<?php
/**
 * controller.php
 *
 * Central AJAX endpoint for:
 *  - toggleAssign:   assign/unassign a single event to a judge or technical
 *  - toggleChair:    make/remove a single judge a chairman for an event
 *  - bulkAssign:     assign/unassign **all** events for a judge or technical
 *  - bulkChair:      make/remove chairman for **all** assigned events of a judge
 *
 * Expects POST:
 *  - action:       one of toggleAssign|toggleChair|bulkAssign|bulkChair
 *  - role/judge_id/technical_id, event_id, assigned/chairman, event_ids, bulk_action
 *
 * Returns JSON: { status: 'ok'|'error' }
 */

const LOGIN_PAGE_PATH = './';
require_once '../auth.php';
require_once '../../config/database.php';
require_once '../../models/Judge.php';
require_once '../../models/Technical.php';
require_once '../../models/Event.php';

header('Content-Type: application/json');

$action   = $_POST['action'] ?? '';
$response = ['status'=>'error','message'=>'Invalid action'];

try {
    switch ($action) {
        case 'toggleAssign':
            $response = handleToggleAssign();
            break;
        case 'toggleChair':
            $response = handleToggleChair();
            break;
        case 'bulkAssign':
            $response = handleBulkAssign();
            break;
        case 'bulkChair':
            $response = handleBulkChair();
            break;
        default:
            throw new Exception("Unknown action: $action");
    }

    echo json_encode($response);
    exit;
} catch (Exception $ex) {
    http_response_code(400);
    echo json_encode(['status'=>'error','message'=>$ex->getMessage()]);
    exit;
}

/**
 * Assign or unassign a single event to a judge or technical.
 *
 * POST parameters:
 *  - role:       'judge' or 'technical'
 *  - judge_id    or technical_id
 *  - event_id
 *  - assigned:   'true'|'false'
 *
 * @return array JSON-serializable response
 * @throws Exception
 */
function handleToggleAssign(): array {
    $role     = $_POST['role'];
    $idKey    = $role . '_id';
    $id       = filter_input(INPUT_POST, $idKey, FILTER_VALIDATE_INT)
        ?: throw new Exception("Missing or invalid $idKey");
    $eventId  = filter_input(INPUT_POST, 'event_id', FILTER_VALIDATE_INT)
        ?: throw new Exception("Missing or invalid event_id");
    $assigned = filter_var($_POST['assigned'] ?? '', FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
    if ($assigned === null) {
        throw new Exception("Missing or invalid assigned flag");
    }

    $obj = ($role === 'judge')
        ? Judge::findById($id)
        : Technical::findById($id);
    if (!$obj) throw new Exception("No $role found with ID $id");

    $event = Event::findById($eventId)
        ?: throw new Exception("No event found with ID $eventId");

    if ($assigned) {
        $obj->assignEvent($event);
    } else {
        $obj->removeEvent($event);
    }

    return [
        'status'   => 'ok',
        'type'     => 'assign',
        'role'     => $role,
        'id'       => $id,
        'event'    => $eventId,
        'assigned' => $assigned
    ];
}

/**
 * Make or remove a single judge as chairman of an event.
 *
 * POST parameters:
 *  - judge_id
 *  - event_id
 *  - chairman:  'true'|'false'
 *
 * @return array JSON-serializable response
 * @throws Exception
 */
function handleToggleChair(): array {
    $judgeId  = filter_input(INPUT_POST, 'judge_id', FILTER_VALIDATE_INT)
        ?: throw new Exception("Missing or invalid judge_id");
    $eventId  = filter_input(INPUT_POST, 'event_id', FILTER_VALIDATE_INT)
        ?: throw new Exception("Missing or invalid event_id");
    $chairman = filter_var($_POST['chairman'] ?? '', FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
    if ($chairman === null) {
        throw new Exception("Missing or invalid chairman flag");
    }

    $judge = Judge::findById($judgeId)
        ?: throw new Exception("No judge found with ID $judgeId");
    $event   = Event::findById($eventId)
        ?: throw new Exception("No event found with ID $eventId");

    if ($chairman) {
        $judge->assignChairmanOfEvent($event);
    } else {
        $judge->removeChairmanOfEvent($event);
    }

    return [
        'status'    => 'ok',
        'type'      => 'chair',
        'judge_id'  => $judgeId,
        'event'     => $eventId,
        'chairman'  => $chairman
    ];
}

/**
 * Bulk assign or unassign all events for a judge or technical.
 *
 * POST parameters:
 *  - role:        'judge' or 'technical'
 *  - judge_id     or technical_id
 *  - event_ids:   array of ints
 *  - bulk_action: 'assign'|'unassign'
 *
 * @return array JSON-serializable response
 * @throws Exception
 */
function handleBulkAssign(): array {
    $role       = $_POST['role'] ?? '';
    $idKey      = $role . '_id';
    $id         = filter_input(INPUT_POST, $idKey, FILTER_VALIDATE_INT)
        ?: throw new Exception("Missing or invalid $idKey");
    $eventIds     = $_POST['event_ids'] ?? [];
    if (!is_array($eventIds)) throw new Exception("Missing or invalid event_ids");
    $actionStr  = $_POST['bulk_action'] ?? '';
    $assignAll  = $actionStr === 'assign';

    $obj = ($role === 'judge')
        ? Judge::findById($id)
        : Technical::findById($id);
    if (!$obj) throw new Exception("No $role found with ID $id");

    // loop and assign/unassign
    foreach ($eventIds as $e) {
        $eventId = (int)$e;
        $event = Event::findById($eventId)
            ?: throw new Exception("No event found with ID $eventId");
        if ($assignAll) {
            $obj->assignEvent($event);
        } else {
            $obj->removeEvent($event);
        }
    }

    return [
        'status'     => 'ok',
        'type'       => 'bulkAssign',
        'role'       => $role,
        'id'         => $id,
        'event_ids'  => array_map('intval', $eventIds),
        'assigned'   => $assignAll
    ];
}

/**
 * Bulk make or remove chairman on all currently assigned events of a judge.
 *
 * POST parameters:
 *  - judge_id
 *  - event_ids:   array of ints
 *  - bulk_action: 'chair'|'remove_chair'
 *
 * @return array JSON-serializable response
 * @throws Exception
 */
function handleBulkChair(): array {
    $judgeId    = filter_input(INPUT_POST, 'judge_id', FILTER_VALIDATE_INT)
        ?: throw new Exception("Missing or invalid judge_id");
    $eventIds     = $_POST['event_ids'] ?? [];
    if (!is_array($eventIds)) throw new Exception("Missing or invalid event_ids");
    $actionStr  = $_POST['bulk_action'] ?? '';
    $makeChair  = $actionStr === 'chair';

    $judge = Judge::findById($judgeId)
        ?: throw new Exception("No judge found with ID $judgeId");

    foreach ($eventIds as $e) {
        $eventId = (int)$e;
        $event = Event::findById($eventId)
            ?: throw new Exception("No event found with ID $eventId");
        if ($makeChair) {
            $judge->assignChairmanOfEvent($event);
        } else {
            $judge->removeChairmanOfEvent($event);
        }
    }

    return [
        'status'     => 'ok',
        'type'       => 'bulkChair',
        'judge_id'   => $judgeId,
        'event_ids'  => array_map('intval', $eventIds),
        'chairman'   => $makeChair
    ];
}
