
const mysql = require('mysql2')
const express = require('express');
const http = require('http');
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

    //placeName, placeAddress, placeDescription, placeRating, placeEmail, placePhone, placeLogoPath, placeThumbnailPath, sellerID
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
    const sql = 'SELECT * FROM sellers WHERE id = ?';
    const businessId = req.query.id;
    
    db.query(sql, [businessId], (err, results) => {
        if (err) {
            console.error('Error fetching data:', err);
            res.status(500).send('Error fetching data');
        } else {
            res.json(results);
        }
    });
})
