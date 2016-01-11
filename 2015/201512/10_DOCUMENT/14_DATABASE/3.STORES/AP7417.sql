IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP7417]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP7417]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Tra ra View xac dinh so du cong no phai tra
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
-----Created by Nguyen Van Nhan, Date 10/10/2003
-----
-----Edited by Nguyen Thi Ngoc Minh, Date 27/04/2004
-----Purpose: Cho phep chon loai ngay len bao cao theo ngay  va theo ky
-----Edited by Dang Le Bao Quynh, Date 29/12/2008
-----Purpose: Bo sung view phuc in chi tiet phai tra theo ma phan tich
---- Modified on 24/11/2011 by Le Thi Thu Hien : Chinh sua where ngay
---- Modified on 08/12/2011 by Le Thi Thu Hien : Chinh sua '''%'''
---- Modified on 16/01/2012 by Le Thi Thu Hien : Chinh sua CONVERT ngay
---- Modified by on 15/10/2014 by Huỳnh Tấn Phú : Bổ sung điều kiện lọc theo 10 mã phân tích. 0022752: [VG] In số dư đầu kỳ lên sai dẫn đến số dư cuối kỳ sai. 
-- <Example>
---- 

CREATE PROCEDURE  [dbo].[AP7417] 
			@DivisionID AS NVARCHAR(50), 
			@FromObjectID AS  NVARCHAR(50),  
			@ToObjectID AS  NVARCHAR(50),  
			@FromAccountID AS NVARCHAR(50),  
			@ToAccountID AS NVARCHAR(50),  
			@CurrencyID NVARCHAR(50),  
			@FromPeriod AS int, 			
			@FromDate AS Datetime, 		
			@IsDate AS tinyint,
			@TypeDate AS NVARCHAR(20),
			@SqlFind AS NVARCHAR(MAX)

AS

DECLARE @sSQL AS nvarchar(max),
		@TempCurrID AS NVARCHAR(50),
		@TempCurrIDAna AS NVARCHAR(50),
		@AnaSQL_COLUMN AS NVARCHAR(max),
		@AnaSQL_GROUPBY AS NVARCHAR(max)
		
IF @CurrencyID ='%'
	BEGIN
		SET @TempCurrID ='''%'''
		SET @TempCurrIDAna ='''%'''
	END
Else
	BEGIN
		SET @TempCurrID =' AV4202.CurrencyIDCN '
		SET @TempCurrIDAna =' AV4203.CurrencyIDCN '
	End
SET @AnaSQL_COLUMN = ''
SET @AnaSQL_GROUPBY = ''
if @SqlFind <> '1=1'
	BEGIN
		SET @AnaSQL_COLUMN = ',Ana01ID,Ana02ID,Ana03ID,Ana04ID,Ana05ID,Ana06ID,Ana07ID,Ana08ID,Ana09ID,Ana10ID '
		SET @AnaSQL_GROUPBY = @AnaSQL_COLUMN
	END
ELSE
	SET @AnaSQL_COLUMN = ',NULL Ana01ID,NULL Ana02ID,NULL Ana03ID,NULL Ana04ID,NULL Ana05ID, NULL Ana06ID, NULL Ana07ID, NULL Ana08ID, NULL Ana09ID, NULL Ana10ID '
	
IF @IsDate not in  (1,2,3)   ---- Xac dinh theo ky	
	Begin
		SET @sSQL =' 
		SELECT 		AT1202.DivisionID,
					AV4202.ObjectID,
					AV4202.AccountID, 		
					' + @TempCurrID+' AS CurrencyIDCN,
					AT1202.ObjectName AS ObjectName,
					AT1005.AccountName AS AccountName,
					Sum(ConvertedAmount) AS OpeningConvertedAmount,
					Sum(OriginalAmount) AS OpeningOriginalAmount'+@AnaSQL_COLUMN+'
		FROM		AV4202	 
		INNER JOIN	AT1202 
			ON		AT1202.ObjectID = AV4202.ObjectID AND AT1202.DivisionID = AV4202.DivisionID
		INNER JOIN	AT1005 
			ON		AT1005.AccountID = AV4202.AccountID AND AT1005.DivisionID = AV4202.DivisionID
		WHERE		AV4202.DivisionID = ''' + @DivisionID + ''' AND
					(AV4202.TranMonth + 100 * AV4202.TranYear < ' + str(@FromPeriod) + ' or (AV4202.TranMonth + 100 * AV4202.TranYear = ' + str(@FromPeriod) + ' AND AV4202.TransactionTypeID =''T00'')) AND
					(AV4202.ObjectID BETWEEN ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''') AND
					AV4202.CurrencyIDCN like ''' + @CurrencyID + ''''+'	AND '+@SqlFind
			
		IF (@FromAccountID <> '%' AND @ToAccountID <> '%')
			SET @sSQL = @sSQL + ' AND (AV4202.AccountID BETWEEN  ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''')'
		
		SET @sSQL = @sSQL + ' GROUP BY AT1202.DivisionID,AV4202.ObjectID, AV4202.AccountID, AT1202.ObjectName, AT1005.AccountName '+@AnaSQL_GROUPBY
		
		IF @CurrencyID <> '%'
		SET @sSQL = @sSQL + ' , AV4202.CurrencyIDCN '
	
	End
