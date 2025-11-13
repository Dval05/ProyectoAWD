<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$res = $conn->query("SELECT EmpID, FirstName, LastName FROM employee WHERE IsActive=1");
$data = [];
while($row = $res->fetch_assoc()) $data[] = $row;
echo json_encode(["success"=>true,"data"=>$data]);
$conn->close();
?>
