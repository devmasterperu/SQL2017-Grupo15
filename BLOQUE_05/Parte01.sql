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
--Tablas derivadas
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

--CTEs
with cte_rt as
(
	select codcliente,count(numero) as total 
	from Telefono 
	where estado=1
	group by codcliente
),  cte_rco as
(
	select codcliente,count(codplan) as total 
	from Contrato 
	where estado=1
	group by codcliente
)
select c.codcliente as [COD-CLIENTE], 
       upper(rtrim(ltrim(nombres+' '+ape_paterno+' '+ape_materno))) as CLIENTE,
	   isnull(rt.total,0)  as [TOT-TE],
	   isnull(rco.total,0) as [TOT-CO]
from Cliente c
left join cte_rt  as rt  on c.codcliente=rt.codcliente
left join cte_rco as rco on c.codcliente=rco.codcliente
where tipo='P'
order by [TOT-TE] asc,[TOT-CO] asc
go
select * from INFORMATION_SCHEMA.TABLES --Vista stma

--Vistas
--create view vClientes as --Crear vista
alter  view vClientes as --Modificar vista
with cte_rt as
(
	select codcliente,count(numero) as total 
	from Telefono 
	where estado=1
	group by codcliente
),  cte_rco as
(
	select codcliente,count(codplan) as total 
	from Contrato 
	where estado=1
	group by codcliente
)
select c.codcliente as [COD-CLIENTE], 
       upper(rtrim(ltrim(nombres+' '+ape_paterno+' '+ape_materno))) as CLIENTE,
	   isnull(rt.total,0)  as [TOT-TE],
	   isnull(rco.total,0) as [TOT-CO],
	   getdate() as FECHORA
from Cliente c
left join cte_rt  as rt  on c.codcliente=rt.codcliente
left join cte_rco as rco on c.codcliente=rco.codcliente
where tipo='P'
--order by [TOT-TE] asc,[TOT-CO] asc

drop view vClientes  --Eliminar vista

select * from vClientes
order by [TOT-TE] asc,[TOT-CO] asc

--Funciones valor tabla
create function uf_cliente(@codcliente int,@estado bit) returns table --Crear función
--alter  function uf_cliente(@codcliente int,@estado bit) returns table --Modificar función
as return
	with cte_rt as
	(
		select codcliente,count(numero) as total 
		from Telefono 
		where estado=1
		group by codcliente
	),  cte_rco as
	(
		select codcliente,count(codplan) as total 
		from Contrato 
		where estado=1
		group by codcliente
	)
	select c.codcliente as [COD-CLIENTE], 
		   upper(rtrim(ltrim(nombres+' '+ape_paterno+' '+ape_materno))) as CLIENTE,
		   isnull(rt.total,0)  as [TOT-TE],
		   isnull(rco.total,0) as [TOT-CO],
		   getdate() as FECHORDIA
	from Cliente c
	left join cte_rt  as rt  on c.codcliente=rt.codcliente
	left join cte_rco as rco on c.codcliente=rco.codcliente
	where tipo='P' and c.codcliente=@codcliente and c.estado=@estado

select * from uf_cliente(401,0) order by [TOT-TE] asc,[TOT-CO] asc--SI
select * from uf_cliente(402,1) order by [TOT-TE] asc,[TOT-CO] asc--SI
select * from uf_cliente(100,1) order by [TOT-TE] asc,[TOT-CO] asc--NO

drop function uf_cliente --Eliminar función

--05.10
--Tablas derivadas
select  c.codcliente as CODIGO,razon_social as EMPRESA,
        isnull(rt.total,0)     as [TOT-TE],
		isnull(rlla.total,0)   as [TOT-LLA],
		isnull(rsms.total,0)   as [TOT-SMS],
		isnull(rwsp.total,0)   as [TOT-WSP]
from Cliente c
left join
(
	select codcliente,count(numero) as total
	from Telefono
	group by codcliente
) rt on c.codcliente=rt.codcliente
left join
(
	select codcliente,count(numero) as total
	from Telefono
	where tipo='LLA'
	group by codcliente
) rlla on c.codcliente=rlla.codcliente
left join
(
	select codcliente,count(numero) as total
	from Telefono
	where tipo='SMS'
	group by codcliente
) rsms on c.codcliente=rsms.codcliente
left join
(
	select codcliente,count(numero) as total
	from Telefono
	where tipo='WSP'
	group by codcliente
) rwsp on c.codcliente=rwsp.codcliente
where tipo='E'

--CTEs
with cte_rt as
(
	select codcliente,count(numero) as total
	from Telefono
	group by codcliente
), cte_rlla as
(
	select codcliente,count(numero) as total
	from Telefono
	where tipo='LLA'
	group by codcliente
), cte_sms as
(
	select codcliente,count(numero) as total
	from Telefono
	where tipo='SMS'
	group by codcliente
), cte_wsp as
(
	select codcliente,count(numero) as total
	from Telefono
	where tipo='WSP'
	group by codcliente
) 
select  c.codcliente as CODIGO,razon_social as EMPRESA,
        isnull(rt.total,0)     as [TOT-TE],
		isnull(rlla.total,0)   as [TOT-LLA],
		isnull(rsms.total,0)   as [TOT-SMS],
		isnull(rwsp.total,0)   as [TOT-WSP]
