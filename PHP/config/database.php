<?php
$servername = "localhost";
$username = "admin";
$password = "admin";         // Cambia si tienes clave
$dbname = "nicekids1";
// Crear conexión
$conn = new mysqli($servername, $username, $password, $dbname);
// Verifica conexión
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
