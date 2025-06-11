-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 11, 2025 at 06:18 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `missiriga`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `number` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `avatar` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `active_portion` varchar(255) DEFAULT NULL,
  `called_at` timestamp NULL DEFAULT NULL,
  `pinged_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `number`, `name`, `avatar`, `username`, `password`, `active_portion`, `called_at`, `pinged_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'DEVELOPMENT', 'no-avatar.jpg', 'admin', 'admin', NULL, NULL, NULL, '2023-02-19 07:36:32', '2025-06-10 09:15:51');

-- --------------------------------------------------------

--
-- Table structure for table `arrangements`
--

CREATE TABLE `arrangements` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `team_id` tinyint(3) UNSIGNED NOT NULL,
  `order` tinyint(3) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `competition_id` tinyint(3) UNSIGNED NOT NULL,
  `slug` varchar(32) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `competition_id`, `slug`, `title`, `created_at`, `updated_at`) VALUES
(1, 1, 'pageant-night', 'Pageant Night', '2023-04-06 13:25:10', '2023-04-06 13:25:10'),
(2, 1, 'pre-pageant', 'Pre-Pageant', '2024-06-11 07:29:26', '2024-06-11 07:29:26');

-- --------------------------------------------------------

--
-- Table structure for table `competitions`
--

CREATE TABLE `competitions` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `slug` varchar(32) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `competitions`
--

INSERT INTO `competitions` (`id`, `slug`, `title`, `created_at`, `updated_at`) VALUES
(1, 'missiriga-2025', 'Miss Iriga 2025', '2023-04-06 13:24:04', '2025-06-10 18:09:35');

-- --------------------------------------------------------

--
-- Table structure for table `criteria`
--

CREATE TABLE `criteria` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `percentage` float UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `criteria`
--

INSERT INTO `criteria` (`id`, `event_id`, `title`, `percentage`, `created_at`, `updated_at`) VALUES
(1, 3, 'Beauty ', 40, '2024-06-10 21:37:30', '2024-06-10 21:37:30'),
(2, 3, 'Intelligence', 40, '2024-06-10 21:37:42', '2024-06-10 21:37:42'),
(3, 3, 'Over-all Impression', 20, '2024-06-10 21:37:57', '2024-06-10 21:37:57'),
(4, 1, 'Form and Figure', 40, '2024-06-11 07:26:14', '2024-06-11 07:26:14'),
(5, 1, 'Poise and Projection', 40, '2024-06-11 07:26:26', '2024-06-11 07:26:26'),
(6, 1, 'Confidence', 20, '2024-06-11 07:26:37', '2024-06-11 07:26:37'),
(7, 2, 'Elegance', 40, '2024-06-11 07:26:57', '2024-06-11 07:26:57'),
(8, 2, 'Poise and Projection', 40, '2024-06-11 07:27:12', '2024-06-11 07:27:12'),
(9, 2, 'Over-all Impact', 20, '2024-06-11 07:27:21', '2024-06-11 07:27:21'),
(10, 4, 'Form and Figure', 40, '2024-06-11 07:31:57', '2024-06-11 07:31:57'),
(11, 4, 'Poise and Projection', 40, '2024-06-11 07:32:08', '2024-06-11 07:32:08'),
(12, 4, 'Confidence', 20, '2024-06-11 07:32:16', '2024-06-11 07:32:16'),
(13, 5, 'Elegance', 40, '2024-06-11 07:32:29', '2024-06-11 07:32:29'),
(14, 5, 'Poise and Projection', 40, '2024-06-11 07:32:39', '2024-06-11 07:32:39'),
(15, 5, 'Over-all Impact', 20, '2024-06-11 07:32:47', '2024-06-11 07:32:47');

-- --------------------------------------------------------

--
-- Table structure for table `deductions`
--

CREATE TABLE `deductions` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `technical_id` tinyint(3) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `team_id` tinyint(3) UNSIGNED NOT NULL,
  `value` float UNSIGNED NOT NULL DEFAULT 0,
  `is_locked` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `eliminations`
