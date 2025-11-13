<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$res = $conn->query("SELECT Name, ScheduledDate, Category, Status FROM activity ORDER BY ScheduledDate DESC LIMIT 5");
$data = [];
while($row = $res->fetch_assoc()) $data[] = $row;
echo json_encode(["success"=>true,"data"=>$data]);
$conn->close();
?>
