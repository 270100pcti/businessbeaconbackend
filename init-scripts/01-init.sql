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
    placeAddress VARCHAR(50) NOT NULL,
    placeDescription VARCHAR(250),
    placeRating DOUBLE NOT NULL DEFAULT 5 CHECK (placeRating >= 1 AND placeRating <= 10),
    placeEmail VARCHAR(100),
    placePhone VARCHAR(20),
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


INSERT INTO sellers (username, email) VALUES 
    ('admin', 'admin@example.com'),
    ('testuser', 'test@example.com')
ON DUPLICATE KEY UPDATE username=username;


INSERT INTO places (placeName, placeAddress, placeDescription, placeRating, placeEmail, placePhone, placeLogoPath, placeThumbnailPath, sellerID) VALUES
    ('Sunrise Cafe', '123 Main St, Springfield', 'Cozy cafe serving breakfast and specialty coffee.', 8.5, 'contact@sunrisecafe.example.com', '+1-555-0100', '/images/sunrise_logo.png', '/images/sunrise_thumb.png', 1),
    ('Moonlight Lounge', '456 Oak Ave, Springfield', 'Late-night lounge with live music and cocktails.', 9.2, 'hello@moonlight.example.com', '+1-555-0123', '/images/moonlight_logo.png', '/images/moonlight_thumb.png', 2)
ON DUPLICATE KEY UPDATE
    placeName = VALUES(placeName),
    placeDescription = VALUES(placeDescription),
    placeRating = VALUES(placeRating),
    placeEmail = VALUES(placeEmail),
    placePhone = VALUES(placePhone),
    placeLogoPath = VALUES(placeLogoPath),
    placeThumbnailPath = VALUES(placeThumbnailPath),
    sellerID = VALUES(sellerID);
