IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP0249]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP0249]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET NOCOUNT ON
GO

-- Tạo bởi : Việt Khánh
-- Ngày tạo: 27/05/2011
-- Mục đích: Báo cáo theo dõi tình hình xuất hóa đơn
--- Modify on 26/03/2014 by Bảo Anh: Truyền biến đơn vị, bổ sung thêm trường và chỉ lấy các phiếu xuất
--- AP0249 'LTV','03/01/2014','03/31/2014',3,2014,3,2014,1,'03/01/2014','03/31/2014',3,2014,3,2014,1,'DV01','VTXM','0000035','SACOM001',0

CREATE PROCEDURE [dbo].[AP0249]
	@DivisionID nvarchar(50),
    @FromVoucherDate DATETIME,
    @ToVoucherDate DATETIME,
    @FromVoucherMonth INT,
    @FromVoucherYear INT,
    @ToVoucherMonth INT,
    @ToVoucherYear INT,
    @VoucherDateFilter INT,
    @FromSalesDate DATETIME,
    @ToSalesDate DATETIME,
    @FromSalesMonth INT,
    @FromSalesYear INT,
    @ToSalesMonth INT,
    @ToSalesYear INT,
    @SalesDateFilter INT,
    @FromInventoryID NVARCHAR(50),
    @ToInventoryID NVARCHAR(50),
    @FromObjectID NVARCHAR(50),
    @ToObjectID NVARCHAR(50),
    @ObjectFilter INT
AS

DECLARE
    @SQL NVARCHAR(MAX),
    @FromVDateText NVARCHAR(10),
    @ToVDateText NVARCHAR(10),
    @FromVMonthYearText NVARCHAR(10),
    @ToVMonthYearText NVARCHAR(10),
    @FromSDateText NVARCHAR(10),
    @ToSDateText NVARCHAR(10),
    @FromSMonthYearText NVARCHAR(10),
    @ToSMonthYearText NVARCHAR(10),
    @VDateFilter NVARCHAR(4000),
    @SDateFilter NVARCHAR(4000),
    @ObjectIDFilter NVARCHAR(4000)

SET @FromVDateText = CONVERT(NVARCHAR(10), @FromVoucherDate, 101)
SET @ToVDateText = CONVERT(NVARCHAR(10), @ToVoucherDate, 101)
SET @FromVMonthYearText = CAST(@FromVoucherMonth + @FromVoucherYear * 100 AS NVARCHAR(10))
SET @ToVMonthYearText = CAST(@ToVoucherMonth + @ToVoucherYear * 100 AS NVARCHAR(10))

SET @FromSDateText = CONVERT(NVARCHAR(10), @FromSalesDate, 101)
SET @ToSDateText = CONVERT(NVARCHAR(10), @ToSalesDate, 101)
SET @FromSMonthYearText = CAST(@FromVoucherMonth + @FromVoucherYear * 100 AS NVARCHAR(10))
SET @ToSMonthYearText = CAST(@ToVoucherMonth + @ToVoucherYear * 100 AS NVARCHAR(10))

-- Ngày xuất
IF(@VoucherDateFilter = 1) SET @VDateFilter = N'(AT2006.TranMonth + AT2006.TranYear * 100 BETWEEN ' + @FromVMonthYearText + ' AND ' + @ToVMonthYearText + ')' ELSE
IF(@VoucherDateFilter = 2) SET @VDateFilter = N'(AT2006.VoucherDate BETWEEN ''' + @FromVDateText + ''' AND ''' + @ToVDateText + ''')'
ELSE SET @VDateFilter = N'1=1'

-- Ngày bán
IF(@SalesDateFilter = 1) SET @SDateFilter = N'(AT9000.TranMonth + AT9000.TranYear * 100 BETWEEN ' + @FromVMonthYearText + ' AND ' + @ToVMonthYearText + ')' ELSE
IF(@SalesDateFilter = 2) SET @SDateFilter = N'(AT9000.VoucherDate BETWEEN ''' + @FromVDateText + ''' AND ''' + @ToVDateText + ''')'
ELSE SET @SDateFilter = N'1=1'

-- Đối tượng
IF(@ObjectFilter = 1) SET @ObjectIDFilter = N'(AT2006.ObjectID BETWEEN ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''')'
ELSE SET @ObjectIDFilter = N'1=1'

--SET @SQL = '
--SELECT
--AT2006.VoucherNo,
--AT2006.VoucherDate,
--AT2007.SOrderID AS OrderID,
--AT9000.VoucherNo AS SalesNo,
--AT9000.VoucherDate AS SalesDate,
--AT2006.ObjectID,
--AT1202.ObjectName,
--AT2007.InventoryID,
--AT1302.InventoryName,
--AT1304.UnitName,
--AT9000.Quantity AS ActualQuantity,
--AT9000.ConvertedAmount,
--AT9000.InvoiceNo,
--AT2006.DivisionID

