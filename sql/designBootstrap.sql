--- This file acts as the way to bootstrap the designed
-- table.
--- Our database is set up so that it is appointment
-- and id-driven; even the hiring process.
--- We can think about appointments as interviews.
--- We also implemented a system such that an associate
-- can have many employee cards, each employee belongs to
-- a single department

--- Inject time/date defaults (impossible in dbml)
-- Default for appointment date is time now
ALTER TABLE "mvd_appointment" MODIFY "appointmentDate" 
DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP);

ALTER TABLE "mvd_okappointment" MODIFY "processedDate"
DEFAULT NULL;

---- CONSTRAINTS ----
--- Only an HR with adminRights may PROCESS an employee
-- card with adminRights
--- Ensure maxPerPerson in mvd_product is respected
--- Appointment for a single person (customer or employee)
-- may not overlap in time
---------------------


--- First, we will insert roots for each department to bootstrap
-- the hiring process.

--- First order of business is the concept of a root into permission
--- 0 is now the absolute permission
INSERT ALL
INTO "mvd_permission" VALUES
(0, 1, 1, 1, 0) -- not founder, but is admin, this is for root and other admins
INTO "mvd_permission" VALUES
(1, 1, 1, 1, 1) -- founder perm
INTO "mvd_permission" VALUES
(2, 1, 1, 0, 0) -- flexible worker
SELECT * FROM dual;

--- Adding the records
--- Department
INSERT ALL
INTO "mvd_department" VALUES (0, 'License')
INTO "mvd_department" VALUES (1, 'Permit')
INTO "mvd_department" VALUES (2, 'Vehicle Registration')
INTO "mvd_department" VALUES (3, 'State ID')
INTO "mvd_department" VALUES (4, 'Human Resource')
SELECT * FROM dual;

--- The ultimate hiring person: the root
-- with the root, we can employ others at will.

-- make a root associate
INSERT INTO "mvd_web2identity" VALUES
(0, 'root', '0');

INSERT INTO "mvd_newAssociate" VALUES
(0, 'root', 'root', 0);

INSERT INTO "mvd_associate" VALUES
(0, 0, null, null);

-- To get root to be an employee, we need an id
-- the only way to get an id is via okappointment
-- we need to first set up appointment for it to be ok, though
-- at the bootstrap step, we are not enforcing anything about
-- the hiring permissions, so we could theoretically appoint ourselves?

INSERT ALL
-- products
INTO "mvd_product" VALUES (0, 'Admin Hiring', 0, 100000, null)    -- bootstrap
INTO "mvd_product" VALUES (1, 'License Registration', 25, 4383, 1)    -- $25, 12yr exp
INTO "mvd_product" VALUES (2, 'Permit Registration', 7, 365, null)    -- $7, 1yr
INTO "mvd_product" VALUES (3, 'Vehicle Registration', 100, 365, null) -- $100, 1yr
INTO "mvd_product" VALUES (4, 'State ID Registration', 12, 7305, 1)   -- $12, 20yr
SELECT * FROM dual;

INSERT ALL
-- constraints
INTO "mvd_productConstraints" VALUES (0, 4, 0) -- boot: ID:0, Dept:HR, Perm: admin
-- boot appointment
INTO "mvd_appointment" VALUES(0, 0, 0, 0, TIMESTAMP '1800-01-01 23:59:59.10')
SELECT * FROM dual;

--- okappointment
INSERT INTO "mvd_okappointment" VALUES(0, 0, 0, 0, DATE '1800-01-02');
---

INSERT ALL
INTO "mvd_employee" VALUES (0, 0, 0, null, 0, DEFAULT)
INTO "mvd_id" VALUES (0,0, DEFAULT)
SELECT * FROM dual;


-- job listing
INSERT INTO "mvd_job" VALUES (0, 'root', 0, 0, 4); -- id:0, jobname:root, salary:0, perm_id:0 (admin/root), dep_id: 4(HR)
