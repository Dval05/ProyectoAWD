<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$id = isset($_GET['id']) ? intval($_GET['id']) : 0;
$stmt = $conn->prepare("SELECT * FROM activity WHERE ActivityID=? LIMIT 1");
$stmt->bind_param("i", $id);
$stmt->execute();
$res = $stmt->get_result();
$row = $res->fetch_assoc();
echo json_encode(["success"=>!!$row,"data"=>$row]);
$stmt->close();
$conn->close();
?>
