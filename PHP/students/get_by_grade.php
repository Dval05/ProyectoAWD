<?php
header('Content-Type: application/json');
require_once "../config/database.php";
$grade = $_GET['grade'];
$res = $conn->query("SELECT * FROM student WHERE GradeID = " . intval($grade) . " AND IsActive=1");
$rows = [];
while($row = $res->fetch_assoc()) $rows[] = $row;
echo json_encode(["success"=>true, "data"=>$rows]);
$conn->close();
?>
