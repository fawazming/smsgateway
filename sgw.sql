-- Adminer 4.8.1 MySQL 10.4.32-MariaDB dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `blacklist`;
CREATE TABLE `blacklist` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `number` varchar(16) NOT NULL,
  `userID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `numberUserID` (`number`,`userID`),
  KEY `userID` (`userID`),
  CONSTRAINT `blacklist_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `contact`;
CREATE TABLE `contact` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `number` varchar(255) NOT NULL,
  `subscribed` tinyint(1) NOT NULL DEFAULT 1,
  `contactsListID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `contactsListID` (`contactsListID`),
  CONSTRAINT `contact_ibfk_1` FOREIGN KEY (`contactsListID`) REFERENCES `contactslist` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `contactslist`;
CREATE TABLE `contactslist` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `userID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `userID` (`userID`),
  CONSTRAINT `contactslist_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `device`;
CREATE TABLE `device` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) DEFAULT NULL,
  `model` varchar(255) NOT NULL,
  `androidVersion` varchar(255) DEFAULT NULL,
  `appVersion` varchar(255) DEFAULT NULL,
  `userID` int(11) NOT NULL,
  `androidID` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 0,
  `sharedToAll` tinyint(1) NOT NULL DEFAULT 0,
  `useOwnerSettings` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `androidUserID` (`androidID`,`userID`),
  KEY `userID` (`userID`),
  CONSTRAINT `device_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `device` (`ID`, `token`, `model`, `androidVersion`, `appVersion`, `userID`, `androidID`, `enabled`, `sharedToAll`, `useOwnerSettings`) VALUES
(1,	NULL,	'TECNO POP 5',	'11',	'9.4.5',	1,	'dc38ddcf31748173',	0,	1,	1);

DROP TABLE IF EXISTS `deviceuser`;
CREATE TABLE `deviceuser` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `deviceID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `deviceUserID` (`deviceID`,`userID`),
  KEY `userID` (`userID`),
  CONSTRAINT `deviceuser_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `deviceuser_ibfk_2` FOREIGN KEY (`deviceID`) REFERENCES `device` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `deviceuser` (`ID`, `name`, `deviceID`, `userID`, `active`) VALUES
(1,	'Tecno',	1,	1,	1);

