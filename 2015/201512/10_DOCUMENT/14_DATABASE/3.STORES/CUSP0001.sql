IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[CUSP0001]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[CUSP0001]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Dong Quang
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 04/08/2011 by Le Thi Thu Hien
---- 
---- Modified on 26/10/2011 by Le Thi Thu Hien : Bo sung Agent
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh
-- <Example>
----

CREATE PROCEDURE [dbo].[CUSP0001] 
	@xml XML,
	@DivisionID nvarchar(50),
	@UserID NVARCHAR(50),
	@VoucherTypeID NVARCHAR(50),
	@Action AS INT
AS

DECLARE @sql nvarchar(4000),
		@Ana01ID AS NVARCHAR(50)

CREATE TABLE #Loi
	(
		STATUS INT,
		MessageError NVARCHAR(250)
	)
	
	INSERT INTO #Loi
	VALUES ( 0, N'Save successfully!')
IF NOT @xml IS NULL
BEGIN
	DECLARE @CUST0001 table 
	(
		ContractID NVARCHAR(50),
		ContractDate DATETIME,
		Notes NVARCHAR(250),
		ObjectName NVARCHAR(250),
		InventoryName NVARCHAR(250),
		OriginalAmount DECIMAL(28,8),
		PaymentID NVARCHAR(50),
		PaymentTermID NVARCHAR(50),
		OrderQuantity DECIMAL(28,8),
		SalesPrice DECIMAL(28,8),
		ObjectID NVARCHAR(50),
		VATNo NVARCHAR(50),
		[Address] NVARCHAR(250),
		AgentID NVARCHAR(50),
		AgentName NVARCHAR(250),
		AgentAddress NVARCHAR(250),
		CurrencyID NVARCHAR(50)

	);
		
	SET ARITHABORT ON

	INSERT INTO @CUST0001 (ContractID,ContractDate, Notes, ObjectName, InventoryName, OriginalAmount, PaymentID,
							PaymentTermID,OrderQuantity,SalesPrice,ObjectID, VATNo,[Address], AgentID, AgentName, AgentAddress, CurrencyID)	
	SELECT DISTINCT *
	FROM (
	SELECT 	X.CUST0001.query('ContractID').value('.','nvarchar(50)') AS ContractID
		  ,	X.CUST0001.query('ContractDate').value('.','datetime') AS ContractDate
		  , X.CUST0001.query('Notes').value('.','nvarchar(250)') AS Notes -- INVOICENO
		  , X.CUST0001.query('ObjectName').value('.','nvarchar(250)') AS ObjectName
		  , X.CUST0001.query(N'InventoryName').value(N'.',N'nvarchar(250)') AS InventoryName
		  , X.CUST0001.query('OriginalAmount').value('.','decimal(28,8)') AS OriginalAmount
		  , X.CUST0001.query('PaymentID').value('.','nvarchar(50)') AS PaymentID
		  , X.CUST0001.query('PaymentTermID').value('.','nvarchar(50)') AS PaymentTermID
		  , X.CUST0001.query('OrderQuantity').value('.','decimal(28,8)') AS OrderQuantity
		  , X.CUST0001.query('SalesPrice').value('.','decimal(28,8)') AS SalesPrice
		  , X.CUST0001.query('ObjectID').value('.','nvarchar(50)') AS ObjectID
		  , X.CUST0001.query('VATNo').value('.','nvarchar(50)') AS VATNo
		  , X.CUST0001.query('Address').value('.','nvarchar(250)') AS Address
		  , X.CUST0001.query('AgentID').value('.','nvarchar(50)') AS AgentID
		  , X.CUST0001.query('AgentName').value('.','nvarchar(250)') AS AgentName
		  , X.CUST0001.query('AgentAddress').value('.','nvarchar(250)') AS AgentAddress
		  , X.CUST0001.query('CurrencyID').value('.','nvarchar(50)') AS CurrencyID
		  
	FROM @xml.nodes('//CUST0001') AS X(CUST0001)
	) AS XX
	
	SET ARITHABORT OFF

	-- Nếu không có dữ liệu thì không xử lý tiếp
	IF(SELECT COUNT(*) FROM @CUST0001) = 0 GOTO Exist


DECLARE @OrderCur AS cursor,	
		@QuantityDecimals  AS tinyint,
		@UnitCostDecimals  AS tinyint, 
		@ConvertedDecimals AS tinyint

