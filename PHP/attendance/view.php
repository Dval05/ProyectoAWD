<?php
header('Content-Type: application/json; charset=utf-8');

$configPath = __DIR__ . '/../config/database.php';
if (!file_exists($configPath)) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Missing config file']);
    exit;
}
require_once $configPath;

$gradeId = isset($_GET['gradeId']) && $_GET['gradeId']!=='' ? (int)$_GET['gradeId'] : null;
$startDate = $_GET['startDate'] ?? null;
$endDate = $_GET['endDate'] ?? null;

try {
    // default to last 30 days if dates not provided
    if (!$startDate || !$endDate) {
        $end = new DateTime();
        $start = (new DateTime())->modify('-30 days');
        $startDate = $start->format('Y-m-d');
        $endDate = $end->format('Y-m-d');
    }

    $params = [];
    $where = "WHERE a.Date BETWEEN ? AND ?";
    $params[] = $startDate;
    $params[] = $endDate;
    if ($gradeId) {
        $where .= " AND s.GradeID = ?";
        $params[] = $gradeId;
    }

    $sql = "SELECT a.AttendanceID, a.StudentID, s.FirstName, s.LastName, s.GradeID, g.GradeName, a.Date, a.CheckInTime, a.CheckOutTime, a.Status, a.IsLate, a.LateMinutes, a.Notes, a.CheckedInBy, a.CheckedOutBy, a.CreatedAt, a.UpdatedAt
            FROM attendance a
            JOIN student s ON a.StudentID = s.StudentID
            LEFT JOIN grade g ON s.GradeID = g.GradeID
            $where
            ORDER BY a.Date DESC, g.GradeName, s.LastName, s.FirstName";

    // Try mysqli
    if (isset($conn) && $conn instanceof mysqli) {
        $stmt = $conn->prepare($sql);
        // bind dynamically
        if ($gradeId) {
            $stmt->bind_param('ssi', $params[0], $params[1], $params[2]);
        } else {
            $stmt->bind_param('ss', $params[0], $params[1]);
        }
        $stmt->execute();
        $res = $stmt->get_result();
        $rows = [];
        while ($r = $res->fetch_assoc()) $rows[] = $r;
        echo json_encode($rows);
        exit;
    }

    // Try PDO
    if (isset($pdo) && $pdo instanceof PDO) {
        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($rows);
        exit;
    }

    // Database singleton
    if (class_exists('Database')) {
        $db = Database::getInstance()->getConnection();
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($rows);
        exit;
    }

    throw new Exception('No DB connection available');

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success'=>false,'message'=>$e->getMessage()]);
    exit;
}

?>
