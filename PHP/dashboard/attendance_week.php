<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$labels = [];
$data = [];
for($i=6;$i>=0;$i--){
  $date = date('Y-m-d', strtotime("-$i days"));
  $total = $conn->query("SELECT COUNT(*) FROM student WHERE IsActive=1")->fetch_row()[0];
  $present = $conn->query("SELECT COUNT(DISTINCT StudentID) FROM attendance WHERE Date='$date' AND Status='Present'")->fetch_row()[0];
  $labels[] = $date;
  $data[] = $total ? round(100*$present/$total) : 0;
}
echo json_encode([
  "success"=>true,
  "labels"=>$labels,
  "data"=>$data
]);
$conn->close();
?>
