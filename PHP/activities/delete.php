<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$id = json_decode(file_get_contents("php://input"), true)['ActivityID'];
$stmt = $conn->prepare("DELETE FROM activity WHERE ActivityID=?");
$stmt->bind_param("i", $id);
if($stmt->execute()){
  echo json_encode(["success"=>true]);
} else {
  echo json_encode(["success"=>false, "message"=>$stmt->error]);
}
$stmt->close();
$conn->close();
?>
