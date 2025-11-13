<?php
header('Content-Type: application/json');
require_once "../config/database.php";

// Validar y obtener el parámetro
$id = isset($_GET['id']) ? intval($_GET['id']) : 0;
if($id <= 0){
  echo json_encode(["success"=>false, "data"=>null, "message"=>"ID inválido"]);
  exit;
}

// Consulta el tutor por su ID
$sql = "SELECT * FROM guardian WHERE GuardianID = ? LIMIT 1";
$stmt = $conn->prepare($sql);
if(!$stmt){
    echo json_encode(["success"=>false, "data"=>null, "message"=>"Error en prepare: ".$conn->error]);
    $conn->close();
    exit;
}
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$row = $result->fetch_assoc();
if($row){
    echo json_encode(["success"=>true, "data"=>$row]);
} else {
    echo json_encode(["success"=>false, "data"=>null, "message"=>"Tutor no encontrado"]);
}
$stmt->close();
$conn->close();
?>
