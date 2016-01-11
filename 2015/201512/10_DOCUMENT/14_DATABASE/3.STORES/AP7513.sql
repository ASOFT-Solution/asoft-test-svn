IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7513]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7513]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- So quy theo ngay
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 20/09/2004 by Nguyen Van Nhan
---- 
---- Edited by Nguyen Quoc Huy, Date 01/09/2006
---- Edit by: Dang Le Bao Quynh, Date 28/08/2009: Thay doi lai cach lay truong DebitOriginalAmount tuong tu nhu in theo thang
---- Edited by: [GS] [Cam Loan] [30/07/2010]
---- Modified on 21/09/2011 by Nguyễn Bình Minh : bổ sung loại bút toán T19 bút toán CLTG xuất
---- Modified on 11/01/2012 by Le Thi Thu Hien : Sua dieu kien loc theo ngay
---- Modified on 14/03/2012 by Le Thi Thu Hien : Bổ sung ReVoucherNo( bút toán CLTG xuất)
---- Modified on 24/05/2013 by Lê Thị Thu Hiền : Bổ sung 10 khoản mục Ana
---- Modified on 03/10/2014 by Trần Quốc Tuấn : Bổ sung thêm điều kiện lọc tính số dư đầu kỳ
---- Modified on 17/12/2014 by Mai Duyen : Fix loi so du dau ngay khong dung
---- Modified on 10/09/2015 by Tiểu Mai: Bổ sung tên 10 MPT, 10 tham số
---- Modified on 08/10/2015 by Tieu Mai: Sửa phần tiền hạch toán theo thiết lập đơn vị-chi nhánh

-- <Example>
---- exec AP7513 @DivisionID=N'VG',@BankAccountID=N'DA-CN',@FromDate='2014-10-03 08:40:49',@ToDate='2014-10-03 08:40:49',@sqlWhere=N'1=1'

CREATE PROCEDURE [dbo].[AP7513] 
(
	@DivisionID AS NVARCHAR(50),
	@BankAccountID AS NVARCHAR(50),
	@FromDate AS DATETIME,
	@ToDate AS DATETIME,
	@SqlWhere AS NVARCHAR(MAX)
)	

AS
DECLARE @StartOriginalAmount   AS DECIMAL(28, 8),
        @StartConvertedAmount  AS DECIMAL(28, 8),
        @BegOriginalAmount     AS DECIMAL(28, 8),
        @BegConvertedAmount    AS DECIMAL(28, 8),
        @DetalOriginalAmount   AS DECIMAL(28, 8),
        @DetalConvertedAmount  AS DECIMAL(28, 8),
        @EndOrginalAmount      AS DECIMAL(28, 8),
        @EndConvertedAmount    AS DECIMAL(28, 8),
        @StartMonth            AS INT,
        @StartYear             AS INT,
        @sSQL                  AS NVARCHAR(MAX),
        @sSQL1                 AS NVARCHAR(MAX),
        @BaseCurrencyID        AS NVARCHAR(50),
        @AccountID             AS NVARCHAR(50),
        @CurrencyID            AS NVARCHAR(50),
        @BankName              AS NVARCHAR(250),
        @BankAccountNo         AS NVARCHAR(50),
        @sSQLBegin             AS NVARCHAR(max)
DECLARE
        @Temp table (StartOriginalAmount decimal(28,8),StartConvertedAmount decimal(28,8))

SET @BaseCurrencyID = ISNULL((SELECT TOP 1 BaseCurrencyID FROM AT1101 WHERE	DivisionID = @DivisionID), 'VND')

SELECT @CurrencyID = CurrencyID,
       @AccountID = AccountID,
       @BankName = dbo.ReplaceSepecialChar(AT1016.BankName),
       @BankAccountNo = BankAccountNo
FROM   AT1016
WHERE  BankAccountID = @BankAccountID AND DivisionID = @DivisionID

/* ---- */
SET @CurrencyID = ISNULL(@CurrencyID, '')
SET @AccountID = ISNULL(@AccountID, '')
SET @BankName = ISNULL(@BankName, '')
SET @BankAccountNo = ISNULL(@BankAccountNo, '')
/* ---- */


----- Buoc 1, So du dau ky------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET @StartMonth = (SELECT		TOP 1 TranMonth 
                   FROM			AT9999 
                   WHERE		DivisionID = @DivisionID 
                   ORDER BY		(TranMonth + TranYear * 100))

