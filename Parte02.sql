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