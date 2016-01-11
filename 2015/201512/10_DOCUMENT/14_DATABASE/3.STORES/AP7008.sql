/****** Object:  StoredProcedure [dbo].[AP7008]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----- Created by Nguyen Van Nhan, Date 13/12/2004
---- Purpose: Tinh so du dau ky cua cac mat hang quan ly thuc te dich danh
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [01/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7008] @DivisionID as varchar(20), 
				@WareHouseID  as  nvarchar(50), 
				@FromInventoryID as  nvarchar(50) , @ToInventoryID as  nvarchar(50),  
				@FromMonth int, @FromYear int, 
				@IsGroup as tinyint, 
				@GroupID as  nvarchar(50)
AS

Declare @sSQL as nvarchar(4000)
Set  @sSQL ='
Select 	AT0114.DivisionID, AT0114.InventoryID,
	ReVoucherNo, ReVoucherDate , ReTranMonth , ReTranYear, ReSourceNo,
	AT0114.LimitDate, ReQuantity, DeQuantity,
	EndQuantity,AT0114.UnitPrice, DeVoucherID, DeTransactionID,
	DeVoucherNo, DeVoucherDate
From AT0114 inner join AT1302 on AT1302.InventoryID = AT0114.InventoryID and AT1302.DivisionID = AT0114.DivisionID
Where ReTranYear + 100*ReTranMonth <='+str(@FromMonth)+'+ 100*'+str(@FromYear)+' and
	AT0114.DivisionID = N'''+@DivisionID+''' and
	WareHouseID like N'''+@WareHouseID+''' and
	( AT0114.InventoryID between N'''+@FromInventoryID+''' and N'''+@ToInventoryID+''')  	
'

If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='AV7008')
	Exec('Create view AV7008 as '+@sSQL)
Else
	Exec('Alter view AV7008 as '+@sSQL)
GO
