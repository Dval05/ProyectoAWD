<?php
header('Content-Type: application/json');
ini_set('display_errors', 1);
error_reporting(E_ALL);

require_once('../config/database.php');
require_once('../config/security.php');
require_once('../middleware/auth_middleware.php');
session_start();
// $conn ya está disponible por database.php

$today = date('Y-m-d');
$startDate = date('Y-m-d', strtotime('-6 days'));

$sql = "SELECT Date, 
               SUM(CASE WHEN Status = 'Present' THEN 1 ELSE 0 END) AS Present,
               SUM(CASE WHEN Status = 'Absent' THEN 1 ELSE 0 END) AS Absent,
               COUNT(*) as Total
        FROM attendance
        WHERE Date BETWEEN ? AND ?
        GROUP BY Date
        ORDER BY Date";
$stmt = $conn->prepare($sql);
$stmt->bind_param('ss', $startDate, $today);
$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = [
        'date' => $row['Date'],
        'present' => (int)$row['Present'],
        'absent' => (int)$row['Absent'],
        'total' => (int)$row['Total']
    ];
}
echo json_encode(['success'=>true, 'data'=>$data]);
$stmt->close();
$conn->close();
