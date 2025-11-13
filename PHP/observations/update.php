<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$data = json_decode(file_get_contents("php://input"), true);

if(empty($data['ObservationID']) || empty($data['Observation'])){
  echo json_encode(["success"=>false, "message"=>"Faltan datos obligatorios"]);
  exit;
}
$stmt = $conn->prepare("UPDATE student_observation SET Category=?, Observation=?, IsPrivate=? WHERE ObservationID=?");
$stmt->bind_param("ssii", $data['Category'], $data['Observation'], $data['IsPrivate'], $data['ObservationID']);
if($stmt->execute()){
  echo json_encode(["success"=>true]);
} else {
  echo json_encode(["success"=>false, "message"=>$stmt->error]);
}
$stmt->close();
$conn->close();
?>
