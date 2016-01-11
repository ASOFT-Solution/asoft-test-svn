/****** Object:  StoredProcedure [dbo].[AP5556]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Ke thua ban hang
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP5556] @Find nvarchar(4000), @Date as datetime, @InvoiceNo as nvarchar(50)='%'
AS

Declare @DataName nvarchar(255)
Declare @sql nvarchar(4000)
Declare @sql1 nvarchar(4000)
IF @InvoiceNo = '' 
Set @InvoiceNo = '%'
EXEC AP5553 @DataName OUTPUT, 1

If @Find = ''
Begin
	
	Set @sql = 
	N'Select 	M.OrderID As [Maõ soá], M.SoHieuHD As [Soá seri], M.SoHD As [Soá hoùa ñôn], M.OrderDate As [Ngaøy hoùa ñôn],
		M.[Object_ID] As [Maõ ñoái töôïng], T2.ObjectName As [Teân ñoái töôïng], 
		left(dbo.af3339(M.Note),250) As [Dieãn giaûi],
		Product_ID As [Maõ haøng], T3.InventoryName As [Teân haøng], T3.UnitID As [ÑVT], 
		Quantity As [Soá löôïng],
		Price As [Ñôn giaù],
		Quantity*Price As [Nguyeân teä],
		Quantity*Price As [Quy ñoåi]
	From AT5558 M 
		Inner Join AT5559 D On M.OrderID = D.OrderID
		left Join AT1202 T2 On M.[Object_ID] = T2.ObjectID
		left Join AT1302 T3 On D.Product_ID = T3.InventoryID
	Where --T2.IsCustomer = 1 And
		M.OrderID Not In (Select OrderID From AT5553) And  
		M.OrderDate = ''' + ltrim(@Date) + N''' And 
		M.SoHD Like N''' + @InvoiceNo + ''' Order by M.OrderID'
	
	EXEC (@sql)
	
	Set @sql1 = 
	'Select Top 100 Percent
		M.OrderID, M.SoHieuHD As Serial, M.SoHD As InvoiceNo, M.OrderDate As VoucherDate,
		M.[Object_ID] As ObjectID, T2.ObjectName As ObjectName, 
		''VND'' As CurrencyID,
		1 As ExchangeRate,
		left(dbo.af3339(M.Note),250) As VDescription,
		Product_ID As InventoryID, T3.InventoryName As InventoryName, T3.UnitID As UnitID, 
		T3.IsStocked, T3.MethodID, T3.IsSource, T3.IsLocation, T3.IsLimitDate,
		Quantity,
		Price As UnitPrice,
		Quantity*Price As OriginalAmount,
		Quantity*Price As ConvertedAmount,
		T3.SalesAccountID
	From AT5558 M 
		Inner Join AT5559 D	On M.OrderID = D.OrderID
		left Join AT1202 T2 On M.[Object_ID] = T2.ObjectID
		left Join AT1302 T3 On D.Product_ID = T3.InventoryID
	Where --T2.IsCustomer = 1 And
		M.OrderID Not In (Select OrderID From AT5553) And  
		M.OrderDate = ''' + ltrim(@Date) + N''' And 
		M.SoHD Like N''' + @InvoiceNo + N''' Order by M.OrderID'

	If exists (Select Top 1 1 From sysobjects Where Id = Object_ID('AV5556') And xType = 'V')
	Begin
		Drop View AV5556
	End
		EXEC('Create View AV5556 --Create by AP5556
			As  ' + @sql1)	
End
Else
Begin
	Set @sql = 
	N'Select 	M.OrderID As [Maõ soá], M.SoHieuHD As [Soá seri], M.SoHD As [Soá hoùa ñôn], M.OrderDate As [Ngaøy hoùa ñôn],
		M.[Object_ID] As [Maõ ñoái töôïng], T2.ObjectName As [Teân ñoái töôïng], 
		left(dbo.af3339(M.Note),250) As [Dieãn giaûi],
		Product_ID As [Maõ haøng], T3.InventoryName As [Teân haøng], T3.UnitID As [ÑVT], 
		Quantity As [Soá löôïng],
		Price As [Ñôn giaù],
		Quantity*Price As [Nguyeân teä],
		Quantity*Price As [Quy ñoåi]
	From AT5558 M 
		Inner Join AT5559 D On M.OrderID = D.OrderID
		left Join AT1202 T2 On M.[Object_ID] = T2.ObjectID
		left Join AT1302 T3 On D.Product_ID = T3.InventoryID
	Where --T2.IsCustomer = 1 And
		M.OrderID Not In (Select OrderID From AT5553) And  ' + @Find + N' And 
		M.OrderDate = ''' + ltrim(@Date) + N''' And 
		M.SoHD Like N''' + @InvoiceNo + N''' Order by M.OrderID'
	
	EXEC (@sql)
	
	Set @sql1 = 
	'Select Top 100 Percent
		M.OrderID, M.SoHieuHD As Serial, M.SoHD As InvoiceNo, M.OrderDate As VoucherDate,
		M.[Object_ID] As ObjectID, T2.ObjectName As ObjectName, 
		''VND'' As CurrencyID,
		1 As ExchangeRate,
		left(dbo.af3339(M.Note),250) As VDescription,
		Product_ID As InventoryID, T3.InventoryName As InventoryName, T3.UnitID As UnitID, 
		T3.IsStocked, T3.MethodID, T3.IsSource, T3.IsLocation, T3.IsLimitDate,
		Quantity,
		Price As UnitPrice,
		Quantity*Price As OriginalAmount,
		Quantity*Price As ConvertedAmount,
		T3.SalesAccountID
	From AT5558 M 
		Inner Join AT5559 D	On M.OrderID = D.OrderID
		left Join AT1202 T2 On M.[Object_ID] = T2.ObjectID
		left Join AT1302 T3 On D.Product_ID = T3.InventoryID
	Where --T2.IsCustomer = 1 And
		M.OrderID Not In (Select OrderID From AT5553) And  ' + @Find + N' And 
		M.OrderDate = ''' + ltrim(@Date) + N''' And 
		M.SoHD Like N''' + @InvoiceNo + N''' Order by M.OrderID'

	If exists (Select Top 1 1 From sysobjects Where Id = Object_ID('AV5556') And xType = 'V')
	Begin
		Drop View AV5556
	End
		EXEC('Create View AV5556 --Create by AP5556
			As  ' + @sql1)	
End
GO
