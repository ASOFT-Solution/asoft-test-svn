IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7403_HT]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7403_HT]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Tong hop no phai thu
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
-----Created by Nguyen Van Nhan, Date 22.08.2003
-----
---- Last Edit by Van Nhan, Date 25.06.2004
---- Last Edit by Nguyen Quoc Huy, Date 25.07.2007
---- Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
---- Edited by: [AS] [Bảo Quỳnh] [15/11/2011] : Bổ sung các field name Phân loại 1,2,3 của đối tượng, 5 field name của mã phân tích đối tượng
---- Modified on 06/12/2011 by Le Thi Thu Hien : Sua ngay CONVERT(varchar(10),@TypeDate,101)
---- Modified on 16/01/2012 by Le Thi Thu Hien : CONVERT lai ngay
---- Modified on 22/02/2012 by Le Thi Thu Hien : Sua dieu kien WHERE
---- Modified on 13/04/2012 by Le Thi Thu Hien : Sửa OriginalAmount thành SignOriginalAmount
---- Modified on 28/12/2012 by Lê Thị Thu Hiền : Bổ sung thêm strDivisionID
---- Modified on 14/11/2014 by Mai Duyen : Bổ sung thêm DatabaseName (tinh năng In báo cao tong hop no phai thu 2 Database, KH SIEUTHANH)
---- Modified on 11/11/2015 by Phuong Thao : Fix lỗi khi in 2 DB : Trả thêm trường AccountNameE (tinh năng In báo cao tong hop no phai thu 2 Database, KH SIEUTHANH)
---- Modified on 25/01/2016 by Thị Phượng: Bổ sung theo field mã phân tích đối tượng 5 (AnaTyeID : O05)_ customize Hoàng Trần
-- <Example>
---- 

CREATE PROCEDURE [dbo].[AP7403_HT]	 	
					@DivisionID AS nvarchar(50) ,
					@FromObjectID As nVarchar(50),
					@ToObjectID as Nvarchar(50),
					@FromMonth AS int,
					@FromYear  AS int,
					@ToMonth  AS int,
					@ToYear  AS int,
					@TypeD AS tinyint,  	--0 theo ky 
					                    	--1 theo ngay hoa don 
					                    	--2 theo ngay hach toan
					@FromDate AS datetime,
					@ToDate AS datetime,
					@CurrencyID AS nvarchar(50),
					@FromAccountID AS nvarchar(50),
					@ToAccountID AS nvarchar(50),
					@FromO05ID As Varchar (50),
					@ToO05ID as Varchar (50),
					@Groupby AS TINYINT
					


 AS

DECLARE 
	@sSQL AS Nvarchar(max),
	@sSQL1 AS nvarchar(MAX),
	@sSQL2 AS nvarchar(MAX),
	@sSQLUnion AS nvarchar(MAX),
	@GroupTypeID AS nvarchar(50),		
	@GroupID AS nvarchar(50),
	@TypeDate AS nvarchar(50),
    @TableName AS nvarchar(50),
    @SqlObject AS nvarchar(4000),
    @SqlGroupBy AS nvarchar(4000)
    
Declare @CustomerName INT
--Tao bang tam de kiem tra day co phai la khach hang Hoang Tran khong (CustomerName = 51)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)


	
Set @GroupTypeID ='O05'

Set @GroupID  = (Case  @GroupTypeID 
				When 'O05'  Then 'A.O05ID' ---- Nhom theo ma phan tich doi tuong
				End)

If @GroupBy = 0    ---- Nhom theo  doi tuong truoc, tai khoan sau
	set @SqlGroupBy = '  
		D3.O05ID AS GroupID,
		O5.AnaName AS  GroupName,
		D3.ObjectID AS GroupID1,
		A.ObjectName AS GroupName1,
		D3.AccountID as GroupID2,
		B.AccountName as GroupName2 '
else   		----- Nhom theo tai khoan truoc, doi tuong sau
	set @SqlGroupBy = '
		D3.O05ID AS GroupID,
		O5.AnaName AS  GroupName, 
		D3.AccountID as GroupID1,
		B.AccountName as GroupName1,
		D3.ObjectID AS GroupID2,
		A.ObjectName AS GroupName2'

