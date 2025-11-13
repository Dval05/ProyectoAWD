<?php
require_once('../config/database.php');
require_once('../config/security.php');
require_once('../middleware/auth_middleware.php');

header('Content-Type: application/json');

// Authenticate user for profile page WITHOUT requiring an active role.
// This allows users who have a valid session/token but no role yet to view their profile.
$userID = null;
// Try bearer token first
$token = get_bearer_token();
if ($token) {
  $q = $conn->prepare("SELECT UserID FROM session WHERE Token = ? AND ExpiresAt > NOW() LIMIT 1");
  $q->bind_param("s", $token);
  $q->execute();
  $q->bind_result($uid);
  if ($q->fetch()) { $userID = (int)$uid; }
  $q->close();
}

// Fallback to PHP session
if (!$userID) {
  if (session_status() !== PHP_SESSION_ACTIVE) session_start();
  if (isset($_SESSION['UserID'])) $userID = (int)$_SESSION['UserID'];
}

if (!$userID) {
  http_response_code(401);
  echo json_encode(['success'=>false, 'msg'=>'No autenticado']);
  exit();
}

$query = "SELECT u.UserID, u.UserName, u.Email, u.FirstName, u.LastName, u.Phone, u.Address, u.IsActive, u.LastLogin, u.CreatedAt, u.UpdatedAt,
          r.RoleName as Role
          FROM user u
          LEFT JOIN (
            SELECT ur.UserID, r.RoleName
            FROM user_role ur
            JOIN role r ON ur.RoleID = r.RoleID
            WHERE r.IsActive = 1
            ORDER BY ur.AssignedAt DESC
          ) r ON r.UserID = u.UserID
          WHERE u.UserID = ? LIMIT 1";

$stmt = $conn->prepare($query);
$stmt->bind_param("i", $userID);
$stmt->execute();
$result = $stmt->get_result();
$row = $result->fetch_assoc();
if (!$row) {
    http_response_code(404);
    echo json_encode(['success'=>false, 'msg'=>'Usuario no encontrado']);
} else {
    echo json_encode($row);
}
$stmt->close();
$conn->close();
?>
