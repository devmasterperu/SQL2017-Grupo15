--Examen final g12
Use devmasterdb
--01
--Subconsultas SELECT
select 
t.nombreTipoDocumento                as TIPO_DOC,
p.numdoc                             as NUM_DOC,
upper(concat(nombres,' ',apellidos)) as NOMBRE_COMPLETO,
(select count(idprogramacion) from tb_Programacion pr where pr.idprofesor=p.idprofesor) as TOTAL_PRO
from tb_Profesor p
left join tb_TipoDocumento t on p.tipodoc=t.idTipoDocumento

--Subconsultas FROM
select 
t.nombreTipoDocumento                as TIPO_DOC,
p.numdoc                             as NUM_DOC,
upper(concat(nombres,' ',apellidos)) as NOMBRE_COMPLETO,
isnull(rp.total,0)					 as TOTAL_PRO
from tb_Profesor p
left join tb_TipoDocumento t on p.tipodoc=t.idTipoDocumento
left join 
(
	select idprofesor,count(idprogramacion) as total
	from tb_Programacion pr 
	group by idprofesor
) rp on p.idprofesor=rp.idprofesor

--CTE
with CTE_RP as
(
	select idprofesor,count(idprogramacion) as total
	from tb_Programacion pr 
	group by idprofesor
)
select 
t.nombreTipoDocumento                as TIPO_DOC,
p.numdoc                             as NUM_DOC,
upper(concat(nombres,' ',apellidos)) as NOMBRE_COMPLETO,
isnull(rp.total,0)					 as TOTAL_PRO
from tb_Profesor p
left join tb_TipoDocumento t on p.tipodoc=t.idTipoDocumento
left join CTE_RP as rp on p.idprofesor=rp.idprofesor

--VISTAS
create view vReporteProfesores as
with CTE_RP as
(
	select idprofesor,count(idprogramacion) as total
	from tb_Programacion pr 
	group by idprofesor
)
select 
t.nombreTipoDocumento                as TIPO_DOC,
p.numdoc                             as NUM_DOC,
upper(concat(nombres,' ',apellidos)) as NOMBRE_COMPLETO,
isnull(rp.total,0)					 as TOTAL_PRO
from tb_Profesor p
left join tb_TipoDocumento t on p.tipodoc=t.idTipoDocumento
left join CTE_RP as rp on p.idprofesor=rp.idprofesor

select * from vReporteProfesores
order by TOTAL_PRO desc

--02
select count(idcurso) as [TOTAL CURSOS],
	   (select count(idhorario) from tb_Horario) as [TOTAL HORARIOS],
	   (select count(idprofesor) from tb_Profesor) as [TOTAL PROFESORES],
	   (select count(idprogramacion) from tb_Programacion) as [TOTAL PROGRAMACIONES]
from   tb_Curso

--create function F_Totales() returns table
alter function F_Totales(@estado bit) returns table
as
return
	select (select count(idcurso) from tb_Curso where estado=@estado) as [TOTAL CURSOS],
		   (select count(idhorario) from tb_Horario where estado=@estado) as [TOTAL HORARIOS],
		   (select count(idprofesor) from tb_Profesor where estado=@estado) as [TOTAL PROFESORES],
		   (select count(idprogramacion) from tb_Programacion) as [TOTAL PROGRAMACIONES]

select * from F_Totales(0)

--03
create view v_Programaciones as
select h.detalle as HORARIO,pr.fecinicio as FEC_INICIO,c.nomcurso as CURSO,
--Dentro de cada HORARIO es la posición irrepetible en base al campo FEC_INICIO (De la más antigua a la más reciente).
row_number() over(partition by h.idhorario order by pr.fecinicio asc) as PR_01,
--Dentro de cada HORARIO puede incluir posiciones repetidas y sin salto, en base al campo FEC_INICIO 
--(De la más antigua a la más reciente).
dense_rank() over(partition by h.idhorario order by pr.fecinicio asc) as PR_02,
--Dentro de cada HORARIO puede incluir posiciones repetidas y con salto, en base al campo FEC_INICIO 
--(De la más antigua a la más reciente)
rank() over(partition by h.idhorario order by pr.fecinicio asc) as PR_03,
--Dentro de cada HORARIO es uno de los 3 grupos al que pertenece el registro, en base al campo FEC_INICIO (De la más
--antigua a la más reciente)
ntile(3) over(partition by h.idhorario order by pr.fecinicio asc) as PR_04
from tb_Programacion pr
left join tb_Horario h on pr.idhorario=h.idhorario
left join tb_Curso   c on pr.idcurso=c.idcurso
where pr.fecinicio is not null

select * from v_Programaciones
order by HORARIO asc,FEC_INICIO

--04

--Variables
declare @idprogramacion int=50

select c.nomcurso as CURSO,p.nombres+' '+p.apellidos as PROFESOR,
h.detalle as HORARIO,pr.fecinicio as FEC_INICIO, pr.fecfin as FEC_FIN
from tb_Programacion pr
left join tb_Curso c on pr.idcurso=c.idcurso
left join tb_Profesor p on pr.idprofesor=p.idprofesor
left join tb_Horario h on pr.idhorario=h.idhorario
where idprogramacion=iif(@idprogramacion=0,idprogramacion,@idprogramacion)

--Función valor tabla
create function F_Programaciones(@idprogramacion int) returns table as
return
	select c.nomcurso as CURSO,p.nombres+' '+p.apellidos as PROFESOR,
	h.detalle as HORARIO,pr.fecinicio as FEC_INICIO, pr.fecfin as FEC_FIN
	from tb_Programacion pr
	left join tb_Curso c on pr.idcurso=c.idcurso
	left join tb_Profesor p on pr.idprofesor=p.idprofesor
	left join tb_Horario h on pr.idhorario=h.idhorario
	where idprogramacion=iif(@idprogramacion=0,idprogramacion,@idprogramacion)

select * from F_Programaciones(10)

--05
declare @x int=10

select 'F(X)'=power(@x+1,2)+10

create function F_Polinomio(@x int) returns table as
return 
	select 'F(X)'=power(@x+1,2)+10

select [F(X)] from F_Polinomio(10)