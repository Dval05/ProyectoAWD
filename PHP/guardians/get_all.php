<?php
header('Content-Type: application/json');
require_once "../config/database.php";
$res = $conn->query("SELECT * FROM guardian");
$data = [];
while($row = $res->fetch_assoc()) $data[] = $row;
echo json_encode(["success"=>true,"data"=>$data]);
$conn->close();
?>
