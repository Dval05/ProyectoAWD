<?php
header('Content-Type: application/json; charset=utf-8');

$configPath = __DIR__ . '/../config/database.php';
if (!file_exists($configPath)) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Missing config file']);
    exit;
}
require_once $configPath;

$raw = file_get_contents('php://input');
$data = json_decode($raw, true);
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Invalid JSON']);
    exit;
}

try {
    $studentId = isset($data['StudentID']) ? (int)$data['StudentID'] : null;
    $date = $data['Date'] ?? null;
    if (!$studentId || !$date) throw new Exception('StudentID and Date are required');

    $checkIn = $data['CheckInTime'] ?? null;
    $checkOut = $data['CheckOutTime'] ?? null;
    $status = $data['Status'] ?? 'Present';
    $isLate = isset($data['IsLate']) ? (int)$data['IsLate'] : 0;
    $lateMinutes = isset($data['LateMinutes']) ? (int)$data['LateMinutes'] : 0;
    $notes = $data['Notes'] ?? null;
    $checkedInBy = isset($data['CheckedInBy']) ? (int)$data['CheckedInBy'] : null;
    $checkedOutBy = isset($data['CheckedOutBy']) ? (int)$data['CheckedOutBy'] : null;

    // Use mysqli if available
    if (isset($conn) && $conn instanceof mysqli) {
        $sql = "INSERT INTO attendance (StudentID, Date, CheckInTime, CheckOutTime, Status, IsLate, LateMinutes, Notes, CheckedInBy, CheckedOutBy, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW()) ON DUPLICATE KEY UPDATE CheckInTime=VALUES(CheckInTime), CheckOutTime=VALUES(CheckOutTime), Status=VALUES(Status), IsLate=VALUES(IsLate), LateMinutes=VALUES(LateMinutes), Notes=VALUES(Notes), CheckedInBy=VALUES(CheckedInBy), CheckedOutBy=VALUES(CheckedOutBy), UpdatedAt=NOW()";
        $stmt = $conn->prepare($sql);
    // bind types: i StudentID, s Date, s CheckIn, s CheckOut, s Status, i IsLate, i LateMinutes, s Notes, i CheckedInBy, i CheckedOutBy
    $stmt->bind_param('issssiisii', $studentId, $date, $checkIn, $checkOut, $status, $isLate, $lateMinutes, $notes, $checkedInBy, $checkedOutBy);
        if (!$stmt->execute()) throw new Exception('DB Error: ' . $stmt->error);
        // retrieve AttendanceID
        $sel = $conn->prepare("SELECT AttendanceID FROM attendance WHERE StudentID = ? AND Date = ? LIMIT 1");
        $sel->bind_param('is', $studentId, $date);
        $sel->execute();
        $res = $sel->get_result();
        $aid = null;
        if ($r = $res->fetch_assoc()) $aid = (int)$r['AttendanceID'];
        echo json_encode(['success' => true, 'AttendanceID' => $aid]);
        exit;
    }

    // Try PDO
    if (isset($pdo) && $pdo instanceof PDO) {
        $sql = "INSERT INTO attendance (StudentID, Date, CheckInTime, CheckOutTime, Status, IsLate, LateMinutes, Notes, CheckedInBy, CheckedOutBy, CreatedAt, UpdatedAt) VALUES (:sid, :date, :ci, :co, :st, :il, :lm, :n, :cib, :cob, NOW(), NOW()) ON DUPLICATE KEY UPDATE CheckInTime=VALUES(CheckInTime), CheckOutTime=VALUES(CheckOutTime), Status=VALUES(Status), IsLate=VALUES(IsLate), LateMinutes=VALUES(LateMinutes), Notes=VALUES(Notes), CheckedInBy=VALUES(CheckedInBy), CheckedOutBy=VALUES(CheckedOutBy), UpdatedAt=NOW()";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([':sid'=>$studentId, ':date'=>$date, ':ci'=>$checkIn, ':co'=>$checkOut, ':st'=>$status, ':il'=>$isLate, ':lm'=>$lateMinutes, ':n'=>$notes, ':cib'=>$checkedInBy, ':cob'=>$checkedOutBy]);
        $sel = $pdo->prepare("SELECT AttendanceID FROM attendance WHERE StudentID = ? AND Date = ? LIMIT 1");
        $sel->execute([$studentId, $date]);
        $r = $sel->fetch(PDO::FETCH_ASSOC);
        $aid = $r ? (int)$r['AttendanceID'] : null;
        echo json_encode(['success' => true, 'AttendanceID' => $aid]);
        exit;
    }

    // Try Database singleton with PDO
    if (class_exists('Database')) {
        $db = Database::getInstance()->getConnection();
        $sql = "INSERT INTO attendance (StudentID, Date, CheckInTime, CheckOutTime, Status, IsLate, LateMinutes, Notes, CheckedInBy, CheckedOutBy, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW()) ON DUPLICATE KEY UPDATE CheckInTime=VALUES(CheckInTime), CheckOutTime=VALUES(CheckOutTime), Status=VALUES(Status), IsLate=VALUES(IsLate), LateMinutes=VALUES(LateMinutes), Notes=VALUES(Notes), CheckedInBy=VALUES(CheckedInBy), CheckedOutBy=VALUES(CheckedOutBy), UpdatedAt=NOW()";
        $stmt = $db->prepare($sql);
        $stmt->execute([$studentId, $date, $checkIn, $checkOut, $status, $isLate, $lateMinutes, $notes, $checkedInBy, $checkedOutBy]);
        $sel = $db->prepare("SELECT AttendanceID FROM attendance WHERE StudentID = ? AND Date = ? LIMIT 1");
        $sel->execute([$studentId, $date]);
        $r = $sel->fetch(PDO::FETCH_ASSOC);
        $aid = $r ? (int)$r['AttendanceID'] : null;
        echo json_encode(['success' => true, 'AttendanceID' => $aid]);
        exit;
    }

    throw new Exception('No DB connection available');

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
    exit;
}

?>
