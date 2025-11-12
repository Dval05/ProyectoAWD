<?php
header('Content-Type: application/json; charset=utf-8');

// Ajusta la ruta al database.php (desde PHP/attendance -> ../config/database.php)
$configPath = __DIR__ . '/../config/database.php';
if (!file_exists($configPath)) {
    // Lanzar excepción para que el catch abajo retorne JSON en vez de volcar warnings/HTML
    throw new Exception('Missing config file: ' . $configPath);
}
require_once $configPath;

try {
    $grades = [];

    // Si database.php expone $pdo (PDO)
    if (isset($pdo) && $pdo instanceof PDO) {
        $stmt = $pdo->prepare("SELECT GradeID, GradeName FROM `grade` WHERE IsActive=1 ORDER BY GradeName");
        $stmt->execute();
        $grades = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($grades);
        exit;
    }

    // Si database.php expone una conexión mysqli ($mysqli o $conn)
    $db = null;
    if (isset($mysqli) && $mysqli instanceof mysqli) {
        $db = $mysqli;
    } elseif (isset($conn) && $conn instanceof mysqli) {
        $db = $conn;
    } else {
        // Intentar crear conexión si están definidas las constantes
        if (defined('DB_HOST') && defined('DB_USER') && defined('DB_NAME')) {
            $db = new mysqli(DB_HOST, DB_USER, defined('DB_PASS') ? DB_PASS : '', DB_NAME);
            if ($db->connect_errno) {
                throw new Exception('DB connect error: ' . $db->connect_error);
            }
        }
    }

    if ($db instanceof mysqli) {
        $res = $db->query("SELECT GradeID, GradeName FROM `grade` WHERE IsActive=1 ORDER BY GradeName");
        if (!$res) throw new Exception('Query error: ' . $db->error);
        while ($row = $res->fetch_assoc()) $grades[] = $row;
        echo json_encode($grades);
        exit;
    }

    throw new Exception('No DB connection available. Verifica config/database.php');
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
    exit;
}