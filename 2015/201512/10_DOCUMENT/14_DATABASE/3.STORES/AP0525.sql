/****** Object:  StoredProcedure [dbo].[AP0525]    Script Date: 07/29/2010 09:58:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--Created by Nguyen Thi Ngoc Minh
--Date 25/10/2004
--Purpose: Tao view so du cuoi hang xuat kho theo bo
--Edit by :  Nguyen Quoc Huy
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP0525]	@DivisionID nvarchar(50), 		
				@TranMonth int, 			
				@TranYear int,
				@Date datetime,
				@InventoryTypeID nvarchar(50),
				@WareHouseID nvarchar(50),
				@IsDate tinyint,
				@ApportionTable nvarchar(250)
AS
DECLARE 	@Ssql as nvarchar(4000),
			@Swhere as nvarchar(4000)
			
If @ApportionTable like 'MT1603'
  BEGIN
  If @IsDate = 0 
	Set @Ssql = 'Select M03.ProductID, M03.ApportionID, T08.WareHouseID,
	T08.EndQuantity/M03.QuantityUnit as EndQuantity, M03.DivisionID
	
From MT1603 M03 inner join MT1602 M02 on M02.ApportionID = M03.ApportionID and M02.DivisionID = M03.DivisionID
		left join AT2008 T08 on T08.InventoryID = M03.MaterialID and T08.DivisionID = M03.DivisionID 
Where 	M02.InventoryTypeID like ''' + @InventoryTypeID + ''' and
	T08.WareHouseID like ''' + @WareHouseID + ''' and
	T08.TranMonth = ' + ltrim(str(@TranMonth)) + ' and
	T08.TranYear = ' + ltrim(str(@TranYear)) + ' and
	M03.DivisionID = ' + @DivisionID + ' and
	M02.Disabled = 0 
Group by M03.ProductID, M03.ApportionID, T08.WareHouseID, M03.MaterialID, T08.EndQuantity, M03.QuantityUnit,M03.DivisionID'
  Else
	Set @Ssql = 'Select M03.ProductID, M03.ApportionID, V70.WareHouseID,
	Sum(Case when D_C = ''D'' or D_C = ''BD'' then isnull(V70.ActualQuantity,0) 
		else -isnull(V70.ActualQuantity,0) End)/M03.QuantityUnit as EndQuantity,
		M03.DivisionID
From MT1603 M03 inner join MT1602 M02 on M02.ApportionID = M03.ApportionID and M02.DivisionID = M03.DivisionID
		left join AV7000 V70 on V70.InventoryID = M03.MaterialID and V70.DivisionID = M03.DivisionID 
Where 	M02.InventoryTypeID like ''' + @InventoryTypeID + ''' and
	V70.WareHouseID like ''' + @WareHouseID + ''' and
	M03.DivisionID = ''' + @DivisionID + ''' and
	M02.Disabled = 0 
Group by M03.ProductID, M03.ApportionID, M03.QuantityUnit, V70.WareHouseID, M03.MaterialID, M03.DivisionID'


--print @sSQL

	If Not Exists (Select 1 From sysObjects Where Name ='AV0524')
		Exec ('Create view AV0524 		--Created by AP0525
			as '+@sSQL)
	Else
		Exec( 'Alter view AV0524			--Created by AP0525
			as '+@sSQL)

	Set @Ssql = 'Select  V24.ProductID, T02.UnitID as InventoryUnitID, T04.UnitName, 
	T02.InventoryName as ProductName, V24.WareHouseID,
	T02.AccountID as CreditAccountID, V24.ApportionID, M02.Description as MDescription, 
	Round(Min(V24.EndQuantity),0,1) as EndQuantity, V24.DivisionID
From AV0524 V24 inner join MT1603 M03 on (V24.ProductID = M03.ProductID and
					V24.ApportionID = M03.ApportionID and V24.DivisionID = M03.DivisionID)
		inner join MT1602 M02 on M02.ApportionID = M03.ApportionID and M02.DivisionID = M03.DivisionID 
		inner join AT1302 T02 on T02.InventoryID = V24.ProductID and T02.DivisionID = V24.DivisionID
		inner join AT1304 T04 on T04.UnitID = T02.UnitID and T04.DivisionID = T02.DivisionID
Group by V24.ProductID, T02.UnitID, T04.UnitName, T02.InventoryName,
	T02.AccountID, V24.ApportionID, M02.Description, V24.WareHouseID, V24.DivisionID
'
  END
Else
  BEGIN
  If @IsDate = 0 
	Set @Ssql = 'Select T26.InventoryID as ProductID, T26.KITID as ApportionID, T08.WareHouseID,
		(T08.EndQuantity/T26.ItemQuantity)*T26.InventoryQuantity as EndQuantity, T26.DivisionID
From AT1326 T26 left join AT2008 T08 on T08.InventoryID = T26.ItemID and T08.DivisionID = T26.DivisionID 
		left join AT1302 T02 on T02.InventoryID = T26.InventoryID and T02.DivisionID = T26.DivisionID
Where 	T02.InventoryTypeID like ''' + @InventoryTypeID + ''' and
	T08.WareHouseID like ''' + @WareHouseID + ''' and
	T08.TranMonth = ' + ltrim(str(@TranMonth)) + ' and
	T08.TranYear = ' + ltrim(str(@TranYear)) + ' and
	T26.DivisionID = ' + @DivisionID + ' and
	T26.Disabled = 0 
Group by T26.InventoryID, T26.InventoryQuantity, T26.KITID, T08.WareHouseID, T26.ItemID, T08.EndQuantity, T26.ItemQuantity, T26.DivisionID'
  Else
	Set @Ssql = 'Select T26.InventoryID as ProductID, T26.KITID as ApportionID, V70.WareHouseID, ItemID, 
	(Sum(Case when D_C = ''D'' or D_C = ''BD'' then isnull(V70.ActualQuantity,0) 
		else -isnull(V70.ActualQuantity,0) End)/T26.ItemQuantity)*T26.InventoryQuantity as EndQuantity,
		T26.DivisionID
From AT1326 T26 left join AV7000 V70 on V70.InventoryID = T26.ItemID and V70.DivisionID = T26.DivisionID
		left join AT1302 T02 on T02.InventoryID = T26.InventoryID and T02.DivisionID = T26.DivisionID
Where 	T02.InventoryTypeID like ''' + @InventoryTypeID + ''' and
	V70.WareHouseID like ''' + @WareHouseID + ''' and
	T26.DivisionID like ''' + @DivisionID + ''' and
--	V70.VoucherDate <= ''' + Convert(nvarchar(10),@Date,101) +''' and
	T26.Disabled = 0 
Group by T26.InventoryID, T26.InventoryQuantity, T26.KITID, V70.WareHouseID, T26.ItemID, T26.ItemQuantity,T26.DivisionID'

--PRINT @SSQL
	If Not Exists (Select 1 From sysObjects Where Name ='AV0524')
		Exec ('Create view AV0524 		--Created by AP0525
			as '+@sSQL)
	Else
		Exec( 'Alter view AV0524			--Created by AP0525
			as '+@sSQL)

	Set @Ssql = 'Select  V24.ProductID, T26.InventoryUnitID, T04.UnitName, 
	T02.InventoryName as ProductName, V24.WareHouseID,
	T02.AccountID as CreditAccountID, V24.ApportionID, T26.MDescription, 
	Round(Min(V24.EndQuantity),0,1) as EndQuantity, V24.DivisionID
From AV0524 V24 inner join AT1326 T26 on (V24.ProductID = T26.InventoryID and
					V24.ApportionID = T26.KITID and V24.DivisionID = T26.DivisionID)
		inner join AT1302 T02 on T02.InventoryID = T26.InventoryID and T02.DivisionID = T26.DivisionID
		inner join AT1304 T04 on T04.UnitID = T26.InventoryUnitID and T04.DivisionID = T26.DivisionID
Group by V24.ProductID, T26.InventoryUnitID, T04.UnitName, T02.InventoryName,
	T02.AccountID, V24.ApportionID, T26.MDescription, V24.WareHouseID, V24.DivisionID
'
  END

--print @sSQL

If Not Exists (Select 1 From sysObjects Where Name ='AV0525')
	Exec ('Create view AV0525 		--Created by AP0525
			as '+@sSQL)
Else
	Exec( 'Alter view AV0525			--Created by AP0525
			as '+@sSQL)