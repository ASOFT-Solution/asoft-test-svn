/****** Object:  StoredProcedure [dbo].[CP5002]    Script Date: 07/29/2010 15:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


--------Date: 1/12/2006
--------Nguyen Thi Thuy Tuyen
--------In ho so bao danh muc he thong 
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[CP5002]
			@DivisionID nVarchar (50),
			@TranMonth as int,
			@TranYear as int,
			@VoucherID nVarchar (50)


as
 Declare @sSQL nVarchar (4000)
Set @sSQL = '
SELECT
	CT5001.DivisionID, 
	CT5000.WMfileID,  
	CT4000.WMFileName,
	CT5000.VoucherID,
	CT5000.InventoryID,
	AT1302.InventoryName,
	Serial,
	Version,
	HostID,
	HostName,
	Orders,
	TransactionID,
	SubInventoryID,
	T02.InventoryName as SubInventoryName,
	CT5001.UnitID,
	UnitName,
	SubQuantity,
	SubSerial,
	SubStatus,
	CV1001.Description as SubStatusName,
	Notes	

 FROM CT5001
Inner Join CT5000 on CT5001.VoucherID = CT5000.VoucherID and CT5001.DivisionID = CT5000.DivisionID
Inner Join AT1302 on AT1302.InventoryID = CT5000.InventoryID and AT1302.DivisionID = CT5000.DivisionID
Left Join  AT1302 T02 on T02.InventoryID = CT5001.SubInventoryID and T02.DivisionID = CT5001.DivisionID
Inner join CT4000 on CT4000.WMfileID = CT5000.WMfileID and CT4000.DivisionID = CT5000.DivisionID
Left Join AT1304 on AT1304.UnitID = CT5001.UnitID and AT1304.DivisionID = CT5001.DivisionID
Left Join CV1001 on CV1001.status = subStatus and CV1001.DivisionID = CT5001.DivisionID
	and  CV1001.TypeID = ''SI''
Where  CT5000.DivisionID = ''' +@DivisionID+'''  and
	CT5000.VoucherID = ''' + @VoucherID+'''
	 '

---Print  @sSQL

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'CV5002')
	Exec('Create View CV5002 ---tao boi CP5002
		 as '+@sSQL)
Else
	Exec('Alter View CV5002 ---tao boi CP5002
		 as '+@sSQL)