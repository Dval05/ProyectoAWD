<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$data = json_decode(file_get_contents("php://input"), true);

if(
  empty($data['StudentID']) ||
  empty($data['EmpID']) ||
  empty($data['ObservationDate']) ||
  empty($data['Category']) ||
  empty($data['Observation'])
){
  echo json_encode(["success"=>false, "message"=>"Faltan datos obligatorios"]);
  exit;
}

$stmt = $conn->prepare("INSERT INTO student_observation (StudentID, EmpID, ObservationDate, Category, Observation, IsPrivate) VALUES (?, ?, ?, ?, ?, ?)");
$stmt->bind_param("iisssi", $data['StudentID'], $data['EmpID'], $data['ObservationDate'], $data['Category'], $data['Observation'], $data['IsPrivate']);
if($stmt->execute()){
  echo json_encode(["success"=>true, "id"=>$conn->insert_id]);
} else {
  echo json_encode(["success"=>false, "message"=>$stmt->error]);
}
$stmt->close();
$conn->close();
?>
