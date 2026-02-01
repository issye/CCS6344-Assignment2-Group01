CREATE DATABASE studentdb;

USE studentdb;

CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    course VARCHAR(100)
);

INSERT INTO students (name, course) VALUES
('Ali', 'Cybersecurity'),
('Aisyah', 'Computer Science'),
('Daniel', 'Data Science');
