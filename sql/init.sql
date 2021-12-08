CREATE DATABASE mvd;
---
--- ID types
---

CREATE TABLE id (
    i_id: int,
    a_id: int, -- associate id of the owner
    
    PRIMARY KEY (i_id),
    FOREIGN KEY (a_id) REFERENCES associate(a_id)

);

---
--- Departments & products
---

--- Records of the departments in MVD
CREATE TABLE department(
    dep_id: int,
    dep_name: varchar2(10) NOT NULL,
    PRIMARY KEY(dep_id),
    FOREIGN KEY (dep_id) REFERENCES departmentOnProduct(dep_id)
);

--- Specifies how each department is afiliated with a product
-- If there is entry with some department for a given product,
-- the department has no afiliation with the product.
--
-- Each entry has a permission id acting as the bitmask of
-- department permission. For example, the job has a permission
-- both represent and process on department A
-- The product imposes the a permission of represent but no process
-- on department A, then the person with that job may not process
-- the product (unless the permission has administrative role.)
CREATE TABLE departmentOnProduct(
    p_id: int,
    dep_id: int,
    perm_id: int,
    PRIMARY KEY (p_id, dep_id),
    FOREIGN KEY (dep_id) REFERENCES department(dep_id),
    FOREIGN KEY (p_id) REFERENCES product(p_id),
    FOREIGN KEY (perm_id) REFERENCES permission(perm_id)
);

--- All of the products available at MVD
CREATE TABLE product(
    p_id: int,
    productName: varchar2(10),
    productPrice: int,
    productExpiry: 
);

---
--- The whole network tables
---

--- Data of those who are affiliated with MVD
CREATE TABLE associate (
    a_id: int,
    newA_id: int,
    dateOfBirth: date,
    address: varchar2(20),
    PRIMARY KEY (a_id),
    FOREIGN KEY (newA_id) REFERENCES newAssociate(newA_id)
);

--- Data of those who make inquiries to MVD
CREATE TABLE newAssociate(
    newA_id: int,
    firstName: varchar2(10) NOT NULL,
    lastName: varchar2(10) NOT NULL,
    identity_id: int,
    PRIMARY KEY newA_id,
    FOREIGN KEY (identity_id) REFERENCES web2Identity(identity_id)
);

--- e-Identity for fast, efficient, pseudo-anonymous communication
--- This is for privacy for those who are not yet affiliated to MVD
CREATE TABLE web2Identity (
    identity_id: int,
    email: varchar2(32) NOT NULL,
    phoneNumber: varchar2(16) NOT NULL,
    PRIMARY KEY (identity_id)
);

---
--- Employee tables
---

--- Employee data
CREATE TABLE employee (
    e_id: int,
    j_id: int,
    a_id: int,
    supervisor_e_id: int,
    isFounder: number(1) NOT NULL DEFAULT 0, -- 1 if founder, 0 otherwise
    PRIMARY KEY (e_id),
    FOREIGN KEY (supervisor_e_id) REFERENCES employee(e_id),
    FOREIGN KEY (a_id) REFERENCES associate(a_id),
    FOREIGN KEY (j_id) REFERENCES job(j_id)
);

---
--- Employment data tables
---

--- Job data
CREATE TABLE job (
    j_id: int,
    job_name: varchar2(10) NOT NULL,
    salary: int NOT NULL,
    perm_id: int,
    primary key (j_id),
    foreign key (perm_id) REFERENCES permission(perm_id)
);

--- Permission data
CREATE TABLE permission (
    perm_id: int,
    canRepresent: number(1) NOT NULL DEFAULT 0,
    canProcess: number(1) NOT NULL DEFAULT 0,
    -- Specifies that any job with this permission
    -- will have absolute authority over the products
    companyAdministrator: number(1) NOT NULL DEFAULT 0,
    primary key (perm_id)
);
