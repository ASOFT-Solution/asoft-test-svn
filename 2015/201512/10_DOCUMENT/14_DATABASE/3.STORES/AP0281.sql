IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0281]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0281]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
---- Kết chuyển dữ liệu từ POS
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 03/06/2014 by Le Thi Thu Hien
---- 
---- Modified on 25/06/2014 by Le Thi Thu Hien : Kết chuyển thông tin chi tiết không SUM lại
---- Modified on 08/07/2014 by Le Thi Thu Hien : Phiếu trả hàng
---- Modified on 22/07/2014 by Le Thi Thu Hien : Bổ sung thêm mã phân tích chi phí
---- Modified on 25/07/2014 by Le Thi Thu Hien : Sửa lại tài khoản kết chuyển bên POS bị ngược
---- Modified on 29/07/2014 by Le Thi Thu Hien : Bổ sung thêm điều kiện phiếu trả hàng
---- Modified on 22/08/2014 by Le Thi Thu Hien : NULLIF(SUMAmount,0) 
---- Modified on 04/09/2014 by Le Thi Thu Hien : Sửa lại phần lấy mặt hàng phiếu kết chuyển (mantis 0022700 )
---- Modified on 05/09/2014 by Le Thi Thu Hien : Sửa lại tài khoản thuế của phiếu kết chuyển ngược lại với bán hàng (mantis 0022702 )
---- Modified on 10/09/2014 by Le Thi Thu Hien : Sửa lại lưu phiếu nhập và phiếu xuất VoucherID = AT9000.VoucherID
---- Modified on 24/09/2014 by Le Thi Thu Hien : Sửa lại AT9000 thành AT2006 Khi INSERT vào bảng AT2006
-- <Example>
---- EXEC AP0281 'KC', 6, 2014, 'MXM32', '2014-06-25', 'asoftadmin', 'DE50BAA5-EF70-412B-95EA-225478AD498F'
CREATE PROCEDURE AP0281
( 
	@DivisionID AS NVARCHAR(50),
	@TranMonth AS INT,
	@TranYear AS INT,
	@AnaID AS NVARCHAR(50),
	@VoucherDate AS DATETIME,
	@UserID AS NVARCHAR(50) ,
	@VoucherID AS NVARCHAR(50) 
) 
AS 
----------->>>>>>>>>>>> Hóa đơn bán hàng
DECLARE @sSQL1 AS NVARCHAR(MAX)
DECLARE @sSQL2 AS NVARCHAR(MAX)
DECLARE @sSQL3 AS NVARCHAR(MAX)
DECLARE @sSQL4 AS NVARCHAR(MAX)
DECLARE @sSQL5 AS NVARCHAR(MAX)
DECLARE @sSQL6 AS NVARCHAR(MAX)
DECLARE @sSQL7 AS NVARCHAR(MAX)
DECLARE @sSQL8 AS NVARCHAR(MAX)

DECLARE @sSQL11 AS NVARCHAR(MAX)
DECLARE @sSQL12 AS NVARCHAR(MAX)
DECLARE @sSQL13 AS NVARCHAR(MAX)
DECLARE @sSQL14 AS NVARCHAR(MAX)
DECLARE @sSQL15 AS NVARCHAR(MAX)
DECLARE @sSQL16 AS NVARCHAR(MAX)
DECLARE @sSQL17 AS NVARCHAR(MAX)
DECLARE @sSQL18 AS NVARCHAR(MAX)


DECLARE @EmployeeAnaTypeID AS NVARCHAR(50),
		@ShopAnaTypeID AS NVARCHAR(50),
		@CostAnaTypeID AS NVARCHAR(50)

SET @ShopAnaTypeID = (
SELECT RIGHT(TypeID, 2) 
FROM AT0005 
WHERE	DivisionID = @DivisionID
		AND TypeID = ( SELECT TOP 1 ShopAnaTypeID 
					 FROM	AT0280 
					 WHERE	AT0280.DivisionID = @DivisionID 
							AND AT0280.VoucherID = @VoucherID)
							)
						
SET @EmployeeAnaTypeID = (
SELECT RIGHT(TypeID, 2) 
FROM AT0005 
WHERE DivisionID = @DivisionID
		AND TypeID = ( SELECT TOP 1 EmployeeAnaTypeID
                 FROM	AT0280 
                 WHERE	AT0280.DivisionID = @DivisionID 
						AND AT0280.VoucherID = @VoucherID)
)

SET @CostAnaTypeID = (
SELECT RIGHT(TypeID, 2) 
FROM AT0005 
WHERE DivisionID = @DivisionID
		AND TypeID = ( SELECT TOP 1 CostAnaTypeID
                 FROM	AT0280 
                 WHERE	AT0280.DivisionID = @DivisionID 
						AND AT0280.VoucherID = @VoucherID)
)
IF @CostAnaTypeID IS NULL SET @CostAnaTypeID = '02'

--SELECT * FROM AT1011 WHERE AnaTypeID = 'A04'
--SELECT * FROM AT1015 WHERE AnaTypeID = 'O05'
INSERT INTO AT1011 (DivisionID, AnaTypeID, AnaID, AnaName)
SELECT	@DivisionID,'A'+@ShopAnaTypeID, AnaID, AnaName
FROM	AT1015
WHERE	DivisionID = @DivisionID
		AND AnaTypeID = (SELECT TOP 1 ShopTypeID 
						 FROM POST0001 
						 WHERE POST0001.DivisionID = @DivisionID )
		AND AnaID NOT IN (SELECT AnaID FROM AT1011 WHERE AT1011.DivisionID = @DivisionID)
		
INSERT INTO AT1011 (DivisionID, AnaTypeID, AnaID, AnaName)
SELECT	DISTINCT @DivisionID,'A'+@EmployeeAnaTypeID, EmployeeID, EmployeeName
FROM	POST0016
WHERE	DivisionID = @DivisionID
		AND EmployeeID NOT IN (SELECT AnaID FROM AT1011 WHERE AT1011.DivisionID = @DivisionID)		

--IF @ShopAnaTypeID IS NULL 
--	SET @ShopAnaTypeID = '04'	
--IF @ShopAnaTypeID IS NULL 
--	SET @ShopAnaTypeID = '03'			

SET @sSQL1 = N'


