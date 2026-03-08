/* * PROJECT: HIPAA SQL Masking Engine
 * GOAL: Protect patient privacy while keeping data useful for analysis.
 * * I built this to solve a common Healthcare IT problem: How do we let 
 * researchers see data trends without exposing actual patient identities?
 */

-- 1. Setting up the fake hospital data (PHI)
-- I'm using standard identifiers like Name, SSN, and DOB.
CREATE TABLE Patients_Production (
    PatientID INT PRIMARY KEY,
    FullName VARCHAR(100),
    SSN VARCHAR(11),
    DateOfBirth DATE,
    ZIPCode VARCHAR(5),
    Diagnosis VARCHAR(50),
    Last_Visit_Date DATE
);

INSERT INTO Patients_Production VALUES 
(1, 'Johnathan Smith', '999-00-1111', '1985-05-12', '60601', 'Hypertension', '2026-01-15'),
(2, 'Maria Garcia', '888-22-3333', '1992-11-20', '90210', 'Diabetes', '2026-02-10'),
(3, 'Robert Chen', '777-44-5555', '1958-02-15', '07030', 'Asthma', '2025-12-05'),
(4, 'Sarah Miller', '666-11-2222', '1977-08-30', '30303', 'Diabetes', '2026-03-01');


-- 2. Creating the Masked View
-- This is where the actual de-identification happens. 
-- I used HIPAA "Safe Harbor" rules as a guide here.
DROP VIEW IF EXISTS HIPAA_Safe_Research_View;

CREATE VIEW HIPAA_Safe_Research_View AS
SELECT 
    PatientID,
    -- Just showing initials so we know it's a person but can't tell who
    CONCAT(LEFT(FullName, 1), '. ', SUBSTR(FullName, LOCATE(' ', FullName) + 1, 1), '.') AS Masked_Name,
    
    -- Only keeping the last 4 of the SSN for reference
    CONCAT('XXX-XX-', RIGHT(SSN, 4)) AS Masked_SSN,

    -- Swapping DOB for Birth Year (way safer for privacy)
    YEAR(DateOfBirth) AS Birth_Year,
    
    -- Hiding specific locations by truncating the ZIP code
    CONCAT(LEFT(ZIPCode, 3), 'XX') AS Masked_ZIP,
    
    Diagnosis
FROM Patients_Production;

-- 3. Check the results
-- This shows the 'clean' data ready for a researcher.
SELECT * FROM HIPAA_Safe_Research_View;
