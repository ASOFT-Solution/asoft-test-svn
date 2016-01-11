/****** Object:  StoredProcedure [dbo].[AP9002]    Script Date: 07/29/2010 13:38:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



------  	Created 	By Nguyen Van Nhan, Date 04/06/2004
----- 	Purpose:	Tinh so phat sinh No, co cua cac  tai khoan phuc vu cho viec phan bo
-----	Edit by: Nguyen Quoc Huy, Date 16/06/2004



/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/


ALTER PROCEDURE  [dbo].[AP9002]
			@DivisionID as nvarchar(50),
			@FromMonth as int,
			@FromYear as int,
			@ToMonth as int,
			@ToYear as int,
			@GroupID as nvarchar(50)		
 AS

Declare @sSQL as nvarchar(4000)

Set @sSQL =N'
Select 	AV9001.AccountID ,
	AT1005.DivisionID,
	AT1005.AccountName,
	AV9001.CorAccountID,
	AT05.AccountName as CorAccountName,
	Ana02ID,
	Ana03ID,
	Sum(Case when D_C =''D'' then ConvertedAmount Else  0 End) as DebitAmount,
	Sum(Case when D_C =''C'' then ConvertedAmount Else 0 End) as CreditAmount
FROM AV9001 left join AT1005 on AT1005.AccountID = AV9001.AccountID and AT1005.DivisionID = AV9001.DivisionID
		left join AT1005 AT05 on AT05.AccountID = AV9001.CorAccountID and AT05.DivisionID = AV9001.DivisionID
WHERE AV9001.GroupID ='''+@GroupID+''' and
	AV9001.DivisionID ='''+@DivisionID+''' and
	AV9001.TableID <>''AV9001'' and
	AV9001.TranMonth + AV9001.TranYear*100 Between '+str(@FromMonth)+' + 100*'+str(@FromYear)+' and '+str(@ToMonth)+' + 100*'+str(@ToYear)+' 
Group by AT1005.DivisionID,AV9001.AccountID, AT1005.AccountName, CorAccountID,AT05.AccountName , Ana02ID, Ana03ID  '



IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV9002' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV9002 AS ' + @sSQL)
ELSE
	EXEC ('ALTER VIEW AV9002 AS ' + @sSQL)