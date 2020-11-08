--02.10
--a
--m01
select tipo,codzona from Cliente
where tipo='E' and 
(codzona=1 or codzona=3 or codzona=5 or codzona=7)
--m02
select iif(codtipo=3,'RUC','OTRO') as TIPO_DOC,numdoc as NUM_DOC,
razon_social as RAZON_SOCIAL,codzona as CODZONA,fec_inicio as FEC_INICIO 
from Cliente
where tipo='E' and codzona in (1,3,5,7)
order by razon_social desc

--b
select iif(codtipo=3,'RUC','OTRO') as TIPO_DOC,numdoc as NUM_DOC,
razon_social as RAZON_SOCIAL,fec_inicio as FEC_INICIO 
from Cliente
where tipo='E' and fec_inicio between '1998-01-01' and '1998-12-31'
order by fec_inicio desc

--02.12