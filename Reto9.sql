select * from reto_9.stage


--Identificar datos duplicados

select distinct ("Codigo Pais") from reto_9.stage

--Forzando el dato duplicado para validar si esta bien o no al consulta
INSERT INTO reto_9.stage (
  "Pais", "Codigo Pais", "Año", "Meningitis", "Enfermedad de Alzheimer y otras demencias", "Enfermedad de Parkinson", "Deficiencias nutricionales", "Malaria", "Ahogo/Asfixia", "Violencia interpersonal", "Trastornos maternos", "HIV/SIDA", "Trastornos por consumo de drogas", "Tuberculosis", "Enfermedades cardiovasculares", "Infecciones respiratorias bajas", "Trastornos neonatales", "Trastornos por consumo de alcohol", "Autolesiones", "Exposición a las fuerzas de la naturaleza", "Enfermedades diarreicas", "Exposición al calor y al frío ambiental", "Neoplasias", "Conflicto y terrorismo", "Diabetes mellitus", "Enfermedad renal cronica", "Envenenamientos", "Desnutrición proteico-energética", "Lesiones en la carretera", "Enfermedades respiratorias cronicas", "Cirrosis y otras enfermedades crónicas del hígado", "Enfermedades digestivas", "Fuego, calor y sustancias calientes", "Hepatitis aguda"
) 
VALUES (
  'Afghanistan', 'AFG', '1990', '2159', '1116', '371', '2087', '93', '1370', '1538', '2655', '34', '93', '4661', '44899', '23741', '15612', '72', '696', '0', '4235', '175', '11580', '1490', '2108', '3709', '338', '2054', '4154', '5945', '2673', '5005', '323', '2985'
);










-- De una manera mas funcional 

WITH CTE AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY "Pais", "Codigo Pais", "Año" ORDER BY "Pais", "Codigo Pais", "Año") AS RowNum
  FROM reto_9.stage
)

SELECT *
FROM CTE
WHERE RowNum = 2






--- eliminar duplicados solo un de los duplicados

WITH Duplicates AS (
  SELECT "Pais", "Codigo Pais", "Año"
  FROM reto_9.stage
  GROUP BY "Pais", "Codigo Pais", "Año"
  HAVING COUNT(*) > 1
)

DELETE FROM reto_9.stage
WHERE ("Pais", "Codigo Pais", "Año") IN (
  SELECT "Pais", "Codigo Pais", "Año"
  FROM Duplicates
)
AND ctid NOT IN (
  SELECT MIN(ctid)
  FROM reto_9.stage
  WHERE ("Pais", "Codigo Pais", "Año") IN (SELECT "Pais", "Codigo Pais", "Año" FROM Duplicates)
  GROUP BY "Pais", "Codigo Pais", "Año"
);


--encontrando nulos en todas la columnas 

SELECT *
FROM reto_9.stage
WHERE
  "Pais" IS NULL OR
  "Codigo Pais" IS NULL OR
  "Año" IS NULL OR
  "Meningitis" IS NULL OR
  "Enfermedad de Alzheimer y otras demencias" IS NULL OR
  "Enfermedad de Parkinson" IS NULL OR
  "Deficiencias nutricionales" IS NULL OR
  "Malaria" IS NULL OR
  "Ahogo/Asfixia" IS NULL OR
  "Violencia interpersonal" IS NULL OR
  "Trastornos maternos" IS NULL OR
  "HIV/SIDA" IS NULL OR
  "Trastornos por consumo de drogas" IS NULL OR
  "Tuberculosis" IS NULL OR
  "Enfermedades cardiovasculares" IS NULL OR
  "Infecciones respiratorias bajas" IS NULL OR
  "Trastornos neonatales" IS NULL OR
  "Trastornos por consumo de alcohol" IS NULL OR
  "Autolesiones" IS NULL OR
  "Exposición a las fuerzas de la naturaleza" IS NULL OR
  "Enfermedades diarreicas" IS NULL OR
  "Exposición al calor y al frío ambiental" IS NULL OR
  "Neoplasias" IS NULL OR
  "Conflicto y terrorismo" IS NULL OR
  "Diabetes mellitus" IS NULL OR
  "Enfermedad renal cronica" IS NULL OR
  "Envenenamientos" IS NULL OR
  "Desnutrición proteico-energética" IS NULL OR
  "Lesiones en la carretera" IS NULL OR
  "Enfermedades respiratorias cronicas" IS NULL OR
  "Cirrosis y otras enfermedades crónicas del hígado" IS NULL OR
  "Enfermedades digestivas" IS NULL OR
  "Fuego, calor y sustancias calientes" IS NULL OR
  "Hepatitis aguda" IS NULL;



