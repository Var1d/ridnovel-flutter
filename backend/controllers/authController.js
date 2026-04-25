// Farid Dhiya Fairuz
// 247006111058
// B

const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const UserModel = require('../models/userModel');
require('dotenv').config();

const AuthController = {
  register: async (req, res) => {
    try {
      const { username, email, password } = req.body;
      if (!username || !email || !password)
        return res.status(400).json({ message: 'Username, email, dan password wajib diisi.', data: null });

      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email))
        return res.status(400).json({ message: 'Format email tidak valid.', data: null });

      if (password.length < 6)
        return res.status(400).json({ message: 'Password minimal 6 karakter.', data: null });

      if (await UserModel.findByEmail(email))
        return res.status(409).json({ message: 'Email sudah terdaftar.', data: null });

      if (await UserModel.findByUsername(username))
        return res.status(409).json({ message: 'Username sudah digunakan.', data: null });

      const saltRounds = parseInt(process.env.BCRYPT_SALT_ROUNDS) || 10;
      const hashedPassword = await bcrypt.hash(password, saltRounds);
      const userId = await UserModel.create({ username, email, password: hashedPassword });

      return res.status(201).json({ message: 'Registrasi berhasil.', data: { id: userId, username, email } });
    } catch (error) {
      return res.status(500).json({ message: 'Terjadi kesalahan pada server.', data: null });
    }
  },

  login: async (req, res) => {
    try {
      const { email, password } = req.body;
      if (!email || !password)
        return res.status(400).json({ message: 'Email dan password wajib diisi.', data: null });

      const user = await UserModel.findByEmail(email);
      if (!user)
        return res.status(401).json({ message: 'Email atau password salah.', data: null });

      const isValid = await bcrypt.compare(password, user.password);
      if (!isValid)
        return res.status(401).json({ message: 'Email atau password salah.', data: null });

      const token = jwt.sign(
        { id: user.id, username: user.username, email: user.email },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN || '24h' }
      );

      return res.status(200).json({
        message: 'Login berhasil.',
        data: { token, user: { id: user.id, username: user.username, email: user.email } },
      });
    } catch (error) {
      return res.status(500).json({ message: 'Terjadi kesalahan pada server.', data: null });
    }
  },

  logout: async (req, res) => {
    return res.status(200).json({ message: 'Logout berhasil. Silakan hapus token di sisi client.', data: null });
  },
};

module.exports = AuthController;
