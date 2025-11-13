<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$data = json_decode(file_get_contents("php://input"), true);
$id = $data['ObservationID'] ?? 0;
$stmt = $conn->prepare("DELETE FROM student_observation WHERE ObservationID=?");
$stmt->bind_param("i", $id);
if($stmt->execute()){
  echo json_encode(["success"=>true]);
} else {
  echo json_encode(["success"=>false, "message"=>$stmt->error]);
}
$stmt->close();
$conn->close();
?>
