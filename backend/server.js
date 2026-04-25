// Farid Dhiya Fairuz
// 247006111058
// B

const express = require('express');
const cors = require('cors');
require('dotenv').config();

const authRoutes = require('./routes/authRoutes');
const novelRoutes = require('./routes/novelRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors({ origin: '*', methods: ['GET', 'POST', 'PUT', 'DELETE'], allowedHeaders: ['Content-Type', 'Authorization'] }));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
  res.status(200).json({
    message: 'RidNovel API berjalan dengan baik 📚',
    data: { version: '1.0.0', endpoints: { auth: '/register, /login, /logout', novels: '/novels (GET, POST), /novels/:id (GET, PUT, DELETE)' } },
  });
});

app.use('/', authRoutes);
app.use('/novels', novelRoutes);

app.use((req, res) => res.status(404).json({ message: 'Endpoint tidak ditemukan.', data: null }));
app.use((err, req, res, next) => res.status(500).json({ message: 'Terjadi kesalahan internal pada server.', data: null }));

app.listen(PORT, () => console.log(`🚀 RidNovel API berjalan di http://localhost:${PORT}`));
