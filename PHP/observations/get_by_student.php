<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$stid = isset($_GET['StudentID']) ? intval($_GET['StudentID']) : 0;
$sql = "SELECT * FROM student_observation WHERE StudentID = ? ORDER BY ObservationDate DESC, ObservationID DESC";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $stid);
$stmt->execute();
$res = $stmt->get_result();
$data = [];
while($row = $res->fetch_assoc()) $data[] = $row;
echo json_encode(["success"=>true, "data"=>$data]);
$stmt->close();
$conn->close();
?>
