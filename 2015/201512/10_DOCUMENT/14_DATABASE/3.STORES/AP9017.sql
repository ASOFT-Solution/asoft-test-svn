/****** Object:  StoredProcedure [dbo].[AP9017]    Script Date: 07/29/2010 14:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


------- 	Created by Nguyen Van Nhan.
------ 	Created Date 02/07/2004
------	Purpose: In chi tiet but  toan theo ma phan tich

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP9017] 
	@DivisionID nvarchar(50), 
	@FromMonth as int, 
	@FromYear as int, 
	@ToMonth as int, 
	@ToYear as int,
	@Ana01ID as nvarchar(50), 
	@AccountID as nvarchar(50),
	@D_C as nvarchar(1)	
AS

Declare @sSQL as nvarchar(4000)


Set @sSQL =N'
Select   DivisionID, VoucherID, TransactionID,
	Ana01ID,
	VoucherTypeID, VoucherNo,VoucherDate, Serial,InvoiceNo, InVoiceDate,
	CurrencyID, ExchangeRate, Description, 
	(Case When D_C =''D'' then AccountID else CorAccountID End) as DebitAccountID,
	(Case When D_C =''C'' then AccountID else CorAccountID End) as CreditAccountID,
	OriginalAmount,
	ConvertedAmount
	
 From AV4444
Where AccountID like '''+@AccountID+''' and Ana01ID like '''+@Ana01ID+'''  and
	DivisionID ='''+@DivisionID+''' and
	AccountID in (Select AccountID From AT1005 Where GroupID in (''G06'', ''G07'')  ) and 
	TranMonth + 100*TranYear Between '+str(@FromMOnth)+' + 100*'+str(@FromYear)+' and  '+str(@ToMonth)+' +  100*'+str(@ToYear)+' 


'


--Print @sSQL
IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV9017' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV9017 AS ' + @sSQL)
ELSE
	EXEC (' ALTER VIEW AV9017  AS ' + @sSQL)














