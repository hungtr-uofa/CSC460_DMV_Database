--- sandbox sql for testing

--- default dispatching from another table's value
create table sandbox_appt(
    a_id integer,
    ts timestamp
);

create table sandbox_ok(
    ok_id integer,
    a_id integer,
    approved timestamp DEFAULT SELECT ts FROM sandbox_appt as a WHERE sandbox_ok.a_id=a.a_id
);

INSERT ALL
INTO sandbox_appt VALUES (0, timestamp '2001-01-01 13:00:00.00')
INTO sandbox_appt VALUES (1, timestamp '2001-02-02 14:00:00.00')
SELECT * FROM dual;

INSERT INTO sandbox_ok VALUES (0, 1, DEFAULT);
SELECT * FROM sandbox_ok;

DROP TABLE sandbox_appt;
DROP TABLE sandbox_ok;