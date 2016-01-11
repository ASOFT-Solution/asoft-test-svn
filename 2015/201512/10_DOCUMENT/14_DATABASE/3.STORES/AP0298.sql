IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0298]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0298]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load Master cho màn hình AF0301 - Quản lý lịch sử mua hàng [Customize SGPT]
-- <History>
---- Create on 25/12/2014 by Lê Thị Hạnh 
---- Modified on ... by 
-- <Example>
/*
AP0298 @DivisionID = 'VG', @FromMonth = 07, @FromYear = 2014, @ToMonth = 09, @ToYear = 2014, 
       @FromDate = '2014-09-02 14:39:51.283', @ToDate = '2014-12-31 14:39:51.283', @IsDate = 0, 
       @FromObjectID = 'AC002', @ToObjectID = 'YKL001', @InventoryID = '%',
       @ConditionVT=N'('''')',@IsUsedConditionVT=N' (0=0) ',@ConditionAC=N'('''')',@IsUsedConditionAC=N' (0=0) ',
       @ConditionOB=N'('''')',@IsUsedConditionOB=N' (0=0) ',@UserID='ASOFTADMIN'
 */

CREATE PROCEDURE [dbo].[AP0298] 	
	@DivisionID NVARCHAR(50),
	@FromMonth INT,
	@FromYear INT,
	@ToMonth INT,
	@ToYear INT,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@IsDate TINYINT, -- = 1: search theo ngày
	@FromObjectID NVARCHAR(50),
	@ToObjectID NVARCHAR(50),
	--@Barcode NVARCHAR(50), -- Mã barcode hoặc mã mặt hàng
	@InventoryID NVARCHAR(50),
	--@IsBarcode TINYINT -- 1: quét theo barcode, 0: chọn mặt hàng
	@ConditionVT NVARCHAR(1000), -- Phân quyền
	@IsUsedConditionVT NVARCHAR(1000),
	@ConditionAC NVARCHAR(1000),
	@IsUsedConditionAC NVARCHAR(1000),
	@ConditionOB NVARCHAR(1000),
	@IsUsedConditionOB NVARCHAR(1000),
	@UserID VARCHAR(50) = ''
AS
DECLARE @sSQL1 NVARCHAR(MAX),
        @sWHERE NVARCHAR(MAX)
----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer NVARCHAR(1000),
		@sWHEREPer NVARCHAR(1000)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsPermissionView = 1 ) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 AT10 ON AT10.DivisionID = AT90.DivisionID 
											AND AT10.AdminUserID = '''+@UserID+''' 
											AND AT10.UserID = AT90.CreateUserID '
		SET @sWHEREPer = ' AND (AT90.CreateUserID = AT10.UserID
								OR  AT90.CreateUserID = '''+@UserID+''') '		
	END