Else
	 Begin
		SET @sSQL =' 
		SELECT 
					AT1202.DivisionID,
					AV4202.ObjectID,
					AV4202.AccountID,
					' + @TempCurrID + ' AS CurrencyIDCN,
					AT1202.ObjectName,
					AT1005.AccountName AS AccountName,
					Sum(ConvertedAmount) AS OpeningConvertedAmount,
					sum(OriginalAmount) AS OpeningOriginalAmount'+@AnaSQL_COLUMN+'
		FROM		AV4202  
		INNER JOIN	AT1202 
			ON		AT1202.ObjectID = AV4202.ObjectID AND AT1202.DivisionID = AV4202.DivisionID
		INNER JOIN	AT1005 on AT1005.AccountID = AV4202.AccountID AND AT1005.DivisionID = AV4202.DivisionID
		WHERE		AV4202.DivisionID = ''' + @DivisionID + ''' AND
					((CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) < ''' + CONVERT(NVARCHAR(10), @FromDate, 101) + ''') or
					 (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= ''' + convert(NVARCHAR(10), @FromDate, 101) + ''' AND TransactionTypeID = ''T00'')) AND
					(AV4202.ObjectID BETWEEN ''' + @FromObjectID + ''' AND ''' + @ToObjectID + ''')  AND
					(AV4202.AccountID BETWEEN ''' + @FromAccountID + ''' AND ''' + @ToAccountID + ''')  AND
					AV4202.CurrencyIDCN like ''' + @CurrencyID + ''' AND '+@SqlFind+'
		GROUP BY	AT1202.DivisionID,AV4202.ObjectID, AV4202.AccountID, AT1202.ObjectName, AT1005.AccountName '+@AnaSQL_GROUPBY
		IF @CurrencyID <> '%'
		SET @sSQL = @sSQL + ' , AV4202.CurrencyIDCN '
	End	
print  @sSQL
IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV7417]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV7417 AS ' + @sSQL)
ELSE
	EXEC ('  ALTER VIEW AV7417  AS ' + @sSQL)

IF @IsDate not in ( 1,2,3)   ---- Tinh theo Ky
	Begin
		SET @sSQL =' 
		SELECT 		AV4203.ObjectID, 
					AV4203.Ana01ID,
					AV4203.AccountID , 
					' + @TempCurrIDAna + ' AS CurrencyIDCN,
					AT1202.DivisionID ,
					AT1202.ObjectName ,
					AT1005.AccountName ,
					(SELECT Sum(ConvertedAmount) 
						FROM AV4203 V03
						WHERE V03.DivisionID = '''+@DivisionID+''' AND
						(V03.TranMonth + 100*V03.TranYear < '+str(@FromPeriod)+'  or (V03.TranMonth + 100*V03.TranYear = '+str(@FromPeriod)+'  AND V03.TransactionTypeID =''T00'' ) ) AND
						(V03.ObjectID = AV4203.ObjectID) AND
						(V03.AccountID BETWEEN  '''+@FromAccountID+''' AND  '''+@ToAccountID+''' ) AND
						V03.CurrencyIDCN like '''+@CurrencyID+ '''
					) AS OpeningConvertedAmount,
					(SELECT Sum(OriginalAmount) 
						FROM AV4203 V03 
						WHERE V03.DivisionID = '''+@DivisionID+''' AND
						( V03.TranMonth + 100*V03.TranYear < '+str(@FromPeriod)+'  or (V03.TranMonth + 100*V03.TranYear = '+str(@FromPeriod)+'  AND V03.TransactionTypeID =''T00'' ) ) AND
						(V03.ObjectID = AV4203.ObjectID) AND
						(V03.AccountID BETWEEN  '''+@FromAccountID+''' AND  '''+@ToAccountID+''' ) AND
						V03.CurrencyIDCN like '''+@CurrencyID+ '''
					) AS OpeningOriginalAmount,
					Sum(ConvertedAmount) AS OpeningConvertedAmountAna01ID,
					Sum(OriginalAmount) AS OpeningOriginalAmountAna01ID
		FROM		AV4203	
		INNER JOIN	AT1202 
			ON		AT1202.ObjectID = AV4203.ObjectID AND AT1202.DivisionID = AV4203.DivisionID
		INNER JOIN	AT1005 on AT1005.AccountID = AV4203.AccountID AND AT1005.DivisionID = AV4203.DivisionID
		WHERE		AV4203.DivisionID = '''+@DivisionID+''' AND
					( AV4203.TranMonth + 100*AV4203.TranYear < '+str(@FromPeriod)+'  or (AV4203.TranMonth + 100*AV4203.TranYear = '+str(@FromPeriod)+'  AND AV4203.TransactionTypeID =''T00'' ) ) AND
					(AV4203.ObjectID BETWEEN '''+ @FromObjectID + ''' AND ''' + @ToObjectID + ''') AND
					(AV4203.AccountID BETWEEN  '''+@FromAccountID+''' AND  '''+@ToAccountID+''' ) AND
					AV4203.CurrencyIDCN like '''+@CurrencyID+'''	
		GROUP BY	AT1202.DivisionID ,AV4203.ObjectID,  AV4203.Ana01ID, AV4203.AccountID ,  AT1202.ObjectName, AT1005.AccountName '
		IF @CurrencyID<>'%'
			SET @sSQL =@sSQL +',  AV4203.CurrencyIDCN '
	End

