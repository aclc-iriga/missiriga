<?php
/**
 * index.php
 *
 * Displays Judges and Technical panels with:
 *  - per-event assign/unassign checkboxes
 *  - per-event chairman toggles for judges only
 *  - bulk operations: Toggle All Assigned / Toggle All Chairman
 *
 * Uses Bootstrap accordion + tabs and jQuery for AJAX updates.
 */

const LOGIN_PAGE_PATH = './';
require_once '../auth.php';
require_once '../../config/database.php';
require_once '../../models/Judge.php';
require_once '../../models/Technical.php';
require_once '../../models/Event.php';

$judges     = Judge::all();
$technicals = Technical::all();
$events     = Event::all();
$totalEvents = count($events);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Judge & Technical Event Assignment</title>
    <link rel="stylesheet" href="./../dist/bootstrap-5.2.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="./../dist/fontawesome-6.3.0/css/all.min.css">
    <style>
        .form-check-input:disabled {
            opacity: 0.4 !important;
            cursor: not-allowed;
        }
        .form-check-input:not(:disabled) {
            box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
            transition: box-shadow 0.2s ease;
        }
        .form-check-input:not(:disabled):hover,
        .form-check-input:not(:disabled):focus {
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.5);
        }
        .muted-row {
            color: #6c757d; /* Bootstrap text-secondary */
        }
        .muted-cell {
            background-color: #f8f9fa; /* light grey */
        }
        .js-chair-tooltip {
            cursor: help;
        }
    </style>
