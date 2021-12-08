CREATE TABLE "web2identity" (
  "identity_id" integer PRIMARY KEY,
  "emailAddress" varchar(40) NOT NULL,
  "phoneNumber" varchar(15) NOT NULL
);

CREATE TABLE "newAssociate" (
  "newA_id" integer PRIMARY KEY,
  "firstName" varchar(20) NOT NULL,
  "lastName" varchar(20) NOT NULL,
  "identity_id" integer
);

CREATE TABLE "associate" (
  "a_id" integer PRIMARY KEY,
  "newA_id" integer,
  "dateOfBirth" datetime,
  "address" varchar(80)
);

CREATE TABLE "department" (
  "dep_id" integer PRIMARY KEY,
  "depName" varchar(80) NOT NULL
);

CREATE TABLE "employee" (
  "e_id" integer PRIMARY KEY,
  "j_id" integer,
  "a_id" integer,
  "supervisor_e_id" integer,
  "isFounder" integer(1) DEFAULT 0,
  "adminRights" integer(1) DEFAULT 0,
  "i_id" integer
);

CREATE TABLE "job" (
  "j_id" integer PRIMARY KEY,
  "jobName" str NOT NULL,
  "salary" integer NOT NULL,
  "perm_id" integer
);

CREATE TABLE "permission" (
  "perm_id" integer PRIMARY KEY,
  "canRepresent" integer(1) NOT NULL DEFAULT false,
  "canProcess" integer(1) NOT NULL DEFAULT false
);

CREATE TABLE "product" (
  "p_id" integer PRIMARY KEY,
  "productName" varchar(40),
  "productPrice" integer,
  "productExpiry_days" integer
);

CREATE TABLE "productConstraints" (
  "p_id" integer,
  "dep_id" integer,
  "perm_id" integer,
  "maxPerPerson" integer,
  PRIMARY KEY ("p_id", "dep_id")
);

CREATE TABLE "id" (
  "i_id" integer PRIMARY KEY,
  "apOK_id" integer,
  "revoked" datetime DEFAULT NULL
);

CREATE TABLE "vehicleID" (
  "v_id" integer PRIMARY KEY,
  "i_id" integer
);

CREATE TABLE "appointment" (
  "ap_id" integer PRIMARY KEY,
  "customer_newA_id" integer,
  "repEmployee_e_id" integer,
  "p_id" integer,
  "appointmentDate" datetime
);

CREATE TABLE "okAppointment" (
  "apOK_id" integer PRIMARY KEY,
  "ap_id" integer,
  "i_id" integer
);

ALTER TABLE "newAssociate" ADD FOREIGN KEY ("identity_id") REFERENCES "web2identity" ("identity_id");

ALTER TABLE "newAssociate" ADD FOREIGN KEY ("newA_id") REFERENCES "associate" ("newA_id");

ALTER TABLE "employee" ADD FOREIGN KEY ("j_id") REFERENCES "job" ("j_id");

ALTER TABLE "employee" ADD FOREIGN KEY ("a_id") REFERENCES "associate" ("a_id");

ALTER TABLE "employee" ADD FOREIGN KEY ("e_id") REFERENCES "employee" ("supervisor_e_id");

ALTER TABLE "employee" ADD FOREIGN KEY ("i_id") REFERENCES "id" ("i_id");

ALTER TABLE "productConstraints" ADD FOREIGN KEY ("p_id") REFERENCES "product" ("p_id");

ALTER TABLE "productConstraints" ADD FOREIGN KEY ("dep_id") REFERENCES "department" ("dep_id");

ALTER TABLE "permission" ADD FOREIGN KEY ("perm_id") REFERENCES "productConstraints" ("perm_id");

ALTER TABLE "id" ADD FOREIGN KEY ("apOK_id") REFERENCES "okAppointment" ("apOK_id");

ALTER TABLE "vehicleID" ADD FOREIGN KEY ("i_id") REFERENCES "id" ("i_id");

ALTER TABLE "appointment" ADD FOREIGN KEY ("customer_newA_id") REFERENCES "newAssociate" ("newA_id");

ALTER TABLE "appointment" ADD FOREIGN KEY ("repEmployee_e_id") REFERENCES "employee" ("e_id");

ALTER TABLE "appointment" ADD FOREIGN KEY ("p_id") REFERENCES "product" ("p_id");

ALTER TABLE "okAppointment" ADD FOREIGN KEY ("ap_id") REFERENCES "appointment" ("ap_id");


COMMENT ON COLUMN "associate"."address" IS 'might want to create an index for addresses in the future';

COMMENT ON COLUMN "employee"."adminRights" IS 'bypasses everything, even the product constraints';

COMMENT ON COLUMN "productConstraints"."maxPerPerson" IS 'if null, infinity. This is useful for license, permit, id limited to 1 person';

COMMENT ON COLUMN "id"."revoked" IS 'if null, not revoked yet';

COMMENT ON COLUMN "vehicleID"."i_id" IS 'vehicleID extends id';

COMMENT ON COLUMN "appointment"."customer_newA_id" IS 'newA_id of potential customer who scheduled appt';

COMMENT ON COLUMN "appointment"."repEmployee_e_id" IS 'e_id of the representative';

COMMENT ON COLUMN "appointment"."appointmentDate" IS 'when appointment was scheduled to be';