Else
	 Begin
		SET @sSQL =' 
		SELECT 		AV4203.ObjectID, AV4203.Ana01ID, AV4203.AccountID , 
					--AV4203.CurrencyID,
					'+@TempCurrIDAna+' AS CurrencyIDCN,
					AT1202.DivisionID,
					AT1202.ObjectName,
					AT1005.AccountName,
					(SELECT Sum(ConvertedAmount) 
						FROM AV4203 V03
						WHERE V03.DivisionID = '''+@DivisionID+''' AND
						( (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) < '''+convert(NVARCHAR(10),@FromDate,101)+'''  )  
						or ( CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(NVARCHAR(10),@FromDate,101)+''' 
						AND TransactionTypeID =''T00'' ) )  AND
						(V03.ObjectID = AV4203.ObjectID) AND
						(V03.AccountID BETWEEN  '''+@FromAccountID+''' AND  '''+@ToAccountID+''' ) AND
						V03.CurrencyIDCN like '''+@CurrencyID+''' 
					) AS OpeningConvertedAmount,
					(SELECT Sum(OriginalAmount) 
						FROM AV4203 V03 
						WHERE V03.DivisionID = '''+@DivisionID+''' AND
						( (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) < '''+convert(NVARCHAR(10),@FromDate,101)+'''  )  
						or ( CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(NVARCHAR(10),@FromDate,101)+''' AND TransactionTypeID =''T00'' ) )  AND
						(V03.ObjectID = AV4203.ObjectID) AND
						(V03.AccountID BETWEEN  '''+@FromAccountID+''' AND  '''+@ToAccountID+''' ) AND
						V03.CurrencyIDCN like '''+@CurrencyID+''' 
					) AS OpeningOriginalAmount,
					Sum(ConvertedAmount) AS OpeningConvertedAmountAna01ID,
					Sum(OriginalAmount) AS OpeningOriginalAmountAna01ID
		FROM		AV4203  	
		INNER JOIN	AT1202 
			ON		AT1202.ObjectID = AV4203.ObjectID AND AT1202.DivisionID = AV4203.DivisionID
		INNER JOIN	AT1005 
			ON		AT1005.AccountID = AV4203.AccountID AND AT1005.DivisionID = AV4203.DivisionID
		WHERE		AV4203.DivisionID = '''+@DivisionID+''' AND
					( (CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) < '''+convert(NVARCHAR(10),@FromDate,101)+'''  )  
					or ( CONVERT(DATETIME,CONVERT(varchar(10),' + LTRIM(RTRIM(@TypeDate)) + ',101),101) <= '''+convert(NVARCHAR(10),@FromDate,101)+''' AND TransactionTypeID =''T00'' ) )  AND
					(AV4203.ObjectID BETWEEN '''+ @FromObjectID + ''' AND ''' + @ToObjectID + ''') AND
					(AV4203.AccountID BETWEEN  '''+@FromAccountID+''' AND  '''+@ToAccountID+''' ) AND
					AV4203.CurrencyIDCN like '''+@CurrencyID+'''	
		GROUP BY AT1202.DivisionID ,AV4203.ObjectID ,  AV4203.Ana01ID, AV4203.AccountID,    AT1202.ObjectName, AT1005.AccountName '
		IF @CurrencyID<>'%'
			SET @sSQL =@sSQL +',  AV4203.CurrencyIDCN '
	End
	

IF not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV7427]') AND OBJECTPROPERTY(id, N'IsView') = 1)
	Exec ('  Create View AV7427 AS ' + @sSQL)
Else
	Exec ('  Alter View AV7427  AS ' + @sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

