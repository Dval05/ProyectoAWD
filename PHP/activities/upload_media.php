<?php
require_once "../config/database.php";
header('Content-Type: application/json');
if(isset($_FILES['file']) && isset($_POST['ActivityID'])){
  $aid = intval($_POST['ActivityID']);
  $type = $_POST['MediaType'] ?? 'Image';
  $caption = $_POST['Caption'] ?? '';
  $userId = $_POST['UploadedBy'] ?? null;
  $file = $_FILES['file'];
  $target = "uploads/activities/" . basename($file["name"]);
  if(move_uploaded_file($file["tmp_name"], $target)){
    $stmt = $conn->prepare("INSERT INTO activitymedia (ActivityID, MediaType, FilePath, Caption, UploadedBy) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("isssi", $aid, $type, $target, $caption, $userId);
    if($stmt->execute()){
      echo json_encode(["success"=>true]);
    } else {
      echo json_encode(["success"=>false,"message"=>$stmt->error]);
    }
    $stmt->close();
  } else {
    echo json_encode(["success"=>false,"message"=>"No puedo mover archivo"]);
  }
} else {
  echo json_encode(["success"=>false]);
}
$conn->close();
?>