-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác	
SET @sWHERE = ''
	SET @sWHERE = @sWHERE + 'AND ISNULL(AT90.ObjectID,'''') BETWEEN '''+@FromObjectID+''' AND '''+@ToObjectID+''' '
	--IF LTRIM(STR(@IsBarcode)) = 1
	--SET @sWHERE = @sWHERE + ' AND AT32.Barcode LIKE ''%'+@Barcode+'%'' '	
	--IF LTRIM(STR(@IsBarcode)) = 0
	SET @sWHERE = @sWHERE + ' AND AT90.InventoryID LIKE ''%'+@InventoryID+'%'' '
	IF LTRIM(STR(@IsDate)) = 1	SET @sWHERE = @sWHERE + '
	  AND CONVERT(VARCHAR(10),AT90.VoucherDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
	IF LTRIM(STR(@IsDate)) = 0	SET @sWHERE = @sWHERE + '
	  AND (AT90.TranYear*12 + AT90.TranMonth) BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+' '
SET @sSQL1 = '
SELECT AT90.VoucherID, AT90.BatchID, AT90.TableID, AT90.TranMonth, AT90.TranYear, AT90.TransactionTypeID, AT90.CurrencyID, 
	   AT90.CreditObjectID, AT90.VATNo, AT90.VATObjectID, ISNULL(AT90.VATObjectName,AT02.ObjectName) AS VATObjectName, 
	   ISNULL(AT90.VATObjectAddress,AT02.[Address]) AS VATObjectAddress, ISNULL(AT90.ExchangeRate,0) AS ExchangeRate, 
	   ISNULL(AT90.IsStock,0) AS IsStock, MAX(AT90.VoucherDate) AS VoucherDate, MAX(AT90.InvoiceDate) AS InvoiceDate, 
	   MAX(AT90.ObjectID) AS ObjectID, AT12.ObjectName, 
	   MAX(AT90.IsMultiTax) AS IsMultiTax, AT90.VoucherTypeID, AT90.VATTypeID, 
	   AT90.VATGroupID, AT90.VoucherNo, AT90.Serial, AT90.InvoiceNo, AT90.EmployeeID, AT90.SenderReceiver, 
	   AT90.SRDivisionName, AT90.SRAddress, AT90.RefNo01, AT90.RefNo02, AT90.VDescription, AT90.BDescription, 
	   AT90.DueDays, AT90.PaymentID, AT90.DueDate, AT90.OrderID, AT90.CreditBankAccountID, AT90.DebitBankAccountID, 
	   AT90.PaymentTermID, AT90.InvoiceCode, AT90.InvoiceSign, AT90.CurrencyIDCN,	   
	   SUM(ISNULL(AT90.DiscountAmount,0)) AS DiscountAmount,
	   SUM(CASE WHEN AT90.TransactionTypeID = ''T14'' THEN AT90.ConvertedAmount ELSE 0 END) TaxAmount,
	   SUM(CASE WHEN AT90.TransactionTypeID = ''T14'' THEN AT90.OriginalAmount ELSE 0 END) TaxOriginalAmount,
	   SUM(CASE WHEN AT90.TransactionTypeID IN (''T04'') THEN ISNULL(AT90.OriginalAmount,0) 
		        WHEN AT90.TransactionTypeID IN (''T64'') THEN (-1)*ISNULL(AT90.OriginalAmount,0) ELSE 0 END) OriginalAmount,
	   SUM(CASE WHEN AT90.TransactionTypeID IN (''T04'') THEN ISNULL(AT90.ConvertedAmount,0)
		        WHEN AT90.TransactionTypeID IN (''T64'') THEN (-1)*ISNULL(AT90.ConvertedAmount,0) ELSE 0 END) ConvertedAmount    
FROM AT9000 AT90 
LEFT JOIN AT1202 AT12 ON AT12.DivisionID = AT90.DivisionID AND AT12.ObjectID = AT90.ObjectID
LEFT JOIN AT1202 AT02 ON AT02.DivisionID = AT90.DivisionID AND AT02.ObjectID = AT90.VATObjectID
LEFT JOIN AT1302 AT32 ON AT32.DivisionID = AT90.DivisionID AND AT32.InventoryID = AT90.InventoryID
WHERE AT90.DivisionID = '''+@DivisionID+''' AND AT90.TransactionTypeID IN (''T04'', ''T14'',''T64'') 
	  AND AT90.TableID = ''AT9000''
	  AND	(ISNULL(AT90.VoucherTypeID,''#'') IN '+@ConditionVT+' OR '+@IsUsedConditionVT+')
      AND	(ISNULL(AT90.DebitAccountID,''#'') IN '+@ConditionAC+' OR '+@IsUsedConditionAC+')
	  AND	(ISNULL(AT90.CreditAccountID,''#'') IN '+@ConditionAC+' OR '+@IsUsedConditionAC+')
	  AND	(ISNULL(AT90.ObjectID,''#'')  IN '+@ConditionOB+' OR '+@IsUsedConditionOB+')
	  '+@sWHERE+'
GROUP BY AT90.VoucherID, AT90.BatchID, AT90.TableID, AT90.TranMonth, AT90.TranYear, AT02.[Address], AT12.ObjectName, 
	     AT90.TransactionTypeID, AT90.CurrencyID, AT90.CreditObjectID, AT90.VATNo, AT90.VATObjectID, AT02.ObjectName,
	     AT90.VATObjectName, AT90.VATObjectAddress, AT90.ExchangeRate, AT90.IsStock, AT90.VoucherTypeID, 
	     AT90.VATTypeID, AT90.VATGroupID, AT90.VoucherNo, AT90.Serial, AT90.InvoiceNo, AT90.EmployeeID, 
	     AT90.SenderReceiver, AT90.SRDivisionName, AT90.SRAddress, AT90.RefNo01, AT90.RefNo02, AT90.VDescription, 
	     AT90.BDescription, AT90.DueDays, AT90.PaymentID, AT90.DueDate, AT90.OrderID, AT90.CreditBankAccountID,
	     AT90.DebitBankAccountID, AT90.PaymentTermID, AT90.InvoiceCode, AT90.InvoiceSign, AT90.CurrencyIDCN 
ORDER BY AT90.VoucherNo '
EXEC (@sSQL1)
--PRINT (@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
