/************************************************CONSULTA 1 **********************************************************************************/
SELECT result1.nombre_eleccion as eleccion, result1.anio as "a�o eleccion",result1.pais as pais,result3.partido, ROUND(result1.mayor/result2.votos*100,2) as porcentaje
from (select sub1.nombre as nombre_eleccion, sub1.anio, sub1.pais, MAX(sub1.votos) as mayor from 
        (SELECT ele.nombre as nombre, ele.anio, p.nombre as pais, par.nombre as partido, SUM(cv.alfabetos+cv.analfabetos) as votos
        FROM conteovotos cv 
        INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido = elep.id_eleccion_partido
        INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
        INNER JOIN departamento d ON m.id_departamento = d.id_departamento
        INNER JOIN region r ON d.id_region = r.id_region
        INNER JOIN pais p ON r.id_pais = p.id_pais
        INNER JOIN eleccion ele on elep.id_eleccion = ele.id_eleccion
        INNER JOIN partido par on elep.id_partido = par.id_partido
        group by ele.nombre, ele.anio, p.nombre, par.nombre
        order by p.nombre) sub1 
        group by sub1.nombre, sub1.anio, sub1.pais order by sub1.pais) result1,
    (SELECT ele.nombre as nombre, ele.anio, p.nombre as pais, SUM(cv.alfabetos+cv.analfabetos) as votos
        FROM conteovotos cv 
        INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido = elep.id_eleccion_partido
        INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
        INNER JOIN departamento d ON m.id_departamento = d.id_departamento
        INNER JOIN region r ON d.id_region = r.id_region
        INNER JOIN pais p ON r.id_pais = p.id_pais
        INNER JOIN eleccion ele on elep.id_eleccion = ele.id_eleccion
        INNER JOIN partido par on elep.id_partido = par.id_partido
        group by ele.nombre, ele.anio, p.nombre
        order by p.nombre) result2,
    (SELECT ele.nombre as nombre, ele.anio, p.nombre as pais, par.nombre as partido, SUM(cv.alfabetos+cv.analfabetos) as votos
        FROM conteovotos cv 
        INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido = elep.id_eleccion_partido
        INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
        INNER JOIN departamento d ON m.id_departamento = d.id_departamento
        INNER JOIN region r ON d.id_region = r.id_region
        INNER JOIN pais p ON r.id_pais = p.id_pais
        INNER JOIN eleccion ele on elep.id_eleccion = ele.id_eleccion
        INNER JOIN partido par on elep.id_partido = par.id_partido
        group by ele.nombre, ele.anio, p.nombre, par.nombre
        order by p.nombre) result3
    where result2.nombre = result1.nombre_eleccion
    and result2.anio = result1.anio 
    and result2.pais = result1.pais
    and result3.nombre =result1.nombre_eleccion
    and result3.anio = result1.anio
    and result3.pais = result1.pais
    and result3.votos = result1.mayor;

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

ROUND(((SUM(cv.analfabetos+cv.alfabetos))
/(SELECT sum(sum(cv.alfabetos+cv.analfabetos)) from conteovotos cv 
INNER JOIN municipio mm ON cv.id_municipio = mm.id_municipio
INNER JOIN sexo sex ON cv.id_sexo = sex.id_sexo
INNER JOIN departamento dd ON mm.id_departamento = dd.id_departamento
INNER JOIN region rr ON dd.id_region = rr.id_region
INNER JOIN pais pp ON rr.id_pais = pp.id_pais
where sex.nombre = 'mujeres'
and pp.nombre = p.nombre
group by pp.nombre))*100,2) as "Porcentaje Departamentos",

ROUND(((SELECT sum(sum(cv.alfabetos+cv.analfabetos)) from conteovotos cv 
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
group by pp.nombre))*100,2) as "Porcentaje Pais"

FROM conteovotos cv
INNER JOIN sexo sex ON cv.id_sexo = sex.id_sexo
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
where UPPER(sex.nombre) = 'MUJERES'
group by  p.nombre, d.nombre
order by p.nombre asc;