--Identificar como estandarizar al columna pais y codigo pais con los nulos
SELECT distinct("Pais"),"Codigo Pais"
FROM reto_9.stage
WHERE
  "Pais" IS NULL OR
  "Codigo Pais" IS NULL 
order by ("Pais") desc


SELECT *
FROM reto_9.stage



--Realizando un unpivot pero en postgresql
SELECT "Pais", "Codigo Pais", "Año", unnest(array[
    'Meningitis', 'Enfermedad de Alzheimer y otras demencias', 'Enfermedad de Parkinson','Deficiencias nutricionales', 'Malaria', 'Ahogo/Asfixia', 'Violencia interpersonal', 'Trastornos maternos', 'HIV/SIDA', 'Trastornos por consumo de drogas', 'Tuberculosis',
    'Enfermedades cardiovasculares', 'Infecciones respiratorias bajas', 'Trastornos neonatales',
    'Trastornos por consumo de alcohol', 'Autolesiones', 'Exposición a las fuerzas de la naturaleza',
    'Enfermedades diarreicas', 'Exposición al calor y al frío ambiental', 'Neoplasias',
    'Conflicto y terrorismo', 'Diabetes mellitus', 'Enfermedad renal cronica', 'Envenenamientos',
    'Desnutrición proteico-energética', 'Lesiones en la carretera', 'Enfermedades respiratorias cronicas',
    'Cirrosis y otras enfermedades crónicas del hígado', 'Enfermedades digestivas',
    'Fuego, calor y sustancias calientes', 'Hepatitis aguda'
]) AS "Enfermedad", 
unnest(array[
    "Meningitis", "Enfermedad de Alzheimer y otras demencias", "Enfermedad de Parkinson", "Deficiencias nutricionales", "Malaria", "Ahogo/Asfixia", "Violencia interpersonal", "Trastornos maternos", "HIV/SIDA", "Trastornos por consumo de drogas", "Tuberculosis",
    "Enfermedades cardiovasculares", "Infecciones respiratorias bajas", "Trastornos neonatales",
    "Trastornos por consumo de alcohol", "Autolesiones", "Exposición a las fuerzas de la naturaleza",
    "Enfermedades diarreicas", "Exposición al calor y al frío ambiental", "Neoplasias",
    "Conflicto y terrorismo", "Diabetes mellitus", "Enfermedad renal cronica", "Envenenamientos",
    "Desnutrición proteico-energética", "Lesiones en la carretera", "Enfermedades respiratorias cronicas",
    "Cirrosis y otras enfermedades crónicas del hígado", "Enfermedades digestivas",
    "Fuego, calor y sustancias calientes", "Hepatitis aguda"
]) AS "Valor"
FROM reto_9.stage;


