DROP TABLE Temporal;
CREATE TABLE Temporal (
    idTemporal NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nombre_eleccion VARCHAR(150) NOT NULL,
    year_eleccion INTEGER NOT NULL,
    pais varchar(100) NOT NULL, 
    region varchar(100) NOT NULL, 
    depto varchar(100) NOT NULL, 
    municipio varchar(100) NOT NULL, 
    partido varchar(100) NOT NULL, 
    nombre_partido varchar(100) NOT NULL, 
    sexo varchar(100) NOT NULL, 
    raza varchar(100) NOT NULL,
    analfabetos integer NOT NULL,
    alfabetos integer NOT NULL, 
    sexo2 varchar(100) NOT NULL, 
    raza2 varchar(100) NOT NULL, 
    primaria integer NOT NULL,
    nivel_medio integer NOT NULL,
    universitarios integer NOT NULL
);


SELECT * FROM temporal;