/******************************************************************************************************************************************************/
/******************************************************************Consulta 3 *************************************************************************/
SELECT ganador.pais, aux.partido, ganador.cantidad FROM 
(SELECT resultquery.pais as pais, MAX(cantidad) as cantidad FROM 
    (SELECT resultquery.pais, resultquery.partido, COUNT(resultquery.muna) AS cantidad FROM
        (SELECT subquery1.pais as pais, subquery1.partido as partido, subquery1.idmun as muna, subquery2.votos FROM 
            (SELECT p.nombre as pais, par.nombre as partido, m.id_municipio as idmun, SUM(cv.alfabetos+cv.analfabetos) AS votos 
                FROM conteovotos CV
                INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
                INNER JOIN departamento d ON m.id_departamento = d.id_departamento
                INNER JOIN region r ON d.id_region = r.id_region
                INNER JOIN pais p ON r.id_pais = p.id_pais
                INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido = elep.id_eleccion_partido
                INNER JOIN partido par ON elep.id_partido = par.id_partido
                GROUP BY p.nombre, par.nombre, m.id_municipio
                ORDER BY p.nombre, m.id_municipio) subquery1,
            (SELECT subqueryaux2.pais AS pais, subqueryaux2.mun as idmun, MAX(subqueryaux2.votos) as votos FROM 
                (SELECT p.nombre as pais, par.nombre as partido, m.id_municipio AS mun, m.nombre, SUM(CV.alfabetos+CV.analfabetos) as votos
                    from conteovotos CV
                    INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
                    INNER JOIN departamento d ON m.id_departamento = d.id_departamento
                    INNER JOIN region r ON d.id_region = r.id_region
                    INNER JOIN pais p ON r.id_pais = p.id_pais
                    INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido = elep.id_eleccion_partido
                    INNER JOIN partido par ON elep.id_partido = par.id_partido
                    GROUP BY p.nombre, m.id_municipio, m.nombre, par.nombre
                    ORDER BY p.nombre, m.id_municipio) subqueryaux2
                group by subqueryaux2.pais, subqueryaux2.mun
                ORDER BY subqueryaux2.mun) subquery2
        where subquery1.pais = subquery2.pais
        and subquery1.votos = subquery2.votos
        and subquery1.idmun = subquery2.idmun
        order by subquery1.idmun) resultquery group by resultquery.pais, resultquery.partido) resultquery 
    group by resultquery.pais) ganador, 
(SELECT resultquery.pais, resultquery.partido, COUNT(resultquery.muna) AS cantidad FROM
    (SELECT subquery1.pais as pais, subquery1.partido as partido, subquery1.idmun as muna, subquery2.votos FROM 
        (SELECT p.nombre as pais, par.nombre as partido, m.id_municipio as idmun, SUM(cv.alfabetos+cv.analfabetos) AS votos 
            FROM conteovotos CV
            INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
            INNER JOIN departamento d ON m.id_departamento = d.id_departamento
            INNER JOIN region r ON d.id_region = r.id_region
            INNER JOIN pais p ON r.id_pais = p.id_pais
            INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido = elep.id_eleccion_partido
            INNER JOIN partido par ON elep.id_partido = par.id_partido
            GROUP BY p.nombre, par.nombre, m.id_municipio
            ORDER BY p.nombre, m.id_municipio) subquery1,
        (SELECT subqueryaux2.pais AS pais, subqueryaux2.mun as idmun, MAX(subqueryaux2.votos) as votos FROM 
            (SELECT p.nombre as pais, par.nombre as partido, m.id_municipio AS mun, m.nombre, SUM(CV.alfabetos+CV.analfabetos) as votos
                from conteovotos CV
                INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
                INNER JOIN departamento d ON m.id_departamento = d.id_departamento
                INNER JOIN region r ON d.id_region = r.id_region
                INNER JOIN pais p ON r.id_pais = p.id_pais
                INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido = elep.id_eleccion_partido
                INNER JOIN partido par ON elep.id_partido = par.id_partido
                GROUP BY p.nombre, m.id_municipio, m.nombre, par.nombre
                ORDER BY p.nombre, m.id_municipio) subqueryaux2
            group by subqueryaux2.pais, subqueryaux2.mun
            ORDER BY subqueryaux2.mun) subquery2
        where subquery1.pais = subquery2.pais
        and subquery1.votos = subquery2.votos
        and subquery1.idmun = subquery2.idmun
        order by subquery1.idmun) resultquery
    group by resultquery.pais, resultquery.partido) aux 
