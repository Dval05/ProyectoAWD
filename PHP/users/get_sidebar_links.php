<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once __DIR__ . '../config/database.php';
require_once __DIR__ . '../middleware/auth_middleware.php';

header('Content-Type: application/json');

// DEBUG: registrar token y flujo de autorización (temporal)
$debugDir = __DIR__ . '/../../logs';
if (!is_dir($debugDir)) @mkdir($debugDir, 0755, true);
$debugFile = $debugDir . '/sidebar_debug.log';
$authHeader = null;
foreach (getallheaders() as $k => $v) {
	if (strtolower($k) === 'authorization') { $authHeader = $v; break; }
}
@file_put_contents($debugFile, date('Y-m-d H:i:s') . " - Request Authorization: " . ($authHeader ?? 'none') . PHP_EOL, FILE_APPEND);

$userId = require_auth();
@file_put_contents($debugFile, date('Y-m-d H:i:s') . " - require_auth returned userId: " . ($userId ?? 'null') . PHP_EOL, FILE_APPEND);

$sql = "SELECT p.PermissionID, p.PermissionName, p.Link, p.Icon
	FROM user_role ur
	JOIN role_permission rp ON ur.RoleID = rp.RoleID
	JOIN permission p ON rp.PermissionID = p.PermissionID
	WHERE ur.UserID = ?
	ORDER BY p.PermissionID";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $userId);
$stmt->execute();
$res = $stmt->get_result();

$menu = [];
// Log results for debugging
$debugFile = __DIR__ . '/../../logs/sidebar_debug.log';
@file_put_contents($debugFile, date('Y-m-d H:i:s') . " - Executed sidebar query for userId=" . $userId . PHP_EOL, FILE_APPEND);
if ($res === false) {
    @file_put_contents($debugFile, date('Y-m-d H:i:s') . " - Query error: " . $conn->error . PHP_EOL, FILE_APPEND);
} else {
    @file_put_contents($debugFile, date('Y-m-d H:i:s') . " - Rows returned: " . $res->num_rows . PHP_EOL, FILE_APPEND);
}

while ($row = $res->fetch_assoc()) {
	if (!empty($row['Link'])) {
		$menu[] = [
			"Link" => $row['Link'],
			"Icon" => !empty($row['Icon']) ? $row['Icon'] : 'fa-tachometer-alt',
			"Title" => $row['PermissionName']
		];
	}
}
$stmt->close();

echo json_encode([
	"success" => true,
	"links" => $menu
]);
?>
