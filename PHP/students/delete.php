<?php
header('Content-Type: application/json');
require_once "../config/database.php";

$data = json_decode(file_get_contents("php://input"), true);
$id = isset($data['StudentID']) ? intval($data['StudentID']) : 0;
if($id <= 0){
    echo json_encode(['success'=>false,'message'=>'ID inválido']);
    exit;
}

$sql = "UPDATE student SET IsActive=0 WHERE StudentID=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $id);
$res = $stmt->execute();
echo json_encode(["success"=>$res]);
$stmt->close();
$conn->close();
?>
