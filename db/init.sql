-- db/init.sql
-- ATUALIZADO: Adicionado a definição de charset na criação da tabela

-- Seleciona a base de dados que criámos no docker-compose
USE `colecao_db`;

-- Cria a tabela 'itens' usando backticks para todos os identificadores
-- e definindo o conjunto de caracteres padrão para utf8mb4.
CREATE TABLE IF NOT EXISTS `itens` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `tipo` VARCHAR(50) NOT NULL,
    `titulo_portugues` VARCHAR(255) NOT NULL,
    `titulo_original` VARCHAR(255),
    `autor` VARCHAR(255),
    `desenhista` VARCHAR(255),
    `isbn` VARCHAR(50),
    `editora` VARCHAR(100),
    `ano` INT,
    `idioma` VARCHAR(50),
    `edicao` VARCHAR(50),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inserindo alguns dados de exemplo da sua folha de cálculo de livros
INSERT INTO `itens` (`tipo`, `titulo_portugues`, `titulo_original`, `autor`, `isbn`, `editora`, `ano`, `idioma`, `edicao`) VALUES
('livro', 'O Espadachim de Carvão', 'O Espadachim de Carvão', 'Affonso Solano', '978-85-7734-334-8', 'Casa da Palavra / Leya', 2013, 'Português', NULL),
('livro', 'Guerra Civil', 'Civil War', 'Stuart Moore', '978-85-428-0412-6', 'Marvel', 2014, 'Português', NULL),
('livro', 'Me poupe! 10 passos para nunca mais faltar dinheiro no seu bolso', 'Me poupe! 10 passos para nunca mais faltar dinheiro no seu bolso', 'Nathalia Arcuri', '978-85-431-0581-9', 'Sextante', 2018, 'Português', NULL);

-- Inserindo alguns dados de exemplo da sua folha de cálculo de banda desenhada
INSERT INTO `itens` (`tipo`, `titulo_portugues`, `titulo_original`, `autor`, `desenhista`, `isbn`, `editora`, `ano`, `idioma`, `edicao`) VALUES
('gibi', 'Dragon Ball', 'Dragon Ball', 'Akira Toryama', 'Akira Toryama', '7897653516940', 'Panini', 2013, 'Português', '20');
