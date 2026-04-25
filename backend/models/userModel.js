// Farid Dhiya Fairuz
// 247006111058
// B

const db = require('../config/db');

const UserModel = {
  findByEmail: async (email) => {
    const [rows] = await db.execute('SELECT * FROM users WHERE email = ?', [email]);
    return rows[0] || null;
  },
  findByUsername: async (username) => {
    const [rows] = await db.execute('SELECT * FROM users WHERE username = ?', [username]);
    return rows[0] || null;
  },
  findById: async (id) => {
    const [rows] = await db.execute('SELECT id, username, email, created_at FROM users WHERE id = ?', [id]);
    return rows[0] || null;
  },
  create: async ({ username, email, password }) => {
    const [result] = await db.execute(
      'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
      [username, email, password]
    );
    return result.insertId;
  },
};

module.exports = UserModel;