from Cliente c
left join cte_rt   as rt   on c.codcliente=rt.codcliente
left join cte_rlla as rlla on c.codcliente=rlla.codcliente
left join cte_sms  as rsms on c.codcliente=rsms.codcliente
left join cte_wsp  as rwsp on c.codcliente=rwsp.codcliente
where tipo='E'

insert into Telefono values ('WSP2','995995177',1,1)

--vistas
create view v_clientes_tel as
select  c.codcliente as CODIGO,razon_social as EMPRESA,
        isnull(rt.total,0)     as [TOT-TE],
		isnull(rlla.total,0)   as [TOT-LLA],
		isnull(rsms.total,0)   as [TOT-SMS],
		isnull(rwsp.total,0)   as [TOT-WSP]
from Cliente c
left join
(
	select codcliente,count(numero) as total
	from Telefono
	group by codcliente
) rt on c.codcliente=rt.codcliente
left join
(
	select codcliente,count(numero) as total
	from Telefono
	where tipo='LLA'
	group by codcliente
) rlla on c.codcliente=rlla.codcliente
left join
(
	select codcliente,count(numero) as total
	from Telefono
	where tipo='SMS'
	group by codcliente
) rsms on c.codcliente=rsms.codcliente
left join
(
	select codcliente,count(numero) as total
	from Telefono
	where tipo='WSP'
	group by codcliente
) rwsp on c.codcliente=rwsp.codcliente
where tipo='E'

select * from v_clientes_tel
order by [TOT-TE] desc,[TOT-LLA] desc

--Funciones valor tabla
alter function uf_clientes_tel(@codcliente int) returns table
as return
	with cte_rt as
	(
		select codcliente,count(numero) as total
		from Telefono
		group by codcliente
	), cte_rlla as
	(
		select codcliente,count(numero) as total
		from Telefono
		where tipo='LLA'
		group by codcliente
	), cte_sms as
	(
		select codcliente,count(numero) as total
		from Telefono
		where tipo='SMS'
		group by codcliente
	), cte_wsp as
	(
		select codcliente,count(numero) as total
		from Telefono
		where tipo='WSP'
		group by codcliente
	) 
	select  c.codcliente as CODIGO,razon_social as EMPRESA,
			isnull(rt.total,0)     as [TOT-TE],
			isnull(rlla.total,0)   as [TOT-LLA],
			isnull(rsms.total,0)   as [TOT-SMS],
			isnull(rwsp.total,0)   as [TOT-WSP]
	from Cliente c
	left join cte_rt   as rt   on c.codcliente=rt.codcliente
	left join cte_rlla as rlla on c.codcliente=rlla.codcliente
	left join cte_sms  as rsms on c.codcliente=rsms.codcliente
	left join cte_wsp  as rwsp on c.codcliente=rwsp.codcliente
	where tipo='E' and c.codcliente=@codcliente

select * from uf_clientes_tel(1) order by [TOT-TE] desc,[TOT-LLA] desc --ok
select * from uf_clientes_tel(700) order by [TOT-TE] desc,[TOT-LLA] desc

select c.* from uf_clientes_tel(1) ce
inner join cliente c on ce.CODIGO=c.codcliente

--05.12

select avg(preciosol) from Contrato where estado=1 --precio promedio de los contratos activos
select eomonth('2020-11-22',1)

--Tablas derivadas
--Consulta padre
select coalesce(razon_social,c.nombres+ ' '+c.ape_paterno+' '+c.ape_materno,'SIN DATO') as CLIENTE,
       coalesce(p.nombre,'SIN DATO') as [PLAN],
	   coalesce(co.fec_contrato,'9999-12-31') as [FECHA],
	   coalesce(co.preciosol,0.00) as PRECIO,
	   cast(round((select avg(preciosol) from Contrato where estado=1),2) as decimal(8,2)) as PROMEDIO,
	   eomonth(getdate()) as F_CIERRE
from Contrato co
left join PlanInternet p on co.codplan=p.codplan
left join Cliente c on co.codcliente=c.codcliente
where co.preciosol>(select avg(preciosol) from Contrato where estado=1) --Consulta hija
order by PRECIO desc

--Vistas
create view v_contratos as
select coalesce(razon_social,c.nombres+ ' '+c.ape_paterno+' '+c.ape_materno,'SIN DATO') as CLIENTE,
       coalesce(p.nombre,'SIN DATO') as [PLAN],
	   coalesce(co.fec_contrato,'9999-12-31') as [FECHA],
	   coalesce(co.preciosol,0.00) as PRECIO,
	   cast(round((select avg(preciosol) from Contrato where estado=1),2) as decimal(8,2)) as PROMEDIO,
	   eomonth(getdate()) as F_CIERRE
from Contrato co
left join PlanInternet p on co.codplan=p.codplan
left join Cliente c on co.codcliente=c.codcliente
where co.preciosol>(select avg(preciosol) from Contrato where estado=1) --Consulta hija

select * from v_contratos
order by PRECIO desc

--Funcion valor tabla
create function uf_contratos() returns table
as return 
   select * from v_contratos

select * from uf_contratos()
order by PRECIO desc