--

CREATE TABLE `eliminations` (
  `id` mediumint(9) NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `team_id` tinyint(3) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `eliminations`
--

INSERT INTO `eliminations` (`id`, `event_id`, `team_id`, `created_at`, `updated_at`) VALUES
(1, 3, 1, '2025-06-11 02:16:38', '2025-06-11 02:16:38'),
(2, 3, 2, '2025-06-11 02:16:40', '2025-06-11 02:16:40'),
(3, 3, 3, '2025-06-11 02:16:41', '2025-06-11 02:16:41'),
(4, 3, 4, '2025-06-11 02:16:43', '2025-06-11 02:16:43'),
(5, 3, 5, '2025-06-11 02:16:44', '2025-06-11 02:16:44'),
(6, 3, 6, '2025-06-11 02:16:45', '2025-06-11 02:16:45'),
(7, 3, 7, '2025-06-11 02:16:46', '2025-06-11 02:16:46'),
(8, 3, 8, '2025-06-11 02:16:47', '2025-06-11 02:16:47'),
(9, 3, 9, '2025-06-11 02:16:48', '2025-06-11 02:16:48'),
(10, 3, 10, '2025-06-11 02:16:50', '2025-06-11 02:16:50'),
(11, 3, 11, '2025-06-11 02:16:51', '2025-06-11 02:16:51'),
(12, 3, 12, '2025-06-11 02:16:52', '2025-06-11 02:16:52'),
(13, 3, 13, '2025-06-11 02:16:53', '2025-06-11 02:16:53'),
(14, 3, 14, '2025-06-11 02:16:54', '2025-06-11 02:16:54'),
(15, 3, 15, '2025-06-11 02:16:55', '2025-06-11 02:16:55'),
(16, 3, 16, '2025-06-11 02:16:57', '2025-06-11 02:16:57'),
(17, 3, 17, '2025-06-11 02:16:58', '2025-06-11 02:16:58'),
(18, 3, 18, '2025-06-11 02:16:59', '2025-06-11 02:16:59'),
(19, 3, 19, '2025-06-11 02:17:00', '2025-06-11 02:17:00'),
(20, 3, 20, '2025-06-11 02:17:01', '2025-06-11 02:17:01');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `category_id` tinyint(3) UNSIGNED NOT NULL,
  `slug` varchar(32) NOT NULL,
  `title` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `category_id`, `slug`, `title`, `created_at`, `updated_at`) VALUES
(1, 1, 'swimsuit', 'Swimsuit', '2024-06-11 07:24:01', '2025-06-10 18:29:54'),
(2, 1, 'evening-gown', 'Evening Gown', '2024-06-11 07:24:13', '2025-06-10 18:29:47'),
(3, 1, 'final-qa', 'Final Q&A', '2024-06-10 21:33:57', '2024-06-11 07:28:38'),
(4, 2, 'pre-swimsuit', 'Swimsuit (Pre-Pageant)', '2024-06-11 07:30:40', '2024-06-11 07:31:15'),
(5, 2, 'pre-evening-gown', 'Evening Gown (Pre-Pageant)', '2024-06-11 07:30:58', '2024-06-11 07:31:21');

-- --------------------------------------------------------

--
-- Table structure for table `judges`
--

