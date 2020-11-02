
/*
select 5+10    --Suma
select '5'+10  --Suma
select '5'+'10'--Concatenación
select 'DEV'+' '+'MASTER'--Concatenación
select  10-5   --Resta
select  10*5   --Multiplica
select  9/5    --División
select  9%5    --Residuo
select  power(10,5) --Potencia
select  sqrt(100)   --Raíz cuadrada
*/

--02.01

declare @n1 int=5,
        @n2 int=7

select power(@n1,2)+10*@n1*@n2+power(@n2,2)

/*Lógica procesamiento
select codubigeo,
       count(codzona) as total --PASO_05
from   Zona
where  estado=1
--where  total=100  --PASO_02
group by codubigeo
having count(codzona)>=4
--having total>=4  --PASO_04
order by total asc --PASO_06
*/

--02.03

--a.Los diferentes departamentos a nivel de ubige0
select distinct nom_dpto from Ubigeo

--b.Los diferentes códigos de ubigeo a nivel de zona.
select distinct codubigeo from Zona

--c.Las diferentes combinaciones de departamento+provincia a nivel de ubigeo
select distinct nom_dpto,nom_prov from Ubigeo
select distinct nom_dpto,nom_prov,nom_dto from Ubigeo

/*Alias tabla y columna
select codubigeo,
       count(codzona) as total,     --forma 01
	   total2=count(codzona)+1,     --forma 02
	   count(codzona)+2 total3,     --forma 03
	   count(codzona)+3 as [total-4]--forma 04
from   Zona -- Zona z | Zona as Z
where  estado=1
group by codubigeo
having count(codzona)>=4
order by total asc
*/

--02.04
select nombre as ZONA,codubigeo as [CODIGO UBIGEO],estado as ESTADO,
       case when estado=1 then 'Zona activa'
	   else 'Zona inactiva'
	   end as [MENSAJE ESTADO] 
from Zona

/*CASE WHEN sobre WHERE
select *, 
		case when nom_dto='HUACHO' then 1
		     when nom_dto='AMBAR'  then 2
		end as codubigeo
from Ubigeo
where codubigeo=case when nom_dto='HUACHO' then 1
					 when nom_dto='AMBAR'  then 2
			     end 

select 'D''Alessando',''
*/

--02.06
declare @tcambio decimal(6,3)=3.613

select precioref as PRECIO_SOL, 
       nombre as [PLAN], 
       cast(round(precioref/@tcambio,2) as decimal(6,2)) as PRECIO_DOL,
	   --cast('SQL' as decimal(6,2)) NO ES FACTIBLE
	   case when precioref>=0 and precioref<70 then '[0,70>'   
			when precioref>=70 and precioref<100 then '[70,100>'
			when precioref>=100 then '[100, +>'
	   else 'SIN DATO'
	   end as RANGO_SOL
from PlanInternet
order by nombre desc
--order by [PLAN] asc
--order by 1

select * from Zona
order by codzona desc

--02.08

select codzona as CODZONA,nombre as ZONA,codubigeo as [CODIGO UBIGEO],estado as ESTADO,
       case when estado=1 then 'Zona activa'
	   else 'Zona inactiva'
	   end as [MENSAJE ESTADO] 
from Zona
--a.Estado=1 [Y] codubigeo=1 ordenados por codzona de mayor a menor.
--where estado=1 and codubigeo=1
--order by codzona desc 
--b.Estado=1 [Y] codubigeo=1 ordenados por nombre alfabéticamente Z-A
--where estado=1 and codubigeo=1
--order by nombre desc 
--c.Estado=0 [O] codubigeo=1 ordenados por estado de menor a mayor.
--where estado=0 or codubigeo=1 
--order by estado asc
--d.Estado=1 [O] codubigeo=1 ordenados por 
--codubigeo de mayor a menor en 1° nivel y nombre de manera alfabética A-Z en 2° nivel.
--where estado=1 or codubigeo=1 
--order by codubigeo desc,nombre asc
--e.Las zonas que NO cumplan: Estado=1 [Y] codubigeo=1 ordenados por codzona de menor a mayor.
where NOT(estado=1 or codubigeo=1)-- NOT estado=1 AND NOT codubigeo=1
order by codzona asc