<?php
/**
 * Health Check Endpoint
 * Este endpoint se usa para verificar que la aplicación está funcionando correctamente
 */
header('Content-Type: application/json');

$health = [
    'status' => 'healthy',
    'timestamp' => date('Y-m-d H:i:s'),
    'application' => 'NICEKIDS',
    'checks' => []
];

// Check database connection
try {
    require_once __DIR__ . '/PHP/config/database.php';
    
    if ($conn && !$conn->connect_error) {
        $result = $conn->query("SELECT 1");
        if ($result) {
            $health['checks']['database'] = 'connected';
        } else {
            $health['checks']['database'] = 'query_failed';
            $health['status'] = 'degraded';
        }
        $conn->close();
    } else {
        $health['checks']['database'] = 'disconnected';
        $health['status'] = 'unhealthy';
    }
} catch (Exception $e) {
    $health['checks']['database'] = 'error: ' . $e->getMessage();
    $health['status'] = 'unhealthy';
}

// Check PHP version
$health['checks']['php_version'] = PHP_VERSION;

// Check required extensions
$required_extensions = ['mysqli', 'json'];
$health['checks']['extensions'] = [];
foreach ($required_extensions as $ext) {
    $health['checks']['extensions'][$ext] = extension_loaded($ext) ? 'loaded' : 'missing';
    if (!extension_loaded($ext)) {
        $health['status'] = 'unhealthy';
    }
}

// Set appropriate HTTP status code
http_response_code($health['status'] === 'healthy' ? 200 : ($health['status'] === 'degraded' ? 200 : 503));

echo json_encode($health, JSON_PRETTY_PRINT);
