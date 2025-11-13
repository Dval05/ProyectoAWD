<?php
header('Content-Type: application/json');
require_once "../config/database.php";
$data = json_decode(file_get_contents("php://input"), true);

if(!isset($data['StudentID']) || intval($data['StudentID']) <= 0){
    echo json_encode(["success"=>false,"message"=>"StudentID requerido o inválido"]);
    exit;
}

$sql = "UPDATE student SET FirstName=?, LastName=?, BirthDate=?, Gender=?, DocumentNumber=?, Address=?, Email=?, PhoneNumber=?, GradeID=?, MedicalInfo=?, EmergencyContact=?, EmergencyPhone=?, IsActive=?, IsRecurrent=?, EnrollmentDate=? WHERE StudentID=?";
$stmt = $conn->prepare($sql);
if(!$stmt){
    echo json_encode(["success"=>false, "message"=>"Error en prepare: ".$conn->error]);
    $conn->close();
    exit;
}
$gradeId = empty($data['GradeID']) ? null : $data['GradeID'];
$stmt->bind_param(
  "ssssssssissssssi",
  $data['FirstName'],
  $data['LastName'],
  $data['BirthDate'],
  $data['Gender'],
  $data['DocumentNumber'],
  $data['Address'],
  $data['Email'],
  $data['PhoneNumber'],
  $gradeId,
  $data['MedicalInfo'],
  $data['EmergencyContact'],
  $data['EmergencyPhone'],
  $data['IsActive'],
  $data['IsRecurrent'],
  $data['EnrollmentDate'],
  $data['StudentID']
);


$res = $stmt->execute();
if($res){
    echo json_encode(["success"=>true]);
}else{
    echo json_encode(["success"=>false,"message"=>$stmt->error]);
}
$stmt->close();
$conn->close();
?>