SET @StartYear = (	SELECT		TOP 1 TranYear
					FROM		AT9999
					WHERE		DivisionID = @DivisionID
                  	ORDER BY	(TranMonth + TranYear * 100))

------ So du ban dau
SET @sSQLBegin =	'SELECT SUM(CASE WHEN DebitAccountID ='''+ @AccountID+''' THEN OriginalAmount ELSE - OriginalAmount END) StartOriginalAmount,
					SUM(	CASE WHEN DebitAccountID = '''+@AccountID+''' THEN ConvertedAmount ELSE - ConvertedAmount END) StartConvertedAmount
					FROM   AT9000
					WHERE  TranMonth = '+str(@StartMonth)+'
					AND TranYear = '+str(@StartYear)+'
					AND DivisionID = '''+@DivisionID+'''
					AND (DebitBankAccountID = '''+@BankAccountID+''' OR CreditBankAccountID = '''+@BankAccountID+''')
					AND CurrencyID = '''+@CurrencyID+'''
					AND TransactionTypeID = ''T00''
					AND '+@SqlWhere+' --- So du dau '
					
INSERT INTO @Temp (StartOriginalAmount, StartConvertedAmount) EXEC(@sSQLBegin)
SELECT @StartOriginalAmount = ISNULL(StartOriginalAmount,0),
@StartConvertedAmount = StartConvertedAmount
FROM @Temp
--print @sSQLBegin
--Print str(@StartOriginalAmount)

--- Xac dinh so phat sinh truoc giai doan (FromDate )


SET @sSQLBegin ='SELECT	(ISNULL(
					(	SELECT SUM(	CASE WHEN AT9000.CurrencyID <> '''+ @BaseCurrencyID+''' AND TransactionTypeID = ''T16'' THEN OriginalAmount 
									ELSE
									   CASE WHEN TransactionTypeID = ''T16'' THEN
                           					ConvertedAmount
									   ELSE OriginalAmount
									   END 
         	           				END)
						FROM   AT9000
						WHERE  DivisionID = '''+@DivisionID+'''
							   AND DebitBankAccountID = '''+@BankAccountID+'''
							   AND TransactionTypeID <> ''T00''
							   AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101), 101) < ''' +  CONVERT(nVARCHAR(10), (@FromDate) ,101) + '''
							   AND ' + @SqlWhere + '
							   
					), 0)     
				- ISNULL(
    				(	SELECT SUM(CASE WHEN TransactionTypeID = ''T16'' AND AT9000.CurrencyIDCN <> '''+@BaseCurrencyID+''' THEN OriginalAmountCN
									   ELSE CASE WHEN TransactionTypeID = ''T16'' THEN
										  ConvertedAmount
											ELSE OriginalAmount
											END 
    	 						   END)
						FROM   AT9000
						WHERE  DivisionID = '''+@DivisionID+'''
							   AND CreditBankAccountID = '''+@BankAccountID+'''
							   AND TransactionTypeID <> ''T00''
							   AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101), 101) < ''' +  CONVERT(nVARCHAR(10), (@FromDate) ,101) + '''
							   AND ' + @SqlWhere + '
					), 0)), 0'
					
INSERT INTO @Temp (StartOriginalAmount, StartConvertedAmount) EXEC(@sSQLBegin)
		SELECT @DetalOriginalAmount = ISNULL(StartOriginalAmount,0)
		FROM @Temp	
--Print @sSQLBegin
--Print str(@DetalOriginalAmount)
		
SET @sSQLBegin ='SELECT (ISNULL(
					(	SELECT SUM(ISNULL(ConvertedAmount, 0))
						FROM   AT9000
						WHERE  DivisionID = '''+@DivisionID+'''
							   AND DebitBankAccountID = '''+@BankAccountID+'''
							   AND TransactionTypeID <> ''T00''
							   AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101), 101) < ''' +  CONVERT(nVARCHAR(10), (@FromDate) ,101) + '''
					), 0) 
				- ISNULL(
					(	SELECT SUM(ISNULL(ConvertedAmount, 0))
						FROM   AT9000
						WHERE  DivisionID = '''+@DivisionID+'''
							   AND CreditBankAccountID ='''+ @BankAccountID+'''
							   AND TransactionTypeID <> ''T00''
							   AND CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101), 101) < ''' +  CONVERT(nVARCHAR(10), (@FromDate) ,101) + '''
							   
					), 0)),0'
					
	INSERT INTO @Temp (StartOriginalAmount, StartConvertedAmount) EXEC(@sSQLBegin)
		SELECT @DetalConvertedAmount = ISNULL(StartOriginalAmount,0)
		FROM @Temp	
SET @BegOriginalAmount = ISNULL(@StartOriginalAmount, 0) + ISNULL(@DetalOriginalAmount, 0)
SET @BegConvertedAmount = ISNULL(@StartConvertedAmount, 0) + ISNULL(@DetalConvertedAmount, 0)

--print 'BegOriAmt ' + str(@BegOriginalAmount) + '	BegConvAmt ' + str(@BegConvertedAmount)

----- Buoc 2,  Xac dinh so phat sinh ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET @sSQL = '
SELECT	(CASE WHEN AT9000.DebitBankAccountID = N''' + @BankAccountID + ''' THEN 0 ELSE 1 END) AS TransactionTypeID, 
		AT9000.TransactionID, AT9000.BatchID, AT9000.VoucherID,		
		AT9000.TranMonth, AT9000.TranYear, AT9000.DivisionID,
		AT9000.VoucherDate,	AT9000.VoucherTypeID,
		AT9000.VoucherNo,
		(CASE WHEN AT9000.DebitBankAccountID = N''' + @BankAccountID + ''' THEN AT9000.VoucherNo ELSE '''' END) AS DebitVoucherNo,
		(CASE WHEN AT9000.CreditBankAccountID = N''' + @BankAccountID + ''' THEN AT9000.VoucherNo ELSE '''' END) AS CreditVoucherNo,
		Ana01ID,	Ana02ID,	Ana03ID,	Ana04ID,	Ana05ID,
		Ana06ID,	Ana07ID,	Ana08ID,	Ana09ID,	Ana10ID,
		A11.AnaName AS Ana01Name,A12.AnaName AS Ana02Name,A13.AnaName AS Ana03Name,A14.AnaName AS Ana04Name,A15.AnaName AS Ana05Name,
		A16.AnaName AS Ana06Name,A17.AnaName AS Ana07Name,A18.AnaName AS Ana08Name,A19.AnaName AS Ana09Name,A10.AnaName AS Ana10Name,
		AT9000.ObjectID,
		--AT1202.ObjectName,
		(CASE WHEN AT1202.IsUpdateName = 1 THEN AT9000.VATObjectName ELSE AT1202.ObjectName END) AS ObjectName,	
		AT9000.Serial, AT9000.InvoiceNo, AT9000.InvoiceDate,
		DebitAccountID, CreditAccountID,
		(CASE WHEN TransactionTypeID = ''T16'' AND CreditBankAccountID = N''' + @BankAccountID +  ''' THEN CurrencyIDCN ELSE AT9000.CurrencyID END) AS CurrencyID, 
		(	CASE WHEN TransactionTypeID = ''T16''  AND CreditBankAccountID = N''' + @BankAccountID + ''' 
				THEN ExchangeRateCN 
			ELSE
				CASE WHEN TransactionTypeID = ''T16''  AND DebitBankAccountID = N''' + @BankAccountID + ''' AND AT9000.CurrencyID = N''' + @BaseCurrencyID + '''  
					THEN 1  
				ELSE ExchangeRate END 
		 	END) AS ExchangeRate,
		N''' + @AccountID + ''' AS AccountID,
		N''' + @BankAccountNo + ''' AS BankAccountNo,
		N''' + @BankAccountID + ''' AS BankAccountID,
		N''' + @BankName + ''' AS BankName,
		( CASE WHEN DebitBankAccountID = N''' + @BankAccountID + ''' THEN CreditAccountID ELSE DebitAccountID END) AS RelationAccountID,		
		(	CASE WHEN DebitBankAccountID = N''' + @BankAccountID + '''   AND TransactionTypeID =''T16'' AND AT9000.CurrencyID = N''' + @BaseCurrencyID + ''' 
				THEN ConvertedAmount 
			ELSE
					CASE WHEN DebitBankAccountID = N''' + @BankAccountID + ''' AND TransactionTypeID = ''T16'' AND AT9000.CurrencyID <> N''' + @BaseCurrencyID + ''' 
						THEN OriginalAmount 
					ELSE
						CASE WHEN DebitBankAccountID = N''' + @BankAccountID + '''  THEN OriginalAmount ELSE  0 END 
					END 
		 	END) AS DebitOriginalAmount,
		(	CASE WHEN CreditBankAccountID = N''' + @BankAccountID + ''' AND TransactionTypeID = ''T16'' AND CurrencyIDCN = N''' + @BaseCurrencyID + ''' 
				THEN ConvertedAmount 
			ELSE  
				CASE WHEN CreditBankAccountID = N''' + @BankAccountID + ''' AND TransactionTypeID = ''T16''  
					THEN OriginalAmountCN
				ELSE
					CASE WHEN CreditBankAccountID = N''' + @BankAccountID + ''' THEN OriginalAmount ELSE 0 END 
				END  
		 	END ) AS CreditOriginalAmount,
		(CASE WHEN DebitBankAccountID = N''' + @BankAccountID + ''' THEN CAST(ConvertedAmount AS DECIMAL(28,8)) ELSE 0 END) AS DebitConvertedAmount,
		(CASE WHEN CreditBankAccountID = N''' + @BankAccountID + ''' THEN CAST(ConvertedAmount AS DECIMAL(28,8)) ELSE 0 END) AS CreditConvertedAmount,			
		VDescription, BDescription, TDescription, 
		' + STR(ISNULL(@BegOriginalAmount, 0), 28, 4) + ' AS BegOriginalAmount,
		' + STR(ISNULL(@BegConvertedAmount, 0), 28, 4) + ' AS BegConvertedAmount,
		AT9000.CreateDate,
		AT9000.Orders,
		A.VoucherNo AS ReVoucherNo					 
		,AT9000.[RefNo01], AT9000.[RefNo02],
		AT9000.Parameter01,AT9000.Parameter02,AT9000.Parameter03,AT9000.Parameter04,AT9000.Parameter05,AT9000.Parameter06,AT9000.Parameter07,AT9000.Parameter08,AT9000.Parameter09,AT9000.Parameter10
'
SET @sSQL1 = '
FROM	AT9000 
LEFT JOIN AT1011 A11 on A11.AnaID = AT9000.Ana01ID AND A11.DivisionID=AT9000.DivisionID AND A11.AnaTypeID = ''A01''
LEFT JOIN AT1011 A12 on A12.AnaID = AT9000.Ana01ID AND A12.DivisionID=AT9000.DivisionID AND A12.AnaTypeID = ''A02''
LEFT JOIN AT1011 A13 on A13.AnaID = AT9000.Ana01ID AND A13.DivisionID=AT9000.DivisionID AND A13.AnaTypeID = ''A03''
LEFT JOIN AT1011 A14 on A14.AnaID = AT9000.Ana01ID AND A14.DivisionID=AT9000.DivisionID AND A14.AnaTypeID = ''A04''
LEFT JOIN AT1011 A15 on A15.AnaID = AT9000.Ana01ID AND A15.DivisionID=AT9000.DivisionID AND A15.AnaTypeID = ''A05''
LEFT JOIN AT1011 A16 on A16.AnaID = AT9000.Ana01ID AND A16.DivisionID=AT9000.DivisionID AND A16.AnaTypeID = ''A06''
LEFT JOIN AT1011 A17 on A17.AnaID = AT9000.Ana01ID AND A17.DivisionID=AT9000.DivisionID AND A17.AnaTypeID = ''A07''
LEFT JOIN AT1011 A18 on A18.AnaID = AT9000.Ana01ID AND A18.DivisionID=AT9000.DivisionID AND A18.AnaTypeID = ''A08'' 
LEFT JOIN AT1011 A19 on A19.AnaID = AT9000.Ana01ID AND A19.DivisionID=AT9000.DivisionID AND A19.AnaTypeID = ''A09''
LEFT JOIN AT1011 A10 on A10.AnaID = AT9000.Ana01ID AND A10.DivisionID=AT9000.DivisionID AND A10.AnaTypeID = ''A10''
LEFT JOIN AT1202 ON AT1202.ObjectID =  AT9000.ObjectID AND AT1202.DivisionID = AT9000.DivisionID
-------->>> Lấy bút toán được đánh giá chênh lệch tỷ giá xuất
LEFT JOIN	(	SELECT	DISTINCT VoucherID,BatchID, TransactionID,VoucherNo , DivisionID
         		FROM	AT9000
         	 	WHERE	AT9000.TransactionTypeID IN (''T21'', ''T22'', ''T09'', ''T16'')
         	 			AND DivisionID = '''+@DivisionID+'''
         	 ) A 
    ON		A.VoucherID = AT9000.RevoucherID 
			AND A.BatchID = AT9000.ReBatchID
			AND A.TransactionID = AT9000.ReTransactionID
			AND A.DivisionID = AT9000.DivisionID

WHERE	AT9000.TransactionTypeID IN (''T21'', ''T22'', ''T09'', ''T16'', ''T19'') 
		AND AT9000.DivisionID = N''' + @DivisionID + ''' 
		AND (CONVERT(DATETIME,CONVERT(VARCHAR(10),VoucherDate,101), 101) Between ''' + CONVERT(VARCHAR(10), @FromDate, 101) + ''' AND ''' + CONVERT(VARCHAR(10), @ToDate, 101) + ''' ) 
		AND (DebitBankAccountID = N''' + @BankAccountID +  ''' OR CreditBankAccountID = N''' + @BankAccountID + ''')'


--PRINT @sSQL
IF NOT EXISTS ( SELECT TOP 1 1 FROM sysobjects WHERE  NAME = 'AV7512' AND Xtype = 'V')
    EXEC ('  CREATE VIEW AV7512 AS ' + @sSQL+@sSQL1)
ELSE
    EXEC ('  ALTER VIEW AV7512 AS ' + @sSQL+@sSQL1)

IF EXISTS (SELECT TOP 1 1 FROM   AV7512)
    SET @sSQL = 'SELECT * FROM AV7512'
ELSE
    SET @sSQL = 
        'SELECT 	NULL AS TransactionTypeID, 
					NULL AS TransactionID,
					NULL AS BatchID, 
					NULL AS VoucherID,		
					NULL AS TranMonth, 
					NULL AS TranYear, 
					N''' + @DivisionID + ''' AS DivisionID,
					NULL AS VoucherNo,
					--NULL AS VoucherDate,	
					Convert(DateTime,'''') AS VoucherDate,	
					NULL AS VoucherTypeID,
					NULL  AS DebitVoucherNo,
					NULL AS CreditVoucherNo,
					Null as	Ana01ID,
					Null as	Ana02ID,
					Null as	Ana03ID,
					Null as	Ana04ID,
					Null as	Ana05ID,
					Null as	Ana06ID,
					Null as	Ana07ID,
					Null as	Ana08ID,
					Null as	Ana09ID,
					Null as	Ana10ID,
					Null as Ana01Name,
					Null as Ana02Name,
					Null as Ana03Name,
					Null as Ana04Name,
					Null as Ana05Name,
					Null as Ana06Name,
					Null as Ana07Name,
					Null as Ana08Name,
					Null as Ana09Name,
					Null as Ana10Name,
					NULL AS ObjectID,
					NULL AS ObjectName,	
					NULL AS Serial, 
					NULL AS InvoiceNo, 
					NULL AS InvoiceDate,
					NULL AS DebitAccountID, 
					NULL AS CreditAccountID,
					N''' + @CurrencyID + ''' AS CurrencyID, 
					NULL AS ExchangeRate,
					N''' + @AccountID + ''' AS AccountID,
					N''' + @BankAccountID + ''' AS BankAccountID,
					N''' + @BankAccountNo + ''' AS BankAccountNo,
					N''' + @BankName + ''' AS BankName,
					NULL AS  RelationAccountID,
					0  AS DebitOriginalAmount,
					0 AS  CreditOriginalAmount,
					0 AS DebitConvertedAmount,
					0 AS CreditConvertedAmount,			
					NULL AS VDescription, 
					NULL AS BDescription, 
					NULL AS TDescription,
					' + STR(ISNULL(@BegOriginalAmount, 0), 28, 4) + ' AS BegOriginalAmount,
					' + STR(ISNULL(@BegConvertedAmount, 0), 28, 4) + ' AS BegConvertedAmount,
					'''' AS CreateDate,
					0 AS Orders,
					'''' AS ReVoucherNo
					,'''' AS [RefNo01], '''' AS [RefNo02],
					Null as Parameter01, Null as Parameter02, Null as Parameter03, Null as Parameter04, Null as Parameter05,
					Null as Parameter06, Null as Parameter07, Null as Parameter08, Null as Parameter09, Null as Parameter10' 

--PRINT @sSQL
IF NOT EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE  NAME = 'AV7502' AND Xtype = 'V')
    EXEC ('  CREATE VIEW AV7502 AS ' + @sSQL)
ELSE
    EXEC ('  ALTER VIEW AV7502  AS ' + @sSQL)



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

