IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0394]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0394]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Created by Van Nhan, Date 19/06/2009
----- purpose: Phat sinh cong no, duoc goi tu AP0393
-----Last edit : Thuy Tuyen, date 09/09/2008
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
---- Modified on 21/05/2013 by Lê Thị Thu Hiền : Bo sung but toan tong hop AT9090

CREATE PROCEDURE [dbo].[AP0394] 	
			@DivisionID AS nvarchar(50),
			@ReportDate AS Datetime,
			@FromAccountID AS nvarchar(50),
			@ToAccountID AS nvarchar(50),
			@FromObjectID AS nvarchar(50),
			@ToObjectID AS nvarchar(50),
			@CurrencyID AS nvarchar(50),
			@IsGroup AS tinyint,
			@GroupID AS nvarchar(50)
					
 AS
Declare @sSQL AS nvarchar(MAX),
		@sSQL1 AS nvarchar(MAX),
		@Month AS int,
		@Year AS int,
		@Period01 AS int,
		@GroupIDField  AS nvarchar(MAX)

Set nocount off
--Delete AT0393
set @Month = month(@ReportDate)
set @Year = year(@ReportDate)
-----------------------------------------No qua han ------------------------------------------------------------------------
Set @Period01=Month(@ReportDate)+12*Year(@ReportDate)

If @IsGroup = 1

Begin
set @GroupIDField =  (Select Case @GroupID when  'A01'  then 'Ana01ID'
					   when 'O01' then 'O01ID'   when 'O02' then 'O02ID'   when 'O03' then 'O03ID'   when 'O04' then 'O04ID' 
			   when 'O05' then 'O05ID'   End)
Set @sSQL= N'
SELECT 	AT9000.ObjectID,
         '+@GroupIDField+' AS   GroupID ,   null AS OriginalAmount, AT9000.BatchID, At9000.DebitAccountID, 
	CASE WHEN month(DueDate)+Year(DueDate)*12= '+str(@Period01)+' then SUM(AT9000.OriginalAmountCN)- sum (isnull(GT.OriginalAmount,0) )Else 0 End AS Amount00,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-1 then SUM(AT9000.OriginalAmountCN)- SUM(isnull(GT.OriginalAmount,0)) Else 0 End AS Amount01,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-2 then SUM(AT9000.OriginalAmountCN)- SUM(isnull(GT.OriginalAmount,0)) Else 0 End AS Amount02,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-3 then SUM(AT9000.OriginalAmountCN)- SUM(isnull(GT.OriginalAmount,0)) Else 0 End AS Amount03,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-4 then SUM(AT9000.OriginalAmountCN)- SUM(isnull(GT.OriginalAmount,0)) Else 0 End AS Amount04,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-5 then SUM(AT9000.OriginalAmountCN)- SUM(isnull(GT.OriginalAmount,0)) Else 0 End AS Amount05,
	CASE WHEN month(DueDate)+Year(DueDate)*12<=  '+str(@Period01)+'-6 then SUM(AT9000.OriginalAmountCN)- SUM(isnull(GT.OriginalAmount,0)) Else 0 End AS Amount06,
	
	CASE WHEN month(DueDate)+Year(DueDate)*12= '+str(@Period01)+' then SUM(AT9000.ConvertedAmount) -    SUM(isnull(GT.ConvertedAmount,0)) Else 0 End AS ConAmount00,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-1 then SUM(AT9000.ConvertedAmount) - SUM(isnull(GT.ConvertedAmount,0)) Else 0 End AS ConAmount01,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-2 then SUM(AT9000.ConvertedAmount) - SUM(isnull(GT.ConvertedAmount,0)) Else 0 End AS ConAmount02,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-3 then SUM(AT9000.ConvertedAmount) - SUM(isnull(GT.ConvertedAmount,0))Else 0 End AS ConAmount03,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-4 then SUM(AT9000.ConvertedAmount) -  SUM(isnull(GT.ConvertedAmount,0)) Else 0 End AS ConAmount04,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-5 then SUM(AT9000.ConvertedAmount) -  SUM(isnull(GT.ConvertedAmount,0)) Else 0 End AS ConAmount05,
	CASE WHEN month(DueDate)+Year(DueDate)*12<=  '+str(@Period01)+'-6 then SUM(AT9000.ConvertedAmount) - SUM(isnull(GT.ConvertedAmount,0)) Else 0 End AS ConAmount06,
	AT9000.DivisionID
	'
