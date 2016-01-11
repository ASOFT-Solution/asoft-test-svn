/****** Object:  StoredProcedure [dbo].[CP3000]    Script Date: 07/30/2010 10:20:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-----Nguyen thi Thuy Tuyen
-------19/12/2006
------L?y d? li?u cho man hinh lich su lam viec

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[CP3000] @DivisionID as nvarchar(50),
				@Date  datetime ,
			   	@FromObjectID as nvarchar(50) ,
				@ToObjectID as nvarchar(50) ,
				@ServiceTypeID as nvarchar(50),	
				@IsContract  as tinyint	 ---0: con hop dong; 1:Het hopdong
 AS

 Declare @sSQL nvarchar(4000)
If @IsContract = 0 
If @ServiceTypeID <> '%'

Set @sSQL ='
Select
	CT4000.S1, 
	CT4000.S2, 
	CT4000.S3, 
	CT4000.WMFileID, 
	CT4000.WMFileName, 
	CT4000.WMFileDate, 
	CT4000.ReVoucherID, 
	CT4000.ReVoucherNo, CT4000.DivisionID, 
	CT4000.TranMonth, CT4000.TranYear, 
	CT4000.ObjectID, CT4000.ObjectName, 
	CT4000.Contact, CT4000.Site, 
	CT4000.EmployeeID, CT4000.SupContractNo,
	 CT4000.SupContractDate, 
	CT4000.SupStartDate, CT4000.SupEndDate, CT4000.InvoiceNo, CT4000.ContractNo, 
	CT4000.ContractDate, CT4000.StartDate, CT4000.EndDate, 
	CT4000.ServiceTypeID, CT4000.ServiceLevelID, 
	CT4000.ToPay, CT4000.Features, CT4000.Description,
	CT4000.InventoryTypeID, CT4000.Disabled
From CT4000
Where CT4000.DivisionID = '''+@DivisionID+''' and
               '''+Convert(nvarchar(10),@Date,101)+'''   between CT4000.StartDate  and  CT4000.EndDate and
	CT4000.ObjectID  betWeen '''+@FromObjectID+''' and '''+@ToObjectID+''' and
	CT4000.ServiceTypeID = '''+@ServiceTypeID+'''

'
Else
Set @sSQL ='
Select
	CT4000.S1, 
	CT4000.S2, 
	CT4000.S3, 
	CT4000.WMFileID, 
	CT4000.WMFileName, 
	CT4000.WMFileDate, 
	CT4000.ReVoucherID, 
	CT4000.ReVoucherNo, CT4000.DivisionID, 
	CT4000.TranMonth, CT4000.TranYear, 
	CT4000.ObjectID, CT4000.ObjectName, 
	CT4000.Contact, CT4000.Site, 
	CT4000.EmployeeID, CT4000.SupContractNo,
	 CT4000.SupContractDate, 
	CT4000.SupStartDate, CT4000.SupEndDate, CT4000.InvoiceNo, CT4000.ContractNo, 
	CT4000.ContractDate, CT4000.StartDate, CT4000.EndDate, 
	CT4000.ServiceTypeID, CT4000.ServiceLevelID, 
	CT4000.ToPay, CT4000.Features, CT4000.Description,
	CT4000.InventoryTypeID, CT4000.Disabled
From CT4000
Where CT4000.DivisionID = '''+@DivisionID+''' and
               '''+Convert(nvarchar(10),@Date,101)+'''   between CT4000.StartDate  and  CT4000.EndDate and
	CT4000.ObjectID  betWeen '''+@FromObjectID+''' and '''+@ToObjectID+''' 
	 '
else

If @ServiceTypeID <> '%'

Set @sSQL ='
Select
	CT4000.S1, 
	CT4000.S2, 
	CT4000.S3, 
	CT4000.WMFileID, 
	CT4000.WMFileName, 
	CT4000.WMFileDate, 
	CT4000.ReVoucherID, 
	CT4000.ReVoucherNo, CT4000.DivisionID, 
	CT4000.TranMonth, CT4000.TranYear, 
	CT4000.ObjectID, CT4000.ObjectName, 
	CT4000.Contact, CT4000.Site, 
	CT4000.EmployeeID, CT4000.SupContractNo,
	 CT4000.SupContractDate, 
	CT4000.SupStartDate, CT4000.SupEndDate, CT4000.InvoiceNo, CT4000.ContractNo, 
	CT4000.ContractDate, CT4000.StartDate, CT4000.EndDate, 
	CT4000.ServiceTypeID, CT4000.ServiceLevelID, 
	CT4000.ToPay, CT4000.Features, CT4000.Description,
	CT4000.InventoryTypeID, CT4000.Disabled
From CT4000
Where CT4000.DivisionID = '''+@DivisionID+''' and
           (    '''+Convert(nvarchar(10),@Date,101)+'''   <   CT4000.StartDate  or
	         '''+Convert(nvarchar(10),@Date,101)+''' >  CT4000.EndDate ) and
	CT4000.ObjectID  betWeen '''+@FromObjectID+''' and '''+@ToObjectID+''' and
	CT4000.ServiceTypeID = '''+@ServiceTypeID+'''

'
Else
Set @sSQL ='
Select
	CT4000.S1, 
	CT4000.S2, 
	CT4000.S3, 
	CT4000.WMFileID, 
	CT4000.WMFileName, 
	CT4000.WMFileDate, 
	CT4000.ReVoucherID, 
	CT4000.ReVoucherNo, CT4000.DivisionID, 
	CT4000.TranMonth, CT4000.TranYear, 
	CT4000.ObjectID, CT4000.ObjectName, 
	CT4000.Contact, CT4000.Site, 
	CT4000.EmployeeID, CT4000.SupContractNo,
	 CT4000.SupContractDate, 
	CT4000.SupStartDate, CT4000.SupEndDate, CT4000.InvoiceNo, CT4000.ContractNo, 
	CT4000.ContractDate, CT4000.StartDate, CT4000.EndDate, 
	CT4000.ServiceTypeID, CT4000.ServiceLevelID, 
	CT4000.ToPay, CT4000.Features, CT4000.Description,
	CT4000.InventoryTypeID, CT4000.Disabled
From CT4000
Where CT4000.DivisionID = '''+@DivisionID+''' and
                ( '''+Convert(nvarchar(10),@Date,101)+'''   <   CT4000.StartDate  or
	         '''+Convert(nvarchar(10),@Date,101)+''' >  CT4000.EndDate ) and
	CT4000.ObjectID  betWeen '''+@FromObjectID+''' and '''+@ToObjectID+''' 
	 '


---Print @sSQL

If  not exists  (Select  top 1 1 From SysObjects Where Xtype ='V' and Name ='CV3000')
	Exec( ' Create View CV3000 as '  +@sSQL ) ---tao boi store CV3000
Else
	Exec('  Alter View CV3000 as  ' +@sSQL) ----Tao boi store CV3000