<?php
require_once "../config/database.php";
header('Content-Type: application/json');

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
$createdBy = $_POST['CreatedBy'] ?? 1;
$imgPath = null;

// PROCESA LA IMAGEN SI SE ENVÍA
if (isset($_FILES['file']) && $_FILES['file']['error'] == UPLOAD_ERR_OK) {
  $targetDir = "../../uploads/activities/";
  if(!file_exists($targetDir)) mkdir($targetDir, 0777, true);
  $fileName = uniqid("act_") . "_" . basename($_FILES["file"]["name"]);
  $target = $targetDir . $fileName;
  if(move_uploaded_file($_FILES["file"]["tmp_name"], $target)){
    // Guarda la ruta relativa para mostrarla desde el sistema
    $imgPath = $target;
  }
}

// VALIDACIÓN DE DATOS OBLIGATORIOS
if (!$name || !$date || !$grade || !$emp) {
  echo json_encode(["success"=>false, "message"=>"Faltan datos obligatorios"]);
  exit;
}

// INSERCIÓN EN LA BASE
$stmt = $conn->prepare(
  "INSERT INTO activity (Name, Description, GradeID, EmpID, ScheduledDate, StartTime, EndTime, Location, Category, Status, CreatedBy, ImagePath)
   VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
);

$stmt->bind_param("ssisssssssss",
  $name,
  $desc,
  $grade,
  $emp,
  $date,
  $stime,
  $etime,
  $loc,
  $cat,
  $status,
  $createdBy,
  $imgPath
);

if($stmt->execute()){
  echo json_encode(["success"=>true, "id"=>$conn->insert_id]);
} else {
  echo json_encode(["success"=>false, "message"=>$stmt->error]);
}
$stmt->close();
$conn->close();
?>
