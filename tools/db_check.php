<?php
header('Content-Type: application/json');

// Ajusta estas credenciales si tu entorno es distinto
$dbHost = 'sql3.freesqldatabase.com';
$dbUser = 'sql3807670';
$dbPass = 'rH287DQKc3';
$dbName = 'sql3807670';
$dbPort = 3306;

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
