-- Initial database setup script
-- This script runs automatically when the MySQL container starts for the first time

USE businessbeacon;

-- Example: Create a sample table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Example: Insert sample data
INSERT INTO users (username, email) VALUES 
    ('admin', 'admin@example.com'),
    ('testuser', 'test@example.com')
ON DUPLICATE KEY UPDATE username=username;

-- Add more initialization SQL here as needed
