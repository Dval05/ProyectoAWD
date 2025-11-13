<?php
header('Content-Type: application/json; charset=utf-8');

$configPath = __DIR__ . '/../config/database.php';
if (!file_exists($configPath)) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Missing config file']);
    exit;
}
require_once $configPath;

try {
    $gradeId = $_GET['gradeId'] ?? null;
    $date = $_GET['date'] ?? null;
    if (!$gradeId || !$date) {
        echo json_encode(['success' => false, 'message' => 'gradeId and date required']);
        exit;
    }

    // Return attendance rows joined with student info
    if (isset($conn) && $conn instanceof mysqli) {
        $sql = "SELECT a.AttendanceID, a.StudentID, s.FirstName, s.LastName, a.CheckInTime, a.CheckOutTime, a.Status, a.IsLate, a.LateMinutes, a.Notes FROM attendance a JOIN student s ON a.StudentID = s.StudentID WHERE s.GradeID = ? AND a.Date = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('is', $gradeId, $date);
        $stmt->execute();
        $res = $stmt->get_result();
        $rows = [];
        while ($r = $res->fetch_assoc()) $rows[] = $r;
        echo json_encode(['success'=>true,'data'=>$rows]);
        exit;
    }

    if (isset($pdo) && $pdo instanceof PDO) {
        $sql = "SELECT a.AttendanceID, a.StudentID, s.FirstName, s.LastName, a.CheckInTime, a.CheckOutTime, a.Status, a.IsLate, a.LateMinutes, a.Notes FROM attendance a JOIN student s ON a.StudentID = s.StudentID WHERE s.GradeID = ? AND a.Date = ?";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$gradeId, $date]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['success'=>true,'data'=>$rows]);
        exit;
    }

    if (class_exists('Database')) {
        $db = Database::getInstance()->getConnection();
        $stmt = $db->prepare("SELECT a.AttendanceID, a.StudentID, s.FirstName, s.LastName, a.CheckInTime, a.CheckOutTime, a.Status, a.IsLate, a.LateMinutes, a.Notes FROM attendance a JOIN student s ON a.StudentID = s.StudentID WHERE s.GradeID = ? AND a.Date = ?");
        $stmt->execute([$gradeId, $date]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['success'=>true,'data'=>$rows]);
        exit;
    }

    throw new Exception('No DB connection');

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success'=>false,'message'=>$e->getMessage()]);
    exit;
}

?>
