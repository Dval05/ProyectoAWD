<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$month = date('Y-m');
$res = $conn->query("SELECT SUM(TotalAmount) AS revenue FROM invoice WHERE DATE_FORMAT(IssueDate, '%Y-%m')='$month' AND Status IN ('Paid','Issued','Overdue')");
$row = $res->fetch_assoc();
echo json_encode(["success"=>true, "revenue"=>floatval($row['revenue'])]);
$conn->close();
?>
