// Farid Dhiya Fairuz - 247006111058 - B
const express = require('express');
const router = express.Router();
const NovelController = require('../controllers/novelController');
const authMiddleware = require('../middleware/authMiddleware');

router.use(authMiddleware);
router.get('/', NovelController.getAll);
router.get('/:id', NovelController.getById);
router.post('/', NovelController.create);
router.put('/:id', NovelController.update);
router.delete('/:id', NovelController.delete);

module.exports = router;
