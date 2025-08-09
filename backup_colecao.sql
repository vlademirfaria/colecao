-- MySQL dump 10.13  Distrib 8.0.43, for Linux (x86_64)
--
-- Host: localhost    Database: colecao_db
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


drop database if exists `colecao_db`;
create database if not exists `colecao_db`;
USE `colecao_db`;
--
-- Table structure for table `itens`
--

DROP TABLE IF EXISTS `itens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `itens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `titulo_portugues` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `titulo_original` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `autor` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `desenhista` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isbn` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `editora` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ano` int DEFAULT NULL,
  `idioma` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `edicao` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itens`
--

LOCK TABLES `itens` WRITE;
/*!40000 ALTER TABLE `itens` DISABLE KEYS */;
INSERT INTO `itens` VALUES (1,'livro','O Espadachim de Carvão','O Espadachim de Carvão','Affonso Solano',NULL,'978-85-7734-334-8','Casa da Palavra / Leya',2013,'Português',NULL,'2025-08-04 23:19:30'),(2,'livro','Guerra Civil','Civil War','Stuart Moore',NULL,'978-85-428-0412-6','Marvel',2014,'Português',NULL,'2025-08-04 23:19:30'),(3,'livro','Me poupe! 10 passos para nunca mais faltar dinheiro no seu bolso','Me poupe! 10 passos para nunca mais faltar dinheiro no seu bolso','Nathalia Arcuri',NULL,'978-85-431-0581-9','Sextante',2018,'Português',NULL,'2025-08-04 23:19:30'),(4,'gibi','Dragon Ball','Dragon Ball','Akira Toryama','Akira Toryama','7897653516940','Panini',2013,'Português','20','2025-08-04 23:19:30'),(5,'livro','Latim em pó - Um passeio pela formação do nosso Português','Latim em pó - Um passeio pela formação do nosso Português','Caetano Waldrigues Galindo',NULL,'978-65-5921-353-5','Companhia das Letras',2022,'Português',NULL,'2025-08-04 23:48:18'),(6,'livro','O evangelho do exorcista - A roda de Deus','O evangelho do exorcista - A roda de Deus','Leonel Caldela',NULL,'978658863417-2','Nerd Books',2021,'Português','1','2025-08-04 23:49:17'),(7,'livro','O enigma do sol oculto','O enigma do sol oculto','Karen Soarele',NULL,'978658863419-6','Nerd Books',2022,'Português','1','2025-08-04 23:50:07'),(8,'livro','O evangelho do exorcista - O criador da morte','O evangelho do exorcista - O criador da morte','Leonel Caldela',NULL,'978658863418-9','Nerd Books',2022,'Português','1','2025-08-04 23:51:07'),(9,'livro','Zangado - O que é ser um gamer e como me tornei um','Zangado - O que é ser um gamer e como me tornei um','Zangado',NULL,'978-85-441-0462-0','Leya',2016,'Português',NULL,'2025-08-04 23:52:08'),(10,'livro','O Espadachim de Carvão e a voz do guardião cego','O Espadachim de Carvão e a voz do guardião cego','Affonso Solano',NULL,'978-65-5643-136-9','Leya',2021,'Português',NULL,'2025-08-04 23:53:19'),(11,'livro','O Espadachim de Carvão e as pontes de Puzur','O Espadachim de Carvão e as pontes de Puzur','Affonso Solano',NULL,'978-85-7734-568-7','Leya',2015,'Português',NULL,'2025-08-04 23:55:01'),(12,'gibi','V de Vingança','V for Vendeta','Alan Moore','David Lloyd','978-85-6548-410-7','Vertigo',2012,'Português',NULL,'2025-08-04 23:56:02'),(13,'gibi','Os sussurros do caos rastejante','Os sussurros do caos rastejante','Fábio Yabu','Fred Rubim [et al]','978658863416-5','Nerd Books',2022,'Português','1','2025-08-05 00:00:56'),(14,'livro','Ozob - Protocolo molotov','Ozob - Protocolo molotov','Daive Pazos; Leonel Caldela',NULL,'978-85-68295-03-8','Nerd Books',2015,'Português',NULL,'2025-08-05 00:05:28'),(15,'livro','Eu, Robô','I, Robot','Izzac Asimov',NULL,'978-85-7657-200-8','Aleph',2014,'Português',NULL,'2025-08-05 00:11:14'),(16,'livro','Sql guia prático','Sql pocket guide','Alice Zhao',NULL,'978-85-7522-831-9','O\'Reilly / Novatec',2024,'Português','4','2025-08-05 00:14:41'),(17,'livro','1984','1984','George Orwell',NULL,'978-85-359-1484-9','Companhia das Letras',2020,'Português',NULL,'2025-08-05 00:19:51'),(18,'livro','Mémorias póstumas de Brás Cubas','Mémorias póstumas de Brás Cubas','Machado de Assis',NULL,'978-85-943-1861-9','Principis',2019,'Português','3','2025-08-05 12:02:32'),(19,'livro','Darwin sem frescura','Darwin sem frescura','Pirula; Reinaldo José Lopes',NULL,'978-85-9508-469-8','Harper Collins',2019,'Português',NULL,'2025-08-05 12:05:05'),(20,'gibi','Maus','Maus','Art Spiegelman','Art Spiegelman','978-85-359-0628-8','Quadrinhos na Cia.',2009,'Português','21','2025-08-05 12:07:53'),(21,'livro','Do átomo ao buraco negro - Para descomplicar a astronomia','Do átomo ao buraco negro - Para descomplicar a astronomia','Schwarza',NULL,'978-85-422-1367-6','Outro Planeta',2018,'Português','4','2025-08-05 12:10:46'),(22,'livro','Arquitetura limpa : o guia do artesão para estrutura e design de software','Clean Architecture: A Craftsman\'s Guide to Software Structure and Design','Robert C. MARTIN',NULL,'978-85-508-0460-6','Alta Books',2019,'Português',NULL,'2025-08-05 22:37:28'),(23,'livro','Código Limpo - Habilidades Práticas do Agile Software','Clean Code: A Handbook of Agile Software Craftsmanship','Robert C. Martin',NULL,'978-85-7608-267-5','Alta Books',2009,'Português','1','2025-08-05 22:49:50'),(24,'livro','Programando em Go - Crie aplicações com a linguagem do Google','Programando em Go - Crie aplicações com a linguagem do Google',' Caio Filipini',NULL,'978-85-66250-49-7','Casa do código',2014,'Português',NULL,'2025-08-05 22:53:53'),(25,'livro','De volta para o futuro - Os bastidores da trilogia','We don\'t need roads: The making of The back to the future trilogy','Cassen Gaines',NULL,'978-85-66636-76-5','Darkside',2015,'Português',NULL,'2025-08-05 22:58:55'),(26,'livro','Desenvolvimento real de software - Um guia de projetos para fundamentos em java','Real-world software development','Raoul-Gabriel Urma; Richard Warburton',NULL,'978-65-5520-201-4','O\'Reilly / Alta Books',2021,'Português',NULL,'2025-08-05 23:06:56'),(27,'livro','Learning Go - An idiomatic approach to real-world go programming','Learning Go - An idiomatic approach to real-world go programming','Jon Bodner',NULL,'978-1-098-13929-2','O\'Reilly',2024,'Inglês','2','2025-08-05 23:10:50'),(28,'livro','Entendendo algoritmos : um guia ilustrado para programadores e outros curiosos','Grokking Algorithms: An illustrated guide for programmers and other curious people','Aditya Y. Bhargava',NULL,'978-85-7522-563-9','Novatec',2017,'Português','1','2025-08-05 23:15:59'),(29,'livro','The pragmatic programmer','The pragmatic programmer','David Thomas; Andrew Hunt',NULL,'978-0-13-595705-9','Pearson Addison-Wesley',2020,'Inglês','20th Anniversary edition','2025-08-06 22:26:18'),(30,'livro','Padrões de projetos - Soluções reutilizáveis de software orientado a objetos','Design Patterns: Elements of Reusable Object-Oriented Software ','Erich Gamma; Richard Helm; Ralph Johnson; John Vlissides',NULL,'978-85-7307-610-3','Bookman',2008,'Português',NULL,'2025-08-06 22:38:02'),(31,'livro','O mundo assombrado pelos demônios','The Demon-Haunted World: Science as a Candle in the Dark','Carl Sagan',NULL,'978-85-359-0834-3','Companhia de bolso',2006,'Português','1','2025-08-06 23:40:10'),(32,'livro','Gestão da produção industrial','Gestão da produção industrial','Moacyr Paranhos Filho',NULL,'978-85-65704-83-0','Intersaberes',2012,'Português','1','2025-08-06 23:47:05'),(33,'livro','Política Externa Brasileira - Uma introdução','Política Externa Brasileira - Uma introdução','André Luiz Reis da Silva; Bruna Figueiredo Riediger',NULL,'978-85-443-0342-9','Intersaberes',2016,'Português','1','2025-08-06 23:53:43');
/*!40000 ALTER TABLE `itens` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-07  2:12:24
