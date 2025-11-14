<?php
// Configuración de conexión centralizada
define('DB_HOST', 'sql3.freesqldatabase.com');
define('DB_USER', 'sql3807670');
define('DB_PASS', 'rH287DQKc3');
define('DB_NAME', 'sql3807670');
define('DB_PORT', 3306);

$db_connect_error = false;
$db_last_error = '';

// Intentar conexión mysqli primero
try {
    $conn = @new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME, DB_PORT);
    if ($conn && !$conn->connect_errno) {
        $mysqli = $conn; // compatibilidad
        if (method_exists($conn, 'set_charset')) $conn->set_charset('utf8mb4');
    } else {
        throw new Exception('MySQLi connect error: ' . ($conn ? $conn->connect_error : 'unknown'));
    }
} catch (Exception $e) {
    $db_connect_error = true;
    $db_last_error = $e->getMessage();
    // Intentar PDO como fallback
    try {
        $dsn = 'mysql:host=' . DB_HOST . ';port=' . DB_PORT . ';dbname=' . DB_NAME . ';charset=utf8mb4';
        $pdo = new PDO($dsn, DB_USER, DB_PASS, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_PERSISTENT => false,
        ]);
        // Si PDO funciona, exponer $pdo y desactivar bandera de error
        $db_connect_error = false;
    } catch (Exception $ex) {
        $db_connect_error = true;
        $db_last_error = $db_last_error . ' | PDO error: ' . $ex->getMessage();
        // Registrar el error en un fichero para depuración
        $logDir = __DIR__ . '/../../logs';
        if (!is_dir($logDir)) {
            @mkdir($logDir, 0755, true);
        }
        $logFile = $logDir . '/db_connect.log';
        $msg = date('Y-m-d H:i:s') . " - DB connect failed: " . $db_last_error . PHP_EOL;
        @file_put_contents($logFile, $msg, FILE_APPEND);
        // Dejar $conn y $pdo no definidos para que los scripts gestionen el error
    }
}

?>
