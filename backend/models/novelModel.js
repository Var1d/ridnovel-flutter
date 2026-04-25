// Farid Dhiya Fairuz
// 247006111058
// B

const db = require('../config/db');

const NovelModel = {
  findAll: async () => {
    const [rows] = await db.execute('SELECT * FROM novels ORDER BY created_at DESC');
    return rows;
  },
  findById: async (id) => {
    const [rows] = await db.execute('SELECT * FROM novels WHERE id = ?', [id]);
    return rows[0] || null;
  },
  create: async ({ title, author, genre, chapters, rating }) => {
    const [result] = await db.execute(
      'INSERT INTO novels (title, author, genre, chapters, rating) VALUES (?, ?, ?, ?, ?)',
      [title, author, genre, chapters, rating]
    );
    return result.insertId;
  },
  update: async (id, { title, author, genre, chapters, rating }) => {
    const [result] = await db.execute(
      'UPDATE novels SET title = ?, author = ?, genre = ?, chapters = ?, rating = ? WHERE id = ?',
      [title, author, genre, chapters, rating, id]
    );
    return result.affectedRows;
  },
  delete: async (id) => {
    const [result] = await db.execute('DELETE FROM novels WHERE id = ?', [id]);
    return result.affectedRows;
  },
};

module.exports = NovelModel;
