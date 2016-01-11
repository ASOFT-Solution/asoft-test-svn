/****** Object:  StoredProcedure [dbo].[AP5211]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----Created by Nguyen Thi Ngoc Minh, Date 09/08/2004
-----Tra ra view so du thue gia tri gia tang
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[AP5211]
			@DivisionID as nvarchar(50),
			@FromMonth as int,
			@FromYear as int,
			@IsMonth as tinyint,
			@FromAccountID as nvarchar(50),
			@ToAccountID as nvarchar(50)

AS

Declare @sSQL as nvarchar(4000),
	@TmpFromMonth as int,
	@TmpToMonth as int

If @IsMonth = 0
   Begin
	Set @TmpFromMonth = 1
   End
else
   Begin
	Set @TmpFromMonth = @FromMonth
   End
Set @sSQL =N' 
Select	DivisionID, AccountID,
	Sum(isnull(ConvertedAmount,0)) as OpeningConvertedAmount,
	sum(isnull(OriginalAmount,0)) as OpeningOriginalAmount
From AV4202 
Where 	DivisionID = N''' + @DivisionID + N''' and
	(TranMonth+TranYear*100 < ' + 
	ltrim(str(@TmpFromMonth)) + ' + 100*' + ltrim(str(@FromYear))+' or 
	(TranMonth+TranYear*100 = ' + 
	ltrim(str(@TmpFromMonth)) + ' + 100*' + ltrim(str(@FromYear))+' and TransactionTypeID = N''T00'')) and
	AV4202.AccountID between N''' + @FromAccountID + N''' and N''' + @ToAccountID + '''
Group by DivisionID, AccountID
'
--print @sSQL

	If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV5211]') and OBJECTPROPERTY(id, N'IsView') = 1)
     		Exec ('  Create View AV5211 	--Created by AP5211
			as ' + @sSQL)
	Else
		Exec ('  Alter View AV5211  	--Created by AP5211
			as ' + @sSQL)
GO
