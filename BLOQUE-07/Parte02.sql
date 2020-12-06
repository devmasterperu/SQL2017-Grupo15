--07.05
--Crear tabla Configuración

create table dbo.Configuracion
(
codconfiguracion int identity(1,1) primary key,
variable varchar(1000) not null,
valor    varchar(1000) not null
)

insert into dbo.Configuracion(variable,valor) values ('RAZON_SOCIAL_DEVWIFI','DEV MASTER PERÚ SAC')
go
insert into dbo.Configuracion(variable,valor) values ('RUC_DEVWIFI','20602275320')
go

select * from dbo.Configuracion

alter procedure usp_selcliente(@idcliente int) as
begin
	if exists(select codcliente from Cliente where codcliente=@idcliente) 
	begin--Si existe cliente
		--select 'El cliente SI ha sido encontrado en la base de datos'	

		--CLIENTE
		select 
		(select valor from Configuracion where variable='RAZON_SOCIAL_DEVWIFI') as RAZON_SOCIAL_DEVWIFI,
		(select valor from Configuracion where variable='RUC_DEVWIFI')          as RUC_DEVWIFI,
		getdate()																as [CONSULTA AL],
		case when tipo='E' then upper(rtrim(ltrim(razon_social)))
			 when tipo='P' then upper(concat(ltrim(rtrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))))
			 else '-'
		end																	    as CLIENTE,
		direccion																as DIRECCION,
		z.nombre																as ZONA
		from Cliente c
		left join Zona z on c.codzona=z.codzona
		where codcliente=@idcliente

		--CONTRATOS
		select row_number() over(order by fec_contrato) as #PLAN,
		p.nombre as [PLAN],fec_contrato as [FEC_CONTRATO],preciosol as [PRECIO_SOL]
		from Contrato co
		left join PlanInternet p on co.codplan=p.codplan
		where codcliente=@idcliente
		order by fec_contrato
	end
	else 
	begin--No existe cliente
		select 'El cliente NO ha sido encontrado en la base de datos'	
	end
end

execute usp_selcliente 800

--07.08

--Variables
begin tran
	declare @codcliente int=700,	
			@codtipo    int=3,
			@numdoc varchar(15)='26940288914',
			@razon_social varchar(200)='EMPRESA 100',
			@fecinicio date='2007-09-04',
			@email varchar(320)='CONTACTO@EMPRESA100.PE',
			@direccion varchar(300)='URB. LOS CIPRESES M-24',
			@codzona int=6,
			@estado bit=1

	if exists(select 1 from Cliente where codcliente=@codcliente and tipo='E')
	begin --Cliente empresa y exista
		update c
		set    c.codtipo=@codtipo,c.numdoc=@numdoc,
			   c.razon_social=@razon_social,c.fec_inicio=@fecinicio,
			   c.email=@email,c.direccion=@direccion,
			   c.codzona=@codzona,c.estado=@estado
		output deleted.numdoc,inserted.numdoc
		from   Cliente c
		where  codcliente=@codcliente
	end
	else --Cliente persona 
	begin
		select 'No cumple la validación'
	end
rollback

select * from Cliente where codcliente=@codcliente

--Procedimientos almacenados

alter procedure usp_actualiza_empresa
(
	@codcliente int,	
	@codtipo    int,
	@numdoc varchar(15),
	@razon_social varchar(200),
	@fecinicio date,
	@email varchar(320),
	@direccion varchar(300),
	@codzona int,
	@estado bit
)
as
begin
	if exists(select 1 from Cliente where codcliente=@codcliente and tipo='E')
	begin --Cliente empresa y exista
		update c
		set    c.codtipo=@codtipo,c.numdoc=@numdoc,
			   c.razon_social=@razon_social,c.fec_inicio=@fecinicio,
			   c.email=@email,c.direccion=@direccion,
			   c.codzona=@codzona,c.estado=@estado
		output deleted.numdoc,inserted.numdoc
		from   Cliente c
		where  codcliente=@codcliente

		select 'Cliente empresa actualizado' as mensaje,@codcliente as codcliente
	end
	else --NO (Cliente empresa y exista)
	begin
		select 'No es posible identificar al cliente empresa a actualizar'as mensaje,@codcliente as codcliente
	end
end

select * from Cliente where codcliente=50
--50	E	3	51521648058	EMPRESA 50	        1993-10-31	5	CA. BOLOGNESI 669	CONTACTO@EMPRESA50.PE	    2020-11-01 14:08:38.337	1
--50	E	3	26940288920	CONFECCIONES JAMS	2009-01-01	7	CL.JUAN BARRETO 422	GMANRIQUEV@EMPRESA100.PE	2020-11-01 14:08:38.337	1
execute usp_actualiza_empresa @codcliente =700,	@codtipo=3,@numdoc='26940288920',@razon_social='CONFECCIONES JAMS',
@fecinicio='2009-01-01',@email='VENTAS@EMPRESA100.PE',@direccion='CL.JUAN BARRETO 422',
@codzona=7,@estado=1

--07.10

--Variables
declare @tipo  varchar(4)='SMS',
		@numero varchar(15)='995995177'--900670335

if exists(select numero from Telefono where tipo=@tipo and numero=@numero)
begin--Teléfono SI existe
	begin tran
		delete from Telefono
		output deleted.codcliente,deleted.tipo,deleted.numero,deleted.estado
		where tipo=@tipo and numero=@numero
	rollback

	select 'Teléfono eliminado' as mensaje,@tipo as tipo,@numero as numero
end
else--Teléfono NO existe
begin
	select 'No es posible identificar al teléfono a eliminar' as mensaje,'TTT' as tipo,'999999999' as numero
end

--Procedimiento almacenado

alter procedure usp_elimina_telefono(@tipo  varchar(4),@numero varchar(15))
as
begin
	if exists(select numero from Telefono where tipo=@tipo and numero=@numero)
	begin--Teléfono SI existe
		
		delete from Telefono
		output deleted.codcliente,deleted.tipo,deleted.numero,deleted.estado
		where tipo=@tipo and numero=@numero

		select 'Teléfono eliminado' as mensaje,@tipo as tipo,@numero as numero
	end
	else--Teléfono NO existe
	begin
		select 'No es posible identificar al teléfono a eliminar' as mensaje,'TTT' as tipo,'999999999' as numero
	end
end

execute usp_elimina_telefono @tipo='SMS',@numero='900670335'--900670335

select * from Telefono where tipo='SMS' and numero='900670335'