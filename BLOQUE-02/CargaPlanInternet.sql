USE DEVWIFI15Ed
go
insert into PlanInternet(nombre,precioref,descripcion) values ('PLAN TOTAL I',50,'Plan anterior ESTANDAR I')
go
insert into PlanInternet(nombre,precioref,descripcion) values ('PLAN TOTAL II',60,'Plan anterior ESTANDAR II')
go
insert into PlanInternet(nombre,precioref,descripcion) values ('GOLD I',70,'Plan nuevo')
go
insert into PlanInternet(nombre,precioref,descripcion) values ('GOLD II',90,'Plan nuevo')
go
insert into PlanInternet(nombre,precioref,descripcion) values ('GOLD III',100,'Plan nuevo')
go

select * from PlanInternet