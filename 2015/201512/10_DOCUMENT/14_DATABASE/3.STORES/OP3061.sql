IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3061]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3061]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- In bao cao Tong hop chao gia 
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 14/03/2006 by Vo Thanh Huong
---- 
---- Modified on 30/01/2012 by Le Thi Thu Hien : Sua dieu kien CONVERT theo ngay
---- Modified on 06/02/2013 by Le Thi Thu Hien : WHERE thêm DivisionID khi lấy SUM tiền
---- Modified on 17/09/2015 by Tieu Mai: bo sung lay 10 ten, ma MPT, 10 tham so chi tiet o dong dau tien moi phieu
-- <Example>
---- 


CREATE PROCEDURE [dbo].[OP3061] 
    @DivisionID NVARCHAR(50),
    @IsDate TINYINT,
    @FromMonth INT,
    @FromYear INT,
    @ToMonth INT,
    @ToYear INT, 
    @FromDate DATETIME,
    @ToDate DATETIME,
    @FromObject NVARCHAR(20),
    @ToObject NVARCHAR(20),
    @OrderStatus INT 
AS

DECLARE 
    @sSQL NVARCHAR(MAX),
    @sSQL1 NVARCHAR(max),
    @sPeriod NVARCHAR(4000),
    @FromDateText AS NVARCHAR(20),
    @ToDateText AS NVARCHAR(20),
    @FromMonthYearText AS NVARCHAR(40),
    @ToMonthYearText AS NVARCHAR(40)

SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59'
SET @FromMonthYearText = CAST(@FromMonth + @FromYear * 100 AS NVARCHAR(20))
SET @ToMonthYearText = CAST(@ToMonth + @ToYear * 100 AS NVARCHAR(20))