--FROM AT2006
--LEFT JOIN AT2007 ON AT2007.DivisionID = AT2006.DivisionID AND AT2007.VoucherID = AT2006.VoucherID
--LEFT JOIN AT9000 ON AT9000.DivisionID = AT2006.DivisionID AND AT9000.TransactionTypeID = ''T04''
--                AND AT9000.MTransactionID = AT2007.MTransactionID 
--                --AND AT9000.STransactionID = AT2007.STransactionID 
--LEFT JOIN AT1202 ON AT1202.DivisionID = AT2006.DivisionID AND AT1202.ObjectID = AT2006.ObjectID
--LEFT JOIN AT1302 ON AT1302.DivisionID = AT2006.DivisionID AND AT1302.InventoryID = AT2007.InventoryID
--LEFT JOIN AT1304 ON AT1304.DivisionID = AT2006.DivisionID AND AT1304.UnitID = AT2007.UnitID

--WHERE ' + @VDateFilter + '
--AND ' + @SDateFilter + '
--AND ' + @ObjectIDFilter + '
--AND AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
--and at2006.voucherno not in (select RefVoucherNo from at9000 
--where RefVoucherNo is not null and DivisionID = AT2006.DivisionID and AT2007.SOrderID =AT9000.SOrderID )
--union all 
--SELECT distinct 
--case when AT9000.RefVoucherNo is null then AT2006.VoucherNo else AT9000.RefVoucherNo end as VoucherNo,
--AT2006.VoucherDate,
--AT9000.SOrderID AS OrderID,
--AT9000.VoucherNo AS SalesNo,
--AT9000.VoucherDate AS SalesDate,
--AT2006.ObjectID,
--AT1202.ObjectName,
--AT9000.InventoryID,
--AT1302.InventoryName,
--AT1304.UnitName,
--AT9000.Quantity AS ActualQuantity,
--AT9000.ConvertedAmount,
--AT9000.InvoiceNo,
--AT2006.DivisionID

--FROM AT9000
--left JOIN AT2006 ON AT9000.DivisionID = AT2006.DivisionID AND AT9000.TransactionTypeID = ''T04''  
--	AND AT9000.RefVoucherNo = AT2006.VoucherNo
--left join AT2007 on AT2007.TransactionID=AT9000.TransactionID And AT2007.InventoryID=AT9000.InventoryID
--LEFT JOIN AT1202 ON AT1202.DivisionID = AT2006.DivisionID AND AT1202.ObjectID = AT2006.ObjectID
--LEFT JOIN AT1302 ON AT1302.DivisionID = AT2006.DivisionID AND AT1302.InventoryID = AT9000.InventoryID
--LEFT JOIN AT1304 ON AT1304.DivisionID = AT2006.DivisionID AND AT1304.UnitID = AT9000.UnitID

--WHERE ' + @VDateFilter + '
--AND ' + @SDateFilter + '
--AND ' + @ObjectIDFilter + '
--AND AT9000.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
--and AT9000.RefVoucherNo is not null
--'

SET @SQL = '
SELECT		AT2006.VoucherNo,  
			AT2006.VoucherDate,  
			AT2007.SOrderID AS OrderID,  
			AT9000.VoucherNo AS SalesNo,  
			AT9000.VoucherDate AS SalesDate,  
			AT2006.ObjectID,  
			AT1202.ObjectName,  
			AT2007.InventoryID,  
			AT1302.InventoryName,  
			AT1304.UnitName,  
			AT9000.Quantity AS ActualQuantity,
			AT2007.ActualQuantity AS AT2007Quantity,
			AT9000.ConvertedAmount,
			AT9000.InvoiceNo,  
			AT9000.InvoiceDate,
			AT9000.UnitPrice
		  						
FROM		AT2006 
INNER JOIN	AT2007 ON AT2007.VoucherID = AT2006.VoucherID AND AT2007.DivisionID = AT2006.DivisionID
LEFT JOIN	AT9000 ON AT9000.RefVoucherNo = AT2006.VoucherNo AND AT9000.InventoryID = AT2007.InventoryID AND AT9000.DivisionID = AT2007.DivisionID
LEFT JOIN	AT1202 ON AT1202.DivisionID = AT2006.DivisionID AND AT1202.ObjectID = AT2006.ObjectID  
LEFT JOIN	AT1302 ON AT1302.DivisionID = AT2006.DivisionID AND AT1302.InventoryID = AT2007.InventoryID  
LEFT JOIN	AT1304 ON AT1304.DivisionID = AT2006.DivisionID AND AT1304.UnitID = AT2007.UnitID 
WHERE		AT2006.DivisionID = ''' + @DivisionID + ''' AND AT2006.KindVoucherID in (2,4) AND ' + @VDateFilter + '
			AND ' + @SDateFilter + '
			AND ' + @ObjectIDFilter + '
			AND AT2007.InventoryID BETWEEN ''' + @FromInventoryID + ''' AND ''' + @ToInventoryID + '''
'
---print @SQL
IF NOT EXISTS (SELECT TOP 1 1 FROM sysObjects WHERE Xtype = 'V' AND Name = 'AV0249')
	EXEC(N'CREATE VIEW AV0249 -- Tạo bởi AP0249
AS ' + @SQL )
ELSE
	EXEC(N'ALTER VIEW AV0249 -- Tạo bởi AP0249
AS ' + @SQL)

GO

SET NOCOUNT OFF