IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP5210]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP5210]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

------- Created by Nguyen Thi Ngoc Minh, Date 09/08/2004.
------- In So theo doi thue GTGT (NKSC)
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'* Edited by: [GS] [Thien Huynh] [19/08/2011]

----- Modified by Thanh Thịnh on 23/09/2015: Lấy dữ liệu năm từ tháng bắt đầu niên độ TC
'********************************************/
-- Exec AP5210 'MP', 1, 2011, 1, 2011, 1, '352', '352'


CREATE PROCEDURE [dbo].[AP5210]
		@DivisionID as nvarchar(50),
		@FromMonth as int,
		@FromYear as int,
		@ToMonth as int,
		@ToYear as int,
		@IsMonth as tinyint,
		@FromAccountID as nvarchar(50),
		@ToAccountID as nvarchar(50)

AS

DECLARE 	@strSQL nvarchar(4000),
		@strWHERE nvarchar(4000)

If @IsMonth = 0
	Set @strWHERE = '
	and (TranMonth + TranYear*100 between ' + ltrim(str(@FromMonth+@FromYear*100)) + ' and ' + ltrim(str(@ToMonth+@ToYear*100)) + ')'
Else
	Set @strWHERE = '
	and (TranMonth + TranYear*100 between ' + ltrim(str(@FromMonth+@FromYear*100)) + ' and ' + ltrim(str(@ToMonth+@ToYear*100)) + ')'

Exec AP5211 @DivisionID, @FromMonth, @FromYear, @IsMonth, @FromAccountID, @ToAccountID

--Set @strSQL = N'
--Select AV5000.DivisionID, VoucherID, TransactionID, VoucherNo, VoucherDate, AV5000.CreateDate, 
--	isnull(TDescription, isnull(BDescription,VDescription)) as Description,
--	CorAccountID,
--	(Case when D_C = ''D'' then isnull(ConvertedAmount,0) else 0 end) as GivedConvertedAmount,
--	(Case when D_C = ''C'' then isnull(ConvertedAmount,0) else 0 end) as ToGivedConvertedAmount,
--	isnull(OpeningConvertedAmount,0) as OpeningConvertedAmount
    
--From AV5000 full join AV5211 on AV5211.AccountID = AV5000.AccountID
--Where AV5000.DivisionID = N''' + @DivisionID + ''' and
--	(AV5000.AccountID between N''' + @FromAccountID + N''' and N''' + @ToAccountID + N''') and
--	AV5000.TransactionTypeID not in (N''t00'', N''T34'') ' + @strWHERE 

Set @strSQL = 'Select * From AV5000 
				Where AV5000.DivisionID = N''' + @DivisionID + ''' and
				(AV5000.AccountID between N''' + @FromAccountID + N''' and N''' + @ToAccountID + N''') and
				AV5000.TransactionTypeID not in (N''t00'', N''T34'') ' + @strWHERE 
			
If not exists (Select top 1 1 From SysObjects Where name = 'AV5212' and Xtype ='V')
	Exec ('Create view AV5212 	--created by AP5210
	as '+@strSQL)
Else
	Exec ('Alter view AV5212  	--created by AP5210
	as '+@strSQL)


Set @strSQL = N'
Select 
	IsNull(AV5212.DivisionID, AV5211.DivisionID) As DivisionID,
	VoucherID, TransactionID, VoucherNo, VoucherDate, AV5212.CreateDate, 
	isnull(TDescription, isnull(BDescription,VDescription)) as Description,
	CorAccountID,
	(Case when D_C = ''D'' then isnull(ConvertedAmount,0) else 0 end) as GivedConvertedAmount,
	(Case when D_C = ''C'' then isnull(ConvertedAmount,0) else 0 end) as ToGivedConvertedAmount,
	isnull(OpeningConvertedAmount,0) as OpeningConvertedAmount
    
From AV5212 full join AV5211 on AV5211.AccountID = AV5212.AccountID '

--print @strSQL

If not exists (Select top 1 1 From SysObjects Where name = 'AV5210' and Xtype ='V')
	Exec ('Create view AV5210 	--created by AP5210
	as '+@strSQL)
Else
	Exec ('Alter view AV5210  	--created by AP5210
	as '+@strSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

