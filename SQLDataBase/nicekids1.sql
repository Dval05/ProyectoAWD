-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 12-11-2025 a las 11:53:34
-- Versión del servidor: 8.0.17
-- Versión de PHP: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `nicekids1`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activity`
--

CREATE TABLE `activity` (
  `ActivityID` int(11) NOT NULL,
  `Name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `GradeID` int(11) DEFAULT NULL,
  `EmpID` int(11) DEFAULT NULL COMMENT 'Docente responsable',
  `ScheduledDate` date DEFAULT NULL,
  `StartTime` time DEFAULT NULL,
  `EndTime` time DEFAULT NULL,
  `Location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Arte, Música, Deporte, Académico, etc.',
  `Status` enum('Planned','In Progress','Completed','Cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Planned',
  `ImagePath` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `activity`
--

INSERT INTO `activity` (`ActivityID`, `Name`, `Description`, `GradeID`, `EmpID`, `ScheduledDate`, `StartTime`, `EndTime`, `Location`, `Category`, `Status`, `ImagePath`, `CreatedBy`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 'Pintando con los dedos', 'Actividad sensorial para motricidad fina', 1, 3, NULL, '00:00:01', '00:20:25', NULL, NULL, 'Planned', NULL, 2, '2025-11-06 15:00:00', '2025-11-10 14:00:00'),
(2, 'Explorando colores', 'Mezcla de colores con esponjas', 2, 2, NULL, '00:00:01', '00:20:25', NULL, NULL, 'Planned', NULL, 3, '2025-11-06 15:05:00', '2025-11-10 14:05:00'),
(3, 'Aprendemos vocales', 'Canciones y tarjetas para reconocer vocales', 3, 4, NULL, '00:00:01', '00:20:25', NULL, NULL, 'Planned', NULL, 4, '2025-11-06 15:10:00', '2025-11-10 14:10:00'),
(4, 'Juego con números', 'Contamos y clasificamos objetos', 4, 3, NULL, '00:00:01', '00:20:25', NULL, NULL, 'Planned', NULL, 2, '2025-11-06 15:15:00', '2025-11-10 14:15:00'),
(5, 'Día de la familia', 'Padres participaron en actividades', 4, 1, NULL, '00:00:01', '00:20:25', NULL, NULL, 'Planned', NULL, 1, '2025-11-06 15:20:00', '2025-11-11 15:20:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `activity_media`
--

CREATE TABLE `activity_media` (
  `MediaID` int(11) NOT NULL,
  `ActivityID` int(11) NOT NULL,
  `MediaType` enum('Image','Video','Document') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Image',
  `FilePath` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `FileSize` int(11) DEFAULT NULL COMMENT 'Tamaño en bytes',
  `Caption` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `UploadedBy` int(11) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `activity_media`
--

INSERT INTO `activity_media` (`MediaID`, `ActivityID`, `MediaType`, `FilePath`, `FileSize`, `Caption`, `UploadedBy`, `CreatedAt`) VALUES
(1, 1, 'Image', 'uploads/activities/fingerpaint1.jpg', 245680, 'Niños pintando con los dedos', 2, '2025-11-07 17:00:00'),
(2, 2, 'Image', 'uploads/activities/colors1.jpg', 312450, 'Niños mezclando colores', 3, '2025-11-08 17:10:00'),
(3, 3, 'Video', 'uploads/activities/vowels1.mp4', 5678900, 'Video vocales con canción', 4, '2025-11-09 18:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `attendance`
--

CREATE TABLE `attendance` (
  `AttendanceID` int(11) NOT NULL,
  `StudentID` int(11) NOT NULL,
  `Date` date NOT NULL,
  `CheckInTime` time DEFAULT NULL,
  `CheckOutTime` time DEFAULT NULL,
  `Status` enum('Present','Absent','Late','Excused','Sick') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Present',
  `IsLate` tinyint(1) DEFAULT '0',
  `LateMinutes` int(11) DEFAULT '0',
  `Notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `CheckedInBy` int(11) DEFAULT NULL,
  `CheckedOutBy` int(11) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `attendance`
--

