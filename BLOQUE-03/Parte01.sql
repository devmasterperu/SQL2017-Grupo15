--03.01
--a 
select codcliente from Cliente --1000
select codplan from PlanInternet --5

select codcliente,codplan from Cliente cross join PlanInternet --5000
--b
select codcliente,codplan from Cliente cross join PlanInternet --2000
where tipo='E'

--03.02

select z.codzona as CODZONA,z.nombre as ZONA,z.estado as ESTADO,u.cod_dpto+u.cod_prov+u.cod_dto as UBIGEO,
'La Zona '+z.nombre+' del ubigeo '+u.cod_dpto+u.cod_prov+u.cod_dto+' se encuentra '+IIF(estado=1,'ACTIVA','INACTIVA') as MENSAJE
from  Zona z inner join Ubigeo u on z.codubigeo=u.codubigeo

--03.04

select top(100) t.desc_corta as TIPO_DOC,numdoc as NUM_DOC,
upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno)))) as [NOMBRE COMPLETO],
fec_nacimiento as FECHA_NAC,z.nombre as ZONA
from Cliente c 
inner join TipoDocumento t on c.codtipo=t.codtipo
inner join Zona z on c.codzona=z.codzona
where tipo='P' and c.estado=1
order by [NOMBRE COMPLETO] asc

--03.06

select t.tipo as TIPO,t.numero as NUMERO,t.codcliente as COD_CLIENTE,
c.razon_social as EMPRESA,z.nombre as ZONA
from Telefono t 
inner join Cliente c on t.codcliente=c.codcliente and c.tipo='E'
inner join Zona z on c.codzona=z.codzona
where t.estado=1

--03.08
--select isnull('MM','NN')

select t.tipo as TIPO,t.numero as NUMERO,
       case when c.tipo='E' then c.razon_social
	        when c.tipo='P' then upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))))
	   else 'SIN DETALLE'
	   end as CLIENTE,
	   isnull(email,'SIN DETALLE') as EMAIL,
	   convert(varchar(8),getdate(),112) as FEC_CONSULTA --112:AAAAMMDD
from Telefono t
left join Cliente c on t.codcliente=c.codcliente
where t.estado=1
order by c.email desc