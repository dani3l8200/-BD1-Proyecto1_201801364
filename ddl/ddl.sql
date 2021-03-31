DROP TABLE Pais cascade constraints;
DROP TABLE Region cascade constraints;
DROP TABLE Departamento cascade constraints;
DROP TABLE Municipio cascade constraints;
DROP TABLE Eleccion cascade constraints;
DROP TABLE Partido  cascade constraints;
DROP TABLE EleccionPartido  cascade constraints;
DROP TABLE Sexo cascade constraints;
DROP TABLE Raza  cascade constraints;
DROP TABLE ConteoVotos cascade constraints;
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