/**
 * index.js
 *
 * Provides interactivity for:
 *  - single assign/unassign toggles
 *  - single chairman toggles
 *  - bulk assign/unassign toggle
 *  - bulk make/remove chairman toggle
 *  - real-time toast feedback
 *  - dynamic updating of the assigned-count badge
 *  - per-row enable/disable of chair checkboxes and tooltip icons
 */
$(function(){

    const $toastContainer = $('#toastContainer');

    // initialize tooltip
    $('[data-bs-toggle="tooltip"]').each(function(){
        new bootstrap.Tooltip(this);
    });
    function showToast(msg, ok = true) {
        const cls = ok ? 'bg-success text-white' : 'bg-danger text-white';
        const tpl = `
      <div class="toast align-items-center ${cls} border-0 mb-2" role="alert" data-bs-delay="2000">
        <div class="d-flex">
          <div class="toast-body">${msg}</div>
          <button type="button" class="btn-close btn-close-white me-2 m-auto"
                  data-bs-dismiss="toast"></button>
        </div>
      </div>`;
        const $t = $(tpl).appendTo($toastContainer);
        new bootstrap.Toast($t[0]).show();
        $t.on('hidden.bs.toast', () => $t.remove());
    }

    function getAssignedEventIds($panel) {
        return $panel.find('input.js-toggle-assign:checked')
            .map((_, cb) => $(cb).data('event'))
            .get();
    }

    /**
     * Refresh the “Assign All / Unassign All” button in a panel:
     * - Shows “Unassign All (total)” if every event is assigned,
     *   else “Assign All (n/total)”
     */
    function refreshBulkAssignButton($panel) {
        const $assignBtn    = $panel.find('.js-bulk-assign');
        const total         = $panel.find('input.js-toggle-assign').length;
        const assignedCount = getAssignedEventIds($panel).length;
        const fullyAssigned = (assignedCount === total);

        const action = fullyAssigned ? 'unassign' : 'assign';
        const label  = fullyAssigned
            ? `Unassign All (${total})`
            : `Assign All (${assignedCount}/${total})`;

        $assignBtn
            .data('action', action)
            .html(`<i class="fa fa-tasks me-1"></i>${label}`);
    }

    /**
     * Refresh the “Make/Remove All Chairman” button in a judge panel:
     * - Shows “Remove All Chairman (c/total)” if any chair checked,
     *   else “Make All Chairman (0/total)”
     */
    function refreshBulkChairButton($panel) {
        const $chairBtn  = $panel.find('.js-bulk-chair');
        const assignedIds = getAssignedEventIds($panel);
        const assignedCount = assignedIds.length;

        let chairCount = 0;
        assignedIds.forEach(id => {
            if ($panel.find(`input.js-toggle-chair[data-event=${id}]`).prop('checked')) {
                chairCount++;
            }
        });

        if (assignedCount === 0) {
            $chairBtn
                .prop('disabled', true)
                .data('action', 'chair')
                .html(`<i class="fa fa-user-shield me-1"></i>Make All Chairman (0/0)`);
        } else if (chairCount > 0) {
            $chairBtn
                .prop('disabled', false)
                .data('action', 'remove_chair')
                .html(`<i class="fa fa-user-shield me-1"></i>Remove All Chairman (${chairCount}/${assignedCount})`);
        } else {
            $chairBtn
                .prop('disabled', false)
                .data('action', 'chair')
                .html(`<i class="fa fa-user-shield me-1"></i>Make All Chairman (0/${assignedCount})`);
        }
    }

    /**
     * Update the badge in the accordion header that shows assigned-count.
     * role: 'judge' or 'technical'
     * ownerId: numeric ID of judge or technical
     */
    function updateAssignedBadge(role, ownerId) {
        // Find the accordion header button for this panel
        let selector;
        if (role === 'judge') {
            selector = `button[data-bs-target="#collapseJ${ownerId}"]`;
        } else {
            selector = `button[data-bs-target="#collapseT${ownerId}"]`;
        }
        const $btn = $(selector);
        if ($btn.length === 0) return;

        const $badge = $btn.find('.js-assigned-badge');
        if ($badge.length === 0) return;

        const panelSelector = role === 'judge'
            ? `#collapseJ${ownerId}`
            : `#collapseT${ownerId}`;
        const $panel = $(panelSelector);
        if ($panel.length === 0) return;

        const assignedCount = getAssignedEventIds($panel).length;

        if (assignedCount === 0) {
            $badge
                .removeClass('bg-primary')
                .addClass('bg-secondary')
                .text('No events');
        } else {
            $badge
                .removeClass('bg-secondary')
                .addClass('bg-primary')
                .text(`${assignedCount} events`);
        }
    }

    /**
     * Enable or disable a specific row's chairman checkbox and tooltip icon.
     * $row: jQuery object for <tr>
     * assigned: boolean; true if event is now assigned
     */
    function updateChairRow($row, assigned) {
        const $chairCb = $row.find('input.js-toggle-chair');
        const $icon    = $row.find('.js-chair-tooltip');

        if (assigned) {
            $chairCb.prop('disabled', false);
            $icon.each((_, el) => {
                const inst = bootstrap.Tooltip.getInstance(el);
                if (inst) inst.dispose();
                $(el).hide();
            });
        } else {
            $chairCb.prop('disabled', true).prop('checked', false);
            $icon.each((_, el) => {
                $(el).show();
                const prev = bootstrap.Tooltip.getInstance(el);
                if (prev) prev.dispose();
                new bootstrap.Tooltip(el);
            });
        }
    }

    // Single assign/unassign
    $(document).on('change', '.js-toggle-assign', function(){
        const $cb      = $(this);
        const role     = $cb.data('role');
        const idKey    = role === 'judge' ? 'judge_id' : 'tech_id';
        const owner    = $cb.data(role);
        const eventId  = $cb.data('event');
        const assigned = $cb.is(':checked');
        const panelSel = role === 'judge' ? `#collapseJ${owner}` : `#collapseT${owner}`;
        const $panel   = $(panelSel);
        const eventName = $cb.closest('tr').find('td').first().text();

        $.post('controller.php', {
            action:       'toggleAssign',
            role:         role,
            [idKey]:      owner,
            event_id:     eventId,
            assigned:     assigned
        }, resp => {
            if (resp.status === 'ok') {
                showToast(`${eventName} ${assigned ? 'assigned to' : 'unassigned from'} ${role} ${owner}`);
                refreshBulkAssignButton($panel);
                updateAssignedBadge(role, owner);

                if (role === 'judge') {
                    const $row = $cb.closest('tr');
                    updateChairRow($row, assigned);
                    refreshBulkChairButton($panel);
                }
            } else {
                showToast(resp.message, false);
                $cb.prop('checked', !assigned);
            }
        }, 'json').fail(() => {
            showToast('Network or server error', false);
            $cb.prop('checked', !assigned);
        });
    });

    // Single chairman toggle
    $(document).on('change', '.js-toggle-chair', function(){
        const $cb      = $(this);
        const judgeId  = $cb.data('judge');
        const eventId  = $cb.data('event');
        const isChair  = $cb.is(':checked');
        const $panel   = $(`#collapseJ${judgeId}`);
        const eventName = $cb.closest('tr').find('td').first().text();

        $.post('controller.php', {
            action:    'toggleChair',
            judge_id:  judgeId,
            event_id:  eventId,
            chairman:  isChair
        }, resp => {
            if (resp.status === 'ok') {
                showToast(`${eventName} ${isChair ? 'made chairman for' : 'removed chairman from'} judge ${judgeId}`);
                refreshBulkChairButton($panel);
            } else {
                showToast(resp.message, false);
                $cb.prop('checked', !isChair);
            }
        }, 'json').fail(() => {
            showToast('Network or server error', false);
            $cb.prop('checked', !isChair);
        });
    });

    // Bulk assign/unassign toggle
    $(document).on('click', '.js-bulk-assign', function(){
        const $btn    = $(this);
        const role    = $btn.data('role');
        const idKey   = role === 'judge' ? 'judge_id' : 'tech_id';
        const owner   = $btn.data('id');
        const action  = $btn.data('action');
        const $panel  = role === 'judge' ? $(`#collapseJ${owner}`) : $(`#collapseT${owner}`);

        const allIds = $panel.find('input.js-toggle-assign')
            .map((_, cb) => $(cb).data('event'))
            .get();

        $.post('controller.php', {
            action:      'bulkAssign',
            role:        role,
            [idKey]:     owner,
            event_ids:   allIds,
            bulk_action: action
        }, resp => {
            if (resp.status === 'ok') {
                const nowAssigned = (action === 'assign');
                $panel.find('input.js-toggle-assign').each((_, el) => {
                    const $el = $(el);
                    $el.prop('checked', nowAssigned);
                });
                refreshBulkAssignButton($panel);
                updateAssignedBadge(role, owner);

                if (role === 'judge') {
                    $panel.find('tbody tr').each((_, rowEl) => {
                        const $row = $(rowEl);
                        updateChairRow($row, nowAssigned);
                    });
                    refreshBulkChairButton($panel);
                }

                showToast(`${role.charAt(0).toUpperCase()+role.slice(1)} ${owner}: ${nowAssigned ? 'Assigned all' : 'Unassigned all'}`);
            } else {
                showToast(resp.message, false);
            }
        }, 'json').fail(() => {
            showToast('Network or server error', false);
        });
    });

    // Bulk make/remove chairman toggle
    $(document).on('click', '.js-bulk-chair', function(){
        const $btn       = $(this);
        const judgeId    = $btn.data('id');
        const action     = $btn.data('action');
        const shouldChair= (action === 'chair');
        const $panel     = $(`#collapseJ${judgeId}`);
        const assignedIds= getAssignedEventIds($panel);

        $.post('controller.php', {
            action:      'bulkChair',
            judge_id:    judgeId,
            event_ids:   assignedIds,
            bulk_action: action
        }, resp => {
            if (resp.status === 'ok') {
                $panel.find('input.js-toggle-chair').each((_, el) => {
                    const $cb  = $(el);
                    const eid  = $cb.data('event');
                    if (assignedIds.includes(eid)) {
                        $cb.prop('checked', shouldChair);
                    }
                });
                refreshBulkChairButton($panel);
                showToast(`Judge ${judgeId}: ${shouldChair ? 'All made chairman' : 'All chairman removed'}`);
            } else {
                showToast(resp.message, false);
            }
        }, 'json').fail(() => {
            showToast('Network or server error', false);
        });
    });
});
