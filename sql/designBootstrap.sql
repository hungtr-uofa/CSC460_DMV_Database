--- This file acts as the way to bootstrap the designed
-- table.
--- Our database is set up so that it is appointment
-- and id-driven; even the hiring process.
--- We can think about appointments as interviews.
--- We also implemented a system such that an associate
-- can have many employee cards, each employee belongs to
-- a single department

---- Some constraints that we have to manually take care of
--- Only an HR with adminRights may PROCESS an employee card with adminRights

--- First, we will insert roots for each department to bootstrap
-- the hiring process.

--- First order of business is the concept of a root into permission
--- 0 is now the absolute permission
INSERT INTO "mvd_permission"
VALUES(0, 1, 1, 1, 0); -- not founder, but is admin

--- Adding the records
--- Department
INSERT INTO "mvd_department" VALUES
(0, "License"),
(1, "Permit"),
(2, "Vehicle Registration"),
(3, "State ID"),
(4, "Human Resource");

--- The ultimate hiring person: the root
-- with the root, we can employ others at will.

-- make a root associate
INSERT INTO "mvd_web2identity" VALUES
(0, "root", "0");

INSERT INTO "mvd_newAssociate" VALUES
(0, "root", "root", 0);

INSERT INTO "mvd_associate" VALUES
(0, 0, null, null);

-- To get root to be an employee, we need an id
-- the only way to get an id is via okappointment
-- we need to first set up appointment for it to be ok, though
-- at the bootstrap step, we are not enforcing anything about
-- the hiring permissions, so we could theoretically appoint ourselves?