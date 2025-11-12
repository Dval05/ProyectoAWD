<?php
header('Content-Type: application/json');
require_once "../config/database.php";
$studentId = intval($_GET['studentId']);
$sql = "SELECT g.GuardianID, g.FirstName, g.LastName, g.Relationship, g.PhoneNumber, g.Email, sg.IsPrimary
        FROM student_guardian sg
        JOIN guardian g ON sg.GuardianID = g.GuardianID
        WHERE sg.StudentID = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $studentId);
$stmt->execute();
$res = $stmt->get_result();
$rows = [];
while($row = $res->fetch_assoc()) $rows[] = $row;
echo json_encode(["success"=>true, "data"=>$rows]);
$stmt->close();
$conn->close();
?>
