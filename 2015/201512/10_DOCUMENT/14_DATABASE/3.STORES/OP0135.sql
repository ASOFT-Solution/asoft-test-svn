IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0135]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].OP0135
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO  
-- <Summary>  
---- Insert dữ liệu vào bảng OT3004, OT3005 (phiếu quyết toán khách hàng)  
-- <Param>  
----   
-- <Return>  
----   
-- <Reference>  
----   
-- <History>  
---- Create on 27/10/2014 Mai Trí Thiện
---- edit by Quốc Tuấn 01/06/2015 bổ sung thêm ngày quyết toán
-- <Example>  
----  
/*
	EXEC OP0135	'BBL', 'ASOFTADMIN', 10, 2014, '','2015-06-01 16:21:48.417'
*/
CREATE PROCEDURE OP0135  
(  
 @DivisionID NVARCHAR(50),  
 @UserID NVARCHAR(50),
 @TranMonth INT,  
 @TranYear INT, 
 @TransactionIDs NVARCHAR(MAX), --- Danh sách transactionid chi tiết quyết toán
 @OrderDate AS DATETIME 
)   
AS   
DECLARE @sSQL NVARCHAR(MAX)
SET @sSQL = '
DECLARE	@VoucherID VARCHAR(250),  
	@VoucherTypeID VARCHAR(50),
	@VoucherNo VARCHAR(50),
	@S1	NVARCHAR(50),
	@S2	NVARCHAR(50),
	@S3	NVARCHAR(50),
	@OutputLenght TINYINT,
	@OutputOrder TINYINT,
	@Seperated TINYINT,
	@Seperator NVARCHAR(5),
	@Cur CURSOR,
	@TranMonth INT,
	@TranYear INT,
	@DivisionID NVARCHAR(50),
	@UserID NVARCHAR(50),
	@ObjectID NVARCHAR(50)


	SET @TranMonth = ' + CONVERT(NVARCHAR(2), @TranMonth) + '
	SET @TranYear = ' + CONVERT(NVARCHAR(4), @TranYear) + '
	SET @DivisionID = N''' + @DivisionID + '''
	SET @UserID = N''' + @UserID + '''


	SELECT @S1 = S1, @S2 = S2, @S3 = S3 FROM dbo.S123(@DivisionID, ''QT'',  @TranMonth, @TranYear)

	--- Tao so chung tu moi
	CREATE TABLE #VoucherNo (VoucherNo VARCHAR(50))  
	SELECT @VoucherTypeID = VoucherTypeID, @OutputLenght = OutputLength,  
	 @OutputOrder = OutputOrder, @Seperated = Separated, @Seperator = Separator FROM AT1007 WHERE VoucherTypeID = ''QT''  
	 INSERT INTO #VoucherNo  
	 EXEC AP0000 @DivisionID, @VoucherNo, ''OT3004'', @S1, @S2, @S3, @OutputLenght, @OutputOrder, @Seperated, @Seperator  
	 SELECT @VoucherNo = VoucherNo FROM #VoucherNo  
 
	--- Ma chung tu moi
	SET @VoucherID = NEWID()

	SELECT TOP 1 @ObjectID = OT3001.ObjectID
	From OT3001 OT3001
	LEFT JOIN OT3002 ON OT3002.DivisionID = OT3001.DivisionID AND OT3002.POrderID = OT3001.POrderID
	Where OT3002.TransactionID IN ('''+@TransactionIDs+''')

	--- Begin insertion transaction 
	BEGIN TRAN T1

	--- Luu thong tin quyet toan
	INSERT INTO OT3004(APK, DivisionID, TranMonth, TranYear, OrderID, VoucherTypeID, VoucherNo, ObjectID, OrderDate, 
						CreateDate, CreateUserID, LastModifyDate, LastModifyUserID)
	VALUES(NEWID(), @DivisionID, @TranMonth, @TranYear, @VoucherID, ''QT'', @VoucherNo, @ObjectID, 
			'''+Convert(varchar,@OrderDate)+''', GETDATE(), @UserID, GETDATE(), @UserID)

	--- Luu chi tiet quyet toan
	INSERT INTO OT3005 (APK, DivisionID, RefTransactionID, OrderID, TransactionID, InventoryID, 
		OrderQuantity, OriginalAmount,
		ConvertedAmount, PurchasePrice, 
		VATPercent, VATConvertedAmount,  
		VATOriginalAmount, Orders, UnitID, 
		Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,
		Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID, 
		Notes, Notes01, Notes02, Notes03, Notes04, 
		Notes05, Notes06, Notes07, Notes08, Notes09, ReceiveDate,
		CreateDate, CreateUserID, LastModifyDate, LastModifyUserID)
	SELECT NEWID(), @DivisionID, OT3002.TransactionID, @VoucherID, NEWID(), OT3002.InventoryID, 
		OT3002.OrderQuantity, (OT3002.OrderQuantity * OT3002.PurchasePrice),
		OT3002.ConvertedAmount, OT3002.PurchasePrice, 
		OT3002.VATPercent, OT3002.VATConvertedAmount,  
		(OT3002.OrderQuantity * OT3002.PurchasePrice) * OT3002.VATPercent / 100, OT3002.Orders, OT3002.UnitID, 
		OT3002.Ana01ID, OT3002.Ana02ID, OT3002.Ana03ID, OT3002.Ana04ID, OT3002.Ana05ID,
		OT3002.Ana06ID, OT3002.Ana07ID, OT3002.Ana08ID, OT3002.Ana09ID, OT3002.Ana10ID, 
		OT3002.Notes, OT3002.Notes01, OT3002.Notes02, OT3002.Notes03, OT3002.Notes04, 
		OT3002.Notes05,	OT3002.Notes06, OT3002.Notes07, OT3002.Notes08, OT3002.Notes09, OT3002.ReceiveDate,
		GETDATE(), @UserID, GETDATE(), @UserID
		FROM OT3002 OT3002
		Where OT3002.TransactionID IN ('''+@TransactionIDs+''')

	--- Cap nhat tinh trang chi tiet xac nhan da quyet toan
	UPDATE OT3002
	SET Finish = 1
	WHERE TransactionID IN ('''+@TransactionIDs+''')

	--- Commit transaction
	COMMIT TRAN T1
'
PRINT(@sSQL)
EXEC(@sSQL)
