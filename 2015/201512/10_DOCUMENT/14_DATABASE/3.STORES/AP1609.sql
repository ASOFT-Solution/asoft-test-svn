/****** Object:  StoredProcedure [dbo].[AP1609]    Script Date: 07/28/2010 15:08:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1609]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1609]
GO

/****** Object:  StoredProcedure [dbo].[AP1609]    Script Date: 07/28/2010 15:08:09 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


----- Created by Van Nhan, Date 24/04/207.
----- Purpose: In Danh sach cong cu dung cu
----- Last edit by Thuy Tuyen, Date 09/05/2007, 11/08/2008
----- Last edit by Bao Anh	Date: 08/07/2012	Where them dieu kien VoucherID
----- Modified by Khanh Van on 22/10/2013: lay them 10 truong parameter
/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

CREATE PROCEDURE  [dbo].[AP1609]  	@DivisionID as nvarchar(50),
					@FromMonth as int,
					@FromYear as int,
					@ToMonth as int,
					@ToYear as int,
					@GroupType as tinyint,		--- 	0 la khong nhom
									---- 	1 theo tai khoan chi phi tra truoc
									----	2 theo tai khoan chi phi phan bo									
					@IsUsed as tinyint,
					@IsFail tinyint
					
 AS
Declare @sSQL as nvarchar(4000),
	@sSQL1 as nvarchar(4000),
	@GroupID as nvarchar(200),

	  @FromPeriod as int,
	  @ToPeriod as int



	set  @FromPeriod =@FromMonth+@FromYear*100
	set @ToPeriod=@ToMonth+@ToYear*100


Set @GroupID = ''
If @GroupType = 0 
	Set @GroupID =''''' as GroupID,  ''''  as GroupName, '
If @GroupType = 1 	
	Set @GroupID =' AT1603.CreditAccountID as GroupID,  A.AccountName  as GroupName, '
If @GroupType = 2 
	Set @GroupID =' AT1603.DebitAccountID as GroupID, B.AccountName   as GroupName,  '


Set @sSQL='

Select Distinct	ToolID, 
	'+@GroupID+'
	ToolName, 
	SerialNo, AT1603.ActualQuantity, 
	CreditAccountID AS AccountID, 
	DebitAccountID, 
	
	MethodID, 
	---Periods, ApportionRate, 

	(Case when exists (Select top 1 ToolID From AT1606 Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
					 and AT1606.TranMonth + 100*AT1606.TranYear <='+str(@ToPeriod )+')
					Then  
						(select top 1 AT1606.DepNewPercent  From AT1606 
						Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
						and AT1606.TranMonth + 100*AT1606.TranYear <= '+str(@ToPeriod )+'  Order by AT1606.TranYear Desc,AT1606.TranMonth Desc )
					Else AT1603.ApportionRate end)	as ApportionRate, 
			
			(Case when exists (Select top 1 ToolID From AT1606 Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
					 and AT1606.TranMonth + 100*AT1606.TranYear <='+str(@ToPeriod )+')
					Then  
						(select top 1 AT1606.DepNewPeriods  From AT1606 
						Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
						and AT1606.TranMonth + 100*AT1606.TranYear <= '+str(@ToPeriod )+'  Order by AT1606.TranYear Desc,AT1606.TranMonth Desc )
					Else AT1603.Periods end)	as Periods, 

	--ConvertedAmount,
	(Case when exists (select top 1 ToolID from AT1606 Where ToolID = AT1603.ToolID and ReVoucherID = AT1603.VoucherID and DivisionID = AT1603.DivisionID
							and AT1606.TranMonth + 100*AT1606.TranYear <='+str(@ToPeriod )+')
			Then (select top 1 AT1606.ConvertedNewAmount  From AT1606 
						Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
							and AT1606.TranMonth + 100*AT1606.TranYear <='+str(@ToPeriod )+'
					Order by AT1606.TranYear Desc,AT1606.TranMonth Desc )
		Else AT1603.ConvertedAmount end) as ConvertedAmount, 

	AT1603.DivisionID,
	isnull((Select Sum(DepAmount) From AT1604 Where TranMonth + TranYear*100 <='+str(@ToMonth)+'+'+str(@ToYear)+'*100  and
						 DivisionID like '''+@DivisionID+''' and
						ToolID = AT1603.ToolID and ReVoucherID = AT1603.VoucherID),0) as AcrueDeAmount,
	isnull((Select Distinct count(TranMonth+TranYear*100) From AT1604 Where TranMonth + TranYear*100 <='+str(@ToMonth)+'+'+str(@ToYear)+'*100   and
						 DivisionID like '''+@DivisionID+'''  and
						ToolID = AT1603.ToolID and ReVoucherID = AT1603.VoucherID),0) as DepPeriods,
	BeginMonth, 
	BeginYear, 
	Description,'
Set @sSQL1='
	AT1603.Ana01ID, T01.AnaName as AnaName01,
	AT1603.Ana02ID, T02.AnaName as AnaName02,
	AT1603.Ana03ID, T03.AnaName as AnaName03,
	AT1603.Ana04ID, T04.AnaName as AnaName04, 
	AT1603.Ana05ID, T05.AnaName as AnaName05,
	AT1603.Parameter01,
	AT1603.Parameter02,
	AT1603.Parameter03,
	AT1603.Parameter04,
	AT1603.Parameter05,
	AT1603.Parameter06,
	AT1603.Parameter07,
	AT1603.Parameter08,
	AT1603.Parameter09,
	AT1603.Parameter10,
	AT1603.ObjectID, AT1202.ObjectName,	AT1603.VoucherNo

 From AT1603	 Left join AT1005 A on A.AccountID =AT1603.CreditAccountID and A.DivisionID =AT1603.DivisionID
		 Left join AT1005 B on B.AccountID =AT1603.DebitAccountID and B.DivisionID =AT1603.DivisionID
		 Left join AT1202 on AT1202.ObjectID =AT1603.ObjectID and AT1202.DivisionID =AT1603.DivisionID
		 Left join AT1011 T01 on T01.AnaID = AT1603.Ana01ID and T01.DivisionID = AT1603.DivisionID And T01.AnaTypeID = ''A01''	 	
		 Left join AT1011 T02 on T02.AnaID = AT1603.Ana02ID and T02.DivisionID = AT1603.DivisionID And T02.AnaTypeID = ''A02''	 	
		 Left join AT1011 T03 on T03.AnaID = AT1603.Ana03ID and T03.DivisionID = AT1603.DivisionID And T03.AnaTypeID = ''A03''	 	
		 Left join AT1011 T04 on T04.AnaID = AT1603.Ana04ID and T04.DivisionID = AT1603.DivisionID And T04.AnaTypeID = ''A04''	 	
		 Left join AT1011 T05 on T05.AnaID = AT1603.Ana05ID and T05.DivisionID = AT1603.DivisionID And T05.AnaTypeID = ''A05''	 	

 Where BeginMonth + BeginYear*100<= '+str(@ToMonth)+'+'+str(@ToYear)+'*100 and AT1603.DivisionID like '''+@DivisionID+'''
		  '
if   @IsFail = 1 and  @IsUsed = 1
	Set @sSQL1 = @sSQL1
if    @IsFail = 0  and  @IsUsed =1  
	Set @sSQL1 = @sSQL1 +'and (AT1603.ToolID  not in (Select ToolID From AT1602) ) '
if    @IsFail =1 and  @IsUsed =0 
	Set @sSQL1 = @sSQL1 +'and (AT1603.ToolID   in (Select ToolID From AT1602) ) '
Print @SSQL
If  Exists (Select 1 From sysObjects Where Name ='AV1609')
	DROP VIEW AV1609
Exec ('Create view AV1609  --Tao boi AP1609
	as '+@sSQL +@sSQL1)
GO

