/******************************************************************************************************/
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
/******************************************************************************************************/
CREATE TABLE Pais(
    id_pais NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL
);
/******************************************************************************************************/
CREATE TABLE Region(
    id_region NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    id_pais NUMBER NOT NULL,
    FOREIGN KEY(id_pais) REFERENCES Pais(id_pais)
);
/******************************************************************************************************/
CREATE TABLE Departamento(
    id_departamento NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    id_region NUMBER NOT NULL,
    FOREIGN KEY(id_region) REFERENCES Region(id_region)
);
/******************************************************************************************************/
CREATE TABLE Municipio(
    id_municipio NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    id_departamento NUMBER NOT NULL,
    FOREIGN KEY(id_departamento) REFERENCES Departamento(id_departamento)
);
/******************************************************************************************************/
CREATE TABLE Eleccion(
    id_eleccion NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nombre VARCHAR2(200),
    anio NUMBER
);
/******************************************************************************************************/
CREATE TABLE Partido(
    id_partido NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    partido VARCHAR2(100),
    nombre VARCHAR2(100)
);
/******************************************************************************************************/
CREATE TABLE EleccionPartido(
    id_eleccion_partido NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    id_eleccion NUMBER NOT NULL,
    id_partido NUMBER NOT NULL,
    FOREIGN KEY(id_eleccion) REFERENCES Eleccion(id_eleccion),
    FOREIGN KEY(id_partido) REFERENCES Partido(id_partido)
);
/******************************************************************************************************/
CREATE TABLE Sexo(
    id_sexo NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nombre VARCHAR2(100)
);
/******************************************************************************************************/
CREATE TABLE Raza(
    id_raza NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    nombre VARCHAR2(100)
);
/******************************************************************************************************/
CREATE TABLE ConteoVotos(
    id_conteo_votos NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL PRIMARY KEY,
    alfabetos NUMBER NOT NULL,
    analfabetos NUMBER NOT NULL,
    primaria NUMBER NOT NULL,
    nivel_medio NUMBER NOT NULL,
    universitarios NUMBER NOT NULL,
    id_raza NUMBER NOT NULL,
    id_sexo NUMBER NOT NULL,
    id_municipio NUMBER NOT NULL,
    id_eleccion_partido NUMBER NOT NULL,
    FOREIGN KEY(id_raza) REFERENCES Raza(id_raza),
    FOREIGN KEY(id_sexo) REFERENCES Sexo(id_sexo),
    FOREIGN KEY(id_municipio) REFERENCES Municipio(id_municipio),
    FOREIGN KEY(id_eleccion_partido) REFERENCES EleccionPartido(id_eleccion_partido)
);
/******************************************************************************************************/
exit;