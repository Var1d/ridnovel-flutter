-- ================================================
-- Farid Dhiya Fairuz
-- 247006111058
-- B
-- RidNovel Management System - Database Setup
-- ================================================

CREATE DATABASE IF NOT EXISTS webnovel_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE webnovel_db;

CREATE TABLE IF NOT EXISTS users (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  username    VARCHAR(50)  NOT NULL UNIQUE,
  email       VARCHAR(100) NOT NULL UNIQUE,
  password    VARCHAR(255) NOT NULL,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS novels (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  title       VARCHAR(200) NOT NULL,
  author      VARCHAR(100) NOT NULL,
  genre       VARCHAR(100) NOT NULL,
  chapters    INT          DEFAULT 0,
  rating      FLOAT        DEFAULT 0.0,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO novels (title, author, genre, chapters, rating) VALUES
  ('Solo Leveling', 'Chugong', 'Action / Fantasy', 179, 9.5),
  ('Omniscient Reader', 'Sing Shong', 'Fantasy / Adventure', 551, 9.7),
  ('The Beginning After The End', 'TurtleMe', 'Fantasy / Isekai', 420, 9.2),
  ('Shadow Slave', 'Guiltythree', 'Dark Fantasy', 1200, 9.4),
  ('Reincarnation of the Suicidal Battle God', 'Cheol Jonghun', 'Action / Fantasy', 360, 8.8);

SELECT 'Database berhasil dibuat!' AS status;
SHOW TABLES;
