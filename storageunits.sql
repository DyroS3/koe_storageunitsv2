SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE `storageunits` (
  `id` int(11) NOT NULL,
  `identifier` varchar(46) DEFAULT NULL,
  `pin` longtext DEFAULT NULL,
  `balance` int(250) NOT NULL DEFAULT 0,
  `time` int(250) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `storageunits` (`id`, `identifier`, `pin`, `balance`, `time`) VALUES
(1, NULL, NULL, 0, 0),
(2, NULL, NULL, 0, 0),
(3, NULL, NULL, 0, 0),
(4, NULL, NULL, 0, 0),
(5, NULL, NULL, 0, 0),
(6, NULL, NULL, 0, 0),
(7, NULL, NULL, 0, 0),
(8, NULL, NULL, 0, 0),
(9, NULL, NULL, 0, 0),
(10, NULL, NULL, 0, 0),
(11, NULL, NULL, 0, 0),
(12, NULL, NULL, 0, 0),
(13, NULL, NULL, 0, 0),
(14, NULL, NULL, 0, 0),
(15, NULL, NULL, 0, 0),
(16, NULL, NULL, 0, 0),
(17, NULL, NULL, 0, 0),
(18, NULL, NULL, 0, 0),
(19, NULL, NULL, 0, 0),
(20, NULL, NULL, 0, 0),
(21, NULL, NULL, 0, 0),
(22, NULL, NULL, 0, 0),
(23, NULL, NULL, 0, 0),
(24, NULL, NULL, 0, 0),
(25, NULL, NULL, 0, 0),
(26, NULL, NULL, 0, 0),
(27, NULL, NULL, 0, 0),
(28, NULL, NULL, 0, 0);

ALTER TABLE `storageunits`
  ADD UNIQUE KEY `id` (`id`);
COMMIT;