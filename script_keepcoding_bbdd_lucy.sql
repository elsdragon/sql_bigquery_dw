-- Crear la tabla Personal_data
CREATE TABLE Personal_data (
    personal_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL, 
    nif VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL,
    adress VARCHAR(100) NOT NULL
);
-- Modifico la tabla para que sea un email único
ALTER TABLE Personal_data
ADD CONSTRAINT uni_email UNIQUE (email);

-- Crear la tabla Student
CREATE TABLE Student (
    student_id SERIAL PRIMARY KEY,
    personal_id INT NOT NULL,
    discount float NOT NULL,
    FOREIGN KEY (personal_id) REFERENCES Personal_data(personal_id)
);

-- Crear la tabla Departments

CREATE TABLE Departments(
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Crear la tabla Salaries

CREATE TABLE Salaries(
     salaries_id SERIAL PRIMARY KEY, 
     level_salary VARCHAR(50) NOT NULL,
     import_salary DECIMAL(10,2) NOT null
);

-- Crear la tabla Employee

CREATE TABLE Employee(
     employee_id SERIAL PRIMARY KEY,
     personal_id INT NOT NULL,
     department_id INT NOT NULL,
     salaries_id INT NOT NULL, 
     account VARCHAR(25) NOT NULL,
     FOREIGN KEY (personal_id) REFERENCES Personal_data(personal_id),
     FOREIGN KEY (department_id) REFERENCES Departments(department_id),
     FOREIGN KEY (salaries_id) REFERENCES Salaries(salaries_id)
);


-- Crear la tabla Bootcamps
CREATE TABLE Bootcamps (
    bootcamp_id SERIAL PRIMARY KEY,
    coordinator INT NOT NULL,
    bootcamp_name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (coordinator) REFERENCES Employee(employee_id)
);

-- Crear la tabla Modules
CREATE TABLE Modules (
    module_id SERIAL PRIMARY KEY,
    module_name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

-- Crear la tabla Training

CREATE TABLE Training (
     training_id SERIAL PRIMARY KEY,
     student_id INT NOT NULL,
     bootcamp_id INT NOT NULL,
     FOREIGN KEY (student_id) REFERENCES Student(student_id),
     FOREIGN KEY (bootcamp_id) REFERENCES Bootcamps(bootcamp_id)

);


-- Crear la tabla Bootcamp_modules
CREATE TABLE Bootcamp_modules (
     boot_mod_id SERIAL PRIMARY KEY,
     module_id INT NOT NULL,
     bootcamp_id INT NOT NULL,
     FOREIGN KEY (module_id) REFERENCES Modules(module_id),
     FOREIGN KEY (bootcamp_id) REFERENCES Bootcamps(bootcamp_id)
);

-- Crear la tabla Teachers
CREATE TABLE Teachers (
     teachar_id SERIAL PRIMARY KEY,
     employee_id INT NOT NULL,
     module_id INT NOT NULL,
     FOREIGN KEY (module_id) REFERENCES Modules(module_id),
     FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- Insertar datos en Personal data

INSERT INTO personal_data (name, surname, email, phone, nif, country, adress) VALUES
('Pedro', 'Gómez', 'pedgom@gmail.com', '654789342', '72908765A','España', 'C/ Goya, 32, 1 Madrid'),
('Carla', 'Rodríguez', 'carrod@gmail.com', '634890761', 'C787987983', 'Mexico', 'C/ Independencia 23 Mexico DF'),
('Antonio', 'Smith', 'antsmi@gmail.com', '555908765', 'C8987890', 'EEUU', 'Avd/ Lincoln 45 3B Washington'),
('Lucia', 'Dominguez', 'lucdom@gmail.com', '690676876', '71787801Z', 'España', 'C/ Arriba 23 9 1C Valladolid')
;

-- Insertar datos en student
INSERT INTO student (personal_id, discount) VALUES
(1, 10.50),
(2, 0.00),
(3, 5.75);

-- Insertar datos en salaries
INSERT INTO salaries (level_salary, import_salary) VALUES
('A', 24000),
('AA', 27000),
('C', 34890.76);


-- Insertar datos en dapartment

INSERT INTO departments(namE) VALUES
('Formacion'),
('Contabilidad');

-- Insertar datos en employee

INSERT INTO employee (personal_id, department_id, salaries_id, account) VALUES
(4, 1, 2, 'ES347896789675432345'),
(3, 2, 3, 'ES547890000000098888');

-- Insertar datos en bootcamps:

INSERT INTO bootcamps (coordinator, bootcamp_name, price, start_date, end_date)
VALUES
  (1, 'Big Data, Machine Learning e IA' , 6000, DATE '2023-09-24', DATE '2024-07-03'),
  (1, 'Desarrollo Web' ,5500, DATE '2023-12-03', DATE '2024-09-08'),
  (1, 'Ciberseguridad' , 6200, DATE '2023-10-24', DATE '2024-05-13')
;

-- Insertar datos en Modules:
INSERT INTO modules (module_name, start_date, end_date) VALUES
  ('SQL AVANZADO', DATE '2023-12-07', DATE '2023-12-22'),
  ('RGPD', DATE '2024-01-10', DATE '2024-01-12'),
  ('REACT AVANZADO', DATE '2023-10-13', DATE '2023-10-23'),
  ('PROGRAMACION 101', DATE '2023-09-16', DATE '2023-09-28')
;

-- Insertar datos en bootcamps-modules:

INSERT INTO bootcamp_modules (module_id, bootcamp_id) VALUES
(1,1),
(2,1),
(4,1),
(2,2),
(2,3),
(3,3),
(2,3),
(4,3);

-- Insertar datos en teachers:

INSERT INTO teachers (employee_id, module_id) VALUES
(1,1),
(1,2),
(1,3),
(1,4);

-- Insertar datos en training:

INSERT INTO training (student_id, bootcamp_id) VALUES

(1,1),
(2,1),
(3,2),
(3,3),
(3,1);


