<?php
header('Content-Type: application/json');
require_once "../config/database.php";
$data = json_decode(file_get_contents("php://input"), true);

$sql = "INSERT INTO student_guardian (StudentID, GuardianID, IsPrimary, Priority) VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("iiii", $data['StudentID'], $data['GuardianID'], $data['IsPrimary'], $data['Priority']);
$res = $stmt->execute();

if($res){
    echo json_encode(["success"=>true]);
}else{
    echo json_encode(["success"=>false, "message"=>$stmt->error]);
}
$conn->close();
?>
