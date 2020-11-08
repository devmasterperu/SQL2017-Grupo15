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
--select LTRIM(RTRIM('   GIANFRANCO MANRIQUE  '))
--Lower=>Pasa expresi�n a min�scula
--Upper=>Pasa expresi�n a mayuscula
--%=>B�squeda sin considerar longitud ni un caracter especial
--'___'=> B�squeda si considera longitud.
--'[xyz]'= B�squeda restringida x,y o z.
--'[^xyz]= B�squeda restringida a que NO sea x, y ni z.
--'[a-c]=[abc]=>B�squeda con par�metros desde y hasta.
--'[^a-c]=[d-z]=>B�squeda con complemento y rango.
select iif(codtipo=1,'LE o DNI','OTRO') as TIPO_DOC,numdoc as NUM_DOC,
	   upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno)))) as CLIENTE
from Cliente --check(longitud>10) | (longitud>10)
where tipo='P' 
--and upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno)))) like 'A%'--a.Nombre completo inicie en �A�.
--and upper(rtrim(ltrim(nombres))) like 'A%'--a.Nombre completo inicie en �A�.
--and upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno)))) like '%AMA%' b.Nombre completo contiene la secuencia �AMA�.
--and upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno)))) like '%AN' c.Nombre completo finaliza en 'AN'
--and upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno)))) like '_ARI%'--e.Nombre completo contenga la secuencia �ARI� desde la 2� posici�n.
--and upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno)))) like '%M__'--f.Nombre completo tenga como antepen�ltimo car�cter la �M�.
--and upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno)))) like '[aeiou]%[aeiou]' --h.Nombre completo inicie y finalice con una vocal (a,e,i,o,u)
--and upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno)))) like '[^aeiou]%[^aeiou]'--i.Nombre completo inicie y finalice con una consonante. NOTA: SIEMPRE Y CUANDO S�LO TENGAMOS CONSONANTES Y VOCALES
and upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno)))) like '%[^f-z]'

--02.13

select codzona, estado, 
       COUNT(codcliente) as TOT_CLIENTES,
	   MIN(fec_inicio) as MIN_FEC_INICIO, 
	   MAX(fec_inicio) as MAX_FEC_INICIO,
	   case 
	   when COUNT(codcliente) between 0 and 19 then 'TOTAL_INFERIOR'
	   when COUNT(codcliente) between 20 and 39 then 'TOTAL_MEDIO'
	   when COUNT(codcliente)>=40 then 'TOTAL_SUPERIOR'
	   else 'NO ES POSIBLE IDENTIFICAR'
	   end as MENSAJE
from Cliente
where tipo='E' 
group by codzona, estado
having COUNT(codcliente)>10

--02.15
--nota_01
declare @n int=15

select top(@n) estado, codzona,
       COUNT(codcliente) as TOT_CLIENTES,
	   MIN(rtrim(ltrim(ape_paterno))) as MIN_APE_PAT, --Primer apellido paterno ordenado alfab�ticamente A-Z 
	   MAX(rtrim(ltrim(ape_paterno))) as MAX_APE_PAT, --�ltimo apellido paterno ordenado alfab�ticamente A-Z 
	   case 
	   when COUNT(codcliente) between 0 and 14 then 'INFERIOR'
	   when COUNT(codcliente) between 15 and 29 then 'MEDIO'
	   when COUNT(codcliente)>=30 then 'SUPERIOR'
	   else 'NO ES POSIBLE IDENTIFICAR'
	   end as MENSAJE
from Cliente
where tipo='P' 
group by codzona, estado
order by TOT_CLIENTES desc

--nota_02
select top(15) percent estado, codzona, --top(15) percent de 22=top(4)
       COUNT(codcliente) as TOT_CLIENTES,
	   MIN(rtrim(ltrim(ape_paterno))) as MIN_APE_PAT, --Primer apellido paterno ordenado alfab�ticamente A-Z 
	   MAX(rtrim(ltrim(ape_paterno))) as MAX_APE_PAT, --�ltimo apellido paterno ordenado alfab�ticamente A-Z 
	   case 
	   when COUNT(codcliente) between 0 and 14 then 'INFERIOR'
	   when COUNT(codcliente) between 15 and 29 then 'MEDIO'
	   when COUNT(codcliente)>=30 then 'SUPERIOR'
	   else 'NO ES POSIBLE IDENTIFICAR'
	   end as MENSAJE
from Cliente
where tipo='P' 
group by codzona, estado
order by TOT_CLIENTES desc

--nota_03
select top(15) with ties estado, codzona, --top(15) percent de 22=top(4)
       COUNT(codcliente) as TOT_CLIENTES,
	   MIN(rtrim(ltrim(ape_paterno))) as MIN_APE_PAT, --Primer apellido paterno ordenado alfab�ticamente A-Z 
	   MAX(rtrim(ltrim(ape_paterno))) as MAX_APE_PAT, --�ltimo apellido paterno ordenado alfab�ticamente A-Z 
	   case 
	   when COUNT(codcliente) between 0 and 14 then 'INFERIOR'
	   when COUNT(codcliente) between 15 and 29 then 'MEDIO'
	   when COUNT(codcliente)>=30 then 'SUPERIOR'
	   else 'NO ES POSIBLE IDENTIFICAR'
	   end as MENSAJE
from Cliente
where tipo='P' 
group by codzona, estado
order by TOT_CLIENTES desc

--nota_04
select top(40) percent with ties estado, codzona, --top(40) percent de 22=top(9)
       COUNT(codcliente) as TOT_CLIENTES,
	   MIN(rtrim(ltrim(ape_paterno))) as MIN_APE_PAT, --Primer apellido paterno ordenado alfab�ticamente A-Z 
	   MAX(rtrim(ltrim(ape_paterno))) as MAX_APE_PAT, --�ltimo apellido paterno ordenado alfab�ticamente A-Z 
	   case 
	   when COUNT(codcliente) between 0 and 14 then 'INFERIOR'
	   when COUNT(codcliente) between 15 and 29 then 'MEDIO'
	   when COUNT(codcliente)>=30 then 'SUPERIOR'
	   else 'NO ES POSIBLE IDENTIFICAR'
	   end as MENSAJE
from Cliente
where tipo='P' 
group by codzona, estado
order by TOT_CLIENTES desc
go
--02.17
declare @n int=30,@t int=20

select codcliente as COD_CLIENTE,
	   upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno)))) as NOMBRE_COMPLETO
from   Cliente 
where  tipo='P' 
order by NOMBRE_COMPLETO asc
--offset 0 rows=(1-1)*10
--fetch next 10 rows only--a.P�gina 1 y tama�o de p�gina 10 [Posici�n 1 � 10].
--offset 10 rows=(2-1)*10
--fetch next 10 rows only--b.P�gina 2 y tama�o de p�gina 10 [Posici�n 11-20].
--offset 20 rows=(3-1)*10
--fetch next 10 rows only--c.P�gina 3 y tama�o de p�gina 10 [Posici�n 21-30].
offset (@n-1)*@t rows
fetch next @t rows only