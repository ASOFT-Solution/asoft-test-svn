IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP03191]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP03191]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- <Summary>
---- Load luoi 1 man hinh AF0319
-- <Param>
---- 
-- <Return>
---- 
-- <Reference> T/but toan tong hop/Tap hop but toan hinh thanh TSCD
---- 
-- <History>
----- Created by Phuong Thao, Date 13/11/2015
---- Modify on 
-- <Example>
----  EXEC AP03191 'SC', 0, 1, 2015, 10, 2015, NULL, NULL, '%', '%', '%'

CREATE PROCEDURE [dbo].[AP03191] 
				@DivisionID AS nvarchar(50), 
				@IsDate AS Tinyint, -- 0: Ky, 1: Ngay
				@FromMonth AS Tinyint,  
				@FromYear  AS Int,  
				@ToMonth  AS Tinyint,  
				@ToYear AS Int,  
				@FromDate AS Datetime, 
				@ToDate AS Datetime,
				@ObjectID  AS nvarchar(50),  
				@FromTaskID AS nvarchar(50),
				@ToTaskID AS nvarchar(50)
				

AS

Declare @sSQL AS varchar(max),
		@TypeDate AS nvarchar(50),
		@FromPeriod AS int,
		@ToPeriod AS int,
		@SQLwhere AS nvarchar(4000)
	
Set @TypeDate ='VoucherDate'

Set @FromPeriod = (@FromMonth + @FromYear*100)	
Set @ToPeriod = (@ToMonth + @ToYear*100)	

IF @IsDate =0   ----- Truong hop tinh Tu ky den ky 
	Set @SQLwhere ='  AND   (AT9000.TranMonth+ AT9000.TranYear*100 Between '+str(@FromPeriod)+' and '+str(@ToPeriod)+')   '

Else
	Set @SQLwhere ='  AND (CONVERT(DATETIME,CONVERT(VARCHAR(10),AT9000.'+ltrim(Rtrim(@TypeDate))+',101),101) Between '''+convert(nvarchar(10),@FromDate,101)+''' and '''+convert(nvarchar(10),@ToDate,101)+''')  '

Set @sSQL='
SELECT 	AT9000.DivisionID,
		AT9000.ObjectID,
		AT1202.ObjectName,
		AT9000.VoucherDate, 
		AT9000.VoucherNo,
		AT9000.VoucherID,  AT9000.BatchID, AT9000.TransactionID,
		AT9000.Serial, AT9000.InvoiceNo, AT9000.InvoiceDate,
		AT9000.TDescription AS Description, 
		AT9000.CurrencyID, ExchangeRate, 
		AT9000.OriginalAmount, ConvertedAmount,
		AT9000.Ana01ID as TaskID, AT1011.AnaName as TaskName,
		AT9000.DebitAccountID,AT9000.CreditAccountID,Convert(BIT,0) IsChoose
FROM	AT9000 	
LEFT JOIN AT1202 on AT1202.ObjectID = AT9000.ObjectID  and AT1202.DivisionID = AT9000.DivisionID
LEFT JOIN AT1011 on AT9000. Ana01ID = AT1011.AnaID and AT9000.DivisionID = AT1011.DivisionID and AT1011.AnaTypeID = ''A01''
Where 	AT9000.DivisionID ='''+@DivisionID+'''
		AND ISNULL(AT9000.IsInheritFA,0) = 0
		AND ISNULL(AT9000.InheritedFAVoucherID,'''') = ''''
		AND (AT9000.DebitAccountID LIKE ''241%'' OR AT9000.CreditAccountID LIKE ''241%'')
		AND ISNULL(AT9000.Ana01ID,'''') <> '''' 
		AND (AT9000.Ana01ID BETWEEN '''+@FromTaskID+''' AND '''+@ToTaskID+''')
		AND ISNULL(AT9000.ObjectID,'''') LIKE '''+@ObjectID+'''
		' + @SQLwhere

--Print @sSQL
EXEC (@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

