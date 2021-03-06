ALTER TABLE "mvd_newAssociate" ADD FOREIGN KEY ("identity_id") REFERENCES "mvd_web2identity" ("identity_id");

ALTER TABLE "mvd_associate" ADD FOREIGN KEY ("newA_id") REFERENCES "mvd_newAssociate" ("newA_id");

ALTER TABLE "mvd_employee" ADD FOREIGN KEY ("j_id") REFERENCES "mvd_job" ("j_id");

ALTER TABLE "mvd_employee" ADD FOREIGN KEY ("a_id") REFERENCES "mvd_associate" ("a_id");

ALTER TABLE "mvd_employee" ADD FOREIGN KEY ("supervisor_e_id") REFERENCES "mvd_employee" ("e_id");

ALTER TABLE "mvd_employee" ADD FOREIGN KEY ("i_id") REFERENCES "mvd_id" ("i_id");

ALTER TABLE "mvd_job" ADD FOREIGN KEY ("perm_id") REFERENCES "mvd_permission" ("perm_id");

ALTER TABLE "mvd_job" ADD FOREIGN KEY ("dep_id") REFERENCES "mvd_department" ("dep_id");

ALTER TABLE "mvd_productConstraints" ADD FOREIGN KEY ("p_id") REFERENCES "mvd_product" ("p_id");

ALTER TABLE "mvd_productConstraints" ADD FOREIGN KEY ("dep_id") REFERENCES "mvd_department" ("dep_id");

ALTER TABLE "mvd_productConstraints" ADD FOREIGN KEY ("perm_id") REFERENCES "mvd_permission" ("perm_id");

ALTER TABLE "mvd_id" ADD FOREIGN KEY ("apOK_id") REFERENCES "mvd_okappointment" ("apOK_id");

ALTER TABLE "mvd_vehicleID" ADD FOREIGN KEY ("i_id") REFERENCES "mvd_id" ("i_id");

ALTER TABLE "mvd_appointment" ADD FOREIGN KEY ("customer_newA_id") REFERENCES "mvd_newAssociate" ("newA_id");

ALTER TABLE "mvd_appointment" ADD FOREIGN KEY ("repEmployee_e_id") REFERENCES "mvd_employee" ("e_id");

ALTER TABLE "mvd_appointment" ADD FOREIGN KEY ("p_id") REFERENCES "mvd_product" ("p_id");

ALTER TABLE "mvd_okappointment" ADD FOREIGN KEY ("ap_id") REFERENCES "mvd_appointment" ("ap_id");

ALTER TABLE "mvd_okappointment" ADD FOREIGN KEY ("processEmp_e_id") REFERENCES "mvd_employee" ("e_id");


COMMENT ON COLUMN "mvd_associate"."address" IS 'might want to create an index for addresses in the future';

COMMENT ON COLUMN "mvd_employee"."supervisor_e_id" IS 'if fk nullable, use null for no supervisor; otherwise, use self.';

COMMENT ON COLUMN "mvd_permission"."adminRights" IS 'bypasses everything, even the product constraints';

COMMENT ON COLUMN "mvd_product"."maxPerPerson" IS 'if null, infinity. This is useful for license, permit, id limited to 1 person';

COMMENT ON COLUMN "mvd_productConstraints"."perm_id" IS 'the canRepresent and canProcess is bitmask and; adminRights or isFounder requires processor to be adminRights and isFounder.';

COMMENT ON COLUMN "mvd_id"."revoked" IS 'if null, not revoked yet';

COMMENT ON COLUMN "mvd_vehicleID"."i_id" IS 'vehicleID extends id';

COMMENT ON COLUMN "mvd_appointment"."customer_newA_id" IS 'newA_id of potential customer who scheduled appt';

COMMENT ON COLUMN "mvd_appointment"."repEmployee_e_id" IS 'e_id of the representative';

COMMENT ON COLUMN "mvd_appointment"."appointmentDate" IS 'when mvd_appointment was scheduled to be, default: timenow';

COMMENT ON COLUMN "mvd_okappointment"."processEmp_e_id" IS 'e_id of a processor';

COMMENT ON COLUMN "mvd_okappointment"."processedDate" IS 'when the appointment is processed, default is the same as appointmentDate';