CREATE TABLE `judges` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `number` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `active_portion` varchar(255) DEFAULT NULL,
  `called_at` timestamp NULL DEFAULT NULL,
  `pinged_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `judges`
--

INSERT INTO `judges` (`id`, `number`, `name`, `avatar`, `username`, `password`, `active_portion`, `called_at`, `pinged_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'Judge 01', 'no-avatar.jpg', 'judge01', 'judge01', 'swimsuit', NULL, '2025-06-10 02:14:39', '2023-04-06 13:58:11', '2025-06-10 02:14:39'),
(2, 2, 'Judge 02', 'no-avatar.jpg', 'judge02', 'judge02', NULL, NULL, NULL, '2023-04-06 13:58:28', '2023-04-06 13:58:28'),
(3, 3, 'Judge 03', 'no-avatar.jpg', 'judge03', 'judge03', NULL, NULL, NULL, '2023-04-06 13:58:42', '2023-04-06 13:58:42'),
(4, 4, 'Judge 04', 'no-avatar.jpg', 'judge04', 'judge04', NULL, NULL, NULL, '2023-04-06 13:59:26', '2023-04-06 13:59:26'),
(5, 5, 'Judge 05', 'no-avatar.jpg', 'judge05', 'judge05', NULL, NULL, NULL, '2023-04-06 14:00:00', '2023-04-06 14:00:00'),
(6, 6, 'Judge 06', 'no-avatar.jpg', 'judge06', 'judge06', NULL, NULL, NULL, '2024-06-10 21:38:33', '2025-06-11 04:17:53'),
(7, 7, 'Judge 07', 'no-avatar.jpg', 'judge07', 'judge07', NULL, NULL, NULL, '2024-06-10 21:38:50', '2024-06-10 21:38:50'),
(8, 1, 'Pre-Pageant Total', 'no-avatar.jpg', 'prejudge01', 'prejudge01', NULL, NULL, NULL, '2024-06-11 07:36:29', '2024-06-11 08:11:32');

-- --------------------------------------------------------

--
-- Table structure for table `judge_event`
--

CREATE TABLE `judge_event` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `judge_id` tinyint(3) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `is_chairman` tinyint(1) NOT NULL DEFAULT 0,
  `active_team_id` tinyint(3) UNSIGNED NOT NULL,
  `has_active_team` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `judge_event`
--

INSERT INTO `judge_event` (`id`, `judge_id`, `event_id`, `is_chairman`, `active_team_id`, `has_active_team`, `created_at`, `updated_at`) VALUES
(1, 1, 3, 0, 1, 0, '2024-06-10 21:39:11', '2024-06-10 21:50:51'),
(2, 2, 3, 0, 1, 0, '2024-06-10 21:39:17', '2024-06-10 21:50:53'),
(3, 3, 3, 0, 1, 0, '2024-06-10 21:39:22', '2024-06-10 21:50:54'),
(4, 4, 3, 0, 1, 0, '2024-06-10 21:39:28', '2024-06-10 21:50:56'),
(5, 5, 3, 0, 1, 0, '2024-06-10 21:39:36', '2024-06-10 21:50:58'),
(6, 6, 3, 0, 1, 0, '2024-06-10 21:39:41', '2024-06-10 21:51:00'),
(7, 7, 3, 0, 1, 0, '2024-06-10 21:39:47', '2024-06-10 21:51:04'),
(8, 1, 1, 0, 1, 0, '2024-06-11 07:33:33', '2024-06-11 07:33:33'),
(9, 1, 2, 0, 1, 0, '2024-06-11 07:34:03', '2024-06-11 07:34:03'),
(10, 2, 1, 0, 1, 0, '2024-06-11 07:34:10', '2024-06-11 07:34:10'),
(11, 2, 2, 0, 1, 0, '2024-06-11 07:34:14', '2024-06-11 07:34:14'),
(12, 3, 1, 0, 1, 0, '2024-06-11 07:34:22', '2024-06-11 07:34:22'),
(13, 3, 2, 0, 1, 0, '2024-06-11 07:34:25', '2024-06-11 07:34:25'),
(14, 4, 1, 0, 1, 0, '2024-06-11 07:34:33', '2024-06-11 07:34:33'),
(15, 4, 2, 0, 1, 0, '2024-06-11 07:34:36', '2024-06-11 07:34:36'),
(16, 5, 1, 0, 1, 0, '2024-06-11 07:34:43', '2024-06-11 07:34:43'),
(17, 5, 2, 0, 1, 0, '2024-06-11 07:34:46', '2024-06-11 07:34:46'),
(18, 6, 1, 0, 1, 0, '2024-06-11 07:34:52', '2024-06-11 07:34:52'),
(19, 6, 2, 0, 1, 0, '2024-06-11 07:34:56', '2024-06-11 07:34:56'),
(20, 7, 1, 0, 1, 0, '2024-06-11 07:35:16', '2024-06-11 07:35:16'),
(21, 7, 2, 0, 1, 0, '2024-06-11 07:35:20', '2024-06-11 07:35:20'),
(22, 8, 4, 0, 1, 0, '2024-06-11 07:36:43', '2024-06-11 07:36:43'),
(23, 8, 5, 0, 1, 0, '2024-06-11 07:36:48', '2024-06-11 07:36:48');

