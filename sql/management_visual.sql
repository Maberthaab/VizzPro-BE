-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 06 Sep 2023 pada 03.55
-- Versi server: 10.4.28-MariaDB
-- Versi PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `management_visual`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `activity_project`
--

CREATE TABLE `activity_project` (
  `no_activity_name` varchar(255) NOT NULL,
  `no_progress_name` varchar(255) DEFAULT NULL,
  `activity_name` varchar(255) DEFAULT NULL,
  `plan_start_date` date DEFAULT NULL,
  `plan_current_date` date DEFAULT NULL,
  `actual_start_date` date DEFAULT NULL,
  `actual_current_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `ga_information`
--

CREATE TABLE `ga_information` (
  `project_name` varchar(255) NOT NULL,
  `project_division` varchar(40) DEFAULT NULL,
  `no_so` varchar(10) NOT NULL,
  `tipe_project` varchar(40) DEFAULT NULL,
  `podrawing_req_masuk` date DEFAULT NULL,
  `target_delivery` date DEFAULT NULL,
  `jumlah_activity` int(11) DEFAULT NULL,
  `actual_activity` int(11) DEFAULT NULL,
  `gap_activity` int(11) DEFAULT NULL,
  `doc_report_schedule` varchar(100) DEFAULT NULL,
  `project_owner` varchar(30) DEFAULT NULL,
  `nominal_po` int(11) DEFAULT NULL,
  `dp1` int(11) DEFAULT NULL,
  `dp2` int(11) DEFAULT NULL,
  `jml_pic` int(11) DEFAULT NULL,
  `prioritas_project` int(11) DEFAULT NULL,
  `customer` varchar(30) DEFAULT NULL,
  `pelunasan` int(11) DEFAULT NULL,
  `keterangan` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `initial_prog`
--

CREATE TABLE `initial_prog` (
  `no_progress_name` varchar(255) NOT NULL,
  `project_name` varchar(255) DEFAULT NULL,
  `progress_name` varchar(255) DEFAULT NULL,
  `step_number` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `prod_prog`
--

CREATE TABLE `prod_prog` (
  `no_progress_name` varchar(255) NOT NULL,
  `project_name` varchar(255) DEFAULT NULL,
  `progress_name` varchar(255) DEFAULT NULL,
  `step_number` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `createdAt`, `updatedAt`) VALUES
(27, 'ayam berkokok', '137e78a870d9d7d77373339aece9e196', '2023-09-04 03:14:38', '2023-09-04 03:14:38'),
(29, 'ayam berkokok1', '137e78a870d9d7d77373339aece9e196', '2023-09-04 03:18:37', '2023-09-04 03:18:37'),
(30, 'Gina', 'b86c986751ac0a855429962d234cb0af', '2023-09-04 03:27:44', '2023-09-04 03:27:44');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `activity_project`
--
ALTER TABLE `activity_project`
  ADD PRIMARY KEY (`no_activity_name`),
  ADD KEY `FK_no_progress_name` (`no_progress_name`);

--
-- Indeks untuk tabel `ga_information`
--
ALTER TABLE `ga_information`
  ADD PRIMARY KEY (`project_name`),
  ADD UNIQUE KEY `no_so` (`no_so`),
  ADD UNIQUE KEY `no_so_2` (`no_so`);

--
-- Indeks untuk tabel `initial_prog`
--
ALTER TABLE `initial_prog`
  ADD PRIMARY KEY (`no_progress_name`),
  ADD KEY `FK_project_name` (`project_name`);

--
-- Indeks untuk tabel `prod_prog`
--
ALTER TABLE `prod_prog`
  ADD PRIMARY KEY (`no_progress_name`),
  ADD KEY `FK_project_name_prod` (`project_name`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `activity_project`
--
ALTER TABLE `activity_project`
  ADD CONSTRAINT `FK_no_progress_name` FOREIGN KEY (`no_progress_name`) REFERENCES `prod_prog` (`no_progress_name`);

--
-- Ketidakleluasaan untuk tabel `initial_prog`
--
ALTER TABLE `initial_prog`
  ADD CONSTRAINT `FK_project_name` FOREIGN KEY (`project_name`) REFERENCES `ga_information` (`project_name`);

--
-- Ketidakleluasaan untuk tabel `prod_prog`
--
ALTER TABLE `prod_prog`
  ADD CONSTRAINT `FK_project_name_prod` FOREIGN KEY (`project_name`) REFERENCES `ga_information` (`project_name`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