Exec AP7402_HT  @DivisionID, @CurrencyID, @FromAccountID, @ToAccountID,@FromObjectID, @ToObjectID, @FromO05ID,  @ToO05ID

IF @TypeD = 1	---- Theo ngay Hoa don
	SET @TypeDate = 'D3.InvoiceDate'
ELSE IF @TypeD = 2 	---- Theo ngay hach toan
	SET @TypeDate = 'D3.VoucherDate'

if @TypeD <> 0   ----- In theo ngay
Begin
SET @sSQL = ' 
SELECT	D3.DivisionID, ' + @SqlGroupBy + ',	
		A.VATNo, D3.ObjectID,  A.ObjectName,
		D3.AccountID, B.AccountName, B.AccountNameE, D3.CurrencyID,
		D3.O05ID,
		O5.AnaName AS O05Name, 
		SUM (CASE WHEN (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <  ''' + convert(nvarchar(10), @FromDate, 101) + ''' OR TransactiontypeID = ''T00'') AND RPTransactionType = ''00'' THEN SignOriginalAmount ELSE 0 END)  AS DebitOriginalOpening,
		SUM (CASE WHEN (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <  ''' + convert(nvarchar(10), @FromDate, 101) + ''' OR TransactiontypeID = ''T00'') AND RPTransactionType = ''00'' THEN SignConvertedAmount ELSE 0 END) AS DebitConvertedOpening,
		SUM (CASE WHEN (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <  ''' + convert(nvarchar(10), @FromDate, 101) + ''' OR TransactiontypeID = ''T00'') AND RPTransactionType = ''01'' THEN -SignOriginalAmount ELSE 0 END) AS CreditOriginalOpening,
		SUM (CASE WHEN (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <  ''' + convert(nvarchar(10), @FromDate, 101) + ''' OR TransactiontypeID = ''T00'') AND RPTransactionType = ''01'' THEN -SignConvertedAmount ELSE 0 END) AS CreditConvertedOpening,
        SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) >= ''' + convert(nvarchar(10), @FromDate, 101) + ''' AND
					   CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND RPTransactionType = ''00'' THEN SignOriginalAmount ELSE 0 END) AS OriginalDebit,
        SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) >= ''' + convert(nvarchar(10), @FromDate, 101) + ''' AND
					   CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND RPTransactionType = ''00'' THEN SignConvertedAmount ELSE 0 END) AS ConvertedDebit,
        SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) >= ''' + convert(nvarchar(10), @FromDate, 101) + '''  AND
					   CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND RPTransactionType = ''01'' THEN -SignOriginalAmount ELSE 0 END) AS OriginalCredit,
		SUM (CASE WHEN CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) >= ''' + convert(nvarchar(10), @FromDate, 101) + '''  AND
					   CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND  RPTransactionType = ''01'' THEN -SignConvertedAmount ELSE 0 END) AS ConvertedCredit,
		SUM (CASE WHEN  RPTransactionType = ''00'' AND CreditAccountID = ''5111'' THEN ConvertedAmount ELSE 0 END)  AS ConvertIncome,  '
