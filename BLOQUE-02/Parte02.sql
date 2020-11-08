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
and upper(concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno)))) like '%[f-z]'