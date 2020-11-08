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
