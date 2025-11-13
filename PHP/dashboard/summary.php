<?php
header('Content-Type: application/json');
ini_set('display_errors', 1);
error_reporting(E_ALL);

require_once('../config/database.php');
require_once('../config/security.php');
require_once('../middleware/auth_middleware.php');
session_start();

// Total estudiantes activos
$students = $conn->query("SELECT COUNT(*) AS total FROM student WHERE Status = 'Active'")->fetch_assoc()['total'];

// Total personal activo
$teachers = $conn->query("SELECT COUNT(*) AS total FROM teacher WHERE Status = 'Active'")->fetch_assoc()['total'];

// Porcentaje asistencia de hoy
$today = date('Y-m-d');
$row = $conn->query("SELECT SUM(CASE WHEN Status='Present' THEN 1 ELSE 0 END) AS present, COUNT(*) AS total 
                     FROM attendance WHERE Date='$today'")->fetch_assoc();
$attendancePercent = $row['total'] > 0 ? round($row['present']*100/$row['total']) : 0;

// Ingresos del mes actual
$month = date('Y-m');
$row = $conn->query("SELECT SUM(PaidAmount) AS income FROM student_payment 
                     WHERE Status='Paid' AND LEFT(PaymentDate,7)='$month'")->fetch_assoc();
$monthlyRevenue = $row['income'] ? floatval($row['income']) : 0.00;

echo json_encode([
    'success' => true,
    'students' => intval($students),
    'teachers' => intval($teachers),
    'attendance' => $attendancePercent,
    'revenue' => $monthlyRevenue,
]);
$conn->close();
