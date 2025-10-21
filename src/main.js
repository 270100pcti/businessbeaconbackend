
const mysql = require('mysql2')
const express = require('express');
const http = require('http');
const app = express();
const server = http.createServer(app);

const PORT = process.env.PORT || 3000;

app.get('/api/getData', (req, res) => {
    res.status(200).send({
        type: 'a lot of big',
        size: 'huge'
    });
});

server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});




const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    database: process.env.DATABASE_NAME
})

app.post('/api/uploadBusiness', (req, res) => {
    const req_json = req.body;
    const businessName = req_json.businessName;
    const businessAddress = req_json.businessAddress;
    const businessPhone = req_json.businessPhone;
    const businessEmail = req_json.businessEmail;

    const sql = 'INSERT INTO sellers (businessName, businessAddress, businessPhone, businessEmail) VALUES (?, ?, ?, ?)';
    const values = [businessName, businessAddress, businessPhone, businessEmail];

    db.query(sql, values, (err, result) => {
        if (err) {
            console.error('Error inserting data:', err);
            res.status(500).send('Error inserting data');
        } else {
            res.send(200);
        }
    });
})

app.get('/api/getBusinesses', (req, res) => {
    const sql = 'SELECT * FROM sellers';

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching data:', err);
            res.status(500).send('Error fetching data');
        } else {
            res.json(results);
        }
    });
})

app.get("/api/storePage", (req, res) => {
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
