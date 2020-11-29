--06.05

--Tablas derivadas
select c.codcliente as CODCLIENTE,CONCAT(nombres,' ',ape_paterno,' ',ape_materno) as CLIENTE,
codzona as ZONA, isnull(rt.total,0) as N_TEL, 
row_number() over(partition by c.codzona order by rt.total asc) as R1,
rank()       over(partition by c.codzona order by rt.total asc) as R2,
dense_rank() over(partition by c.codzona order by rt.total asc) as R3,
ntile(4)     over(partition by c.codzona order by rt.total asc) as R4
from Cliente c 
left join
(
	select codcliente,count(numero) as total
	from Telefono
	group by codcliente
) rt on c.codcliente=rt.codcliente
where c.tipo='P'
order by ZONA asc,N_TEL asc

--Ctes
with cte_rt as 
(
	select codcliente,count(numero) as total
	from Telefono
	group by codcliente
)
select c.codcliente as CODCLIENTE,CONCAT(nombres,' ',ape_paterno,' ',ape_materno) as CLIENTE,
codzona as ZONA, isnull(rt.total,0) as N_TEL, 
row_number() over(partition by c.codzona order by rt.total asc) as R1,
rank()       over(partition by c.codzona order by rt.total asc) as R2,
dense_rank() over(partition by c.codzona order by rt.total asc) as R3,
ntile(4)     over(partition by c.codzona order by rt.total asc) as R4
from Cliente c 
left join cte_rt rt on c.codcliente=rt.codcliente
where c.tipo='P'
order by ZONA asc,N_TEL asc

--06.07

--Tablas derivadas
select c.codcliente as #,c.razon_social as CLIENTE,c.codzona as ZONA,
isnull(rc.total,0) as TOTAL,
row_number() over(partition by codzona order by isnull(rc.total,0) asc) E1,
lag(razon_social,1,'SIN DATO') over(partition by codzona order by isnull(rc.total,0) asc) E2,
lead(razon_social,1,'SIN DATO') over(partition by codzona order by isnull(rc.total,0) asc) E3,
isNull(first_value(razon_social)over(partition by codzona order by isnull(rc.total,0) asc),'SIN DATO')  E4,
isNull(last_value(razon_social)over(partition by codzona order by isnull(rc.total,0) asc),'SIN DATO')  E5
from Cliente c
left join
(
	select codcliente,count(codplan) as total
	from Contrato
	group by codcliente
) rc on c.codcliente=rc.codcliente
where c.tipo='E'

--Ctes
with cte_rc as
(
	select codcliente,count(codplan) as total
	from Contrato
	group by codcliente
)
select c.codcliente as #,c.razon_social as CLIENTE,c.codzona as ZONA,
isnull(rc.total,0) as TOTAL,
row_number() over(partition by codzona order by isnull(rc.total,0) asc) E1,
lag(razon_social,1,'SIN DATO') over(partition by codzona order by isnull(rc.total,0) asc) E2,
lead(razon_social,1,'SIN DATO') over(partition by codzona order by isnull(rc.total,0) asc) E3,
isNull(first_value(razon_social)over(partition by codzona order by isnull(rc.total,0) asc),'SIN DATO')  E4,
isNull(last_value(razon_social)over(partition by codzona order by isnull(rc.total,0) asc),'SIN DATO')  E5
from Cliente c
left join cte_rc rc on c.codcliente=rc.codcliente
where c.tipo='E'
order by ZONA asc, TOTAL asc

--Función valor tabla
create function UF_Resumen_Cliente_Empresa() returns table
as return
	with cte_rc as
	(
		select codcliente,count(codplan) as total
		from Contrato
		group by codcliente
	)
	select c.codcliente as #,c.razon_social as CLIENTE,c.codzona as ZONA,
	isnull(rc.total,0) as TOTAL,
	row_number() over(partition by codzona order by isnull(rc.total,0) asc) E1,
	lag(razon_social,1,'SIN DATO') over(partition by codzona order by isnull(rc.total,0) asc) E2,
	lead(razon_social,1,'SIN DATO') over(partition by codzona order by isnull(rc.total,0) asc) E3,
	isNull(first_value(razon_social)over(partition by codzona order by isnull(rc.total,0) asc),'SIN DATO')  E4,
	isNull(last_value(razon_social)over(partition by codzona order by isnull(rc.total,0) asc),'SIN DATO')  E5
	from Cliente c
	left join cte_rc rc on c.codcliente=rc.codcliente
	where c.tipo='E'