SET @sSQL1 = N'
FROM 
	(SELECT A.ObjectID,A.OriginalAmount, A.ConvertedAmount, A.BatchID, 
			A.DebitAccountID,A.DueDate, A.OriginalAmountCN,
			A.DivisionID, A.VoucherID, A.TableID, A.CurrencyIDCN
	FROM AT9000 A
	WHERE	A.DivisionID = '''+@DivisionID+'''
			AND (DebitAccountID between '''+@FromAccountID+''' AND '''+@ToAccountID+''' ) 
			AND DueDate<'''+convert(nvarchar(10),@ReportDate,21)+''' 
			AND A.ObjectID between '''+@FromObjectID+''' AND '''+@ToObjectID+''' 
			AND A.CurrencyIDCN like '''+@CurrencyID+'''
	UNION ALL
	SELECT 	A.ObjectID,A.OriginalAmount, A.ConvertedAmount, A.VoucherID AS BatchID, 
			A.DebitAccountID,A.DueDate, A.OriginalAmount AS OriginalAmountCN,
			A.DivisionID, A.VoucherID,''AT9090'' AS TableID, A.CurrencyID AS CurrencyIDCN
	FROM AT9090 A
	WHERE	A.DivisionID = '''+@DivisionID+'''
			AND (DebitAccountID between '''+@FromAccountID+''' AND '''+@ToAccountID+''' ) 
			AND DueDate<'''+convert(nvarchar(10),@ReportDate,21)+''' 
			AND A.ObjectID between '''+@FromObjectID+''' AND '''+@ToObjectID+''' 
			AND A.CurrencyID like '''+@CurrencyID+'''
	)AT9000 
LEFT JOIN (SELECT	AT0303.DivisionID, AT0303.DebitVoucherID, 
					AT0303.ObjectID,AT0303.AccountID , 
					AT0303.DebitTableID,AT0303.DebitBatchID,
					SUM(AT0303.OriginalAmount) AS OriginalAmount, 
					SUM(AT0303.ConvertedAmount) AS ConvertedAmount
			FROM	AT0303
			GROUP BY	AT0303.DivisionID, AT0303.DebitVoucherID, 
						AT0303.ObjectID,AT0303.AccountID , 
						AT0303.DebitTableID,AT0303.DebitBatchID  
			) AS GT

	 ON 	GT.DebitVoucherID = AT9000.VoucherID and
			GT.ObjectID = AT9000.ObjectID and
			GT.AccountID = AT9000.DebitAccountID and
			GT.DebitTableID = AT9000.TableID and
			GT.DebitBatchID = AT9000.BatchID and
			GT.DivisionID = AT9000.DivisionID	
INNER JOIN	AT1202 on AT1202.ObjectID  = AT9000.ObjectID AND AT1202.DivisionID = AT9000.DivisionID
GROUP BY	AT9000.DivisionID, AT9000.DueDate, AT9000.ObjectID , 
			AT9000.BatchID, AT9000.DebitAccountID,  
			'+@GroupIDField+'
HAVING		SUM(AT9000.OriginalAmountCN)- sum (isnull(GT.OriginalAmount,0) )<>0 '

