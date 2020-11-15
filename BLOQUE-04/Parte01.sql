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