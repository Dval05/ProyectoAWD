<?php
// Database configuration with environment variable support
// For Render deployment, these values will be set as environment variables
$servername = getenv('DB_HOST') ?: 'localhost';
$username = getenv('DB_USER') ?: 'admin';
$password = getenv('DB_PASSWORD') ?: 'admin';
$dbname = getenv('DB_NAME') ?: 'nicekids';
$port = getenv('DB_PORT') ?: 3306;

// Crear conexión
$conn = new mysqli($servername, $username, $password, $dbname, $port);

// Set charset to utf8mb4 for proper unicode support
if (!$conn->set_charset("utf8mb4")) {
    error_log("Error loading character set utf8mb4: " . $conn->error);
}

// Verifica conexión
if ($conn->connect_error) {
    error_log("Connection failed: " . $conn->connect_error);
    die("Connection failed: " . $conn->connect_error);
}
?>
