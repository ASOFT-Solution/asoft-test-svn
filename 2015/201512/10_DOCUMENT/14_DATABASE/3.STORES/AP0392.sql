/****** Object:  StoredProcedure [dbo].[AP0392]    Script Date: 07/29/2010 10:03:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---- Created by Van Nhan, Date 19/06/2009
----- purpose: Phat sinh cong no, duoc goi tu AP0393
-----Edit: Thuy Tuyen, date:  09/09/2008
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/

ALTER PROCEDURE [dbo].[AP0392] 	@DivisionID as nvarchar(50),
					@ReportDate as Datetime,
					@FromAccountID as nvarchar(50),
					@ToAccountID as nvarchar(50),
					@FromObjectID as nvarchar(50),
					@ToObjectID as nvarchar(50),
					@CurrencyID as nvarchar(50),
					@IsGroup as tinyint,
					@GroupID as nvarchar(50)
					
 AS
Declare @sSQL as nvarchar(4000),
	@Month as int,
	@Year as int,
	@Period01 as int,
	@GroupIDField as nvarchar(50)
Set nocount off
--Delete AT0393
set @Month = month(@ReportDate)
set @Year = year(@ReportDate)

------- Phat sinh -----------------------------

If @IsGroup = 1

Begin
set @GroupIDField =  (Select Case @GroupID when  'A01'  then 'Ana01ID'
					   when 'O01' then 'O01ID'   when 'O02' then 'O02ID'   when 'O03' then 'O03ID'   when 'O04' then 'O04ID' 
					   when 'O05' then 'O05ID'   End)
set @sSQL='

Select 	DivisionID, ObjectID, '+@GroupIDField+'  as  GroupID , 
	sum(Case when D_C =''D'' then OriginalAmountCN else 0 end) as DebitAmount,
	sum(Case when D_C =''D'' then ConvertedAmount else 0 end) as DebitConAmount,
	sum(Case when D_C =''C'' then OriginalAmountCN else 0 end ) as CreditAmount,
	sum(Case when D_C =''C'' then ConvertedAmount  else 0 end ) as CreditConAmount
From AV4301
Where 	AccountID between '''+@FromAccountID+''' and '''+@ToAccountID+''' and
	(ObjectID between '''+@FromObjectID+''' and '''+@ToObjectID+''' )  and
	TranMonth + 100*TranYear = '+str(@Month)+' + 100*'+str(@Year)+' 	 
	and AV4301.CurrencyIDCN like '''+@CurrencyID+'''
Group by  DivisionID, ObjectID,  '+@GroupIDField+'  '

end

Else
If @IsGroup = 0
Begin
set @sSQL='

Select 	DivisionID, ObjectID, '''' GroupID ,
	sum(Case when D_C =''D'' then OriginalAmountCN else 0 end) as DebitAmount,
	sum(Case when D_C =''D'' then ConvertedAmount else 0 end) as DebitConAmount,
	sum(Case when D_C =''C'' then OriginalAmountCN else 0 end ) as CreditAmount,
	sum(Case when D_C =''C'' then ConvertedAmount  else 0 end ) as CreditConAmount
From AV4301
Where 	AccountID between '''+@FromAccountID+''' and '''+@ToAccountID+''' and
	(ObjectID between '''+@FromObjectID+''' and '''+@ToObjectID+''' )  and
	TranMonth + 100*TranYear = '+str(@Month)+' + 100*'+str(@Year)+' 	
	and Av4301.CurrencyIDCN like '''+@CurrencyID+''' 
Group by  DivisionID, ObjectID'

End
print @sSQL	
If not exists (Select name from sysobjects Where id = Object_id(N'[dbo].[AV0392]') and OBJECTPROPERTY(id, N'IsView') = 1)
     		Exec ('  Create View AV0392 	--created by AP0393
				as ' + @sSQL)
	Else
		Exec ('  Alter View AV0392  	--created by AP0393
		as ' + @sSQL)


if @IsGroup = 0
	Begin
	Update AT0393
		Set	 DebitAmount = AV0392.DebitAmount,
			CreditAmount = AV0392.CreditAmount,
			 DebitConAmount = AV0392.DebitConAmount,
			CreditConAmount = AV0392.CreditConAmount
	From AT0393 inner join AV0392 on  AV0392.ObjectID = AT0393.ObjectID and AV0392.DivisionID = AT0393.DivisionID 
						
	
	Insert AT0393 (DivisionID, ObjectID,  DebitAmount, CreditAmount,  DebitConAmount, CreditConAmount)
	Select DivisionID, ObjectID ,  sum(DebitAmount), sum(CreditAmount),  sum(DebitConAmount), sum(CreditConAmount)
	From AV0392
	Where isnull(ObjectID,'') not in (Select isnull(ObjectID,'')  From AT0393)
	Group by DivisionID, ObjectID
	End
 

If @IsGroup = 1 

	Begin
	Update AT0393
		Set	 DebitAmount = AV0392.DebitAmount,
			CreditAmount = AV0392.CreditAmount,
			 DebitConAmount = AV0392.DebitConAmount,
			CreditConAmount = AV0392.CreditConAmount
	From AT0393 inner join AV0392 on  AV0392.ObjectID = AT0393.ObjectID and AV0392.DivisionID = AT0393.DivisionID and
						isnull (AV0392.GroupID,'') = Isnull (AT0393.GroupID,'')
	
	
	Insert AT0393 (DivisionID, ObjectID, GroupID,  DebitAmount, CreditAmount, DebitConAmount, CreditConAmount)
	Select DivisionID, ObjectID, GroupID,  sum(DebitAmount), sum(CreditAmount), sum( DebitConAmount), sum(CreditConAmount)
	From AV0392
	Where isnull(ObjectID,'')+isnull(GroupID,'') not in (Select isnull(ObjectID,'')+isnull(GroupID,'') From AT0393)
	Group by DivisionID, ObjectID, GroupID
	End