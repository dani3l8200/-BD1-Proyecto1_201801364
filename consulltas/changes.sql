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