IF @IsDate = 1
    SET @sPeriod = ' AND CONVERT(DATETIME,CONVERT(VARCHAR(10),OT2101.QuotationDate,101),101) BETWEEN ''' + @FromDateText + ''' AND ''' + @ToDateText + '''' 
ELSE 
    SET @sPeriod = ' AND OT2101.TranMonth + OT2101.TranYear * 100 BETWEEN ' + @FromMonthYearText + ' AND ' + @ToMonthYearText

SET @sSQL = '
SELECT 
	OT2101.DivisionID, 
	OT2101.TranMonth, 
	OT2101.TranYear, 
	OT2101.VoucherTypeID, 
	OT2101.ObjectID,
	CASE WHEN ISNULL(OT2101.ObjectName, '''') <> '''' THEN OT2101.ObjectName ELSE AT1202.ObjectName END AS ObjectName, 
	CASE WHEN ISNULL(OT2101.Address, '''') <> '''' THEN OT2101.Address ELSE AT1202.Address END AS Address, 
	AT1202.Tel,
	AT1202.Fax,
	AT1202.Email,
	AT1202.BankAccountNo,
	OT2101.EmployeeID, 
	AT1103.FullName,
	OT2101.CurrencyID, 
	AT1004.CurrencyName,
	OT2101.ExchangeRate, 
	OT2101.QuotationNo, 
	OT2101.QuotationDate, 
	OT2101.RefNo1, 
	OT2101.RefNo2, 
	OT2101.RefNo3, 
	OT2101.Attention1, 
	OT2101.Attention2, 
	OT2101.Dear, 
	OT2101.Condition, 
	OT2101.SaleAmount, 
	OT2101.PurchaseAmount, 
	OT2101.Disabled, 
	OT2101.Status, 
	OT2101.OrderStatus, 
	OT2101.IsSO, 
	OT2101.Description, 
	OT2101.CreateDate, 
	OT2101.CreateUserID, 
	OT2101.LastModifyDate, 
	OT2101.LastModifyUserID, 
	OT2101.InventoryTypeID, 
	OT2101.EndDate, 
	OT2101.Transport, 
	OT2101.DeliveryAddress, 
	OT2101.PaymentID, 
	OT2101.PaymentTermID, 
	OT2101.Ana01ID, 
	OT2101.Ana02ID, 
	OT2101.Ana03ID, 
	OT1002_1.AnaName AS Ana01Name, 
	OT1002_2.AnaName AS Ana02Name, 
	OT1002_3.AnaName AS Ana03Name, 
	OT2101.Ana04ID, 
	OT2101.Ana05ID, 
	OT2101.SalesManID, 
	OT2101.ClassifyID, 
	OV1001.Description AS OrderStatusName,
	OV1001.EDescription AS EOrderStatusName,
	OT2001.SOrderID,
	QuoQuantity = (SELECT SUM(ISNULL (QuoQuantity,0)) FROM OT2102 WHERE OT2102.QuotationID = OT2101.QuotationID AND DivisionID = '''+@DivisionID+'''),
	OriginalAmount = (SELECT SUM(ISNULL(OriginalAmount, 0)) FROM OT2102 WHERE OT2102.QuotationID = OT2101.QuotationID AND DivisionID = '''+@DivisionID+'''),
	ConvertedAmount = (SELECT SUM(ISNULL(ConvertedAmount, 0)) FROM OT2102 WHERE OT2102.QuotationID = OT2101.QuotationID AND DivisionID = '''+@DivisionID+'''),
	VATOriginalAmount = (SELECT SUM(ISNULL(VATOriginalAmount, 0)) FROM OT2102 WHERE OT2102.QuotationID = OT2101.QuotationID AND DivisionID = '''+@DivisionID+'''),
	VATConvertedAmount = (SELECT SUM(ISNULL(VATConvertedAmount, 0)) FROM OT2102 WHERE OT2102.QuotationID = OT2101.QuotationID AND DivisionID = '''+@DivisionID+'''),
	DiscountOriginalAmount = (SELECT SUM(ISNULL(DiscountOriginalAmount, 0)) FROM OT2102 WHERE OT2102.QuotationID = OT2101.QuotationID AND DivisionID = '''+@DivisionID+'''),
	DiscountConvertedAmount = (SELECT SUM(ISNULL(DiscountConvertedAmount, 0)) FROM OT2102 WHERE OT2102.QuotationID = OT2101.QuotationID AND DivisionID = '''+@DivisionID+'''),
	OT2102.Ana01ID as AnaID01,OT2102.Ana02ID as AnaID02,OT2102.Ana03ID as AnaID03,OT2102.Ana04ID as AnaID04,OT2102.Ana05ID as AnaID05,
	OT2102.Ana06ID as AnaID06,OT2102.Ana07ID as AnaID07,OT2102.Ana08ID as AnaID08,OT2102.Ana09ID as AnaID09,OT2102.Ana10ID as AnaID10,
	A01.AnaName as AnaName01,
	A02.AnaName as AnaName02,
	A03.AnaName as AnaName03,
	A04.AnaName as AnaName04,
	A05.AnaName as AnaName05,
	A06.AnaName as AnaName06,
	A07.AnaName as AnaName07,
	A08.AnaName as AnaName08,
	A09.AnaName as AnaName09,
	A10.AnaName as AnaName10,
	OT2102.QD01,OT2102.QD02,OT2102.QD03,OT2102.QD04,OT2102.QD05,OT2102.QD06,OT2102.QD07,OT2102.QD08,OT2102.QD09,OT2102.QD10'

SET @sSQL1 = '
FROM OT2101 
LEFT JOIN OV1001            ON OV1001.DivisionID = OT2101.DivisionID    AND OV1001.OrderStatus = OT2101.OrderStatus AND OV1001.TypeID=''QO''
LEFT JOIN OT2001            ON OT2001.DivisionID = OT2101.DivisionID    AND OT2001.QuotationID = OT2101.QuotationID
LEFT JOIN AT1202            ON AT1202.DivisionID = OT2101.DivisionID    AND AT1202.ObjectID = OT2101.ObjectID
LEFT JOIN AT1103            ON AT1103.DivisionID = OT2101.DivisionID    AND AT1103.EmployeeID = OT2101.EmployeeID
LEFT JOIN OT1002 OT1002_1   ON OT1002_1.DivisionID = OT2101.DivisionID  AND OT1002_1.AnaTypeID = ''S01'' AND OT1002_1.AnaID = OT2101.Ana01ID
LEFT JOIN OT1002 OT1002_2   ON OT1002_2.DivisionID = OT2101.DivisionID  AND OT1002_2.AnaTypeID = ''S02'' AND OT1002_2.AnaID = OT2101.Ana02ID
LEFT JOIN OT1002 OT1002_3   ON OT1002_3.DivisionID = OT2101.DivisionID  AND OT1002_3.AnaTypeID = ''S03'' AND OT1002_3.AnaID = OT2101.Ana03ID
LEFT JOIN AT1004 ON AT1004.DivisionID = OT2101.DivisionID AND AT1004.CurrencyID = OT2101.CurrencyID
LEFT JOIN (SELECT O02.DivisionID, O02.QuotationID, O02.Ana01ID, O02.Ana02ID,O02.Ana03ID,O02.Ana04ID,O02.Ana05ID,O02.Ana06ID,O02.Ana07ID,O02.Ana08ID,O02.Ana09ID,O02.Ana10ID,
							O02.QD01,O02.QD02,O02.QD03,O02.QD04,O02.QD05,O02.QD06,O02.QD07,O02.QD08,O02.QD09,O02.QD10
           FROM OT2102 O02 WHERE O02.DivisionID = ''' + @DivisionID + ''' AND O02.Orders = 1
           ) OT2102		ON OT2102.DivisionID = OT2101.DivisionID	AND OT2102.QuotationID = OT2101.QuotationID
left join AT1011 A01 on A01.AnaTypeID = ''A01'' and A01.AnaID = OT2102.Ana01ID  and A01.DivisionID= OT2102.DivisionID
left join AT1011 A02 on A02.AnaTypeID = ''A02'' and A02.AnaID = OT2102.Ana02ID  and A02.DivisionID= OT2102.DivisionID
left join AT1011 A03 on A03.AnaTypeID = ''A03'' and A03.AnaID = OT2102.Ana03ID  and A03.DivisionID= OT2102.DivisionID
left join AT1011 A04 on A04.AnaTypeID = ''A04'' and A04.AnaID = OT2102.Ana04ID  and A04.DivisionID= OT2102.DivisionID
left join AT1011 A05 on A05.AnaTypeID = ''A05'' and A05.AnaID = OT2102.Ana05ID  and A05.DivisionID= OT2102.DivisionID
left join AT1011 A06 on A06.AnaTypeID = ''A06'' and A06.AnaID = OT2102.Ana06ID  and A06.DivisionID= OT2102.DivisionID
left join AT1011 A07 on A07.AnaTypeID = ''A07'' and A07.AnaID = OT2102.Ana07ID  and A07.DivisionID= OT2102.DivisionID
left join AT1011 A08 on A08.AnaTypeID = ''A08'' and A08.AnaID = OT2102.Ana08ID  and A08.DivisionID= OT2102.DivisionID
left join AT1011 A09 on A09.AnaTypeID = ''A09'' and A09.AnaID = OT2102.Ana09ID  and A09.DivisionID= OT2102.DivisionID
left join AT1011 A10 on A10.AnaTypeID = ''A10'' and A10.AnaID = OT2102.Ana10ID  and A10.DivisionID= OT2102.DivisionID           
WHERE OT2101.DivisionID = ''' + @DivisionID + ''' 
AND OT2101.ObjectID BETWEEN ''' + @FromObject + ''' AND ''' + @ToObject + ''' 
AND OT2101.OrderStatus LIKE ' + CASE WHEN @OrderStatus = - 1 THEN '''%''' ELSE CAST(@OrderStatus AS NVARCHAR(1)) END + @sPeriod 

IF EXISTS(SELECT Top 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'OV3061')
    DROP VIEW OV3061

EXEC('Create view OV3061 --tao boi OP3061
        AS ' + @sSQL + @sSQL1)
--PRINT @sSQL + @sSQL1

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

