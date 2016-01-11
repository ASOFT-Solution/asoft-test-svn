IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0102]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0102]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- <Summary>
---- Sinh phiếu nhập kho phế liệu và xuất kho nguyên vật liệu tự động tại màn hình Thành Phẩm
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 29/05/2012 by Lê Thị Thu Hiền
---- 
---- Modified on 28/01/2013 by Lê Thị Thu Hiền : Bổ sung lưu WasteID ( mã phế liệu thay cho nguyên vật liệu )
---- Modified on 05/02/2013 by Bảo Quỳnh : Đảo định khoản nợ có cho bút toán phế liệu
---- Modified on 14/05/2015 by Bảo Anh: Bổ sung ConvertedQuantity khi insert AT2007
---- Modified on 17/08/2015 by Tiểu Mai: Sửa TK nợ mặc định theo thiết lập, loại tiền tệ theo thông tin công ty (ở phiếu xuất kho)
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ, tiền hạch toán theo thiết lập đơn vị-chi nhánh
-- <Example>
---- 
CREATE PROCEDURE MP0102
( 
		@DivisionID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@UserID AS NVARCHAR(50),
		@ExVoucherTypeID AS NVARCHAR(50),
		@ImVoucherTypeID AS NVARCHAR(50),
		@ExWareHouseID AS NVARCHAR(50),
		@ImWareHouseID AS NVARCHAR(50),
		@VoucherID AS NVARCHAR(50),
		@ApportionID AS NVARCHAR(50)
) 
AS 

DECLARE
	@StringKey1 nvarchar(50), 
	@StringKey2 nvarchar(50),
	@StringKey3 nvarchar(50), 
	@OutputLen int, 
	@OutputOrder int,
	@Separated int, 
	@Separator char(1),
	@Enabled1 tinyint, 
	@Enabled2 tinyint,
	@Enabled3 tinyint,
	@S1 nvarchar(50), 
	@S2 nvarchar(50),
	@S3 nvarchar(50),
	@S1Type tinyint, 
	@S2Type tinyint,
	@S3Type tinyint,
	@QuantityDecimals  as tinyint,
	@ExVoucherID as nvarchar(50),
	@ImVoucherID as nvarchar(50),
	@VoucherNo as nvarchar(50),
	@VoucherDate as DATETIME,
	@ExVoucherNo as nvarchar(50),
	@ImVoucherNo as nvarchar(50),
	@IsAutoExMaterialDelivery AS TINYINT,
	@IsAutoImScrap AS TINYINT,

	@ObjectID as nvarchar(50),
	@EmployeeID as nvarchar(50),
	@DebitAccountID as nvarchar(50),
	@Orders AS INT,
	@cur as CURSOR,
	
	@PeriodID AS NVARCHAR(50), 
	@ProductID AS NVARCHAR(50), 
	@Quantity AS DECIMAL(28,8), 
	@DistributionID AS NVARCHAR(50), 
	@MaterialID AS NVARCHAR(50),
	@MaterialAmount AS DECIMAL(28,8), 
	@MaterialQuantity AS DECIMAL(28,8), 
	@MaterialUnitID AS NVARCHAR(50), 
	@MaterialPrice AS DECIMAL(28,8),
	@ProductQuantity AS DECIMAL(28,8), 
	@QuantityUnit AS DECIMAL(28,8),
	@ExTransactionID AS NVARCHAR(50),
	@ImTransactionID AS NVARCHAR(50),
	@CreditAccountID AS NVARCHAR(50),
	@RateWastage AS DECIMAL(28,8), --- %hao hụt
	@SSQL as NVARCHAR(Max),
	@Currency AS NVARCHAR(50)


SELECT	@IsAutoExMaterialDelivery = IsAutoExMaterialDelivery,
		@IsAutoImScrap = IsAutoImScrap 
FROM	MT0000
WHERE	DivisionID = @DivisionID

select @Currency = CurrencyID
from WT0000
where DefDivisionID = @DivisionID

IF @Currency = NULL 
BEGIN 
SELECT @Currency = BaseCurrencyID FROM AT11001 WHERE DivisionID = @DivisionID
END 

SELECT	@QuantityDecimals = QuantityDecimals
FROM	AT1101
WHERE DivisionID = @DivisionID
SET		@QuantityDecimals = ISNULL(@QuantityDecimals,0)

