IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0026]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0026]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Import excel đơn hàng bán (mẫu customize cho HYUNDAE)
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 12/05/2014
---- Modified on 
-- <Example>
/*
	OP0026 'HD', '', '',''
*/
CREATE PROCEDURE OP0026
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@ImportTemplateID NVARCHAR(50),
	@Xml XML
)
AS
DECLARE @DataCol VARCHAR(50),
		@Cur CURSOR,
		@Row INT,
		@VoucherNo VARCHAR(50),
		@S01 VARCHAR(50),
		@S02 VARCHAR(50),
		@S03 VARCHAR(50),
		@S04 VARCHAR(50),
		@S05 VARCHAR(50),
		@S06 VARCHAR(50),
		@S07 VARCHAR(50),
		@S08 VARCHAR(50),
		@InventoryID VARCHAR(50),
		@Ana01ID VARCHAR(50),
		@Ana02ID VARCHAR(50),
		@VoucherTypeID VARCHAR(50),
		@TranMonth INT,
		@TranYear INT,
		@OrderDate DATETIME,
		@ObjectID VARCHAR(50),
		@PriceListID VARCHAR(50)

CREATE TABLE #Data
(
	[Row] INT,
	TransactionID VARCHAR(50),
	DivisionID VARCHAR(50),
	Period VARCHAR(10),
	TranMonth INT,
	TranYear INT,
	VoucherID VARCHAR(50),
	Ana01ID VARCHAR(50),
	OrderDate DATETIME,
	VoucherTypeID VARCHAR(50),
	VoucherNo VARCHAR(50),
	ContractNo  VARCHAR(50),
	S01 VARCHAR(50),
	ObjectID VARCHAR(50),
	PriceListID VARCHAR(50),
	InventoryID VARCHAR(50),
	S02 VARCHAR(50),
	S03 VARCHAR(50),
	[Description] NVARCHAR(250),
	Notes NVARCHAR(250),
	Notes01 NVARCHAR(250),
	S04 VARCHAR(50),
	S05 VARCHAR(50),
	S06 VARCHAR(50),
	S07 VARCHAR(50),
	S08 VARCHAR(50),
	Notes02 NVARCHAR(250),
	YDQuantity DECIMAL(28,8),
	OrderQuantity DECIMAL(28,8),	
	nvarchar01 NVARCHAR(100),
	nvarchar02 NVARCHAR(100),
	Transport NVARCHAR(250),
	DiscountPercent DECIMAL(28,8),
	SalePrice DECIMAL(28,8),
	OriginalAmount DECIMAL(28,8),
	nvarchar03 NVARCHAR(100),
	Ana02ID VARCHAR(50),
	nvarchar04 NVARCHAR(100),
	nvarchar05 NVARCHAR(100),
	nvarchar06 NVARCHAR(100),
	nvarchar07 NVARCHAR(100),
	nvarchar11 NVARCHAR(100),
	nvarchar10 NVARCHAR(100),
	nvarchar08 NVARCHAR(100),
	nvarchar09 NVARCHAR(100),
	Contact NVARCHAR(250),
	DeliveryAddress NVARCHAR(250),
	ImportMessage NVARCHAR(500)	
)
INSERT INTO #Data (Row, TransactionID, DivisionID, Period, TranMonth, TranYear, VoucherID, Ana01ID, OrderDate, VoucherTypeID,
	VoucherNo, ContractNo, S01, ObjectID, PriceListID, InventoryID, S02, S03, [Description], Notes, Notes01, S04, S05, S06, S07,
	S08, Notes02, YDQuantity, OrderQuantity, nvarchar01, nvarchar02, Transport, DiscountPercent, SalePrice, OriginalAmount,
	nvarchar03, Ana02ID, nvarchar04, nvarchar05, nvarchar06, nvarchar07, nvarchar11, nvarchar10, nvarchar08, nvarchar09,
	Contact, DeliveryAddress, ImportMessage)    		
