IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[WP2018]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[WP2018]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
---- ?i?u ch?nh kho cho phù h?p v?i S? L??ng ?i?u Ch?nh
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Nguy?n Thanh Th?nh, Date: 16/09/2015
---- Modified on 15/12/2015 by Phương Thảo : Chỉnh sửa cách sinh VoucherID, TransactionID (sinh lại theo chuẩn store AP0002)
-- <Example>
---- 
/*
	EXEC WP2018 @DivisionID = 'MSI', @VoucherID = '06d45241-b0d9-4165-9a45-d3299c6559e0', @TranMonth = 6',@TranYear = 2015 , @CreateBy = 'NV002', @Result = @Result output
*/


CREATE PROCEDURE [dbo].[WP2018] 	
@DivisionID nvarchar(50) ,
@VoucherID nvarchar(50) ,
@TranMonth int ,
@TranYear int ,
@CreateBy nvarchar(50),
@Result int output,
@IsImport int = 0
AS
BEGIN
	
BEGIN TRANSACTION
BEGIN TRY

-- Insert d? li?u t?ng Ho?t Gi?m
CREATE TABLE #TMP_PreIncrease
(DivisionID nvarchar(50),TransactionID nvarchar(50),VoucherID nvarchar(50), InventoryID nvarchar(250),
UnitID nvarchar(50), ActualQuantity DECIMAL(28), UnitPrice decimal(28), OriginalAmount DECIMAL(28),
ConvertedAmount DECIMAL(28), TranMonth int, TranYear int, CurrencyID nvarchar(50),DebitAccountID nvarchar(10),
CreditAccountID nvarchar(10), [Orders] int, ConversionFactor DECIMAL(28),Notes NVARCHAR(250),SourceNo NVARCHAR(50),
LimitDate datetime, [Status] int )

INSERT INTO #TMP_PreIncrease(DivisionID, TransactionID, VoucherID, InventoryID,
		UnitID, [ActualQuantity], [UnitPrice], [OriginalAmount],
		ConvertedAmount,TranMonth, TranYear,CurrencyID ,DebitAccountID,CreditAccountID,Orders,[ConversionFactor],
			Notes, SourceNo, LimitDate,[Status])
SELECT	AT37.DivisionID, TransactionID, VoucherID, InventoryID,UnitID,
		CASE WHEN  ISNULL(AdjustQuantity,0) > ISNULL(Quantity,0) THEN ISNULL(AdjustQuantity,0) - ISNULL(Quantity,0) ELSE  ISNULL(Quantity,0) - ISNULL(AdjustQuantity,0)   END [ActualQuantity],
		ISNULL(AdjustUnitPrice,0) [UnitPrice], ISNULL(AdjutsOriginalAmount,0) [OriginalAmount],
		ConvertedAmount,TranMonth, TranYear,AT04.CurrencyID ,DebitAccountID,DebitAccountID CreditAccountID,
		Orders, AT04.ExchangeRate [ConversionFactor], Notes, SourceNo, LimitDate, 
		CASE WHEN  ISNULL(AdjustQuantity,0) > ISNULL(Quantity,0) THEN 1 ELSE 2 END [Status]
FROM AT2037 AT37
LEFT JOIN AT1004 AT04 ON AT04.CurrencyID = 'VND' AND AT04.DivisionID = AT37.DivisionID
WHERE VoucherID = @VoucherID
GROUP BY AT37.DivisionID, TransactionID, VoucherID, InventoryID, UnitID, Quantity , UnitPrice, OriginalAmount, ConvertedAmount,
		AdjustQuantity, AdjustUnitPrice, AdjutsOriginalAmount, Notes, TranMonth, TranYear, SourceNo, 
		DebitAccountID, LimitDate, Orders,AT04.CurrencyID ,AT04.ExchangeRate
HAVING AdjustQuantity is not null and(ISNULL(Quantity,0) < ISNULL(AdjustQuantity,0) OR ISNULL(Quantity,0) > ISNULL(AdjustQuantity,0))

	--CREATE TABLE #TMP_MasterInfo
	--(DivisionID nvarchar(50),VoucherID nvarchar(50), TableID nvarchar(50),VoucherDate DATETIME,VoucherNo nvarchar(50),
	-- WareHouseID nvarchar(50), EmployeeID nvarchar(50),Createby nvarchar(50), CreateDate DATETIME)

	--INSERT INTO #TMP_MasterInfo(DivisionID, VoucherID, TableID, VoucherDate,VoucherNo,WareHouseID, EmployeeID,Createby,CreateDate)
	--SELECT DivisionID, VoucherID, TableID, VoucherDate,VoucherNo,WareHouseID, EmployeeID,@Createby,Getdate()
	--FROM AT2036 AT36
	--WHERE AT36.VoucherID = @VoucherID


