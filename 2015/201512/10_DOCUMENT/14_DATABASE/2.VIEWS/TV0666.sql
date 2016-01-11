IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[TV0666]'))
DROP VIEW [dbo].[TV0666]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----- Created by Quoc Huy, Date 06/04/2008
----- View chet cho nhap xuat ton kho

CREATE View [dbo].[TV0666] as
Select 
	 VoucherID, TableID, TranMonth, TranYear, DivisionID, VoucherTypeID, VoucherDate, VoucherNo,ObjectID, ProjectID, OrderID, BatchID, 
               Case when KindVoucherID in(1,5,7,9,3) then WareHouseID end as ImWareHouseID,  
               Case when KindVoucherID in(2,4,6,8,10)  then WareHouseID when KindVoucherID in(3)  then WareHouseID2 end as ExWareHouseID, 
               ReDeTypeID,KindVoucherID, Status, EmployeeID,Description, CreateDate, CreateUserID,LastModifyUserID , LastModifyDate, 
               RefNo01, RefNo02, RDAddress, ContactPerson, VATObjectName  

From AT2006


GO


