--07.01
--Variables
declare @n1 int=5, @n2 int=7
select 'F(N1,N2)'=power(@n1,2)+10*@n1*@n2+power(@n2,2)
go
--Procedimiento almacenado
create schema bloque07 

create procedure bloque07.usp_polinomio(@n1 int,@n2 int)
as
begin
	select 'F(N1,N2)'=power(@n1,2)+10*@n1*@n2+power(@n2,2)
end

execute bloque07.usp_polinomio @n1=5,@n2=7
execute bloque07.usp_polinomio @n2=7,@n1=5
exec bloque07.usp_polinomio @n1=5,@n2=7
exec bloque07.usp_polinomio 5,7
exec sp_helptext 'bloque07.usp_polinomio'

--Función escalar

alter function bloque07.f_polinomio(@n1 int,@n2 int) returns int
as
begin
	--Incluir total clientes
	declare @totclientes int=(select count(codcliente) from Cliente)
	declare @resultado   int=(select power(@n1,2)+10*@n1*@n2+power(@n2,2))
	return  @resultado
end

select bloque07.f_polinomio(5,7) as [F(N1,N2)]

select codtipo,codzona,bloque07.f_polinomio(codtipo,codzona) as resultado
from Cliente
/*
Números DEV MASTER.

Elaborar 1 función escalar que basado en el valor 'N' permita representar la función 'FN_DEV_MASTER', 
considerando las siguientes reglas:

VALOR_N	FN_DEV_MASTER(N)
[0,6>	N2+2
[6,10>	N3+3
[10, +>	N4+4

Ejecutar los siguientes comandos para validar su función escalar: 
	
-	SELECT dbo.FN_DEV_MASTER(2) retorna 6.
-	SELECT dbo.FN_DEV_MASTER(6) retorna 219.
-	SELECT dbo.FN_DEV_MASTER(11) retorna 14645.
*/

/*Variables*/
declare @N int=6

select 'FN_DEV_MASTER(N)'=case when @N between 0 and 5 then power(@N,2)+2
							   when @N between 6 and 9 then power(@N,3)+3
							   when @N>=10 then power(@N,4)+4
						  end

/*Funcion escalar*/

alter function FN_DEV_MASTER(@N int) returns int as
begin
    declare @resultado int
	set     @resultado = (select case when @N between 0 and 5 then power(@N,2)+2
							          when @N between 6 and 9 then power(@N,3)+3
							          when @N>=10 then power(@N,4)+4
						   end
						 )						
	return @resultado
end

select 'FN_DEV_MASTER(N)'=dbo.FN_DEV_MASTER(11)

create table dbo.Numeros
(
valor int not null
)

insert into dbo.Numeros values (2),(6),(11)

select valor,dbo.FN_DEV_MASTER(valor) as [FN_DEV_MASTER(N)]
from dbo.Numeros

--07.03
alter procedure USP_REPORTE_TEL(@tipo varchar(4),@mensaje varchar(1000))
as
begin
	--declare @_tipo varchar(4)='SMS',
	--declare @_mensaje varchar(1000)='Hola, tu servicio será cortado este fin de mes.'
	/*Validación de tipo*/

	if exists(select 1 from Telefono where tipo=@tipo)
	begin --Tipo existente
		select tipo as TIPO,numero as TELEFONO,@mensaje as MENSAJE from Telefono
		where estado=1 and tipo=@tipo
	end
	else
	begin --Tipo no existente
		select 'Tipo de teléfono no existente' as Mensaje
	end
end

EXECUTE USP_REPORTE_TEL @tipo= 'LLA', @mensaje= 'Hola, no olvide realizar el pago de su servicio de Internet'
EXECUTE USP_REPORTE_TEL @tipo= 'SMS', @mensaje= 'Hola, muchas gracias por su preferencia. Tenemos excelentes promociones para usted'
EXECUTE USP_REPORTE_TEL @tipo= 'WSP', @mensaje= 'Hola, hasta el 15/07 recibe un 20% de descuento en tu facturación'
EXECUTE USP_REPORTE_TEL @tipo= 'ABC', @mensaje= 'Hola, hasta el 15/07 recibe un 20% de descuento en tu facturación'

--07.06

create procedure usp_insUbigeo
(@cod_dpto varchar(3),
 @nom_dpto varchar(50),
 @cod_prov varchar(3),
 @nom_prov varchar(50),
 @cod_dto  varchar(3),
 @nom_dto  varchar(80))
 as
 begin
	if not exists(select codubigeo from Ubigeo where cod_dpto=@cod_dpto and cod_prov=@cod_prov and cod_dto=@cod_dto)
	begin
		insert into Ubigeo(cod_dpto,nom_dpto,cod_prov,nom_prov,cod_dto,nom_dto)
		values (@cod_dpto,@nom_dpto,@cod_prov,@nom_prov,@cod_dto,@nom_dto)

		select 'Ubigeo insertado' as mensaje,SCOPE_IDENTITY() as codubigeoasi
	end
	else 
	begin
		select 'Ubigeo existente' as mensaje,0 as codubigeoasi
	end
end

--DECLARE @cod_dpto varchar(3)='25'
--DECLARE @nom_dpto varchar(50)='UCAYALI'
--DECLARE @cod_prov varchar(3)='01'
--DECLARE @nom_prov varchar(50)='CORONEL PORTILLO'
--DECLARE @cod_dto varchar(3)='01'
--DECLARE @nom_dto varchar(80)='CALLERIA'

-- TODO: Set parameter values here.

EXECUTE [dbo].[usp_insUbigeo] @cod_dpto='25',@nom_dpto='UCAYALI',@cod_prov='01',@nom_prov='CORONEL PORTILLO',
                              @cod_dto='02',@nom_dto='YARINACOCHA'
GO

select * from Ubigeo where codubigeo=19