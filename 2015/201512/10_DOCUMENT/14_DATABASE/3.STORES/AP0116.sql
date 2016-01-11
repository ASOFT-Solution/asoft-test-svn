SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---- Created by Van Nhan.
--- Created Date 17/03/2006
---- Purpose: Chi tiet, tong hop Thanh toan, lam co so de tinh  Lai Phat.
---- Modified on 06/03/2013 by Khanh Van: Bo sung tu tai khoan den tai khoan cho Sieu Thanh

/********************************************
'* Edited by: [GS] [Tố Oanh] [28/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP0116] 
		@DivisionID AS nvarchar(50), 
		@FromMonth AS int, 
		@FromYear AS int,
		@ToMonth AS int, 
		@ToYear AS int,
		@FromDate AS Datetime, 
		@ToDate AS Datetime,
		@IsDate AS tinyint,								
		@IsGroup AS tinyint,
		@GroupTypeID AS nvarchar(50),
		@FromObjectID AS nvarchar(50),
		@ToObjectID AS nvarchar(50),
		@FromAccountID AS nvarchar(50),
		@ToAccountID AS nvarchar(50)

AS
						
Declare @sSQL AS nvarchar(max)
Declare @LevelColumn AS nvarchar(50)

If @IsGroup<>0 
Exec AP4700 @GroupTypeID , @LevelColumn  OUTPUT

If @IsDate =0  --- Theo ky
set @sSQL='
SELECT 	AT0303.ObjectID, O01ID, O02ID,O03ID,O04ID, O05ID,
		AV0301.OriginalAmount AS DebitAmount, 
		AT0303.OriginalAmount AS GiveUpAmount, AV0301.DueDate , AV0302.VoucherDate,
		DATEDiff(day,AV0301.DueDate, AV0302.VoucherDate) AS Days,
		AV0301.VoucherNo AS DebitVoucherNo,
		AV0302.VoucherNo AS CreditVoucherNo,
		AV0302.voucherTypeID  AS CreditVoucherTypeID,
		AT0303.DivisionID	
FROM AT0303 	
inner join AT1202 on 	AT1202.ObjectID = AT0303.ObjectID and AT1202.DivisionID = AT0303.DivisionID
inner join AV0301 on 	AV0301.ObjectID = AT0303.ObjectID and
			AV0301.DebitAccountID = AT0303.AccountID and
			AV0301.VoucherID = At0303.DebitVoucherID and
			AV0301.TableID = AT0303.DebitTableID and 
			AV0301.DivisionID = AT0303.DivisionID
inner join AV0302 on 	AV0302.ObjectID = AT0303.ObjectID and
			AV0302.CreditAccountID = AT0303.AccountID and
			AV0302.VoucherID = At0303.CreditVoucherID and
			AV0302.TableID = AT0303.CreditTableID and 
			AV0302.DivisionID = AT0303.DivisionID
		
Where 	(AT0303.ObjectID between '''+@FromObjectID+''' and '''+@ToObjectID+''' ) and
	(AV0302.TranMonth + AV0302.TranYear*100 between '+str(@FromMonth)+' + 100*'+str(@FromYear)+' and '+str(@ToMonth)+' +100*'+str(@ToYear)+') and
	AT0303.AccountID between '''+@FromAccountID+''' and '''+@ToAccountID+''' ' 
Else   --- Theo ngay
set @sSQL='
Select 	AT0303.ObjectID, O01ID, O02ID,O03ID,O04ID, O05ID,
		AV0301.OriginalAmount AS DebitAmount, 
		AT0303.OriginalAmount AS GiveUpAmount, AV0301.DueDate , AV0302.VoucherDate,
		DATEDiff(day,AV0301.DueDate, AV0302.VoucherDate) AS Days,
		AV0301.VoucherNo AS DebitVoucherNo,
		AV0302.VoucherNo AS CreditVoucherNo,
		AV0302.voucherTypeID  AS CreditVoucherTypeID,
		AT0303.DivisionID
from AT0303 	
inner join AT1202 on 	AT1202.ObjectID = AT0303.ObjectID and AT1202.DivisionID = AT0303.DivisionID
inner join AV0301 on 	AV0301.ObjectID = AT0303.ObjectID and
			AV0301.DebitAccountID = AT0303.AccountID and
			AV0301.VoucherID = At0303.DebitVoucherID and
			AV0301.TableID = AT0303.DebitTableID and 
			AV0301.DivisionID = AT0303.DivisionID
inner join AV0302 on 	AV0302.ObjectID = AT0303.ObjectID and
			AV0302.CreditAccountID = AT0303.AccountID and
			AV0302.VoucherID = At0303.CreditVoucherID and
			AV0302.TableID = AT0303.CreditTableID and 
			AV0302.DivisionID = AT0303.DivisionID
		
Where 	(AT0303.ObjectID between '''+@FromObjectID+''' and '''+@ToObjectID+''' ) and
		(CONVERT(DATETIME,CONVERT(VARCHAR(10),AV0302.VoucherDate,101),101)  Between '''+convert(nvarchar(10), @FromDate,21)+'''  and '''+convert(nvarchar(10), @ToDate, 21)+''') and
		AT0303.AccountID between '''+@FromAccountID+''' and '''+@ToAccountID+''' ' 

IF NOT EXISTS (SELECT 1 FROM  SYSOBJECTS WHERE XTYPE ='V' AND NAME ='AV0115')
	EXEC(' CREATE VIEW AV0115 AS '+ @sSQL )
ELSE
	EXEC(' ALTER VIEW AV0115 AS '+@sSQL)


--- Buoc 4: Gop lai chi tiet va tong hop ------------------------------------------------------------------------------
If @IsGroup =1
Set @sSQL= '
Select 	AV0115.ObjectID,  AV0115.O01ID, AV0115.O02ID,AV0115.O03ID,AV0115.O04ID, AV0115.O05ID,
	AV0115.'+@LevelColumn+' AS GroupID,
	AV6666.SelectionName AS GroupName,	
	At1202.ObjectName,
	At1202.Address,
	Sum (Case when Days>0 then GiveUpAmount else 0 end ) AS AfterAmount,
	Sum (Case when Days>0 then 0 else GiveUpAmount end ) AS BeforeAmount,
	Sum (Case when Days<0 and  AV0115.CreditVoucherTypeID like ''HL'' then GiveUpAmount else 0  end ) AS OthersAmount,
	(Case when Days>0 then Days else 0 end )  DelayDays, AV0115.DivisionID

From AV0115  	
inner join AT1202 on AT1202.ObjectID = AV0115.ObjectID and AT1202.DivisionID = AV0115.DivisionID
left join AV6666 on AV6666.DivisionID = AV0115.DivisionID and AV6666.SelectionID =AV0115.'+@LevelColumn+' and
		    AV6666.SelectionType = '''+@GroupTypeID+''' 
Group by AV0115.ObjectID,  AV0115.O01ID, AV0115.O02ID,AV0115.O03ID,AV0115.O04ID, AV0115.O05ID, AV6666.SelectionName, At1202.ObjectName,At1202.Address,
	   (Case when Days>0 then Days else 0 end ), AV0115.DivisionID '
Else
Set @sSQL ='
Select 	AV0115.ObjectID,  AV0115.O01ID, AV0115.O02ID, AV0115.O03ID, AV0115.O04ID, AV0115.O05ID,
		'''' AS GroupID,
		'''' AS GroupName,	
		AT1202.ObjectName,
		AT1202.Address,
		Sum(Case when Days>0 then GiveUpAmount else 0 end ) AS AfterAmount,
		Sum(Case when Days>0 then 0 else GiveUpAmount end ) AS BeforeAmount,
		Sum (Case when Days<0 and  AV0115.CreditVoucherTypeID like ''HL'' then GiveUpAmount else 0 end ) AS OthersAmount,
		(Case when Days>0 then Days else 0 end )  DelayDays, AV0115.DivisionID	
From AV0115  	
inner join AT1202 on AT1202.ObjectID = AV0115.ObjectID and AT1202.DivisionID = AV0115.DivisionID
Group by AV0115.ObjectID,  AV0115.O01ID, AV0115.O02ID, AV0115.O03ID, AV0115.O04ID, AV0115.O05ID,  AT1202.ObjectName,
		AT1202.Address,
	   (Case when Days>0 then Days else 0 end ), AV0115.DivisionID '

--Print @sSQL
If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV0116')
	Exec(' Create view AV0116 AS '+ @sSQL )
Else
	Exec(' Alter view AV0116 AS '+@sSQL)