DECLARE @ObjectID AS NVARCHAR(50),
		@WareHouseID AS NVARCHAR(50),
		@ObjectName AS NVARCHAR(250),
		@Address AS NVARCHAR(250),
		@VATNo AS NVARCHAR(50),
		@DebitAccountID AS NVARCHAR(50),
		@CreditAccountID AS NVARCHAR(50),
		@CostDebitAccountID AS NVARCHAR(50),
		@CostCreditAccountID AS NVARCHAR(50),
		@PayDebitAccountID AS NVARCHAR(50),
		@PayCreditAccountID AS NVARCHAR(50),
		@TaxCreditAccountID AS NVARCHAR(50),
		@TaxDebitAccountID AS NVARCHAR(50)
				
SELECT	@DebitAccountID = DebitAccountID,
		@CreditAccountID = CreditAccountID,
		@CostDebitAccountID = CostDebitAccountID,
		@CostCreditAccountID = CostCreditAccountID,
		@PayDebitAccountID = PayDebitAccountID,
		@PayCreditAccountID = PayCreditAccountID,
		@TaxDebitAccountID = TaxDebitAccountID,
		@TaxCreditAccountID = TaxCreditAccountID,
		@ObjectID = ObjectID,
		@WareHouseID = WareHouseID
FROM	POST0010 P 
WHERE	P.DivisionID = '''+@DivisionID+''' 
		AND P.ShopID = '''+@AnaID+'''
		
SELECT	@ObjectName = ObjectName ,
		@Address  = Address ,
		@VATNo = VATNo
FROM AT1202 
WHERE AT1202.DivisionID = N'''+@DivisionID+'''  
		AND AT1202.ObjectID = @ObjectID 


DECLARE 
@SalesVoucherTypeID AS NVARCHAR(50),
@SalesVoucherNo AS NVARCHAR(50),
@SalesVDescription AS NVARCHAR(250),
@EmployeeID AS NVARCHAR(50),
@InvoiceCode AS NVARCHAR(50),
@InvoiceSign AS NVARCHAR(50),
@InvSerial AS NVARCHAR(50),
@InvNo AS NVARCHAR(50),
@InvDate AS DATETIME,
@InvVATType AS NVARCHAR(50),
@CurrencyID AS NVARCHAR(50),
@ExchangeRate AS DECIMAL(28,8),
@WareVoucherTypeID AS NVARCHAR(50),
@WareVDescription AS NVARCHAR(250),
@WareVoucherNo AS NVARCHAR(50),
@InvVoucherID AS NVARCHAR(50),
@BatchID AS NVARCHAR(50),
@WareVoucherID AS NVARCHAR(50),
@ReturnVoucherID AS NVARCHAR(50), 
@ImWareVoucherID AS NVARCHAR(50),
@ReturnVoucherTypeID AS NVARCHAR(50),
@ImWareVoucherTypeID AS NVARCHAR(50),
@ReturnVoucherNo AS NVARCHAR(50),
@ImWareVoucherNo AS NVARCHAR(50),
@ReturnVDescription AS NVARCHAR(250),
@ImWareVDescription AS NVARCHAR(250),
@VATDescription AS NVARCHAR(250),
@CostAnaID AS NVARCHAR(50)

SET @InvVoucherID = NEWID()
SET @BatchID = NEWID()
SET @WareVoucherID = NEWID()
SET @ReturnVoucherID = NEWID()
SET @ImWareVoucherID = NEWID()


'
SET @sSQL2 = N'

SELECT	@SalesVoucherTypeID = A.SalesVoucherTypeID, 
		@SalesVoucherNo = A.SalesVoucherNo,
		@SalesVDescription = ISNULL(A.SalesVDescription,N''Kết chuyển dữ liệu bán hàng từ POS''), 
		@EmployeeID = A.EmployeeID, 
		@InvoiceCode = A.InvoiceCode, 
		@InvoiceSign = A.InvoiceSign,
		@InvSerial = A.InvSerial, 
		@InvNo = A.InvNo, 
		@InvDate = A.InvDate, 
		@InvVATType = A.InvVATType, 
		@CurrencyID = A.CurrencyID, 
		@ExchangeRate = A.ExchangeRate,
		@WareVoucherTypeID = A.WareVoucherTypeID, 
		@WareVDescription = ISNULL(A.WareVDescription,N''Kết chuyển dữ liệu bán hàng từ POS''), 
		@WareVoucherNo = A.WareVoucherNo,
		@ReturnVoucherTypeID = A.ReturnVoucherTypeID,
		@ImWareVoucherTypeID = A.ImWareVoucherTypeID,
		@ReturnVoucherNo = A.ReturnVoucherNo,
		@ImWareVoucherNo = A.ImWareVoucherNo,
		@ReturnVDescription = ISNULL(A.ReturnVDescription,N''Kết chuyển dữ liệu bán hàng từ POS''), 
		@ImWareVDescription = ISNULL(A.ImWareVDescription,N''Kết chuyển dữ liệu bán hàng từ POS''), 
		@VATDescription = N''Thuế giá trị gia tăng của hàng hoá, dịch vụ.'',
		@CostAnaID = CostAnaID
FROM AT0280 A
WHERE A.DivisionID = '''+@DivisionID+'''
AND A.AnaID = '''+@AnaID+'''
AND Convert(nvarchar(10),A.VoucherDate,21) = CONVERT(Nvarchar(10),'''+Convert(nvarchar(10),@VoucherDate,21)+''',21)
AND A.VoucherID = '''+@VoucherID+'''
'
SET @sSQL3 = N'
-------------------->>>>>>>>>>>>Doanh thu -------------------------------
INSERT INTO AT9000
(
	DivisionID,	VoucherID,	BatchID,	TransactionID,	
	TableID,	ReTableID, TranMonth,	TranYear,	TransactionTypeID,
	CurrencyID,	ObjectID,	CreditObjectID,	VATNo,	
	VATObjectID,	VATObjectName,	VATObjectAddress,
	DebitAccountID,	CreditAccountID,
	ExchangeRate,	UnitPrice,	OriginalAmount,	ConvertedAmount,
	ImTaxOriginalAmount,	ImTaxConvertedAmount,
	IsStock,	VoucherDate,	InvoiceDate,
	VoucherTypeID,	VATTypeID,	VoucherNo,
	Serial,	InvoiceNo,	EmployeeID,	VDescription,	
	Quantity,	InventoryID,	UnitID,	[Status],

	CreateDate,	CreateUserID,	LastModifyDate,	LastModifyUserID,
	OriginalAmountCN,	ExchangeRateCN,	CurrencyIDCN,
	VATGroupID, 
	BDescription, TDescription,
	VATOriginalAmount, VATConvertedAmount,
	IsMultiTax,
	ConvertedQuantity,	ConvertedPrice,	ConvertedUnitID,
	MarkQuantity,	ConversionFactor,
	ReVoucherID,	DiscountAmount, Ana'+@ShopAnaTypeID+'ID, Ana'+@EmployeeAnaTypeID+'ID, Ana'+@CostAnaTypeID+'ID

)

