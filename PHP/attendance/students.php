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
    $date = $_GET['date'] ?? null; // optional YYYY-MM-DD to load existing attendance
    if (!$gradeId) {
        echo json_encode([]);
        exit;
    }

    $students = [];

    // Prefer mysqli connection variable $conn from config
    if (isset($conn) && $conn instanceof mysqli) {
        if ($date) {
            $sql = "SELECT s.StudentID, s.FirstName, s.LastName, a.AttendanceID, a.CheckInTime, a.CheckOutTime, a.Status, a.IsLate, a.LateMinutes, a.Notes, a.CheckedInBy, a.CheckedOutBy FROM student s LEFT JOIN attendance a ON s.StudentID = a.StudentID AND a.Date = ? WHERE s.GradeID = ? AND s.IsActive = 1 ORDER BY s.FirstName, s.LastName";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param('si', $date, $gradeId);
        } else {
            $sql = "SELECT s.StudentID, s.FirstName, s.LastName, NULL AS AttendanceID, NULL AS CheckInTime, NULL AS CheckOutTime, NULL AS Status, NULL AS IsLate, NULL AS LateMinutes, NULL AS Notes, NULL AS CheckedInBy, NULL AS CheckedOutBy FROM student s WHERE s.GradeID = ? AND s.IsActive = 1 ORDER BY s.FirstName, s.LastName";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param('i', $gradeId);
        }
        $stmt->execute();
        $res = $stmt->get_result();
        while ($row = $res->fetch_assoc()) $students[] = $row;
        echo json_encode($students);
        exit;
    }

    // Try PDO if available
    if (isset($pdo) && $pdo instanceof PDO) {
        if ($date) {
            $stmt = $pdo->prepare("SELECT s.StudentID, s.FirstName, s.LastName, a.AttendanceID, a.CheckInTime, a.CheckOutTime, a.Status, a.IsLate, a.LateMinutes, a.Notes, a.CheckedInBy, a.CheckedOutBy FROM student s LEFT JOIN attendance a ON s.StudentID = a.StudentID AND a.Date = ? WHERE s.GradeID = ? AND s.IsActive = 1 ORDER BY s.FirstName, s.LastName");
            $stmt->execute([$date, $gradeId]);
        } else {
            $stmt = $pdo->prepare("SELECT s.StudentID, s.FirstName, s.LastName, NULL AS AttendanceID, NULL AS CheckInTime, NULL AS CheckOutTime, NULL AS Status, NULL AS IsLate, NULL AS LateMinutes, NULL AS Notes, NULL AS CheckedInBy, NULL AS CheckedOutBy FROM student s WHERE s.GradeID = ? AND s.IsActive = 1 ORDER BY s.FirstName, s.LastName");
            $stmt->execute([$gradeId]);
        }
        $students = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($students);
        exit;
    }

    // Try Database singleton if present
    if (class_exists('Database')) {
        $db = Database::getInstance()->getConnection();
        if ($date) {
            $stmt = $db->prepare("SELECT s.StudentID, s.FirstName, s.LastName, a.AttendanceID, a.CheckInTime, a.CheckOutTime, a.Status, a.IsLate, a.LateMinutes, a.Notes, a.CheckedInBy, a.CheckedOutBy FROM student s LEFT JOIN attendance a ON s.StudentID = a.StudentID AND a.Date = ? WHERE s.GradeID = ? AND s.IsActive = 1 ORDER BY s.FirstName, s.LastName");
            $stmt->execute([$date, $gradeId]);
        } else {
            $stmt = $db->prepare("SELECT s.StudentID, s.FirstName, s.LastName, NULL AS AttendanceID, NULL AS CheckInTime, NULL AS CheckOutTime, NULL AS Status, NULL AS IsLate, NULL AS LateMinutes, NULL AS Notes, NULL AS CheckedInBy, NULL AS CheckedOutBy FROM student s WHERE s.GradeID = ? AND s.IsActive = 1 ORDER BY s.FirstName, s.LastName");
            $stmt->execute([$gradeId]);
        }
        $students = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($students);
        exit;
    }

    throw new Exception('No DB connection available');
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
    exit;
}

?>