where ganador.pais = aux.pais
and ganador.cantidad = aux.cantidad
order by ganador.pais;
/******************************************************************************************************************************************************/
/******************************************************************Consulta 4 *************************************************************************/
SELECT  h.pais, h.region, h.total from (SELECT x.pais, x.region, max(x.total) as total from (SELECT p.nombre as pais, r.nombre as region, raz.nombre as raza, SUM(cv.alfabetos+cv.analfabetos) as total from conteovotos cv 
INNER JOIN raza raz on cv.id_raza = raz.id_raza
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
group by p.nombre, r.nombre, raz.nombre
order by pais) x group by x.pais, x.region) v, (SELECT p.nombre as pais, r.nombre as region, raz.nombre as raza, SUM(cv.alfabetos+cv.analfabetos) as total from conteovotos cv 
INNER JOIN raza raz on cv.id_raza = raz.id_raza
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
group by p.nombre, r.nombre, raz.nombre
order by pais) h
where v.pais = h.pais
and v.region = h.region
and v.total = h.total
and h.raza = 'INDIGENAS';
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
            where UPPER(sex.nombre) = 'MUJERES'
            group by p.nombre, d.nombre, sex.nombre
) x
INNER JOIN (SELECT p.nombre as pais, d.nombre as departamento,
                sex.nombre as sexo, sum(cv.universitarios) as universitarios from conteovotos  cv
                INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
                INNER JOIN departamento d ON m.id_departamento = d.id_departamento
                INNER JOIN region r ON d.id_region = r.id_region
                INNER JOIN pais p ON r.id_pais = p.id_pais
                INNER JOIN sexo sex ON cv.id_sexo = sex.id_sexo
                where UPPER(sex.nombre) = 'HOMBRES'
                group by p.nombre, d.nombre, sex.nombre
) h on x.pais = h.pais and x.departamento = h.departamento
where x.universitarios > h.universitarios
order by x.departamento;
/****************************************************************************************************************************************************************/
/************************************************************** Consulta 6 **************************************************************************************/
SELECT x.pais, x.region, ROUND(sum(x.total)/(SELECT count(*) 
from (SELECT p.nombre as pais, d.nombre as departamento, r.nombre as region, sum(cv.analfabetos+cv.alfabetos) as total
                from conteovotos  cv
                INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
                INNER JOIN departamento d ON m.id_departamento = d.id_departamento
                INNER JOIN region r ON d.id_region = r.id_region
                INNER JOIN pais p ON r.id_pais = p.id_pais
                group by p.nombre, d.nombre, r.nombre) y 
where x.pais = y.pais and x.region = y.region),2) as promedio
from (SELECT p.nombre as pais, d.nombre as departamento, r.nombre as region, sum(cv.analfabetos+cv.alfabetos) as total
                from conteovotos  cv
                INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
                INNER JOIN departamento d ON m.id_departamento = d.id_departamento
                INNER JOIN region r ON d.id_region = r.id_region
                INNER JOIN pais p ON r.id_pais = p.id_pais
                group by p.nombre, d.nombre, r.nombre) x
