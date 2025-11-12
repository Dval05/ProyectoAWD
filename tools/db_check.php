<?php
header('Content-Type: application/json');

// Ajusta estas credenciales si tu entorno es distinto
$dbHost = 'localhost';
$dbUser = 'admin';
$dbPass = 'admin';
$dbName = 'nicekids';

$result = ['success' => false];

$mysqli = @new mysqli($dbHost, $dbUser, $dbPass, $dbName);
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
