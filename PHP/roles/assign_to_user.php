<?php
require_once('../config/database.php');
require_once('../middleware/auth_middleware.php');
header('Content-Type: application/json');

// Ensure caller is authenticated and get their user id
$assignedBy = require_auth();

$userID = isset($_POST['UserID']) ? intval($_POST['UserID']) : 0;
$roleID = isset($_POST['RoleID']) ? intval($_POST['RoleID']) : 0;

if ($userID <= 0 || $roleID <= 0) {
    echo json_encode(['success'=>false, 'msg'=>'UserID y RoleID son requeridos']);
    $conn->close();
    exit;
}

// Insert into user_role table
$query = "INSERT INTO user_role (UserID, RoleID, AssignedAt, AssignedBy) VALUES (?, ?, NOW(), ?)";
$stmt = $conn->prepare($query);
if (!$stmt) {
    echo json_encode(['success'=>false, 'msg'=>'Prepare error: '.$conn->error]);
    $conn->close();
    exit;
}
$stmt->bind_param("iii", $userID, $roleID, $assignedBy);
if ($stmt->execute()) {
    echo json_encode(['success'=>true, 'UserRoleID'=>$stmt->insert_id]);
} else {
    echo json_encode(['success'=>false, 'msg'=>$stmt->error]);
}
$stmt->close();
$conn->close();
?>
