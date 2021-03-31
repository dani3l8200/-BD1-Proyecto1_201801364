@echo off
echo ------------ JUAN DANIEL ENRIQUE ROMAN BARRIENTOS - 201801364 -----------------
pause
sqlplus -s -l hr/hr@xepdb1 @"C:\BD1\proyecto1\ddl\drops.sql" >> "C:\BD1\proyecto1\ddl\drops.txt"
echo --------------- TABLAS ELIMINADAS ----------------------
pause
sqlplus -s -l hr/hr@xepdb1 @"C:\BD1\proyecto1\ddl\ddl.sql" >> "C:\BD1\proyecto1\ddl\ddl.txt"
echo --------------- TABLAS CREADAS -------------------------
pause
cd C:\BD1\proyecto1\load_data\
sqlldr userid=hr/hr@xepdb1 control="C:\BD1\proyecto1\load_data\carga.ctl"
echo --------------- CARGA DE DATOS TERMINADA -------------------------
pause 
sqlplus -s -l hr/hr@xepdb1 @"C:\BD1\proyecto1\dml\dml.sql" >> "C:\BD1\proyecto1\dml\dml.txt"
echo --------------- TRASPASO DE DATOS TERMINADA --------------------
pause
sqlplus -s -l hr/hr@xepdb1 @"C:\BD1\proyecto1\consulltas\consultas.sql" >> "C:\BD1\proyecto1\consulltas\consultas.txt"
echo --------------- CONSULTAS FINALIZADAS --------------------
pause
echo --------------- SALE EN VACAS ----------------------------
pause
exit