-- --------------------------------------------------------

--
-- Table structure for table `noshows`
--

CREATE TABLE `noshows` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `team_id` tinyint(3) UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `participants`
--

CREATE TABLE `participants` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `team_id` tinyint(3) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `number` smallint(5) UNSIGNED NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `middle_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) NOT NULL,
  `gender` enum('male','female') NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `points`
--

CREATE TABLE `points` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `rank` tinyint(3) UNSIGNED NOT NULL,
  `value` float UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `judge_id` tinyint(3) UNSIGNED NOT NULL,
  `criteria_id` smallint(5) UNSIGNED NOT NULL,
  `team_id` tinyint(3) UNSIGNED NOT NULL,
  `value` float UNSIGNED NOT NULL DEFAULT 0,
  `is_locked` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `number` tinyint(4) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `location` varchar(32) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `competing_for` enum('Miss Rinconada','Miss Iriga','Miss Bicol Tourism') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`id`, `number`, `name`, `location`, `avatar`, `competing_for`, `created_at`, `updated_at`) VALUES
(1, 1, 'CHRISTINE B. ORVILLA', 'Minalabac, Cam. Sur', '01.jpg', 'Miss Bicol Tourism', '2024-06-10 21:26:11', '2025-06-10 17:59:08'),
(2, 2, 'JADE NICA B. LABIOS', 'San Francisco, Iriga City', '02.jpg', 'Miss Iriga', '2024-06-10 21:26:31', '2025-06-10 17:59:20'),
(3, 3, 'CHRISTINE MAY B. ALOC', 'Daet, Cam. Norte', '03.jpg', 'Miss Bicol Tourism', '2024-06-10 21:26:54', '2025-06-10 17:59:32'),
(4, 4, 'MARIA SHELLY SABULARSE', 'San Antonio, Iriga City', '04.jpg', 'Miss Iriga', '2024-06-10 21:27:15', '2025-06-10 17:59:47'),
(5, 5, 'RICA JANE PEÑALBA', 'Sorsogon', '05.jpg', 'Miss Bicol Tourism', '2024-06-10 21:28:09', '2025-06-10 18:00:09'),
(6, 6, 'AMABEL B. IBASCO', 'Daet, Cam. Norte', '06.jpg', 'Miss Bicol Tourism', '2024-06-10 21:28:33', '2025-06-10 18:00:27'),
(7, 7, 'ALEXANDRA KRISHNA M. ORIÑO', 'Naga City', '07.jpg', 'Miss Bicol Tourism', '2024-06-10 21:28:50', '2025-06-10 18:00:45'),
(8, 8, 'EURICKA LYN N. MORAÑA', 'Nabua, Cam. Sur', '08.jpg', 'Miss Rinconada', '2024-06-10 21:29:05', '2025-06-10 18:01:00'),
(9, 9, 'BETTINA PAULINE L. FRANCIA', 'San Nicolas, Iriga City', '09.jpg', 'Miss Iriga', '2024-06-10 21:29:23', '2025-06-10 18:01:13'),
(10, 10, 'AUDREY ALEXANDRA B. VILLA', 'Baao, Cam. Sur', '10.jpg', 'Miss Rinconada', '2024-06-10 21:29:41', '2025-06-10 18:06:06'),
(11, 11, 'MARAE ALAINE B. CUSTODIO', 'Bombon, Cam. Sur', '11.jpg', 'Miss Bicol Tourism', '2024-06-10 21:29:58', '2025-06-10 18:02:06'),
(12, 12, 'ANGELICA V. CENTENO', 'Baao, Cam. Sur', '12.jpg', 'Miss Rinconada', '2024-06-10 21:30:15', '2025-06-10 18:02:19'),
(13, 13, 'RANI LACHMI DADO', 'Legazpi, Albay', '13.jpg', 'Miss Bicol Tourism', '2024-06-10 21:30:34', '2025-06-10 17:55:38'),
(14, 14, 'MICKHA ELLA S. COMODA', 'Lagonoy, Cam. Sur', '14.jpg', 'Miss Bicol Tourism', '2024-06-10 21:30:58', '2025-06-10 18:02:39'),
(15, 15, 'MARY DINE MONGE', 'Sto. Domingo, Iriga City', '15.jpg', 'Miss Iriga', '2024-06-10 21:31:22', '2025-06-10 18:02:50'),
(16, 16, 'KASSANDRA A. SETON', 'Siruma, Cam. Sur', '16.jpg', 'Miss Bicol Tourism', '2024-06-10 21:32:04', '2025-06-10 18:02:56'),
(17, 17, 'XENA ELISA C. VALDEMORO', 'Del Rosario Banao, Iriga City', '17.jpg', 'Miss Iriga', '2024-06-10 21:32:34', '2025-06-10 18:03:47'),
(18, 18, 'MIEN MIE EGIPTO', 'San Agustin, Iriga City', '18.jpg', 'Miss Iriga', '2025-06-10 17:54:48', '2025-06-10 18:03:52'),
(19, 19, 'MA. KASSANDRA S. COMPLETO', 'Bula, Cam. Sur', '19.jpg', 'Miss Rinconada', '2025-06-10 17:54:48', '2025-06-10 18:04:04'),
(20, 20, 'BARBIE ANNE DE LOS SANTOS', 'San Miguel, Iriga City', '20.jpg', 'Miss Iriga', '2025-06-10 17:54:48', '2025-06-10 18:04:17');

-- --------------------------------------------------------

--
-- Table structure for table `technicals`
--

CREATE TABLE `technicals` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `number` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `active_portion` varchar(255) DEFAULT NULL,
  `called_at` timestamp NULL DEFAULT NULL,
  `pinged_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `technicals`
