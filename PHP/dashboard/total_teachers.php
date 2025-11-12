<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$res = $conn->query("SELECT COUNT(*) as total FROM employee WHERE IsActive=1");
$row = $res->fetch_assoc();
echo json_encode(["success"=>true, "total"=>intval($row['total'])]);
$conn->close();
?>
