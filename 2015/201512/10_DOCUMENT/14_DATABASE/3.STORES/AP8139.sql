IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP8139]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP8139]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Import Excel Đơn hàng bán
-- <History>
---- Create on 15/04/2015 by Lê Thị Hạnh 
---- Modified on ... by 
---- 
-- <Example>
/* 
 AP8139 @DivisionID = 'VG', @UserID = 'ASOFTADMIN', @ImportTemplateID = 'SalesOrder', @@XML = ''
 */
 
CREATE PROCEDURE AP8139
( 
	@DivisionID AS NVARCHAR(50),
	@UserID AS NVARCHAR(50),	
	@ImportTemplateID AS NVARCHAR(50),
	@XML AS XML
) 
AS
DECLARE @cCURSOR AS CURSOR,
		@sSQL AS VARCHAR(1000)
		
DECLARE @ColID AS NVARCHAR(50), 
		@ColSQLDataType AS NVARCHAR(50)
		
CREATE TABLE #Data
(
	APK UNIQUEIDENTIFIER DEFAULT(NEWID()),
	Row INT,
	Orders INT,
	SOrderID NVARCHAR(50),
	TransactionID NVARCHAR(50),
	ImportMessage NVARCHAR(MAX) DEFAULT (''),
	CONSTRAINT [PK_#Data] PRIMARY KEY CLUSTERED 
	(
		Row ASC
	) ON [PRIMARY]	
)

CREATE TABLE #Keys
(
	Row INT,	
	Orders INT,
	SOrderID NVARCHAR(50),
	TransactionID NVARCHAR(50),
	VoucherNo NVARCHAR(50),
	Period NVARCHAR(50),
	InventoryID NVARCHAR(50),
	UnitID NVARCHAR(50)
	CONSTRAINT [PK_#Keys] PRIMARY KEY CLUSTERED 
	(
		Row ASC
	) ON [PRIMARY]	
)

SET @cCURSOR = CURSOR STATIC FOR
	SELECT		TLD.ColID,
				BTL.ColSQLDataType
	FROM		A01065 TL
	INNER JOIN	A01066 TLD
			ON	TL.ImportTemplateID = TLD.ImportTemplateID
	INNER JOIN	A00065 BTL
			ON	BTL.ImportTransTypeID = TL.ImportTransTypeID AND BTL.ColID = TLD.ColID
	WHERE		TL.ImportTemplateID = @ImportTemplateID
	ORDER BY	TLD.OrderNum

OPEN @cCURSOR									
-- Tạo cấu trúc bảng tạm
FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType	
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @sSQL = 'ALTER TABLE #Data ADD ' + @ColID + ' ' + @ColSQLDataType + CASE WHEN @ColSQLDataType LIKE '%char%' THEN ' COLLATE SQL_Latin1_General_CP1_CI_AS' ELSE '' END + ' NULL'
	EXEC (@sSQL)
	FETCH NEXT FROM @cCURSOR INTO @ColID, @ColSQLDataType
END 
-- Thêm dữ liệu vào bảng tạm
SELECT	X.Data.query('Row').value('.', 'INT') AS Row,
		X.Data.query('DivisionID').value('.', 'NVARCHAR(50)') AS DivisionID,
		X.Data.query('Period').value('.', 'VARCHAR(10)') AS Period,
		X.Data.query('VoucherTypeID').value('.', 'NVARCHAR(50)') AS VoucherTypeID,
		X.Data.query('VoucherNo').value('.', 'NVARCHAR(50)') AS VoucherNo,
		(CASE WHEN X.Data.query('OrderDate').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('OrderDate').value('.', 'DATETIME') END) AS OrderDate,
		(CASE WHEN X.Data.query('ContractNo').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE  X.Data.query('ContractNo').value('.', 'NVARCHAR(50)') END) AS ContractNo,
		(CASE WHEN X.Data.query('ContractDate').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('ContractDate').value('.', 'DATETIME') END) AS ContractDate,
		X.Data.query('CurrencyID').value('.', 'NVARCHAR(50)') AS CurrencyID,
		(CASE WHEN X.Data.query('ExchangeRate').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ExchangeRate').value('.', 'DECIMAL(28,8)') END) AS ExchangeRate,
		(CASE WHEN X.Data.query('ClassifyID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('ClassifyID').value('.', 'NVARCHAR(50)') END) AS ClassifyID,
		(CASE WHEN X.Data.query('OrderStatus').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('OrderStatus').value('.', 'TINYINT') END) AS OrderStatus,
		(CASE WHEN X.Data.query('ShipDate').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('ShipDate').value('.', 'DATETIME') END) AS ShipDate,
		(CASE WHEN X.Data.query('InventoryTypeID').value('.', 'VARCHAR(50)') = '' THEN '%' ELSE X.Data.query('InventoryTypeID').value('.', 'NVARCHAR(50)') END) AS InventoryTypeID,
		(CASE WHEN X.Data.query('EmployeeID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('EmployeeID').value('.', 'NVARCHAR(50)') END) AS EmployeeID,
		(CASE WHEN X.Data.query('SalesManID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('SalesManID').value('.', 'NVARCHAR(50)') END) AS SalesManID,
		(CASE WHEN X.Data.query('Notes').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Notes').value('.', 'NVARCHAR(250)')END) AS Notes,
		X.Data.query('ObjectID').value('.', 'NVARCHAR(50)') AS ObjectID,
		(CASE WHEN X.Data.query('VATObjectID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('VATObjectID').value('.', 'NVARCHAR(50)') END) AS VATObjectID,
		(CASE WHEN X.Data.query('PriceListID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('PriceListID').value('.', 'NVARCHAR(50)') END) AS PriceListID,
		(CASE WHEN X.Data.query('Address').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Address').value('.', 'NVARCHAR(250)') END) AS [Address],
		(CASE WHEN X.Data.query('VatNo').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('VatNo').value('.', 'NVARCHAR(50)') END) AS VatNo,
		(CASE WHEN X.Data.query('Contact').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Contact').value('.', 'NVARCHAR(100)') END) AS [Contact],
		(CASE WHEN X.Data.query('DeliveryAddress').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('DeliveryAddress').value('.', 'NVARCHAR(250)') END) AS DeliveryAddress,
		(CASE WHEN X.Data.query('PaymentTermID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('PaymentTermID').value('.', 'NVARCHAR(50)') END) AS PaymentTermID,
		(CASE WHEN X.Data.query('Transport').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Transport').value('.', 'NVARCHAR(250)') END) AS Transport,
		(CASE WHEN X.Data.query('PaymentID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('PaymentID').value('.', 'NVARCHAR(50)') END) AS PaymentID,
		(CASE WHEN X.Data.query('BarCode').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('BarCode').value('.', 'NVARCHAR(50)') END) AS BarCode,
		X.Data.query('InventoryID').value('.', 'NVARCHAR(50)') AS InventoryID,
		X.Data.query('UnitID').value('.', 'NVARCHAR(50)') AS UnitID,
		(CASE WHEN X.Data.query('ConvertedQuantity').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ConvertedQuantity').value('.', 'DECIMAL(28,8)') END) AS ConvertedQuantity,
		(CASE WHEN X.Data.query('ConvertedSaleprice').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ConvertedSaleprice').value('.', 'DECIMAL(28,8)') END) AS ConvertedSaleprice,
		(CASE WHEN X.Data.query('OrderQuantity').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('OrderQuantity').value('.', 'DECIMAL(28,8)') END) AS OrderQuantity,
		(CASE WHEN X.Data.query('SalePrice').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('SalePrice').value('.', 'DECIMAL(28,8)') END) AS SalePrice,
		(CASE WHEN X.Data.query('OriginalAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('OriginalAmount').value('.', 'DECIMAL(28,8)') END) AS OriginalAmount,
		(CASE WHEN X.Data.query('ConvertedAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('ConvertedAmount').value('.', 'DECIMAL(28,8)') END) AS ConvertedAmount,
		(CASE WHEN X.Data.query('DiscountPercent').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('DiscountPercent').value('.', 'DECIMAL(28,8)') END) AS DiscountPercent,
		(CASE WHEN X.Data.query('DiscountOriginalAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('DiscountOriginalAmount').value('.', 'DECIMAL(28,8)') END) AS DiscountOriginalAmount,
		(CASE WHEN X.Data.query('DiscountConvertedAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('DiscountConvertedAmount').value('.', 'DECIMAL(28,8)') END) AS DiscountConvertedAmount,
		(CASE WHEN X.Data.query('VATPercent').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('VATPercent').value('.', 'DECIMAL(28,8)') END) AS VATPercent,
		(CASE WHEN X.Data.query('VATOriginalAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('VATOriginalAmount').value('.', 'DECIMAL(28,8)') END) AS VATOriginalAmount,
		(CASE WHEN X.Data.query('VATConvertedAmount').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('VATConvertedAmount').value('.', 'DECIMAL(28,8)') END) AS VATConvertedAmount,
		(CASE WHEN X.Data.query('Finish').value('.', 'VARCHAR(50)') = '' THEN 0 ELSE X.Data.query('Finish').value('.', 'TINYINT') END) AS Finish,
		(CASE WHEN X.Data.query('Description').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Description').value('.', 'NVARCHAR(150)')END) AS [Description],		
		(CASE WHEN X.Data.query('Ana01ID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Ana01ID').value('.', 'NVARCHAR(50)') END) AS Ana01ID,
		(CASE WHEN X.Data.query('Ana02ID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Ana02ID').value('.', 'NVARCHAR(50)') END) AS Ana02ID,
		(CASE WHEN X.Data.query('Ana03ID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Ana03ID').value('.', 'NVARCHAR(50)') END) AS Ana03ID,
		(CASE WHEN X.Data.query('Ana04ID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Ana04ID').value('.', 'NVARCHAR(50)') END) AS Ana04ID,
		(CASE WHEN X.Data.query('Ana05ID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Ana05ID').value('.', 'NVARCHAR(50)') END) AS Ana05ID,
		(CASE WHEN X.Data.query('Ana06ID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Ana06ID').value('.', 'NVARCHAR(50)') END) AS Ana06ID,
		(CASE WHEN X.Data.query('Ana07ID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Ana07ID').value('.', 'NVARCHAR(50)') END) AS Ana07ID,
		(CASE WHEN X.Data.query('Ana08ID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Ana08ID').value('.', 'NVARCHAR(50)') END) AS Ana08ID,
		(CASE WHEN X.Data.query('Ana09ID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Ana09ID').value('.', 'NVARCHAR(50)') END) AS Ana09ID,
		(CASE WHEN X.Data.query('Ana10ID').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Ana10ID').value('.', 'NVARCHAR(50)') END) AS Ana10ID,
		(CASE WHEN X.Data.query('nvarchar01').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('nvarchar01').value('.', 'NVARCHAR(250)') END) AS nvarchar01,
		(CASE WHEN X.Data.query('nvarchar02').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('nvarchar02').value('.', 'NVARCHAR(250)') END) AS nvarchar02,
		(CASE WHEN X.Data.query('nvarchar03').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('nvarchar03').value('.', 'NVARCHAR(250)') END) AS nvarchar03,
		(CASE WHEN X.Data.query('nvarchar04').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('nvarchar04').value('.', 'NVARCHAR(250)') END) AS nvarchar04,
		(CASE WHEN X.Data.query('nvarchar05').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('nvarchar05').value('.', 'NVARCHAR(250)') END) AS nvarchar05,
		(CASE WHEN X.Data.query('nvarchar06').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('nvarchar06').value('.', 'NVARCHAR(250)') END) AS nvarchar06,
		(CASE WHEN X.Data.query('nvarchar07').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('nvarchar07').value('.', 'NVARCHAR(250)') END) AS nvarchar07,
		(CASE WHEN X.Data.query('nvarchar08').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('nvarchar08').value('.', 'NVARCHAR(250)') END) AS nvarchar08,
		(CASE WHEN X.Data.query('nvarchar09').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('nvarchar09').value('.', 'NVARCHAR(250)') END) AS nvarchar09,
		(CASE WHEN X.Data.query('nvarchar10').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('nvarchar10').value('.', 'NVARCHAR(250)') END) AS nvarchar10,
		(CASE WHEN X.Data.query('Varchar01').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Varchar01').value('.', 'NVARCHAR(250)') END) AS varchar01,
		(CASE WHEN X.Data.query('Varchar02').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Varchar02').value('.', 'NVARCHAR(250)') END) AS varchar02,
		(CASE WHEN X.Data.query('Varchar03').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Varchar03').value('.', 'NVARCHAR(250)') END) AS varchar03,
		(CASE WHEN X.Data.query('Varchar04').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Varchar04').value('.', 'NVARCHAR(250)') END) AS varchar04,
		(CASE WHEN X.Data.query('Varchar05').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Varchar05').value('.', 'NVARCHAR(250)') END) AS varchar05,
		(CASE WHEN X.Data.query('Varchar06').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Varchar06').value('.', 'NVARCHAR(250)') END) AS varchar06,
		(CASE WHEN X.Data.query('Varchar07').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Varchar07').value('.', 'NVARCHAR(250)') END) AS varchar07,
		(CASE WHEN X.Data.query('Varchar08').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Varchar08').value('.', 'NVARCHAR(250)') END) AS varchar08,
		(CASE WHEN X.Data.query('Varchar09').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Varchar09').value('.', 'NVARCHAR(250)') END) AS varchar09,
		(CASE WHEN X.Data.query('Varchar10').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('Varchar10').value('.', 'NVARCHAR(250)') END) AS varchar10
INTO	#AP8139							 
FROM	@XML.nodes('//Data') AS X (Data)

INSERT INTO #Data ([Row], DivisionID, Period, VoucherTypeID, VoucherNo, OrderDate, ContractNo, 
ContractDate, CurrencyID, ExchangeRate, ClassifyID, OrderStatus, ShipDate, InventoryTypeID, EmployeeID, 
SalesManID, Notes, ObjectID, VATObjectID,PriceListID, [Address], VatNo, Contact, DeliveryAddress, 
PaymentTermID, Transport, PaymentID, BarCode, InventoryID, UnitID, ConvertedQuantity, ConvertedSalePrice, 
OrderQuantity, SalePrice, OriginalAmount, ConvertedAmount, DiscountPercent, DiscountOriginalAmount, 
DiscountConvertedAmount, VATPercent, VATOriginalAmount, VATConvertedAmount, Finish, [Description], 
Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
nvarchar01, nvarchar02, nvarchar03, nvarchar04, nvarchar05, nvarchar06, nvarchar07, nvarchar08, nvarchar09, nvarchar10,
varchar01, varchar02, varchar03, varchar04, varchar05, varchar06, varchar07, varchar08, varchar09, varchar10)
SELECT * FROM #AP8139
ORDER BY [Row]
---- Kiểm tra check code mặc định
EXEC AP8105 @ImportTemplateID = @ImportTemplateID, @UserID = @UserID
----- Kiểm tra và lưu dữ liệu bảng giá bán
EXEC AP8100 @UserID = @UserID, @ImportTemplateID = @ImportTemplateID, @CheckCode = 'CheckIdenticalValues', @ColID = 'VoucherNo', @Param1 = 'DivisionID, Period, VoucherTypeID, VoucherNo, OrderDate, ContractNo, 
ContractDate, CurrencyID, ExchangeRate, ClassifyID, OrderStatus, ShipDate, InventoryTypeID, EmployeeID, SalesManID, Notes, ObjectID, PriceListID, VATObjectID, [Address], VatNo, Contact, DeliveryAddress, 
PaymentTermID, Transport, PaymentID' 
----- Kiểm tra VoucherID đã tồn tại trong OT2001 (DivisionID, SOrderID)
DECLARE @Cur CURSOR,
		@Row INT,		
		@Period NVARCHAR(50),
		@VoucherNo NVARCHAR(50) 
SET @Cur = CURSOR SCROLL KEYSET FOR
		   SELECT Row, DivisionID, Period, VoucherNo
		   FROM #Data
OPEN @Cur
FETCH NEXT FROM @Cur INTO @Row, @DivisionID, @Period, @VoucherNo
WHILE @@FETCH_STATUS = 0
BEGIN
---- Kiểm tra số chứng từ đã tồn tại
	IF EXISTS (SELECT TOP 1 1 FROM OT2001 WHERE DivisionID = @DivisionID AND SOrderID = @VoucherNo)
	BEGIN		
		UPDATE DT SET 
		ImportMessage = ImportMessage + CASE WHEN ImportMessage != '' THEN '\n' ELSE '' END + 'ASML000084 {0}='''+CONVERT(NVARCHAR,@Row)+''''
		FROM #Data DT
		WHERE DT.Row = @Row			
	END 
	FETCH NEXT FROM @Cur INTO @Row, @DivisionID, @Period, @VoucherNo
END
CLOSE @Cur
-- Nếu có lỗi thì không cần sinh khóa và không đẩy dữ liệu vào
IF EXISTS(SELECT TOP 1 1 FROM #Data WHERE ImportMessage != '')
	GOTO LB_RESULT
--- Xử lý làm tròn dữ liệu vì nhập trên Excel có thể sai
UPDATE		DT
SET			
ConvertedQuantity = ROUND(DT.ConvertedQuantity,OT01.QuantityDecimal),
ConvertedSalePrice = ROUND(DT.ConvertedSalePrice,OT01.UnitPriceDecimal),
OrderQuantity = ROUND(DT.OrderQuantity,OT01.QuantityDecimal),
SalePrice = ROUND(DT.SalePrice,OT01.UnitPriceDecimal),
OriginalAmount = ROUND(DT.OriginalAmount,CUR.OriginalDecimal),
ConvertedAmount = ROUND(DT.ConvertedAmount,OT01.ConvertDecimal),
DiscountPercent = ROUND(DT.DiscountPercent,OT01.PercentDecimal),
DiscountOriginalAmount = ROUND(DT.DiscountOriginalAmount,CUR.OriginalDecimal),
DiscountConvertedAmount = ROUND(DT.DiscountConvertedAmount,OT01.ConvertDecimal),
VATPercent = ROUND(DT.VATPercent,OT01.PercentDecimal),
VATOriginalAmount = ROUND(DT.VATOriginalAmount,CUR.OriginalDecimal),
VATConvertedAmount = ROUND(DT.VATConvertedAmount,OT01.ConvertDecimal)
FROM #Data DT
LEFT JOIN OT0000 OT01 ON OT01.DivisionID = DT.DivisionID
LEFT JOIN AV1004 CUR ON	CUR.DivisionID = DT.DivisionID AND CUR.CurrencyID = DT.CurrencyID 
-- Sinh khoá

DECLARE @cKey AS CURSOR
DECLARE @Orders INT,
	    @TransactionID NVARCHAR(50),
	    @SOrderID NVARCHAR(50),
		@InventoryID NVARCHAR(50),
		@UnitID NVARCHAR(50),
	    @TestID NVARCHAR(50) = ''
SET @cKey = CURSOR SCROLL KEYSET FOR
			SELECT Row,DivisionID, Period, VoucherNo, InventoryID, UnitID
			FROM #Data
OPEN @cKey
FETCH NEXT FROM @cKey INTO @Row, @DivisionID, @Period, @VoucherNo, @InventoryID, @UnitID
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @TestID IS NULL OR @TestID != @VoucherNo
	BEGIN
		SET @Orders = 1
		SET @TransactionID = NEWID()
		SET @SOrderID = @VoucherNo
		SET @TestID = @VoucherNo
	END
	ELSE 
	BEGIN
		SET @Orders = @Orders + 1
		SET @TransactionID = NEWID()
	END
	INSERT INTO #Keys (Row,Orders, SOrderID, TransactionID, VoucherNo, Period,InventoryID, UnitID)
	VALUES (@Row,@Orders, @SOrderID, @TransactionID, @VoucherNo, @Period, @InventoryID, @UnitID)
	FETCH NEXT FROM @cKey INTO @Row, @DivisionID, @Period, @VoucherNo, @InventoryID, @UnitID
END
CLOSE @cKey
----- Cập nhật khoá 
UPDATE DT
SET
	DT.Orders = K.Orders,
	DT.TransactionID = K.TransactionID,
	DT.SOrderID = K.SOrderID
FROM #Data DT
INNER JOIN #Keys K ON K.Row = DT.Row
-- Insert Master 
INSERT INTO OT2001(DivisionID, SOrderID, TranMonth, TranYear, VoucherTypeID, VoucherNo, OrderDate,
            ContractNo, ContractDate, ClassifyID, OrderType, ObjectID, DeliveryAddress, Notes, 
            OrderStatus, CurrencyID, ExchangeRate, InventoryTypeID, EmployeeID, [Disabled], IsConfirm,
            Transport, PaymentID, VatNo, [Address], SalesManID, ShipDate, PaymentTermID, Contact, 
            VATObjectID, PriceListID, CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
SELECT DISTINCT DivisionID, SOrderID, LEFT(Period, 2), RIGHT(Period, 4), VoucherTypeID, VoucherNo, OrderDate,
       ContractNo, ContractDate, ClassifyID, 0, ObjectID, DeliveryAddress, Notes, 
       OrderStatus, CurrencyID, ExchangeRate, InventoryTypeID, EmployeeID, 0,
       CASE WHEN ISNULL(OrderStatus,0) IN (1,2,3,5) THEN 1 ELSE 0 END,
       Transport, PaymentID, VatNo, [Address], SalesManID, ShipDate, PaymentTermID, 
       Contact, VATObjectID, PriceListID, @UserID, GETDATE(), @UserID, GETDATE()
FROM #Data DT
-- Insert Detail
INSERT INTO OT2002(DivisionID, TransactionID, SOrderID, InventoryID, UnitID,
            OrderQuantity, ConvertedQuantity, SalePrice, ConvertedAmount, OriginalAmount, VATPercent,
            VATOriginalAmount, VATConvertedAmount, DiscountPercent, Orders,
            DiscountOriginalAmount, DiscountConvertedAmount, [Description],
            IsPicking, Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID,
            Ana07ID, Ana08ID, Ana09ID, Ana10ID, nvarchar01, nvarchar02, nvarchar03,
            nvarchar04, nvarchar05, nvarchar06, nvarchar07, nvarchar08, nvarchar09,
            nvarchar10, varchar01, varchar02, varchar03, varchar04, varchar05, varchar06, varchar07, 
			varchar08, varchar09, varchar10)
SELECT DivisionID, TransactionID, SOrderID, InventoryID, UnitID, OrderQuantity, ConvertedQuantity, 
	   SalePrice, ConvertedAmount, OriginalAmount, VATPercent, VATOriginalAmount, VATConvertedAmount, 
	   DiscountPercent, Orders, DiscountOriginalAmount, DiscountConvertedAmount, [Description],
	   0, Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, Ana06ID, Ana07ID, Ana08ID, Ana09ID, 
	   Ana10ID, nvarchar01, nvarchar02, nvarchar03, nvarchar04, nvarchar05, nvarchar06, nvarchar07, 
	   nvarchar08, nvarchar09, nvarchar10, varchar01, varchar02, varchar03, varchar04, varchar05, varchar06, varchar07, 
	   varchar08, varchar09, varchar10
FROM #Data DT

-----------------------------------------------------------------------------------------
LB_RESULT:
SELECT * FROM #Data

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON