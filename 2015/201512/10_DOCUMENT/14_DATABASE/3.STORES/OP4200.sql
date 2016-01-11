/****** Object:  StoredProcedure [dbo].[OP4200]    Script Date: 12/20/2010 15:32:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
---Created by: Vo Thanh Huong, date: 28/09/2005
---Tinh ton kho thuc te

ALTER PROCEDURE [dbo].[OP4200]   @DivisionID varchar(20),
				 @FromMonth int,
				 @FromYear int,
				 @ToMonth int,
				 @ToYear int,
				 @WareHouseID varchar(20),
				 @FromInventoryID varchar(20),
				 @ToInventoryID varchar(20)	
AS
DECLARE @sSQL varchar(8000),
	@sWhere varchar(8000)
	
Set @sWhere = ' DivisionID = ''' + @DivisionID + '''
and AT2016.TranMonth + AT2017.TranYear * 100 between ' + cast(@FromMonth + @FromYear* 100 as varchar(20)) + ' and 
' + cast(@FromMonth + @FromYear* 100 as varchar(20)) + 
case when isnull(@FromInventoryID, '') <> '' or @FromInventoryID <> '%' then ' 
and AT2017.InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + '''' else '' end + ' 
and WareHouseID  like ''' + @WareHouseID  
		

Set @sSQL = '
----- So du
Select 	
	AT2017.DivisionID,  WareHouseID,  InventoryID, 
	Sum(ActualQuantity) as 	DebitQuantity,
	0 as CreditQuantity
From AT2017 inner join AT2016 on AT2016.VoucherID = AT2017.VoucherID
Where ' + @sWhere + '
Group by AT2017.DivisionID,  WareHouseID,  InventoryID

Union All  --- Nhap kho

Select 	
	AT2007.DivisionID,  WareHouseID,  InventoryID, 
	Sum(ActualQuantity) as 	DebitQuantity,
	0 as CreditQuantity
From AT2007 inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID
Where KindVoucherID in (1,3,5,7,9) ' + @sWhere + '
Group by AT2007.DivisionID, WareHouseID ,  InventoryID

Union All  ---- Xuat kho

Select 	
	AT2007.DivisionID,  WareHouseID,  InventoryID, 
	0 as DebitQuantity,
	Sum(ActualQuantity) as CreditQuantity
From AT2007 inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID
Where KindVoucherID in (2,4,6,8) ' + @sWhere + '
Group by AT2007.DivisionID,  WareHouseID, InventoryID

Union All  --- Xuat kho van chuyen noi bo

Select 
	AT2007.DivisionID,  WareHouseID2 as WareHouseID,  InventoryID, 
	Sum(ActualQuantity) as 	DebitQuantity,
	0 as CreditQuantity
From AT2007 inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID
Where KindVoucherID =  3  ' + @sWhere + '
Group by AT2007.DivisionID,  WareHouseID2, InventoryID'

IF  exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV4020')
	DROP VIEW OV4020
EXEC('Create view OV4020 ----tao boi OP2200
	as ' + @sSQL)