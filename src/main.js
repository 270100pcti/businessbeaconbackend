
const mysql = require('mysql2')
const express = require('express');
const http = require('http');
const path = require('path');
const fs = require('fs');
const multer = require('multer');
const p = require('path');
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
    const placeId = req.get("placeId");
    if (placeId) {
        //comment
    } else {
        res.status(300).send('Missing placeId');
        return;
    }
    
    db.query(sql, [placeId], (err, results) => {
        if (err) {
            console.error('Error fetching data:', err);
            res.status(500).send('Error fetching data');
        } else {
            res.json(results);
        }
    });
})


app.get(/.*\.(svg|ico|png|jpg|jpeg|gif|webp)$/, (req, res) => {
    res.sendFile(path.join(__dirname, '../', req.path));
});





const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        const uploadDir = './uploads/images/places';

        
        if (!fs.existsSync(uploadDir)) {
            fs.mkdirSync(uploadDir, { recursive: true });
        }
        cb(null, uploadDir);
    },
    filename: function (req, file, cb) {
        // Generate unique filename
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
    }
});

// File filter to only accept images
const fileFilter = (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|gif|webp/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);
    
    if (mimetype && extname) {
        return cb(null, true);
    } else {
        cb(new Error('Only image files are allowed!'));
    }
};

// Initialize multer
const upload = multer({
    storage: storage,
    limits: { fileSize: 5 * 1024 * 1024 }, // 5MB limit
    fileFilter: fileFilter
});

async function handleImagePaths(id, path, imageType) {
    if (!id) throw new Error('handleImagePaths: missing id');
    if (!path) throw new Error('handleImagePaths: missing path');
    if (!imageType) throw new Error('handleImagePaths: missing imageType');

    // ensure result has format "/images/<filename>"
    const filename = (typeof path === 'string') ? (() => {
        const idx = path.indexOf('/images/');
        if (idx !== -1) return path.slice(idx + '/images/'.length);
        return p.basename(path);
    })() : '';

    if (!filename) throw new Error('handleImagePaths: cannot determine filename from path');

    const normalized = '/images/' + filename.replace(/^\/+/, '');

    // --- // --- // // --- // --- // // --- // --- // // --- // --- // // --- // --- // 
    // Validate imageType to avoid SQL injection
    const allowedImageCols = ['placeLogoPath', 'placeThumbnailPath'];
    if (!allowedImageCols.includes(imageType)) {
        throw new Error('handleImagePaths: invalid imageType');
    }

    // Query the DB for the requested image column for this id
    let imagePath = "";
    const sql = `SELECT \`${imageType}\` AS imgpath FROM places WHERE id = ?`;
    const results = await new Promise((resolve, reject) => {
        db.query(sql, [id], (err, rows) => {
            console.log(rows);
            console.log(rows[0].imgpath);
            imagePath = rows[0].imgpath;
            if (err) return reject(err);
            resolve(rows);
        });
    });
    function setNewImagePathSQL(id, newPath) {
    const updateSql = `UPDATE places SET\`${imageType}\` = ? WHERE id = ?`;
    db.query(updateSql, [newPath, id], (err, updateResult) => {
        if (err) {
            console.error('Error updating path of image:', err);
            res.status(500).send('Error updating path of image- ERR 1X002');
            return;
        } else {
            console.log("Updatd the value of the image path");
        }
    });

    }
    if (imagePath) {
        //if it exists do this
        try {
            const row = results && results[0];
            const dbImg = row ? row.imgpath : null;
            if (dbImg) {
                const idx = dbImg.indexOf('/images/');
                const filename = (idx !== -1) ? dbImg.slice(idx + '/images/'.length) : p.basename(dbImg);
                const uploadsDir = p.join(__dirname, '..', 'uploads', 'images', 'places');
                const fullPath = p.join(uploadsDir, filename);

                if (fs.existsSync("./"+imagePath)) {
                    await fs.promises.unlink("./"+imagePath);
                    console.log('Deleted old image:', "./"+imagePath);
                } else {
                    console.log('Old image not found, skipping delete:', fullPath);
                }
                setNewImagePathSQL(id, path);
            }
        } catch (err) {
            console.error('Error deleting old image:', err);
        }
    } else {
        setNewImagePathSQL(id, path);
        // no value
    }

    // const dbRow = results && results[0];
    // const dbPath = dbRow ? dbRow.imgpath : null;

    // // If DB has a value, normalize and return it; otherwise fall back to the provided path
    // if (dbPath) {
    //     const idx = dbPath.indexOf('/images/');
    //     const filenameFromDb = (idx !== -1) ? dbPath.slice(idx + '/images/'.length) : p.basename(dbPath);
    //     const finalNormalized = '/images/' + filenameFromDb.replace(/^\/+/, '');
    //     return { id, path: finalNormalized };
    // }

    // If no DB value, keep the already-computed normalized path
    // (outer return will also return normalized if this block isn't reached)

    // --- // --- //
    return { id, path: normalized };
}

// SINGLE FILE UPLOAD
app.post('/api/uploadImage', upload.single('image'), (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ error: 'No file uploaded' });
        }
        
        
        
        // Extract id and imageType from request body
        const { id, imageType } = req.body;
        
        handleImagePaths(id, req.file.path, imageType);
        

        res.status(200).json({
            message: 'File uploaded successfully',
            file: {
                filename: req.file.filename,
                originalname: req.file.originalname,
                mimetype: req.file.mimetype,
                size: req.file.size,
                path: req.file.path
            },
            id: id,
            imageType: imageType
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});