SET @sSQL1 = '					   
		SUM (CASE WHEN (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' OR TransactiontypeID = ''T00'') AND RPTransactionType = ''00'' THEN SignOriginalAmount ELSE 0 END) AS DebitOriginalClosing,
		SUM (CASE WHEN (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' OR TransactiontypeID = ''T00'') AND RPTransactionType = ''00'' THEN SignConvertedAmount ELSE 0 END) AS DebitConvertedClosing,
		SUM (CASE WHEN (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' OR TransactiontypeID = ''T00'') AND RPTransactionType = ''01'' THEN -SignOriginalAmount ELSE 0 END) AS CreditOriginalClosing,
		SUM (CASE WHEN (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' OR TransactiontypeID = ''T00'') AND RPTransactionType = ''01'' THEN -SignConvertedAmount ELSE 0 END) AS CreditConvertedClosing,
		SUM (CASE WHEN (TranMonth + TranYear * 100 > ' + str(@FromYear) + '*100) AND CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND RPTransactionType = ''00'' THEN SignOriginalAmount ELSE 0 END) AS OriginalDebitYTD,
		SUM (CASE WHEN (TranMonth + TranYear * 100 > ' + str(@FromYear) + '*100) AND CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND RPTransactionType = ''00'' THEN SignConvertedAmount ELSE 0 END) AS ConvertedDebitYTD,
		SUM (CASE WHEN (TranMonth + TranYear * 100 > ' + str(@FromYear) + '*100) AND CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND RPTransactionType = ''01'' THEN -SignOriginalAmount ELSE 0 END) AS OriginalCreditYTD,
		SUM (CASE WHEN (TranMonth + TranYear * 100 > ' + str(@FromYear) + '*100) AND CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(nvarchar(10), @ToDate, 101) + ''' AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND RPTransactionType = ''01'' THEN -SignConvertedAmount ELSE 0 END) AS ConvertedCreditYTD '
SET @sSQL2 = ' 		
	FROM AV7402_HT D3 
		INNER JOIN AT1202 A  on  A.ObjectID = D3.ObjectID AND A.DivisionID = D3.DivisionID
		LEFT JOIN AT1015 O5 on O5.AnaID = A.O05ID AND O5.DivisionID = D3.DivisionID AND O5.AnaTypeID = ''O05''
		INNER JOIN AT1005 AS B on B.AccountID = D3.AccountID AND B.DivisionID = D3.DivisionID
	GROUP BY	D3.DivisionID,  D3.AccountID, A.VATNo,  D3.ObjectID,  A.ObjectName,
				B.AccountName, B.AccountNameE, D3.CurrencyID, 
				D3.O05ID, O5.AnaName '

END

ELSE
BEGIN
	SET @sSQL = '
SELECT	D3.DivisionID, ' + @SqlGroupBy + ',	
		A.VATNo, D3.ObjectID,  A.ObjectName,
		D3.AccountID,
		B.AccountName, B.AccountNameE,
		D3.CurrencyID,
		D3.O05ID, 
		O5.AnaName AS O05Name, 
		SUM (CASE WHEN ((TranMonth + 100 * TranYear < ' + str(@FromMonth) + ' + 100 * ' + str(@FromYear) + ') OR TransactiontypeID = ''T00'') AND RPTransactionType = ''00'' THEN SignOriginalAmount ELSE 0 END)  AS DebitOriginalOpening,
		SUM (CASE WHEN ((TranMonth + 100 * TranYear < ' + str(@FromMonth) + ' + 100 * ' + str(@FromYear) + ') OR TransactiontypeID = ''T00'') AND RPTransactionType = ''00'' THEN SignConvertedAmount ELSE 0 END) AS DebitConvertedOpening,
		SUM (CASE WHEN ((TranMonth + 100 * TranYear < ' + str(@FromMonth) + ' + 100 * ' + str(@FromYear) + ') OR TransactiontypeID = ''T00'') AND RPTransactionType = ''01'' THEN -SignOriginalAmount ELSE 0 END)  AS CreditOriginalOpening,
		SUM (CASE WHEN ((TranMonth + 100 * TranYear < ' + str(@FromMonth) + ' + 100 * ' + str(@FromYear) + ') OR TransactiontypeID = ''T00'') AND RPTransactionType = ''01'' THEN -SignConvertedAmount ELSE 0 END) AS CreditConvertedOpening,
		SUM (CASE WHEN (TranMonth + 100 * TranYear >= ' + str(@FromMonth) + ' + 100 * ' + str(@FromYear) + ') AND (TranMonth + 100 * TranYear <= ' + str(@ToMonth) + ' + 100 * ' + str(@ToYear) + ') AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND  RPTransactionType = ''00'' THEN SignOriginalAmount ELSE 0 END) AS OriginalDebit,
		SUM (CASE WHEN (TranMonth + 100 * TranYear >= ' + str(@FromMonth) + ' + 100 * ' + str(@FromYear) + ') AND (TranMonth + 100 * TranYear <= ' + str(@ToMonth) + ' + 100 * ' + str(@ToYear) + ') AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND  RPTransactionType = ''00'' THEN SignConvertedAmount ELSE 0 END) AS ConvertedDebit,
		SUM (CASE WHEN (TranMonth + 100 * TranYear >= ' + str(@FromMonth) + ' + 100 * ' + str(@FromYear) + ') AND (TranMonth + 100 * TranYear <= ' + str(@ToMonth) + ' + 100 * ' + str(@ToYear) + ') AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND  RPTransactionType = ''01'' THEN - SignOriginalAmount ELSE 0 END) AS OriginalCredit,
		SUM (CASE WHEN (TranMonth + 100 * TranYear >= ' + str(@FromMonth) + ' + 100 * ' + str(@FromYear) + ') AND (TranMonth + 100 * TranYear <= ' + str(@ToMonth) + ' + 100 * ' + str(@ToYear) + ') AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND  RPTransactionType = ''01'' THEN - SignConvertedAmount ELSE 0 END) AS ConvertedCredit,
		SUM (CASE WHEN  RPTransactionType = ''00'' AND CreditAccountID = ''5111'' THEN ConvertedAmount ELSE 0 END) AS ConvertIncome,  '
SET @sSQL1 = '
		SUM (CASE WHEN ((TranMonth + 100 * TranYear <= ' + str(@ToMonth) + ' + 100 * ' + str(@ToYear) + ') OR TransactiontypeID = ''T00'') AND RPTransactionType = ''00'' THEN SignOriginalAmount ELSE 0 END) AS DebitOriginalClosing,
		SUM (CASE WHEN ((TranMonth + 100 * TranYear <= ' + str(@ToMonth) + ' + 100 * ' + str(@ToYear) + ') OR TransactiontypeID = ''T00'') AND RPTransactionType = ''00'' THEN SignConvertedAmount ELSE 0 END) AS DebitConvertedClosing,
		SUM (CASE WHEN ((TranMonth + 100 * TranYear <= ' + str(@ToMonth) + ' + 100 * ' + str(@ToYear) + ') OR TransactiontypeID = ''T00'') AND RPTransactionType = ''01'' THEN -SignOriginalAmount ELSE 0 END) AS CreditOriginalClosing,
		SUM (CASE WHEN ((TranMonth + 100 * TranYear <= ' + str(@ToMonth) + ' + 100 * ' + str(@ToYear) + ') OR TransactiontypeID = ''T00'') AND RPTransactionType = ''01'' THEN -SignConvertedAmount ELSE 0 END) AS CreditConvertedClosing,
		SUM (CASE WHEN (TranMonth + TranYear * 100 > ' + str(@FromYear) + ' * 100) AND (TranMonth + TranYear * 100 <= ' + str(@ToMonth) + ' + ' + str(@ToYear) + '*100) AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND  RPTransactionType = ''00'' THEN SignOriginalAmount ELSE 0 END) AS OriginalDebitYTD,
		SUM (CASE WHEN (TranMonth + TranYear * 100 > ' + str(@FromYear) + ' * 100) AND (TranMonth + TranYear * 100 <= ' + str(@ToMonth) + ' + ' + str(@ToYear) + '*100) AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND  RPTransactionType = ''00'' THEN SignConvertedAmount ELSE 0 END) AS ConvertedDebitYTD,
		SUM (CASE WHEN (TranMonth + TranYear * 100 > ' + str(@FromYear) + ' * 100) AND (TranMonth + TranYear * 100 <= ' + str(@ToMonth) + ' + ' + str(@ToYear) + '*100) AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND  RPTransactionType = ''01'' THEN -SignOriginalAmount ELSE 0 END) AS OriginalCreditYTD,
		SUM (CASE WHEN (TranMonth + TranYear * 100 > ' + str(@FromYear) + ' * 100) AND (TranMonth + TranYear * 100 <= ' + str(@ToMonth) + ' + ' + str(@ToYear) + '*100) AND (IsNull(TransactiontypeID, '''') <> ''T00'') AND  RPTransactionType = ''01'' THEN -SignConvertedAmount ELSE 0 END) AS ConvertedCreditYTD '
SET @sSQL2 = ' 	
	FROM AV7402_HT D3 	
		INNER JOIN AT1202 A  on  A.ObjectID = D3.ObjectID AND A.DivisionID = D3.DivisionID
		LEFT JOIN AT1015 O5 on O5.AnaID = A.O05ID AND O5.DivisionID = D3.DivisionID AND O5.AnaTypeID = ''O05''
		INNER JOIN AT1005 B on B.AccountID = D3.AccountID AND B.DivisionID = D3.DivisionID
	
GROUP BY  D3.DivisionID, D3.AccountID, A.VATNo, D3.ObjectID,  A.ObjectName,
		B.AccountName, B.AccountNameE, D3.CurrencyID, 
		D3.O05ID,  O5.AnaName '
End


IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7413_HT]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
     EXEC ('  CREATE VIEW AV7413_HT AS ' + @sSQL + @sSQL1 + @sSQL2)
ELSE
     EXEC ('  ALTER VIEW AV7413_HT  AS ' + @sSQL + @sSQL1 + @sSQL2)


---- Bo phan so 0 	
IF @CurrencyID <> '%'
	Set @sSQLUnion =  ' 
		Select x.DivisionID, x.O05ID, x.O05Name, x.ObjectID, x.ObjectName, x.AccountID, x.AccountName, x.CurrencyID, Sum(x.ConvertIncome) as ConvertIncome,
		Sum(x.ConvertedOpening) as ConvertedOpening, Sum(x.ConvertedDebit) as ConvertedDebit, sum(x.ConvertedCredit) as ConvertedCredit,
		(Sum(x.ConvertedOpening)+Sum(x.ConvertedDebit)-sum(x.ConvertedCredit)) as ConvertedClosing
		From 
		(SELECT DivisionID, 
		ObjectID, ObjectName,
		AccountID,
		AccountName, AccountNameE,
		CurrencyID,		 
		O05ID,
		O05Name, ConvertIncome,
		CASE WHEN DebitOriginalOpening - CreditOriginalOpening < 0 THEN CreditOriginalOpening - DebitOriginalOpening ELSE 0 END AS CreditOriginalOpening,
		CASE WHEN DebitOriginalOpening - CreditOriginalOpening > 0 THEN DebitOriginalOpening - CreditOriginalOpening ELSE 0 END AS DebitOriginalOpening,
		DebitOriginalOpening - CreditOriginalOpening AS OriginalOpening,
		CASE WHEN DebitConvertedOpening - CreditConvertedOpening < 0 THEN CreditConvertedOpening - DebitConvertedOpening ELSE 0 END AS CreditConvertedOpening,
		CASE WHEN DebitConvertedOpening - CreditConvertedOpening > 0 THEN DebitConvertedOpening - CreditConvertedOpening ELSE 0 END AS DebitConvertedOpening,
 		DebitConvertedOpening - CreditConvertedOpening AS ConvertedOpening,
		OriginalDebit,
		ConvertedDebit,
		OriginalCredit,
		ConvertedCredit,
		CASE WHEN DebitOriginalClosing - CreditOriginalClosing < 0 THEN CreditOriginalClosing - DebitOriginalClosing ELSE 0 END AS CreditOriginalClosing,
		CASE WHEN DebitOriginalClosing - CreditOriginalClosing > 0 THEN DebitOriginalClosing - CreditOriginalClosing ELSE 0 END AS DebitOriginalClosing,
		DebitOriginalClosing - CreditOriginalClosing AS OriginalClosing,   
		CASE WHEN DebitConvertedClosing - CreditConvertedClosing < 0 THEN CreditConvertedClosing - DebitConvertedClosing ELSE 0 END AS CreditConvertedClosing,
		CASE WHEN DebitConvertedClosing - CreditConvertedClosing > 0 THEN DebitConvertedClosing - CreditConvertedClosing ELSE 0 END AS DebitConvertedClosing,
		DebitConvertedClosing - CreditConvertedClosing AS ConvertedClosing,
		OriginalDebitYTD,
		ConvertedDebitYTD,
		OriginalCreditYTD,
		ConvertedCreditYTD   
	FROM AV7413_HT
	WHERE DebitOriginalOpening - CreditOriginalOpening <> 0 
		OR DebitConvertedOpening - CreditConvertedOpening <> 0 OR OriginalDebit <> 0 
		OR ConvertedDebit <> 0 OR OriginalCredit <> 0 OR ConvertedCredit <> 0 
		OR DebitOriginalClosing - CreditOriginalClosing <> 0 
		OR DebitConvertedClosing - CreditConvertedClosing <> 0 
	)x
	Group by x.DivisionID, x.O05ID, x.O05Name, x.AccountID, x.AccountName, x.CurrencyID,x.ObjectID, x.ObjectName
		'
	
Else
	
	Set @sSQLUnion =  ' 
	Select x.DivisionID, x.O05ID, x.O05Name,x.ObjectID, x.ObjectName, x.AccountID, x.AccountName, x.CurrencyID, Sum(x.ConvertIncome) as ConvertIncome,
	Sum(x.ConvertedOpening) as ConvertedOpening, Sum(x.ConvertedDebit) as ConvertedDebit, sum(x.ConvertedCredit) as ConvertedCredit,
	(Sum(x.ConvertedOpening)+Sum(x.ConvertedDebit)-sum(x.ConvertedCredit)) as ConvertedClosing
	From 
	(	
		SELECT DivisionID, 
		ObjectID, ObjectName,
		AccountID,
		AccountName, AccountNameE,
		''%'' AS CurrencyID,  	
		O05ID,
		O05Name, ConvertIncome,
		0 AS CreditOriginalOpening,
 		0 AS DebitOriginalOpening,
		0 AS OriginalOpening,
 		Case when Sum(DebitConvertedOpening)-SUM(CreditConvertedOpening) < 0 then  - Sum(DebitConvertedOpening) + SUM(CreditConvertedOpening) else 0 end AS CreditConvertedOpening,
		Case when Sum(DebitConvertedOpening)-SUM(CreditConvertedOpening) > 0 then  Sum(DebitConvertedOpening)-SUM(CreditConvertedOpening) else 0 end AS DebitConvertedOpening,
		Sum(DebitConvertedOpening)-SUM(CreditConvertedOpening) AS ConvertedOpening,
		sum(OriginalDebit) AS OriginalDebit,
		sum(ConvertedDebit) AS ConvertedDebit,
		sum(OriginalCredit) AS OriginalCredit,
		Sum(ConvertedCredit) AS ConvertedCredit,
		0 AS CreditOriginalClosing,
		0 AS DebitOriginalClosing,
		sum(DebitOriginalClosing - CreditOriginalClosing) AS OriginalClosing,
		Case when Sum(DebitConvertedClosing)-SUM(CreditConvertedClosing) < 0 then  - Sum(DebitConvertedClosing) + SUM(CreditConvertedClosing) else 0 end AS CreditConvertedClosing,
		Case when Sum(DebitConvertedClosing)-SUM(CreditConvertedClosing) > 0 then  Sum(DebitConvertedClosing)-SUM(CreditConvertedClosing) else 0 end AS DebitConvertedClosing,
		Sum(DebitConvertedClosing)-SUM(CreditConvertedClosing) AS ConvertedClosing,
		0 AS OriginalDebitYTD,
		0 AS ConvertedDebitYTD,
		0 AS OriginalCreditYTD,
		0 AS ConvertedCreditYTD
	FROM AV7413_HT
	WHERE DebitOriginalOpening - CreditOriginalOpening <> 0  
		OR DebitConvertedOpening - CreditConvertedOpening <> 0 OR OriginalDebit <> 0 
		OR ConvertedDebit <> 0 OR OriginalCredit <> 0 OR ConvertedCredit <> 0 
		OR DebitOriginalClosing - CreditOriginalClosing <> 0 
		OR DebitConvertedClosing - CreditConvertedClosing <> 0
	GROUP BY DivisionID, GroupID, GroupName, GroupID1, GroupName1, GroupID2, GroupName2,
	 ObjectID, ObjectName, AccountID, AccountName, AccountNameE,
		O05ID,
		O05Name, ConvertIncome

	)x
	Group by x.DivisionID, x.O05ID, x.O05Name, x.AccountID, x.AccountName, x.CurrencyID, x.ObjectID, x.ObjectName'

exec (@sSQLUnion)

GO