-- khai bao lai chung tu xuat NVL
SELECT	@Enabled1=Enabled1,@Enabled2=Enabled2,@Enabled3=Enabled3,
		@S1=S1,@S2=S2,@S3=S3,
		@S1Type=S1Type,@S2Type=S2Type,@S3Type=S3Type,
		@OutputLen = OutputLength, @OutputOrder=OutputOrder,@Separated=Separated,@Separator=Separator, @DebitAccountID = DebitAccountID
FROM	AT1007 
WHERE	VoucherTypeID = @ExVoucherTypeID

If @Enabled1 = 1
	Set @StringKey1 = 
	Case @S1Type
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @ExVoucherTypeID
	When 4 Then @DivisionID
	When 5 Then @S1
	When 6 Then right(ltrim(@TranYear),2)
	Else '' End
Else
	Set @StringKey1 = ''

If @Enabled2 = 1
	Set @StringKey2 = 
	Case @S2Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @ExVoucherTypeID
	When 4 Then @DivisionID
	When 5 Then @S1
	When 6 Then right(ltrim(@TranYear),2)
	Else '' End
Else
	Set @StringKey2 = ''

If @Enabled3 = 1
	Set @StringKey3 = 
	Case @S3Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @ExVoucherTypeID
	When 4 Then @DivisionID
	When 5 Then @S1
	When 6 Then right(ltrim(@TranYear),2)
	Else '' End
Else
	Set @StringKey3 = ''

SELECT	@VoucherDate = VoucherDate ,
		@VoucherNo = VoucherNo,
		@ObjectID = ObjectID,
		@PeriodID = PeriodID
FROM	MT0810 
WHERE	VoucherID = @VoucherID AND DivisionID = @DivisionID

