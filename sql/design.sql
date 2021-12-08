CREATE TABLE [web2identity] (
  [identity_id] integer PRIMARY KEY,
  [emailAddress] varchar(20) NOT NULL,
  [phoneNumber] nvarchar(255) NOT NULL
)
GO

CREATE TABLE [newAssociate] (
  [newA_id] integer PRIMARY KEY,
  [firstName] nvarchar(255) NOT NULL,
  [lastName] nvarchar(255) NOT NULL,
  [identity_id] integer
)
GO

CREATE TABLE [associate] (
  [a_id] integer PRIMARY KEY,
  [newA_id] integer,
  [dateOfBirth] datetime,
  [address] nvarchar(255)
)
GO

CREATE TABLE [department] (
  [dep_id] integer PRIMARY KEY,
  [depName] nvarchar(255) NOT NULL
)
GO

CREATE TABLE [employee] (
  [e_id] integer PRIMARY KEY,
  [j_id] integer,
  [a_id] integer,
  [supervisor_e_id] integer,
  [isFounder] integer(1) DEFAULT (0),
  [adminRights] integer(1) DEFAULT (0),
  [i_id] integer
)
GO

CREATE TABLE [job] (
  [j_id] integer PRIMARY KEY,
  [jobName] str NOT NULL,
  [salary] integer NOT NULL,
  [perm_id] integer
)
GO

CREATE TABLE [permission] (
  [perm_id] integer PRIMARY KEY,
  [canRepresent] integer(1) NOT NULL DEFAULT (false),
  [canProcess] integer(1) NOT NULL DEFAULT (false)
)
GO

CREATE TABLE [product] (
  [p_id] integer PRIMARY KEY,
  [productName] nvarchar(255),
  [productPrice] integer,
  [productExpiry_days] integer
)
GO

CREATE TABLE [productConstraints] (
  [p_id] integer,
  [dep_id] integer,
  [perm_id] integer,
  [maxPerPerson] integer,
  PRIMARY KEY ([p_id], [dep_id])
)
GO

CREATE TABLE [id] (
  [i_id] integer PRIMARY KEY,
  [apOK_id] integer,
  [revoked] datetime DEFAULT (NULL)
)
GO

CREATE TABLE [vehicleID] (
  [v_id] integer PRIMARY KEY,
  [i_id] integer
)
GO

CREATE TABLE [appointment] (
  [ap_id] integer PRIMARY KEY,
  [customer_newA_id] integer,
  [repEmployee_e_id] integer,
  [p_id] integer,
  [appointmentDate] datetime
)
GO

CREATE TABLE [okAppointment] (
  [apOK_id] integer PRIMARY KEY,
  [ap_id] integer,
  [i_id] integer
)
GO

ALTER TABLE [newAssociate] ADD FOREIGN KEY ([identity_id]) REFERENCES [web2identity] ([identity_id])
GO

ALTER TABLE [newAssociate] ADD FOREIGN KEY ([newA_id]) REFERENCES [associate] ([newA_id])
GO

ALTER TABLE [employee] ADD FOREIGN KEY ([j_id]) REFERENCES [job] ([j_id])
GO

ALTER TABLE [employee] ADD FOREIGN KEY ([a_id]) REFERENCES [associate] ([a_id])
GO

ALTER TABLE [employee] ADD FOREIGN KEY ([e_id]) REFERENCES [employee] ([supervisor_e_id])
GO

ALTER TABLE [employee] ADD FOREIGN KEY ([i_id]) REFERENCES [id] ([i_id])
GO

ALTER TABLE [productConstraints] ADD FOREIGN KEY ([p_id]) REFERENCES [product] ([p_id])
GO

ALTER TABLE [productConstraints] ADD FOREIGN KEY ([dep_id]) REFERENCES [department] ([dep_id])
GO

ALTER TABLE [permission] ADD FOREIGN KEY ([perm_id]) REFERENCES [productConstraints] ([perm_id])
GO

ALTER TABLE [id] ADD FOREIGN KEY ([apOK_id]) REFERENCES [okAppointment] ([apOK_id])
GO

ALTER TABLE [vehicleID] ADD FOREIGN KEY ([i_id]) REFERENCES [id] ([i_id])
GO

ALTER TABLE [appointment] ADD FOREIGN KEY ([customer_newA_id]) REFERENCES [newAssociate] ([newA_id])
GO

ALTER TABLE [appointment] ADD FOREIGN KEY ([repEmployee_e_id]) REFERENCES [employee] ([e_id])
GO

ALTER TABLE [appointment] ADD FOREIGN KEY ([p_id]) REFERENCES [product] ([p_id])
GO

ALTER TABLE [okAppointment] ADD FOREIGN KEY ([ap_id]) REFERENCES [appointment] ([ap_id])
GO


EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'bypasses everything, even the product constraints',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'employee',
@level2type = N'Column', @level2name = 'adminRights';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'if null, infinity. This is useful for license, permit, id limited to 1 person',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'productConstraints',
@level2type = N'Column', @level2name = 'maxPerPerson';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'if null, not revoked yet',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'id',
@level2type = N'Column', @level2name = 'revoked';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'vehicleID extends id',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'vehicleID',
@level2type = N'Column', @level2name = 'i_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'newA_id of potential customer who scheduled appt',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'appointment',
@level2type = N'Column', @level2name = 'customer_newA_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'e_id of the representative',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'appointment',
@level2type = N'Column', @level2name = 'repEmployee_e_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'when appointment was scheduled to be',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'appointment',
@level2type = N'Column', @level2name = 'appointmentDate';
GO