SELECT	X.Data.query('Row').value('.', 'INT') Row,
		NEWID() TransactionID,
		X.Data.query('DivisionID').value('.', 'VARCHAR(50)') DivisionID,		
		X.Data.query('Period').value('.', 'VARCHAR(10)') Period,
		CONVERT(INT,LEFT(X.Data.query('Period').value('.','VARCHAR(10)'),2)) AS TranMonth,
		CONVERT(INT,RIGHT(X.Data.query('Period').value('.','VARCHAR(10)'),4)) AS TranYear,
		X.Data.query('VoucherNo').value('.', 'VARCHAR(50)') VoucherID,
		X.Data.query('Ana01ID').value('.', 'VARCHAR(50)') Ana01ID,
		CASE WHEN X.Data.query('OrderDate').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('OrderDate').value('.', 'VARCHAR(50)') END OrderDate,
		X.Data.query('VoucherTypeID').value('.', 'VARCHAR(50)') VoucherTypeID,
		X.Data.query('VoucherNo').value('.', 'VARCHAR(50)') VoucherNo,
		X.Data.query('ContractNo').value('.', 'VARCHAR(50)') ContractNo,
		X.Data.query('S01').value('.', 'VARCHAR(50)') S01,
		X.Data.query('ObjectID').value('.', 'VARCHAR(50)') ObjectID,
		X.Data.query('PriceListID').value('.', 'VARCHAR(50)') PriceListID,
		X.Data.query('InventoryID').value('.', 'VARCHAR(50)') InventoryID,
		X.Data.query('S02').value('.', 'VARCHAR(50)') S02,
		X.Data.query('S03').value('.', 'VARCHAR(50)') S03,
		X.Data.query('Description').value('.', 'NVARCHAR(250)') [Description],
		X.Data.query('Notes').value('.', 'NVARCHAR(250)') Notes,
		X.Data.query('Notes01').value('.', 'NVARCHAR(250)') Notes01,
		X.Data.query('S04').value('.', 'VARCHAR(50)') S04,
		X.Data.query('S05').value('.', 'VARCHAR(50)') S05,
		X.Data.query('S06').value('.', 'VARCHAR(50)') S06,
		X.Data.query('S07').value('.', 'VARCHAR(50)') S07,
		X.Data.query('S08').value('.', 'VARCHAR(50)') S08,
		X.Data.query('Notes02').value('.', 'NVARCHAR(250)') Notes02,
		(CASE WHEN X.Data.query('YDQuantity').value('.', 'VARCHAR(50)') = '' THEN NULL ELSE X.Data.query('YDQuantity').value('.', 'DECIMAL(28,8)') END) AS YDQuantity,		
		(CASE WHEN X.Data.query('OrderQuantity').value('.', 'VARCHAR(50)') = '' THEN -1 ELSE X.Data.query('OrderQuantity').value('.', 'DECIMAL(28,8)') END) AS OrderQuantity,
		X.Data.query('nvarchar01').value('.', 'NVARCHAR(100)') nvarchar01,
		X.Data.query('nvarchar02').value('.', 'NVARCHAR(100)') nvarchar02,
		X.Data.query('Transport').value('.', 'NVARCHAR(250)') Transport,
		(CASE WHEN X.Data.query('DiscountPercent').value('.', 'VARCHAR(50)') = '' THEN -1 ELSE X.Data.query('DiscountPercent').value('.', 'DECIMAL(28,8)') END) AS DiscountPercent,
		(CASE WHEN X.Data.query('SalePrice').value('.', 'VARCHAR(50)') = '' THEN -1 ELSE X.Data.query('SalePrice').value('.', 'DECIMAL(28,8)') END) AS SalePrice,
		0 OriginalAmount,
		X.Data.query('nvarchar03').value('.', 'NVARCHAR(100)') nvarchar03,
		X.Data.query('Ana02ID').value('.', 'VARCHAR(50)') Ana02ID,
		X.Data.query('nvarchar04').value('.', 'NVARCHAR(100)') nvarchar04,
		X.Data.query('nvarchar05').value('.', 'NVARCHAR(100)') nvarchar05,
		X.Data.query('nvarchar06').value('.', 'NVARCHAR(100)') nvarchar06,
		X.Data.query('nvarchar07').value('.', 'NVARCHAR(100)') nvarchar07,
		X.Data.query('nvarchar11').value('.', 'NVARCHAR(100)') nvarchar11,	
		X.Data.query('nvarchar10').value('.', 'NVARCHAR(100)') nvarchar10,
		X.Data.query('nvarchar08').value('.', 'NVARCHAR(100)') nvarchar08,
		X.Data.query('nvarchar09').value('.', 'NVARCHAR(100)') nvarchar09,
		X.Data.query('Contact').value('.', 'NVARCHAR(250)') Contact,
		X.Data.query('DeliveryAddress').value('.', 'NVARCHAR(250)') DeliveryAddress,
		'' ImportMessage
FROM @Xml.nodes('//Data') AS X (Data)