group by x.pais, x.region
order by x.pais,x.region asc;
/****************************************************************************************************************************************************************/
/************************************************************** Consulta 7 **************************************************************************************/
/*SELECT DISTINCT x.pais, x.muni, (select h.partido from (SELECT p.nombre as pais, d.nombre as departamento, 
m.nombre  muni, par.nombre as partido, sum(cv.alfabetos+cv.analfabetos) as total 
from conteovotos cv
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido= elep.id_eleccion_partido
INNER JOIN partido par ON elep.id_partido = par.id_partido
group by p.nombre, d.nombre, m.nombre, par.nombre) h 
where h.pais = x.pais and h.muni = x.muni 
order by h.total desc 
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY) as Partido1,
(select h.partido from (SELECT p.nombre as pais, d.nombre as departamento, 
m.nombre  muni, par.nombre as partido, sum(cv.alfabetos+cv.analfabetos) as total 
from conteovotos cv
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido= elep.id_eleccion_partido
INNER JOIN partido par ON elep.id_partido = par.id_partido
group by p.nombre, d.nombre, m.nombre, par.nombre) h 
where h.pais = x.pais and h.muni = x.muni 
order by h.total desc 
OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY) as Partido2
from (SELECT p.nombre as pais, d.nombre as departamento,
m.nombre muni, par.nombre as partido, sum(cv.alfabetos+cv.analfabetos) as total 
from conteovotos cv
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido= elep.id_eleccion_partido
INNER JOIN partido par ON elep.id_partido = par.id_partido
group by p.nombre, d.nombre, m.nombre, par.nombre) x
group by x.pais, x.muni
order by pais ;*/

