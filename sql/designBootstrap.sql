--- This file acts as the way to bootstrap the designed
-- table.
--- Our database is set up so that it is appointment
-- and id-driven; even the hiring process.
--- We can think about appointments as interviews.
--- We also implemented a system such that an associate
-- can have many employee cards, each employee belongs to
-- a single department

--- First, we will insert roots for each department to bootstrap
-- the hiring process.

--- First order of business is the concept of a root into permission
INSERT INTO "mvd_permission"
VALUES(0, 1, 1);
