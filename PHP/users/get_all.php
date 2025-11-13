<?php
require_once('../config/database.php');
// return list of users including their most recently assigned role (if any)
header('Content-Type: application/json');

$sql = "SELECT u.UserID, u.UserName, u.Email, u.FirstName, u.LastName, u.Phone, u.Address, u.IsActive, u.LastLogin,
               r.RoleName AS Role
        FROM user u
        LEFT JOIN (
            -- latest role assignment per user (by AssignedAt)
            SELECT ur1.UserID, ur1.RoleID
            FROM user_role ur1
            JOIN (
                SELECT UserID, MAX(AssignedAt) AS ma
                FROM user_role
                GROUP BY UserID
            ) ur2 ON ur1.UserID = ur2.UserID AND ur1.AssignedAt = ur2.ma
        ) latest ON u.UserID = latest.UserID
        LEFT JOIN role r ON latest.RoleID = r.RoleID
        ORDER BY u.UserID ASC";

$result = $conn->query($sql);
if (!$result) {
    echo json_encode(['success'=>false,'msg'=>'Error al leer usuarios: '.$conn->error]);
    $conn->close();
    exit;
}

$data = [];
while($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
$conn->close();
?>
