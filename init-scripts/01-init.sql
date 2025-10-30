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
    placeDescription VARCHAR(600),
    placeRating DOUBLE NOT NULL DEFAULT 5 CHECK (placeRating >= 1 AND placeRating <= 10),
    placeEmail VARCHAR(100),
    placePhone VARCHAR(20),
    placeLogoPath VARCHAR(255),
    placeThumbnailPath VARCHAR(255),

    totalOfReviews VARCHAR(50) NOT NULL DEFAULT 0,
    countOfReviews VARCHAR(50) NOT NULL DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    sellerID INT NOT NULL,
    FOREIGN KEY (sellerID) REFERENCES sellers(id) ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE IF NOT EXISTS analytics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dataType VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    placeID INT NOT NULL,
    FOREIGN KEY (placeID) REFERENCES places(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    review VARCHAR(600) NOT NULL,
    rating VARCHAR(10) NOT NULL,
    creator VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    placeID INT NOT NULL,
    FOREIGN KEY (placeID) REFERENCES places(id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO sellers (username, email) VALUES 
    ('admin', 'admin@example.com'),
    ('testuser', 'test@example.com')
ON DUPLICATE KEY UPDATE username=username;


INSERT INTO places (placeName, placeAddress, placeDescription, placeRating, placeEmail, placePhone, placeLogoPath, placeThumbnailPath, sellerID) VALUES
    ('Sunrise Cafe', '123 Main St, Springfield', 'Cozy cafe serving breakfast and specialty coffee.', 8.5, 'contact@sunrisecafe.example.com', '+1-555-0100', 'uploads/images/places/image-1761596210054-755960422.jpg', '/images/sunrise_thumb.png', 1),
    ('Moonlight Lounge', '456 Oak Ave, Springfield', 'Late-night lounge with live music and cocktails.', 9.2, 'hello@moonlight.example.com', '+1-555-0123', 'uploads/images/places/image-1761596214231-425349978.jpg', '/images/moonlight_thumb.png', 2),
    ('Green Leaf Deli', '789 Elm St, Springfield', 'Fresh sandwiches and salads made daily.', 8.1, 'info@greenleafdeli.com', '+1-555-0145', 'uploads/images/places/image-1.jpg', '/images/greenleaf_thumb.png', 1),
    ('Corner Bookstore', '101 Maple Rd, Springfield', 'Independent bookstore with a cozy reading nook.', 9.0, 'hello@cornerbookstore.com', '+1-555-0156', 'uploads/images/places/image-2.jpg', '/images/cornerbookstore_thumb.png', 2),
    ('Bella Pizzeria', '202 Pine St, Springfield', 'Family-owned pizzeria serving wood-fired pizzas.', 8.7, 'order@bellapizzeria.com', '+1-555-0167', 'uploads/images/places/image-3.jpg', '/images/bellapizzeria_thumb.png', 1),
    ('Sunset Yoga Studio', '303 Cedar Ave, Springfield', 'Yoga classes for all levels in a peaceful studio.', 9.3, 'contact@sunsetyoga.com', '+1-555-0178', 'uploads/images/places/image-4.jpg', '/images/sunsetyoga_thumb.png', 2),
    ('Sprout Grocery', '404 Birch Blvd, Springfield', 'Organic produce and local goods.', 8.9, 'info@sproutgrocery.com', '+1-555-0189', 'uploads/images/places/image-5.jpg', '/images/sproutgrocery_thumb.png', 1),
    ('Fix-It Hardware', '505 Walnut St, Springfield', 'Neighborhood hardware store with expert advice.', 8.2, 'support@fixithardware.com', '+1-555-0190', 'uploads/images/places/image-6.jpg', '/images/fixithardware_thumb.png', 2),
    ('Bluebird Bakery', '606 Chestnut Ln, Springfield', 'Artisan breads and pastries baked fresh daily.', 9.1, 'hello@bluebirdbakery.com', '+1-555-0201', 'uploads/images/places/image-7.jpg', '/images/bluebirdbakery_thumb.png', 1),
    ('Happy Trails Bike Shop', '707 Willow Dr, Springfield', 'Bicycle sales, repairs, and rentals.', 8.6, 'info@happytrailsbikes.com', '+1-555-0212', 'uploads/images/places/image-8.jpg', '/images/happytrails_thumb.png', 2),
    ('Little Sprouts Preschool', '808 Poplar Ct, Springfield', 'Early childhood education with caring teachers.', 9.4, 'contact@littlesproutspreschool.com', '+1-555-0223', 'uploads/images/places/image-9.jpg', '/images/littlesprouts_thumb.png', 1),
    ('The Paint Palette', '909 Aspen Way, Springfield', 'Art supplies and painting workshops.', 8.8, 'info@paintpalette.com', '+1-555-0234', 'uploads/images/places/image-10.jpg', '/images/paintpalette_thumb.png', 2),
    ('Fresh Cuts Barbershop', '111 Oak St, Springfield', 'Classic and modern haircuts for all ages.', 8.5, 'hello@freshcutsbarbershop.com', '+1-555-0245', 'uploads/images/places/image-11.jpg', '/images/freshcuts_thumb.png', 1),
    ('Harmony Music School', '222 Pine Ave, Springfield', 'Private and group music lessons.', 9.2, 'info@harmonymusicschool.com', '+1-555-0256', 'uploads/images/places/image-12.jpg', '/images/harmony_thumb.png', 2),
    ('Petal Pushers Florist', '333 Cedar St, Springfield', 'Beautiful floral arrangements for any occasion.', 8.9, 'contact@petalpushers.com', '+1-555-0267', 'uploads/images/places/image-13.jpg', '/images/petalpushers_thumb.png', 1),
    ('Taste of Thai', '444 Birch Rd, Springfield', 'Authentic Thai cuisine in a welcoming setting.', 9.0, 'order@tasteofthai.com', '+1-555-0278', 'uploads/images/places/image-14.jpg', '/images/tasteofthai_thumb.png', 2),
    ('Sunny Side Laundromat', '555 Walnut Ave, Springfield', 'Clean, modern laundromat with free Wi-Fi.', 8.3, 'info@sunnysidelaundromat.com', '+1-555-0289', 'uploads/images/places/image-15.jpg', '/images/sunnyside_thumb.png', 1),
    ('The Gadget Garage', '666 Chestnut St, Springfield', 'Electronics repair and accessories.', 8.7, 'support@gadgetgarage.com', '+1-555-0290', 'uploads/images/places/image-16.jpg', '/images/gadgetgarage_thumb.png', 2),
    ('Maple Family Dental', '777 Willow Ave, Springfield', 'Friendly dental care for the whole family.', 9.1, 'hello@mapledental.com', '+1-555-0301', 'uploads/images/places/image-17.jpg', '/images/mapledental_thumb.png', 1),
    ('Springfield Pet Clinic', '888 Poplar St, Springfield', 'Compassionate veterinary services.', 9.3, 'info@springfieldpetclinic.com', '+1-555-0312', 'uploads/images/places/image-18.jpg', '/images/petclinic_thumb.png', 2),
    ('The Cozy Nook Cafe', '999 Aspen Blvd, Springfield', 'Homemade soups, sandwiches, and desserts.', 8.6, 'contact@cozynookcafe.com', '+1-555-0323', 'uploads/images/places/image-19.jpg', '/images/cozynook_thumb.png', 1),
    ('Urban Roots Garden Center', '121 Oak Ct, Springfield', 'Plants, gardening supplies, and expert advice.', 8.9, 'info@urbanroots.com', '+1-555-0334', 'uploads/images/places/image-20.jpg', '/images/urbanroots_thumb.png', 2),
    ('The Frame Shop', '232 Pine St, Springfield', 'Custom framing for art, photos, and memorabilia.', 8.7, 'hello@frameshop.com', '+1-555-0345', 'uploads/images/places/image-21.jpg', '/images/frameshop_thumb.png', 1),
    ('Sweet Tooth Candy Store', '343 Cedar Ave, Springfield', 'Classic and modern candies for all ages.', 9.0, 'info@sweettooth.com', '+1-555-0356', 'uploads/images/places/image-22.jpg', '/images/sweettooth_thumb.png', 2),
    ('The Running Store', '454 Birch Blvd, Springfield', 'Running shoes, apparel, and accessories.', 8.8, 'contact@runningstore.com', '+1-555-0367', 'uploads/images/places/image-23.jpg', '/images/runningstore_thumb.png', 1),
    ('Sunshine Day Spa', '565 Walnut Rd, Springfield', 'Relaxing massages and spa treatments.', 9.2, 'info@sunshinedayspa.com', '+1-555-0378', 'uploads/images/places/image-24.jpg', '/images/sunshinedayspa_thumb.png', 2),
    ('The Local Butcher', '676 Chestnut Ave, Springfield', 'Fresh meats and specialty cuts.', 8.9, 'hello@localbutcher.com', '+1-555-0389', 'uploads/images/places/image-25.jpg', '/images/localbutcher_thumb.png', 1),
    ('Springfield Cycle Works', '787 Willow St, Springfield', 'Bike repairs and custom builds.', 8.6, 'info@cycleworks.com', '+1-555-0390', 'uploads/images/places/image-26.jpg', '/images/cycleworks_thumb.png', 2),
    ('The Tea Room', '898 Poplar Ave, Springfield', 'Loose leaf teas and afternoon tea service.', 9.1, 'contact@tearoom.com', '+1-555-0401', 'uploads/images/places/image-27.jpg', '/images/tearoom_thumb.png', 1),
    ('Fresh Start Fitness', '909 Aspen Ct, Springfield', 'Personal training and group fitness classes.', 8.7, 'info@freshstartfitness.com', '+1-555-0412', 'uploads/images/places/image-28.jpg', '/images/freshstart_thumb.png', 2),
    ('The Dog House Grooming', '123 Oak Blvd, Springfield', 'Professional pet grooming and spa.', 9.0, 'hello@doghousegrooming.com', '+1-555-0423', 'uploads/images/places/image-29.jpg', '/images/doghouse_thumb.png', 1),
    ('Springfield Art Gallery', '234 Pine Ave, Springfield', 'Local and regional art exhibitions.', 9.3, 'info@springfieldartgallery.com', '+1-555-0434', 'uploads/images/places/image-30.jpg', '/images/artgallery_thumb.png', 2),
    ('The Spice Market', '345 Cedar St, Springfield', 'Exotic spices and gourmet ingredients.', 8.8, 'contact@spicemarket.com', '+1-555-0445', 'uploads/images/places/image-31.jpg', '/images/spicemarket_thumb.png', 1),
    ('Happy Feet Shoe Store', '456 Birch Rd, Springfield', 'Comfortable shoes for every occasion.', 8.9, 'info@happyfeet.com', '+1-555-0456', 'uploads/images/places/image-32.jpg', '/images/happyfeet_thumb.png', 2),
    ('The Vintage Vault', '567 Walnut Ave, Springfield', 'Antiques, collectibles, and vintage finds.', 9.0, 'hello@vintagevault.com', '+1-555-0467', 'uploads/images/places/image-33.jpg', '/images/vintagevault_thumb.png', 1),
    ('Springfield Martial Arts', '678 Chestnut St, Springfield', 'Karate, judo, and self-defense classes.', 8.7, 'info@springfieldmartialarts.com', '+1-555-0478', 'uploads/images/places/image-34.jpg', '/images/martialarts_thumb.png', 2),
    ('The Cookie Jar', '789 Willow Ave, Springfield', 'Fresh-baked cookies and treats.', 9.2, 'contact@cookiejar.com', '+1-555-0489', 'uploads/images/places/image-35.jpg', '/images/cookiejar_thumb.png', 1),
    ('Springfield Farmers Market', '890 Poplar St, Springfield', 'Local produce and handmade goods.', 9.4, 'info@springfieldfarmersmarket.com', '+1-555-0490', 'uploads/images/places/image-36.jpg', '/images/farmersmarket_thumb.png', 2),
    ('The Bike Barn', '901 Aspen Blvd, Springfield', 'Bikes, gear, and expert repairs.', 8.6, 'hello@bikebarn.com', '+1-555-0501', 'uploads/images/places/image-37.jpg', '/images/bikebarn_thumb.png', 1),
    ('Springfield Brew House', '112 Oak St, Springfield', 'Craft beers and brewery tours.', 9.1, 'info@springfieldbrewhouse.com', '+1-555-0512', 'uploads/images/places/image-38.jpg', '/images/brewhouse_thumb.png', 2),
    ('The Little Library', '223 Pine Ave, Springfield', 'Childrens books and storytime events.', 8.9, 'contact@littlelibrary.com', '+1-555-0523', 'uploads/images/places/image-39.jpg', '/images/littlelibrary_thumb.png', 1),
    ('Springfield Auto Care', '334 Cedar St, Springfield', 'Reliable auto repair and maintenance.', 8.7, 'info@springfieldautocare.com', '+1-555-0534', 'uploads/images/places/image-40.jpg', '/images/autocare_thumb.png', 2),
    ('The Pasta House', '445 Birch Rd, Springfield', 'Homemade pasta and Italian specialties.', 9.0, 'order@pastahouse.com', '+1-555-0545', 'uploads/images/places/image-41.jpg', '/images/pastahouse_thumb.png', 1),
    ('Springfield Print Shop', '556 Walnut Ave, Springfield', 'Printing, copying, and graphic design.', 8.8, 'hello@printshop.com', '+1-555-0556', 'uploads/images/places/image-42.jpg', '/images/printshop_thumb.png', 2),
    ('The Toy Chest', '667 Chestnut St, Springfield', 'Toys, games, and puzzles for all ages.', 9.1, 'info@toychest.com', '+1-555-0567', 'uploads/images/places/image-43.jpg', '/images/toychest_thumb.png', 1),
    ('Springfield Dance Studio', '778 Willow Ave, Springfield', 'Dance classes for kids and adults.', 8.9, 'contact@springfielddance.com', '+1-555-0578', 'uploads/images/places/image-44.jpg', '/images/dancestudio_thumb.png', 2),
    ('The Juice Bar', '889 Poplar St, Springfield', 'Fresh juices and smoothies.', 8.7, 'info@juicebar.com', '+1-555-0589', 'uploads/images/places/image-45.jpg', '/images/juicebar_thumb.png', 1),
    ('Springfield Locksmith', '990 Aspen Blvd, Springfield', 'Locksmith services and key cutting.', 8.6, 'hello@springfieldlocksmith.com', '+1-555-0590', 'uploads/images/places/image-46.jpg', '/images/locksmith_thumb.png', 2),
    ('The Craft Corner', '123 Oak Ct, Springfield', 'Craft supplies and DIY workshops.', 9.0, 'info@craftcorner.com', '+1-555-0601', 'uploads/images/places/image-47.jpg', '/images/craftcorner_thumb.png', 1),
    ('Springfield Eye Care', '234 Pine St, Springfield', 'Optometry and eyewear.', 9.2, 'contact@springfieldeyecare.com', '+1-555-0612', 'uploads/images/places/image-48.jpg', '/images/eyecare_thumb.png', 2),
    ('The Burger Joint', '345 Cedar Ave, Springfield', 'Gourmet burgers and fries.', 8.8, 'order@burgerjoint.com', '+1-555-0623', 'uploads/images/places/image-49.jpg', '/images/burgerjoint_thumb.png', 1),
    ('Springfield Tailor Shop', '456 Birch Blvd, Springfield', 'Custom tailoring and alterations.', 8.9, 'info@tailorshop.com', '+1-555-0634', 'uploads/images/places/image-50.jpg', '/images/tailorshop_thumb.png', 2)
ON DUPLICATE KEY UPDATE
    placeName = VALUES(placeName),
    placeDescription = VALUES(placeDescription),
    placeRating = VALUES(placeRating),
    placeEmail = VALUES(placeEmail),
    placePhone = VALUES(placePhone),
    placeLogoPath = VALUES(placeLogoPath),
    placeThumbnailPath = VALUES(placeThumbnailPath),
    sellerID = VALUES(sellerID);