DROP TABLE IF EXISTS `job`;
CREATE TABLE `job` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `functionName` varchar(255) NOT NULL,
  `arguments` text NOT NULL,
  `lockName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `number` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `schedule` bigint(20) DEFAULT NULL,
  `sentDate` datetime NOT NULL,
  `deliveredDate` datetime DEFAULT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `status` varchar(10) NOT NULL,
  `resultCode` int(11) DEFAULT NULL,
  `errorCode` int(11) DEFAULT NULL,
  `retries` int(11) NOT NULL DEFAULT 0,
  `userID` int(11) NOT NULL,
  `deviceID` int(11) DEFAULT NULL,
  `simSlot` int(11) DEFAULT NULL,
  `groupID` varchar(255) DEFAULT NULL,
  `type` enum('sms','mms') NOT NULL DEFAULT 'sms',
  `attachments` text DEFAULT NULL,
  `prioritize` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  KEY `userID` (`userID`),
  KEY `deviceID` (`deviceID`),
  KEY `groupID_index` (`groupID`),
  CONSTRAINT `message_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `message_ibfk_2` FOREIGN KEY (`deviceID`) REFERENCES `device` (`ID`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `transactionFee` int(11) NOT NULL,
  `currency` varchar(255) NOT NULL,
  `dateAdded` datetime NOT NULL,
  `userID` int(11) NOT NULL,
  `subscriptionID` int(11) NOT NULL,
  `transactionID` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `transactionID` (`transactionID`),
  KEY `userID` (`userID`),
  KEY `subscriptionID` (`subscriptionID`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`subscriptionID`) REFERENCES `subscription` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `plan`;
CREATE TABLE `plan` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `credits` int(11) DEFAULT NULL,
  `devices` int(11) DEFAULT NULL,
  `contacts` int(11) DEFAULT NULL,
  `price` int(11) NOT NULL,
  `currency` varchar(255) NOT NULL,
  `frequency` int(11) NOT NULL,
  `frequencyUnit` varchar(255) NOT NULL,
  `totalCycles` int(11) NOT NULL DEFAULT 0,
  `paypalPlanID` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `paypalPlanID` (`paypalPlanID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `response`;
CREATE TABLE `response` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `message` text NOT NULL,
  `response` text NOT NULL,
  `matchType` tinyint(1) NOT NULL DEFAULT 0,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `userID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `userID` (`userID`),
  CONSTRAINT `response_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `setting`;
CREATE TABLE `setting` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `setting` (`ID`, `name`, `value`) VALUES
(1,	'firebase_service_account_json',	NULL);

DROP TABLE IF EXISTS `sim`;
CREATE TABLE `sim` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `number` varchar(255) DEFAULT NULL,
  `carrier` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `iccID` varchar(255) DEFAULT NULL,
  `slot` int(11) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `deviceID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `deviceID` (`deviceID`),
  CONSTRAINT `sim_ibfk_1` FOREIGN KEY (`deviceID`) REFERENCES `device` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `sim` (`ID`, `name`, `number`, `carrier`, `country`, `iccID`, `slot`, `enabled`, `deviceID`) VALUES
(1,	'MTN NG',	'',	'No service',	'ng',	'',	1,	1,	1);

DROP TABLE IF EXISTS `subscription`;
CREATE TABLE `subscription` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `subscribedDate` datetime NOT NULL,
  `expiryDate` datetime NOT NULL,
  `cyclesCompleted` int(11) NOT NULL,
  `status` varchar(255) NOT NULL,
  `paymentMethod` varchar(255) NOT NULL,
  `subscriptionID` varchar(255) DEFAULT NULL,
  `planID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `subscriptionID` (`subscriptionID`),
  KEY `planID` (`planID`),
  KEY `userID` (`userID`),
  CONSTRAINT `subscription_ibfk_1` FOREIGN KEY (`planID`) REFERENCES `plan` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `subscription_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `user` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `template`;
CREATE TABLE `template` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `userID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `userID` (`userID`),
  CONSTRAINT `template_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(70) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `apiKey` char(40) NOT NULL,
  `isAdmin` tinyint(1) NOT NULL DEFAULT 0,
  `primaryDeviceID` int(11) DEFAULT 0,
  `dateAdded` datetime NOT NULL,
  `lastLogin` datetime DEFAULT NULL,
  `lastLoginIP` varchar(255) DEFAULT NULL,
  `delay` varchar(7) NOT NULL DEFAULT '2',
  `ussdDelay` int(11) NOT NULL DEFAULT 0,
  `webHook` varchar(255) DEFAULT NULL,
  `devicesLimit` int(11) DEFAULT NULL,
  `contactsLimit` int(11) DEFAULT NULL,
  `credits` int(11) DEFAULT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `timeZone` varchar(255) NOT NULL DEFAULT 'Africa/Lagos',
  `reportDelivery` tinyint(1) NOT NULL DEFAULT 0,
  `autoRetry` tinyint(1) NOT NULL DEFAULT 0,
  `smsToEmail` tinyint(1) NOT NULL DEFAULT 0,
  `useProgressiveQueue` tinyint(1) NOT NULL DEFAULT 1,
  `receivedSmsEmail` varchar(255) DEFAULT NULL,
  `sleepTime` varchar(255) DEFAULT NULL,
  `language` varchar(255) NOT NULL DEFAULT 'english',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `apiKey` (`apiKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `user` (`ID`, `name`, `email`, `password`, `apiKey`, `isAdmin`, `primaryDeviceID`, `dateAdded`, `lastLogin`, `lastLoginIP`, `delay`, `ussdDelay`, `webHook`, `devicesLimit`, `contactsLimit`, `credits`, `expiryDate`, `timeZone`, `reportDelivery`, `autoRetry`, `smsToEmail`, `useProgressiveQueue`, `receivedSmsEmail`, `sleepTime`, `language`) VALUES
(1,	'RayyanTech',	'fawazpro27@gmail.com',	'$2y$12$2nofUFgda2bi9uz/EkEdW.A50vz20MJAkLfWGGvEUGzYEvXXvH.TS',	'f34cab329a4b08b900d13fd2ce7e1c6310c14c02',	1,	0,	'2024-08-18 05:07:40',	'2024-08-18 05:12:14',	'192.168.43.65',	'2',	0,	NULL,	NULL,	NULL,	NULL,	NULL,	'Africa/Lagos',	0,	0,	0,	1,	NULL,	NULL,	'English');

DROP TABLE IF EXISTS `ussd`;
CREATE TABLE `ussd` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `request` varchar(255) NOT NULL,
  `response` text DEFAULT NULL,
  `userID` int(11) NOT NULL,
  `deviceID` int(11) DEFAULT NULL,
  `simSlot` int(11) DEFAULT NULL,
  `sentDate` datetime NOT NULL,
  `responseDate` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `userID` (`userID`),
  KEY `deviceID` (`deviceID`),
  CONSTRAINT `ussd_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `ussd_ibfk_2` FOREIGN KEY (`deviceID`) REFERENCES `device` (`ID`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- 2024-08-18 16:39:18