IF EXISTS (SELECT TOP 1 1 FROM #TMP_PreIncrease HAVING COUNT(*) > 0) 
BEGIN
	DECLARE 
	@VALUE INT = 0,
	@S1 NVARCHAR(50) = '',
	@S2 NVARCHAR(50) = '',
	@S3 NVARCHAR(50) = '',
	@OutputLenght INT = 0,
	@OutputOrder INT = 0, 	--- 0 NSSS; 1 SNSS, 2 SSNS, 3 SSSN
	@Seperated INT = 0,
	@Seperator NVARCHAR(1) = '',
	@IncreaVoucher nvarchar(50)= '',
	@DescVoucher nvarchar(50)= ''

		
	-- Sinh khóa
	DECLARE @cKey AS CURSOR

	DECLARE	@TransactionID AS NVARCHAR(50),
			@New_TransID AS NVARCHAR(50),
			@InVoucherID AS NVARCHAR(50),
			@DeVoucherID AS NVARCHAR(50),
			@Orders AS INT

	SELECT @VALUE = COUNT(*) FROM #TMP_PreIncrease WHERE [Status] =1

	IF(@VALUE >0)
	BEGIN
		 
		SELECT @S1 = at07.S1, @S2 = at07.S2, @S3 = at07.S3,@OutputLenght = at07.OutputLength,
				@OutputOrder = at07.OutputOrder, @Seperated = at07.Separated, @Seperator = at07.separator
		FROM WT0000 WT00
		LEFT JOIN AT1007 AT07
			ON AT07.VoucherTypeID = WT00.VoucherNoIncre
			AND AT07.DivisionID = WT00.DefdivisionID
	
		-- SINH SO PHIEU
		EXEC AP0000 @DivisionID, @IncreaVoucher output, 'AT9000', @S1, @S2, @S3, @OutputLenght, @OutputOrder, @Seperated, @Seperator  

		-- SINH VOUCHERID
		EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @InVoucherID OUTPUT, @TableName = 'AT2006', @StringKey1 = 'IN', @StringKey2 = @TranYear, @OutputLen = 16

		SET @VALUE = 0
					
	END

	SELECT @VALUE = COUNT(*) FROM #TMP_PreIncrease WHERE [Status] =2
		
	IF(@VALUE >0)
	BEGIN
		
		SELECT @S1 = at07.S1, @S2 = at07.S2, @S3 = at07.S3,@OutputLenght = at07.OutputLength,
				@OutputOrder = at07.OutputOrder, @Seperated = at07.Separated, @Seperator = at07.separator
		FROM WT0000 WT00
		LEFT JOIN AT1007 AT07
			ON AT07.VoucherTypeID = WT00.VoucherNoDecs
			AND AT07.DivisionID = WT00.DefdivisionID
			
		-- SINH SO PHIEU
		EXEC AP0000 @DivisionID, @DescVoucher output, 'AT9000', @S1, @S2, @S3, @OutputLenght, @OutputOrder, @Seperated, @Seperator  

		-- SINH VOUCHERID			
		EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @DeVoucherID OUTPUT, @TableName = 'AT2006', @StringKey1 = 'DE', @StringKey2 = @TranYear, @OutputLen = 16

		SET @VALUE = 0
	END
	
			
SET @cKey = CURSOR FOR
SELECT	ROW_NUMBER() over (order by (select 1)), TransactionID	 
FROM	#TMP_PreIncrease
WHERE	Status = 1

OPEN @cKey
	FETCH NEXT FROM @cKey INTO @Orders, @TransactionID
	WHILE @@FETCH_STATUS = 0
	BEGIN	
	
		EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @New_TransID OUTPUT, @TableName = 'AT2007', @StringKey1 = 'IT', @StringKey2 = @TranYear, @OutputLen = 16
	
		UPDATE  #TMP_PreIncrease  
		SET		TransactionID = @New_TransID,
				Orders = @Orders
		WHERE	TransactionID = @TransactionID AND Status = 1

	FETCH NEXT FROM @cKey INTO  @Orders, @TransactionID	
	END	
CLOSE @cKey


SET @cKey = CURSOR FOR
SELECT	ROW_NUMBER() over (order by (select 1)), TransactionID	 
FROM	#TMP_PreIncrease
WHERE	Status = 2

OPEN @cKey
	FETCH NEXT FROM @cKey INTO @Orders, @TransactionID
	WHILE @@FETCH_STATUS = 0
	BEGIN	
	
		EXEC AP0002 @DivisionID = @DivisionID, @NewKey = @New_TransID OUTPUT, @TableName = 'AT2007', @StringKey1 = 'DT', @StringKey2 = @TranYear, @OutputLen = 16
	
		UPDATE  #TMP_PreIncrease  
		SET		TransactionID = @New_TransID,				
				Orders = @Orders
		WHERE	TransactionID = @TransactionID AND Status = 2

	FETCH NEXT FROM @cKey INTO @Orders, @TransactionID	
	END	
CLOSE @cKey

UPDATE TD
SET	TD.DebitAccountID = CASE WHEN status = 1 THEN TD.DebitAccountID ELSE AT07_1.DebitAccountID END, 
TD.CreditAccountID  = CASE WHEN status = 1 THEN AT07_2.CreditAccountID ELSE TD.CreditAccountID END,
TD.VoucherID = CASE WHEN status = 1 THEN @InVoucherID ELSE @DeVoucherID END
FROM  #TMP_PreIncrease TD
INNER JOIN WT0000 WT00 ON WT00.DefDivisionID = TD.DivisionID
LEFT JOIN AT1007 AT07_1
		ON AT07_1.VoucherTypeID = WT00.VoucherNoIncre
		AND AT07_1.DivisionID = WT00.DefdivisionID
LEFT JOIN AT1007 AT07_2
		ON AT07_2.VoucherTypeID = WT00.VoucherNoDecs
		AND AT07_2.DivisionID = WT00.DefdivisionID


--- INSERT PHI?U XU?T HAY NH?P KHO
	INSERT INTO AT2006
	(	DivisionID,VoucherID,TableID,TranMonth,TranYear,VoucherTypeID,VoucherDate,
		VoucherNo,WareHouseID, KindVoucherID, Status, EmployeeID,CreateUserID, CreateDate,
		LastModifyUserID ,LastModifyDate )
	SELECT DivisionID, TMP.VoucherID,'AT2006', @TranMonth, @TranYear , TMP.VoucherTypeID , AT06.VoucherDate,
			TMP.VoucherNo, AT06.WareHouseID, TMP.[KindVoucherID], 0,AT06.EmployeeID, @CreateBy, GETDATE(),@CreateBy, GETDATE()
	FROM AT2036 AT06
		LEFT JOIN (		SELECT	MAX(VoucherID) [VoucherID] , 									
							CASE WHEN Status = 1 THEN WT00.VoucherNoIncre 
									WHEN Status = 2 THEN WT00.VoucherNoDecs
									ELSE '' END [VoucherTypeID],
							CASE WHEN Status = 1 THEN @IncreaVoucher
									WHEN Status = 2 THEN @DescVoucher
									ELSE '' END [VoucherNo],
							CASE WHEN Status = 1 THEN 9
									WHEN Status = 2 THEN 8
									ELSE '' END [KindVoucherID]
						FROM #TMP_PreIncrease TMP
						LEFT JOIN WT0000 WT00
							ON TMP.DIVISIONID = WT00.DefDivisionID 
						GROUP BY VoucherID,Status,VoucherNoIncre,VoucherNoDecs
					) TMP ON 1 = 1
	WHERE AT06.VoucherID = @VoucherID
			  	
	-- INSERT THÔNG TIN XU?T NH?P KHO
	INSERT INTO AT2007 (DivisionID, TransactionID, VoucherID, InventoryID,UnitID, [ActualQuantity], [UnitPrice], 
					[OriginalAmount],ConvertedAmount,TranMonth, TranYear, CurrencyID ,DebitAccountID,CreditAccountID,
					Orders,[ConversionFactor],Notes, SourceNo, LimitDate)			
	SELECT DivisionID, TransactionID, VoucherID, InventoryID,UnitID, [ActualQuantity], [UnitPrice], 
					[OriginalAmount],[OriginalAmount],TranMonth, TranYear, CurrencyID ,DebitAccountID,CreditAccountID,
					Orders,[ConversionFactor],Notes, SourceNo, LimitDate
	FROM #TMP_PreIncrease 	
END

	DROP TABLE #TMP_PreIncrease
	SET @Result = 1 

COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	SET @Result = -1
END CATCH
IF @IsImport = 0 
	select @Result as Result


END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
