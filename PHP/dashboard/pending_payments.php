<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$res = $conn->query("SELECT s.FirstName, s.LastName, sp.TotalAmount, sp.DueDate 
  FROM student_payment sp
  JOIN student s ON s.StudentID=sp.StudentID
  WHERE sp.Status='Pending' OR sp.Status='Overdue'
  ORDER BY sp.DueDate ASC LIMIT 10");
$data = [];
while($row = $res->fetch_assoc()) $data[] = $row;
echo json_encode(["success"=>true, "data"=>$data]);
$conn->close();
?>
