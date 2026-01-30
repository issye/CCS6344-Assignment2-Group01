-- 1. Create the Database
CREATE DATABASE vet_clinic;
GO

USE vet_clinic;
GO

-- 2. Create Users Table (For Logins)
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Stores the bcrypt hash later
    role VARCHAR(20) CHECK (role IN ('vet', 'receptionist')) DEFAULT 'receptionist',
    created_at DATETIME DEFAULT GETDATE()
);

-- 3. Create Pets Table 
CREATE TABLE pets (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pet_name VARCHAR(100) NOT NULL,
    owner_name VARCHAR(100) NOT NULL,  
    owner_contact VARCHAR(100),         
    diagnosis TEXT,
    treatment_fee DECIMAL(10, 2),
    age INT,
    created_at DATETIME DEFAULT GETDATE()
);

-- 4. Create Audit Log (Security Requirement)
CREATE TABLE audit_log (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    action_type VARCHAR(50), 
    details TEXT,
    action_time DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. Insert Default Admin (Safe Placeholder Method)
-- Note: The password is NOT a real hash yet. This is just a placeholder.
INSERT INTO users (username, password, role) 
VALUES ('dr_admin', 'HASHED_IN_APPLICATION_LAYER', 'vet');
GO

-- 1. Create Login (Server Level)
-- Checks if login exists first to avoid errors
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'vet_app_user')
BEGIN
    CREATE LOGIN vet_app_user WITH PASSWORD = 'VetSecurePass2026!';
END
GO

-- 2. Create User (Database Level)
CREATE USER vet_app_user FOR LOGIN vet_app_user;
GO

-- 3. Grant Permissions (Least Privilege)
-- We allow them to read/write data, but NOT delete the database itself.
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO vet_app_user;
GO