END
ELSE
If @IsGroup = 0
BEGIN
SET @sSQL= N'
SELECT 	AT9000.ObjectID,
        ''''  AS   GroupID ,   null AS OriginalAmount, AT9000.BatchID, AT9000.DebitAccountID, 
	CASE WHEN month(DueDate)+Year(DueDate)*12= '+str(@Period01)+' then SUM(AT9000.OriginalAmountCN)- sum (isnull(GT.OriginalAmount,0) )Else 0 End AS Amount00,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-1 then SUM(AT9000.OriginalAmountCN)- SUM(isnull(GT.OriginalAmount,0)) Else 0 End AS Amount01,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-2 then SUM(AT9000.OriginalAmountCN)- SUM(isnull(GT.OriginalAmount,0)) Else 0 End AS Amount02,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-3 then SUM(AT9000.OriginalAmountCN)- SUM(isnull(GT.OriginalAmount,0)) Else 0 End AS Amount03,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-4 then SUM(AT9000.OriginalAmountCN)- SUM(isnull(GT.OriginalAmount,0)) Else 0 End AS Amount04,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-5 then SUM(AT9000.OriginalAmountCN)- SUM(isnull(GT.OriginalAmount,0)) Else 0 End AS Amount05,
	CASE WHEN month(DueDate)+Year(DueDate)*12<=  '+str(@Period01)+'-6 then SUM(AT9000.OriginalAmountCN)- SUM(isnull(GT.OriginalAmount,0)) Else 0 End AS Amount06,
	
	CASE WHEN month(DueDate)+Year(DueDate)*12= '+str(@Period01)+' then SUM(AT9000.ConvertedAmount) -    SUM(isnull(GT.ConvertedAmount,0)) Else 0 End AS ConAmount00,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-1 then SUM(AT9000.ConvertedAmount) - SUM(isnull(GT.ConvertedAmount,0)) Else 0 End AS ConAmount01,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-2 then SUM(AT9000.ConvertedAmount) - SUM(isnull(GT.ConvertedAmount,0)) Else 0 End AS ConAmount02,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-3 then SUM(AT9000.ConvertedAmount) - SUM(isnull(GT.ConvertedAmount,0))Else 0 End AS ConAmount03,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-4 then SUM(AT9000.ConvertedAmount) -  SUM(isnull(GT.ConvertedAmount,0)) Else 0 End AS ConAmount04,
	CASE WHEN month(DueDate)+Year(DueDate)*12=  '+str(@Period01)+'-5 then SUM(AT9000.ConvertedAmount) -  SUM(isnull(GT.ConvertedAmount,0)) Else 0 End AS ConAmount05,
	CASE WHEN month(DueDate)+Year(DueDate)*12<=  '+str(@Period01)+'-6 then SUM(AT9000.ConvertedAmount) - SUM(isnull(GT.ConvertedAmount,0)) Else 0 End AS ConAmount06,
	AT9000.DivisionID
'
SET @sSQL1 = N'
FROM 
(SELECT		A.ObjectID,A.OriginalAmount, A.ConvertedAmount, A.BatchID, 
			A.DebitAccountID,A.DueDate, A.OriginalAmountCN,
			A.DivisionID, A.VoucherID, A.TableID, A.CurrencyIDCN
	FROM	AT9000 A
	WHERE	A.DivisionID = '''+@DivisionID+'''
			AND (DebitAccountID between '''+@FromAccountID+''' AND '''+@ToAccountID+''' ) 
			AND DueDate<'''+convert(nvarchar(10),@ReportDate,21)+''' 
			AND A.ObjectID between '''+@FromObjectID+''' AND '''+@ToObjectID+''' 
			AND A.CurrencyIDCN like '''+@CurrencyID+'''
	UNION ALL
	SELECT 	A.ObjectID,A.OriginalAmount, A.ConvertedAmount , A.VoucherID AS BatchID, 
			A.DebitAccountID,A.DueDate, A.OriginalAmount AS OriginalAmountCN,
			A.DivisionID, A.VoucherID, ''AT9090'' AS TableID, A.CurrencyID AS CurrencyIDCN
	FROM	AT9090 A
	WHERE	A.DivisionID = '''+@DivisionID+'''
			AND (DebitAccountID between '''+@FromAccountID+''' AND '''+@ToAccountID+''' ) 
			AND DueDate<'''+convert(nvarchar(10),@ReportDate,21)+''' 
			AND A.ObjectID between '''+@FromObjectID+''' AND '''+@ToObjectID+''' 
			AND A.CurrencyID like '''+@CurrencyID+'''
	)AT9000  
LEFT JOIN (SELECT	AT0303.DivisionID, AT0303.DebitVoucherID, 
					AT0303.ObjectID,AT0303.AccountID , 
					AT0303.DebitTableID,AT0303.DebitBatchID,
					SUM(AT0303.OriginalAmount) AS OriginalAmount, 
					SUM(AT0303.ConvertedAmount) AS ConvertedAmount
			FROM	AT0303
			GROUP BY	AT0303.DivisionID, AT0303.DebitVoucherID, 
						AT0303.ObjectID,AT0303.AccountID , 
						AT0303.DebitTableID,AT0303.DebitBatchID  
			) AS GT

	 ON 	GT.DebitVoucherID = AT9000.VoucherID and
			GT.ObjectID = AT9000.ObjectID and
			GT.AccountID = AT9000.DebitAccountID and
			GT.DebitTableID = AT9000.TableID and
			GT.DebitBatchID = AT9000.BatchID and
			GT.DivisionID = AT9000.DivisionID	
INNER JOIN	AT1202 on AT1202.ObjectID  = AT9000.ObjectID AND AT1202.DivisionID = AT9000.DivisionID
GROUP BY	AT9000.DueDate, AT9000.ObjectID , AT9000.BatchID, 
			AT9000.DebitAccountID, AT9000.DivisionID
HAVING		SUM(AT9000.OriginalAmountCN)- sum (isnull(GT.OriginalAmount,0) )<>0 '

END
--PRINT(@sSQL)
--PRINT(@sSQL1)
IF NOT EXISTS (SELECT NAME FROM SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0394]') AND OBJECTPROPERTY(ID, N'ISVIEW') = 1)
	EXEC ('  CREATE VIEW AV0394 	--CREATED BY AP0393
		AS ' + @sSQL +@sSQL1)
ELSE
	EXEC ('  ALTER VIEW AV0394  	--CREATED BY AP0393
		AS ' + @sSQL +@sSQL1)


If @IsGroup = 0
	Begin
	Update AT0393 set 	OldCol00=Amount00,OldCol01=Amount01,OldCol02=Amount02,OldCol03=Amount03,
				OldCol04=Amount04,OldCol05=Amount05,OldCol06=Amount06,
				OldColCon00=ConAmount00,OldColCon01=ConAmount01,OldColCon02= ConAmount02,OldColCon03=ConAmount03,
				OldColCon04=ConAmount04,OldColCon05=ConAmount05,OldColCon06=ConAmount06
		
	FROM	AT0393 
	INNER JOIN (Select	ObjectID,  SUM(Amount00) AS Amount00, SUM(Amount01) AS Amount01, SUM(Amount02) AS Amount02,
						SUM(Amount03) AS Amount03, SUM(Amount04) AS Amount04, SUM(Amount05) AS Amount05, SUM(Amount06) AS Amount06,
						SUM(ConAmount00) AS ConAmount00, SUM(ConAmount01) AS ConAmount01, SUM(ConAmount02) AS ConAmount02,
						SUM(ConAmount03) AS ConAmount03, SUM(ConAmount04) AS ConAmount04, SUM(ConAmount05) AS ConAmount05, SUM(ConAmount06) AS ConAmount06,
						DivisionID	
				FROM	AV0394
				GROUP BY ObjectID, DivisionID 
				) AS S
			on 	S.ObjectID = AT0393.ObjectID and
			    S.DivisionID = AT0393.DivisionID
	WHERE AT0393.DivisionID = @DivisionID
	End

If @IsGroup = 1
	Begin
	Update AT0393 set 	OldCol00=Amount00,OldCol01=Amount01,OldCol02=Amount02,OldCol03=Amount03,
				OldCol04=Amount04,OldCol05=Amount05,OldCol06=Amount06,
				OldColCon00=ConAmount00,OldColCon01=ConAmount01,OldColCon02= ConAmount02,OldColCon03=ConAmount03,
				OldColCon04=ConAmount04,OldColCon05=ConAmount05,OldColCon06=ConAmount06
		
	From AT0393 
	INNER JOIN (Select ObjectID, GroupID,  SUM(Amount00) AS Amount00, SUM(Amount01) AS Amount01, SUM(Amount02) AS Amount02,
						SUM(Amount03) AS Amount03, SUM(Amount04) AS Amount04, SUM(Amount05) AS Amount05, SUM(Amount06) AS Amount06,
						SUM(ConAmount00) AS ConAmount00, SUM(ConAmount01) AS ConAmount01, SUM(ConAmount02) AS ConAmount02,
						SUM(ConAmount03) AS ConAmount03, SUM(ConAmount04) AS ConAmount04, SUM(ConAmount05) AS ConAmount05, SUM(ConAmount06) AS ConAmount06,
						DivisionID
				From	AV0394
				Group by ObjectID, GroupID, DivisionID) AS S
			on 	S.ObjectID = AT0393.ObjectID and 
				Isnull (S.GroupID,'') = isnull (AT0393.GroupID,'')
				and S.DivisionID = AT0393.DivisionID
	Where	AT0393.DivisionID = @DivisionID
	End

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

