--05.01
--Forma 01
--El total de contratos
select count(codcliente) from Contrato
--El total de contratos pertenecientes a clientes empresa
select count(co.codcliente) from Contrato co
inner join Cliente c on co.codcliente=c.codcliente
where c.tipo='E'
--El total de contratos pertenecientes a clientes persona
select count(co.codcliente) from Contrato co
inner join Cliente c on co.codcliente=c.codcliente
where c.tipo='P'

--Forma 02
/*Consulta padre*/
select count(codcliente) as TOT_C,
	   (
		select count(co.codcliente)  /*Consulta hija*/
	    from Contrato co
	    inner join Cliente c on co.codcliente=c.codcliente
	    where c.tipo='E'
	   ) as TOT_C_E,
	   (
	    select count(co.codcliente)  /*Consulta hija*/
		from Contrato co
		inner join Cliente c on co.codcliente=c.codcliente
		where c.tipo='P'
	   ) as TOT_C_P,
	   (
	    select count(co.codcliente)  /*Consulta hija*/
		from Contrato co
		left join Cliente c on co.codcliente=c.codcliente
		where c.codcliente is null
	   ) as TOT_C_O
from   Contrato 

--FORMA 03

declare @TOT_C int=(select count(codcliente) from Contrato),

		@TOT_C_E int=(select count(co.codcliente) from Contrato co
					  inner join Cliente c on co.codcliente=c.codcliente
					  where c.tipo='E'),

		@TOT_C_P int= (select count(co.codcliente) from Contrato co
					  inner join Cliente c on co.codcliente=c.codcliente
					  where c.tipo='P')

select @TOT_C,@TOT_C_E,@TOT_C_P,@TOT_C-@TOT_C_E-@TOT_C_P

--05.03
select count(codcliente) from Contrato where codplan=1
select count(codcliente) from Contrato where codplan=2
select count(codcliente) from Contrato where codplan=3

select codplan,replace(upper(nombre),' ','_') as [PLAN],
	   (select count(codcliente) from Contrato co where co.codplan=p.codplan) as TOTAL,
	   case 
	   when (select count(codcliente) from Contrato co where co.codplan=p.codplan) between 0 and 99 then 'Plan de baja demanda.'
	   when (select count(codcliente) from Contrato co where co.codplan=p.codplan) between 100 and 199 then 'Plan de mediana demanda.'
	   when (select count(codcliente) from Contrato co where co.codplan=p.codplan)>=200 then 'Plan de alta demanda.'
	   else 'SIN DATO'
	   end as MENSAJE
from PlanInternet p
order by TOTAL asc

--begin tran
--	update p
--	set nombre=replace(upper(nombre),' ','_')
--	from PlanInternet p
--rollback

--05.05

select 5*1.00/2

select replace(upper(nombre),' ','_') as [PLAN],
	   (select count(codcliente) from Contrato co where co.codplan=p.codplan) as [TOTAL-P],
	   (select count(codcliente) from Contrato co) as [TOTAL],
	   cast(
		   round(
			   (select count(codcliente) from Contrato co where co.codplan=p.codplan)*100.00/
			   (select count(codcliente) from Contrato co),--Expresion
			   2                                           --Redondeo al centesimo
		   ) as decimal(6,2)                               --Transformar a decimal(6,2)
	   ) as PORCENTAJE
from PlanInternet p
order by [TOTAL-P] asc

--05.07
--m01 (Subconsultas SELECT)

select replace(upper(nombre),' ','_') as [PLAN],
	   isnull((select count(codcliente) from Contrato co where co.codplan=p.codplan),0) as [CO-TOTAL],
	   isnull((select avg(co.preciosol) from Contrato co where co.codplan=p.codplan),0.00) as [CO-PROM],
	   isnull((select min(co.fec_contrato) from Contrato co where co.codplan=p.codplan),'9999-12-31') as [CO-ANTIGUO],
	   isnull((select max(co.fec_contrato) from Contrato co where co.codplan=p.codplan),'9999-12-31') as [CO-RECIENTE]
from PlanInternet p
order by [CO-TOTAL] asc

--m02 (Subconsultas FROM)

select codplan,count(codcliente) as total,avg(co.preciosol) as prom,
       min(co.fec_contrato) as antiguo, max(co.fec_contrato) as reciente
from Contrato co
group by codplan

--Consulta padre
select replace(upper(nombre),' ','_') as [PLAN],
	   isnull(rp.total,0) as [CO-TOTAL],
	   isnull(rp.prom,0.00) as [CO-PROM],
	   isnull(rp.antiguo,'9999-12-31') as [CO-ANTIGUO],
	   isnull(rp.reciente,'9999-12-31') as [CO-RECIENTE]
from PlanInternet p left join
(   --Tabla derivada (Consulta Hija)
	select codplan,count(codcliente) as total,avg(co.preciosol) as prom,
           min(co.fec_contrato) as antiguo, max(co.fec_contrato) as reciente
	from   Contrato co
	group by codplan
) rp on p.codplan=rp.codplan 
order by [CO-TOTAL] asc

--m03 (ctes)

with CTE_RP as 
(   --Consulta interna
	select codplan,count(codcliente) as total,avg(co.preciosol) as prom,
           min(co.fec_contrato) as antiguo, max(co.fec_contrato) as reciente
	from   Contrato co
	group by codplan
), 
CTE_RZ as 
(   --Consulta interna
	 select codubigeo,count(codzona) as total 
	 from Zona
	 group by codubigeo
)   --Consulta externa
select replace(upper(nombre),' ','_') as [PLAN],
	   isnull(rp.total,0) as [CO-TOTAL],
	   isnull(rp.prom,0.00) as [CO-PROM],
	   isnull(rp.antiguo,'9999-12-31') as [CO-ANTIGUO],
	   isnull(rp.reciente,'9999-12-31') as [CO-RECIENTE],
	   (select count(1) from CTE_RZ) as TOTAL
from PlanInternet p left join
CTE_RP rp on p.codplan=rp.codplan 
order by [CO-TOTAL] asc

--05.09

select c.codcliente as [COD-CLIENTE], 
       upper(rtrim(ltrim(nombres+' '+ape_paterno+' '+ape_materno))) as CLIENTE,
	   isnull(rt.total,0)  as [TOT-TE],
	   isnull(rco.total,0) as [TOT-CO]
from Cliente c
left join
(
	select codcliente,count(numero) as total 
	from Telefono 
	where estado=1
	group by codcliente
) rt on c.codcliente=rt.codcliente
left join
(
	select codcliente,count(codplan) as total 
	from Contrato 
	where estado=1
	group by codcliente
) rco on c.codcliente=rco.codcliente
where tipo='P'
order by [TOT-TE] asc,[TOT-CO] asc