--------------- Xuất nguyên vật liệu 
IF @IsAutoExMaterialDelivery = 1
BEGIN
	
	EXEC AP0005 @DivisionID, @ExVoucherNo Output, 'AT9000', @StringKey1, @StringKey2, @StringKey3, @OutputLen, @OutputOrder, @Separated, @Separator

	EXEC AP0005 @DivisionID, @ExVoucherID Output, 'AT2006', 'AD', @TranYear, '', 16, 3, 0, '-'

	--IF NOT EXISTS (SELECT TOP 1 1 FROM MT0810 M
	--							LEFT JOIN MT1001 M1	ON	M1.DivisionID = M.DivisionID AND M1.VoucherID = M.VoucherID
	--							LEFT JOIN MT1601 M2 ON M2.DivisionID = M.DivisionID AND M.PeriodID = M2.PeriodID
	--							LEFT JOIN MT5001 M3 ON M3.DivisionID = M2.DivisionID AND M3.DistributionID = M2.DistributionID
	--							LEFT JOIN MT1602 M4 ON M4.DivisionID = M3.DivisionID AND M4.ApportionID = M3.ApportionID
	--							LEFT JOIN MT1603 M5 ON M5.DivisionID = M4.DivisionID AND M5.ApportionID = M4.ApportionID AND M5.ProductID = M1.ProductID
	--							WHERE ISNULL(M5.MaterialID,'') <> '' AND M.DivisionID = @DivisionID
	--							ORDER BY M.VoucherNo, M.PeriodID, M1.ProductID, M5.MaterialID )
	IF EXISTS ( SELECT	TOP 1 1 FROM MT1603 M5 
					LEFT JOIN (SELECT DivisionID,ProductID FROM MT1001 M WHERE M.DivisionID = @DivisionID AND M.VoucherID = @VoucherID)M1
						ON	M1.DivisionID = M5.DivisionID AND M1.ProductID = M5.ProductID
					WHERE	ISNULL(M5.MaterialID,'') <> '' AND M1.ProductID <> '' AND M5.DivisionID = @DivisionID AND M5.ApportionID = @ApportionID
						AND M5.ExpenseID = 'COST001')
		BEGIN
			INSERT INTO AT2006
			(VoucherID,TableID,TranMonth,TranYear,
			DivisionID,VoucherTypeID,VoucherDate,VoucherNo,ObjectID,MOrderID,
			WareHouseID,KindVoucherID,EmployeeID,[Description],
			CreateDate,CreateUserID,LastModifyUserID,LastModifyDate, RefNo01,InventoryTypeID,BatchID, [Status],
			ApportionID)
			VALUES
			(@ExVoucherID,'AT2006',@TranMonth,@TranYear,
			@DivisionID,@ExVoucherTypeID,@VoucherDate,@ExVoucherNo,@ObjectID,@VoucherID,
			@ExWareHouseID,2, @EmployeeID,N'Xuất NVL từ phiếu KQSX ' + @VoucherNo,
			getDate(),@EmployeeID,@EmployeeID,getDate(), @VoucherNo,'%',@ExVoucherID, 0,
			@ApportionID)
		END

	SET @Orders = 1
	SET @cur = CURSOR STATIC FOR

		--SELECT	DISTINCT M.VoucherID , M.PeriodID, M1.ProductID, M1.Quantity, 
		--		M2.DistributionID, M4.ApportionID, M5.MaterialID,
		--		M5.MaterialAmount, M5.MaterialQuantity, M5.MaterialUnitID, M5.MaterialPrice,
		--		M5.ProductQuantity, M5.QuantityUnit
		--FROM MT0810 M
		--LEFT JOIN MT1001 M1	ON	M1.DivisionID = M.DivisionID AND M1.VoucherID = M.VoucherID
		--LEFT JOIN MT1601 M2 ON M2.DivisionID = M.DivisionID AND M.PeriodID = M2.PeriodID
		--LEFT JOIN MT5001 M3 ON M3.DivisionID = M2.DivisionID AND M3.DistributionID = M2.DistributionID
		--LEFT JOIN MT1602 M4 ON M4.DivisionID = M3.DivisionID AND M4.ApportionID = M3.ApportionID
		--LEFT JOIN MT1603 M5 ON M5.DivisionID = M4.DivisionID AND M5.ApportionID = M4.ApportionID AND M5.ProductID = M1.ProductID
		--WHERE ISNULL(M5.MaterialID,'') <> '' AND M.DivisionID = @DivisionID AND M.VoucherID = @VoucherID
		--ORDER BY M.VoucherNo, M.PeriodID, M1.ProductID, M5.MaterialID
		
		SELECT	M5.MaterialID,M5.MaterialAmount, M5.MaterialQuantity, M5.MaterialUnitID, M5.MaterialPrice,
				M5.ProductQuantity, M1.Quantity
		FROM	MT1603 M5 
		LEFT JOIN (SELECT DivisionID,ProductID, M.Quantity  FROM MT1001 M WHERE M.DivisionID = @DivisionID AND M.VoucherID = @VoucherID)M1
			ON		M1.DivisionID = M5.DivisionID AND M1.ProductID = M5.ProductID
		WHERE	ISNULL(M5.MaterialID,'') <> '' AND M1.ProductID <> ''  AND M5.DivisionID = @DivisionID AND M5.ApportionID = @ApportionID
				AND M5.ExpenseID = 'COST001'
		
	OPEN @cur
	FETCH NEXT FROM @cur INTO @MaterialID,@MaterialAmount, @MaterialQuantity, @MaterialUnitID, @MaterialPrice,
							@ProductQuantity, @QuantityUnit
	WHILE @@Fetch_Status = 0
	BEGIN
		
		EXEC AP0005 @DivisionID, @ExTransactionID OUTPUT, 'AT2007', 'BD', @TranYear, '', 16, 3, 0, '-'
		
		SET @CreditAccountID = (SELECT TOP 1 AccountID FROM AT1302 WHERE InventoryID = @MaterialID AND DivisionID = @DivisionID)

		INSERT INTO AT2007
			(TransactionID, VoucherID, InventoryID, UnitID, ActualQuantity,
			ConvertedQuantity, TranMonth, TranYear, DivisionID, CurrencyID, ExchangeRate, 
			DebitAccountID,CreditAccountID, Orders, PeriodID, ProductID, MOrderID, Notes)
		VALUES 
			(@ExTransactionID, @ExVoucherID, @MaterialID, @MaterialUnitID, Round(@MaterialQuantity*@QuantityUnit/@ProductQuantity,@QuantityDecimals),
			Round(@MaterialQuantity*@QuantityUnit/@ProductQuantity,@QuantityDecimals), @TranMonth, @TranYear, @DivisionID, @Currency, 1,
			@DebitAccountID,@CreditAccountID, @Orders, @PeriodID, @ProductID, @VoucherID, N'Xuất NVL từ phiếu KQSX ' + @VoucherNo)

		SET @Orders = @Orders + 1
		
	FETCH NEXT FROM @cur INTO @MaterialID,@MaterialAmount, @MaterialQuantity, @MaterialUnitID, @MaterialPrice,
							@ProductQuantity, @QuantityUnit

		
	END

	