SELECT	@QuantityDecimals = QuantityDecimals, 
		@UnitCostDecimals = UnitCostDecimals, 
		@ConvertedDecimals = ConvertedDecimals
FROM	AT1101
WHERE DivisionID = @DivisionID

SET @QuantityDecimals =isnull( @QuantityDecimals,2)
SET @UnitCostDecimals = isnull( @UnitCostDecimals,2)
SET @ConvertedDecimals = isnull( @ConvertedDecimals,2)

IF @Action = 2 OR @Action = 3
BEGIN
	IF EXISTS (SELECT TOP 1 1 FROM AT9000 WHERE LEFT(Ana01ID,CHARINDEX('_', Ana01ID+'_')-1) IN (SELECT ContractID FROM @CUST0001))
	BEGIN
		UPDATE #Loi
		SET [STATUS] = 0,
			MessageError = N'This Contract used ASOFT-T. You are not Edit/Delete.'
		GOTO LB_RESULT1
	END 
END
	
IF @Action = 2
BEGIN
	DELETE FROM OT2001 WHERE SOrderID IN (SELECT ContractID FROM @CUST0001)  
	DELETE FROM OT2002 WHERE SOrderID IN (SELECT ContractID FROM @CUST0001) 
END


------Nếu là DELETE thì thực hiện DELETE hết dữ liệu
IF @Action = 3
BEGIN
	DELETE FROM OT2001 WHERE SOrderID IN (SELECT ContractID FROM @CUST0001)
	DELETE FROM OT2002 WHERE SOrderID IN (SELECT ContractID FROM @CUST0001)

	UPDATE #Loi
	SET [STATUS] = 0,
		MessageError = N'Delete successfully.'
	GOTO LB_RESULT1
END	

SET NOCOUNT ON 


-- Bat dau Import
 
DECLARE @ContractID NVARCHAR(50),
		@ContractDate DATETIME,
		@Notes NVARCHAR(250),
		@ObjectName NVARCHAR(250),
		@InventoryName NVARCHAR(250),
		@OriginalAmount DECIMAL(28,8),
		@PaymentID NVARCHAR(50),
		@PaymentTermID NVARCHAR(50),
		@OrderQuantity DECIMAL(28,8),
		@SalesPrice DECIMAL(28,8),
		@ObjectID NVARCHAR(50),
		@VATNo NVARCHAR(50),
		@Address NVARCHAR(250),
		@AgentID NVARCHAR(50),
		@AgentName NVARCHAR(250),
		@AgentAddress NVARCHAR(250),
		@CurrencyID NVARCHAR(50),
		@TransactionID NVARCHAR(50),
		@TranMonth INT,
		@TranYear INT,
		@ExchangeRate DECIMAL(28,8),
		@Operator INT,
		@InventoryID NVARCHAR(50)
		
------ Nếu la EDIT thì thực hiện DELETE / INSERT


	
SET @OrderCur = cursor static for
SELECT	ContractID, ContractDate, Notes, ObjectName, InventoryName,OriginalAmount,
		PaymentID, PaymentTermID,OrderQuantity,SalesPrice,ObjectID,
		VATNo,Address,AgentID, AgentName, AgentAddress, CurrencyID
FROM	@CUST0001
 
BEGIN TRAN
OPEN @OrderCur
FETCH NEXT FROM @OrderCur INTO	@ContractID, @ContractDate, @Notes, @ObjectName, @InventoryName,@OriginalAmount,
								@PaymentID, @PaymentTermID,@OrderQuantity,@SalesPrice,@ObjectID,
								@VATNo,@Address,@AgentID, @AgentName, @AgentAddress, @CurrencyID
