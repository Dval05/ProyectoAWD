<?php
require_once('../config/database.php');
require_once('../config/security.php');
require_once('../middleware/auth_middleware.php');

// Require authentication and get the acting user id (AssignedBy)
$creatorId = null;
try {
    $creatorId = require_auth();
} catch (Exception $e) {
    // require_auth() will echo and exit on failure; this is defensive
}

$username = sanitize(isset($_POST['UserName']) ? $_POST['UserName'] : '');
$email = sanitize(isset($_POST['Email']) ? $_POST['Email'] : '');
$firstname = sanitize(isset($_POST['FirstName']) ? $_POST['FirstName'] : '');
$lastname = sanitize(isset($_POST['LastName']) ? $_POST['LastName'] : '');
$phone = sanitize(isset($_POST['Phone']) ? $_POST['Phone'] : '');
$address = sanitize(isset($_POST['Address']) ? $_POST['Address'] : '');
$password = hashPassword(isset($_POST['Password']) ? $_POST['Password'] : '');
$roleId = isset($_POST['RoleID']) ? intval($_POST['RoleID']) : 0;

$query = "INSERT INTO user (UserName, PasswordHash, Email, FirstName, LastName, Phone, Address, IsActive, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, 1, NOW())";
$stmt = $conn->prepare($query);
$stmt->bind_param("sssssss", $username, $password, $email, $firstname, $lastname, $phone, $address);
if($stmt->execute()){
    $newUserId = $stmt->insert_id;

    $userRoleId = null;
    // If a role was provided, try to assign it
    if ($roleId > 0) {
        $insSql = "INSERT INTO user_role (UserID, RoleID, AssignedAt, AssignedBy) VALUES (?, ?, NOW(), ?)";
        $ins = $conn->prepare($insSql);
        if ($ins) {
            // If creatorId is null, insert NULL for AssignedBy
            if ($creatorId) {
                $ins->bind_param("iii", $newUserId, $roleId, $creatorId);
            } else {
                // bind as i i i but pass null as 0
                $dummy = 0;
                $ins->bind_param("iii", $newUserId, $roleId, $dummy);
            }
            if ($ins->execute()) {
                $userRoleId = $ins->insert_id;
            }
            $ins->close();
        }
    }

    echo json_encode(['success'=>true,'UserID'=>$newUserId,'UserRoleID'=>$userRoleId]);
} else {
    echo json_encode(['success'=>false,'msg'=>$stmt->error]);
}
$stmt->close();
$conn->close();
?>
