<?php
header('Content-Type: application/json');
ini_set('display_errors', 1);
error_reporting(E_ALL);

require_once('../config/database.php');
require_once('../config/security.php');
require_once('../middleware/auth_middleware.php');
session_start();

$past = date('Y-m-d', strtotime('-7 days'));
$sql = "SELECT ActivityID, Name, Description, ScheduledDate, Status, Category
        FROM activity
        WHERE ScheduledDate BETWEEN ? AND CURDATE()
        ORDER BY ScheduledDate DESC, ActivityID DESC
        LIMIT 10";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $past);
$stmt->execute();
$res = $stmt->get_result();

$recent = [];
while($row = $res->fetch_assoc()) $recent[] = $row;
echo json_encode(['success'=>true, 'recent'=>$recent]);
$stmt->close();
$conn->close();
