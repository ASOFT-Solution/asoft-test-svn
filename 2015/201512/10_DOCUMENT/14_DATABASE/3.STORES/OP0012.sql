IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0012]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP0012]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- <Summary>
---- Loc phieu chao gia cho man hinh truy van
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 09/09/2004 by Vo Thanh Huong
---- Modified on 26/09/2006 by Nguyen Thi Thuy Tuyen: Lay them truong Notes,01,02 
---- Modified on 12/04/2007 by Trung Dung:
---- Modified on 15/12/2011 by Vo Viet Khanh : Lay them trường Varchar01 -> Varchar20
---- Modified on 16/12/2011 by Le Thi Thu Hien: Bo sung Barcode, va 5 khoan muc
---- Modified on 28/03/2012 by Le Thi Thu Hien: Bo sung QuotationStatus, ReceiveDate
---- Modified on 31/07/2012 by Bao Anh: Lay cac truong tham so Parameter01 -> 05
---- Modified on 03/05/2013 by Le Thi Thu Hien: Bo sung WHERE them DivisionID
---- Modified on 23/01/2015 by Trần Quốc Tuấn: Fix lỗi khi tìm kiếm detail
---- Modified on 16/05/2015 by Phan thanh hoàng Vũ: Bổ sung chức năng 
------ <Example>	exec OP0012 
--@DivisionID=N'AS',
--@UserID='NV000',
--@FromTranMonth=3,
--@FromTranYear=2014,
--@ToTranMonth=3,
--@ToTranYear=2014,
--@Mode=0,
--@StrWhere=N''


CREATE PROCEDURE [dbo].[OP0012] 
( 
		@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@FromTranMonth AS INT,
		@FromTranYear AS INT,
		@ToTranMonth AS INT,
		@ToTranYear AS INT,
		@Mode AS INT,	-- Master
						-- Detail
		@StrWhere AS NVARCHAR(4000) --Dieu kien tim kiem tren luoi 
) 
 AS
Declare @sSQL1 as nvarchar(max),
		@sSQL2 as nvarchar(max),
		@sSQL3 AS nvarchar(max),
		@sSQL4 AS NVARCHAR(MAX),
		@sSQL5 AS NVARCHAR(MAX)
			
				
SET @sSQL3 = ''
SET @sSQL4 = ''
----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer AS NVARCHAR(MAX),
		@sWHEREPer AS NVARCHAR(MAX)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM OT0001 WHERE DivisionID = @DivisionID AND IsPermissionView = 1 ) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = OT2101.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = OT2101.CreateUserID '
		SET @sWHEREPer = ' AND (OT2101.CreateUserID = AT0010.UserID
								OR  OT2101.CreateUserID = '''+@UserID+''') '		
	END

-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác	

IF @StrWhere IS NOT NULL AND @StrWhere <> ''
BEGIN
	SET @sSQL4 = ' AND ' + @StrWhere + ''
END
IF @Mode = 1 --Tim kiem duoi detail
BEGIN
	SET @sSQL3 = N'INNER JOIN OT2102 on OT2102.QuotationID = OT2101.QuotationID AND OT2102.DivisionID = OT2101.DivisionID'
END
----- Buoc  1 : Tra ra thông tin Master View OV0015

