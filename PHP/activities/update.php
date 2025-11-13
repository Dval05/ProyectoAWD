<?php
ini_set('display_errors', 1); error_reporting(E_ALL);

require_once "../config/database.php";
header('Content-Type: application/json');

if ($_SERVER["CONTENT_TYPE"] === "application/json" || strpos($_SERVER["CONTENT_TYPE"],"json")!==false) {
  // Actualización desde AJAX JSON (sin imagen)
  $data = json_decode(file_get_contents("php://input"), true);
  $id = $data['ActivityID'] ?? null;
  $name = $data['Name'] ?? '';
  $desc = $data['Description'] ?? '';
  $grade = $data['GradeID'] ?? '';
  $emp = $data['EmpID'] ?? '';
  $date = $data['ScheduledDate'] ?? '';
  $stime = $data['StartTime'] ?? null;
  $etime = $data['EndTime'] ?? null;
  $loc = $data['Location'] ?? null;
  $cat = $data['Category'] ?? '';
  $status = $data['Status'] ?? 'Planned';
  if(!$id || !$name || !$date || !$grade || !$emp){
    echo json_encode(["success"=>false, "message"=>"Faltan datos obligatorios"]);
    exit;
  }
  $stmt = $conn->prepare(
    "UPDATE activity SET Name=?, Description=?, GradeID=?, EmpID=?, ScheduledDate=?, StartTime=?, EndTime=?, Location=?, Category=?, Status=? WHERE ActivityID=?"
  );
  $stmt->bind_param("ssisssssssi", $name, $desc, $grade, $emp, $date, $stime, $etime, $loc, $cat, $status, $id);
  if($stmt->execute()){
    echo json_encode(["success"=>true]);
  } else {
    echo json_encode(["success"=>false, "message"=>$stmt->error]);
  }
  $stmt->close();
  $conn->close();
  exit;
}

// Si no, asume POST con archivo (FormData)
$id = $_POST['ActivityID'] ?? null;
$name = $_POST['Name'] ?? '';
$desc = $_POST['Description'] ?? '';
$grade = $_POST['GradeID'] ?? '';
$emp = $_POST['EmpID'] ?? '';
$date = $_POST['ScheduledDate'] ?? '';
$stime = $_POST['StartTime'] ?? null;
$etime = $_POST['EndTime'] ?? null;
$loc = $_POST['Location'] ?? null;
$cat = $_POST['Category'] ?? '';
$status = $_POST['Status'] ?? 'Planned';
$imgPath = null;

if(!$id || !$name || !$date || !$grade || !$emp) {
  echo json_encode(["success"=>false, "message"=>"Faltan datos obligatorios"]);
  exit;
}

if(isset($_FILES['file']) && $_FILES['file']['error'] == UPLOAD_ERR_OK){
  $targetDir = "../../uploads/activities/";
  if(!file_exists($targetDir)) mkdir($targetDir, 0777, true);
  $fileName = uniqid("act_") . "_" . basename($_FILES["file"]["name"]);
  $target = $targetDir . $fileName;
  if(move_uploaded_file($_FILES["file"]["tmp_name"], $target)){
    $imgPath = $target;
  }
}

if($imgPath) {
  $stmt = $conn->prepare(
    "UPDATE activity SET Name=?, Description=?, GradeID=?, EmpID=?, ScheduledDate=?, StartTime=?, EndTime=?, Location=?, Category=?, Status=?, ImagePath=? WHERE ActivityID=?"
  );
  $stmt->bind_param("ssissssssssi", 
    $name, $desc, $grade, $emp, $date, $stime, $etime, $loc, $cat, $status, $imgPath, $id
  );
} else {
  $stmt = $conn->prepare(
    "UPDATE activity SET Name=?, Description=?, GradeID=?, EmpID=?, ScheduledDate=?, StartTime=?, EndTime=?, Location=?, Category=?, Status=? WHERE ActivityID=?"
  );
  $stmt->bind_param("ssisssssssi", 
    $name, $desc, $grade, $emp, $date, $stime, $etime, $loc, $cat, $status, $id
  );
}

if($stmt->execute()){
  echo json_encode(["success"=>true]);
} else {
  echo json_encode(["success"=>false, "message"=>$stmt->error]);
}
$stmt->close();
$conn->close();
?>
