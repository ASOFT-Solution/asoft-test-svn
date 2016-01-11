/****** Object:  StoredProcedure [dbo].[AP2016]    Script Date: 08/05/2010 09:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



------ In lien tuc cac phieu Nhap, xuat, VCNB
------ Created by Nguyen Van Nhan, Date 21/08/2004
------ Last Edit ThuyTuyen ,date 18/04/2007 Lay DebitAccountID,CreditAccountID
------ Edit by: Dang Le Bao Quynh; Date: 16/01/2009
------ Purpose: Bo sung truong hop xuat hang mua tra lai
/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP2016]
       @DivisionID nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear int ,
       @ListOfVouchers AS nvarchar(4000)
AS
DECLARE @sSQL AS nvarchar(4000)

SET @sSQL = '
Select AT2007.DivisionID,	
	AT2006.WareHouseID,
	T31.WareHouseName,
	WareHouseID2, 
	T32.WareHouseName  as WareHouseName2,
	VoucherTypeID,VoucherNo, VoucherDate, At2007.VoucherID,
	(Case When At2006.KindVoucherID in (1,5,7, 9) then ''NK''
	Else 
	 Case When At2006.KindVoucherID in (2,4,6, 8,10) then ''XK''
	  Else ''VC'' end end ) as TypeID,
	AT2006.Description,
	---AT2006.ObjectID+ '' - ''+ ObjectName as ObjectName,	
	AT2006.ObjectID+ '' -''+  case When Isnull (AT2006.VATObjectName,'''')= '''' then AT1202.ObjectName else AT2006.VATObjectName end   as ObjectName,	
	TransactionID, Orders,
	AT2007.InventoryID, InventoryName, AT2007.UnitID, UnitName,
	UnitPrice, ActualQuantity, ConvertedAmount,
	DebitAccountID,CreditAccountID
	, AT2006.[RefNo01], AT2006.[RefNo02]
From AT2007 	inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID and AT2006.DivisionID = AT2007.DivisionID
		inner join AT1302 on AT1302.InventoryID = AT2007.InventoryID and AT1302.DivisionID = AT2007.DivisionID
		Left join AT1202 on AT1202.ObjectID = AT2006.ObjectID and AT1202.DivisionID = AT2006.DivisionID
		Left join AT1303  T31 on T31.WareHouseID = AT2006.WareHouseID and T31.DivisionID = AT2006.DivisionID
		Left join AT1303  T32 on T32.WareHouseID = AT2006.WareHouseID2 and T32.DivisionID = AT2006.DivisionID
		Left join AT1304 on AT1304.UnitID = AT2007.UnitID and AT1304.DivisionID = AT2007.DivisionID
Where 	AT2007.TranMOnth = ' + str(@TranMonth) + ' and
	AT2007.TranYear =' + str(@TranYear) + ' and
	AT2007.DivisionID = ''' + @DivisionID + ''' and	
	AT2007.VoucherID in (' + @ListOfVouchers + ' )'

--Print @sSQL
IF NOT EXISTS ( SELECT
                    1
                FROM
                    sysObjects
                WHERE
                    Xtype = 'V' AND Name = 'AV2116' )
   BEGIN
         EXEC ( ' Create view AV2116 as '+@sSQL )
   END
ELSE
   BEGIN
         EXEC ( ' Alter view AV2116 as '+@sSQL )
   END