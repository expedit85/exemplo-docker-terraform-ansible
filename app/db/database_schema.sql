-- Esta linha foi comentada porque o container já cria o database
-- CREATE DATABASE `notes`;

CREATE TABLE `notes`.`Note` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Text` varchar(255) NOT NULL,
  `CreateDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;
