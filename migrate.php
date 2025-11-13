#!/usr/bin/env php
<?php
/**
 * Database Migration Script
 * This script imports the nicekids.sql file into the configured database
 * 
 * Usage: php migrate.php
 */

// Check if running from CLI
if (php_sapi_name() !== 'cli') {
    die("This script must be run from the command line.\n");
}

echo "=== NICEKIDS Database Migration ===\n\n";

// Get database credentials from environment variables or defaults
$dbHost = getenv('DB_HOST') ?: 'localhost';
$dbUser = getenv('DB_USER') ?: 'admin';
$dbPass = getenv('DB_PASSWORD') ?: 'admin';
$dbName = getenv('DB_NAME') ?: 'nicekids';
$dbPort = getenv('DB_PORT') ?: 3306;

echo "Database Configuration:\n";
echo "  Host: $dbHost\n";
echo "  Port: $dbPort\n";
echo "  Database: $dbName\n";
echo "  User: $dbUser\n\n";

// Path to SQL file
$sqlFile = __DIR__ . '/nicekids.sql';

if (!file_exists($sqlFile)) {
    die("ERROR: SQL file not found at: $sqlFile\n");
}

echo "SQL file found: $sqlFile\n";
echo "File size: " . number_format(filesize($sqlFile)) . " bytes\n\n";

// Connect to database
echo "Connecting to database...\n";
$conn = new mysqli($dbHost, $dbUser, $dbPass, $dbName, $dbPort);

if ($conn->connect_error) {
    die("ERROR: Connection failed: " . $conn->connect_error . "\n");
}

echo "Connected successfully!\n\n";

// Set charset
if (!$conn->set_charset("utf8mb4")) {
    echo "WARNING: Could not set charset to utf8mb4\n";
}

// Read SQL file
echo "Reading SQL file...\n";
$sql = file_get_contents($sqlFile);

if ($sql === false) {
    die("ERROR: Could not read SQL file\n");
}

echo "SQL file loaded (" . number_format(strlen($sql)) . " characters)\n\n";

// Split SQL into individual statements
echo "Executing SQL statements...\n";
$statements = array_filter(
    array_map('trim', explode(';', $sql)),
    function($stmt) {
        return !empty($stmt) && 
               substr($stmt, 0, 2) !== '--' && 
               substr($stmt, 0, 2) !== '/*';
    }
);

$successCount = 0;
$errorCount = 0;
$totalStatements = count($statements);

echo "Found $totalStatements SQL statements\n\n";

foreach ($statements as $index => $statement) {
    if (empty($statement)) continue;
    
    // Show progress
    if (($index + 1) % 10 === 0 || $index === 0) {
        echo "Progress: " . ($index + 1) . "/$totalStatements statements\n";
    }
    
    if ($conn->query($statement)) {
        $successCount++;
    } else {
        $errorCount++;
        // Only show first few errors to avoid spam
        if ($errorCount <= 5) {
            echo "WARNING: Error in statement " . ($index + 1) . ": " . $conn->error . "\n";
            if ($errorCount === 5) {
                echo "... (suppressing further errors)\n";
            }
        }
    }
}

echo "\n=== Migration Complete ===\n";
echo "Total statements: $totalStatements\n";
echo "Successful: $successCount\n";
echo "Errors: $errorCount\n\n";

// Verify some key tables exist
echo "Verifying database structure...\n";
$tables = ['users', 'students', 'employees', 'activity', 'attendance'];
$foundTables = 0;

foreach ($tables as $table) {
    $result = $conn->query("SHOW TABLES LIKE '$table'");
    if ($result && $result->num_rows > 0) {
        $foundTables++;
        echo "  ✓ Table '$table' exists\n";
    } else {
        echo "  ✗ Table '$table' NOT FOUND\n";
    }
}

echo "\nFound $foundTables/" . count($tables) . " key tables\n";

$conn->close();

echo "\n";
if ($errorCount === 0) {
    echo "✓ Migration completed successfully!\n";
    exit(0);
} else {
    echo "⚠ Migration completed with $errorCount errors. Please review the output above.\n";
    exit(1);
}
