<?php
require_once('../config/database.php');

// Si no hay conexión a la base de datos, devolver error JSON claro (evita 500/HTML que rompe AJAX)
if ((empty($conn) || !($conn instanceof mysqli)) && empty($pdo)) {
	header('Content-Type: application/json');
	http_response_code(500);
	$logFile = __DIR__ . '/../../logs/db_connect.log';
	$msg = 'DB connection not available';
	if (file_exists($logFile)) {
		$msg .= '. See log: ' . $logFile;
	}
	echo json_encode(['success' => false, 'code' => 500, 'msg' => $msg]);
	exit();
}

function get_authorization_header() {
	if (isset($_SERVER['HTTP_AUTHORIZATION'])) return trim($_SERVER['HTTP_AUTHORIZATION']);
	if (function_exists('apache_request_headers')) {
		$headers = apache_request_headers();
		if (isset($headers['Authorization'])) return trim($headers['Authorization']);
		if (isset($headers['authorization'])) return trim($headers['authorization']);
	}
	return null;
}

function get_bearer_token() {
	$auth = get_authorization_header();
	// Si no hay header Authorization, aceptar token por GET/POST para depuración
	if (empty($auth)) {
		if (isset($_GET['token']) && !empty($_GET['token'])) {
			return trim($_GET['token']);
		}
		if (!empty($_POST['token'])) {
			return trim($_POST['token']);
		}
		return null;
	}
	if (stripos($auth, 'Bearer ') === 0) {
		return trim(substr($auth, 7));
	}
	return null;
}

function require_auth() {
	global $conn;
	header('Content-Type: application/json');

	$token = get_bearer_token();
	$userId = null;

	if ($token) {
		// Intentar buscar token en la tabla session
		$debugDir = __DIR__ . '/../../logs';
		if (!is_dir($debugDir)) @mkdir($debugDir, 0755, true);
		$debugFile = $debugDir . '/auth_debug.log';
		@file_put_contents($debugFile, date('Y-m-d H:i:s') . " - Checking token: " . $token . PHP_EOL, FILE_APPEND);
		$q = $conn->prepare("SELECT UserID FROM session WHERE Token = ? AND ExpiresAt > NOW() LIMIT 1");
		if ($q) {
			$q->bind_param("s", $token);
			$q->execute();
			$q->bind_result($uid);
			if ($q->fetch()) {
				$userId = $uid;
				@file_put_contents($debugFile, date('Y-m-d H:i:s') . " - Token valid for UserID: " . $userId . PHP_EOL, FILE_APPEND);
			} else {
				@file_put_contents($debugFile, date('Y-m-d H:i:s') . " - Token not found or expired." . PHP_EOL, FILE_APPEND);
			}
			$q->close();
		} else {
			@file_put_contents($debugFile, date('Y-m-d H:i:s') . " - Prepare failed: " . $conn->error . PHP_EOL, FILE_APPEND);
		}
	}

	if (!$userId) {
		// Fallback a sesión PHP (por compatibilidad)
		if (session_status() !== PHP_SESSION_ACTIVE) {
			session_start();
		}
		if (isset($_SESSION['UserID'])) {
			$userId = (int)$_SESSION['UserID'];
		}
	}

	if (!$userId) {
		// Registrar detalle y devolver 401
		$debugDir = __DIR__ . '/../../logs';
		$debugFile = $debugDir . '/auth_debug.log';
		@file_put_contents($debugFile, date('Y-m-d H:i:s') . " - Authentication failed, userId null. REMOTE_ADDR=" . ($_SERVER['REMOTE_ADDR'] ?? 'unknown') . PHP_EOL, FILE_APPEND);
		header('HTTP/1.1 401 Unauthorized');
		echo json_encode(['success'=>false, 'code'=>401, 'msg'=>'No autenticado']);
		exit();
	}

	// Verificar que tenga al menos un rol activo
	$q = $conn->prepare("SELECT 1 
		FROM user_role ur 
		JOIN role r ON ur.RoleID = r.RoleID 
		WHERE ur.UserID = ? AND r.IsActive = 1 LIMIT 1");
	$q->bind_param("i", $userId);
	$q->execute();
	$q->store_result();
	if ($q->num_rows === 0) {
		http_response_code(403);
		echo json_encode(['success'=>false, 'code'=>403, 'msg'=>'Usuario sin rol activo']);
		exit();
	}
	$q->close();

	return $userId;
}

function user_has_permission($userId, $module, $action) {
	global $conn;
	$sql = "SELECT p.PermissionID
		FROM user_role ur 
		JOIN role_permission rp ON ur.RoleID = rp.RoleID
		JOIN permission p ON rp.PermissionID = p.PermissionID
		WHERE ur.UserID = ? AND p.Module = ? AND p.Action = ?
		LIMIT 1";
	$st = $conn->prepare($sql);
	$st->bind_param("iss", $userId, $module, $action);
	$st->execute();
	$st->store_result();
	$ok = $st->num_rows > 0;
	$st->close();
	return $ok;
}

function require_permission($module, $action) {
	$userId = require_auth();
	if (!user_has_permission($userId, $module, $action)) {
		http_response_code(403);
		echo json_encode(['success'=>false, 'code'=>403, 'msg'=>'Permiso denegado']);
		exit();
	}
	return $userId;
}
?>
