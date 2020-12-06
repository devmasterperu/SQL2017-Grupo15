--Examen final g14

USE EmprendimientosDB

select * from produccion.tbUbigeo
select * from produccion.tbEmprendimiento
select * from produccion.tbActividadEconomica
select * from produccion.tbEmprendimientoActividad where idemprendimiento=1
select * from produccion.tbEmprendimientoActividad where idactividad=45

--01
create view vUbigeos as
select codigo as CODUBIGEO,departamento as DPTO,provincia as PROV,distrito as DTO,poblacion as POBLACION,
/*Es 1 de los 5 grupos, dentro de cada departamento, al que pertenece el
ubigeo. Considerar la poblaci�n, de mayor a menor, para generar el grupo*/
NTILE(5) over(partition by departamento order by poblacion desc) as U1,
/*Es la posici�n irrepetible por departamento. Considerar la poblaci�n, de
mayor a menor, para generar la posici�n*/
row_number() over(partition by departamento order by poblacion desc) as U2,
/*Es la posici�n por departamento que puede repetirse en caso de empate.
Considerar la poblaci�n, de mayor a menor, para generar la posici�n.
Adem�s, si puede existir salto de posiciones en el ranking*/
rank() over(partition by departamento order by poblacion desc) as U3,
/*Es la posici�n por departamento que puede repetirse en caso de empate.
Considerar la poblaci�n, de mayor a menor, para generar la posici�n.
Adem�s, no puede existir salto de posiciones en el ranking*/
dense_rank() over(partition by departamento order by poblacion desc) as U4
from produccion.tbUbigeo

select * from vUbigeos
order by DPTO asc, POBLACION desc

--02
declare @idubigeo int=31,@estado bit=1

select ruc as RUC,razonsocial as RAZON_SOCIAL,u.departamento as DEPARTAMENTO,
u.provincia as PROVINCIA, u.distrito as DISTRITO,e.estado as ESTADO
from produccion.tbEmprendimiento e
left join produccion.tbUbigeo u on e.idubigeo=u.idubigeo
where e.idubigeo=@idubigeo and e.estado=@estado

create procedure USP_REPORTE_EMP(@idubigeo int,@estado bit)
as
begin
	select ruc as RUC,razonsocial as RAZON_SOCIAL,u.departamento as DEPARTAMENTO,
	u.provincia as PROVINCIA, u.distrito as DISTRITO,e.estado as ESTADO
	from produccion.tbEmprendimiento e
	left join produccion.tbUbigeo u on e.idubigeo=u.idubigeo
	where e.idubigeo=@idubigeo and e.estado=@estado
end

EXECUTE USP_REPORTE_EMP @IDUBIGEO=31, @ESTADO=1
EXECUTE USP_REPORTE_EMP @IDUBIGEO=854, @ESTADO=0
go
--03
declare @ciiu varchar(4)='0000', @descripci�n varchar(500)='alquiler de videojuegos', @estado bit=1

if exists(select ciiu from produccion.tbActividadEconomica where ciiu=@ciiu)
begin --Existe ciiu
	select 'Actividad econ�mica existente' as mensaje,0 as idactividad
end
else
begin --NO Existe ciiu
	insert into produccion.tbActividadEconomica(ciiu,descripcion,estado)
	values (@ciiu,@descripci�n,@estado)

	--select 'Actividad econ�mica registrada' as mensaje,IDENT_CURRENT('produccion.tbActividadEconomica') as idactividad
	select 'Actividad econ�mica registrada' as mensaje,SCOPE_IDENTITY() as idactividad
end 

select * from produccion.tbActividadEconomica where idactividad=418

