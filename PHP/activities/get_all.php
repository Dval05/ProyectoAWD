<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$sql = "SELECT a.ActivityID, a.Name, a.Description, a.GradeID, g.GradeName, a.EmpID, e.FirstName AS TeacherFirstName, e.LastName AS TeacherLastName, a.ScheduledDate, a.Category, a.Status, a.CreatedAt
        FROM activity a
        LEFT JOIN grade g ON a.GradeID = g.GradeID
        LEFT JOIN employee e ON a.EmpID = e.EmpID
        ORDER BY a.ScheduledDate DESC";
$res = $conn->query($sql);
$data = [];
while($row = $res->fetch_assoc()) $data[] = $row;
echo json_encode(["success"=>true,"data"=>$data]);
$conn->close();
?>
