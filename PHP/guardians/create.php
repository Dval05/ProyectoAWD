<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json');
require_once "../config/database.php";
$data = json_decode(file_get_contents("php://input"), true);

$sql = "INSERT INTO guardian (FirstName,LastName,DocumentNumber,Relationship,PhoneNumber,Email,Address,Occupation,WorkPhone,IsEmergencyContact,IsAuthorizedPickup)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);

// Haz null para campos vacíos opcionales
foreach (['DocumentNumber','Relationship','PhoneNumber','Email','Address','Occupation','WorkPhone'] as $f) {
  if(isset($data[$f]) && $data[$f]==="") $data[$f] = null;
}

$stmt->bind_param(
  "ssssssssiii",
  $data['FirstName'], $data['LastName'], $data['DocumentNumber'], $data['Relationship'],
  $data['PhoneNumber'], $data['Email'], $data['Address'], $data['Occupation'], $data['WorkPhone'],
  $data['IsEmergencyContact'], $data['IsAuthorizedPickup']
);

$res = $stmt->execute();

if($res){
    echo json_encode(["success"=>true,"GuardianID"=>$stmt->insert_id]);
}else{
    echo json_encode(["success"=>false,"message"=>$stmt->error, "sql"=>$sql, "params"=>$data]);
}
$conn->close();
?>
