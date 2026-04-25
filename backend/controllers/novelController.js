// Farid Dhiya Fairuz
// 247006111058
// B

const NovelModel = require('../models/novelModel');

const NovelController = {
  getAll: async (req, res) => {
    try {
      const novels = await NovelModel.findAll();
      return res.status(200).json({ message: 'Data novel berhasil diambil.', data: novels });
    } catch (error) {
      return res.status(500).json({ message: 'Terjadi kesalahan pada server.', data: null });
    }
  },

  getById: async (req, res) => {
    try {
      const novel = await NovelModel.findById(req.params.id);
      if (!novel) return res.status(404).json({ message: 'Novel tidak ditemukan.', data: null });
      return res.status(200).json({ message: 'Detail novel berhasil diambil.', data: novel });
    } catch (error) {
      return res.status(500).json({ message: 'Terjadi kesalahan pada server.', data: null });
    }
  },

  create: async (req, res) => {
    try {
      const { title, author, genre, chapters, rating } = req.body;
      if (!title || !author || !genre)
        return res.status(400).json({ message: 'Title, author, dan genre wajib diisi.', data: null });

      if (chapters !== undefined && (isNaN(chapters) || chapters < 0))
        return res.status(400).json({ message: 'Jumlah chapters harus berupa angka positif.', data: null });

      if (rating !== undefined && (isNaN(rating) || rating < 0 || rating > 10))
        return res.status(400).json({ message: 'Rating harus berupa angka antara 0 dan 10.', data: null });

      const novelId = await NovelModel.create({ title, author, genre, chapters: chapters || 0, rating: rating || 0.0 });
      const newNovel = await NovelModel.findById(novelId);
      return res.status(201).json({ message: 'Novel berhasil ditambahkan.', data: newNovel });
    } catch (error) {
      return res.status(500).json({ message: 'Terjadi kesalahan pada server.', data: null });
    }
  },

  update: async (req, res) => {
    try {
      const { id } = req.params;
      const { title, author, genre, chapters, rating } = req.body;
      const existing = await NovelModel.findById(id);
      if (!existing) return res.status(404).json({ message: 'Novel tidak ditemukan.', data: null });
      if (!title || !author || !genre)
        return res.status(400).json({ message: 'Title, author, dan genre wajib diisi.', data: null });

      await NovelModel.update(id, {
        title, author, genre,
        chapters: chapters || existing.chapters,
        rating: rating !== undefined ? rating : existing.rating,
      });
      const updated = await NovelModel.findById(id);
      return res.status(200).json({ message: 'Novel berhasil diupdate.', data: updated });
    } catch (error) {
      return res.status(500).json({ message: 'Terjadi kesalahan pada server.', data: null });
    }
  },

  delete: async (req, res) => {
    try {
      const { id } = req.params;
      const existing = await NovelModel.findById(id);
      if (!existing) return res.status(404).json({ message: 'Novel tidak ditemukan.', data: null });
      await NovelModel.delete(id);
      return res.status(200).json({ message: 'Novel berhasil dihapus.', data: { id: parseInt(id) } });
    } catch (error) {
      return res.status(500).json({ message: 'Terjadi kesalahan pada server.', data: null });
    }
  },
};

module.exports = NovelController;
