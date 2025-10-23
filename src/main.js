
const mysql = require('mysql2')
const express = require('express');
const http = require('http');
const path = require('path');
const fs = require('fs');
const app = express();
app.use(express.json());
const server = http.createServer(app);

const PORT = 2929;


server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});




const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
})

app.post('/api/uploadBusiness', (req, res) => {

    // [Outdated] placeName, placeAddress, placeDescription, placeRating, placeEmail, placePhone, placeLogoPath, placeThumbnailPath, sellerID
    const req_json = req.body;
    const placeName = req_json.placeName;
    const placeAddress = req_json.placeAddress;
    const placeDescription = req_json.placeDescription;
    const placeEmail = req_json.placeEmail;
    const placePhone = req_json.placePhone;

    const sellerID = req_json.sellerID;

    

    const sql = 'INSERT INTO places (placeName, placeAddress, placeDescription, placeEmail, placePhone, totalOfReviews, countOfReviews, sellerID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)';
    const values = [placeName, placeAddress, placeDescription, placeEmail, placePhone, 0, 0, sellerID];
    //Create DB item
    db.query(sql, values, (err, result) => {
        
        if (err) {
            console.error('Error inserting data:', err);
            res.status(500).send('Error inserting data - ERR 0X001');
        } else {
            res.sendStatus(200)
            console.log("Insterted data:");
            console.log(result["insertId"]);
        }
    });
})

app.post('/api/uploadReview', (req, res) => {

    
    const req_json = req.body;
    const placeId = req_json.placeId;
    const review = req_json.review;
    const rating = req_json.rating;
    const creator = req_json.creator;

    const updateSql = 'UPDATE places SET countOfReviews = countOfReviews + 1, totalOfReviews = totalOfReviews + ? WHERE id = ?';
    db.query(updateSql, [rating, placeId], (err, updateResult) => {
        if (err) {
            console.error('Error updating place data:', err);
            res.status(500).send('Error updating place data - ERR 0X002');
            return;
        }
        

        const insertSql = 'INSERT INTO reviews (review, rating, creator, placeId) VALUES (?, ?, ?, ?)';
        db.query(insertSql, [review, rating, creator, placeId], (err, insertResult) => {
            if (err) {
                console.error('Error inserting review:', err);
                res.status(500).send('Error inserting review - ERR 0X003');
                return;
            }
            
            res.sendStatus(200);
            console.log("Added review for place ID:", placeId);
        });
    });
})

app.get('/api/getBusinesses', (req, res) => {
    const sql = 'SELECT * FROM places';

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching data:', err);
            res.status(500).send('Error fetching data');
        } else {
            res.json(results);
        }
    });
})

app.get("/api/getStorePage", (req, res) => {
    const sql = 'SELECT * FROM places WHERE id = ?';
    const req_json = req.headers;
    const placeId = req.get("placeId")
    
    db.query(sql, [placeId], (err, results) => {
        if (err) {
            console.error('Error fetching data:', err);
            res.status(500).send('Error fetching data');
        } else {
            res.json(results);
        }
    });
})


app.get(/.*\.(svg|ico|png)$/, (req, res) => {
  res.sendFile(path.join(__dirname, '../uploads/places/logos', req.path));
});