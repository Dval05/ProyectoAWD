<?php
header('Content-Type: application/json');
require_once "../config/database.php";
$res = $conn->query("SELECT * FROM student WHERE IsActive=1");
$rows = [];
while($row = $res->fetch_assoc()) $rows[] = $row;
echo json_encode(["success"=>true, "data"=>$rows]);
$conn->close();
?>
