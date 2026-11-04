USE ulk_database_application;

DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;

CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    country VARCHAR(50)
);

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author_id INT,
    published_year INT,
    copies INT CHECK (copies >= 0),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

INSERT INTO authors (author_id, author_name, country) 
VALUES 
(1, 'Al-Aqqad', 'Egypt'),
(2, 'Naguib Mahfouz', 'Egypt');

INSERT INTO books (book_id, title, author_id, published_year, copies) 
VALUES 
(1, 'Abqariyat Umar', 1, 1942, 5),
(2, 'The Trilogy', 2, 2018, 3),
(3, 'Awlad Haratina', 2, 2020, 8);