<?php
header('Content-Type: application/json');
require_once "../config/database.php"; // Asegúrate del path correcto

function nullIfEmpty($v){ return ($v === "" ? null : $v); }

$data = json_decode(file_get_contents("php://input"), true);

$FirstName = $data['FirstName'] ?? null;
$LastName = $data['LastName'] ?? null;
$BirthDate = $data['BirthDate'] ?? null;
$Gender = nullIfEmpty($data['Gender'] ?? null);
$DocumentNumber = nullIfEmpty($data['DocumentNumber'] ?? null);
$Address = nullIfEmpty($data['Address'] ?? null);
$Email = nullIfEmpty($data['Email'] ?? null);
$PhoneNumber = nullIfEmpty($data['PhoneNumber'] ?? null);
$GradeID = nullIfEmpty($data['GradeID'] ?? null);
$ProfilePicture = nullIfEmpty($data['ProfilePicture'] ?? null); // aquí solo ruta/filename, para FormData adapta lógica
$MedicalInfo = nullIfEmpty($data['MedicalInfo'] ?? null);
$EmergencyContact = nullIfEmpty($data['EmergencyContact'] ?? null);
$EmergencyPhone = nullIfEmpty($data['EmergencyPhone'] ?? null);
$IsActive = isset($data['IsActive']) ? intval($data['IsActive']) : 1;
$IsRecurrent = isset($data['IsRecurrent']) ? intval($data['IsRecurrent']) : 1;
$EnrollmentDate = nullIfEmpty($data['EnrollmentDate'] ?? null);
$WithdrawalDate = nullIfEmpty($data['WithdrawalDate'] ?? null);

// Los únicos obligatorios estrictos son FirstName, LastName, BirthDate
if(!$FirstName || !$LastName || !$BirthDate){
    http_response_code(400);
    echo json_encode(["success"=>false,"message"=>"Missing required fields"]);
    exit;
}

$sql = "INSERT INTO student
(FirstName, LastName, BirthDate, Gender, DocumentNumber, Address, Email, PhoneNumber, GradeID, ProfilePicture, MedicalInfo, EmergencyContact, EmergencyPhone, IsActive, IsRecurrent, EnrollmentDate, WithdrawalDate)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param(
    "ssssssssisssssiss",
    $FirstName, $LastName, $BirthDate, $Gender, $DocumentNumber, $Address, $Email, $PhoneNumber,
    $GradeID, $ProfilePicture, $MedicalInfo, $EmergencyContact, $EmergencyPhone,
    $IsActive, $IsRecurrent, $EnrollmentDate, $WithdrawalDate
);

$res = $stmt->execute();
if($res){
    echo json_encode(["success"=>true, "student_id"=>$stmt->insert_id]);
} else {
    http_response_code(500);
    echo json_encode(["success"=>false, "message"=>"Error: ".$stmt->error]);
}

$stmt->close();
$conn->close();
?>
