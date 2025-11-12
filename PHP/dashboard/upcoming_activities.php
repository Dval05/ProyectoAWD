<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$now = date('Y-m-d');
$res = $conn->query("SELECT Name, ScheduledDate, Status, Category
  FROM activity WHERE ScheduledDate>='$now'
  ORDER BY ScheduledDate ASC LIMIT 10");
$data = [];
while($row = $res->fetch_assoc()) $data[] = $row;
echo json_encode(["success"=>true, "data"=>$data]);
$conn->close();
?>
