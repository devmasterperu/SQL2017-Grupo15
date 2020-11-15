--03.10
--LEFT JOIN
--coalesce(null,null,999)
select co.codcliente as [CODIGO CLIENTE],isnull(p.nombre,'SIN DATO') as [NOMBRE PLAN],
isnull(p.precioref,0.00) as [PRECIO PLAN],co.preciosol as [PRECIO CONTRATO],co.fec_contrato as [FECHA CONTRATO],
isnull(p.codplan,co.codplan) as CODPLAN
from Contrato co
left join PlanInternet p on co.codplan=p.codplan
order by isnull(p.codplan,co.codplan)

--RIGHT JOIN

select co.codcliente as [CODIGO CLIENTE],isnull(p.nombre,'SIN DATO') as [NOMBRE PLAN],
isnull(p.precioref,0.00) as [PRECIO PLAN],co.preciosol as [PRECIO CONTRATO],co.fec_contrato as [FECHA CONTRATO],
isnull(p.codplan,co.codplan) as CODPLAN
from PlanInternet p
right join Contrato co on co.codplan=p.codplan
order by isnull(p.codplan,co.codplan)

--03.12
select isnull(c.codcliente,0) as CLIENTE_CODCLIENTE,
case when c.tipo='P' 
	 then upper(rtrim(ltrim(nombres))+ ' ' +rtrim(ltrim(ape_paterno)) +' '+rtrim(ltrim(ape_materno)))
	 when c.tipo='E'
	 then upper(rtrim(ltrim(razon_social)))
	 else 'SIN DATO'
end as CLIENTE_NOMBRE,
lower(isnull(c.email,'SIN DATO')) as CLIENTE_CORREO,
isnull(co.codcliente,0) as CONTRATO_CODCLIENTE,
isnull(p.nombre,'SIN DATO') as CONTRATO_PLAN,
isnull(co.fec_contrato,'9999-12-31') as CONTRATO_FECHA
from Contrato co 
full outer join Cliente c on co.codcliente=c.codcliente
left outer join PlanInternet p on co.codplan=p.codplan
order by isnull(co.codcliente,0) asc

--SELF JOIN
--Relación empleados y sus jefes (empleados)
--select 
--emp.firstname+ ' ' + emp.lastname as empleado,
--jef.firstname+ ' ' + jef.lastname as jefe
--from HR.Employees emp
--left join HR.Employees jef on emp.mgrid=jef.empid
