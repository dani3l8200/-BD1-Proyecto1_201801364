/******************************************************************************************************/
INSERT INTO pais(nombre)
SELECT DISTINCT(pais) FROM temporal;
/******************************************************************************************************/
INSERT INTO region(nombre, id_pais)
SELECT DISTINCT(region), pais.id_pais FROM temporal, pais
WHERE temporal.pais = pais.nombre;
/******************************************************************************************************/
INSERT INTO Departamento(nombre, id_region)
SELECT DISTINCT(t.depto), r.id_region FROM temporal t, region r
INNER JOIN pais p ON r.id_pais = p.id_pais
WHERE t.region = r.nombre
AND t.pais = p.nombre;
/******************************************************************************************************/
INSERT INTO Municipio(nombre,id_departamento)
SELECT DISTINCT(t.municipio), d.id_departamento FROM temporal t, departamento d
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
WHERE t.depto = d.nombre
AND t.region = r.nombre
AND t.pais = p.nombre;
/******************************************************************************************************/
INSERT INTO eleccion(nombre, anio) 
SELECT DISTINCT t.nombre_eleccion, t.year_eleccion FROM temporal t;
/******************************************************************************************************/
INSERT INTO partido(partido, nombre)
SELECT DISTINCT t.partido, t.nombre_partido FROM temporal t;
/******************************************************************************************************/
INSERT INTO EleccionPartido(id_eleccion, id_partido)
SELECT DISTINCT e.id_eleccion, p.id_partido FROM temporal t, partido p, eleccion e
WHERE t.nombre_eleccion = e.nombre 
AND t.year_eleccion = e.anio
AND t.partido = p.partido 
AND t.nombre_partido = p.nombre;
/******************************************************************************************************/
INSERT INTO Sexo(nombre)
SELECT DISTINCT t.sexo FROM temporal t 
WHERE t.sexo = t.sexo2;
/******************************************************************************************************/
INSERT INTO Raza(nombre)
SELECT DISTINCT t.raza FROM temporal t 
WHERE t.raza = t.raza2;
/******************************************************************************************************/
INSERT INTO ConteoVotos(alfabetos,analfabetos,primaria,nivel_medio,
universitarios,id_raza,id_sexo,id_municipio,id_eleccion_partido)
SELECT DISTINCT t.alfabetos, t.analfabetos,t.primaria, t.nivel_medio, t.universitarios,
raz.id_raza, sex.id_sexo, m.id_municipio, elep.id_eleccion_partido
FROM   temporal t, municipio m
INNER JOIN departamento d ON d.id_departamento = m.id_departamento
INNER JOIN region r ON r.id_region = d.id_region
INNER JOIN pais p on p.id_pais = r.id_pais,
EleccionPartido elep
INNER JOIN eleccion ele on elep.id_eleccion = ele.id_eleccion
INNER JOIN partido par on elep.id_partido = par.id_partido,
Raza raz, Sexo sex
WHERE t.raza = raz.nombre
AND t.sexo = sex.nombre 
AND t.municipio = m.nombre
AND t.depto = d.nombre
AND t.region = r.nombre
AND t.pais = p.nombre
AND t.nombre_eleccion = ele.nombre
AND t.year_eleccion = ele.anio 
AND t.partido = par.partido
AND t.nombre_partido = par.nombre;
/******************************************************************************************************/