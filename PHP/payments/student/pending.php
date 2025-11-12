<?php
header('Content-Type: application/json');
ini_set('display_errors', 1);
error_reporting(E_ALL);

require_once('../../config/database.php');
require_once('../../config/security.php');
require_once('../../middleware/auth_middleware.php');
session_start();
// $conn ya está disponible por database.php

$sql = "SELECT sp.StudentPaymentID, s.FirstName, s.LastName, sp.DueDate, sp.TotalAmount, sp.PaidAmount, sp.BalanceRemaining
        FROM student_payment sp
        JOIN student s ON s.StudentID = sp.StudentID
        WHERE sp.Status = 'Pending'
        ORDER BY sp.DueDate ASC";

$result = $conn->query($sql);

$pending = [];
while($row = $result->fetch_assoc()) {
    $pending[] = [
        'paymentId' => $row['StudentPaymentID'],
        'studentName' => $row['FirstName'] . ' ' . $row['LastName'],
        'dueDate' => $row['DueDate'],
        'total' => floatval($row['TotalAmount']),
        'paid' => floatval($row['PaidAmount']),
        'remaining' => floatval($row['BalanceRemaining'])
    ];
}
echo json_encode(['success' => true, 'pending' => $pending]);
$conn->close();