----- Kiểm tra dữ liệu
---- Kiểm tra DivisionID
IF (SELECT TOP 1 DivisionID FROM #Data) <> @DivisionID
BEGIN
	SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'DivisionID')
	UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol
END

---- Kiểm tra kỳ kế toán
IF (SELECT TOP 1 Period FROM #Data) NOT IN (SELECT MonthYear FROM OV9999)
BEGIN	
	SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'Period')
	UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'ASML000072 {0}=' + @DataCol
END

SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT Row, VoucherNo, S01, S02, S03, S04, S05, S06, S07, S08, InventoryID, Ana01ID, Ana02ID, VoucherTypeID,
	TranMonth, TranYear, OrderDate, ObjectID, PriceListID
FROM #Data

OPEN @Cur
FETCH NEXT FROM @Cur INTO @Row, @VoucherNo, @S01, @S02, @S03, @S04, @S05, @S06, @S07, @S08, @InventoryID, @Ana01ID, @Ana02ID, @VoucherTypeID,
	@TranMonth, @TranYear, @OrderDate, @ObjectID, @PriceListID
WHILE @@FETCH_STATUS = 0
BEGIN
	---- Kiểm tra dữ liệu không đồng nhất tại phần master
		
	IF (SELECT COUNT(*) FROM
			(
				SELECT DISTINCT DivisionID, VoucherID, VoucherTypeID, VoucherNo, OrderDate, ContractNo, ObjectID,
					TranMonth, TranYear, PriceListID, Transport
				FROM #Data WHERE VoucherNo = @VoucherNo
			)A
		) <> 1	
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'VoucherNo')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'ASML000083 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END

	---- Kiểm tra tồn tại loại chứng từ
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1007 WHERE DivisionID = @DivisionID AND VoucherTypeID = @VoucherTypeID)
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'VoucherTypeID')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END	

	---- Kiểm tra tồn tại số chứng từ
	IF EXISTS (SELECT TOP 1 1 FROM OT2001 WHERE DivisionID = @DivisionID AND VoucherNo = @VoucherNo)
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'VoucherNo')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000231 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END	

	---- Kiểm tra hợp lệ ngày chứng từ
	IF (@OrderDate < (SELECT TOP 1 BeginDate FROM OT9999 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear)
		AND @OrderDate > (SELECT TOP 1 EndDate FROM OT9999 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear))
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'OrderDate')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000029 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END
	
	---- Kiểm tra tồn tại danh mục khách hàng
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1202 WHERE DivisionID = @DivisionID AND ObjectID = @ObjectID AND IsCustomer = 1)
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'ObjectID')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END	
	---- Kiểm tra tồn tại mã bảng giá theo từng khách hàng
	CREATE TABLE #Price (PriceListID VARCHAR(50), PriceListName NVARCHAR(250))
	INSERT INTO #Price EXEC OP1304 @DivisionID, @ObjectID, @OrderDate, 0
	IF NOT EXISTS (SELECT TOP 1 1 FROM #Price WHERE PriceListID = @PriceListID)
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'PriceListID')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000233 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END	
	DROP TABLE #Price

	---- Kiểm tra tồn mã phân tích quy cách
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT0128 WHERE DivisionID = @DivisionID AND StandardID = @S01 AND StandardTypeID = 'S01') AND @S01 <> ''
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'S01')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT0128 WHERE DivisionID = @DivisionID AND StandardID = @S02 AND StandardTypeID = 'S02') AND @S02 <> ''
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'S02')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT0128 WHERE DivisionID = @DivisionID AND StandardID = @S03 AND StandardTypeID = 'S03') AND @S03 <> ''
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'S03')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT0128 WHERE DivisionID = @DivisionID AND StandardID = @S04 AND StandardTypeID = 'S04') AND @S04 <> ''
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'S04')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT0128 WHERE DivisionID = @DivisionID AND StandardID = @S05 AND StandardTypeID = 'S05') AND @S05 <> ''
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'S05')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT0128 WHERE DivisionID = @DivisionID AND StandardID = @S06 AND StandardTypeID = 'S06') AND @S06 <> ''
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'S06')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT0128 WHERE DivisionID = @DivisionID AND StandardID = @S07 AND StandardTypeID = 'S07') AND @S07 <> ''
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'S07')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT0128 WHERE DivisionID = @DivisionID AND StandardID = @S08 AND StandardTypeID = 'S08') AND @S08 <> ''
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'S08')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END
	---- Kiểm tra tồn mã hàng
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1302 WHERE DivisionID = @DivisionID AND InventoryID = @InventoryID)
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'InventoryID')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END	
	---- Kiểm tra tồn mã phân tích	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE DivisionID = @DivisionID AND AnaID = @Ana01ID AND AnaTypeID = 'A01') AND @Ana01ID <> ''
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'Ana01ID')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END
	
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE DivisionID = @DivisionID AND AnaID = @Ana02ID AND AnaTypeID = 'A02') AND @Ana02ID <> ''
	BEGIN
		SET @DataCol = (SELECT TOP 1 DataCol FROM A00065 WHERE ImportTransTypeID = @ImportTemplateID AND ColID = 'Ana02ID')
		UPDATE #Data SET ImportMessage = ISNULL(ImportMessage,'') + '\n' + 'OFML000232 {0}=' + @DataCol+ LTRIM(STR(@Row))
		WHERE Row = @Row
	END

	FETCH NEXT FROM @Cur INTO @Row, @VoucherNo, @S01, @S02, @S03, @S04, @S05, @S06, @S07, @S08, @InventoryID, @Ana01ID, @Ana02ID, @VoucherTypeID,
		@TranMonth, @TranYear, @OrderDate, @ObjectID, @PriceListID