--tabla temporal con modelo tabular
-- Crear una tabla temporal a partir de la consulta
CREATE TEMP TABLE tabla_temporal_limpia AS
SELECT "Pais", "Codigo Pais", "Año", unnest(array[
    'Meningitis', 'Enfermedad de Alzheimer y otras demencias', 'Enfermedad de Parkinson',
    'Deficiencias nutricionales', 'Malaria', 'Ahogo/Asfixia', 'Violencia interpersonal',
    'Trastornos maternos', 'HIV/SIDA', 'Trastornos por consumo de drogas', 'Tuberculosis',
    'Enfermedades cardiovasculares', 'Infecciones respiratorias bajas', 'Trastornos neonatales',
    'Trastornos por consumo de alcohol', 'Autolesiones', 'Exposición a las fuerzas de la naturaleza',
    'Enfermedades diarreicas', 'Exposición al calor y al frío ambiental', 'Neoplasias',
    'Conflicto y terrorismo', 'Diabetes mellitus', 'Enfermedad renal cronica', 'Envenenamientos',
    'Desnutrición proteico-energética', 'Lesiones en la carretera', 'Enfermedades respiratorias cronicas',
    'Cirrosis y otras enfermedades crónicas del hígado', 'Enfermedades digestivas',
    'Fuego, calor y sustancias calientes', 'Hepatitis aguda'
]) AS "Enfermedad", 
unnest(array[
    "Meningitis", "Enfermedad de Alzheimer y otras demencias", "Enfermedad de Parkinson",
    "Deficiencias nutricionales", "Malaria", "Ahogo/Asfixia", "Violencia interpersonal",
    "Trastornos maternos", "HIV/SIDA", "Trastornos por consumo de drogas", "Tuberculosis",
    "Enfermedades cardiovasculares", "Infecciones respiratorias bajas", "Trastornos neonatales",
    "Trastornos por consumo de alcohol", "Autolesiones", "Exposición a las fuerzas de la naturaleza",
    "Enfermedades diarreicas", "Exposición al calor y al frío ambiental", "Neoplasias",
    "Conflicto y terrorismo", "Diabetes mellitus", "Enfermedad renal cronica", "Envenenamientos",
    "Desnutrición proteico-energética", "Lesiones en la carretera", "Enfermedades respiratorias cronicas",
    "Cirrosis y otras enfermedades crónicas del hígado", "Enfermedades digestivas",
    "Fuego, calor y sustancias calientes", "Hepatitis aguda"
]) AS "Valor"
FROM reto_9.stage;


--sumando los datos de United Kingdom
select sum("Valor"::integer) from tabla_temporal
where "Pais"='United Kingdom'

--sumando los paises

select sum("Valor"::integer) from tabla_temporal
where "Pais" in ('England','Scotland','Wales','Northern Ireland')  



--eliminados todos los null

delete from reto_9.stage
where  "Codigo Pais"
 is null
drop table tabla_temporal
-- Crear una tabla temporal a partir de la consulta pero ya sin nuloes 

CREATE TEMP TABLE tabla_temporal_limpia AS
SELECT "Pais", "Codigo Pais", "Año", unnest(array[
    'Meningitis', 'Enfermedad de Alzheimer y otras demencias', 'Enfermedad de Parkinson',
    'Deficiencias nutricionales', 'Malaria', 'Ahogo/Asfixia', 'Violencia interpersonal',
    'Trastornos maternos', 'HIV/SIDA', 'Trastornos por consumo de drogas', 'Tuberculosis',
    'Enfermedades cardiovasculares', 'Infecciones respiratorias bajas', 'Trastornos neonatales',
    'Trastornos por consumo de alcohol', 'Autolesiones', 'Exposición a las fuerzas de la naturaleza',
    'Enfermedades diarreicas', 'Exposición al calor y al frío ambiental', 'Neoplasias',
    'Conflicto y terrorismo', 'Diabetes mellitus', 'Enfermedad renal cronica', 'Envenenamientos',
    'Desnutrición proteico-energética', 'Lesiones en la carretera', 'Enfermedades respiratorias cronicas',
    'Cirrosis y otras enfermedades crónicas del hígado', 'Enfermedades digestivas',
    'Fuego, calor y sustancias calientes', 'Hepatitis aguda'
]) AS "Enfermedad", 
unnest(array[
    "Meningitis", "Enfermedad de Alzheimer y otras demencias", "Enfermedad de Parkinson",
    "Deficiencias nutricionales", "Malaria", "Ahogo/Asfixia", "Violencia interpersonal",
    "Trastornos maternos", "HIV/SIDA", "Trastornos por consumo de drogas", "Tuberculosis",
    "Enfermedades cardiovasculares", "Infecciones respiratorias bajas", "Trastornos neonatales",
    "Trastornos por consumo de alcohol", "Autolesiones", "Exposición a las fuerzas de la naturaleza",
    "Enfermedades diarreicas", "Exposición al calor y al frío ambiental", "Neoplasias",
    "Conflicto y terrorismo", "Diabetes mellitus", "Enfermedad renal cronica", "Envenenamientos",
    "Desnutrición proteico-energética", "Lesiones en la carretera", "Enfermedades respiratorias cronicas",
    "Cirrosis y otras enfermedades crónicas del hígado", "Enfermedades digestivas",
    "Fuego, calor y sustancias calientes", "Hepatitis aguda"
]) AS "Valor"
FROM reto_9.stage;

