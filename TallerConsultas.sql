/*Cálculos en TSQL*/
declare @t1 int=1,@n int=63,@r bigint=2

--select 'tn'=@t1+(@n-1)*@r
--select 'tn'=@t1*power(@r,@n-1);
select @r=9223372036854775808

select 'dev'+'master'
/*Elementos de la Clausula SELECT*/
select count(ProductID),ProductCategoryID
from SalesLT.Product
where ListPrice>100
group by ProductCategoryID
having count(ProductID)>10

/*Lógica de Procesamiento consulta*/
select count(ProductID) as TOTAL,
       TOTAL*1.10       as TOTAL2,
       ProductCategoryID as PCI
from SalesLT.Product
where ListPrice>100 and ProductCategoryID=5
group by ProductCategoryID
having count(ProductID)>10
order by TOTAL

/*Uso de DISTINCT*/
select  Color from SalesLT.Product order by Color
select distinct Color from SalesLT.Product
select  ProductCategoryID from SalesLT.Product order by ProductCategoryID
select distinct ProductCategoryID from SalesLT.Product

select distinct Color,Size from SalesLT.Product
/*Uso de alias*/

select cu.CustomerID 'CodCliente',
concat(title,' ',FirstName,' ',LastName) as 'Cliente',
'Compañia'=CompanyName 
 --from SalesLT.Customer cu
 from SalesLT.Customer as cu
 where CustomerID=21

 /*Expresiones CASE*/
select AddressID,AddressLine1,CountryRegion,
case 
    when CountryRegion='United States' then 'US'
    when CountryRegion='Canada' then 'CA'
    else 'NN'
end as CountryCode,
case CountryRegion
    when 'United States' then 'US'
    when  'Canada' then 'CA'
    else 'NN'
end as CountryCode2,
IIF(CountryRegion='United States','US',
    IIF(CountryRegion='Canada','CA','NN')
) as CountryCode3
from SalesLT.Address

/*Uso de ORDER BY*/
select SalesOrderID,OrderQty,UnitPrice as PrecioUnitario,SalesOrderDetailID
from SalesLT.SalesOrderDetail
order by 1,OrderQty desc,PrecioUnitario desc

/*Predicados y Operadores*/
select ProductID,color,Size from SalesLT.Product
where color='Black' and ProductID=680

select ProductID,color,Size from SalesLT.Product
where color='Black' or ProductID=680

select ProductID,color,Size from SalesLT.Product
--where NOT(color='Black' and ProductID=680)
where NOT(color='Black') or NOT(ProductID=680)

select ProductID,color,Size from SalesLT.Product
--where NOT(color='Black' or ProductID=680)
where NOT(color='Black') and NOT(ProductID=680)

select ProductID,color,Size from SalesLT.Product
--where (color='Black') or (color='Red') or color='White'
where color in ('Black','Red','White')

select AddressID,AddressLine1,ModifiedDate 
from SalesLT.Address
where ModifiedDate BETWEEN '2005-01-01' and '2005-12-31'
order by ModifiedDate asc

select AddressLine1 from SalesLT.Address
where AddressLine1 like 'LAKE%'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '%H%'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '%LAKE%'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '%LAKE'

select AddressLine1 from SalesLT.Address
where AddressLine1 like 'E%E'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '_U%'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '_U_E%'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '%U_'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '[aeiou]%'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '%[aeiou]'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '[aeiou]%[aeiou]'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '[aeiou]%[s-z]'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '[aeiou]%[^s-z]'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '[^aeiou]%[s-z]'

select AddressLine1 from SalesLT.Address
where AddressLine1 like '[^aeiou]%[s-z]_'

/*Filtrado con TOP*/

select top 6 ProductID,ListPrice from SalesLT.Product 
order by ListPrice desc

select top 6 with ties ProductID,ListPrice from SalesLT.Product 
order by ListPrice desc

--select count(*) from SalesLT.Product --295
select top 6 percent ProductID,ListPrice from SalesLT.Product 
order by ListPrice desc

select top 6 percent with ties ProductID,ListPrice from SalesLT.Product 
order by ListPrice desc

/*Funciones sumarización*/
select ProductCategoryID,
count(*) as total,
sum(ListPrice),
avg(ListPrice),
min(ListPrice),
max(ListPrice)
from SalesLT.Product
where color='Black'
group by ProductCategoryID
having count(*)>10