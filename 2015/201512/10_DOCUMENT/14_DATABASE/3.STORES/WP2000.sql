IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP2000]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[WP2000]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Tự động tạo phiếu xuất kho khi lưu phiếu nhập kho thành công (customize Viengut)
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
----Created by: Thanh Sơn on 17/06/2014
-- <Example>
/*
    EXEC WP2000 'EIS','','0F336164-AA6E-4C72-B916-17C7CBCA1E87'
*/

 CREATE PROCEDURE WP2000
(
     @DivisionID NVARCHAR(2000),
     @UserID VARCHAR(50),
     @VoucherID VARCHAR(50)
)
AS
DECLARE @IsCreateExVoucher TINYINT, @ExVoucherID UNIQUEIDENTIFIER, @ExVoucherNo VARCHAR(50), @VoucherTypeID VARCHAR(50),
@S1 VARCHAR(50), @S2 VARCHAR(50), @S3 VARCHAR(50), @TranMonth INT = 0 , @TranYear INT = 0, @OutputLenght TINYINT,
@OutputOrder TINYINT, @Seperated TINYINT, @Seperator VARCHAR(50), @TransactionID UNIQUEIDENTIFIER, @WareHouseID VARCHAR(50)

SET @ExVoucherID = NEWID()

SELECT @TranMonth = TranMonth, @TranYear = TranYear, @WareHouseID = WareHouseID
FROM AT2006 WHERE DivisionID = @DivisionID AND VoucherID = @VoucherID
CREATE TABLE #ExVoucherNo (ExVoucherNo VARCHAR(50))

SELECT @VoucherTypeID = VoucherTypeID, @S1 = 'PX', @S2 = CONVERT(VARCHAR(4),@TranYear), @S3 = 
	CASE WHEN @TranMonth < 10 THEN '0' + CONVERT(VARCHAR(1),@TranMonth) ELSE CONVERT(VARCHAR(1),@TranMonth) END , @OutputLenght = OutputLength,
	@OutputOrder = OutputOrder, @Seperated = Separated, @Seperator = Separator FROM AT1007 WHERE VoucherTypeID = 'PX'	
	INSERT INTO #ExVoucherNo
	EXEC AP0000 @DivisionID,@ExVoucherNo,'AT9000',@S1, @S2, @S3, @OutputLenght, @OutputOrder, @Seperated, @Seperator
	SELECT @ExVoucherNo = ExVoucherNo FROM #ExVoucherNo
------------------------thực hiện bắn dữ liệu--------------------------------------------------
IF EXISTS (SELECT TOP 1 1 FROM AT2006 WHERE DivisionID = @DivisionID AND ImVoucherID = @VoucherID)
BEGIN
	DECLARE @DelExVoucherID NVARCHAR(50)
	SELECT @DelExVoucherID = VoucherID FROM AT2006 WHERE DivisionID = @DivisionID AND ImVoucherID = @VoucherID
	DELETE AT2006 WHERE DivisionID = @DivisionID AND VoucherID = @DelExVoucherID
	DELETE AT2007 WHERE DivisionID = @DivisionID AND VoucherID = @DelExVoucherID
		
END		
	-----------------Thêm master AT2006----------------------------------------------------------------------------------	
INSERT INTO AT2006 (DivisionID, VoucherID, TableID, TranMonth, TranYear, VoucherTypeID, VoucherDate, VoucherNo,
			ObjectID, ProjectID, OrderID, BatchID, WareHouseID, ReDeTypeID, KindVoucherID, [Status],
			EmployeeID, [Description], CreateDate, CreateUserID, LastModifyUserID, LastModifyDate, RefNo01, RefNo02,
	        RDAddress, ContactPerson, VATObjectName, InventoryTypeID, IsGoodsFirstVoucher, MOrderID, ApportionID,
	        IsInheritWarranty, EVoucherID, IsGoodsRecycled, IsVoucher, ImVoucherID)
SELECT DivisionID, @ExVoucherID, TableID, TranMonth, TranYear, @VoucherTypeID, VoucherDate, @ExVoucherNo,
			ObjectID, ProjectID, OrderID, BatchID, WareHouseID, ReDeTypeID, 2, [Status],
			EmployeeID, [Description], CreateDate, CreateUserID, LastModifyUserID, LastModifyDate, RefNo01, RefNo02,
	        RDAddress, ContactPerson, VATObjectName, InventoryTypeID, IsGoodsFirstVoucher, MOrderID, ApportionID,
	        IsInheritWarranty, EVoucherID, IsGoodsRecycled, IsVoucher, @VoucherID
FROM AT2006
WHERE DivisionID = @DivisionID
AND VoucherID = @VoucherID          
	 
	-----------------Thêm detail AT2007----------------------------------------------------------------------------------
