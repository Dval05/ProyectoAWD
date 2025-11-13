<?php
require_once "../config/database.php";
header('Content-Type: application/json');
$sql = "SELECT o.ObservationID, o.ObservationDate, o.Category, o.Observation, o.IsPrivate, s.StudentID, s.FirstName, s.LastName, e.EmpID, e.FirstName as EmpFirstName, e.LastName as EmpLastName
        FROM student_observation o
        JOIN student s ON o.StudentID = s.StudentID
        JOIN employee e ON o.EmpID = e.EmpID
        ORDER BY o.ObservationDate DESC, o.ObservationID DESC";
$res = $conn->query($sql);
$data = [];
while($row = $res->fetch_assoc()) $data[] = $row;
echo json_encode(["success"=>true, "data"=>$data]);
$conn->close();
?>