--------------->>>>>>>Tài khoản nợ, Tài khoản có, Tiền chiết khấu, Tiền doanh thu ------------------------
SELECT	'''+@DivisionID+''',	@InvVoucherID,	@BatchID,	NEWID(),	
		''AT9000'', ''POST0016'',	'+STR(@TranMonth)+',		'+STR(@TranYear)+',	''T04'',
		@CurrencyID,	@ObjectID,		@ObjectID,	@VATNo,
		@ObjectID,		@ObjectName AS VATObjectName,				@Address AS VATObjectAddress,
		B.DebitAccountID,				B.CreditAccountID,
		@ExchangeRate,	B.UnitPrice,	(B.Amount - ISNULL(B.DiscountAmount,0)) AS OriginalAmount,	(B.Amount - ISNULL(B.DiscountAmount,0)) AS ConvertedAmount,
		0 AS ImTaxOriginalAmount,		0 AS ImTaxConvertedAmount,
		1 AS IsStock,	'''+Convert(nvarchar(10),@VoucherDate,21)+''',	@InvDate AS InvoiceDate,
		@SalesVoucherTypeID AS VoucherTypeID,	@InvVATType AS VATTypeID,	@SalesVoucherNo,
		@InvSerial AS Serial,	@InvNo AS InvoiceNo,	@EmployeeID,	@SalesVDescription AS VDescription,
		B.ActualQuantity AS Quantity,	B.InventoryID,	B.UnitID,	0 AS [Status],
		
		GETDATE(),	@EmployeeID,	GETDATE(),	@EmployeeID,
		(B.Amount - ISNULL(B.DiscountAmount,0)) AS OriginalAmountCN,	@ExchangeRate AS ExchangeRateCN,	@CurrencyID AS CurrencyIDCN,
		B.VATGroupID, 
		B.BDescription,	B.BDescription AS TDescription,
		B.TaxAmount AS VATOriginalAmount, 	B.TaxAmount AS VATConvertedAmount,
		1 AS IsMultiTax,
		B.ActualQuantity AS ConvertedQuantity,	B.UnitPrice AS ConvertedPrice,	B.UnitID AS ConvertedUnitID,
		B.ActualQuantity AS MarkQuantity,	1 AS ConversionFactor,
		'''+@VoucherID+''', B.DiscountAmount, '''+@AnaID+''', B.EmployeeID, @CostAnaID
	
