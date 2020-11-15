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

select codplan,nombre as [PLAN],
	   (select count(codcliente) from Contrato co where co.codplan=p.codplan) as TOTAL,
	   case 
	   when (select count(codcliente) from Contrato co where co.codplan=p.codplan) between 0 and 99 then 'Plan de baja demanda.'
	   when (select count(codcliente) from Contrato co where co.codplan=p.codplan) between 100 and 199 then 'Plan de mediana demanda.'
	   when (select count(codcliente) from Contrato co where co.codplan=p.codplan)>=200 then 'Plan de alta demanda.'
	   else 'SIN DATO'
	   end as MENSAJE
from PlanInternet p
order by TOTAL asc