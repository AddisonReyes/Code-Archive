CREATE DATABASE VeterinariaINT2024T3;

USE VeterinariaINT2024T3;

CREATE TABLE Cliente (
    IDcliente INT PRIMARY KEY AUTO_INCREMENT,
    NombreApellido VARCHAR(200) NOT NULL,
    Cedula VARCHAR(13) UNIQUE,
    Edad INT,
    Direccion VARCHAR(255)
);

CREATE TABLE PacienteAnimal (
    IDPacienteAnimal INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Raza VARCHAR(45),
    TipoAnimal VARCHAR(45),
    Edad VARCHAR(100),
    IDcliente INT,
    FOREIGN KEY (IDcliente) REFERENCES Cliente(IDcliente)
);

CREATE TABLE Tratamiento (
    IDTratamiento INT PRIMARY KEY AUTO_INCREMENT,
    Suplidor VARCHAR(100),
    Tiempo VARCHAR(50) NOT NULL,
    Costo FLOAT,
    -- Campo adicional Descripcion ya que no estaba en el diagrama
    Descripcion VARCHAR(45)
);

CREATE TABLE PacienteAnimalTratamiento (
    IDPacienteAnimalTratamiento INT PRIMARY KEY AUTO_INCREMENT,
    IDPacienteAnimal INT,
    IDTratamiento INT,
    FOREIGN KEY (IDPacienteAnimal) 
        REFERENCES PacienteAnimal(IDPacienteAnimal),
    FOREIGN KEY (IDTratamiento) 
        REFERENCES Tratamiento(IDTratamiento)
);

CREATE TABLE Rol (
    IDRol INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100),
    Descripcion VARCHAR(100)
);

CREATE TABLE Empleado (
    IDEmpleado INT PRIMARY KEY AUTO_INCREMENT,
    NombreApellido VARCHAR(200) NOT NULL,
    Cedula VARCHAR(13) UNIQUE,
    Edad INT,
    Direccion VARCHAR(255),
    IDRol INT,
    FOREIGN KEY (IDRol) REFERENCES Rol(IDRol)
);