</head>
<body class="bg-light">
<div class="container py-4">
    <h1 class="mb-4 text-primary">
        <i class="fa fa-tasks me-2"></i>Judge & Technical Event Assignment
    </h1>
    <!-- Toast container -->
    <div class="position-fixed top-0 end-0 p-3" style="z-index:1055">
        <div id="toastContainer"></div>
    </div>
    <!-- Tabs -->
    <ul class="nav nav-tabs mb-3">
        <li class="nav-item">
            <a class="nav-link active" data-bs-toggle="tab" href="#judges">
                <i class="fa fa-gavel me-1"></i>Judges
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-bs-toggle="tab" href="#technical">
                <i class="fa fa-cogs me-1"></i>Technical
            </a>
        </li>
    </ul>
    <div class="tab-content">
        <!-- Judges Panel -->
        <div class="tab-pane fade show active" id="judges">
            <div class="accordion" id="judgesAccordion">
                <?php foreach ($judges as $judge):
                    $assignedEvents = $judge->getAllEvents();
                    $assignedIds   = array_map(fn($e)=>$e->getId(), $assignedEvents);
                    $assignedCount = count($assignedIds);
                    $chairCount    = 0;
                    foreach ($assignedIds as $eid) {
                        if ($judge->isChairmanOfEvent(Event::findById($eid))) {
                            $chairCount++;
                        }
                    }
                    if ($assignedCount === $totalEvents) {
                        $assignLabel  = "Unassign All ({$totalEvents})";
                        $assignAction = 'unassign';
                    } else {
                        $assignLabel  = "Assign All ({$assignedCount}/{$totalEvents})";
                        $assignAction = 'assign';
                    }
                    if ($assignedCount === 0) {
                        $chairLabel    = "Make All Chairman (0/0)";
                        $chairAction   = 'chair';
                        $chairDisabled = true;
                    } else {
                        if ($chairCount > 0) {
                            $chairLabel  = "Remove All Chairman ({$chairCount}/{$assignedCount})";
                            $chairAction = 'remove_chair';
                        } else {
                            $chairLabel  = "Make All Chairman (0/{$assignedCount})";
                            $chairAction = 'chair';
                        }
                        $chairDisabled = false;
                    }
                    ?>
                    <div class="accordion-item mb-2 shadow-sm">
                        <h2 class="accordion-header">
                            <?php
                            if ($assignedCount === 0) {
                                $badgeHtml = '<span class="badge bg-secondary ms-2 js-assigned-badge">No events</span>';
                            } else {
                                $badgeHtml = "<span class=\"badge bg-primary ms-2 js-assigned-badge\">{$assignedCount} events</span>";
                            }
                            ?>
                            <button class="accordion-button collapsed bg-white text-dark"
                                    data-bs-toggle="collapse"
                                    data-bs-target="#collapseJ<?= $judge->getId() ?>">
                                <i class="fa fa-user me-2"></i><?= htmlspecialchars($judge->getName()) ?>
                                <?= $badgeHtml ?>
                            </button>
                        </h2>
                        <div id="collapseJ<?= $judge->getId() ?>"
                             class="accordion-collapse collapse"
                             data-bs-parent="#judgesAccordion">
                            <div class="accordion-body">
                                <!-- Bulk toggles -->
                                <div class="mb-3">
                                    <button class="btn btn-sm btn-outline-secondary me-2 js-bulk-assign"
                                            data-role="judge"
                                            data-id="<?= $judge->getId() ?>"
                                            data-action="<?= $assignAction ?>">
                                        <i class="fa fa-tasks me-1"></i><?= $assignLabel ?>
                                    </button>
                                    <button class="btn btn-sm btn-outline-primary js-bulk-chair"
                                            data-id="<?= $judge->getId() ?>"
                                            data-action="<?= $chairAction ?>"
                                        <?= $chairDisabled ? 'disabled' : '' ?>>
                                        <i class="fa fa-user-shield me-1"></i><?= $chairLabel ?>
                                    </button>
                                </div>
                                <!-- Events table -->
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th><i class="fa fa-calendar me-1"></i>Event</th>
                                        <th class="text-center"><i class="fa fa-check-square me-1"></i>Assigned</th>
                                        <th class="text-center"><i class="fa fa-user-shield me-1"></i>Chairman</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <?php foreach ($events as $evt):
                                        $isAssigned = in_array($evt->getId(), $assignedIds);
                                        $isChair    = $isAssigned && $judge->isChairmanOfEvent($evt);

                                        $rowClass = '';
                                        if (!$isAssigned) {
                                            $rowClass = 'muted-row';
                                        }
                                        $chairCellClass = 'text-center';
                                        if (!$isAssigned) {
                                            $chairCellClass .= ' muted-cell';
                                        }
                                        ?>
                                        <tr class="<?= $rowClass ?>">
                                            <td><?= htmlspecialchars($evt->getTitle()) ?></td>
                                            <td class="text-center">
                                                <input type="checkbox"
                                                       class="form-check-input js-toggle-assign"
                                                       data-role="judge"
                                                       data-judge="<?= $judge->getId() ?>"
                                                       data-event="<?= $evt->getId() ?>"
                                                    <?= $isAssigned ? 'checked' : '' ?>>
                                            </td>
                                            <td class="<?= $chairCellClass ?>">
                                                <div class="d-flex align-items-center justify-content-center">
                                                    <input type="checkbox"
                                                           class="form-check-input js-toggle-chair me-1"
                                                           data-judge="<?= $judge->getId() ?>"
                                                           data-event="<?= $evt->getId() ?>"
                                                        <?= $isChair ? 'checked' : '' ?>
                                                        <?= $isAssigned ? '' : 'disabled' ?>>
                                                    <i class="fa fa-info-circle text-muted js-chair-tooltip"
                                                       data-bs-toggle="tooltip"
                                                       title="Assign event first to enable chairman"
                                                       style="<?= $isAssigned ? 'display:none;' : 'display:inline-block;' ?>"></i>
                                                </div>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
        <!-- Technical Panel -->
        <div class="tab-pane fade" id="technical">
            <div class="accordion" id="techAccordion">
                <?php foreach ($technicals as $tech):
                    $assignedEvents = $tech->getAllEvents();
                    $assignedIds   = array_map(fn($e)=>$e->getId(), $assignedEvents);
                    $assignedCount = count($assignedIds);
                    if ($assignedCount === $totalEvents) {
                        $toggleLabel  = "Unassign All ({$totalEvents})";
                        $toggleAction = 'unassign';
                    } else {
                        $toggleLabel  = "Assign All ({$assignedCount}/{$totalEvents})";
                        $toggleAction = 'assign';
                    }
                    ?>
                    <div class="accordion-item mb-2 shadow-sm">
                        <h2 class="accordion-header">
                            <?php
                            if ($assignedCount === 0) {
                                $techBadge = '<span class="badge bg-secondary ms-2 js-assigned-badge">No events</span>';
                            } else {
                                $techBadge = "<span class=\"badge bg-primary ms-2 js-assigned-badge\">{$assignedCount} events</span>";
                            }
                            ?>
                            <button class="accordion-button collapsed bg-white text-dark"
                                    data-bs-toggle="collapse"
                                    data-bs-target="#collapseT<?= $tech->getId() ?>">
                                <i class="fa fa-cog me-2"></i><?= htmlspecialchars($tech->getName()) ?>
                                <?= $techBadge ?>
                            </button>
                        </h2>
                        <div id="collapseT<?= $tech->getId() ?>"
                             class="accordion-collapse collapse"
                             data-bs-parent="#techAccordion">
                            <div class="accordion-body">
                                <!-- Bulk toggle -->
                                <div class="mb-3">
                                    <button class="btn btn-sm btn-outline-secondary js-bulk-assign"
                                            data-role="tech"
                                            data-id="<?= $tech->getId() ?>"
                                            data-action="<?= $toggleAction ?>">
                                        <i class="fa fa-tasks me-1"></i><?= $toggleLabel ?>
                                    </button>
                                </div>
                                <!-- Events table -->
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th><i class="fa fa-calendar me-1"></i>Event</th>
                                        <th class="text-center"><i class="fa fa-check-square me-1"></i>Assigned</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <?php foreach ($events as $evt):
                                        $isAssigned = in_array($evt->getId(), $assignedIds);

                                        $rowClassT = '';
                                        if (!$isAssigned) {
                                            $rowClassT = 'muted-row';
                                        }
                                        ?>
                                        <tr class="<?= $rowClassT ?>">
                                            <td><?= htmlspecialchars($evt->getTitle()) ?></td>
                                            <td class="text-center">
                                                <input type="checkbox"
                                                       class="form-check-input js-toggle-assign"
                                                       data-role="tech"
                                                       data-tech="<?= $tech->getId() ?>"
                                                       data-event="<?= $evt->getId() ?>"
                                                    <?= $isAssigned ? 'checked' : '' ?>>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    </div>
</div>
<script src="./../dist/jquery-3.6.4/jquery-3.6.4.min.js"></script>
<script src="./../dist/bootstrap-5.2.3/js/bootstrap.bundle.min.js"></script>
<script src="index.js"></script>
</body>
</html>
