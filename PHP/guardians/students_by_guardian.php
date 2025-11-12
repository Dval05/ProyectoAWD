<?php
header('Content-Type: application/json');
require_once "../config/database.php";

// Validar y obtener el parámetro
$guardianId = isset($_GET['guardianId']) ? intval($_GET['guardianId']) : 0;
if($guardianId <= 0){
  echo json_encode(["success"=>false, "data"=>[], "message"=>"ID de representante inválido"]);
  exit;
}

// Consulta los estudiantes vinculados a este tutor
$sql = "SELECT s.StudentID, s.FirstName, s.LastName 
        FROM student_guardian sg 
        JOIN student s ON sg.StudentID = s.StudentID 
        WHERE sg.GuardianID = ?";
$stmt = $conn->prepare($sql);
if(!$stmt){
    echo json_encode(["success"=>false, "data"=>[], "message"=>"Error en prepare: ".$conn->error]);
    $conn->close();
    exit;
}
$stmt->bind_param("i", $guardianId);
$stmt->execute();
$res = $stmt->get_result();
$rows = [];
while($row = $res->fetch_assoc()) $rows[] = $row;
echo json_encode(["success"=>true, "data"=>$rows]);
$stmt->close();
$conn->close();
?>