INSERT INTO `attendance` (`AttendanceID`, `StudentID`, `Date`, `CheckInTime`, `CheckOutTime`, `Status`, `IsLate`, `LateMinutes`, `Notes`, `CheckedInBy`, `CheckedOutBy`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 1, '2025-11-11', '08:00:00', '16:30:00', 'Present', 0, 0, NULL, 2, 2, '2025-11-11 13:00:00', NULL),
(2, 2, '2025-11-11', '08:15:00', '16:45:00', 'Late', 1, 15, 'Tráfico', 3, 3, '2025-11-11 13:15:00', NULL),
(3, 3, '2025-11-11', '08:05:00', '16:35:00', 'Present', 0, 0, NULL, 2, 2, '2025-11-11 13:05:00', NULL),
(4, 4, '2025-11-11', '07:55:00', '17:00:00', 'Present', 0, 0, NULL, 3, 3, '2025-11-11 12:55:00', NULL),
(5, 5, '2025-11-11', '08:10:00', '16:40:00', 'Present', 0, 0, NULL, 4, 4, '2025-11-11 13:10:00', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audit_log`
--

CREATE TABLE `audit_log` (
  `LogID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `Action` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `TableName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `RecordID` int(11) DEFAULT NULL,
  `OldData` json DEFAULT NULL,
  `NewData` json DEFAULT NULL,
  `IPAddress` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `UserAgent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `employee`
--

CREATE TABLE `employee` (
  `EmpID` int(11) NOT NULL,
  `FirstName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `LastName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `DocumentNumber` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Position` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Maestra, Asistente, Administrador, etc.',
  `Email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PhoneNumber` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `HireDate` date DEFAULT NULL,
  `TerminationDate` date DEFAULT NULL,
  `Salary` decimal(10,2) DEFAULT NULL,
  `BankAccount` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EmergencyContact` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EmergencyPhone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Qualifications` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Títulos, certificaciones',
  `ProfilePicture` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IsActive` tinyint(1) NOT NULL DEFAULT '1',
  `UserID` int(11) DEFAULT NULL COMMENT 'Usuario del sistema asociado',
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `employee`
--

INSERT INTO `employee` (`EmpID`, `FirstName`, `LastName`, `DocumentNumber`, `Position`, `Email`, `PhoneNumber`, `Address`, `HireDate`, `TerminationDate`, `Salary`, `BankAccount`, `EmergencyContact`, `EmergencyPhone`, `Qualifications`, `ProfilePicture`, `IsActive`, `UserID`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 'Patricia', 'Sánchez', '1728394050', 'Directora Académica', 'patricia.sanchez@gmail.com', '0987654321', 'Av. República E7-123', '2020-03-01', NULL, '1400.00', 'Pichincha-4567890123', 'María Rodríguez', '0998765432', 'Lic. en Educación Infantil, Magíster en Gestión Educativa', 'uploads/employees/patricia.jpg', 1, 2, '2025-11-05 14:00:00', '2025-11-11 14:00:00'),
(2, 'Carmen', 'Mendoza', '1725567843', 'Docente Maternal', 'carmen.mendoza@gmail.com', '0976543210', 'Av. 10 de Agosto N26-45', '2021-04-01', NULL, '980.00', 'Guayaquil-7894561230', 'Luis Mendoza', '0994433221', 'Lic. en Parvularia', 'uploads/employees/carmen.jpg', 1, 3, '2025-11-05 14:05:00', '2025-11-10 13:45:00'),
(3, 'Lucía', 'García', '1712345678', 'Docente Inicial', 'lucia.garcia@gmail.com', '0965432109', 'Av. Naciones Unidas N36-188', '2021-06-10', NULL, '1020.00', 'Pichincha-1234567890', 'Carlos García', '0996655443', 'Lic. en Educación Inicial', 'uploads/employees/lucia.jpg', 1, 4, '2025-11-05 14:10:00', '2025-11-09 15:00:00'),
(4, 'Ana', 'Martínez', '1723456789', 'Docente Arte y Música', 'ana.martinez@gmail.com', '0954321098', 'Av. Portugal E10-89', '2022-01-15', NULL, '1000.00', 'Produbanco-9876543210', 'Marcos Martínez', '0995566778', 'Lic. en Música Infantil, Certificado en Arte', 'uploads/employees/ana.jpg', 1, 5, '2025-11-05 14:15:00', '2025-11-08 16:00:00'),
(5, 'Diego', 'Torres', '1719988776', 'Asistente Pedagógico', 'diego.torres@gmail.com', '0998877665', 'Av. América N45-123', '2023-04-10', NULL, '750.00', 'Pichincha-1122334455', 'Mónica Torres', '0989988776', 'Bachiller en Ciencias, Curso auxiliar docente', 'uploads/employees/diego.jpg', 1, 6, '2025-11-05 14:20:00', '2025-11-08 16:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `employee_task`
--

CREATE TABLE `employee_task` (
  `TaskID` int(11) NOT NULL,
  `EmpID` int(11) NOT NULL,
  `TaskName` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `DueDate` date DEFAULT NULL,
  `Status` enum('Pending','In Progress','Completed','Cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Pending',
  `Priority` enum('Low','Medium','High','Urgent') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Medium',
  `CompletedDate` date DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `employee_task`
--

INSERT INTO `employee_task` (`TaskID`, `EmpID`, `TaskName`, `Description`, `DueDate`, `Status`, `Priority`, `CompletedDate`, `CreatedBy`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 3, 'Preparar materiales pintura', 'Reunir pinceles y vasos de agua', '2025-11-06', 'Completed', 'High', '2025-11-06', 2, '2025-11-05 18:00:00', '2025-11-06 19:00:00'),
(2, 5, 'Revisar asistencias', 'Verificar lista de asistencia diaria', '2025-11-07', 'Pending', '', NULL, 2, '2025-11-05 18:05:00', '2025-11-07 14:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grade`
--

CREATE TABLE `grade` (
  `GradeID` int(11) NOT NULL,
  `GradeName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `AgeRangeMin` int(11) DEFAULT NULL,
  `AgeRangeMax` int(11) DEFAULT NULL,
  `MaxCapacity` int(11) DEFAULT NULL,
  `IsActive` tinyint(1) NOT NULL DEFAULT '1',
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `grade`
--

INSERT INTO `grade` (`GradeID`, `GradeName`, `Description`, `AgeRangeMin`, `AgeRangeMax`, `MaxCapacity`, `IsActive`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 'Maternal 1', 'Bebés 0-1', 0, 1, 8, 1, '2025-11-05 13:00:00', '2025-11-11 13:00:00'),
(2, 'Maternal 2', 'Niños 1-2', 1, 2, 10, 1, '2025-11-05 13:05:00', '2025-11-11 13:05:00'),
(3, 'Inicial 1', 'Niños 2-3', 2, 3, 12, 1, '2025-11-05 13:10:00', '2025-11-11 13:10:00'),
(4, 'Inicial 2', 'Niños 3-4', 3, 4, 15, 1, '2025-11-05 13:15:00', '2025-11-11 13:15:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `guardian`
--

CREATE TABLE `guardian` (
  `GuardianID` int(11) NOT NULL,
  `FirstName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `LastName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `DocumentNumber` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Relationship` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Padre, Madre, Tutor, Abuelo, etc.',
  `PhoneNumber` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Occupation` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `WorkPhone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IsEmergencyContact` tinyint(1) DEFAULT '0',
  `IsAuthorizedPickup` tinyint(1) DEFAULT '1',
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `guardian`
--

INSERT INTO `guardian` (`GuardianID`, `FirstName`, `LastName`, `DocumentNumber`, `Relationship`, `PhoneNumber`, `Email`, `Address`, `Occupation`, `WorkPhone`, `IsEmergencyContact`, `IsAuthorizedPickup`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 'Gabriela', 'Smith', '1729001111', 'Madre', '0991122334', 'gabriela.smith@gmail.com', 'Calle El Sol 12', 'Contadora', '022-345678', 1, 1, '2025-11-06 14:30:00', '2025-11-11 17:00:00'),
(2, 'Juan', 'Rodríguez', '1712340001', 'Padre', '0984455667', 'juan.rodriguez@gmail.com', 'Calle La Paz 45', 'Ingeniero', '022-111222', 1, 1, '2025-11-06 14:35:00', '2025-11-10 17:30:00'),
(3, 'María', 'López', '1720011111', 'Madre', '0993344556', 'maria.lopez@gmail.com', 'Av. Simón Bolívar 90', 'Doctora', '022-222333', 1, 1, '2025-11-06 14:40:00', '2025-11-09 14:30:00'),
(4, 'Ana', 'Rodríguez', '1711112222', 'Madre', '0982233445', 'ana.rodriguez@gmail.com', 'Calle Las Rosas 33', 'Diseñadora', '022-333444', 1, 1, '2025-11-06 14:45:00', '2025-11-08 19:00:00'),
(5, 'Carlos', 'García', '1722223333', 'Padre', '0985566778', 'carlos.garcia@gmail.com', 'Av. Amazonas 120', 'Arquitecto', '022-444555', 1, 1, '2025-11-06 14:50:00', '2025-11-11 20:00:00'),
(6, 'Sofía', 'Pérez', '1723334444', 'Madre', '0994455667', 'sofia.perez@gmail.com', 'Calle Primera 7', 'Abogada', '022-555666', 1, 1, '2025-11-07 14:00:00', '2025-11-10 21:00:00'),
(7, 'Raúl', 'Vargas', '1714445555', 'Padre', '0989988776', 'raul.vargas@gmail.com', 'Calle Segunda 24', 'Empresario', '022-666777', 1, 1, '2025-11-07 14:05:00', '2025-11-09 23:00:00'),
(8, 'María', 'Ruiz', '1725556666', 'Madre', '0995566777', 'maria.ruiz@gmail.com', 'Av. Siempre Viva 5', 'Administradora', '022-777888', 1, 1, '2025-11-07 14:10:00', '2025-11-08 23:30:00'),
(9, 'José', 'Martínez', '1716667777', 'Padre', '0986677889', 'jose.martinez@gmail.com', 'Calle Tercera 40', 'Chef', '022-888999', 1, 1, '2025-11-07 14:15:00', '2025-11-09 00:00:00'),
(10, 'Andrea', 'Valencia', '1727778888', 'Madre', '0992233445', 'andrea.valencia@gmail.com', 'Av. Reforma 22', 'Docente Universitaria', '022-999000', 1, 1, '2025-11-07 14:20:00', '2025-11-12 00:30:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `invoice`
--

CREATE TABLE `invoice` (
  `InvoiceID` int(11) NOT NULL,
  `InvoiceNumber` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `InvoiceType` enum('Student','Teacher') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Student',
  `ReferenceID` int(11) NOT NULL COMMENT 'StudentPaymentID o TeacherPaymentID',
  `IssueDate` date NOT NULL,
  `DueDate` date DEFAULT NULL,
  `TotalAmount` decimal(10,2) NOT NULL,
  `TaxAmount` decimal(10,2) DEFAULT '0.00',
  `DiscountAmount` decimal(10,2) DEFAULT '0.00',
  `FinalAmount` decimal(10,2) NOT NULL,
  `Description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `Status` enum('Draft','Issued','Paid','Cancelled','Overdue') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Draft',
  `FilePath` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ruta del PDF generado',
  `CreatedBy` int(11) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `invoice`
--

INSERT INTO `invoice` (`InvoiceID`, `InvoiceNumber`, `InvoiceType`, `ReferenceID`, `IssueDate`, `DueDate`, `TotalAmount`, `TaxAmount`, `DiscountAmount`, `FinalAmount`, `Description`, `Status`, `FilePath`, `CreatedBy`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 'INV-2025-001', 'Student', 1, '2025-11-01', '2025-11-05', '350.00', '0.00', '0.00', '350.00', 'Pensión noviembre - Lucas', 'Paid', '/invoices/INV-2025-001.pdf', 2, '2025-11-05 17:10:00', '2025-11-05 19:00:00'),
(2, 'INV-2025-002', 'Student', 2, '2025-11-01', '2025-11-05', '350.00', '0.00', '0.00', '350.00', 'Pensión noviembre - Sofía', 'Paid', '/invoices/INV-2025-002.pdf', 2, '2025-11-06 17:10:00', '2025-11-06 19:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notification`
--

CREATE TABLE `notification` (
  `NotificationID` int(11) NOT NULL,
  `SenderID` int(11) DEFAULT NULL,
  `ReceiverID` int(11) NOT NULL,
  `Type` enum('Message','Alert','Reminder','System') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Message',
  `Priority` enum('Low','Normal','High','Urgent') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Normal',
  `Subject` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `IsRead` tinyint(1) DEFAULT '0',
  `ReadAt` datetime DEFAULT NULL,
  `RelatedModule` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'students, payments, attendance, etc.',
  `RelatedID` int(11) DEFAULT NULL COMMENT 'ID del registro relacionado',
  `ExpiresAt` datetime DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `notification`
--

INSERT INTO `notification` (`NotificationID`, `SenderID`, `ReceiverID`, `Type`, `Priority`, `Subject`, `Message`, `IsRead`, `ReadAt`, `RelatedModule`, `RelatedID`, `ExpiresAt`, `CreatedAt`) VALUES
(1, 1, 2, 'Alert', 'High', 'Nuevo pago registrado', 'El pago del alumno Lucas ha sido registrado', 0, NULL, 'payments', 1, '2025-12-01 00:00:00', '2025-11-05 17:20:00'),
(2, 2, 6, 'Message', 'Normal', 'Actividad publicada', 'Se ha publicado la actividad Pintando con los dedos', 1, '2025-11-06 13:00:00', 'activities', 1, '2025-11-20 00:00:00', '2025-11-06 17:30:00');

--
-- Disparadores `notification`
--
DELIMITER $$
CREATE TRIGGER `trg_mark_read_notification` BEFORE UPDATE ON `notification` FOR EACH ROW BEGIN
    IF NEW.IsRead = 1 AND OLD.IsRead = 0 THEN
        SET NEW.ReadAt = NOW();
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permission`
--

CREATE TABLE `permission` (
  `PermissionID` int(11) NOT NULL,
  `PermissionName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Link` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `permission`
--

INSERT INTO `permission` (`PermissionID`, `PermissionName`, `Module`, `Action`, `Description`, `CreatedAt`, `Link`, `Icon`) VALUES
(1, 'Ver panel principal', 'dashboard', 'view', 'Acceso al dashboard principal', '2025-11-06 14:15:00', 'dashboard.html', 'fa-tachometer-alt'),
(2, 'Gestión estudiantes', 'students', 'view', 'Listado y gestión de estudiantes', '2025-11-06 14:16:00', 'students/students.html', 'fa-user-graduate'),
(3, 'Gestión tutores', 'guardians', 'view', 'Listado y gestión de tutores', '2025-11-06 14:17:00', 'guardians/parents.html', 'fa-users'),
(4, 'Gestión empleados', 'staff', 'view', 'Listado y gestión de empleados', '2025-11-06 14:18:00', 'staff/teachers.html', 'fa-chalkboard-teacher'),
(5, 'Control asistencia', 'attendance', 'view', 'Registro de asistencia', '2025-11-06 14:19:00', 'attendance/attendance.html', 'fa-calendar-check'),
(6, 'Gestión actividades', 'activities', 'view', 'Gestión de actividades', '2025-11-06 14:20:00', 'activities/activities.html', 'fa-calendar-alt'),
(7, 'Gestión pagos', 'payments', 'view', 'Gestión de pagos', '2025-11-06 14:21:00', 'payments/payments.html', 'fa-money-bill'),
(8, 'Reportes', 'reports', 'view', 'Reportes generales', '2025-11-06 14:22:00', 'reports/reports.html', 'fa-file-alt'),
(9, 'Gestión usuarios', 'users', 'view', 'Gestión de usuarios y perfiles', '2025-11-06 14:23:00', 'users/users-roles.html', 'fa-id-badge'),
(10, 'Auditoría', 'audit', 'view', 'Acceso a logs de auditoría', '2025-11-06 14:24:00', 'audit/audit-logs.html', 'fa-search'),
(11, 'Observaciones', 'observations', 'view', 'Acceso a observaciones de estudiantes', '2025-11-06 14:25:00', 'observations/observations.html', 'fa-clipboard'),
(12, 'Facturación', 'invoices', 'view', 'Gestión de facturas', '2025-11-06 14:26:00', 'invoices/invoices.html', 'fa-file-invoice'),
(13, 'Notificaciones', 'communication', 'view', 'Enviar/leer notificaciones', '2025-11-06 14:27:00', 'communication/communication.html', 'fa-comments'),
(14, 'Pagos de alumnos', 'payments', 'view_student', 'Pagos de alumnos', '2025-11-06 14:28:00', 'payments/student-payments.html', 'fa-image'),
(15, 'Pagos docentes', 'payments', 'view_teacher', 'Pagos a personal docente', '2025-11-06 14:29:00', 'payments/teacher-payments.html', 'fa-coins'),
(16, 'Gestión usuarios', 'users', 'manage', 'Perfil, roles y permisos', '2025-11-06 14:30:00', 'users/users-roles.html', 'fa-clock');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role`
--

CREATE TABLE `role` (
  `RoleID` int(11) NOT NULL,
  `RoleName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `IsActive` tinyint(1) NOT NULL DEFAULT '1',
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `role`
--

INSERT INTO `role` (`RoleID`, `RoleName`, `Description`, `IsActive`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 'Director', 'Administrador general', 1, '2025-11-06 14:00:00', '2025-11-11 15:00:00'),
(2, 'Teacher', 'Docente', 1, '2025-11-06 14:05:00', '2025-11-11 15:05:00'),
(3, 'Parent', 'Padre/Tutor', 1, '2025-11-06 14:10:00', '2025-11-11 15:10:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `role_permission`
--

CREATE TABLE `role_permission` (
  `RolePermissionID` int(11) NOT NULL,
  `RoleID` int(11) NOT NULL,
  `PermissionID` int(11) NOT NULL,
  `GrantedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `role_permission`
--

INSERT INTO `role_permission` (`RolePermissionID`, `RoleID`, `PermissionID`, `GrantedAt`) VALUES
(190, 1, 1, '2025-11-06 14:40:00'),
(191, 1, 2, '2025-11-06 14:40:00'),
(192, 1, 3, '2025-11-06 14:40:00'),
(193, 1, 4, '2025-11-06 14:40:00'),
(194, 1, 5, '2025-11-06 14:40:00'),
(195, 1, 6, '2025-11-06 14:40:00'),
(196, 1, 7, '2025-11-06 14:40:00'),
(197, 1, 8, '2025-11-06 14:40:00'),
(198, 1, 9, '2025-11-06 14:40:00'),
(199, 1, 10, '2025-11-06 14:40:00'),
(200, 1, 11, '2025-11-06 14:40:00'),
(201, 1, 12, '2025-11-06 14:40:00'),
(202, 1, 13, '2025-11-06 14:40:00'),
(203, 1, 14, '2025-11-06 14:40:00'),
(204, 1, 15, '2025-11-06 14:40:00'),
(205, 1, 16, '2025-11-06 14:40:00'),
(206, 2, 1, '2025-11-06 14:41:00'),
(207, 2, 2, '2025-11-06 14:41:00'),
(208, 2, 5, '2025-11-06 14:41:00'),
(209, 2, 6, '2025-11-06 14:41:00'),
(210, 2, 11, '2025-11-06 14:41:00'),
(211, 2, 14, '2025-11-06 14:41:00'),
(212, 3, 1, '2025-11-06 14:42:00'),
(213, 3, 2, '2025-11-06 14:42:00'),
(214, 3, 3, '2025-11-06 14:42:00'),
(215, 3, 6, '2025-11-06 14:42:00'),
(216, 3, 13, '2025-11-06 14:42:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `session`
--

CREATE TABLE `session` (
  `SessionID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `Token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `IPAddress` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `UserAgent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ExpiresAt` datetime NOT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `session`
--

INSERT INTO `session` (`SessionID`, `UserID`, `Token`, `IPAddress`, `UserAgent`, `ExpiresAt`, `CreatedAt`) VALUES
(1, 1, 'sess_admin_abc123', '192.168.1.10', 'Mozilla/5.0 (Windows NT 10.0)', '2025-11-13 09:00:00', '2025-11-11 14:00:00'),
(2, 2, 'sess_pat_456def', '192.168.1.11', 'Mozilla/5.0 (Macintosh)', '2025-11-13 10:00:00', '2025-11-10 13:30:00'),
(3, 1, 'f1865590f1d06c01595c6266397e1bfbea9a8358abe484074a4f97881be71f0d', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-19 04:05:10', '2025-11-12 09:05:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `student`
--

CREATE TABLE `student` (
  `StudentID` int(11) NOT NULL,
  `FirstName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `LastName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `BirthDate` date NOT NULL,
  `Gender` enum('M','F','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DocumentNumber` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PhoneNumber` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `GradeID` int(11) DEFAULT NULL,
  `ProfilePicture` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MedicalInfo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Alergias, medicamentos, condiciones',
  `EmergencyContact` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `EmergencyPhone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IsActive` tinyint(1) NOT NULL DEFAULT '1',
  `IsRecurrent` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=Recurrente, 0=Ocasional',
  `EnrollmentDate` date DEFAULT NULL,
  `WithdrawalDate` date DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `student`
--

INSERT INTO `student` (`StudentID`, `FirstName`, `LastName`, `BirthDate`, `Gender`, `DocumentNumber`, `Address`, `Email`, `PhoneNumber`, `GradeID`, `ProfilePicture`, `MedicalInfo`, `EmergencyContact`, `EmergencyPhone`, `IsActive`, `IsRecurrent`, `EnrollmentDate`, `WithdrawalDate`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 'Lucas', 'Vásquez', '2021-05-20', 'M', '0911111111', 'Av. Cipreses N45-67', 'lucas.vasquez@gmail.com', '0997001111', 1, 'profiles/lucas.jpg', 'Alergia leve a la leche', 'Gabriela Smith', '0991122334', 1, 1, '2024-01-05', NULL, '2025-11-06 13:00:00', '2025-11-11 13:00:00'),
(2, 'Sofía', 'López', '2020-08-15', 'F', '0912222222', 'Av. González Suárez N27-142', 'sofia.lopez@gmail.com', '0997002222', 2, 'profiles/sofia.jpg', 'Ninguna', 'Juan Rodríguez', '0984455667', 1, 1, '2023-09-10', NULL, '2025-11-06 13:05:00', '2025-11-11 13:05:00'),
(3, 'Martín', 'Morales', '2020-06-30', 'M', '0913333333', 'Calle Japón E7-119', 'martin.morales@gmail.com', '0997003333', 2, 'profiles/martin.jpg', 'Usa inhalador', 'María López', '0993344556', 1, 1, '2023-08-20', NULL, '2025-11-06 13:10:00', '2025-11-10 13:45:00'),
(4, 'Camila', 'Herrera', '2019-09-10', 'F', '0914444444', 'Av. Mariana de Jesús E7-45', 'camila.herrera@gmail.com', '0997004444', 3, 'profiles/camila.jpg', 'Control médico semestral', 'Ana Rodríguez', '0982233445', 1, 1, '2022-07-15', NULL, '2025-11-06 13:15:00', '2025-11-09 15:00:00'),
(5, 'Valentina', 'Pérez', '2019-10-25', 'F', '0915555555', 'Calle Francisco Salazar E4-56', 'valentina.perez@gmail.com', '0997005555', 3, 'profiles/valentina.jpg', 'Ninguna', 'Carlos García', '0985566778', 1, 1, '2022-07-20', NULL, '2025-11-06 13:20:00', '2025-11-11 20:00:00'),
(6, 'Emilia', 'Castro', '2019-03-17', 'F', '0916666666', 'Av. De los Shyris N35-234', 'emilia.castro@gmail.com', '0997006666', 4, 'profiles/emilia.jpg', 'Ninguna', 'Sofía Pérez', '0994455667', 1, 1, '2022-03-10', NULL, '2025-11-06 13:25:00', '2025-11-10 21:00:00'),
(7, 'Matías', 'Ruiz', '2019-04-02', 'M', '0917777777', 'Calle Luis Cordero E6-78', 'matias.ruiz@gmail.com', '0997007777', 4, 'profiles/matias.jpg', 'Alergia al polvo', 'Raúl Vargas', '0989988776', 1, 1, '2022-03-20', NULL, '2025-11-06 13:30:00', '2025-11-09 23:00:00'),
(8, 'Renata', 'Ávila', '2020-02-10', 'F', '0918888888', 'Av. Occidental N25-67', 'renata.avila@gmail.com', '0997008888', 2, 'profiles/renata.jpg', 'Ninguna', 'María Ruiz', '0995566777', 1, 1, '2023-05-05', NULL, '2025-11-06 13:35:00', '2025-11-08 23:30:00'),
(9, 'Santiago', 'Santana', '2019-01-28', 'M', '0919999999', 'Calle Diego de Almagro N32-89', 'santiago.santana@gmail.com', '0997009999', 4, 'profiles/santiago.jpg', 'Alergia al maní', 'José Martínez', '0986677889', 1, 1, '2021-11-01', NULL, '2025-11-06 13:40:00', '2025-11-09 00:00:00'),
(10, 'Isabela', 'Paredes', '2020-07-22', 'F', '0910000001', 'Av. Naciones Unidas E10-23', 'isabela.paredes@gmail.com', '0997010001', 2, 'profiles/isabela.jpg', 'Ninguna', 'Andrea Valencia', '0992233445', 1, 1, '2023-06-10', NULL, '2025-11-06 13:45:00', '2025-11-12 00:30:00'),
(11, 'Thiago', 'Jiménez', '2020-05-05', 'M', '0910000002', 'Av. Brasil N50-12', 'thiago.jimenez@gmail.com', '0997010002', 3, 'profiles/thiago.jpg', 'Alergia a la penicilina', 'Gabriela Smith', '0991122334', 1, 1, '2023-07-01', NULL, '2025-11-06 13:50:00', '2025-11-11 17:00:00'),
(12, 'Victoria', 'Romero', '2019-12-01', 'F', '0910000003', 'Av. República del Salvador N45-60', 'victoria.romero@gmail.com', '0997010003', 3, 'profiles/victoria.jpg', 'Ninguna', 'Juan Rodríguez', '0984455667', 1, 1, '2022-02-20', NULL, '2025-11-06 13:55:00', '2025-11-10 17:30:00'),
(13, 'Sebastián', 'Cárdenas', '2021-02-14', 'M', '0910000004', 'Calle Eloy Alfaro N28-88', 'sebastian.cardenas@gmail.com', '0997010004', 1, 'profiles/sebastian.jpg', 'Reflujo controlado', 'María López', '0993344556', 1, 1, '2024-09-01', NULL, '2025-11-06 14:00:00', '2025-11-10 13:45:00'),
(14, 'Emma', 'Paredes', '2021-06-08', 'F', '0910000005', 'Calle América N24-56', 'emma.paredes@gmail.com', '0997010005', 1, 'profiles/emma.jpg', 'Ninguna', 'Ana Rodríguez', '0982233445', 1, 1, '2024-09-10', NULL, '2025-11-06 14:05:00', '2025-11-08 19:00:00'),
(15, 'Samuel', 'Martínez', '2020-03-12', 'M', '0910000006', 'Av. Amazonas N33-100', 'samuel.martinez@gmail.com', '0997010006', 2, 'profiles/samuel.jpg', 'Alergia al polen', 'Carlos García', '0985566778', 1, 1, '2023-03-05', NULL, '2025-11-06 14:10:00', '2025-11-11 20:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `student_guardian`
--

CREATE TABLE `student_guardian` (
  `StudentGuardianID` int(11) NOT NULL,
  `StudentID` int(11) NOT NULL,
  `GuardianID` int(11) NOT NULL,
  `IsPrimary` tinyint(1) DEFAULT '0' COMMENT 'Contacto principal',
  `Priority` int(11) DEFAULT '1' COMMENT 'Orden de contacto en emergencias',
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `student_guardian`
--

INSERT INTO `student_guardian` (`StudentGuardianID`, `StudentID`, `GuardianID`, `IsPrimary`, `Priority`, `CreatedAt`) VALUES
(1, 1, 1, 1, 1, '2025-11-06 14:15:00'),
(2, 1, 2, 0, 2, '2025-11-06 14:16:00'),
(3, 2, 2, 1, 1, '2025-11-06 14:17:00'),
(4, 3, 3, 1, 1, '2025-11-06 14:18:00'),
(5, 4, 4, 1, 1, '2025-11-06 14:19:00'),
(6, 5, 5, 1, 1, '2025-11-06 14:20:00'),
(7, 6, 6, 1, 1, '2025-11-06 14:21:00'),
(8, 7, 7, 1, 1, '2025-11-06 14:22:00'),
(9, 8, 8, 1, 1, '2025-11-06 14:23:00'),
(10, 9, 9, 1, 1, '2025-11-06 14:24:00'),
(11, 10, 10, 1, 1, '2025-11-06 14:25:00'),
(12, 11, 1, 1, 1, '2025-11-06 14:26:00'),
(13, 12, 2, 1, 1, '2025-11-06 14:27:00'),
(14, 13, 3, 1, 1, '2025-11-06 14:28:00'),
(15, 14, 4, 1, 1, '2025-11-06 14:29:00'),
(16, 15, 5, 1, 1, '2025-11-06 14:30:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `student_observation`
--

CREATE TABLE `student_observation` (
  `ObservationID` int(11) NOT NULL,
  `StudentID` int(11) NOT NULL,
  `EmpID` int(11) NOT NULL COMMENT 'Docente que realiza la observación',
  `ObservationDate` date NOT NULL,
  `Category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Comportamiento, Aprendizaje, Social, Salud, etc.',
  `Observation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `IsPositive` tinyint(1) DEFAULT NULL COMMENT '1=Positivo, 0=Negativo, NULL=Neutral',
  `RequiresAction` tinyint(1) DEFAULT '0' COMMENT 'Requiere seguimiento',
  `ActionTaken` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `IsPrivate` tinyint(1) DEFAULT '0' COMMENT 'Visible solo para personal autorizado',
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `student_observation`
--

INSERT INTO `student_observation` (`ObservationID`, `StudentID`, `EmpID`, `ObservationDate`, `Category`, `Observation`, `IsPositive`, `RequiresAction`, `ActionTaken`, `IsPrivate`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 1, 3, '2025-11-08', 'Comportamiento', 'Lucas compartió sus juguetes con los compañeros', 1, 0, NULL, 0, '2025-11-08 19:30:00', NULL),
(2, 2, 2, '2025-11-07', 'Aprendizaje', 'Sofía muestra avance en reconocimiento de colores', 1, 0, NULL, 0, '2025-11-07 20:00:00', NULL),
(3, 7, 2, '2025-11-10', 'Salud', 'Matías presentó irritación en la piel', NULL, 1, 'Se informó a los padres y se aplicó protocolo', 1, '2025-11-10 18:00:00', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `student_payment`
--

CREATE TABLE `student_payment` (
  `StudentPaymentID` int(11) NOT NULL,
  `StudentID` int(11) NOT NULL,
  `ServiceType` enum('Hourly','Monthly','Daily','Event') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Monthly',
  `Hours` decimal(5,2) DEFAULT NULL COMMENT 'Solo para tipo Hourly',
  `RatePerHour` decimal(10,2) DEFAULT NULL COMMENT 'Solo para tipo Hourly',
  `MonthlyFee` decimal(10,2) DEFAULT NULL COMMENT 'Solo para tipo Monthly',
  `DailyFee` decimal(10,2) DEFAULT NULL COMMENT 'Solo para tipo Daily',
  `TotalAmount` decimal(10,2) NOT NULL,
  `PaidAmount` decimal(10,2) DEFAULT '0.00',
  `BalanceRemaining` decimal(10,2) DEFAULT '0.00',
  `PaymentDate` date DEFAULT NULL,
  `DueDate` date NOT NULL,
  `PaymentMethod` enum('Cash','Credit Card','Debit Card','Transfer','Check','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Status` enum('Paid','Pending','Overdue','Partial','Cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  `IsRecurrent` tinyint(1) DEFAULT '1' COMMENT '1=Recurrente (mensualidad), 0=Ocasional (por horas/día)',
  `StartDate` date DEFAULT NULL COMMENT 'Fecha inicio del servicio',
  `EndDate` date DEFAULT NULL COMMENT 'Fecha fin del servicio',
  `InvoiceNumber` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TransactionReference` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Referencia bancaria o transacción',
  `Notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ProcessedBy` int(11) DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `student_payment`
--

INSERT INTO `student_payment` (`StudentPaymentID`, `StudentID`, `ServiceType`, `Hours`, `RatePerHour`, `MonthlyFee`, `DailyFee`, `TotalAmount`, `PaidAmount`, `BalanceRemaining`, `PaymentDate`, `DueDate`, `PaymentMethod`, `Status`, `IsRecurrent`, `StartDate`, `EndDate`, `InvoiceNumber`, `TransactionReference`, `Notes`, `ProcessedBy`, `CreatedBy`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 1, 'Monthly', NULL, NULL, '350.00', NULL, '350.00', '350.00', '0.00', '2025-11-01', '2025-11-05', 'Transfer', 'Paid', 1, '2025-11-01', '2025-11-30', 'INV-2025-001', 'TRANS-001-2025', 'Pago noviembre', 2, 1, '2025-11-05 16:00:00', '2025-11-05 19:00:00'),
(2, 2, 'Monthly', NULL, NULL, '350.00', NULL, '350.00', '350.00', '0.00', '2025-11-02', '2025-11-05', 'Transfer', 'Paid', 1, '2025-11-01', '2025-11-30', 'INV-2025-002', 'TRANS-002-2025', 'Pago noviembre', 2, 1, '2025-11-06 16:00:00', '2025-11-06 19:00:00'),
(3, 3, 'Monthly', NULL, NULL, '350.00', NULL, '350.00', '175.00', '175.00', '2025-11-03', '2025-11-05', 'Cash', 'Partial', 1, '2025-11-01', '2025-11-30', 'INV-2025-003', NULL, 'Pago parcial', 3, 1, '2025-11-07 16:00:00', '2025-11-07 19:00:00'),
(4, 4, 'Monthly', NULL, NULL, '350.00', NULL, '350.00', '350.00', '0.00', '2025-11-01', '2025-11-05', 'Debit Card', 'Paid', 1, '2025-11-01', '2025-11-30', 'INV-2025-004', 'TRANS-004-2025', 'Pago noviembre', 4, 1, '2025-11-08 16:00:00', '2025-11-08 20:00:00'),
(5, 5, 'Monthly', NULL, NULL, '350.00', NULL, '350.00', '350.00', '0.00', '2025-11-01', '2025-11-05', 'Transfer', 'Paid', 1, '2025-11-01', '2025-11-30', 'INV-2025-005', 'TRANS-005-2025', 'Pago noviembre', 2, 1, '2025-11-09 16:00:00', '2025-11-09 19:00:00');

--
-- Disparadores `student_payment`
--
DELIMITER $$
CREATE TRIGGER `trg_student_payment_balance_insert` BEFORE INSERT ON `student_payment` FOR EACH ROW BEGIN
    SET NEW.BalanceRemaining = NEW.TotalAmount - NEW.PaidAmount;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_student_payment_balance_update` BEFORE UPDATE ON `student_payment` FOR EACH ROW BEGIN
    SET NEW.BalanceRemaining = NEW.TotalAmount - NEW.PaidAmount;
    
    -- Actualizar estado automáticamente
    IF NEW.BalanceRemaining = 0 THEN
        SET NEW.Status = 'Paid';
    ELSEIF NEW.PaidAmount > 0 AND NEW.BalanceRemaining > 0 THEN
        SET NEW.Status = 'Partial';
    ELSEIF NEW.DueDate < CURDATE() AND NEW.Status != 'Paid' THEN
        SET NEW.Status = 'Overdue';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `teacher_payment`
--

CREATE TABLE `teacher_payment` (
  `TeacherPaymentID` int(11) NOT NULL,
  `EmpID` int(11) NOT NULL,
  `PaymentPeriod` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ejemplo: 2025-11, 2025-Q4, 2025-W45',
  `PeriodStartDate` date NOT NULL,
  `PeriodEndDate` date NOT NULL,
  `BaseSalary` decimal(10,2) NOT NULL,
  `Bonuses` decimal(10,2) DEFAULT '0.00' COMMENT 'Bonificaciones',
  `Overtime` decimal(10,2) DEFAULT '0.00' COMMENT 'Horas extra',
  `Deductions` decimal(10,2) DEFAULT '0.00' COMMENT 'Deducciones (impuestos, préstamos, etc.)',
  `TotalAmount` decimal(10,2) NOT NULL,
  `PaymentDate` date NOT NULL,
  `PaymentMethod` enum('Cash','Transfer','Check','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Transfer',
  `Status` enum('Paid','Pending','Processing','Cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pending',
  `TransactionReference` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ProcessedBy` int(11) DEFAULT NULL,
  `CreatedBy` int(11) DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `teacher_payment`
--

INSERT INTO `teacher_payment` (`TeacherPaymentID`, `EmpID`, `PaymentPeriod`, `PeriodStartDate`, `PeriodEndDate`, `BaseSalary`, `Bonuses`, `Overtime`, `Deductions`, `TotalAmount`, `PaymentDate`, `PaymentMethod`, `Status`, `TransactionReference`, `Notes`, `ProcessedBy`, `CreatedBy`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 1, '2025-10', '2025-10-01', '2025-10-31', '1400.00', '200.00', '0.00', '150.00', '1450.00', '2025-11-05', 'Transfer', 'Paid', 'PAY-DIR-001-2025', 'Pago octubre con bono', 1, 1, '2025-11-05 17:00:00', '2025-11-05 19:00:00'),
(2, 2, '2025-10', '2025-10-01', '2025-10-31', '980.00', '50.00', '0.00', '90.00', '940.00', '2025-11-05', 'Transfer', 'Paid', 'PAY-TCH-002-2025', 'Pago octubre', 1, 1, '2025-11-06 17:00:00', '2025-11-06 19:00:00'),
(3, 3, '2025-10', '2025-10-01', '2025-10-31', '1020.00', '0.00', '0.00', '96.30', '923.70', '2025-11-05', 'Transfer', 'Paid', 'PAY-TCH-003-2025', 'Pago octubre', 1, 1, '2025-11-07 17:00:00', '2025-11-07 19:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user`
--

CREATE TABLE `user` (
  `UserID` int(11) NOT NULL,
  `UserName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `PasswordHash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `FirstName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `LastName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IsActive` tinyint(1) NOT NULL DEFAULT '1',
  `LastLogin` datetime DEFAULT NULL,
  `PasswordResetToken` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PasswordResetExpires` datetime DEFAULT NULL,
  `CreatedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`UserID`, `UserName`, `PasswordHash`, `Email`, `FirstName`, `LastName`, `Phone`, `Address`, `IsActive`, `LastLogin`, `PasswordResetToken`, `PasswordResetExpires`, `CreatedAt`, `UpdatedAt`) VALUES
(1, 'admin', '$2y$10$RB3GHK0tnk3XOBhlgYgpx.osqFJVAGTjvvdIVe.edey3Vlv3DbOOu', 'admin.nicekids@gmail.com', 'María', 'Rodríguez', '0998765432', 'Av. 6 de Diciembre N34-120', 1, '2025-11-12 04:05:10', NULL, NULL, '2025-11-05 14:00:00', '2025-11-12 09:05:10'),
(2, 'psanchez', 'hash_pat_2', 'patricia.sanchez@gmail.com', 'Patricia', 'Sánchez', '0987654321', 'Av. República E7-123', 1, '2025-11-10 08:30:00', NULL, NULL, '2025-11-06 14:00:00', '2025-11-10 13:30:00'),
(3, 'cmendoza', 'hash_car_3', 'carmen.mendoza@gmail.com', 'Carmen', 'Mendoza', '0976543210', 'Av. 10 de Agosto N26-45', 1, '2025-11-09 08:45:00', NULL, NULL, '2025-11-06 14:05:00', '2025-11-09 13:45:00'),
(4, 'lgarcia', 'hash_luc_4', 'lucia.garcia@gmail.com', 'Lucía', 'García', '0965432109', 'Av. Naciones Unidas N36-188', 1, '2025-11-09 10:00:00', NULL, NULL, '2025-11-06 14:10:00', '2025-11-09 15:00:00'),
(5, 'atorres', 'hash_diego_5', 'diego.torres@gmail.com', 'Diego', 'Torres', '0998877665', 'Av. América N45-123', 1, '2025-11-08 11:00:00', NULL, NULL, '2025-11-06 14:15:00', '2025-11-08 16:00:00'),
(6, 'gsmith', 'hash_gs_6', 'gabriela.smith@gmail.com', 'Gabriela', 'Smith', '0991122334', 'Calle El Sol 12', 1, '2025-11-11 12:00:00', NULL, NULL, '2025-11-07 14:00:00', '2025-11-11 17:00:00'),
(7, 'jrodriguez', 'hash_jr_7', 'juan.rodriguez@gmail.com', 'Juan', 'Rodríguez', '0984455667', 'Calle La Paz 45', 1, '2025-11-10 12:30:00', NULL, NULL, '2025-11-07 14:05:00', '2025-11-10 17:30:00'),
(8, 'mlopez', 'hash_ml_8', 'maria.lopez@gmail.com', 'María', 'López', '0993344556', 'Av. Simón Bolívar 90', 1, '2025-11-09 09:30:00', NULL, NULL, '2025-11-07 14:10:00', '2025-11-09 14:30:00'),
(9, 'arodriguez', '$2y$10$RB3GHK0tnk3XOBhlgYgpx.osqFJVAGTjvvdIVe.edey3Vlv3DbOOu', 'ana.rodriguez@gmail.com', 'Ana', 'Rodríguez', '0982233445', 'Calle Las Rosas 33', 1, '2025-11-08 14:00:00', NULL, NULL, '2025-11-07 14:15:00', '2025-11-12 09:04:29'),
(10, 'cgarcia', 'hash_cg_10', 'carlos.garcia@gmail.com', 'Carlos', 'García', '0985566778', 'Av. Amazonas 120', 1, '2025-11-11 15:00:00', NULL, NULL, '2025-11-07 14:20:00', '2025-11-11 20:00:00'),
(11, 'sanchezp', 'hash_sp_11', 'sofia.perez@gmail.com', 'Sofía', 'Pérez', '0994455667', 'Calle Primera 7', 1, '2025-11-10 16:00:00', NULL, NULL, '2025-11-07 14:25:00', '2025-11-10 21:00:00'),
(12, 'rvargas', 'hash_rv_12', 'raul.vargas@gmail.com', 'Raúl', 'Vargas', '0989988776', 'Calle Segunda 24', 1, '2025-11-09 18:00:00', NULL, NULL, '2025-11-07 14:30:00', '2025-11-09 23:00:00'),
(13, 'mruiz', 'hash_mr_13', 'maria.ruiz@gmail.com', 'María', 'Ruiz', '0995566777', 'Av. Siempre Viva 5', 1, '2025-11-08 18:30:00', NULL, NULL, '2025-11-07 14:35:00', '2025-11-08 23:30:00'),
(14, 'jmartinez', 'hash_jm_14', 'jose.martinez@gmail.com', 'José', 'Martínez', '0986677889', 'Calle Tercera 40', 1, '2025-11-08 19:00:00', NULL, NULL, '2025-11-07 14:40:00', '2025-11-09 00:00:00'),
(15, 'avalencia', '$2y$10$RB3GHK0tnk3XOBhlgYgpx.osqFJVAGTjvvdIVe.edey3Vlv3DbOOu', 'andrea.valencia@gmail.com', 'Andrea', 'Valencia', '0992233445', 'Av. Reforma 22', 1, '2025-11-11 19:30:00', NULL, NULL, '2025-11-07 14:45:00', '2025-11-12 09:04:32'),
(16, 'cvasquez', 'hash_cv_16', 'carlos.vasquez@gmail.com', 'Carlos', 'Vásquez', '0982345678', 'Calle Verde 8', 1, '2025-11-10 20:00:00', NULL, NULL, '2025-11-07 14:50:00', '2025-11-11 01:00:00'),
(17, 'dlopez', 'hash_dl_17', 'diego.lopez@gmail.com', 'Diego', 'López', '0984567890', 'Av. Central 77', 1, '2025-11-09 21:15:00', NULL, NULL, '2025-11-07 14:55:00', '2025-11-10 02:15:00'),
(18, 'ncastro', 'hash_nc_18', 'natalia.castro@gmail.com', 'Natalia', 'Castro', '0999012345', 'Calle Nueva 12', 1, '2025-11-11 21:00:00', NULL, NULL, '2025-11-07 15:00:00', '2025-11-12 02:00:00'),
(19, 'gsantos', 'hash_gs_19', 'gabriela.santos@gmail.com', 'Gabriela', 'Santos', '0990123456', 'Av. Los Rios 99', 1, '2025-11-11 21:30:00', NULL, NULL, '2025-11-07 15:05:00', '2025-11-12 02:30:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_role`
--

CREATE TABLE `user_role` (
  `UserRoleID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `RoleID` int(11) NOT NULL,
  `AssignedAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `AssignedBy` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `user_role`
--

INSERT INTO `user_role` (`UserRoleID`, `UserID`, `RoleID`, `AssignedAt`, `AssignedBy`) VALUES
(1, 1, 1, '2025-11-05 14:05:00', 1),
(2, 2, 2, '2025-11-06 14:10:00', 1),
(3, 3, 2, '2025-11-06 14:11:00', 1),
(4, 4, 2, '2025-11-06 14:12:00', 1),
(5, 5, 2, '2025-11-06 14:13:00', 1),
(6, 6, 3, '2025-11-07 15:00:00', 1),
(7, 7, 3, '2025-11-07 15:05:00', 1),
(8, 8, 3, '2025-11-07 15:10:00', 1),
(9, 9, 3, '2025-11-07 15:15:00', 1),
(10, 10, 3, '2025-11-07 15:20:00', 1),
(11, 11, 3, '2025-11-07 15:25:00', 1),
(12, 12, 3, '2025-11-07 15:30:00', 1),
(13, 13, 3, '2025-11-07 15:35:00', 1),
(14, 14, 3, '2025-11-07 15:40:00', 1),
(15, 15, 3, '2025-11-07 15:45:00', 1),
(16, 16, 3, '2025-11-07 15:50:00', 1),
(17, 17, 3, '2025-11-07 15:55:00', 1),
(18, 18, 3, '2025-11-07 16:00:00', 1),
(19, 19, 3, '2025-11-07 16:05:00', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `activity`
--
ALTER TABLE `activity`
  ADD PRIMARY KEY (`ActivityID`),
  ADD KEY `GradeID` (`GradeID`),
  ADD KEY `EmpID` (`EmpID`),
  ADD KEY `CreatedBy` (`CreatedBy`),
  ADD KEY `idx_activity_date` (`ScheduledDate`),
  ADD KEY `idx_activity_status` (`Status`);

--
-- Indices de la tabla `activity_media`
--
ALTER TABLE `activity_media`
  ADD PRIMARY KEY (`MediaID`),
  ADD KEY `ActivityID` (`ActivityID`),
  ADD KEY `UploadedBy` (`UploadedBy`);

--
-- Indices de la tabla `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`AttendanceID`),
  ADD UNIQUE KEY `unique_student_date` (`StudentID`,`Date`),
  ADD KEY `CheckedInBy` (`CheckedInBy`),
  ADD KEY `CheckedOutBy` (`CheckedOutBy`),
  ADD KEY `idx_attendance_date` (`Date`),
  ADD KEY `idx_attendance_status` (`Status`),
  ADD KEY `idx_attendance_student_date` (`StudentID`,`Date`);

--
-- Indices de la tabla `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`LogID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `idx_audit_action` (`Action`),
  ADD KEY `idx_audit_table` (`TableName`),
  ADD KEY `idx_audit_date` (`CreatedAt`);

--
-- Indices de la tabla `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`EmpID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `idx_employee_name` (`FirstName`,`LastName`),
  ADD KEY `idx_employee_active` (`IsActive`),
  ADD KEY `idx_document` (`DocumentNumber`);

--
-- Indices de la tabla `employee_task`
--
ALTER TABLE `employee_task`
  ADD PRIMARY KEY (`TaskID`),
  ADD KEY `EmpID` (`EmpID`),
  ADD KEY `CreatedBy` (`CreatedBy`),
  ADD KEY `idx_task_status` (`Status`),
  ADD KEY `idx_task_due_date` (`DueDate`);

--
-- Indices de la tabla `grade`
--
ALTER TABLE `grade`
  ADD PRIMARY KEY (`GradeID`),
  ADD KEY `idx_grade_active` (`IsActive`);

--
-- Indices de la tabla `guardian`
--
ALTER TABLE `guardian`
  ADD PRIMARY KEY (`GuardianID`),
  ADD KEY `idx_guardian_name` (`FirstName`,`LastName`),
  ADD KEY `idx_document` (`DocumentNumber`);

--
-- Indices de la tabla `invoice`
--
ALTER TABLE `invoice`
  ADD PRIMARY KEY (`InvoiceID`),
  ADD UNIQUE KEY `InvoiceNumber` (`InvoiceNumber`),
  ADD KEY `CreatedBy` (`CreatedBy`),
  ADD KEY `idx_invoice_type` (`InvoiceType`),
  ADD KEY `idx_invoice_reference` (`ReferenceID`),
  ADD KEY `idx_invoice_status` (`Status`),
  ADD KEY `idx_invoice_date` (`IssueDate`);

--
-- Indices de la tabla `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`NotificationID`),
  ADD KEY `SenderID` (`SenderID`),
  ADD KEY `ReceiverID` (`ReceiverID`),
  ADD KEY `idx_notification_read` (`IsRead`),
  ADD KEY `idx_notification_type` (`Type`),
  ADD KEY `idx_notification_receiver` (`ReceiverID`,`IsRead`),
  ADD KEY `idx_notification_receiver_unread` (`ReceiverID`,`IsRead`,`CreatedAt`);

--
-- Indices de la tabla `permission`
--
ALTER TABLE `permission`
  ADD PRIMARY KEY (`PermissionID`),
  ADD UNIQUE KEY `unique_permission` (`Module`,`Action`),
  ADD KEY `idx_module` (`Module`);

--
-- Indices de la tabla `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`RoleID`),
  ADD UNIQUE KEY `RoleName` (`RoleName`);

--
-- Indices de la tabla `role_permission`
--
ALTER TABLE `role_permission`
  ADD PRIMARY KEY (`RolePermissionID`),
  ADD UNIQUE KEY `unique_role_permission` (`RoleID`,`PermissionID`),
  ADD KEY `PermissionID` (`PermissionID`);

--
-- Indices de la tabla `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`SessionID`),
  ADD UNIQUE KEY `Token` (`Token`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `idx_session_expires` (`ExpiresAt`);

--
-- Indices de la tabla `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`StudentID`),
  ADD KEY `GradeID` (`GradeID`),
  ADD KEY `idx_student_name` (`FirstName`,`LastName`),
  ADD KEY `idx_student_active` (`IsActive`),
  ADD KEY `idx_student_recurrent` (`IsRecurrent`),
  ADD KEY `idx_document` (`DocumentNumber`);

--
-- Indices de la tabla `student_guardian`
--
ALTER TABLE `student_guardian`
  ADD PRIMARY KEY (`StudentGuardianID`),
  ADD UNIQUE KEY `unique_student_guardian` (`StudentID`,`GuardianID`),
  ADD KEY `GuardianID` (`GuardianID`);

--
-- Indices de la tabla `student_observation`
--
ALTER TABLE `student_observation`
  ADD PRIMARY KEY (`ObservationID`),
  ADD KEY `StudentID` (`StudentID`),
  ADD KEY `EmpID` (`EmpID`),
  ADD KEY `idx_observation_date` (`ObservationDate`),
  ADD KEY `idx_observation_category` (`Category`);

--
-- Indices de la tabla `student_payment`
--
ALTER TABLE `student_payment`
  ADD PRIMARY KEY (`StudentPaymentID`),
  ADD KEY `StudentID` (`StudentID`),
  ADD KEY `ProcessedBy` (`ProcessedBy`),
  ADD KEY `CreatedBy` (`CreatedBy`),
  ADD KEY `idx_payment_status` (`Status`),
  ADD KEY `idx_payment_date` (`PaymentDate`),
  ADD KEY `idx_due_date` (`DueDate`),
  ADD KEY `idx_service_type` (`ServiceType`),
  ADD KEY `idx_invoice` (`InvoiceNumber`),
  ADD KEY `idx_student_payment_student_status` (`StudentID`,`Status`),
  ADD KEY `idx_student_payment_dates` (`PaymentDate`,`DueDate`);

--
-- Indices de la tabla `teacher_payment`
--
ALTER TABLE `teacher_payment`
  ADD PRIMARY KEY (`TeacherPaymentID`),
  ADD KEY `EmpID` (`EmpID`),
  ADD KEY `ProcessedBy` (`ProcessedBy`),
  ADD KEY `CreatedBy` (`CreatedBy`),
  ADD KEY `idx_payment_status` (`Status`),
  ADD KEY `idx_payment_date` (`PaymentDate`),
  ADD KEY `idx_payment_period` (`PaymentPeriod`),
  ADD KEY `idx_teacher_payment_employee_period` (`EmpID`,`PaymentPeriod`);

--
-- Indices de la tabla `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `UserName` (`UserName`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `idx_username` (`UserName`),
  ADD KEY `idx_email` (`Email`),
  ADD KEY `idx_active` (`IsActive`);

--
-- Indices de la tabla `user_role`
--
ALTER TABLE `user_role`
  ADD PRIMARY KEY (`UserRoleID`),
  ADD UNIQUE KEY `unique_user_role` (`UserID`,`RoleID`),
  ADD KEY `RoleID` (`RoleID`),
  ADD KEY `AssignedBy` (`AssignedBy`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `activity`
--
ALTER TABLE `activity`
  MODIFY `ActivityID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `activity_media`
--
ALTER TABLE `activity_media`
  MODIFY `MediaID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `attendance`
--
ALTER TABLE `attendance`
  MODIFY `AttendanceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `LogID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `employee`
--
ALTER TABLE `employee`
  MODIFY `EmpID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `employee_task`
--
ALTER TABLE `employee_task`
  MODIFY `TaskID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `grade`
--
ALTER TABLE `grade`
  MODIFY `GradeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `guardian`
--
ALTER TABLE `guardian`
  MODIFY `GuardianID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `invoice`
--
ALTER TABLE `invoice`
  MODIFY `InvoiceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `notification`
--
ALTER TABLE `notification`
  MODIFY `NotificationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `permission`
--
ALTER TABLE `permission`
  MODIFY `PermissionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `role`
--
ALTER TABLE `role`
  MODIFY `RoleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `role_permission`
--
ALTER TABLE `role_permission`
  MODIFY `RolePermissionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=217;

--
-- AUTO_INCREMENT de la tabla `session`
--
ALTER TABLE `session`
  MODIFY `SessionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `student`
--
ALTER TABLE `student`
  MODIFY `StudentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `student_guardian`
--
ALTER TABLE `student_guardian`
  MODIFY `StudentGuardianID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `student_observation`
--
ALTER TABLE `student_observation`
  MODIFY `ObservationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `student_payment`
--
ALTER TABLE `student_payment`
  MODIFY `StudentPaymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `teacher_payment`
--
ALTER TABLE `teacher_payment`
  MODIFY `TeacherPaymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `user`
--
ALTER TABLE `user`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `user_role`
--
ALTER TABLE `user_role`
  MODIFY `UserRoleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `activity`
--
ALTER TABLE `activity`
  ADD CONSTRAINT `fk_activity_created_by` FOREIGN KEY (`CreatedBy`) REFERENCES `user` (`UserID`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_activity_employee` FOREIGN KEY (`EmpID`) REFERENCES `employee` (`EmpID`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_activity_grade` FOREIGN KEY (`GradeID`) REFERENCES `grade` (`GradeID`) ON DELETE SET NULL;

--
-- Filtros para la tabla `activity_media`
--
ALTER TABLE `activity_media`
  ADD CONSTRAINT `fk_activity_media_activity` FOREIGN KEY (`ActivityID`) REFERENCES `activity` (`ActivityID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_activity_media_uploaded_by` FOREIGN KEY (`UploadedBy`) REFERENCES `user` (`UserID`) ON DELETE SET NULL;

--
-- Filtros para la tabla `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `fk_attendance_checked_in_by` FOREIGN KEY (`CheckedInBy`) REFERENCES `employee` (`EmpID`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_attendance_checked_out_by` FOREIGN KEY (`CheckedOutBy`) REFERENCES `employee` (`EmpID`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_attendance_student` FOREIGN KEY (`StudentID`) REFERENCES `student` (`StudentID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `audit_log`
--
ALTER TABLE `audit_log`
  ADD CONSTRAINT `fk_audit_log_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE SET NULL;

--
-- Filtros para la tabla `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `fk_employee_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE SET NULL;

--
-- Filtros para la tabla `employee_task`
--
ALTER TABLE `employee_task`
  ADD CONSTRAINT `fk_employee_task_created_by` FOREIGN KEY (`CreatedBy`) REFERENCES `user` (`UserID`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_employee_task_employee` FOREIGN KEY (`EmpID`) REFERENCES `employee` (`EmpID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `invoice`
--
ALTER TABLE `invoice`
  ADD CONSTRAINT `fk_invoice_created_by` FOREIGN KEY (`CreatedBy`) REFERENCES `user` (`UserID`) ON DELETE SET NULL;

--
-- Filtros para la tabla `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `fk_notification_receiver` FOREIGN KEY (`ReceiverID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_notification_sender` FOREIGN KEY (`SenderID`) REFERENCES `user` (`UserID`) ON DELETE SET NULL;

--
-- Filtros para la tabla `role_permission`
--
ALTER TABLE `role_permission`
  ADD CONSTRAINT `fk_role_permission_permission` FOREIGN KEY (`PermissionID`) REFERENCES `permission` (`PermissionID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_role_permission_role` FOREIGN KEY (`RoleID`) REFERENCES `role` (`RoleID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `session`
--
ALTER TABLE `session`
  ADD CONSTRAINT `fk_session_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `student`
--
ALTER TABLE `student`
  ADD CONSTRAINT `fk_student_grade` FOREIGN KEY (`GradeID`) REFERENCES `grade` (`GradeID`) ON DELETE SET NULL;

--
-- Filtros para la tabla `student_guardian`
--
ALTER TABLE `student_guardian`
  ADD CONSTRAINT `fk_student_guardian_guardian` FOREIGN KEY (`GuardianID`) REFERENCES `guardian` (`GuardianID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_student_guardian_student` FOREIGN KEY (`StudentID`) REFERENCES `student` (`StudentID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `student_observation`
--
ALTER TABLE `student_observation`
  ADD CONSTRAINT `fk_observation_employee` FOREIGN KEY (`EmpID`) REFERENCES `employee` (`EmpID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_observation_student` FOREIGN KEY (`StudentID`) REFERENCES `student` (`StudentID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `student_payment`
--
ALTER TABLE `student_payment`
  ADD CONSTRAINT `fk_student_payment_created_by` FOREIGN KEY (`CreatedBy`) REFERENCES `user` (`UserID`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_student_payment_processed_by` FOREIGN KEY (`ProcessedBy`) REFERENCES `employee` (`EmpID`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_student_payment_student` FOREIGN KEY (`StudentID`) REFERENCES `student` (`StudentID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `teacher_payment`
--
ALTER TABLE `teacher_payment`
  ADD CONSTRAINT `fk_teacher_payment_created_by` FOREIGN KEY (`CreatedBy`) REFERENCES `user` (`UserID`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_teacher_payment_employee` FOREIGN KEY (`EmpID`) REFERENCES `employee` (`EmpID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_teacher_payment_processed_by` FOREIGN KEY (`ProcessedBy`) REFERENCES `user` (`UserID`) ON DELETE SET NULL;

--
-- Filtros para la tabla `user_role`
--
ALTER TABLE `user_role`
  ADD CONSTRAINT `fk_user_role_assigned_by` FOREIGN KEY (`AssignedBy`) REFERENCES `user` (`UserID`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_user_role_role` FOREIGN KEY (`RoleID`) REFERENCES `role` (`RoleID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_role_user` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
