--06.01

--Tablas derivadas
select co.codplan as CODPLAN, codcliente as CODCLIENTE,preciosol as PRECIO,
rco.pre_sum as PRE_SUM,rco.pre_prom as PRE_PROM,rco.pre_tot as PRE_TOT,
rco.pre_min as PRE_MIN, rco.pre_max as PRE_MAX
from Contrato co
left join
(
	select codplan,sum(preciosol) as pre_sum,avg(preciosol) as pre_prom,count(codcliente) as pre_tot,
	min(preciosol) as pre_min,max(preciosol) as pre_max
	from Contrato 
	group by codplan
) rco on co.codplan=rco.codplan
order by CODPLAN asc,PRECIO asc

--Over+Agrupamiento
select co.codplan as CODPLAN, codcliente as CODCLIENTE,preciosol as PRECIO,
sum(preciosol)    over(partition by co.codplan) as PRE_SUM,
avg(preciosol)    over(partition by co.codplan) as PRE_PROM,
count(codcliente) over(partition by co.codplan) as PRE_TOT,
min(preciosol)    over(partition by co.codplan) as PRE_MIN, 
max(preciosol)    over(partition by co.codplan) as PRE_MAX
from Contrato co
order by CODPLAN asc,PRECIO asc

select codcliente,codzona,
       min(direccion) over(partition by codzona) as min_direccion,
	   max(direccion) over(partition by codzona) as max_direccion
from Cliente
order by codzona

--Vistas
create view v_contratos_o as
select co.codplan as CODPLAN, codcliente as CODCLIENTE,preciosol as PRECIO,
sum(preciosol)    over(partition by co.codplan) as PRE_SUM,
avg(preciosol)    over(partition by co.codplan) as PRE_PROM,
count(codcliente) over(partition by co.codplan) as PRE_TOT,
min(preciosol)    over(partition by co.codplan) as PRE_MIN, 
max(preciosol)    over(partition by co.codplan) as PRE_MAX
from Contrato co

select * from v_contratos_o
order by CODPLAN asc,PRECIO asc

--06.03

--Tablas derivadas
select codcliente as CODIGO,razon_social as EMPRESA,fec_inicio as FEC_INICIO,
row_number() over(order by fec_inicio asc) as RN, --Posición irrepetible
rank() over(order by fec_inicio asc) as RK,       --Posición repetible con salto
dense_rank() over(order by fec_inicio asc) as DRK,--Posición repetible sin salto
ntile(5)  over(order by fec_inicio asc)    as N5, --Uno de los 5 grupos
ntile(6)  over(order by fec_inicio asc)    as N6  --Uno de los 6 grupos
from Cliente
where tipo='E'
order by fec_inicio asc

--funcion valor tabla
create function uf_cliente_e() returns table
as
return 
	select codcliente as CODIGO,razon_social as EMPRESA,fec_inicio as FEC_INICIO,
	row_number() over(order by fec_inicio asc) as RN, --Posición irrepetible
	rank() over(order by fec_inicio asc) as RK,       --Posición repetible con salto
	dense_rank() over(order by fec_inicio asc) as DRK,--Posición repetible sin salto
	ntile(5)  over(order by fec_inicio asc)    as N5, --Uno de los 5 grupos
	ntile(6)  over(order by fec_inicio asc)    as N6  --Uno de los 6 grupos
	from Cliente
	where tipo='E'

select * from uf_cliente_e()
order by fec_inicio asc