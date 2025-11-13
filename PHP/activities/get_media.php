<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$actid = isset($_GET['ActivityID']) ? intval($_GET['ActivityID']) : 0;
$sql = "SELECT * FROM activitymedia WHERE ActivityID=? ORDER BY CreatedAt DESC";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $actid);
$stmt->execute();
$res = $stmt->get_result();
$data = [];
while($row=$res->fetch_assoc()) $data[] = $row;
echo json_encode(["success"=>true,"data"=>$data]);
$stmt->close();
$conn->close();
?>
