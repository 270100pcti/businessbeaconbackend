-- Initial database setup script
-- This script runs automatically when the MySQL container starts for the first time

USE businessbeacon;

CREATE TABLE IF NOT EXISTS sellers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS places (
    id INT AUTO_INCREMENT PRIMARY KEY,
    placeName VARCHAR(50) NOT NULL,
    placeAddress VARCHAR(50) NOT NULL UNIQUE,
    placeDescription VARCHAR(250) NOT NULL,
    placeRating DOUBLE NOT NULL CHECK (placeRating >= 1 AND placeRating <= 10),
    email VARCHAR(100),
    phone VARCHAR(20),
    placeLogoPath VARCHAR(255),
    placeThumbnailPath VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    sellerID INT NOT NULL,
    FOREIGN KEY (sellerID) REFERENCES sellers(id) ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE IF NOT EXISTS analytics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dataType VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sellerID INT NOT NULL,
    FOREIGN KEY (sellerID) REFERENCES sellers(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Example: Insert sample data
INSERT INTO sellers (username, email) VALUES 
    ('admin', 'admin@example.com'),
    ('testuser', 'test@example.com')
ON DUPLICATE KEY UPDATE username=username;

-- Add more initialization SQL here as needed