SELECT segundo_partido.PAIS, segundo_partido.MUNICIPIO, segundo_partido.PARTIDO FROM(
SELECT primer_partido.PAIS AS PAIS, primer_partido.MUNICIPIO AS MUNICIPIO, primer_partido.PARTIDO AS PARTIDO, ROW_NUMBER() OVER 
(PARTITION BY primer_partido.PAIS,primer_partido.MUNICIPIO ORDER BY primer_partido.VOTOS desc) AS VOTOS_TOP, primer_partido.VOTOS
FROM (
SELECT p.nombre AS PAIS, m.nombre AS MUNICIPIO, par.nombre AS PARTIDO, SUM(cv.analfabetos + cv.alfabetos) AS VOTOS 
FROM conteovotos cv
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido= elep.id_eleccion_partido
INNER JOIN partido par ON elep.id_partido = par.id_partido
group by p.nombre, m.nombre, par.nombre
) primer_partido
ORDER BY primer_partido.PAIS, primer_partido.MUNICIPIO, VOTOS_TOP
) segundo_partido
WHERE segundo_partido.VOTOS_TOP <= 2
ORDER BY segundo_partido.PAIS, segundo_partido.MUNICIPIO, segundo_partido.VOTOS_TOP;
/****************************************************************************************************************************************************************/
/************************************************************** Consulta 8 **************************************************************************************/
SELECT p.nombre as pais, sum(cv.primaria) as primaria, sum(cv.nivel_medio) as 
"NIVEL MEDIO", sum(cv.universitarios) as universitarios from conteovotos cv
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
group by p.nombre
order by pais asc;
/****************************************************************************************************************************************************************/
/************************************************************** Consulta 9 **************************************************************************************/
SELECT x.pais, x.raza, ROUND((x.total/(SELECT sum(h.total) from (SELECT p.nombre as pais, raz.nombre as raza, sum(cv.alfabetos+cv.analfabetos) as total
FROM conteovotos cv
INNER JOIN raza raz ON cv.id_raza = raz.id_raza
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
group by p.nombre, raz.nombre) h
where h.pais = x.pais group by h.pais))*100,2) as "TOTAL PORCENTUAL%" from 
(SELECT p.nombre as pais, raz.nombre as raza, sum(cv.alfabetos+cv.analfabetos) as total
FROM conteovotos cv
INNER JOIN raza raz ON cv.id_raza = raz.id_raza
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
group by p.nombre, raz.nombre) x 
order by x.pais;
/****************************************************************************************************************************************************************/
/************************************************************** Consulta 10 *************************************************************************************/
select x.pais,ROUND((max(x.total)-min(x.total))/(select sum(h.total) from (
select p.nombre as pais, par.nombre as partido, sum(cv.alfabetos+cv.analfabetos) as total 
from conteovotos cv 
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido = elep.id_eleccion_partido
INNER JOIN partido par ON elep.id_partido = par.id_partido
group by p.nombre, par.nombre) h where x.pais = h.pais)*100,2) as "DIFERENCIA PORCENTUAL%" from 
(select p.nombre as pais, par.nombre as partido, sum(cv.alfabetos+cv.analfabetos) as total 
from conteovotos cv 
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
INNER JOIN eleccionpartido elep ON cv.id_eleccion_partido = elep.id_eleccion_partido
INNER JOIN partido par ON elep.id_partido = par.id_partido
group by p.nombre, par.nombre)x
group by x.pais
order by "DIFERENCIA PORCENTUAL%"
FETCH NEXT 1 ROWS ONLY
;
/****************************************************************************************************************************************************************/
/************************************************************** Consulta 11 *************************************************************************************/
SELECT x.total as total_votos, ROUND(h.total/x.total*100,2) as "PORCENTAJE MUJERES ALFABETAS%" FROM 
(select sum(cv.alfabetos+cv.analfabetos) as total from conteovotos cv) x, 
(select sum(cv.alfabetos) as total from conteovotos cv 
INNER JOIN raza raz ON cv.id_raza = raz.id_raza
INNER JOIN sexo sex ON cv.id_sexo = sex.id_sexo
where UPPER(raz.nombre) = 'INDIGENAS'
and UPPER(sex.nombre) = 'MUJERES') h;
/***************************************************************************************************************************************************************/
/************************************************************** Consulta 12 ************************************************************************************/
SELECT x.pais, ROUND((x.analfabetas/x.total)*100,2) as porcentaje from (
select p.nombre as pais, sum(cv.analfabetos) as analfabetas, sum(cv.analfabetos+cv.alfabetos) as total 
from conteovotos cv 
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
group by p.nombre
) x
order by porcentaje desc
FETCH NEXT 1 ROWS ONLY;
/************************************************************** VERSION 2 ************************************************************************************/
SELECT x.pais, ROUND((x.analfabetas/h.total)*100,2) as porcentaje from (
select p.nombre as pais, sum(cv.analfabetos) as analfabetas, sum(cv.analfabetos+cv.alfabetos) as total 
from conteovotos cv 
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
group by p.nombre
) x,
(select sum(x.total) as total from 
(select p.nombre as pais, sum(cv.analfabetos) as analfabetas, sum(cv.analfabetos+cv.alfabetos) as total 
from conteovotos cv 
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
group by p.nombre)x) h
order by porcentaje desc
FETCH NEXT 1 ROWS ONLY;
/****************************************************************************************************************************************************************/
/************************************************************** Consulta 13 ************************************************************************************/
SELECT result.dep, result.votos AS "CANTIDAD VOTOS" FROM (SELECT d.id_departamento, d.nombre AS DEP, SUM(cv.alfabetos + cv.analfabetos) AS VOTOS FROM conteovotos cv
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
AND UPPER(p.nombre) = 'GUATEMALA'
group by d.id_departamento, d.nombre) result, (SELECT d.id_departamento, d.nombre AS DEP, SUM(cv.alfabetos + cv.analfabetos) AS VOTOS FROM conteovotos cv
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
AND UPPER(p.nombre) = 'GUATEMALA'
AND UPPER(d.nombre) = 'GUATEMALA'
group by d.id_departamento, d.nombre) aux
WHERE result.votos > aux.votos;
/****************************************************************************************************************************************************************/
/************************************************************** Consulta 14 ************************************************************************************/
SELECT UPPER(SUBSTR(REPLACE(m.nombre,' ',''),1,1)) as INICIAL, SUM(cv.alfabetos+cv.analfabetos) as total FROM conteovotos cv
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
group by SUBSTR(REPLACE(m.nombre,' ',''),1,1)
order by UPPER(SUBSTR(REPLACE(m.nombre,' ',''),1,1));