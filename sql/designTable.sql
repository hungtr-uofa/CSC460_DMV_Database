CREATE TABLE "mvd_web2identity" (
  "identity_id" integer PRIMARY KEY,
  "emailAddress" varchar2(40) NOT NULL,
  "phoneNumber" varchar2(15) NOT NULL
);

CREATE TABLE "mvd_newAssociate" (
  "newA_id" integer PRIMARY KEY,
  "firstName" varchar2(20) NOT NULL,
  "lastName" varchar2(20) NOT NULL,
  "identity_id" integer
);

CREATE TABLE "mvd_associate" (
  "a_id" integer PRIMARY KEY,
  "newA_id" integer,
  "dateOfBirth" date,
  "address" varchar2(80)
);

CREATE TABLE "mvd_department" (
  "dep_id" integer PRIMARY KEY,
  "depName" varchar2(80) NOT NULL
);

CREATE TABLE "mvd_employee" (
  "e_id" integer PRIMARY KEY,
  "j_id" integer,
  "a_id" integer,
  "supervisor_e_id" integer,
  "i_id" integer,
  "salaryIncrease" integer DEFAULT 0
);

CREATE TABLE "mvd_job" (
  "j_id" integer PRIMARY KEY,
  "jobName" varchar2(32) NOT NULL,
  "salary" integer NOT NULL,
  "perm_id" integer,
  "dep_id" integer
);

CREATE TABLE "mvd_permission" (
  "perm_id" integer PRIMARY KEY,
  "canRepresent" number(1) DEFAULT 0,
  "canProcess" number(1) DEFAULT 0,
  "adminRights" number(1) DEFAULT 0,
  "isFounder" number(1) DEFAULT 0
);

CREATE TABLE "mvd_product" (
  "p_id" integer PRIMARY KEY,
  "productName" varchar2(40),
  "productPrice" integer,
  "productExpiry_days" integer,
  "maxPerPerson" integer
);

CREATE TABLE "mvd_productConstraints" (
  "p_id" integer,
  "dep_id" integer,
  "perm_id" integer,
  PRIMARY KEY ("p_id", "dep_id")
);

CREATE TABLE "mvd_id" (
  "i_id" integer PRIMARY KEY,
  "apOK_id" integer,
  "revoked" date DEFAULT NULL
);

CREATE TABLE "mvd_vehicleID" (
  "v_id" integer PRIMARY KEY,
  "i_id" integer
);

CREATE TABLE "mvd_appointment" (
  "ap_id" integer PRIMARY KEY,
  "customer_newA_id" integer,
  "repEmployee_e_id" integer,
  "p_id" integer,
  "appointmentDate" timestamp
);

CREATE TABLE "mvd_okappointment" (
  "apOK_id" integer PRIMARY KEY,
  "ap_id" integer,
  "processEmp_e_id" integer,
  "i_id" integer,
  "processedDate" date
);