END
CLOSE @Cur

IF NOT EXISTS (SELECT TOP 1 1 FROM #Data WHERE ISNULL(ImportMessage,'') <> '') -- nếu dữ liệu không có lỗi
BEGIN
	---- Lấy dữ liệu từ thiết lập mặc định
	DECLARE @CurrenyID VARCHAR(50),
			@ExchangeRate DECIMAL(28,8),
			@QuantityDecimal TINYINT = 0,
			@UnitPriceDecimal TINYINT = 0
		
	SELECT @QuantityDecimal = ISNULL(QuantityDecimal,0), @UnitPriceDecimal = ISNULL(UnitPriceDecimal,0) FROM OT0000 WHERE DivisionID = @DivisionID
	
	SELECT @CurrenyID = O01.CurrencyID, @ExchangeRate = A04.ExchangeRate
	FROM OT0001 O01
	LEFT JOIN AT1004 A04 ON A04.DivisionID = O01.DivisionID AND A04.CurrencyID = O01.CurrencyID
	WHERE O01.DivisionID = @DivisionID AND O01.TypeID = 'SO'
	
	-- Lưu dữ liệu vào bảng master OT2001
	INSERT INTO OT2001 (APK, DivisionID, SOrderID, VoucherTypeID, VoucherNo, 
		OrderDate, ContractNo, OrderType, ObjectID, DeliveryAddress, Notes,
		[Disabled], OrderStatus, CurrencyID, ExchangeRate, InventoryTypeID,
		TranMonth, TranYear, EmployeeID, PaymentTermID, Contact, Transport,
		VATObjectID, VATObjectName, IsInherit, IsConfirm, PriceListID, IsSalesCommission)
		            
	SELECT NEWID(), DivisionID, VoucherID, VoucherTypeID, VoucherNo,
		OrderDate, ContractNo, 0, ObjectID, 
		CASE WHEN DeliveryAddress <> '' THEN DeliveryAddress ELSE (SELECT TOP 1 DeAddress FROM AT1202 WHERE DivisionID = @DivisionID AND ObjectID = A.ObjectID) END,
		N'Đơn hàng bán - Nhập từ excel', 0, 1, @CurrenyID, @ExchangeRate, '%', TranMonth, TranYear, @UserID, 
		(SELECT TOP 1 RePaymentTermID FROM AT1202 WHERE DivisionID = @DivisionID AND ObjectID = A.ObjectID),		
		CASE WHEN Contact <> '' THEN Contact ELSE (SELECT TOP 1 Contactor FROM AT1202 WHERE DivisionID = @DivisionID AND ObjectID = A.ObjectID) END,		
		Transport, ObjectID, (SELECT TOP 1 ObjectName FROM AT1202 WHERE DivisionID = @DivisionID AND ObjectID = A.ObjectID), 0,
		0, PriceListID, 0
	FROM
	(
		SELECT DISTINCT DivisionID, VoucherID, VoucherTypeID, VoucherNo, OrderDate, ContractNo, ObjectID,
			TranMonth, TranYear, PriceListID, Transport, Contact, DeliveryAddress
		FROM #Data
	)A

	---- Lưu dữ liệu vào bảng quy cách module OP OT8899
	INSERT INTO OT8899 (DivisionID, VoucherID, TransactionID, TableID,
		S01ID, S02ID, S03ID, S04ID, S05ID, S06ID, S07ID, S08ID,
	    SUnitPrice01, SUnitPrice02, SUnitPrice03, SUnitPrice04, SUnitPrice05, SUnitPrice06, SUnitPrice07, SUnitPrice08, UnitPriceStandard)
	SELECT DATA.DivisionID, DATA.VoucherID, DATA.TransactionID, 'OT2001',
		 DATA.S01, DATA.S02, DATA.S03, DATA.S04, DATA.S05, DATA.S06, DATA.S07, DATA.S08,
	    ISNULL(V01.UnitPrice,0) SUnitPrice01, ISNULL(V02.UnitPrice,0) SUnitPrice02, ISNULL(V03.UnitPrice,0) SUnitPrice03,
	    ISNULL(V04.UnitPrice,0) SUnitPrice04, ISNULL(V05.UnitPrice,0) SUnitPrice05, ISNULL(V06.UnitPrice,0) SUnitPrice06,
	    ISNULL(V07.UnitPrice,0) SUnitPrice07, ISNULL(V08.UnitPrice,0) SUnitPrice08, O02.UnitPrice
	FROM #Data DATA
	LEFT JOIN OT1302 O02 ON O02.DivisionID = DATA.DivisionID AND O02.InventoryID = DATA.InventoryID AND O02.ID = DATA.PriceListID
	LEFT JOIN AV0026 V01 ON V01.PriceID = DATA.PriceListID AND V01.StandardID = DATA.S01 AND (V01.InventoryID = DATA.InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S01') = 1)
	LEFT JOIN AV0026 V02 ON V02.PriceID = DATA.PriceListID AND V02.StandardID = DATA.S02 AND (V02.InventoryID = DATA.InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S02') = 1)
	LEFT JOIN AV0026 V03 ON V03.PriceID = DATA.PriceListID AND V03.StandardID = DATA.S03 AND (V03.InventoryID = DATA.InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S03') = 1)
	LEFT JOIN AV0026 V04 ON V04.PriceID = DATA.PriceListID AND V04.StandardID = DATA.S04 AND (V04.InventoryID = DATA.InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S04') = 1)
	LEFT JOIN AV0026 V05 ON V05.PriceID = DATA.PriceListID AND V05.StandardID = DATA.S05 AND (V05.InventoryID = DATA.InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S05') = 1)
	LEFT JOIN AV0026 V06 ON V06.PriceID = DATA.PriceListID AND V06.StandardID = DATA.S06 AND (V06.InventoryID = DATA.InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S06') = 1)
	LEFT JOIN AV0026 V07 ON V07.PriceID = DATA.PriceListID AND V07.StandardID = DATA.S07 AND (V07.InventoryID = DATA.InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S07') = 1)
	LEFT JOIN AV0026 V08 ON V08.PriceID = DATA.PriceListID AND V08.StandardID = DATA.S08 AND (V08.InventoryID = DATA.InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S08') = 1)
	
	---- Tính lại giá cho khách hàng KHK
	IF EXISTS (SELECT TOP 1 1 FROM #Data WHERE ObjectID LIKE 'KHK%')
	BEGIN
		CREATE TABLE #SalesPrice (SalesPrice DECIMAL(28,8))
		DECLARE @Cur1 CURSOR, @Row1 INT, @InventoryID1 VARCHAR(50), @Quantity DECIMAL(28,8), @PriceID VARCHAR(50),
				@S04ID VARCHAR(50), @S05ID VARCHAR(50), @S06ID VARCHAR(50), @S07ID VARCHAR(50), @S08ID VARCHAR(50)
				
		SET @Cur1 = CURSOR SCROLL KEYSET FOR
		SELECT Row, InventoryID, PriceListID, OrderQuantity, S04, S05, S06, S07, S08
		FROM #Data
		WHERE ObjectID LIKE 'KHK%'
		
		OPEN @Cur1
		FETCH NEXT FROM @Cur1 INTO @Row1, @InventoryID1, @PriceID, @Quantity, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE #SalesPrice
			INSERT INTO #SalesPrice (SalesPrice)
			EXEC AP0134_1 @DivisionID = @DivisionID, @UserID = @UserID, @InventoryID = @InventoryID1, @Quantity = @Quantity, @PriceID = @PriceID,
				@S04 = @S04ID, @S05 = @S05ID, @S06 = @S06ID, @S07 = @S07ID, @S08 = @S08
			UPDATE #Data SET SalePrice = (SELECT TOP 1 SalesPrice FROM #SalesPrice) WHERE [Row] = @Row1 AND SalePrice = -1                   	
			
			FETCH NEXT FROM @Cur1 INTO @Row1, @InventoryID1, @PriceID, @Quantity, @S04ID, @S05ID, @S06ID, @S07ID, @S08ID
		END		
	END
	
	---- Lưu dữ liệu vào bảng detail OT2002
	
	
	INSERT INTO OT2002 (APK, DivisionID, TransactionID, SOrderID, InventoryID, YDQuantity,
	    OrderQuantity, SalePrice, OriginalAmount, ConvertedAmount,	        
	    DiscountPercent, Orders,  DiscountOriginalAmount, DiscountConvertedAmount,
	    IsPicking, [Description], Ana01ID, Ana02ID, UnitID,
		Notes, Notes01, Notes02, nvarchar01, nvarchar02, nvarchar03, nvarchar04, nvarchar05, nvarchar06, nvarchar07, nvarchar08, nvarchar09, nvarchar10, Varchar01)
	
	SELECT NEWID(), DivisionID, TransactionID, VoucherID, InventoryID, YDQuantity,
		OrderQuantity, SalePrice, OrderQuantity * SalePrice, OrderQuantity * SalePrice * @ExchangeRate,
		DiscountPercent, [Row], OrderQuantity * SalePrice * DiscountPercent / 100, OrderQuantity * SalePrice * @ExchangeRate * DiscountPercent / 100,
		IsPicking, [Description], Ana01ID, Ana02ID, UnitID,
		Notes, Notes01, Notes02, nvarchar01, nvarchar02, nvarchar03, nvarchar04, nvarchar05, nvarchar06, nvarchar07, nvarchar08, nvarchar09, nvarchar10, nvarchar11
	FROM
	(	
		SELECT DATA.DivisionID, DATA.TransactionID, DATA.VoucherID, DATA.InventoryID, ISNULL(DATA.YDQuantity,0) YDQuantity,
			ROUND((CASE WHEN DATA.OrderQuantity < 0 THEN ISNULL(DATA.YDQuantity,0) * 0.9144 ELSE DATA.OrderQuantity END), @QuantityDecimal) OrderQuantity,		
			ROUND((CASE WHEN DATA.ObjectID LIKE 'KHK%' OR DATA.SalePrice <> -1 THEN DATA.SalePrice ELSE A.SalePrice END), @UnitPriceDecimal) SalePrice,
			(CASE WHEN DATA.DiscountPercent < 0 THEN (SELECT TOP 1 DiscountPercent FROM OT1302 WHERE DivisionID = DATA.DivisionID AND ID = DATA.PriceListID AND InventoryID = DATA.InventoryID) ELSE DATA.DiscountPercent END) DiscountPercent,		
			DATA.[Row],
			0 IsPicking, [Description], Ana01ID, DATA.Ana02ID, (SELECT TOP 1 UnitID FROM AT1302 WHERE DivisionID = @DivisionID AND InventoryID = DATA.InventoryID) UnitID,
			Notes, Notes01, Notes02, nvarchar01, nvarchar02, nvarchar03, nvarchar04, nvarchar05, nvarchar06, nvarchar07, nvarchar08, nvarchar09, nvarchar10, nvarchar11
		FROM #Data DATA
		LEFT JOIN 
		(
			SELECT TransactionID, UnitPriceStandard,
			ISNULL(SUnitPrice01, 0) + ISNULL(SUnitPrice02, 0) + ISNULL(SUnitPrice03, 0) + ISNULL(SUnitPrice04, 0) + ISNULL(SUnitPrice05, 0) +
			ISNULL(SUnitPrice06, 0) + ISNULL(SUnitPrice07, 0) + ISNULL(SUnitPrice08, 0) + ISNULL(SUnitPrice09, 0) + ISNULL(SUnitPrice10, 0) + 
			ISNULL(SUnitPrice11, 0) + ISNULL(SUnitPrice12, 0) + ISNULL(SUnitPrice13, 0) + ISNULL(SUnitPrice14, 0) + ISNULL(SUnitPrice15, 0) + 
			ISNULL(SUnitPrice16, 0) + ISNULL(SUnitPrice17, 0) + ISNULL(SUnitPrice18, 0) + ISNULL(SUnitPrice19, 0) + ISNULL(SUnitPrice20, 0) + UnitPriceStandard SalePrice
			FROM OT8899
		)A ON A.TransactionID = DATA.TransactionID
	)B
    
END
SELECT * FROM #Data
  
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
