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
  "isFounder" number(1) DEFAULT 0,
  "adminRights" number(1) DEFAULT 0,
  "i_id" integer
);

CREATE TABLE "mvd_job" (
  "j_id" integer PRIMARY KEY,
  "jobName" varchar2(32) NOT NULL,
  "salary" integer NOT NULL,
  "perm_id" integer
);

CREATE TABLE "mvd_permission" (
  "perm_id" integer PRIMARY KEY,
  "canRepresent" number(1) DEFAULT 0,
  "canProcess" number(1) DEFAULT 0
);

CREATE TABLE "mvd_product" (
  "p_id" integer PRIMARY KEY,
  "productName" varchar2(40),
  "productPrice" integer,
  "productExpiry_days" integer
);

CREATE TABLE "mvd_productConstraints" (
  "p_id" integer,
  "dep_id" integer,
  "perm_id" integer,
  "maxPerPerson" integer,
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
  "appointmentDate" date
);

CREATE TABLE "mvd_okappointment" (
  "apOK_id" integer PRIMARY KEY,
  "ap_id" integer,
  "i_id" integer
);

ALTER TABLE "mvd_newAssociate" ADD FOREIGN KEY ("identity_id") REFERENCES "mvd_web2identity" ("identity_id");

ALTER TABLE "mvd_newAssociate" ADD FOREIGN KEY ("newA_id") REFERENCES "mvd_associate" ("newA_id");

ALTER TABLE "mvd_employee" ADD FOREIGN KEY ("j_id") REFERENCES "mvd_job" ("j_id");

ALTER TABLE "mvd_employee" ADD FOREIGN KEY ("a_id") REFERENCES "mvd_associate" ("a_id");

ALTER TABLE "mvd_employee" ADD FOREIGN KEY ("e_id") REFERENCES "mvd_employee" ("supervisor_e_id");

ALTER TABLE "mvd_employee" ADD FOREIGN KEY ("i_id") REFERENCES "mvd_id" ("i_id");

ALTER TABLE "mvd_productConstraints" ADD FOREIGN KEY ("p_id") REFERENCES "mvd_product" ("p_id");

ALTER TABLE "mvd_productConstraints" ADD FOREIGN KEY ("dep_id") REFERENCES "mvd_department" ("dep_id");

ALTER TABLE "mvd_permission" ADD FOREIGN KEY ("perm_id") REFERENCES "mvd_productConstraints" ("perm_id");

ALTER TABLE "mvd_id" ADD FOREIGN KEY ("apOK_id") REFERENCES "mvd_okappointment" ("apOK_id");

ALTER TABLE "mvd_vehicleID" ADD FOREIGN KEY ("i_id") REFERENCES "mvd_id" ("i_id");

ALTER TABLE "mvd_appointment" ADD FOREIGN KEY ("customer_newA_id") REFERENCES "mvd_newAssociate" ("newA_id");

ALTER TABLE "mvd_appointment" ADD FOREIGN KEY ("repEmployee_e_id") REFERENCES "mvd_employee" ("e_id");

ALTER TABLE "mvd_appointment" ADD FOREIGN KEY ("p_id") REFERENCES "mvd_product" ("p_id");

ALTER TABLE "mvd_okappointment" ADD FOREIGN KEY ("ap_id") REFERENCES "mvd_appointment" ("ap_id");


COMMENT ON COLUMN "mvd_associate"."address" IS 'might want to create an index for addresses in the future';

COMMENT ON COLUMN "mvd_employee"."adminRights" IS 'bypasses everything, even the product constraints';

COMMENT ON COLUMN "mvd_productConstraints"."maxPerPerson" IS 'if null, infinity. This is useful for license, permit, id limited to 1 person';

COMMENT ON COLUMN "mvd_id"."revoked" IS 'if null, not revoked yet';

COMMENT ON COLUMN "mvd_vehicleID"."i_id" IS 'vehicleID extends id';

COMMENT ON COLUMN "mvd_appointment"."customer_newA_id" IS 'newA_id of potential customer who scheduled appt';

COMMENT ON COLUMN "mvd_appointment"."repEmployee_e_id" IS 'e_id of the representative';

COMMENT ON COLUMN "mvd_appointment"."appointmentDate" IS 'when mvd_appointment was scheduled to be';
