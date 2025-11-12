<?php
header('Content-Type: application/json');
require_once "../config/database.php";
$data = json_decode(file_get_contents("php://input"), true);
$sql = "UPDATE guardian SET FirstName=?,LastName=?,DocumentNumber=?,Relationship=?,PhoneNumber=?,Email=?,Address=?,Occupation=?,WorkPhone=?,IsEmergencyContact=?,IsAuthorizedPickup=? WHERE GuardianID=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssssssssiiii",
  $data['FirstName'], $data['LastName'], $data['DocumentNumber'], $data['Relationship'],
  $data['PhoneNumber'], $data['Email'], $data['Address'], $data['Occupation'],
  $data['WorkPhone'], $data['IsEmergencyContact'], $data['IsAuthorizedPickup'],
  $data['GuardianID']
);
$res = $stmt->execute();
echo json_encode(["success"=>$res]);
$conn->close();
?>