create procedure usp_ins_actividad(@ciiu varchar(4), @descripci�n varchar(500), @estado bit)
as
begin
	if exists(select ciiu from produccion.tbActividadEconomica where ciiu=@ciiu)
	begin --Existe ciiu
		select 'Actividad econ�mica existente' as mensaje,0 as idactividad
	end
	else
	begin --NO Existe ciiu
		insert into produccion.tbActividadEconomica(ciiu,descripcion,estado)
		values (@ciiu,@descripci�n,@estado)

		--select 'Actividad econ�mica registrada' as mensaje,IDENT_CURRENT('produccion.tbActividadEconomica') as idactividad
		select 'Actividad econ�mica registrada' as mensaje,SCOPE_IDENTITY() as idactividad
	end 
end

execute usp_ins_actividad @ciiu='9999', @descripci�n='alquiler de bicicletas', @estado=0

select * from produccion.tbActividadEconomica where idactividad=419
go
--04
declare @idemprendimiento int=9999,@idactividad int=138,
		@estado bit=1,@comentario varchar(300)='�ltima sesi�n SQL Server grupo 15'

if exists(select 1 from produccion.tbEmprendimientoActividad 
          where idemprendimiento=@idemprendimiento and idactividad=@idactividad)
begin --Relaci�n de emprendimiento+actividad existe
	begin tran
		update ea
		set  ea.estado=@estado,ea.comentario=@comentario
		output deleted.estado,inserted.estado,deleted.comentario,inserted.comentario
		from produccion.tbEmprendimientoActividad ea
		where idemprendimiento=@idemprendimiento and idactividad=@idactividad
	rollback

	select 'Relaci�n de emprendimiento y actividad actualizada' as mensaje
end
else
begin --Relaci�n de emprendimiento+actividad NO existe
	select 'No es posible identificar el emprendimiento y la actividad.Actualizaci�n no ejecutada' as mensaje
end

create procedure usp_ActualizaEmpActividad(@idemprendimiento int,@idactividad int,
@estado bit,@comentario varchar(300))
as
begin
	if exists(select 1 from produccion.tbEmprendimientoActividad 
          where idemprendimiento=@idemprendimiento and idactividad=@idactividad)
	begin --Relaci�n de emprendimiento+actividad existe

			update ea
			set  ea.estado=@estado,ea.comentario=@comentario
			output deleted.estado,inserted.estado,deleted.comentario,inserted.comentario
			from produccion.tbEmprendimientoActividad ea
			where idemprendimiento=@idemprendimiento and idactividad=@idactividad

			select 'Relaci�n de emprendimiento y actividad actualizada' as mensaje
	end
	else
	begin --Relaci�n de emprendimiento+actividad NO existe
			select 'No es posible identificar el emprendimiento y la actividad.Actualizaci�n no ejecutada' as mensaje
	end
end
--idemprendimiento	idactividad	fechoraregistro	estado	comentario
--5	377	2020-07-19 20:49:27.750	0	NULL
--5	377	2020-07-19 20:49:27.750	1	�ltima sesi�n SQL Server grupo 15

execute usp_ActualizaEmpActividad @idemprendimiento=5,@idactividad=377,
		                          @estado=1,@comentario='�ltima sesi�n SQL Server grupo 15'

select * from produccion.tbEmprendimientoActividad where idemprendimiento=5 and idactividad=377

--05
create procedure usp_eliminaEmpActividad(@idemprendimiento int,@idactividad int)
as
begin
	if exists(select 1 from produccion.tbEmprendimientoActividad 
          where idemprendimiento=@idemprendimiento and idactividad=@idactividad)
	begin --Relaci�n de emprendimiento+actividad existe

			delete ea
			output deleted.estado,deleted.comentario
			from produccion.tbEmprendimientoActividad ea
			where idemprendimiento=@idemprendimiento and idactividad=@idactividad

			select 'Relaci�n de emprendimiento y actividad eliminada' as mensaje
	end
	else
	begin --Relaci�n de emprendimiento+actividad NO existe
			select 'No es posible identificar el emprendimiento y la actividad.Eliminaci�n no ejecutada' as mensaje
	end
end

execute usp_eliminaEmpActividad @idemprendimiento=5,@idactividad=377

select * from produccion.tbEmprendimientoActividad where idemprendimiento=5 and idactividad=377