/************************************************CONSULTA 1 **********************************************************************************/
SELECT ele.nombre as "eleccion", ele.anio "año eleccion", p.nombre "pais",
par.nombre "nombre_partido", par.partido "Partido", ROUND((SUM(cv.analfabetos+cv.alfabetos)/(SELECT SUM(SUM(cv.analfabetos+cv.alfabetos))
FROM conteovotos cv
INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido = elep.id_eleccion_partido
INNER JOIN eleccion ele on elep.id_eleccion = ele.id_eleccion
group by ele.nombre 
))*100,2) as "Total%" FROM conteovotos cv
INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido = elep.id_eleccion_partido
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
INNER JOIN eleccion ele on elep.id_eleccion = ele.id_eleccion
INNER JOIN partido par on elep.id_partido = par.id_partido
group by ele.anio, ele.nombre, par.nombre, par.partido, p.nombre
ORDER BY "Total%" desc;
/******************************************************************************************************************************************************/
/****************************************************** CONSULTA 2 ***********************************************************************************/
SELECT p.nombre as pais, d.nombre as departamento, SUM(cv.analfabetos+cv.alfabetos) as TotalDepartamento,

(SELECT sum(cv.alfabetos+cv.analfabetos) from conteovotos cv 
INNER JOIN municipio mm ON cv.id_municipio = mm.id_municipio
INNER JOIN sexo sex ON cv.id_sexo = sex.id_sexo
INNER JOIN departamento dd ON mm.id_departamento = dd.id_departamento
INNER JOIN region rr ON dd.id_region = rr.id_region
INNER JOIN pais pp ON rr.id_pais = pp.id_pais
where pp.nombre = p.nombre and 
sex.nombre = 'mujeres'
group by pp.nombre
) as TotalPais,

ROUND((SUM(cv.analfabetos+cv.alfabetos))
/(SELECT sum(sum(cv.alfabetos+cv.analfabetos)) from conteovotos cv 
INNER JOIN municipio mm ON cv.id_municipio = mm.id_municipio
INNER JOIN sexo sex ON cv.id_sexo = sex.id_sexo
INNER JOIN departamento dd ON mm.id_departamento = dd.id_departamento
INNER JOIN region rr ON dd.id_region = rr.id_region
INNER JOIN pais pp ON rr.id_pais = pp.id_pais
where sex.nombre = 'mujeres'
and pp.nombre = p.nombre
group by pp.nombre),2) as PorcentajeDepartamentos,

ROUND((SELECT sum(sum(cv.alfabetos+cv.analfabetos)) from conteovotos cv 
INNER JOIN municipio mm ON cv.id_municipio = mm.id_municipio
INNER JOIN sexo sex ON cv.id_sexo = sex.id_sexo
INNER JOIN departamento dd ON mm.id_departamento = dd.id_departamento
INNER JOIN region rr ON dd.id_region = rr.id_region
INNER JOIN pais pp ON rr.id_pais = pp.id_pais
where sex.nombre = 'mujeres'
and pp.nombre = p.nombre
group by pp.nombre)
/(SELECT sum(sum(cv.alfabetos+cv.analfabetos)) from conteovotos cv 
INNER JOIN municipio mm ON cv.id_municipio = mm.id_municipio
INNER JOIN sexo sex ON cv.id_sexo = sex.id_sexo
INNER JOIN departamento dd ON mm.id_departamento = dd.id_departamento
INNER JOIN region rr ON dd.id_region = rr.id_region
INNER JOIN pais pp ON rr.id_pais = pp.id_pais
where sex.nombre = 'mujeres'
group by pp.nombre),2) as PorcentajePais

FROM conteovotos cv
INNER JOIN sexo sex ON cv.id_sexo = sex.id_sexo
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
where sex.nombre = 'mujeres'
group by  p.nombre, d.nombre
order by TotalPais desc;
/******************************************************************************************************************************************************/
/******************************************************************Consulta 3 *************************************************************************/

/******************************************************************************************************************************************************/
/******************************************************************Consulta 4 *************************************************************************/
SELECT p.nombre as pais, r.nombre as region, raz.nombre, SUM(cv.alfabetos+cv.analfabetos) as total from conteovotos cv 
INNER JOIN raza raz on cv.id_raza = raz.id_raza
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
where raz.nombre = 'INDIGENAS'
group by p.nombre, r.nombre, raz.nombre
order by pais;
/*******************************************************************************************************************************************************/
/****************************************************************Consulta 5 *****************************************************************************/
SELECT x.pais, x.departamento, 
ROUND((x.universitarios/(h.universitarios+x.universitarios))*100,2) as mujeres,
ROUND((h.universitarios/(h.universitarios+x.universitarios))*100,2) as hombres
from (  SELECT p.nombre as pais, d.nombre as departamento,
            sex.nombre as sexo, sum(cv.universitarios) as universitarios from conteovotos  cv
            INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
            INNER JOIN departamento d ON m.id_departamento = d.id_departamento
            INNER JOIN region r ON d.id_region = r.id_region
            INNER JOIN pais p ON r.id_pais = p.id_pais
            INNER JOIN sexo sex ON cv.id_sexo = sex.id_sexo
            group by p.nombre, d.nombre, sex.nombre
) x
INNER JOIN (SELECT p.nombre as pais, d.nombre as departamento,
                sex.nombre as sexo, sum(cv.universitarios) as universitarios from conteovotos  cv
                INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
                INNER JOIN departamento d ON m.id_departamento = d.id_departamento
                INNER JOIN region r ON d.id_region = r.id_region
                INNER JOIN pais p ON r.id_pais = p.id_pais
                INNER JOIN sexo sex ON cv.id_sexo = sex.id_sexo
                group by p.nombre, d.nombre, sex.nombre
) h on x.pais = h.pais and x.departamento = h.departamento
where x.universitarios > h.universitarios;
/****************************************************************************************************************************************************************/
/************************************************************** Consulta 6 **************************************************************************************/

