--04.01
--a
insert into PlanInternet 
output inserted.codplan /*Valores del registro insertado*/
values ('GOLD IV',110.00,'Solicitado por comité junio 2020.')

select * from PlanInternet where codplan=6
--b
select * from PlanInternet where codplan=7
--c
insert into PlanInternet 
output inserted.codplan /*Valores del registro insertado*/
values 
('PREMIUM II',140.00,'Solicitado por comité junio 2020.'),
('PREMIUM III',160.00,'Solicitado por comité junio 2020.'),
('PREMIUM IV',180.00,'Solicitado por comité junio 2020.')

begin tran
	delete from PlanInternet 
	output deleted.codplan
	where codplan in (11,12,13)--Eliminar planes
rollback

select ident_current('PlanInternet')     --CODIGO AUTOGENERADO ACTUAL
DBCC CHECKIDENT('PlanInternet',RESEED,7) --RESETEAR VALOR AUTOGENERADO 7

insert into PlanInternet 
output inserted.codplan /*Valores del registro insertado*/
values 
('PREMIUM II',140.00,'Solicitado por comité junio 2020.'),
('PREMIUM III',160.00,'Solicitado por comité junio 2020.'),
('PREMIUM IV',180.00,'Solicitado por comité junio 2020.')

select * from PlanInternet

--d

insert into PlanInternet(descripcion,nombre,precioref)
output inserted.codplan /*Valores del registro insertado*/
values 
('Solicitado por comité junio 2020.','STAR I',190.00)

select * from PlanInternet where codplan=11

--e
/*Agregar valor x defecto a columna*/
alter table PlanInternet add fechoraregistro datetime default getdate()

insert into PlanInternet(descripcion,nombre,precioref)
output inserted.codplan /*Valores del registro insertado*/
values 
('Solicitado por comité junio 2020.','STAR II',200.00)

select * from PlanInternet where codplan in (11,12)

--f
/*Agregar valor x defecto a columna*/
alter table PlanInternet add estado bit default 0

insert into PlanInternet(descripcion,nombre,precioref,fechoraregistro)
output inserted.codplan /*Valores del registro insertado*/
values 
('Solicitado por comité junio 2020.','STAR III',210.00,'2020-11-15 08:30:00.500')

select * from PlanInternet where codplan in (11,12,13)

--04.02
--a
insert into Zona(nombre,codubigeo,estado)
output inserted.codzona
select nombre,u.codubigeo,1 from Zona_Carga zc 
inner join Ubigeo u on 
upper(rtrim(ltrim(zc.departamento)))=upper(rtrim(ltrim(u.nom_dpto))) and
upper(rtrim(ltrim(zc.provincia)))=upper(rtrim(ltrim(u.nom_prov))) and
upper(rtrim(ltrim(zc.distrito)))=upper(rtrim(ltrim(u.nom_dto)))
where estado='ACTIVO'

--b
--create procedure usp_ObtieneZonas
alter procedure usp_ObtieneZonas
as
select nombre,u.codubigeo,0 from Zona_Carga zc 
inner join Ubigeo u on 
upper(rtrim(ltrim(zc.departamento)))=upper(rtrim(ltrim(u.nom_dpto))) and
upper(rtrim(ltrim(zc.provincia)))=upper(rtrim(ltrim(u.nom_prov))) and
upper(rtrim(ltrim(zc.distrito)))=upper(rtrim(ltrim(u.nom_dto)))
where estado='INACTIVO'

insert into Zona(nombre,codubigeo,estado)
--output inserted.codzona
execute usp_ObtieneZonas

select * from Zona

--04.03

select * from Zona where codubigeo=18

insert into Zona(codubigeo,nombre,estado) values (18,'CAJATAMBO-A',1)
go
insert into Zona(codubigeo,nombre,estado) values (18,'CAJATAMBO-B',1)
go
insert into Zona(codubigeo,nombre,estado) values (18,'CAJATAMBO-C',1)
go

select ident_current('Zona')     --CODIGO AUTOGENERADO ACTUAL
DBCC CHECKIDENT('Zona',RESEED,32) --RESETEAR VALOR AUTOGENERADO 32

--Inserción sobre columna IDENTITY
SET IDENTITY_INSERT dbo.Zona ON;--Abrir inserción IDENTITY

insert into Zona(codzona,codubigeo,nombre,estado) values (12,18,'CAJATAMBO-A',1)
go
insert into Zona(codzona,codubigeo,nombre,estado) values (13,18,'CAJATAMBO-B',1)
go
insert into Zona(codzona,codubigeo,nombre,estado) values (14,18,'CAJATAMBO-C',1)
go

SET IDENTITY_INSERT dbo.Zona OFF;--Cerrar inserción IDENTITY

select * from Zona order by codzona

--04.05

select * from Telefono where codcliente=18 and tipo <> 'LLA'

begin tran
	delete
	from Telefono 
	output deleted.codcliente,deleted.tipo,deleted.numero,deleted.estado
	where codcliente=18 and tipo <> 'LLA'
rollback

select * from Telefono where codcliente=18 and tipo <> 'LLA'

--04.07

select co.*,c.tipo,c.estado,u.cod_dpto,u.cod_prov,u.cod_dto 
from Contrato co
inner join Cliente c on co.codcliente=c.codcliente and c.tipo='P' and c.estado=0
inner join Zona z on c.codzona=z.codzona
inner join Ubigeo u on z.codubigeo=u.codubigeo
where u.cod_dpto='15' and u.cod_prov='08' and u.cod_dto='01'

begin tran
	delete co
	output deleted.codcliente,deleted.codplan
	from Contrato co
	inner join Cliente c on co.codcliente=c.codcliente and c.tipo='P' and c.estado=0
	inner join Zona z on c.codzona=z.codzona
	inner join Ubigeo u on z.codubigeo=u.codubigeo
	where u.cod_dpto='15' and u.cod_prov='08' and u.cod_dto='01'
rollback

select co.*,c.tipo,c.estado,u.cod_dpto,u.cod_prov,u.cod_dto 
from Contrato co
inner join Cliente c on co.codcliente=c.codcliente and c.tipo='P' and c.estado=0
inner join Zona z on c.codzona=z.codzona
inner join Ubigeo u on z.codubigeo=u.codubigeo
where u.cod_dpto='15' and u.cod_prov='08' and u.cod_dto='01'

--begin tran
--	delete from Cliente
--	where codcliente=1
--rollback

--04.09

select * from cliente where codcliente=500

begin tran
	update Cliente
	set    numdoc='46173385',nombres='DOMITILA CAMILA',ape_paterno='LOPEZ',ape_materno='MORALES',
	       fec_nacimiento='1980-01-09',sexo='F',email='DOMITILA_LOPEZ@GMAIL.COM', direccion='URB. LOS CIPRESES M-24'
    output deleted.numdoc,deleted.nombres,  --Valores actuales
		   inserted.numdoc,inserted.nombres --Valores nuevos
	where  codcliente=500
rollback