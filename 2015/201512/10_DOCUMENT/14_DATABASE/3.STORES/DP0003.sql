IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[DP0003]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[DP0003]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Created by: Mai Trí Thiện
---- Purpose:  Cập nhật tồn kho vào AT0114 cho DB đích khi kết chuyển bằng tools Data-Tranfer
---- Edited by:
---- Porpose: 
/********************************************
EXEC DP0003 N'ASOFTADMIN, N'SVTHUE', N'SV', N'AD20140000000159'', ''AD20140000000159'
*********************************************/
CREATE PROC DP0003
(
	@UserID			NVARCHAR(50),	-- UserID
	@Destination	NVARCHAR(50),	-- Tên database đích
	@DBID			NVARCHAR(50),	-- Chi nhánh
	@ExVoucherID	NVARCHAR(MAX)	-- Mã phiếu xuất
)
AS	
BEGIN
	DECLARE @SQL NVARCHAR(MAX)
	
	SET @SQL = N'
	DECLARE @Cur CURSOR,
		@DivisionID			NVARCHAR(50),
		@TransactionID		NVARCHAR(50), 
		@VoucherID			NVARCHAR(50), 
		@InventoryID		NVARCHAR(50), 
		@UnitID				NVARCHAR(50),
		@ActualQuantity		DECIMAL(28, 8), 
		@TranMonth			INT, 
		@TranYear			INT, 
		@MarkQuantity		DECIMAL(28, 8),
		@ConversionFactor	DECIMAL(28, 8), 
		@ReVoucherID		NVARCHAR(50), 
		@ReTransactionID	NVARCHAR(50), 
		@CreditAccountID	NVARCHAR(50),  
		@WareHouseID2		NVARCHAR(50),
		@IsSource			TINYINT, 
		@MethodID			TINYINT, 
		@IsLimitDate		TINYINT

	-- SELECT ALL DETAILS
	SET @Cur = CURSOR FORWARD_ONLY
	FOR
		SELECT	a.DivisionID, a.TransactionID, a.VoucherID, a.InventoryID, a.UnitID, a.ActualQuantity, a.TranMonth, a.TranYear, 
				a.MarkQuantity, a.ConversionFactor, a.ReVoucherID, a.ReTransactionID, a.CreditAccountID, a1.WareHouseID,
				A12.IsSource, A12.MethodID, A12.IsLimitDate
		FROM [' + @Destination + '].dbo.AT2006 a1
		INNER JOIN [' + @Destination + '].dbo.AT2007 a ON a.VoucherID = a1.VoucherID AND a.DivisionID = a1.DivisionID
		LEFT JOIN [' + @Destination + '].dbo.AT1302 a12 ON a12.DivisionID = a.DivisionID AND a12.InventoryID = a.InventoryID
		WHERE RIGHT(a1.VoucherID, LEN(a1.VoucherID) - LEN( '''+ @DBID + ''' )) IN (''' + @ExVoucherID + ''')
		AND a1.KindVoucherID IN (2, 4, 6, 8, 10, 12, 14, 16, 18) -- Ex voucher kind id
		AND a1.VoucherID LIKE '''+ @DBID +'%'' -- match case for db id (destination division id)
	
	OPEN @Cur

	FETCH NEXT FROM @Cur
	INTO @DivisionID, @TransactionID, @VoucherID, @InventoryID, @UnitID, @ActualQuantity, @TranMonth, @TranYear, @MarkQuantity,
	@ConversionFactor, @ReVoucherID, @ReTransactionID, @CreditAccountID, @WareHouseID2, @IsSource, @MethodID, @IsLimitDate

	-- UPDATE END-QUANTITY
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC [' + @Destination + '].dbo.[AP7777] ''' + @UserID + ''', @DivisionID, @TranMonth, @TranYear, @WareHouseID2,
			   @InventoryID, @UnitID, @ConversionFactor, @IsSource, @IsLimitDate, @CreditAccountID, NULL, NULL, @ReVoucherID, 
			   @ReTransactionID, 0, @ActualQuantity, 0, @MethodID, 0, @MarkQuantity
		   
		FETCH NEXT FROM @Cur
		INTO @DivisionID, @TransactionID, @VoucherID, @InventoryID, @UnitID, @ActualQuantity, @TranMonth, @TranYear, @MarkQuantity,
		@ConversionFactor, @ReVoucherID, @ReTransactionID, @CreditAccountID, @WareHouseID2, @IsSource, @MethodID, @IsLimitDate
		
	END

	CLOSE @Cur
	DEALLOCATE @Cur
'

	--PRINT(@SQL)
	EXEC(@SQL)
END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
