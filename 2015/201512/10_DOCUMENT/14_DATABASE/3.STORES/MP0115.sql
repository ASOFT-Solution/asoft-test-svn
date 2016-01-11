IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0115]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0115]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Kế thừa bảng giá vốn sản phẩm - MF0115[Customize Index: 36 - Sài Gòn Petro]
-- <History>
---- Create on 27/04/2015 by Lê Thị Hạnh 
---- Modified by ... on ... 
-- <Example>
/*
MP0115 @DivisionID = 'VG', @TranMonth = 1, @TranYear = 2015, @PCTranMonth = 4, @PCTranYear = 2015, 
@VoucherTypeID = 'CL',@VoucherDate = '2015-04-29 10:18:11.377',@IsPriceList=0,@PriceListID = 'SPP2015011',
@InheritAnaID = 'TP', @InheritPCID = '90783BCA-3DFB-4FCF-8505-DAF41A09A3C0', @UserID ='ASOFTADMIN'
*/

CREATE PROCEDURE [dbo].[MP0115] 	
	@DivisionID NVARCHAR(50),
	@TranMonth INT,
	@TranYear INT,
	@PCTranMonth INT,
	@PCTranYear INT,
	@VoucherTypeID NVARCHAR(50),
	@VoucherDate DATETIME,
	@IsPriceList TINYINT, --0: Không check, 1:check
	@PriceListID NVARCHAR(50),
	@InheritAnaID NVARCHAR(50),
	@InheritPCID NVARCHAR(50),
	@UserID NVARCHAR(50)
AS
DECLARE @Cur CURSOR, 
		@CurrencyID NVARCHAR(50),
		@ExchangeRate DECIMAL(28,8),
		@WeightTotal DECIMAL(28,8),
		@PMID NVARCHAR(50),
		@IsVND TINYINT,
		@MaterialID NVARCHAR(50),
		@TypeID TINYINT,
		@UnitPrice DECIMAL(28,8),
		@InheritVoucherID NVARCHAR(50),
		@InheritTransactionID NVARCHAR(50),
		@VoucherID NVARCHAR(50),
		@TransactionID NVARCHAR(50),
		@VoucherNo NVARCHAR(50),
		@TestID NVARCHAR(50),
		@StringKey1 NVARCHAR(50),
		@StringKey2 NVARCHAR(50),
		@StringKey3 NVARCHAR(50),
		@OutputLen INT,
		@OutputOrder INT,-- 0 NSSS; 1 SNSS, 2 SSNS, 3 SSSN
		@Seperated INT,
		@Seperator NVARCHAR(1)
--SET @InheritPCID = NEWID()
DELETE FROM MT0119
INSERT INTO MT0119(DivisionID, VoucherID, TransactionID, TranMonth, TranYear, 
	        VoucherTypeID, VoucherNo, VoucherDate, CostAmount, CurrencyID, ExchangeRate, 
	        PriceListID, ProductID, [Description], PMID, IsVND, MaterialID,
            TypeID, UnitPrice, VATImPercent, VATPercent, ConvertedAmount, Orders, 
            Quantity, InheritTableID, InheritVoucherID, InheritTransactionID, InheritPCID, InheritAnaID,
            CreateUserID, CreateDate, LastModifyUserID, LastModifyDate)
SELECT MT15.DivisionID, NULL AS VoucherID, NULL AS TransactionID, 
	   @TranMonth AS TranMonth, @TranYear AS TranYear, 
	   @VoucherTypeID AS VoucherTypeID, @VoucherNo AS VoucherNo, @VoucherDate AS VoucherDate,
	   ISNULL(MT15.CostAmount,0) AS CostAmount, 
	   MT15.CurrencyID, ISNULL(MT15.ExchangeRate,0) AS ExchangeRate,
       MT15.PriceListID, MT15.ProductID, MT15.[Description], MT15.PMID, ISNULL(MT15.IsVND,0) AS IsVND,
       MT16.MaterialID, ISNULL(MT16.TypeID,0) AS TypeID, ISNULL(MT16.UnitPrice,0) AS UnitPrice, 
       ISNULL(MT16.VATImPercent,0) AS VATImPercent, ISNULL(MT16.VATPercent,0) AS VATPercent, 
       ISNULL(MT16.ConvertedAmount,0) AS ConvertedAmount, ISNULL(MT16.Orders,0) AS Orders, 
       CASE WHEN ISNULL(MT16.TypeID,0) = 3 THEN ISNULL(MT16.Quantity,1) ELSE ISNULL(MT16.Quantity,0) END AS Quantity,
       'MT0115' AS InheritTableID, MT15.VoucherID AS InheritVoucherID, 
       MT16.TransactionID AS InheritTransactionID, @InheritPCID AS InheritPCID, AT13.I01ID AS InheritAnaID,
       @UserID AS CreateUserID, NULL AS CreateDate, @UserID AS LastModifyUserID, NULL AS LastModifyDate
