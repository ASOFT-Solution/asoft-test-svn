/****** Object:  StoredProcedure [dbo].[AP5557]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Ke thua mua hang
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP5557] @Find nvarchar(4000), @Date as datetime, @InvoiceNo as nvarchar(50)='%'
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
	N'Select M.ImportID As [Maõ soá], M.SoHD as [Soá hoùa ñôn], M.ImportDate As [Ngaøy hoùa ñôn], 
		[Object_ID] As [Maõ ñoái töôïng], T2.ObjectName As [Teân ñoái töôïng], 
		Case When PriceUSD>0 Then ''USD'' Else ''VND'' End As [Loaïi tieàn], 
		Case When tigia = 0 Then 1 Else tigia End As [Tyû giaù], 
		left(dbo.af3339(M.Note),250) As [Dieãn giaûi],
		Product_ID As [Maõ haøng],T3.InventoryName As [Teân haøng], T3.UnitID As [ÑVT], 
		Quantity As [Soá löôïng],
		Case When PriceUSD>0 Then PriceUSD Else Price End As [Ñôn giaù],
		Quantity*Case When PriceUSD>0 Then PriceUSD Else Price End As [Nguyeân teä],
		Quantity*Case When PriceUSD>0 Then PriceUSD Else Price End*tigia As [Quy ñoåi]
	From ' + @DataName + N'..Imports M 
		Inner Join ' + @DataName + N'..ImportDetails D On M.ImportID = D.ImportID
		left Join AT1202 T2 On M.[Object_ID] = T2.ObjectID
		left Join AT1302 T3 On D.Product_ID = T3.InventoryID
	Where --T2.IsSupplier = 1 And
		M.ImportID Not In (Select ImportID From AT5552) And  
		M.ImportDate = ''' + ltrim(@Date) + N''' And 
		M.SoHD Like N''' + @InvoiceNo + N''' Order by M.ImportID, D.IDSort'
	EXEC (@sql)

	Set @sql1 = 
	'Select Top 100 Percent 
		M.ImportID, M.SoHD as InvoiceNo, M.ImportDate As VoucherDate, 
		[Object_ID] As ObjectID, T2.ObjectName As ObjectName, 
		Case When PriceUSD>0 Then ''USD'' Else ''VND'' End As CurrencyID, 
		Case When tigia = 0 Then 1 Else tigia End As ExchangeRate, 
		left(dbo.af3339(M.Note),250) As VDescription,
		Product_ID As InventoryID,T3.InventoryName As InventoryName, T3.UnitID As UnitID, 
		T3.IsStocked, T3.MethodID, T3.IsSource, T3.IsLocation, T3.IsLimitDate,
		Quantity,
		Case When PriceUSD>0 Then PriceUSD Else Price End As UnitPrice,
		Quantity*Case When PriceUSD>0 Then PriceUSD Else Price End As OriginalAmount,
		Quantity*Case When PriceUSD>0 Then PriceUSD Else Price End*tigia As ConvertedAmount,
		T3.PurchaseAccountID,
		D.IDSort As Orders,
		M.ImportID + ''_'' + ltrim(D.IDSort) As Ma
	From ' + @DataName + N'..Imports M 
		Inner Join ' + @DataName + '..ImportDetails D On M.ImportID = D.ImportID
		left Join AT1202 T2 On M.[Object_ID] = T2.ObjectID
		left Join AT1302 T3 On D.Product_ID = T3.InventoryID
	Where --T2.IsSupplier = 1 And
		M.ImportID Not In (Select ImportID From AT5552) And  
		M.ImportDate = ''' + ltrim(@Date) + N''' And 
		M.SoHD Like N''' + @InvoiceNo + N''' Order by M.ImportID, D.IDSort'

	If exists (Select Top 1 1 From sysobjects Where Id = Object_ID('AV5557') And xType = 'V')
	Begin
		Drop View AV5557
	End
		EXEC('Create View AV5557 --Create by AP5557
			As  ' + @sql1)	
End
Else
Begin
	Set @sql = 
	'Select M.ImportID As [Maõ soá], M.SoHD as [Soá hoùa ñôn], M.ImportDate As [Ngaøy hoùa ñôn], 
		[Object_ID] As [Maõ ñoái töôïng], T2.ObjectName As [Teân ñoái töôïng], 
		Case When PriceUSD>0 Then ''USD'' Else ''VND'' End As [Loaïi tieàn], 
		Case When tigia = 0 Then 1 Else tigia End As [Tyû giaù], 
		left(dbo.af3339(M.Note),250) As [Dieãn giaûi],
		Product_ID As [Maõ haøng],T3.InventoryName As [Teân haøng], T3.UnitID As [ÑVT], 
		Quantity As [Soá löôïng],
		Case When PriceUSD>0 Then PriceUSD Else Price End As [Ñôn giaù],
		Quantity*Case When PriceUSD>0 Then PriceUSD Else Price End As [Nguyeân teä],
		Quantity*Case When PriceUSD>0 Then PriceUSD Else Price End*tigia As [Quy ñoåi]
	From ' + @DataName + N'..Imports M 
		Inner Join ' + @DataName + N'..ImportDetails D On M.ImportID = D.ImportID
		left Join AT1202 T2 On M.[Object_ID] = T2.ObjectID
		left Join AT1302 T3 On D.Product_ID = T3.InventoryID
	Where --T2.IsSupplier = 1 And
		M.ImportID Not In (Select ImportID From AT5552) And  ' + @Find + N' And 

		M.ImportDate = ''' + ltrim(@Date) + N''' And 
		M.SoHD Like N''' + @InvoiceNo + N''' Order by M.ImportID, D.IDSort'
	EXEC (@sql)

	Set @sql1 = 
	'Select Top 100 Percent 
		M.ImportID, M.SoHD as InvoiceNo, M.ImportDate As VoucherDate, 
		[Object_ID] As ObjectID, T2.ObjectName As ObjectName, 
		Case When PriceUSD>0 Then ''USD'' Else ''VND'' End As CurrencyID, 
		Case When tigia = 0 Then 1 Else tigia End As ExchangeRate, 
		left(dbo.af3339(M.Note),250) As VDescription,
		Product_ID As InventoryID,T3.InventoryName As InventoryName, T3.UnitID As UnitID, 
		T3.IsStocked, T3.MethodID, T3.IsSource, T3.IsLocation, T3.IsLimitDate,
		Quantity,
		Case When PriceUSD>0 Then PriceUSD Else Price End As UnitPrice,
		Quantity*Case When PriceUSD>0 Then PriceUSD Else Price End As OriginalAmount,
		Quantity*Case When PriceUSD>0 Then PriceUSD Else Price End*tigia As ConvertedAmount,
		T3.PurchaseAccountID,
		D.IDSort As Orders,
		M.ImportID + ''_'' + ltrim(D.IDSort) As Ma
	From ' + @DataName + N'..Imports M 
		Inner Join ' + @DataName + N'..ImportDetails D On M.ImportID = D.ImportID
		left Join AT1202 T2 On M.[Object_ID] = T2.ObjectID
		left Join AT1302 T3 On D.Product_ID = T3.InventoryID
	Where --T2.IsSupplier = 1 And
		M.ImportID Not In (Select ImportID From AT5552) And  ' + @Find + N' And 
		M.ImportDate = ''' + ltrim(@Date) + N''' And 
		M.SoHD Like N''' + @InvoiceNo + N''' Order by M.ImportID, D.IDSort'

	If exists (Select Top 1 1 From sysobjects Where Id = Object_ID('AV5557') And xType = 'V')
	Begin
		Drop View AV5557
	End
		EXEC('Create View AV5557 --Create by AP5557
			As  ' + @sql1)	
End
GO
