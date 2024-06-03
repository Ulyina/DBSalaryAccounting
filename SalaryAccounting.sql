-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Июн 03 2024 г., 13:12
-- Версия сервера: 5.7.39
-- Версия PHP: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `SalaryAccounting`
--

-- --------------------------------------------------------

--
-- Структура таблицы `Earnings`
--

CREATE TABLE `Earnings` (
  `id` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT '0.00',
  `position_id` int(11) DEFAULT NULL,
  `operation_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `Earnings`
--

INSERT INTO `Earnings` (`id`, `date`, `amount`, `position_id`, `operation_id`) VALUES
(1, '2024-02-05', '39310.34', 1, 1),
(2, '2024-02-05', '20689.66', 1, 2),
(3, '2024-02-05', '66818.18', 2, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `EarningsWrite`
--

CREATE TABLE `EarningsWrite` (
  `id` int(11) NOT NULL,
  `position_id` int(11) DEFAULT NULL,
  `operation_id` int(11) DEFAULT NULL,
  `contribution_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `EarningsWrite`
--

INSERT INTO `EarningsWrite` (`id`, `position_id`, `operation_id`, `contribution_id`, `date`, `time`, `total_amount`) VALUES
(1, 1, 1, 2, '2024-04-30', '21:33:01', '57272.73'),
(2, 1, 1, 1, '2024-04-30', '22:04:03', '39310.34'),
(3, 1, 1, 1, '2024-05-02', '02:04:13', '39310.34'),
(4, 1, 1, 2, '2024-05-02', '10:01:45', '57272.73');

-- --------------------------------------------------------

--
-- Структура таблицы `InsuranceContributions`
--

CREATE TABLE `InsuranceContributions` (
  `id` int(11) NOT NULL,
  `insurance_type_id` int(11) DEFAULT NULL,
  `earning_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `InsuranceContributions`
--

INSERT INTO `InsuranceContributions` (`id`, `insurance_type_id`, `earning_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3);

-- --------------------------------------------------------

--
-- Структура таблицы `InsuranceTypes`
--

CREATE TABLE `InsuranceTypes` (
  `id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `InsuranceTypes`
--

INSERT INTO `InsuranceTypes` (`id`, `title`, `amount`) VALUES
(1, 'ФСС', '2.90'),
(2, 'Пенсионный фонд', '22.00'),
(3, 'ФСС по травмотизму', '2.00'),
(4, 'ФФОМС', '5.10');

-- --------------------------------------------------------

--
-- Структура таблицы `Operations`
--

CREATE TABLE `Operations` (
  `id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `Operations`
--

INSERT INTO `Operations` (`id`, `title`) VALUES
(1, 'Зарплата к выплате111'),
(2, 'Сумма страховых взносов');

-- --------------------------------------------------------

--
-- Структура таблицы `Positions`
--

CREATE TABLE `Positions` (
  `id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `Positions`
--

INSERT INTO `Positions` (`id`, `title`, `salary`) VALUES
(1, 'Токарь1', '60000.00'),
(2, 'Слесарь', '70000.00');

-- --------------------------------------------------------

--
-- Структура таблицы `PositionsInsurance`
--

CREATE TABLE `PositionsInsurance` (
  `id` int(11) NOT NULL,
  `insurance_type_id` int(11) DEFAULT NULL,
  `positions_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `PositionsInsurance`
--

INSERT INTO `PositionsInsurance` (`id`, `insurance_type_id`, `positions_id`) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 2),
(4, 4, 2);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `Earnings`
--
ALTER TABLE `Earnings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `position_id` (`position_id`),
  ADD KEY `operation_id` (`operation_id`);

--
-- Индексы таблицы `EarningsWrite`
--
ALTER TABLE `EarningsWrite`
  ADD PRIMARY KEY (`id`),
  ADD KEY `position_id` (`position_id`),
  ADD KEY `operation_id` (`operation_id`),
  ADD KEY `contribution_id` (`contribution_id`);

--
-- Индексы таблицы `InsuranceContributions`
--
ALTER TABLE `InsuranceContributions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `insurance_type_id` (`insurance_type_id`),
  ADD KEY `earning_id` (`earning_id`);

--
-- Индексы таблицы `InsuranceTypes`
--
ALTER TABLE `InsuranceTypes`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `Operations`
--
ALTER TABLE `Operations`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `Positions`
--
ALTER TABLE `Positions`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `PositionsInsurance`
--
ALTER TABLE `PositionsInsurance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `insurance_type_id` (`insurance_type_id`),
  ADD KEY `positions_id` (`positions_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `Earnings`
--
ALTER TABLE `Earnings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `EarningsWrite`
--
ALTER TABLE `EarningsWrite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `InsuranceContributions`
--
ALTER TABLE `InsuranceContributions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `InsuranceTypes`
--
ALTER TABLE `InsuranceTypes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `Operations`
--
ALTER TABLE `Operations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `Positions`
--
ALTER TABLE `Positions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `PositionsInsurance`
--
ALTER TABLE `PositionsInsurance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `Earnings`
--
ALTER TABLE `Earnings`
  ADD CONSTRAINT `earnings_ibfk_1` FOREIGN KEY (`position_id`) REFERENCES `salary_accounting`.`Positions` (`id`),
  ADD CONSTRAINT `earnings_ibfk_2` FOREIGN KEY (`operation_id`) REFERENCES `salary_accounting`.`Operations` (`id`);

--
-- Ограничения внешнего ключа таблицы `EarningsWrite`
--
ALTER TABLE `EarningsWrite`
  ADD CONSTRAINT `earningswrite_ibfk_1` FOREIGN KEY (`position_id`) REFERENCES `Positions` (`id`),
  ADD CONSTRAINT `earningswrite_ibfk_2` FOREIGN KEY (`operation_id`) REFERENCES `Operations` (`id`),
  ADD CONSTRAINT `earningswrite_ibfk_3` FOREIGN KEY (`contribution_id`) REFERENCES `InsuranceTypes` (`id`);

--
-- Ограничения внешнего ключа таблицы `InsuranceContributions`
--
ALTER TABLE `InsuranceContributions`
  ADD CONSTRAINT `insurancecontributions_ibfk_1` FOREIGN KEY (`insurance_type_id`) REFERENCES `salary_accounting`.`InsuranceTypes` (`id`),
  ADD CONSTRAINT `insurancecontributions_ibfk_2` FOREIGN KEY (`earning_id`) REFERENCES `salary_accounting`.`Earnings` (`id`);

--
-- Ограничения внешнего ключа таблицы `PositionsInsurance`
--
ALTER TABLE `PositionsInsurance`
  ADD CONSTRAINT `positionsinsurance_ibfk_1` FOREIGN KEY (`insurance_type_id`) REFERENCES `InsuranceTypes` (`id`),
  ADD CONSTRAINT `positionsinsurance_ibfk_2` FOREIGN KEY (`positions_id`) REFERENCES `Positions` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
