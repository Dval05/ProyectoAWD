<?php
header('Content-Type: application/json');

// Database configuration with environment variable support
$dbHost = getenv('DB_HOST') ?: 'localhost';
$dbUser = getenv('DB_USER') ?: 'admin';
$dbPass = getenv('DB_PASSWORD') ?: 'admin';
$dbName = getenv('DB_NAME') ?: 'nicekids';
$dbPort = getenv('DB_PORT') ?: 3306;

$result = ['success' => false];

$mysqli = @new mysqli($dbHost, $dbUser, $dbPass, $dbName, $dbPort);
if ($mysqli->connect_errno) {
    $result['error'] = $mysqli->connect_error;
    $result['errno'] = $mysqli->connect_errno;
} else {
    $result['success'] = true;
    $result['message'] = 'Conectado a MySQL ' . $mysqli->server_info . ' / DB: ' . $dbName;
    // opcional: una consulta simple para confirmar permisos
    $res = $mysqli->query("SELECT 1");
    $result['query_ok'] = $res ? true : false;
    $mysqli->close();
}

echo json_encode($result);
