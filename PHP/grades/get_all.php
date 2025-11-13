<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$res = $conn->query("SELECT GradeID, GradeName FROM grade ORDER BY GradeID ASC");
$data = [];
while($row = $res->fetch_assoc()) $data[] = $row;
echo json_encode(["success"=>true,"data"=>$data]);
$conn->close();
?>
