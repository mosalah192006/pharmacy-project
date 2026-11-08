-- ============================================================================
-- Examination File: sms_multi_students.sql
-- Description: Soldier Management System (SMS) - Multi-Student Implementation
-- Student Numbers: 202511449, 202512591, 202512126
-- ============================================================================

-- Statement required at the very start of the file
SELECT DATABASE(), CURRENT_USER(), NOW();[cite: 2]


-- ============================================================================
-- PART A: Create the tables (15 marks)
-- ============================================================================

CREATE DATABASE IF NOT EXISTS sms_multi_students;
USE sms_multi_students;

-- Table 1: ranks
-- Does: Stores soldier ranks with strict check on level range (1-6).
CREATE TABLE ranks (
    rank_id INT PRIMARY KEY,
    rank_name VARCHAR(50) NOT NULL UNIQUE,
    rank_level INT NOT NULL CHECK (rank_level BETWEEN 1 AND 6)
);[cite: 2, 3]

-- Table 2: units
-- Does: Stores military units and their physical locations.
CREATE TABLE units (
    unit_id INT PRIMARY KEY,
    unit_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL
);[cite: 3]

-- Table 3: missions
-- Does: Stores mission details ensuring end date is not earlier than start date.
CREATE TABLE missions (
    mission_id INT PRIMARY KEY,
    mission_name VARCHAR(100) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    CONSTRAINT chk_mission_dates CHECK (end_date IS NULL OR end_date >= start_date)
);[cite: 3]

-- Table 4: soldiers
-- Does: Stores soldier personal info, auto-increment PK, status constraint, and date logic.
CREATE TABLE soldiers (
    soldier_id INT AUTO_INCREMENT PRIMARY KEY,
    service_number VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    enlistment_date DATE NOT NULL,
    status ENUM('Active', 'On Leave', 'Retired') NOT NULL DEFAULT 'Active',
    rank_id INT NOT NULL,
    unit_id INT NOT NULL,
    FOREIGN KEY (rank_id) REFERENCES ranks(rank_id),
    FOREIGN KEY (unit_id) REFERENCES units(unit_id),
    CONSTRAINT chk_enlistment_birth CHECK (enlistment_date > date_of_birth)
);[cite: 3]

-- Table 5: soldier_missions
-- Does: Junction table linking soldiers to missions preventing duplicate assignments.
CREATE TABLE soldier_missions (
    soldier_id INT NOT NULL,
    mission_id INT NOT NULL,
    mission_role VARCHAR(100) NOT NULL,
    PRIMARY KEY (soldier_id, mission_id),
    FOREIGN KEY (soldier_id) REFERENCES soldiers(soldier_id),
    FOREIGN KEY (mission_id) REFERENCES missions(mission_id)
);[cite: 3]


-- ============================================================================
-- PART B: Insert the data (10 marks)
-- ============================================================================

-- B1: Insert predefined Ranks, Units, and Missions
-- Does: Populates static lookup data for ranks, units, and missions.
INSERT INTO ranks (rank_id, rank_name, rank_level) VALUES
(1, 'Private', 1),
(2, 'Corporal', 2),
(3, 'Sergeant', 3),
(4, 'Lieutenant', 4),
(5, 'Captain', 5),
(6, 'Major', 6);[cite: 3]

INSERT INTO units (unit_id, unit_name, location) VALUES
(1, 'Alpha Company', 'North Camp'),
(2, 'Bravo Company', 'South Camp'),
(3, 'Charlie Company', 'East Camp'),
(4, 'Delta Company', 'West Camp'),
(5, 'Signals Unit', 'Central Camp'),
(6, 'Medical Unit', 'Central Camp');[cite: 3, 4]

INSERT INTO missions (mission_id, mission_name, start_date, end_date) VALUES
(1, 'Exercise Falcon', '2025-02-03', '2025-02-28'),
(2, 'Flood Relief', '2025-04-14', '2025-05-30'),
(3, 'Border Patrol', '2025-07-01', NULL),
(4, 'Peace Support', '2025-09-15', NULL),
(5, 'Field Medical Camp', '2026-01-12', '2026-01-23');[cite: 4]

-- B3: Insert custom soldiers for the three student numbers
INSERT INTO soldiers (soldier_id, service_number, first_name, last_name, date_of_birth, enlistment_date, status, rank_id, unit_id) VALUES
(31, 'ST-202511449', 'Mohamed', 'Salah', '2001-05-15', '2021-09-01', 'Active', 1, 2),
(32, 'ST-202512591', 'Student', 'Two', '1999-07-12', '2020-03-15', 'Active', 4, 1),
(33, 'ST-202512126', 'Student', 'Three', '2000-01-20', '2022-06-10', 'Active', 2, 3);[cite: 4]

-- Assigning the students' soldiers to missions
INSERT INTO soldier_missions (soldier_id, mission_id, mission_role) VALUES
(31, 5, 'Communications Specialist'),
(32, 5, 'Team Leader'),
(33, 2, 'Medical Assistant');[cite: 4]