FROM MT0115 MT15
INNER JOIN MT0116 MT16 ON MT16.DivisionID = MT15.DivisionID AND MT16.VoucherID = MT15.VoucherID
LEFT JOIN AT1302 AT13 ON AT13.DivisionID = MT15.DivisionID AND AT13.InventoryID = MT15.ProductID
WHERE MT15.DivisionID = @DivisionID AND MT15.TranYear*12+MT15.TranMonth = (@PCTranYear*12+@PCTranMonth)
	  AND AT13.I01ID = @InheritAnaID	  
ORDER BY MT16.DivisionID, MT16.VoucherID, MT16.TypeID, MT16.Orders
-- Sinh khoá
SELECT @OutputLen = OutputLength, @OutputOrder = OutputOrder, 
	   @Seperated = Separated, @Seperator = separator
FROM AT1007
WHERE DivisionID = @DivisionID AND VoucherTypeID = @VoucherTypeID
SELECT @StringKey1 = S1, @StringKey2 = S2, @StringKey3 = S3 FROM dbo.S123 (@DivisionID, @VoucherTypeID, @TranMonth,@TranYear)
SET @Cur = CURSOR SCROLL KEYSET FOR 
		   SELECT DivisionID, InheritVoucherID, InheritTransactionID, VoucherTypeID, TranMonth, TranYear
		   FROM MT0119
OPEN @Cur
FETCH NEXT FROM @Cur INTO @DivisionID, @InheritVoucherID, @InheritTransactionID, @VoucherTypeID, @TranMonth, @TranYear
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @TestID IS NULL OR @TestID != @InheritVoucherID
	BEGIN
		SET @VoucherID = NEWID()
		EXEC AP0000 @DivisionID = @DivisionID, @NewKey = @VoucherNo OUTPUT, @TableName = 'AT9000',
		@StringKey1 = @StringKey1, @StringKey2 = @StringKey2, @StringKey3 = @StringKey3, 
		@OutputLen = @OutputLen, @OutputOrder = @OutputOrder, @Seperated = @Seperated, @Seperator = @Seperator
		UPDATE MT0119 SET VoucherID = @VoucherID, TransactionID = NEWID(), VoucherNo = @VoucherNo
	    WHERE DivisionID = @DivisionID AND InheritVoucherID = @InheritVoucherID AND @InheritTransactionID = @InheritTransactionID
		SET @TestID = @InheritVoucherID
	END
	ELSE 
	BEGIN
		SET @VoucherID = @VoucherID
		SET @VoucherNo = @VoucherNo
		UPDATE MT0119 SET VoucherID = @VoucherID, TransactionID = NEWID(), VoucherNo = @VoucherNo
	    WHERE DivisionID = @DivisionID AND InheritVoucherID = @InheritVoucherID AND @InheritTransactionID = @InheritTransactionID
		SET @TestID = @InheritVoucherID
	END	
	FETCH NEXT FROM @Cur INTO @DivisionID, @InheritVoucherID, @InheritTransactionID, @VoucherTypeID, @TranMonth, @TranYear