WHILE @@Fetch_Status = 0
BEGIN
	
	IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1302 WHERE InventoryName = @InventoryName)
		BEGIN
			UPDATE #Loi
			SET [STATUS] = 1,
				MessageError = N'This InventoryName : '+@InventoryName +' not in list. You create Inventory.'
			GOTO LB_RESULT
		END
	ELSE
		BEGIN
			SET @InventoryID = (SELECT TOP 1 InventoryID FROM AT1302 WHERE InventoryName = @InventoryName)
		END
	
	----- INSERT Phương thức thanh toán PaymentID 
	IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1205 WHERE PaymentID = @PaymentID)
	BEGIN
		INSERT INTO AT1205 ( DivisionID, PaymentID, PaymentName)
		VALUES(@DivisionID, @PaymentID, @PaymentID)
	END
	----- INSERT Phương thức thanh toán PaymentTermID 
	IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1208 WHERE PaymentTermID = @PaymentTermID)
	BEGIN
		INSERT INTO AT1208 ( DivisionID, PaymentTermID, PaymentTermName)
		VALUES(@DivisionID, @PaymentTermID, @PaymentTermID)
	END
	----- INSERT Loại phiếu
	IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1007 WHERE VoucherTypeID = @VoucherTypeID)
	BEGIN
		INSERT INTO AT1007
		(
			DivisionID,		VoucherTypeID,		VoucherTypeName,
			CreateUserID,	CreateDate,			LastModifyUserID,		LastModifyDate
		
		)
		VALUES
		(
			@DivisionID,	@VoucherTypeID,		N'SalesVoucherType',
			@UserID,		GETDATE(),			@UserID,				GETDATE()
		)
	END
		
	----- INSERT HOP DONG VAO KHOAN MUC 1
	IF @Notes <> ''
	SET @Ana01ID = @ContractID+'_'+@Notes
	ELSE
	SET @Ana01ID = @ContractID
		
	IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1011 WHERE AnaTypeID = 'A01' AND AnaID = @Ana01ID)
	BEGIN
		INSERT INTO AT1011
		(
			DivisionID,			AnaID,						AnaTypeID,
			CreateDate,			CreateUserID,				LastModifyUserID,		LastModifyDate

		)
		VALUES
		(
			@DivisionID,		@Ana01ID,					'A01',
			GETDATE(),			@UserID,					@UserID,				GETDATE()
		)
	END

	-------INSERT HOA DON VAO KHOAN MUC 2
	--- + vào chung khoản mục 1
	--IF NOT EXISTS (SELECT TOP 1 1 FROM AT1011 WHERE AnaTypeID = 'A02' AND AnaID = @Notes)
	--BEGIN
	--	INSERT INTO AT1011
	--	(
	--		DivisionID,			AnaID,				AnaTypeID,
	--		CreateDate,			CreateUserID,		LastModifyUserID,		LastModifyDate

	--	)
	--	VALUES
	--	(
	--		@DivisionID,		@Notes,				'A02',
	--		GETDATE(),			@UserID,			@UserID,				GETDATE()
	--	)
	--END
	
	-- But toan hoa don ban hang
	--SET @VoucherTypeID  = 'SO'
	IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1007 WHERE VoucherTypeID = @VoucherTypeID)
	BEGIN
		INSERT INTO AT1007 (DivisionID, VoucherTypeID, VoucherTypeName, [Disabled])
		VALUES (@DivisionID, @VoucherTypeID, N'SalesVoucher', 0)
	END
	
						
	
	SET @TranMonth = CONVERT(INT,RIGHT(LEFT(CONVERT(VARCHAR(20),@ContractDate,103), 5), 2))
	SET @TranYear = CONVERT(INT, RIGHT(CONVERT(VARCHAR(20),@ContractDate,103), 4))	
	-- Sinh IGE
	EXEC AP0002 @DivisionID, @TransactionID Output, 'AT9000', 'OT', @TranYear, '', 16, 3, 0, '-'
				

	
	----------INSERT Loai tien
	IF NOT EXISTS( SELECT TOP 1 1 FROM AT1004 WHERE CurrencyID = @CurrencyID)
		BEGIN
			INSERT INTO AT1004
			(
				DivisionID,			CurrencyID,			CurrencyName,			ExchangeRate,
				Operator,			[Disabled],			
				CreateDate,			CreateUserID,		LastModifyDate,			LastModifyUserID
			)
			VALUES
			(
				@DivisionID,		@CurrencyID,		@CurrencyID,			1,
				0,					0,				
				GETDATE(),			@UserID,			GETDATE(),				@UserID
			)
			SET @ExchangeRate = 1
			SET @Operator = 0
		END
	ELSE
		BEGIN
			SET @ExchangeRate = (SELECT TOP 1 ExchangeRate FROM AT1004  WHERE CurrencyID = @CurrencyID)
			SET @Operator = (SELECT TOP 1 Operator FROM at1004 WHERE CurrencyID = @CurrencyID)		
		END
	
	----------INSERT Doi tuong
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT1201 WHERE ObjectTypeID = 'C')
	BEGIN
		INSERT INTO AT1201
			(
				DivisionID,		ObjectTypeID,		ObjectTypeName,
				[Disabled],
				CreateDate,		CreateUserID,		LastModifyDate,		LastModifyUserID
			)
		VALUES
			(
				@DivisionID,	'C',				N'Customize',
				0,
				GETDATE(),		@UserID,			GETDATE(),			@UserID
			)
	END
	
	IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1202 WHERE ObjectID = @ObjectID )
	BEGIN
		INSERT INTO AT1202
		(
		DivisionID,
		ObjectTypeID,	ObjectID,		ObjectName,			[Address],
		IsSupplier,		IsCustomer,		VATNo,
		CreateDate,		CreateUserID,	LastModifyDate,		LastModifyUserID	
		)
		VALUES
		(
		@DivisionID,
		'C',			@ObjectID,		@ObjectName,		@Address,
		1,				1,				@VATNo,
		GETDATE(),		@UserID,		GETDATE(),			@UserID
		)
	END
	