-- ============================================================================
-- PART C: Retrieve the data (25 marks)
-- ============================================================================

-- C1
-- Does: Retrieves the 10 most recently added soldiers ordered by ID descending.
-- Rows returned: 10
SELECT * FROM soldiers 
ORDER BY soldier_id DESC 
LIMIT 10;[cite: 4, 5]

-- C2
-- Does: Selects the last 10 added soldiers and displays them in ascending order of ID.
-- Rows returned: 10
SELECT * FROM (
    SELECT * FROM soldiers 
    ORDER BY soldier_id DESC 
    LIMIT 10
) AS recent_soldiers 
ORDER BY soldier_id ASC;[cite: 4, 5]

-- C3
-- Does: Retrieves soldiers whose specific ID is 10, 15, or 20 using IN operator.
-- Rows returned: 3
SELECT * FROM soldiers 
WHERE soldier_id IN (10, 15, 20);[cite: 5]

-- C4
-- Does: Retrieves soldiers whose ID matches based on student numbers using IN.
-- Rows returned: 3
SELECT * FROM soldiers 
WHERE soldier_id IN (19, 24, 29);[cite: 5]

-- C5
-- Does: Selects active soldiers having soldier_id between 10 and 20.
-- Rows returned: Variable based on table data.
SELECT * FROM soldiers 
WHERE status = 'Active' 
  AND soldier_id BETWEEN 10 AND 20;[cite: 5]

-- C6
-- Does: Displays soldier ID, full name, and rank name, sorted by highest rank level first then last name.
-- Rows returned: Total soldiers count.
SELECT s.soldier_id, 
       CONCAT(s.first_name, ' ', s.last_name) AS soldier_name, 
       r.rank_name 
FROM soldiers s
JOIN ranks r ON s.rank_id = r.rank_id
ORDER BY r.rank_level DESC, s.last_name ASC;[cite: 5]

-- C7
-- Does: Shows active soldiers for specific units related to the student numbers.
-- Rows returned: Variable.
SELECT s.first_name, s.last_name, r.rank_name, u.unit_name, u.location
FROM soldiers s
JOIN ranks r ON s.rank_id = r.rank_id
JOIN units u ON s.unit_id = u.unit_id
WHERE s.status = 'Active' 
  AND s.unit_id IN (1, 2, 3);[cite: 5]

-- C8
-- Does: Lists personnel assigned to missions with role and unit details.
-- Rows returned: 3
SELECT m.mission_name, 
       CONCAT(s.first_name, ' ', s.last_name) AS soldier_name, 
       sm.mission_role, 
       u.unit_name
FROM soldier_missions sm
JOIN soldiers s ON sm.soldier_id = s.soldier_id
JOIN missions m ON sm.mission_id = m.mission_id
JOIN units u ON s.unit_id = u.unit_id;[cite: 5]

-- C9
-- Does: Finds soldiers who have never been assigned to any mission using LEFT JOIN.
-- Rows returned: Variable.
SELECT s.soldier_id, s.first_name, s.last_name
FROM soldiers s
LEFT JOIN soldier_missions sm ON s.soldier_id = sm.soldier_id
WHERE sm.mission_id IS NULL;[cite: 5]

-- C10
-- Does: Aggregates total soldiers per unit ordered from largest to smallest unit size.
-- Rows returned: 6
SELECT u.unit_name, COUNT(s.soldier_id) AS total_soldiers
FROM units u
LEFT JOIN soldiers s ON u.unit_id = s.unit_id
GROUP BY u.unit_id, u.unit_name
ORDER BY total_soldiers DESC;[cite: 5]


-- ============================================================================
-- PART D: Create an index and a view (10 marks)
-- ============================================================================

-- D1: Explain analysis and Index creation
-- Does: Analyzes query execution path before adding index.
-- Rows returned: 1
EXPLAIN SELECT * FROM soldiers WHERE last_name = 'Salah';[cite: 6]

-- Creating the non-clustered index on last_name
CREATE INDEX idx_soldiers_last_name ON soldiers(last_name);[cite: 6]

-- Does: Re-analyzes execution path after index creation.
-- Rows returned: 1
EXPLAIN SELECT * FROM soldiers WHERE last_name = 'Salah';[cite: 6]

-- D2: Create profile view
-- Does: Creates a reusable view combining soldier details and full names.
CREATE VIEW v_soldier_profile AS
SELECT s.soldier_id,
       CONCAT(s.first_name, ' ', s.last_name) AS full_name,
       r.rank_name,
       u.unit_name,
       u.location,
       s.status
FROM soldiers s
JOIN ranks r ON s.rank_id = r.rank_id
JOIN units u ON s.unit_id = u.unit_id;[cite: 6]

-- D3: Retrieve from view for the student units, ordered by full name.
-- Rows returned: Variable.
SELECT * FROM v_soldier_profile
WHERE unit_name IN ('Alpha Company', 'Bravo Company', 'Charlie Company')
ORDER BY full_name ASC;[cite: 6]