END
CLOSE @Cur		   
-- Chọn bảng giá, Update bảng giá vốn theo bảng giá
IF ISNULL(@IsPriceList,0) = 1 
BEGIN
	-- Lấy Bảng giá, loại tiền, tỷ giá, IsVND
	SELECT @IsVND = ISNULL(MT17.IsVND,0), @CurrencyID = MT17.CurrencyID 
	FROM MT0117 MT17 
	WHERE MT17.DivisionID = @DivisionID AND MT17.ID = @PriceListID
	SELECT TOP 1 @ExchangeRate = ISNULL(AT12.ExchangeRate,AT14.ExchangeRate) 
	FROM AT1004 AT14
	LEFT JOIN AT1012 AT12 ON AT12.DivisionID = AT14.DivisionID AND AT12.CurrencyID = AT14.CurrencyID
		 AND DATEDIFF(dd,AT12.ExchangeDate,CONVERT(NVARCHAR,@VoucherDate,101)) >= 0
	WHERE AT14.DivisionID = @DivisionID AND AT14.CurrencyID = @CurrencyID	
	UPDATE MT0119 SET 
		PriceListID = @PriceListID, 
		IsVND = @IsVND, 
		CurrencyID = @CurrencyID, 
		ExchangeRate = @ExchangeRate
	WHERE DivisionID = @DivisionID
	SET @Cur = CURSOR SCROLL KEYSET FOR 
			   SELECT DivisionID, VoucherID, TransactionID, TypeID, MaterialID, PMID
			   FROM MT0119
	OPEN @Cur
	FETCH NEXT FROM @Cur INTO @DivisionID, @VoucherID, @TransactionID, @TypeID, @MaterialID, @PMID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @UnitPrice = ISNULL(MT18.UnitPrice,0)   
		FROM MT0118 MT18
		WHERE MT18.DivisionID = @DivisionID AND MT18.ID = @PriceListID AND MT18.InventoryID = @MaterialID
		SELECT @WeightTotal = ISNULL(MT14.WeightTotal,0)
		FROM MT0114 MT14
        WHERE MT14.DivisionID = @DivisionID AND MT14.ID = @PMID AND MT14.InventoryID = @MaterialID
		UPDATE MT0119 SET 
			UnitPrice = @UnitPrice,
			ConvertedAmount = 
				CASE WHEN ISNULL(TypeID,0) =3 AND ISNULL(IsVND,0) = 1 THEN ISNULL(Quantity,0)*ISNULL(@UnitPrice,0)
				     WHEN ISNULL(TypeID,0) =3 AND ISNULL(IsVND,0) = 0 THEN ISNULL(Quantity,0)*ISNULL(@UnitPrice,0)*ISNULL(@ExchangeRate,0)
					 WHEN ISNULL(TypeID,0) IN (1,2) THEN 
				             ((ISNULL(@WeightTotal,0)/1000)*ISNULL(@UnitPrice,0)
						  + (ISNULL(@WeightTotal,0)/1000)*ISNULL(@UnitPrice,0)*(ISNULL(VATImPercent,0)/100)
						  + ((ISNULL(@WeightTotal,0)/1000)*ISNULL(@UnitPrice,0) 
						   + (ISNULL(@WeightTotal,0)/1000)*ISNULL(@UnitPrice,0)*(ISNULL(VATImPercent,0)/100))*(ISNULL(VATPercent,0)/100))
						     *ISNULL(@ExchangeRate,0)				     
					 ELSE NULL END 
		WHERE DivisionID = @DivisionID AND VoucherID = @VoucherID AND TransactionID = @TransactionID
		FETCH NEXT FROM @Cur INTO @DivisionID, @VoucherID, @TransactionID, @TypeID, @MaterialID, @PMID
	END
CLOSE @Cur
END
-- Lưu dữ liệu cho bảng [Master - Detail]
INSERT INTO MT0115(DivisionID, VoucherID, TranMonth, TranYear, VoucherTypeID,
            VoucherNo, VoucherDate, CostAmount, CurrencyID, ExchangeRate,
            PriceListID, ProductID, [Description], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate, PMID, IsVND)
SELECT DISTINCT DivisionID, VoucherID, TranMonth, TranYear, VoucherTypeID,
       VoucherNo, VoucherDate, CostAmount, CurrencyID, ExchangeRate, PriceListID,
       ProductID, [Description], CreateUserID, GETDATE(), LastModifyUserID,
       GETDATE(), PMID, IsVND 
FROM MT0119
INSERT INTO MT0116(DivisionID, VoucherID, TransactionID, MaterialID, TypeID,
            UnitPrice, VATImPercent, VATPercent, ConvertedAmount, Orders, Quantity,
            InheritTableID, InheritVoucherID, InheritTransactionID, InheritPCID, InheritAnaID)
SELECT DivisionID, VoucherID, TransactionID, MaterialID, TypeID, UnitPrice,
       VATImPercent, VATPercent, ConvertedAmount, Orders, Quantity, InheritTableID,
       InheritVoucherID, InheritTransactionID, InheritPCID, InheritAnaID
FROM MT0119   

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