select * from UF_Resumen_Cliente_Empresa()
order by ZONA asc, TOTAL asc

/*UNION y UNION ALL*/

select 'A','B','C'
union all
select 'A','B','C'
union all
select 'A','B','D'

select 'A','B','C'
union all
select '20','B',convert(varchar(8),getdate(),112)
union all
select 'A','B',null

select 'A','B','C'
union
select 'A','B','C'
union
select 'A','B','D'

select 'A','B'
union
select 'A','B'
union 
select 'A','B'

--06.09
--a.
create view dbo.V_Ubigeo 
as
	with CTE_Ubigeos as
	(
	select cod_dpto,cod_prov,cod_dto from DEVWIFI15Ed.dbo.Ubigeo
	union all
	select cod_dpto,cod_prov,cod_dto from DevWifi2019.comercial.Ubigeo --DATABASE.SCHEMA.TABLE
	)
	select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO
	from CTE_Ubigeos

select * from dbo.V_Ubigeo 
order by CODIGO_DPTO,CODIGO_PROV,CODIGO_DTO

--b.
create function UF_Ubigeos() returns table as
return
	with CTE_Ubigeos as
	(
	select cod_dpto,cod_prov,cod_dto from DEVWIFI15Ed.dbo.Ubigeo
	union
	select cod_dpto,cod_prov,cod_dto from DevWifi2019.comercial.Ubigeo --DATABASE.SCHEMA.TABLE
	)
	select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO
	from CTE_Ubigeos

select * from UF_Ubigeos() 
order by CODIGO_DPTO,CODIGO_PROV,CODIGO_DTO

--06.11
select tipo,numero,codcliente,estado from DEVWIFI15Ed.dbo.Telefono 
where tipo='WSP' and numero='963065267' and codcliente=3 and estado=1

select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
where tipo='WSP' and numero='963065267' and codcliente=3 and estado=1

--a
with CTE_Telefono as
(
select tipo,numero,codcliente,estado from DEVWIFI15Ed.dbo.Telefono      
intersect
select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono 
)
select ct.tipo as TIPO,numero as NUMERO,ct.codcliente as CODIGO,ct.estado as ESTADO,
coalesce(c.razon_social,c.nombres+' '+c.ape_paterno+' '+c.ape_materno,'SIN DATO') as CLIENTE,
row_number() over(partition by ct.codcliente order by ct.numero asc) as POSICION
from CTE_Telefono ct
left join Cliente c on ct.codcliente=c.codcliente

--b
--SI (DBO) - NO (COMERCIAL)
--select tipo,numero,codcliente,estado from DEVWIFI15Ed.dbo.Telefono      
--except
--select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono 

select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono  
where tipo='SMS' and numero='900670335' and codcliente=1 and estado=1
select tipo,numero,codcliente,estado from DEVWIFI15Ed.dbo.Telefono 
where tipo='SMS' and numero='900670335' and codcliente=1 and estado=1

with CTE_Telefono as
(--NO (DBO) - SI (COMERCIAL)
select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono    
except
select tipo,numero,codcliente,estado from DEVWIFI15Ed.dbo.Telefono   
)
select ct.tipo as TIPO,numero as NUMERO,ct.codcliente as CODIGO,ct.estado as ESTADO,
coalesce(c.razon_social,c.nombres+' '+c.ape_paterno+' '+c.ape_materno,'SIN DATO') as CLIENTE,
row_number() over(partition by ct.codcliente order by ct.numero asc) as POSICION
from CTE_Telefono ct
left join Cliente c on ct.codcliente=c.codcliente