--

INSERT INTO `technicals` (`id`, `number`, `name`, `avatar`, `username`, `password`, `active_portion`, `called_at`, `pinged_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'Technical 01', 'no-avatar.jpg', 'technical01', 'technical01', NULL, NULL, NULL, '2023-02-19 08:58:58', '2023-04-06 14:00:12');

-- --------------------------------------------------------

--
-- Table structure for table `technical_event`
--

CREATE TABLE `technical_event` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `technical_id` tinyint(3) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `active_team_id` tinyint(3) UNSIGNED NOT NULL,
  `has_active_team` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `titles`
--

CREATE TABLE `titles` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `event_id` smallint(5) UNSIGNED NOT NULL,
  `rank` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `title` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `titles`
--

INSERT INTO `titles` (`id`, `event_id`, `rank`, `title`, `created_at`, `updated_at`) VALUES
(1, 3, 1, 'MISS IRIGA 2025', '2024-06-11 07:43:42', '2025-06-10 18:12:51'),
(2, 3, 2, 'MISS RINCONADA 2025', '2024-06-11 07:43:42', '2025-06-10 18:12:56'),
(3, 3, 3, 'MISS BICOL TOURISM 2025', '2024-06-11 07:43:42', '2025-06-10 18:12:59'),
(4, 3, 4, '1ST RUNNER UP', '2024-06-11 07:43:42', '2024-06-11 08:09:17'),
(5, 3, 5, '2ND RUNNER UP', '2024-06-11 07:43:42', '2024-06-11 08:09:19');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `arrangements`
--
ALTER TABLE `arrangements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `competition_id` (`competition_id`);

--
-- Indexes for table `competitions`
--
ALTER TABLE `competitions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `criteria`
--
ALTER TABLE `criteria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indexes for table `deductions`
--
ALTER TABLE `deductions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `judge_id` (`technical_id`),
  ADD KEY `team_id` (`team_id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indexes for table `eliminations`
--
ALTER TABLE `eliminations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `area_id` (`category_id`);

--
-- Indexes for table `judges`
--
ALTER TABLE `judges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `judge_event`
--
ALTER TABLE `judge_event`
  ADD PRIMARY KEY (`id`),
  ADD KEY `judge_id` (`judge_id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `active_team_id` (`active_team_id`);

--
-- Indexes for table `noshows`
--
ALTER TABLE `noshows`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `participants`
--
ALTER TABLE `participants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `team_id` (`team_id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indexes for table `points`
--
ALTER TABLE `points`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `judge_id` (`judge_id`),
  ADD KEY `team_id` (`team_id`),
  ADD KEY `criteria_id` (`criteria_id`);

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `technicals`
--
ALTER TABLE `technicals`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `technical_event`
--
ALTER TABLE `technical_event`
  ADD PRIMARY KEY (`id`),
  ADD KEY `judge_id` (`technical_id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `active_team_id` (`active_team_id`);

--
-- Indexes for table `titles`
--
ALTER TABLE `titles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `arrangements`
--
ALTER TABLE `arrangements`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `competitions`
--
ALTER TABLE `competitions`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `criteria`
--
ALTER TABLE `criteria`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `deductions`
--
ALTER TABLE `deductions`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `eliminations`
--
ALTER TABLE `eliminations`
  MODIFY `id` mediumint(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `judges`
--
ALTER TABLE `judges`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `judge_event`
--
ALTER TABLE `judge_event`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `noshows`
--
ALTER TABLE `noshows`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `participants`
--
ALTER TABLE `participants`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `points`
--
ALTER TABLE `points`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=562;

--
-- AUTO_INCREMENT for table `teams`
--
ALTER TABLE `teams`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `technicals`
--
ALTER TABLE `technicals`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `technical_event`
--
ALTER TABLE `technical_event`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `titles`
--
ALTER TABLE `titles`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `arrangements`
--
ALTER TABLE `arrangements`
  ADD CONSTRAINT `arrangements_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `arrangements_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`competition_id`) REFERENCES `competitions` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `criteria`
--
ALTER TABLE `criteria`
  ADD CONSTRAINT `criteria_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `deductions`
--
ALTER TABLE `deductions`
  ADD CONSTRAINT `deductions_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `deductions_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `deductions_ibfk_3` FOREIGN KEY (`technical_id`) REFERENCES `technicals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `eliminations`
--
ALTER TABLE `eliminations`
  ADD CONSTRAINT `eliminations_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `eliminations_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `judge_event`
--
ALTER TABLE `judge_event`
  ADD CONSTRAINT `judge_event_ibfk_1` FOREIGN KEY (`judge_id`) REFERENCES `judges` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `judge_event_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `judge_event_ibfk_3` FOREIGN KEY (`active_team_id`) REFERENCES `teams` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `noshows`
--
ALTER TABLE `noshows`
  ADD CONSTRAINT `noshows_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `noshows_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `participants`
--
ALTER TABLE `participants`
  ADD CONSTRAINT `participants_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `participants_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `points`
--
ALTER TABLE `points`
  ADD CONSTRAINT `points_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`criteria_id`) REFERENCES `criteria` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ratings_ibfk_3` FOREIGN KEY (`judge_id`) REFERENCES `judges` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `technical_event`
--
ALTER TABLE `technical_event`
  ADD CONSTRAINT `technical_event_ibfk_2` FOREIGN KEY (`technical_id`) REFERENCES `technicals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `technical_event_ibfk_3` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `technical_event_ibfk_4` FOREIGN KEY (`active_team_id`) REFERENCES `teams` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `titles`
--
ALTER TABLE `titles`
  ADD CONSTRAINT `titles_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
