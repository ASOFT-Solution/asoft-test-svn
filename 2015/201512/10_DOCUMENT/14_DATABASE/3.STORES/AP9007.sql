/****** Object:  StoredProcedure [dbo].[AP9007]    Script Date: 07/29/2010 14:03:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Van Nhan.
-----   Created Date 29.06.2004
---- Purpose Loc du lieu cho len bao cao tinh hinh thuc hien

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP9007]
	 @DivisionID as nvarchar(50), 
	 @FromMonth as int, 
	 @FromYear as int, 
	 @ToMonth int, 
	 @ToYear as int


 AS

Declare @sSQL as nvarchar(4000)


Set @sSQL =N'
Select 	AV4444.DivisionID,
	AV4444.AccountID, 
	AT1005.AccountName,
	Ana01ID , 	
	AnaName,
	Sum(Case when D_C = ''D'' then ConvertedAmount else 0 End) as DebitAmount ,
	Sum(Case when D_C = ''C'' then ConvertedAmount else 0 End) as CreditAmount
 
From AV4444 	inner join AT1005 on 	AT1005.AccountID = AV4444.AccountID and AT1005.DivisionID = AV4444.DivisionID 
				
		inner join AT1011 on 	AT1011.AnaID = AV4444.Ana01ID and AT1011.DivisionID = AV4444.DivisionID and
					AT1011.AnaTypeID =''A01''
Where ( TranMonth  + 100*TranYear between '+str(@FromMonth)+' + 100*'+str(@FromYear)+' and '+str(@ToMonth)+'  + 100*'+str(@ToYear)+' ) 
	and AV4444.DivisionID = '''+@DivisionID+''' 
Group by AV4444.DivisionID,AV4444.AccountID, Ana01ID, AT1005.AccountName, AnaName '


--PRINT @sSQL

IF NOT EXISTS (SELECT 1 FROM SYSOBJECTS WHERE SYSOBJECTS.NAME = 'AV9007' AND SYSOBJECTS.XTYPE = 'V')
	EXEC ('CREATE VIEW AV9007 AS ' + @sSQL)
ELSE
	EXEC ('ALTER VIEW AV9007  AS ' + @sSQL)