--Creando consulta 
select distinct("Pais"),"Codigo Pais" from tabla_temporal_limpia

--creamos la tabla de Dim_Pais

create table Dim_Pais
(
	Id_pais serial primary key,
	Pais varchar(255),
	Codigo_pais char(10)
)

--creando insert
insert into Dim_Pais(Pais,Codigo_pais)
select distinct("Pais"),"Codigo Pais" from tabla_temporal_limpia

select * from Dim_Pais


--Creando consulta año
select distinct("Año") from tabla_temporal_limpia

--Creando la tabla 
Create table Dim_Anio
(
Id_anio serial primary key,
Anio int
)

--creando el insertar datos
insert into Dim_Anio (Anio)
select distinct("Año"::integer) from tabla_temporal_limpia

--Verficar tabla
select * from Dim_Anio

--consulta para la dimension enfermedades

select distinct("Enfermedad") from tabla_temporal_limpia

--creando tabla Dim_Enfermedad
create table Dim_enfermedad
(
	Id_Enfermedad serial primary key,
	Enfermedad varchar(255)
)
--creando el insert

insert into Dim_enfermedad (Enfermedad)
select distinct("Enfermedad") from tabla_temporal_limpia

select * from Dim_enfermedad


--pasamo a crear la consulta para la tablad de hechos llamada indicadores salud

select * from tabla_temporal_limpia


select a."Valor"::integer,b.Id_pais,c.Id_Anio,d.id_enfermedad
from tabla_temporal_limpia as a
left join Dim_Pais as b
on a."Pais"=b.Pais
left join Dim_Anio as c
on a."Año"::int=c.Anio
left join Dim_Enfermedad as d
on a."Enfermedad" = d.Enfermedad


--Creamos la tabla Fact_Indicadores_Salud
create table Fact_Indicadores_Salud
(
Valor int,
	Id_pais int,
	Id_Anio int,
	id_enfermedad int,
	FOREIGN KEY (Id_pais) REFERENCES Dim_Pais (Id_pais),
	FOREIGN KEY (Id_Anio) REFERENCES Dim_Anio (Id_Anio),
	FOREIGN KEY (id_enfermedad) REFERENCES Dim_enfermedad (id_enfermedad)
)



insert into  Fact_Indicadores_Salud (Valor ,Id_pais ,Id_Anio,id_enfermedad)
select a."Valor"::integer,b.Id_pais,c.Id_Anio,d.id_enfermedad
from tabla_temporal_limpia as a
left join Dim_Pais as b
on a."Pais"=b.Pais
left join Dim_Anio as c
on a."Año"::int=c.Anio
left join Dim_Enfermedad as d
on a."Enfermedad" = d.Enfermedad

select * from Fact_Indicadores_Salud