FROM 
	(
'
SET @sSQL4 = N'
SELECT	  D.InventoryID 
		, D.UnitID 
		, D.ActualQuantity 
		, D.UnitPrice 
		, D.Amount 
		, CASE WHEN D.IsPromotion = 1 THEN @CostDebitAccountID ELSE @DebitAccountID END AS DebitAccountID
		, CASE WHEN D.IsPromotion = 1 THEN @CostCreditAccountID ELSE @CreditAccountID END AS CreditAccountID
		, (Isnull(D.DiscountAmount, 0) +(Isnull(M.TotalDiscountAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0) + (Isnull(M.TotalRedureAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0) ) as DiscountAmount
		, Isnull(D.Amount, 0) - Isnull(D.DiscountAmount, 0)
				   - (Isnull(M.TotalDiscountAmount, 0)* Isnull(D.Amount, 0))/NULLIF(SUMAmount,0)
				   - (Isnull(M.TotalRedureAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0) as Revenue
		, ((Isnull(D.Amount, 0) - Isnull(D.DiscountAmount, 0) 
				   - (Isnull(M.TotalDiscountAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0) 
				   - (Isnull(M.TotalRedureAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0)) * D.VATPercent) as TaxAmount
		,ISNULL(D.VATGroupID,A.VATGroupID) AS  VATGroupID
		,D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID, D.Ana06ID,
		D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID,
		M.VoucherNo +'' ''+ M.ShopID +'' ''+M.ObjectName AS BDescription, M.EmployeeID		
FROM POST0016 M 
INNER JOIN POST00161 D on M.APK=D.APKMaster and M.DeleteFlg=D.DeleteFlg
LEFT JOIN AT1302 A ON A.DivisionID = D.DivisionID AND A.InventoryID = D.InventoryID
INNER JOIN 
	(
	SELECT	SUM (P.Amount) AS SUMAmount, P.APKMaster
	FROM	POST00161 P
	LEFT JOIN POST0016 P2
		ON P2.DivisionID = P.DivisionID
		AND P2.APK = P.APKMaster
	WHERE	P.DivisionID = '''+@DivisionID+''' 
			AND P.ShopID = '''+@AnaID+'''
			AND ISNULL(P2.IsTransferred,0) = 0
			AND P.DeleteFlg = 0
			AND Convert(nvarchar(10),P2.VoucherDate,21) = '''+Convert(nvarchar(10),@VoucherDate,21)+'''
	GROUP BY P.APKMaster
	) P1
	ON P1.APKMaster = M.APK
Where	M.DivisionID = '''+@DivisionID+''' 
		and M.ShopID = '''+@AnaID+''' 
		and M.DeleteFlg = 0 
		and Convert(nvarchar(10),M.VoucherDate,21) = '''+Convert(nvarchar(10),@VoucherDate,21)+'''
		and (M.VoucherTypeID = (SELECT TOP 1 VoucherType05 FROM POST0004 WHERE DivisionID = '''+@DivisionID+''' AND ShopID = '''+@AnaID+''')	
			OR (M.VoucherTypeID = (SELECT TOP 1 VoucherType12 FROM POST0004 WHERE DivisionID = '''+@DivisionID+''' AND ShopID = '''+@AnaID+''') AND D.IsKindVoucherID = 1 ) )
		AND ISNULL(M.IsTransferred,0) = 0	
		AND M.APK IN (SELECT D.APKMaster FROM AT0281 D WHERE D.DivisionID = '''+@DivisionID+''' AND D.VoucherID = '''+@VoucherID+''' )
Group by D.InventoryID, D.UnitID, D.ActualQuantity, D.UnitPrice, D.Amount, 
		M.TotalDiscountAmount, D.DiscountAmount, M.TotalRedureAmount, D.VATPercent,
		D.VATGroupID,D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID, D.Ana06ID,
		D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID,
		M.VoucherNo, M.ShopID,M.ObjectName,
		D.APK,SUMAmount, A.VATGroupID , M.EmployeeID, D.IsPromotion
	) B

--------------------<<<<<<<<<Doanh thu -------------------------------
'
SET @sSQL5 = N'
-------------------->>>>>>>>>>>>Thuế-------------------------------
INSERT INTO AT9000
(
	DivisionID,	VoucherID,	BatchID,	TransactionID,
	TableID,	ReTableID, TranMonth,	TranYear,	TransactionTypeID,
	CurrencyID,	ObjectID,	CreditObjectID,
	VATNo,	VATObjectID,	VATObjectName,	VATObjectAddress,
	DebitAccountID,	CreditAccountID,
	ExchangeRate,	UnitPrice,
	OriginalAmount,	ConvertedAmount,
	ImTaxOriginalAmount,	ImTaxConvertedAmount,
	IsStock,	VoucherDate,	InvoiceDate,
	VoucherTypeID,	VATTypeID,	VoucherNo,
	Serial,	InvoiceNo,	EmployeeID,
	VDescription,	Quantity,	InventoryID,
	UnitID,	[Status],

	CreateDate,	CreateUserID,	LastModifyDate,	LastModifyUserID,
	OriginalAmountCN,	ExchangeRateCN,	CurrencyIDCN,	
	VATGroupID, 
	BDescription,	TDescription,
	IsMultiTax,		ReVoucherID, Ana'+@ShopAnaTypeID+'ID, Ana'+@EmployeeAnaTypeID+'ID, Ana'+@CostAnaTypeID+'ID

)
SELECT	'''+@DivisionID+''',	@InvVoucherID,	@BatchID,	NEWID(),
	''AT9000'', ''POST0016'','+STR(@TranMonth)+',	'+STR(@TranYear)+',	''T14'',
	@CurrencyID,	@ObjectID,	@ObjectID,
	@VATNo,	@ObjectID,	@ObjectName AS VATObjectName,	@Address AS VATObjectAddress,
	B.DebitAccountID,	B.CreditAccountID,
	@ExchangeRate,	0 AS UnitPrice,
	B.TaxAmount AS OriginalAmount,	B.TaxAmount AS ConvertedAmount,
	0 AS ImTaxOriginalAmount,	0 AS ImTaxConvertedAmount,
	1 AS IsStock, 	'''+Convert(nvarchar(10),@VoucherDate,21)+''',	@InvDate AS InvoiceDate,
	@SalesVoucherTypeID AS VoucherTypeID,	@InvVATType AS VATTypeID,	@SalesVoucherNo,
	@InvSerial AS Serial,	@InvNo AS InvoiceNo,	@EmployeeID,
	@SalesVDescription AS VDescription,	0 AS Quantity,	'''' AS InventoryID,
	0 AS UnitID,	0 AS [Status],
	GETDATE(),	@EmployeeID,	GETDATE(),	@EmployeeID,
	B.TaxAmount AS OriginalAmountCN,	@ExchangeRate AS ExchangeRateCN,	@CurrencyID AS CurrencyIDCN,
	B.VATGroupID, 
	@VATDescription AS BDescription, B.TDescription	 AS TDescription,
	1 AS IsMultiTax,	'''+@VoucherID+''', '''+@AnaID+''', B.EmployeeID	, @CostAnaID
FROM (
	'
SET @sSQL6 = N'
---------------Tài khoản nợ, Tài khoản có, Tiền thuế VAT------------------------
SELECT	  D.InventoryID 
		, D.UnitID 
		, D.ActualQuantity 
		, D.UnitPrice
		, D.Amount
		, @TaxCreditAccountID as CreditAccountID
		, @TaxDebitAccountID as DebitAccountID
		, Isnull(D.DiscountAmount, 0) + (Isnull(M.TotalDiscountAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0) + (Isnull(M.TotalRedureAmount, 0) * Isnull(D.Amount, 0))/SUMAmount as DiscountAmount
		, ((Isnull(D.Amount, 0) - Isnull(D.DiscountAmount, 0) 
				   - (Isnull(M.TotalDiscountAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0) 
				   - (Isnull(M.TotalRedureAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0)) * D.VATPercent) as TaxAmount
		,ISNULL(D.VATGroupID,A.VATGroupID) AS  VATGroupID
		,D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID, D.Ana06ID,
		D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID,
		M.VoucherNo +'' ''+ M.ShopID +'' ''+M.ObjectName + '' ''+ D.InventoryID AS TDescription, M.EmployeeID
FROM POST0016 M 
INNER JOIN POST00161 D on M.APK=D.APKMaster and M.DeleteFlg=D.DeleteFlg
LEFT JOIN AT1302 A ON A.DivisionID = D.DivisionID AND A.InventoryID = D.InventoryID
INNER JOIN 
	(
	SELECT	SUM (P.Amount) AS SUMAmount, P.APKMaster
	FROM	POST00161 P
	LEFT JOIN POST0016 P2
		ON P2.DivisionID = P.DivisionID
		AND P2.APK = P.APKMaster
	WHERE	P.DivisionID = '''+@DivisionID+''' 
			AND P.ShopID = '''+@AnaID+'''
			AND P.DeleteFlg = 0
			AND ISNULL(P2.IsTransferred,0) = 0
			AND Convert(nvarchar(10),P2.VoucherDate,21) = '''+Convert(nvarchar(10),@VoucherDate,21)+'''
	GROUP BY P.APKMaster
	) P1
	ON P1.APKMaster = M.APK
WHERE M.DivisionID = '''+@DivisionID+''' 
		and M.ShopID = '''+@AnaID+''' 
		and M.DeleteFlg = 0 
		and M.VoucherDate = '''+Convert(nvarchar(10),@VoucherDate,21)+'''
		and (M.VoucherTypeID = (SELECT TOP 1 VoucherType05 FROM POST0004 WHERE DivisionID = '''+@DivisionID+''' AND ShopID = '''+@AnaID+''')
			OR (M.VoucherTypeID = (SELECT TOP 1 VoucherType12 FROM POST0004 WHERE DivisionID = '''+@DivisionID+''' AND ShopID = '''+@AnaID+''') AND D.IsKindVoucherID = 1 ) )
		AND ISNULL(M.IsTransferred,0) = 0	
		AND M.APK IN (SELECT D.APKMaster FROM AT0281 D WHERE D.DivisionID = '''+@DivisionID+''' AND D.VoucherID = '''+@VoucherID+''' )
GROUP BY D.InventoryID, D.UnitID, D.ActualQuantity, D.UnitPrice, D.Amount, 
		M.TotalDiscountAmount, D.DiscountAmount, M.TotalRedureAmount, D.VATPercent,
		D.VATGroupID,D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID, D.Ana06ID,
		D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID, 
		M.VoucherNo, M.ShopID,M.ObjectName,
		D.APK,SUMAmount, A.VATGroupID, M.EmployeeID
	) B


-------------<<<<<<<<<<<< Hóa đơn bán hàng
'
SET @sSQL7 = N'
----------------Xuat kho ban hang

		INSERT INTO AT2006
		(
			DivisionID,		VoucherID,		TableID,	TranMonth,	TranYear,
			VoucherTypeID,	VoucherDate,	ReVoucherID,	
			VoucherNo,		ObjectID,		InventoryTypeID,
			WareHouseID,	KindVoucherID,	
			[Status],		EmployeeID,		[Description],
			RefNo01,		RefNo02,		
			CreateDate,		CreateUserID,	LastModifyUserID,	LastModifyDate
			
		)
		SELECT	DISTINCT
				'''+@DivisionID+''',		AT9000.VoucherID,		''AT2006'',	'+STR(@TranMonth)+', '+STR(@TranYear)+',
				@WareVoucherTypeID,	'''+Convert(nvarchar(10),@VoucherDate,21)+''',	AT9000.VoucherID,
				@WareVoucherNo,		AT9000.ObjectID,			''%''	,		
				@WareHouseID, 		4,		------Xuat kho ban hang	
				0,					@EmployeeID,			@WareVDescription,
				@SalesVoucherNo,	AT9000.InvoiceNo +''/''+ AT9000.Serial,		
				GETDATE(),			@EmployeeID,			@EmployeeID,	GETDATE()
				
		FROM	AT9000 AT9000
		LEFT JOIN AT1302 AT1302 ON AT1302.DivisionID = AT9000.DivisionID AND AT1302.InventoryID = AT9000.InventoryID
		WHERE	AT9000.DivisionID = '''+@DivisionID+'''
				AND AT9000.VoucherID = @InvVoucherID
				AND AT1302.IsStocked = 1
				AND AT9000.TransactionTypeID = ''T04''
				AND ISNULL(AT9000.InventoryID,'''') <> ''''
				
		INSERT INTO AT2007
		(
			Orders,
			DivisionID,		TransactionID,	VoucherID,	
			TranMonth,		TranYear,		CurrencyID,		ExchangeRate,
			InventoryID,	UnitID,			
			ConvertedQuantity,				ConvertedPrice,
			ActualQuantity,	UnitPrice,		
			OriginalAmount,	ConvertedAmount,
			DebitAccountID,	CreditAccountID,						
			Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
			Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
			ReVoucherID,	ReTransactionID,	OrderID,
			ConversionFactor, MarkQuantity, Notes

		)
		SELECT	ISNULL(D.Orders,0),
				D.DivisionID,		D.TransactionID,		D.VoucherID,	
				'+STR(@TranMonth)+',			'+STR(@TranYear)+',		D.CurrencyID,		D.ExchangeRate,
				D.InventoryID,		D.UnitID,				
				D.Quantity,			D.UnitPrice,
				D.Quantity,			D.UnitPrice,			
				D.OriginalAmount,	D.ConvertedAmount,
				--CASE WHEN ISNULL(D.ConvertedAmount,0) = 0 THEN D.DebitAccountID ELSE AT1302.PrimeCostAccountID END AS DebitAccountID, 
				--CASE WHEN ISNULL(D.ConvertedAmount,0) = 0 THEN D.CreditAccountID ELSE AT1302.AccountID END AS CreditAccountID,
				CASE WHEN D.DebitAccountID = @CostDebitAccountID THEN D.DebitAccountID ELSE AT1302.PrimeCostAccountID END AS DebitAccountID, 
				CASE WHEN D.CreditAccountID = @CostCreditAccountID THEN D.CreditAccountID ELSE AT1302.AccountID END AS CreditAccountID,
				D.Ana01ID,	D.Ana02ID,	D.Ana03ID,	D.Ana04ID,	D.Ana05ID,
				D.Ana06ID,	D.Ana07ID,	D.Ana08ID,	D.Ana09ID,	D.Ana10ID,
				D.VoucherID,		D.TransactionID,		D.VoucherNo,
				1 AS ConversionFactor, D.Quantity AS MarkQuantity, D.TDescription

		FROM	AT9000 D
		LEFT JOIN AT1302 AT1302 ON AT1302.DivisionID = D.DivisionID AND AT1302.InventoryID = D.InventoryID
		WHERE	D.DivisionID = '''+@DivisionID+'''
				AND VoucherID = @InvVoucherID
				AND AT1302.IsStocked = 1
				AND D.TransactionTypeID = ''T04''
				AND ISNULL(D.InventoryID,'''') <> ''''


IF NOT EXISTS ( SELECT TOP 1 1 FROM AT2007 WHERE VoucherID = @InvVoucherID)	
	 ---- nếu không có phiếu xuất thì UPDATE lại phiếu kết chuyển bỏ phiếu xuất
	BEGIN
		UPDATE	AT0280 
		SET		WareVoucherNo = ''''
		WHERE	DivisionID = '''+@DivisionID+'''
				AND AnaID = '''+@AnaID+'''
				AND Convert(nvarchar(10),VoucherDate,21) = '''+Convert(nvarchar(10),@VoucherDate,21)+'''
	END
	



'
--------------------->>>>>>> Phiếu trả hàng
SET @sSQL13 = N'
-------------------->>>>>>>>>>>>Doanh thu Phiếu trả hàng-------------------------------
INSERT INTO AT9000
(
	DivisionID,	VoucherID,	BatchID,	TransactionID,	
	TableID,	ReTableID, TranMonth,	TranYear,	TransactionTypeID,
	CurrencyID,	ObjectID,	CreditObjectID,	VATNo,	
	VATObjectID,	VATObjectName,	VATObjectAddress,
	DebitAccountID,	CreditAccountID,
	ExchangeRate,	UnitPrice,	OriginalAmount,	ConvertedAmount,
	ImTaxOriginalAmount,	ImTaxConvertedAmount,
	IsStock,	VoucherDate,	InvoiceDate,
	VoucherTypeID,	VATTypeID,	VoucherNo,
	Serial,	InvoiceNo,	EmployeeID,	VDescription,	
	Quantity,	InventoryID,	UnitID,	[Status],

	CreateDate,	CreateUserID,	LastModifyDate,	LastModifyUserID,
	OriginalAmountCN,	ExchangeRateCN,	CurrencyIDCN,
	VATGroupID, 
	BDescription, TDescription,
	VATOriginalAmount, VATConvertedAmount,
	IsMultiTax,
	ConvertedQuantity,	ConvertedPrice,	ConvertedUnitID,
	MarkQuantity,	ConversionFactor,
	ReVoucherID,	DiscountAmount, Ana'+@ShopAnaTypeID+'ID, Ana'+@EmployeeAnaTypeID+'ID, Ana'+@CostAnaTypeID+'ID

)

--------------->>>>>>>Tài khoản nợ, Tài khoản có, Tiền chiết khấu, Tiền doanh thu Phiếu trả hàng------------------------
SELECT	'''+@DivisionID+''',	@ReturnVoucherID,	@BatchID,	NEWID(),	
		''AT9000'', ''POST0016'',	'+STR(@TranMonth)+',		'+STR(@TranYear)+',	''T24'',
		@CurrencyID,	@ObjectID,		@ObjectID,	@VATNo,
		@ObjectID,		@ObjectName AS VATObjectName,				@Address AS VATObjectAddress,
		B.DebitAccountID,				B.CreditAccountID,
		@ExchangeRate,	B.UnitPrice,	(B.Amount - ISNULL(B.DiscountAmount,0)) AS OriginalAmount,	(B.Amount - ISNULL(B.DiscountAmount,0)) AS ConvertedAmount,
		0 AS ImTaxOriginalAmount,		0 AS ImTaxConvertedAmount,
		1 AS IsStock,	'''+Convert(nvarchar(10),@VoucherDate,21)+''',	@InvDate AS InvoiceDate,
		@ReturnVoucherTypeID AS VoucherTypeID,	@InvVATType AS VATTypeID,	@ReturnVoucherNo,
		@InvSerial AS Serial,	@InvNo AS InvoiceNo,	@EmployeeID,	@ReturnVDescription AS VDescription,
		B.ActualQuantity AS Quantity,	B.InventoryID,	B.UnitID,	0 AS [Status],
		
		GETDATE(),	@EmployeeID,	GETDATE(),	@EmployeeID,
		(B.Amount - ISNULL(B.DiscountAmount,0)) AS OriginalAmountCN,	@ExchangeRate AS ExchangeRateCN,	@CurrencyID AS CurrencyIDCN,
		B.VATGroupID, 
		B.BDescription,	B.BDescription AS TDescription,
		B.TaxAmount AS VATOriginalAmount, 	B.TaxAmount AS VATConvertedAmount,
		1 AS IsMultiTax,
		B.ActualQuantity AS ConvertedQuantity,	B.UnitPrice AS ConvertedPrice,	B.UnitID AS ConvertedUnitID,
		B.ActualQuantity AS MarkQuantity,	1 AS ConversionFactor,
		'''+@VoucherID+''', B.DiscountAmount, '''+@AnaID+''', B.EmployeeID	, @CostAnaID	
	
FROM 
	(
'
SET @sSQL14 = N'
SELECT	  D.InventoryID 
		, D.UnitID 
		, D.ActualQuantity 
		, D.UnitPrice 
		, D.Amount 
		, @PayDebitAccountID as DebitAccountID
		, @PayCreditAccountID as CreditAccountID
		, (Isnull(D.DiscountAmount, 0) +(Isnull(M.TotalDiscountAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0) + (Isnull(M.TotalRedureAmount, 0) * Isnull(D.Amount, 0))/SUMAmount ) as DiscountAmount
		, Isnull(D.Amount, 0) - Isnull(D.DiscountAmount, 0)
				   - (Isnull(M.TotalDiscountAmount, 0)* Isnull(D.Amount, 0))/NULLIF(SUMAmount,0)
				   - (Isnull(M.TotalRedureAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0) as Revenue
		, ((Isnull(D.Amount, 0) - Isnull(D.DiscountAmount, 0) 
				   - (Isnull(M.TotalDiscountAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0) 
				   - (Isnull(M.TotalRedureAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0)) * D.VATPercent) as TaxAmount
		,ISNULL(D.VATGroupID,A.VATGroupID) AS  VATGroupID
		,D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID, D.Ana06ID,
		D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID,
		M.VoucherNo +'' ''+ M.ShopID +'' ''+M.ObjectName AS BDescription, M.EmployeeID		
From POST0016 M 
INNER JOIN POST00161 D on M.APK=D.APKMaster and M.DeleteFlg=D.DeleteFlg
LEFT JOIN AT1302 A ON A.DivisionID = D.DivisionID AND A.InventoryID = D.InventoryID
INNER JOIN 
	(
	SELECT	SUM (P.Amount) AS SUMAmount, P.APKMaster
	FROM	POST00161 P
	LEFT JOIN POST0016 P2
		ON P2.DivisionID = P.DivisionID
		AND P2.APK = P.APKMaster
	WHERE	P.DivisionID = '''+@DivisionID+''' 
			AND P.ShopID = '''+@AnaID+'''
			AND P.DeleteFlg = 0
			AND ISNULL(P2.IsTransferred,0) = 0
			AND Convert(nvarchar(10),P2.VoucherDate,21) = '''+Convert(nvarchar(10),@VoucherDate,21)+'''
	GROUP BY P.APKMaster
	) P1
	ON P1.APKMaster = M.APK
Where	M.DivisionID = '''+@DivisionID+''' 
		and M.ShopID = '''+@AnaID+''' 
		and M.DeleteFlg = 0 
		and Convert(nvarchar(10),M.VoucherDate,21) = '''+Convert(nvarchar(10),@VoucherDate,21)+'''
		and (M.VoucherTypeID = (SELECT TOP 1 VoucherType02 FROM POST0004 WHERE DivisionID = '''+@DivisionID+''' AND ShopID = '''+@AnaID+''')	
			OR (M.VoucherTypeID = (SELECT TOP 1 VoucherType12 FROM POST0004 WHERE DivisionID = '''+@DivisionID+''' AND ShopID = '''+@AnaID+''') AND D.IsKindVoucherID = 2 ) )
		AND ISNULL(M.IsTransferred,0) = 0	
		AND M.APK IN (SELECT D.APKMaster FROM AT0281 D WHERE D.DivisionID = '''+@DivisionID+''' AND D.VoucherID = '''+@VoucherID+''' )
Group by D.InventoryID, D.UnitID, D.ActualQuantity, D.UnitPrice, D.Amount, 
		M.TotalDiscountAmount, D.DiscountAmount, M.TotalRedureAmount, D.VATPercent,
		D.VATGroupID,D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID, D.Ana06ID,
		D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID,
		M.VoucherNo, M.ShopID,M.ObjectName,
		D.APK,SUMAmount, A.VATGroupID , M.EmployeeID
	) B

--------------------<<<<<<<<<Doanh thu Phiếu trả hàng-------------------------------
'
SET @sSQL15 = N'
-------------------->>>>>>>>>>>>Thuế Phiếu trả hàng-------------------------------
INSERT INTO AT9000
(
	DivisionID,	VoucherID,	BatchID,	TransactionID,
	TableID,	ReTableID, TranMonth,	TranYear,	TransactionTypeID,
	CurrencyID,	ObjectID,	CreditObjectID,
	VATNo,	VATObjectID,	VATObjectName,	VATObjectAddress,
	DebitAccountID,	CreditAccountID,
	ExchangeRate,	UnitPrice,
	OriginalAmount,	ConvertedAmount,
	ImTaxOriginalAmount,	ImTaxConvertedAmount,
	IsStock,	VoucherDate,	InvoiceDate,
	VoucherTypeID,	VATTypeID,	VoucherNo,
	Serial,	InvoiceNo,	EmployeeID,
	VDescription,	Quantity,	InventoryID,
	UnitID,	[Status],

	CreateDate,	CreateUserID,	LastModifyDate,	LastModifyUserID,
	OriginalAmountCN,	ExchangeRateCN,	CurrencyIDCN,	
	VATGroupID, 
	BDescription,	TDescription,
	IsMultiTax,		ReVoucherID, Ana'+@ShopAnaTypeID+'ID, Ana'+@EmployeeAnaTypeID+'ID, Ana'+@CostAnaTypeID+'ID

)
SELECT	'''+@DivisionID+''',	@ReturnVoucherID,	@BatchID,	NEWID(),
	''AT9000'', ''POST0016'','+STR(@TranMonth)+',	'+STR(@TranYear)+',	''T34'',
	@CurrencyID,	@ObjectID,	@ObjectID,
	@VATNo,	@ObjectID,	@ObjectName AS VATObjectName,	@Address AS VATObjectAddress,
	B.DebitAccountID,	B.CreditAccountID,
	@ExchangeRate,	0 AS UnitPrice,
	B.TaxAmount AS OriginalAmount,	B.TaxAmount AS ConvertedAmount,
	0 AS ImTaxOriginalAmount,	0 AS ImTaxConvertedAmount,
	1 AS IsStock, 	'''+Convert(nvarchar(10),@VoucherDate,21)+''',	@InvDate AS InvoiceDate,
	@ReturnVoucherTypeID AS VoucherTypeID,	@InvVATType AS VATTypeID,	@ReturnVoucherNo,
	@InvSerial AS Serial,	@InvNo AS InvoiceNo,	@EmployeeID,
	@ReturnVDescription AS VDescription,	0 AS Quantity,	'''' AS InventoryID,
	0 AS UnitID,	0 AS [Status],
	GETDATE(),	@EmployeeID,	GETDATE(),	@EmployeeID,
	B.TaxAmount AS OriginalAmountCN,	@ExchangeRate AS ExchangeRateCN,	@CurrencyID AS CurrencyIDCN,
	B.VATGroupID, 
	@VATDescription AS BDescription,		B.TDescription AS TDescription,
	1 AS IsMultiTax,	'''+@VoucherID+''', '''+@AnaID+''', B.EmployeeID, @CostAnaID	
FROM (
	'
SET @sSQL16 = N'
---------------Tài khoản nợ, Tài khoản có, Tiền thuế VAT Phiếu trả hàng------------------------
SELECT	  D.InventoryID 
		, D.UnitID 
		, D.ActualQuantity 
		, D.UnitPrice
		, D.Amount
		, @TaxDebitAccountID  as CreditAccountID
		, @TaxCreditAccountID as DebitAccountID
		, Isnull(D.DiscountAmount, 0) + (Isnull(M.TotalDiscountAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0) + (Isnull(M.TotalRedureAmount, 0) * Isnull(D.Amount, 0))/SUMAmount as DiscountAmount
		, ((Isnull(D.Amount, 0) - Isnull(D.DiscountAmount, 0) 
				   - (Isnull(M.TotalDiscountAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0) 
				   - (Isnull(M.TotalRedureAmount, 0) * Isnull(D.Amount, 0))/NULLIF(SUMAmount,0)) * D.VATPercent) as TaxAmount
		,ISNULL(D.VATGroupID,A.VATGroupID) AS  VATGroupID
		,D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID, D.Ana06ID,
		D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID,
		M.VoucherNo +'' ''+ M.ShopID +'' ''+M.ObjectName + '' ''+ D.InventoryID AS TDescription, M.EmployeeID
FROM POST0016 M 
INNER JOIN POST00161 D on M.APK=D.APKMaster and M.DeleteFlg=D.DeleteFlg
LEFT JOIN AT1302 A ON A.DivisionID = D.DivisionID AND A.InventoryID = D.InventoryID
INNER JOIN 
	(
	SELECT	SUM (P.Amount) AS SUMAmount, P.APKMaster
	FROM	POST00161 P
	LEFT JOIN POST0016 P2
		ON P2.DivisionID = P.DivisionID
		AND P2.APK = P.APKMaster
	WHERE	P.DivisionID = '''+@DivisionID+''' 
			AND P.ShopID = '''+@AnaID+'''
			AND P.DeleteFlg = 0
			AND ISNULL(P2.IsTransferred,0) = 0
			AND Convert(nvarchar(10),P2.VoucherDate,21) = '''+Convert(nvarchar(10),@VoucherDate,21)+'''
	GROUP BY P.APKMaster
	) P1
	ON P1.APKMaster = M.APK
WHERE M.DivisionID = '''+@DivisionID+''' 
		and M.ShopID = '''+@AnaID+''' 
		and M.DeleteFlg = 0 
		and M.VoucherDate = '''+Convert(nvarchar(10),@VoucherDate,21)+'''
		and (M.VoucherTypeID = (SELECT TOP 1 VoucherType02 FROM POST0004 WHERE DivisionID = '''+@DivisionID+''' AND ShopID = '''+@AnaID+''')
			OR (M.VoucherTypeID = (SELECT TOP 1 VoucherType12 FROM POST0004 WHERE DivisionID = '''+@DivisionID+''' AND ShopID = '''+@AnaID+''') AND D.IsKindVoucherID = 2 ) )
		AND ISNULL(M.IsTransferred,0) = 0	
		AND M.APK IN (SELECT D.APKMaster FROM AT0281 D WHERE D.DivisionID = '''+@DivisionID+''' AND D.VoucherID = '''+@VoucherID+''' )
GROUP BY D.InventoryID, D.UnitID, D.ActualQuantity, D.UnitPrice, D.Amount, 
		M.TotalDiscountAmount, D.DiscountAmount, M.TotalRedureAmount, D.VATPercent,
		D.VATGroupID,D.Ana01ID, D.Ana02ID, D.Ana03ID, D.Ana04ID, D.Ana05ID, D.Ana06ID,
		D.Ana07ID, D.Ana08ID, D.Ana09ID, D.Ana10ID, 
		M.VoucherNo, M.ShopID,M.ObjectName,
		D.APK,SUMAmount, A.VATGroupID, M.EmployeeID
	) B


-------------<<<<<<<<<<<< Hàng bán trả lại
'
SET @sSQL17 = N'
----------------Nhập kho 
INSERT INTO AT2006
		(
			DivisionID,		VoucherID,		TableID,	TranMonth,	TranYear,
			VoucherTypeID,	VoucherDate,	ReVoucherID,	
			VoucherNo,		ObjectID,		InventoryTypeID,
			WareHouseID,	KindVoucherID,	
			[Status],		EmployeeID,		[Description],
			RefNo01,		RefNo02,		
			CreateDate,		CreateUserID,	LastModifyUserID,	LastModifyDate
			
		)

		SELECT	DISTINCT
				'''+@DivisionID+''',		AT9000.VoucherID,		''AT2006'',	'+STR(@TranMonth)+', '+STR(@TranYear)+',
				@ImWareVoucherTypeID,	'''+Convert(nvarchar(10),@VoucherDate,21)+''',	AT9000.VoucherID,
				@ImWareVoucherNo,		AT9000.ObjectID,			''%''	,		
				@WareHouseID, 			7,		---- Nhap kho hang ban tra lai	
				0,						@EmployeeID,		@ImWareVDescription,
				@SalesVoucherNo,		AT9000.InvoiceNo+''/''+AT9000.Serial,		
				GETDATE(),				@EmployeeID,	@EmployeeID,	GETDATE()
				
		FROM	AT9000 AT9000
		LEFT JOIN AT1302 AT1302 ON AT1302.DivisionID = AT9000.DivisionID AND AT1302.InventoryID = AT9000.InventoryID
		WHERE	AT9000.DivisionID = '''+@DivisionID+'''
				AND AT9000.VoucherID = @ReturnVoucherID
				AND AT1302.IsStocked = 1
				AND AT9000.TransactionTypeID = ''T24''
				AND ISNULL(AT9000.InventoryID,'''') <> ''''

INSERT INTO AT2007
(
	Orders,
	DivisionID,		TransactionID,	VoucherID,	
	TranMonth,		TranYear,		CurrencyID,		ExchangeRate,
	InventoryID,	UnitID,			
	ConvertedQuantity,				ConvertedPrice,
	ActualQuantity,	UnitPrice,		
	OriginalAmount,	ConvertedAmount,
	DebitAccountID,	CreditAccountID,						
	Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
	Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,
	ReVoucherID,	ReTransactionID,	OrderID,
	ConversionFactor, MarkQuantity, Notes

)
SELECT	ISNULL(D.Orders,0),
		D.DivisionID,		D.TransactionID,		D.VoucherID,	
		'+STR(@TranMonth)+',			'+STR(@TranYear)+',		D.CurrencyID,		D.ExchangeRate,
		D.InventoryID,		D.UnitID,				
		D.Quantity,			D.UnitPrice,
		D.Quantity,			D.UnitPrice,			
		D.OriginalAmount,	D.ConvertedAmount,
		AT1302.AccountID,	AT1302.PrimeCostAccountID,	
		D.Ana01ID,	D.Ana02ID,	D.Ana03ID,	D.Ana04ID,	D.Ana05ID,
		D.Ana06ID,	D.Ana07ID,	D.Ana08ID,	D.Ana09ID,	D.Ana10ID,
		D.VoucherID,		D.TransactionID,		D.VoucherNo,
		1 AS ConversionFactor, D.Quantity AS MarkQuantity, D.TDescription

FROM	AT9000 D
LEFT JOIN AT1302 AT1302 ON AT1302.DivisionID = D.DivisionID AND AT1302.InventoryID = D.InventoryID
WHERE	D.DivisionID = '''+@DivisionID+'''
		AND VoucherID = @ReturnVoucherID
		AND AT1302.IsStocked = 1
		AND D.TransactionTypeID = ''T24''
		AND ISNULL(D.InventoryID,'''') <> ''''

IF NOT EXISTS ( SELECT TOP 1 1 FROM AT2007 WHERE VoucherID = @ReturnVoucherID)	
	---- nếu không có phiếu xuất thì UPDATE lại phiếu kết chuyển bỏ phiếu xuất
	BEGIN
		UPDATE	AT0280 
		SET		ImWareVoucherNo = ''''
		WHERE	DivisionID = '''+@DivisionID+'''
				AND AnaID = '''+@AnaID+'''
				AND Convert(nvarchar(10),VoucherDate,21) = '''+Convert(nvarchar(10),@VoucherDate,21)+'''
	END

'

SET @sSQL8 = N'
----------- UPDATE lại cái phiếu bên POS đã kết chuyển rồi

UPDATE POST0016 
SET IsTransferred = 1 
WHERE DivisionID = '''+@DivisionID+''' 
AND ShopID = '''+@AnaID+''' 
AND DeleteFlg = 0
AND Convert(nvarchar(10),VoucherDate,21) = '''+Convert(nvarchar(10),@VoucherDate,21)+'''
AND APK IN (SELECT D.APKMaster FROM AT0281 D WHERE D.DivisionID = '''+@DivisionID+''' AND D.VoucherID = '''+@VoucherID+''' )
'	
--PRINT(@sSQL1)	
--PRINT(@sSQL2)	
--PRINT(@sSQL3)	
--PRINT(@sSQL4)	
--PRINT(@sSQL5)
--PRINT(@sSQL6)
--PRINT(@sSQL7)
--PRINT(@sSQL13)	
--PRINT(@sSQL14)	
--PRINT(@sSQL15)
--PRINT(@sSQL16)
--PRINT(@sSQL17)
--PRINT(@sSQL8)
EXEC(@sSQL1+@sSQL2+@sSQL3+@sSQL4+@sSQL5 +@sSQL6+@sSQL7 +@sSQL13+@sSQL14+@sSQL15+@sSQL16+@sSQL17+@sSQL8)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