----------INSERT Agent
	
	IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1202 WHERE ObjectID = @AgentID )
	BEGIN
		INSERT INTO AT1202
		(
		DivisionID,
		ObjectTypeID,	ObjectID,		ObjectName,			[Address],
		IsSupplier,		IsCustomer,		
		CreateDate,		CreateUserID,	LastModifyDate,		LastModifyUserID	
		)
		VALUES
		(
		@DivisionID,
		'C',			@AgentID,		@AgentName,			@AgentAddress,
		1,				1,				
		GETDATE(),		@UserID,		GETDATE(),			@UserID
		)
	END
	
	------ Đơn hàng bán
	IF NOT EXISTS ( SELECT TOP 1  1 FROM OT2001 WHERE SOrderID = @ContractID)
	BEGIN
		INSERT INTO OT2001
		(
			DivisionID,			SOrderID,			OrderDate,
			VoucherTypeID,		VoucherNo,
			ContractNo,			ContractDate,
			ObjectID,			ObjectName,			[Address],				VatNo,	
			Notes,
			CreateDate,			CreateUserID,		LastModifyUserID,		LastModifyDate,
			CurrencyID,			ExchangeRate,
			TranMonth,			TranYear,
			PaymentID,			OrderType,			[Disabled],				OrderStatus,
			SalesManID,			IsConfirm,			InventoryTypeID
		)
		VALUES
		(
			@DivisionID,		@ContractID,		@ContractDate,
			@VoucherTypeID,		@ContractID,
			@ContractID,		@ContractDate,
			@ObjectID,			@ObjectName ,		@Address,		@VATNo,		
			@ContractID,
			GETDATE(),			@UserID,			@UserID,		GETDATE(),
			@CurrencyID,		@ExchangeRate,
			@TranMonth,			@TranYear,
			@PaymentID,			0,					0,				1,
			@AgentID,			0,					'%'
		)
	END

	IF NOT EXISTS ( SELECT TOP 1  1 FROM OT2002 WHERE SOrderID = @ContractID AND InventoryID = @InventoryID )
		BEGIN
		INSERT INTO OT2002
		(
			DivisionID,		TransactionID,		SOrderID,
			InventoryID,
			OrderQuantity,
			SalePrice,
			ConvertedAmount,					OriginalAmount,
			IsPicking,		
			ConvertedQuantity,	
			ConvertedSalePrice,					PriceList
		)
		VALUES
		(
			@DivisionID,	@TransactionID,		@ContractID,
			@InventoryID,
			@OrderQuantity,
			@SalesPrice,
			CASE WHEN @Operator = 0 THEN ROUND(@OriginalAmount * @ExchangeRate, @ConvertedDecimals) ELSE ROUND(@OriginalAmount / @ExchangeRate, @ConvertedDecimals) END ,
			@OriginalAmount,
			0,				
			@OrderQuantity,
			CASE WHEN @Operator = 0 THEN ROUND(@SalesPrice * @ExchangeRate, @ConvertedDecimals) ELSE ROUND(@SalesPrice / @ExchangeRate, @ConvertedDecimals) END,
			0
		)
		END
																		
	FETCH NEXT FROM @OrderCur INTO	@ContractID, @ContractDate, @Notes, @ObjectName, @InventoryName,@OriginalAmount,
									@PaymentID, @PaymentTermID,@OrderQuantity,@SalesPrice,@ObjectID,
									@VATNo,@Address,@AgentID, @AgentName, @AgentAddress, @CurrencyID
END

LB_RESULT:


IF @@ERROR = 0
	COMMIT TRAN
ELSE
	ROLLBACK TRAN
		
Close @OrderCur
END
EXIST:
SET NOCOUNT OFF

LB_RESULT1:
SELECT * FROM #Loi


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