INSERT INTO AT2007 (DivisionID, TransactionID, VoucherID, BatchID, InventoryID, UnitID, ActualQuantity, UnitPrice,
	OriginalAmount, ConvertedAmount, Notes, TranMonth, TranYear, CurrencyID, ExchangeRate, SaleUnitPrice,
	SaleAmount, DiscountAmount, SourceNo, DebitAccountID, CreditAccountID, LocationID, ImLocationID,
	LimitDate, Orders, ConversionFactor, ReTransactionID, ReVoucherID, Ana01ID, Ana02ID, Ana03ID, PeriodID,
	ProductID, OrderID, InventoryName1, Ana04ID, Ana05ID, OTransactionID, ReSPVoucherID, ReSPTransactionID,
	ETransactionID, MTransactionID, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
	ConvertedQuantity, ConvertedPrice, ConvertedUnitID, MOrderID, SOrderID, STransactionID, Ana06ID, Ana07ID,
	Ana08ID, Ana09ID, Ana10ID, LocationCode, Location01ID, Location02ID, Location03ID, Location04ID, Location05ID,
	MarkQuantity, OExpenseConvertedAmount, WVoucherID, RefInfor, Notes01, Notes02, Notes03, Notes04, Notes05,
	Notes06, Notes07, Notes08, Notes09, Notes10, Notes11, Notes12, Notes13, Notes14, Notes15, StandardPrice,
	StandardAmount, InheritTableID, InheritVoucherID, InheritTransactionID)
SELECT DivisionID, NEWID(), @ExVoucherID, BatchID, InventoryID, UnitID, ActualQuantity, UnitPrice,
	OriginalAmount, ConvertedAmount, Notes, TranMonth, TranYear, CurrencyID, ExchangeRate, SaleUnitPrice,
	SaleAmount, DiscountAmount, SourceNo,
	(SELECT PrimeCostAccountID FROM AT1302 WHERE DivisionID = @DivisionID AND InventoryID = A.InventoryID),
	DebitAccountID, LocationID, ImLocationID,
	LimitDate, Orders, ConversionFactor, TransactionID, @VoucherID, Ana01ID, Ana02ID, Ana03ID, PeriodID,
	ProductID, OrderID, InventoryName1, Ana04ID, Ana05ID, OTransactionID, ReSPVoucherID, ReSPTransactionID,
	ETransactionID, MTransactionID, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
	ConvertedQuantity, ConvertedPrice, ConvertedUnitID, MOrderID, SOrderID, STransactionID, Ana06ID, Ana07ID,
	Ana08ID, Ana09ID, Ana10ID, LocationCode, Location01ID, Location02ID, Location03ID, Location04ID, Location05ID,
	MarkQuantity, OExpenseConvertedAmount, WVoucherID, RefInfor, Notes01, Notes02, Notes03, Notes04, Notes05,
	Notes06, Notes07, Notes08, Notes09, Notes10, Notes11, Notes12, Notes13, Notes14, Notes15, StandardPrice,
	StandardAmount, InheritTableID, InheritVoucherID, InheritTransactionID
FROM AT2007 A
WHERE DivisionID = @DivisionID
	AND VoucherID = @VoucherID
	
----------------------------Update tinh hinh ton theo Lo, Date,chung tu nhap khi xuat kho--------------------------------------------------------
DECLARE @Cur CURSOR, @InventoryID VARCHAR(50), @Quantity DECIMAL(28,8), @UnitID VARCHAR(50),
@IsSource TINYINT, @IsLimitDate TINYINT, @CreditAccountID VARCHAR(50), @TransactionID1 VARCHAR(50)
SET @Cur = CURSOR SCROLL KEYSET FOR

SELECT InventoryID, UnitID, CreditAccountID, TransactionID, ActualQuantity 
FROM AT2007
WHERE DivisionID = @DivisionID AND VoucherID = CONVERT(VARCHAR(50), @VoucherID)

OPEN @Cur
FETCH NEXT FROM @Cur INTO @InventoryID, @UnitID, @CreditAccountID, @TransactionID1, @Quantity
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @IsSource = IsSource, @IsLimitDate = IsLimitDate FROM AT1302 WHERE DivisionID = @DivisionID AND InventoryID = @InventoryID
	EXEC AP7777 @UserID = @UserID, @DivisionID = @DivisionID, @TranMonth = @TranMonth, @TranYear = @TranYear, @WareHouseID = @WareHouseID,
	@InventoryID = @InventoryID, @UnitID = @UnitID, @ConversionFactor = 1.00000000, @IsSource = @IsSource, @IsLimitDate = @IsLimitDate, 
	@CreditAccountID = @CreditAccountID, @ReOldVoucherID = '',@ReOldTransactionID = '', @ReNewVoucherID = @VoucherID,
	@ReNewTransactionID = @TransactionID1, @OldQuantity=0, @NewQuantity = @Quantity, @AllowOverShip = 0, @MethodID = 4, @OldMarkQuantity=0,
	@NewMarkQuantity = @Quantity
	PRINT (@IsSource)
	FETCH NEXT FROM @Cur INTO @InventoryID, @UnitID, @CreditAccountID, @TransactionID1, @Quantity
END
CLOSE @Cur

	-----------------Update phiếu nhập đã tạo ra phiếu xuất nào----------------------------------------------------------------------------------
UPDATE AT2006 SET ImVoucherID = @ExVoucherID WHERE DivisionID = @DivisionID AND VoucherID = @VoucherID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO