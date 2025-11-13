<?php
header('Content-Type: application/json');
ini_set('display_errors', 1);
error_reporting(E_ALL);

require_once('../config/database.php');
require_once('../config/security.php');
require_once('../middleware/auth_middleware.php');
session_start();

$today = date('Y-m-d');
$sql = "SELECT ActivityID, Name, Description, ScheduledDate, Status, Category
        FROM activity
        WHERE ScheduledDate >= ?
        ORDER BY ScheduledDate ASC, ActivityID DESC
        LIMIT 10";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $today);
$stmt->execute();
$res = $stmt->get_result();

$upcoming = [];
while($row = $res->fetch_assoc()) $upcoming[] = $row;
echo json_encode(['success'=>true, 'upcoming'=>$upcoming]);
$stmt->close();
$conn->close();