END

------------Nhập kho phế liệu

------Khai báo chứng từ nhập phế liệu
SELECT	@Enabled1=Enabled1,@Enabled2=Enabled2,@Enabled3=Enabled3,
		@S1=S1,@S2=S2,@S3=S3,
		@S1Type=S1Type,@S2Type=S2Type,@S3Type=S3Type,
		@OutputLen = OutputLength, @OutputOrder=OutputOrder,@Separated=Separated,@Separator=Separator
FROM	AT1007 
WHERE	VoucherTypeID = @ImVoucherTypeID

If @Enabled1 = 1
	Set @StringKey1 = 
	Case @S1Type
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @ImVoucherTypeID
	When 4 Then @DivisionID
	When 5 Then @S1
	When 6 Then right(ltrim(@TranYear),2)
	Else '' End
Else
	Set @StringKey1 = ''

If @Enabled2 = 1
	Set @StringKey2 = 
	Case @S2Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @ImVoucherTypeID
	When 4 Then @DivisionID
	When 5 Then @S1
	When 6 Then right(ltrim(@TranYear),2)
	Else '' End
Else
	Set @StringKey2 = ''

If @Enabled3 = 1
	Set @StringKey3 = 
	Case @S3Type 
	When 1 Then Case When @TranMonth <10 Then '0' + ltrim(@TranMonth) Else ltrim(@TranMonth) End
	When 2 Then ltrim(@TranYear)
	When 3 Then @ImVoucherTypeID
	When 4 Then @DivisionID
	When 5 Then @S1
	When 6 Then right(ltrim(@TranYear),2)
	Else '' End
Else
	Set @StringKey3 = ''
