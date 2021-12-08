CREATE TABLE `web2identity` (
  `identity_id` integer PRIMARY KEY,
  `emailAddress` varchar(255) NOT NULL,
  `phoneNumber` varchar(255) NOT NULL
);

CREATE TABLE `newAssociate` (
  `newA_id` integer PRIMARY KEY,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `identity_id` integer
);

CREATE TABLE `associate` (
  `a_id` integer PRIMARY KEY,
  `newA_id` integer,
  `dateOfBirth` datetime,
  `address` varchar(255)
);

CREATE TABLE `department` (
  `dep_id` integer PRIMARY KEY,
  `depName` varchar(255) NOT NULL
);

CREATE TABLE `employee` (
  `e_id` integer PRIMARY KEY,
  `j_id` integer,
  `a_id` integer,
  `supervisor_e_id` integer,
  `isFounder` boolean DEFAULT 0,
  `adminRights` boolean DEFAULT 0 COMMENT 'bypasses everything, even the product constraints',
  `i_id` integer
);

CREATE TABLE `job` (
  `j_id` integer PRIMARY KEY,
  `jobName` str NOT NULL,
  `salary` integer NOT NULL,
  `perm_id` integer
);

CREATE TABLE `permission` (
  `perm_id` integer PRIMARY KEY,
  `canRepresent` boolean NOT NULL DEFAULT false,
  `canProcess` boolean NOT NULL DEFAULT false
);

CREATE TABLE `product` (
  `p_id` integer PRIMARY KEY,
  `productName` varchar(255),
  `productPrice` integer,
  `productExpiry_days` integer
);

CREATE TABLE `productConstraints` (
  `p_id` integer,
  `dep_id` integer,
  `perm_id` integer,
  `maxPerPerson` integer COMMENT 'if null, infinity. This is useful for license, permit, id limited to 1 person',
  PRIMARY KEY (`p_id`, `dep_id`)
);

CREATE TABLE `id` (
  `i_id` integer PRIMARY KEY,
  `apOK_id` integer,
  `revoked` datetime DEFAULT NULL COMMENT 'if null, not revoked yet'
);

CREATE TABLE `vehicleID` (
  `v_id` integer PRIMARY KEY,
  `i_id` integer COMMENT 'vehicleID extends id'
);

CREATE TABLE `appointment` (
  `ap_id` integer PRIMARY KEY,
  `customer_newA_id` integer COMMENT 'newA_id of potential customer who scheduled appt',
  `repEmployee_e_id` integer COMMENT 'e_id of the representative',
  `p_id` integer,
  `appointegermentDate` datetime COMMENT 'when appointegerment was scheduled to be'
);

CREATE TABLE `okAppointment` (
  `apOK_id` integer PRIMARY KEY,
  `ap_id` integer,
  `i_id` integer
);

ALTER TABLE `newAssociate` ADD FOREIGN KEY (`identity_id`) REFERENCES `web2identity` (`identity_id`);

ALTER TABLE `newAssociate` ADD FOREIGN KEY (`newA_id`) REFERENCES `associate` (`newA_id`);

ALTER TABLE `employee` ADD FOREIGN KEY (`j_id`) REFERENCES `job` (`j_id`);

ALTER TABLE `employee` ADD FOREIGN KEY (`a_id`) REFERENCES `associate` (`a_id`);

ALTER TABLE `employee` ADD FOREIGN KEY (`e_id`) REFERENCES `employee` (`supervisor_e_id`);

ALTER TABLE `employee` ADD FOREIGN KEY (`i_id`) REFERENCES `id` (`i_id`);

ALTER TABLE `productConstraints` ADD FOREIGN KEY (`p_id`) REFERENCES `product` (`p_id`);

ALTER TABLE `productConstraints` ADD FOREIGN KEY (`dep_id`) REFERENCES `department` (`dep_id`);

ALTER TABLE `permission` ADD FOREIGN KEY (`perm_id`) REFERENCES `productConstraints` (`perm_id`);

ALTER TABLE `id` ADD FOREIGN KEY (`apOK_id`) REFERENCES `okAppointment` (`apOK_id`);

ALTER TABLE `vehicleID` ADD FOREIGN KEY (`i_id`) REFERENCES `id` (`i_id`);

ALTER TABLE `appointment` ADD FOREIGN KEY (`customer_newA_id`) REFERENCES `newAssociate` (`newA_id`);

ALTER TABLE `appointment` ADD FOREIGN KEY (`repEmployee_e_id`) REFERENCES `employee` (`e_id`);

ALTER TABLE `appointment` ADD FOREIGN KEY (`p_id`) REFERENCES `product` (`p_id`);

ALTER TABLE `okAppointment` ADD FOREIGN KEY (`ap_id`) REFERENCES `appointment` (`ap_id`);

