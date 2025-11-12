<?php
require_once "../config/database.php";
$today = date('Y-m-d');
$total = $conn->query("SELECT COUNT(*) as t FROM student WHERE IsActive=1")->fetch_assoc()['t'];
$present = $conn->query("SELECT COUNT(DISTINCT StudentID) as p FROM attendance WHERE Date='$today' AND Status='Present'")->fetch_assoc()['p'];
$pct = $total > 0 ? round(100 * $present / $total) : 0;
echo json_encode([
  "success"=>true,
  "present"=>$present,
  "total"=>$total,
  "percent"=>$pct
]);
$conn->close();
?>
