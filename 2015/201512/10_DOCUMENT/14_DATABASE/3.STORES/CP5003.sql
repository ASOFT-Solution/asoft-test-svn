/****** Object:  StoredProcedure [dbo].[CP5003]    Script Date: 07/29/2010 15:07:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



--------Date: 6/12/2006
--------Nguyen Thi Thuy Tuyen
--------Lay du lieu cho an hinh thay the 
-------Last Edit 10/06/2007 Thuy Tuyen Where them CT4001.Disabled =0
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[CP5003]
			@DivisionID nVarchar (50),			
			@InventoryID nVarchar (50),
			@Serial nVarchar (50),
			@WMFileID nVarchar (50),
			@IsSytem tinyint

as
 Declare @sSQL nVarchar (4000)

If @IsSytem = 1
Set @sSQL = '
Select 
	CT5001.DivisionID,
	CT5001.VoucherID, 
	Orders, 
	SubInventoryID,
	AT1302.InventoryName as SubInventoryName ,
	CT5001.UnitID, 
	SubQuantity, 
	SubSerial, 
	SubStatus, 
	Notes ,
	CT5001.TransactionID
From CT5001
Inner Join AT1302 on AT1302.InventoryID = CT5001.SubInventoryID and AT1302.DivisionID = CT5001.DivisionID
Inner Join CT5000 on CT5000.VoucherID =CT5001.VoucherID and CT5000.DivisionID =CT5001.DivisionID
Where	
	SubStatus <> ''0''  AND
	 CT5000.DivisionID = ''' +@DivisionID+'''  and
	CT5000.InventoryID = ''' + @InventoryID+''' and 
	CT5000.Serial = ''' +@Serial+'''
	 '

Else

Set @sSQL  ='
Select 
	CT4001.DivisionID,
	CT4001.TransactionID as VoucherID , 
	Orders, 
	CT4001.InventoryID as SubInventoryID,
	AT1302.InventoryName as SubInventoryName ,
	CT4001.UnitID, 
	Ct4001.ActualQuantity as SubQuantity, 
	CT4001.Serial as SubSerial, 
	CT4001.Disabled as SubStatus, 
	Notes ,
	CT4001.TransactionID
From CT4001
Inner Join AT1302 on AT1302.InventoryID = CT4001.InventoryID and AT1302.DivisionID = CT4001.DivisionID

Where	
	CT4001.Disabled = 0  AND
	 CT4001.DivisionID = ''' +@DivisionID+'''  and
	CT4001.InventoryID =''' + @InventoryID+'''    
	and CT4001.WMFileID = ''' +@WMFileID+'''  
	and CT4001.IsSystem =0
	and isnull(CT4001.Serial,'''') = isnull( ''' +@Serial+''','''')
'


---Print  @sSQL

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'CV5003')
	Exec('Create View CV5003 ---tao boi CP5003
		 as '+@sSQL)
Else
	Exec('Alter View CV5003 ---tao boi CP5003
		 as '+@sSQL)