Set @sSQL1 =N' 
SELECT DISTINCT 
	OT2101.PriceListID,   
    OT2101.QuotationID, 
	OT2101.QuotationNo, 
	OT2101.DivisionID, 
	OT2101.TranMonth, 
	OT2101.TranYear,
	OT2101.QuotationDate,  
	OT2101.InventoryTypeID, 
	AT1301.InventoryTypeName,  	
	OT2101.ObjectID,  
	case when isnull(OT2101.ObjectName, '''') <> '''' then OT2101.ObjectName else AT1202.ObjectName end as ObjectName, 	
	OT2101.EmployeeID,  
	AT1103.FullName,  
	OriginalAmount = (	SELECT	Sum(isnull(OriginalAmount,0) + isnull(VATOriginalAmount, 0) - isnull(DiscountOriginalAmount, 0))  
						FROM	OT2102 
	                  	WHERE	OT2102.QuotationID = OT2101.QuotationID 
	                  			AND OT2102.DivisionID = '''+@DivisionID+'''),
	OT2101.Disabled, 
	OT2101.OrderStatus, 
	OV1001.Description as OrderStatusName, 
	OV1001.EDescription as EOrderStatusName, 
	OT2101.RefNo1, 
	OT2101.RefNo2, 
	OT2101.RefNo3, 
	OT2101.Attention1, 
	OT2101.Attention2, 
	OT2101.Dear, 
	OT2101.Condition, 
	OT2101.SaleAmount, 
	OT2101.PurchaseAmount,		
	OT2101.CurrencyID, 
	AT1004.CurrencyName, 
	OT2101.ExchangeRate,
	OT2101.Ana01ID, 
	OT2101.Ana02ID, 
	OT2101.Ana03ID,
	OT2101.Ana04ID, 
	OT2101.Ana05ID,
	OT1002_1.AnaName as Ana01Name, 
	OT1002_2.AnaName as Ana02Name, 
	OT1002_3.AnaName as Ana03Name,
	OT1002_4.AnaName as Ana04Name,
	OT1002_5.AnaName as Ana05Name,
	OT2101.CreateUserID, 
	OT2101.CreateDate, 
	OT2101.LastModifyUserID, 
	OT2101.LastModifyDate, 
	OT2101.IsSO,OT2101.Description, 
	OT2101.VoucherTypeID,
	OT2101.EndDate, 
	OT2101.Transport, 
	OT2101.DeliveryAddress, 
	case when isnull(OT2101.Address,'''') <> '''' then OT2101.Address else AT1202.Address end as Address,
	OT2101.PaymentID, 
	OT2101.PaymentTermID,
	OT2101.ApportionID,
	OT1102.Description as  IsConfirm,
	OT1102.EDescription as EIsConfirm,
	OT2101.DescriptionConfirm,
	OT2101.NumOfValidDays,
	OT2101.Varchar01,
	OT2101.Varchar02,
	OT2101.Varchar03,
	OT2101.Varchar04,
	OT2101.Varchar05,
	OT2101.Varchar06,
	OT2101.Varchar07,
	OT2101.Varchar08,
	OT2101.Varchar09,
	OT2101.Varchar10,
	OT2101.Varchar11,
	OT2101.Varchar12,
	OT2101.Varchar13,
	OT2101.Varchar14,
	OT2101.Varchar15,
	OT2101.Varchar16,
	OT2101.Varchar17,
	OT2101.Varchar18,
	OT2101.Varchar19,
	OT2101.Varchar20,
	OT2101.QuotationStatus,
	OV0002.Description AS QuotationStatusDescription,
	OV0002.EDescription AS QuotationStatusEDescription,
	OT2101.SalesManID,
	AT1103_1.FullName AS SalesMan '
	
SET @sSQL5 = N'	
FROM OT2101 	
LEFT JOIN AT1202 on AT1202.ObjectID = OT2101.ObjectID AND AT1202.DivisionID = OT2101.DivisionID
LEFT JOIN AT1004 on AT1004.CurrencyID = OT2101.CurrencyID AND AT1004.DivisionID = OT2101.DivisionID
LEFT JOIN AT1301 on AT1301.InventoryTypeID = OT2101.InventoryTypeID AND AT1301.DivisionID = OT2101.DivisionID
LEFT JOIN AT1103 on AT1103.EmployeeID = OT2101.EmployeeID AND AT1103.DivisionID = OT2101.DivisionID 
LEFT JOIN AT1103 AT1103_1 on AT1103_1.EmployeeID = OT2101.SalesManID AND AT1103_1.DivisionID = OT2101.DivisionID 
LEFT JOIN OV1001 on OV1001.OrderStatus = OT2101.OrderStatus AND OV1001.TypeID = ''SO'' AND OV1001.DivisionID = OT2101.DivisionID
LEFT JOIN OT1002 OT1002_1 on OT1002_1.AnaID = OT2101.Ana01ID AND OT1002_1.AnaTypeID = ''S01'' AND OT1002_1.DivisionID = OT2101.DivisionID
LEFT JOIN OT1002 OT1002_2 on OT1002_2.AnaID = OT2101.Ana02ID AND OT1002_2.AnaTypeID = ''S02'' AND OT1002_2.DivisionID = OT2101.DivisionID
LEFT JOIN OT1002 OT1002_3 on OT1002_3.AnaID = OT2101.Ana03ID AND OT1002_3.AnaTypeID = ''S03'' AND OT1002_3.DivisionID = OT2101.DivisionID
LEFT JOIN OT1002 OT1002_4 on OT1002_4.AnaID = OT2101.Ana04ID AND OT1002_4.AnaTypeID = ''S04'' AND OT1002_4.DivisionID = OT2101.DivisionID
LEFT JOIN OT1002 OT1002_5 on OT1002_5.AnaID = OT2101.Ana05ID AND OT1002_5.AnaTypeID = ''S05'' AND OT1002_5.DivisionID = OT2101.DivisionID
LEFT JOIN OT1102 on OT1102.Code = OT2101.IsConfirm AND OT1102.TypeID = ''SO'' AND OT1102.DivisionID = OT2101.DivisionID 
LEFT JOIN OV0002 ON OV0002.Status = OT2101.QuotationStatus AND OV0002.DivisionID = OT2101.DivisionID AND OV0002.Mode = 1 AND OV0002.TypeID = ''QO''
'+@sSQL3+''+@sSQLPer+'
WHERE	OT2101.DivisionID = '''+@DivisionID+''''+@sWHEREPer
---- Buoc  2 : Tra ra thong tin Detail View OV0016

Set @sSQL2= N'
SELECT OT2102.QuotationID, 
	OT2102.TransactionID, 
	QuotationNo, 
	QuotationDate,  
	OT2101.InventoryTypeID, 
	AT1301.InventoryTypeName,
	case when isnull(OT2102.InventoryCommonName, '''') = '''' then  AT1302.InventoryName else OT2102.InventoryCommonName end as InventoryName, 
	OT2102.InventoryID, 
	Isnull(OT2102.UnitID,AT1302.UnitID) as  UnitID,
	Isnull(T04.UnitName,AT1304.UnitName) as  UnitName,
	QuoQuantity, 
	OT2102.UnitPrice, 
	OriginalAmount, 
	OT2102.VATPercent,  
	OT2102.Notes, 
	VATOriginalAmount, 
	OT2102.DiscountPercent, 
	OT2102.DiscountOriginalAmount, 
	OT2102.Orders, 
	0 as ActualQuantity, 
	0 as RemainQuantity,
	ConvertedAmount, 
	VATConvertedAmount, 
	DiscountConvertedAmount,	
	OT2102.Notes01,			
	OT2102.Notes02,
	OT2102.VATGroupID,
	OT2102.finish	,
	OT2102.ConvertedQuantity, 
	OT2102.ConvertedSalepriceInput,
	OT2102.Markup,
	OT2102.ConvertedSaleprice, 
	OT2102.DivisionID,
	OT2102.Ana01ID,
	OT2102.Ana02ID,
	OT2102.Ana03ID,
	OT2102.Ana04ID,
	OT2102.Ana05ID,
	OT2102.Ana06ID,
	OT2102.Ana07ID,
	OT2102.Ana08ID,
	OT2102.Ana09ID,
	OT2102.Ana10ID,
	OT2102.Barcode,
	
	OT2102.OriginalAmount - OT2102.DiscountOriginalAmount  AS OriginalAmountBeforeVAT,
	OT2102.ConvertedAmount - OT2102.DiscountConvertedAmount AS ConvertedAmountBeforeVAT,
	OT2102.OriginalAmount - OT2102.DiscountOriginalAmount + OT2102.VATOriginalAmount AS OriginalAmountEnd,
	OT2102.ConvertedAmount - OT2102.DiscountConvertedAmount + OT2102.VATConvertedAmount AS ConvertedAmountEnd,
	ReceiveDate,
	OT2102.Parameter01, OT2102.Parameter02, OT2102.Parameter03, OT2102.Parameter04, OT2102.Parameter05

FROM OT2102 
LEFT JOIN AT1302 on AT1302.InventoryID= OT2102.InventoryID AND AT1302.DivisionID= OT2102.DivisionID
INNER JOIN OT2101 on OT2101.QuotationID = OT2102.QuotationID AND OT2101.DivisionID = OT2102.DivisionID
LEFT JOIN AT1004 ON AT1004.CurrencyID = OT2101.CurrencyID AND AT1004.DivisionID = OT2101.DivisionID
LEFT JOIN AT1301 on AT1301.InventoryTypeID = OT2101.InventoryTypeID AND AT1301.DivisionID = OT2101.DivisionID
LEFT JOIN AT1304 on AT1304.UnitID = AT1302.UnitID AND AT1304.DivisionID = AT1302.DivisionID
LEFT JOIN AT1304  T04 on T04.UnitID = OT2102.UnitID AND  T04.DivisionID = OT2102.DivisionID 
WHERE	OT2102.DivisionID = '''+@DivisionID+'''

'
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV0015')
    EXEC('CREATE VIEW OV0015    -- Tạo bởi OP0012
        as ' + @sSQL1 + @sSQL5 + @sSQL4)
ELSE
    EXEC('ALTER VIEW OV0015     -- Tạo bởi OP0012
        as ' + @sSQL1 + @sSQL5 + @sSQL4)

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV0016')
EXEC('CREATE VIEW OV0016    -- Tạo bởi OP0012
        as ' + @sSQL2)
ELSE
    EXEC('ALTER VIEW OV0016     -- Tạo bởi OP0012
        as ' + @sSQL2)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