IF @IsAutoImScrap = 1
BEGIN
	
	EXEC AP0005 @DivisionID, @ImVoucherNo Output, 'AT9000', @StringKey1, @StringKey2, @StringKey3, @OutputLen, @OutputOrder, @Separated, @Separator

	EXEC AP0005 @DivisionID, @ImVoucherID Output, 'AT2006', 'AR', @TranYear, '', 16, 3, 0, '-'
	
	--IF NOT EXISTS (SELECT TOP 1 1 FROM MT0810 M
	--							LEFT JOIN MT1001 M1	ON	M1.DivisionID = M.DivisionID AND M1.VoucherID = M.VoucherID
	--							LEFT JOIN MT1601 M2 ON M2.DivisionID = M.DivisionID AND M.PeriodID = M2.PeriodID
	--							LEFT JOIN MT5001 M3 ON M3.DivisionID = M2.DivisionID AND M3.DistributionID = M2.DistributionID
	--							LEFT JOIN MT1602 M4 ON M4.DivisionID = M3.DivisionID AND M4.ApportionID = M3.ApportionID
	--							LEFT JOIN MT1603 M5 ON M5.DivisionID = M4.DivisionID AND M5.ApportionID = M4.ApportionID AND M5.ProductID = M1.ProductID
	--							WHERE ISNULL(M5.MaterialID,'') <> '' AND M.DivisionID = @DivisionID
	--							ORDER BY M.VoucherNo, M.PeriodID, M1.ProductID, M5.MaterialID )
	
	IF EXISTS (		SELECT	TOP 1 1 FROM MT1603 M5 
					LEFT JOIN (SELECT	DivisionID,ProductID  
					           FROM		MT1001 M 
					           WHERE	M.DivisionID = @DivisionID 
										AND M.VoucherID = @VoucherID
								)M1
						ON	M1.DivisionID = M5.DivisionID 
							AND M1.ProductID = M5.ProductID
					WHERE	ISNULL(M5.MaterialID,'') <> '' 
							AND M1.ProductID <> '' 
							AND M5.DivisionID = @DivisionID 
							AND M5.ApportionID = @ApportionID
							AND M5.ExpenseID = 'COST001' 
							AND ISNULL (M5.RateWastage, 0) <> 0
							AND ISNULL(M5.WasteID, '') <> '')
		BEGIN
			INSERT INTO AT2006
			(VoucherID,TableID,TranMonth,TranYear,
			DivisionID,VoucherTypeID,VoucherDate,VoucherNo,ObjectID,MOrderID,
			WareHouseID,KindVoucherID,EmployeeID,[Description],
			CreateDate,CreateUserID,LastModifyUserID,LastModifyDate, RefNo01,InventoryTypeID,BatchID, [Status],
			ApportionID)
			VALUES
			(@ImVoucherID,'AT2006',@TranMonth,@TranYear,
			@DivisionID,@ImVoucherTypeID,@VoucherDate,@ImVoucherNo,@ObjectID,@VoucherID,
			@ImWareHouseID,1, @EmployeeID,N'Nhập phế liệu từ phiếu KQSX ' + @VoucherNo,
			getDate(),@EmployeeID,@EmployeeID,getDate(), @VoucherNo,'%',@ImVoucherID, 0,
			@ApportionID)
		END

	SET @Orders = 1
	SET @cur = CURSOR STATIC FOR

		SELECT	M5.WasteID,M5.MaterialAmount, M5.MaterialQuantity, M5.MaterialUnitID, M5.MaterialPrice,
				M5.ProductQuantity, M1.Quantity, M5.RateWastage
		FROM	MT1603 M5 
		LEFT JOIN (	SELECT DivisionID,ProductID , M.Quantity
		            FROM MT1001 M 
		           	WHERE M.DivisionID = @DivisionID AND M.VoucherID = @VoucherID
					)M1
			ON		M1.DivisionID = M5.DivisionID AND M1.ProductID = M5.ProductID
		WHERE	ISNULL(M5.MaterialID,'') <> '' 
				AND M1.ProductID <> '' 
				AND M5.DivisionID = @DivisionID 
				AND M5.ApportionID = @ApportionID
				AND M5.ExpenseID = 'COST001' 
				AND ISNULL(M5.RateWastage, 0) <> 0 
				AND ISNULL(M5.WasteID, '') <> ''
		
	OPEN @cur
	FETCH NEXT FROM @cur INTO @MaterialID,@MaterialAmount, @MaterialQuantity, @MaterialUnitID, @MaterialPrice,
							@ProductQuantity, @QuantityUnit, @RateWastage
	WHILE @@Fetch_Status = 0
	BEGIN
		
		EXEC AP0005 @DivisionID, @ImTransactionID OUTPUT, 'AT2007', 'BR', @TranYear, '', 16, 3, 0, '-'
		
		SET @CreditAccountID = (SELECT TOP 1 AccountID FROM AT1302 WHERE InventoryID = @MaterialID AND DivisionID = @DivisionID)

		INSERT INTO AT2007
			(TransactionID, VoucherID, InventoryID, UnitID, ActualQuantity, 
			ConvertedQuantity, TranMonth, TranYear, DivisionID, CurrencyID, ExchangeRate, 
			DebitAccountID,CreditAccountID, Orders, PeriodID, ProductID, MOrderID, Notes)
		VALUES 
			(@ImTransactionID, @ImVoucherID, @MaterialID, @MaterialUnitID, Round(@MaterialQuantity*@QuantityUnit/@ProductQuantity*@RateWastage/100,@QuantityDecimals),
			Round(@MaterialQuantity*@QuantityUnit/@ProductQuantity*@RateWastage/100,@QuantityDecimals), @TranMonth, @TranYear, @DivisionID, 'VND', 1,
			@CreditAccountID,@DebitAccountID, @Orders, @PeriodID, @ProductID, @VoucherID, N'Nhập phế liệu từ phiếu KQSX ' + @VoucherNo)

		SET @Orders = @Orders + 1
		
	FETCH NEXT FROM @cur INTO @MaterialID,@MaterialAmount, @MaterialQuantity, @MaterialUnitID, @MaterialPrice,
							@ProductQuantity, @QuantityUnit, @RateWastage

		
	END

	
END






GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
