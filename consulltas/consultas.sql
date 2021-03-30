/************************************************CONSULTA 1 **********************************************************************************/
SELECT result1.nombre_eleccion as eleccion, result1.anio as "año eleccion",result1.pais as pais,result3.partido, ROUND(result1.mayor/result2.votos*100,2) as porcentaje
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
where UPPER(sex.nombre) = 'MUJERES'
group by  p.nombre, d.nombre
order by TotalPais desc;
/******************************************************************************************************************************************************/
/******************************************************************Consulta 3 *************************************************************************/
SELECT TOTAL.PAIS, PART.PARTIDO, TOTAL.CANTIDAD FROM 
(SELECT TOT.PAIS as PAIS, MAX(CANTIDAD) as CANTIDAD FROM 
    (SELECT RA.PAIS, RA.PARTIDO, COUNT(RA.MUNA) AS CANTIDAD FROM
        (SELECT UNO.PAIS as PAIS, UNO.PARTIDO as PARTIDO, UNO.IDMUN as MUNA, DOS.VOTOS FROM 
            (SELECT PA.NOMBRE as PAIS, PAR.NOMBRE as PARTIDO, MU.ID_MUNICIPIO as IDMUN, SUM(CV.ANALFABETOS + CV.ALFABETOS) AS VOTOS 
             FROM conteovotos CV
             INNER JOIN municipio MU ON CV.id_municipio = MU.id_municipio
             INNER JOIN departamento DE ON MU.id_departamento = DE.id_departamento
             INNER JOIN region RE ON DE.id_region = RE.id_region
             INNER JOIN pais PA ON RE.id_pais = PA.id_pais
             INNER JOIN eleccionpartido ELEP ON cv.id_eleccion_partido = ELEP.id_eleccion_partido
             INNER JOIN partido PAR ON ELEP.id_partido = PAR.id_partido
             GROUP BY PA.nombre, PAR.nombre, MU.id_municipio
             ORDER BY PA.nombre, MU.id_municipio) UNO,
            (SELECT UN.PAIS AS PAIS, UN.MUN as IDMUN, MAX(UN.VOTOS) as VOTOS FROM 
                (SELECT PA.nombre as PAIS, PAR.nombre as PARTIDO, MU.id_municipio AS MUN, MU.nombre, SUM(CV.alfabetos+CV.analfabetos) as VOTOS
                from conteovotos CV
                INNER JOIN municipio MU ON CV.id_municipio = MU.id_municipio
                INNER JOIN departamento DE ON MU.id_departamento = DE.id_departamento
                INNER JOIN region RE ON DE.id_region = RE.id_region
                INNER JOIN pais PA ON RE.id_pais = PA.id_pais
                INNER JOIN eleccionpartido ELEP ON cv.id_eleccion_partido = ELEP.id_eleccion_partido
                INNER JOIN partido PAR ON ELEP.id_partido = PAR.id_partido
                GROUP BY PA.nombre, PAR.nombre, MU.id_municipio, MU.nombre
                ORDER BY PA.nombre, MU.id_municipio) UN
                group by UN.PAIS, UN.MUN
                ORDER BY un.MUN) DOS
        where uno.pais = dos.pais
        and uno.votos = dos.votos
        and uno.idmun = dos.idmun
        order by uno.idmun) RA group by RA.PAIS, RA.PARTIDO) TOT group by tot.pais) TOTAL, (SELECT RA.PAIS, RA.PARTIDO, COUNT(RA.MUNA) AS CANTIDAD FROM
        (SELECT UNO.PAIS as PAIS, UNO.PARTIDO as PARTIDO, UNO.IDMUN as MUNA, DOS.VOTOS FROM 
            (SELECT PA.NOMBRE as PAIS, PAR.NOMBRE as PARTIDO, MU.ID_MUNICIPIO as IDMUN, SUM(CV.ANALFABETOS + CV.ALFABETOS) AS VOTOS 
             FROM conteovotos CV
             INNER JOIN municipio MU ON CV.id_municipio = MU.id_municipio
             INNER JOIN departamento DE ON MU.id_departamento = DE.id_departamento
             INNER JOIN region RE ON DE.id_region = RE.id_region
             INNER JOIN pais PA ON RE.id_pais = PA.id_pais
             INNER JOIN eleccionpartido ELEP ON cv.id_eleccion_partido = ELEP.id_eleccion_partido
             INNER JOIN partido PAR ON ELEP.id_partido = PAR.id_partido
             GROUP BY PA.nombre, PAR.nombre, MU.id_municipio
             ORDER BY PA.nombre, MU.id_municipio) UNO,
            (SELECT UN.PAIS AS PAIS, UN.MUN as IDMUN, MAX(UN.VOTOS) as VOTOS FROM 
                (SELECT PA.nombre as PAIS, PAR.nombre as PARTIDO, MU.id_municipio AS MUN, MU.nombre, SUM(CV.alfabetos+CV.analfabetos) as VOTOS
                from conteovotos CV
                INNER JOIN municipio MU ON CV.id_municipio = MU.id_municipio
                INNER JOIN departamento DE ON MU.id_departamento = DE.id_departamento
                INNER JOIN region RE ON DE.id_region = RE.id_region
                INNER JOIN pais PA ON RE.id_pais = PA.id_pais
                INNER JOIN eleccionpartido ELEP ON cv.id_eleccion_partido = ELEP.id_eleccion_partido
                INNER JOIN partido PAR ON ELEP.id_partido = PAR.id_partido
                GROUP BY PA.nombre, PAR.nombre, MU.id_municipio, MU.nombre
                ORDER BY PA.nombre, MU.id_municipio) UN
                group by UN.PAIS, UN.MUN
                ORDER BY un.MUN) DOS
        where uno.pais = dos.pais
        and uno.votos = dos.votos
        and uno.idmun = dos.idmun
        order by uno.idmun) RA group by RA.PAIS, RA.PARTIDO) PART 
        where TOTAL.pais = PART.pais
        and total.CANTIDAD = part.CANTIDAD
        order by total.pais;
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
SELECT DISTINCT x.pais, x.muni, (select h.partido from (SELECT p.nombre as pais, d.nombre as departamento, 
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
order by pais;


SELECT DOS.PAIS, DOS.MUNICIPIO, DOS.PARTIDO FROM(
SELECT UNO.PAIS AS PAIS, UNO.MUNICIPIO AS MUNICIPIO, UNO.PARTIDO AS PARTIDO, ROW_NUMBER() OVER (PARTITION BY UNO.PAIS,UNO.MUNICIPIO ORDER BY UNO.VOTOS desc) AS VOTOS_RANK, UNO.VOTOS
FROM (
SELECT PA.NOMBRE_PAIS AS PAIS, MU.NOMBRE_MUNICIPIO AS MUNICIPIO, PAR.NOMBRE_PARTIDO AS PARTIDO, SUM(E.ANALFAVETOS + E.ALFAVETOS) AS VOTOS 
FROM ELECCION E, MUNICIPIO MU, DEPARTAMENTO DE, REGION RE, PAIS PA, PARTIDO PAR
WHERE E.MUNICIPIO_ID_MUNICIPIO = MU.ID_MUNICIPIO
AND MU.DEPARTAMENTO_ID_DEPARTAMENTO = DE.ID_DEPARTAMENTO
AND DE.REGION_ID_REGION = RE.ID_REGION
AND RE.PAIS_ID_PAIS = PA.ID_PAIS
AND E.PARTIDO_ID_PARTIDO = PAR.ID_PARTIDO 
group by PA.NOMBRE_PAIS, MU.NOMBRE_MUNICIPIO, PAR.NOMBRE_PARTIDO
) UNO
ORDER BY UNO.PAIS, UNO.MUNICIPIO, VOTOS_RANK
) DOS
WHERE DOS.VOTOS_RANK <= 2
ORDER BY DOS.PAIS, DOS.MUNICIPIO, DOS.VOTOS_RANK;
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
(select sum(cv.analfabetos+cv.alfabetos) as total from conteovotos cv 
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
)x
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
SELECT UPPER(SUBSTR(m.nombre,1,1)) as INICIAL, SUM(cv.alfabetos+cv.analfabetos) as total FROM conteovotos cv
INNER JOIN municipio m ON cv.id_municipio = m.id_municipio
INNER JOIN departamento d ON m.id_departamento = d.id_departamento
INNER JOIN region r ON d.id_region = r.id_region
INNER JOIN pais p ON r.id_pais = p.id_pais
group by SUBSTR(m.nombre,1,1)
order by UPPER(SUBSTR(m.nombre,1,1));