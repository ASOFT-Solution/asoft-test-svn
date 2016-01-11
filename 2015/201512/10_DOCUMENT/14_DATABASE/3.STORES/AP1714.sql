/****** Object:  StoredProcedure [dbo].[AP1714]    Script Date: 07/28/2010 15:46:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1714]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1714]
GO

/****** Object:  StoredProcedure [dbo].[AP1714]    Script Date: 07/28/2010 15:46:36 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

---Created by: Nguyen Thi Thuy Tuyen	
---Purpose: Phuc vu bao cao phan bo
---Date: 7/09/2007
--Last Edit Thuy Tuyen 13/11/2007
---Edit by: Dang Le Bao Quynh; Date: 08/08/09	
---Purpose: Them truong DepMonths , sua lai cong thuc AccuDepAmount 
--- Modify on 10/06/2015 by Bảo Anh: Bỏ các tham số thời gian theo quý và năm
/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/

CREATE PROCEDURE [dbo].[AP1714]  @DivisionID nvarchar(50),
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,
				@GroupType as tinyint	,	--- 	0 la khong nhom
								---- 	1 theo tai khoan chi phi  phan bo
								----	2 theo tai khoan chi phi tra truoc
								
				@D_C as nvarchar(50)     --C: Doanh thu, D: Chi phi 
				---@Condition  tinyint,
			---	@IsFail tinyint 
				
 AS

Declare 
	  @FromPeriod as int,
	  @ToPeriod as int,
	  @sSQL as nvarchar(4000),
	  @GroupID as nvarchar(250)

set  @FromPeriod =@FromMonth+@FromYear*100
set @ToPeriod=@ToMonth+@ToYear*100

Set @GroupID = ''
 IF @D_C = 'C'
	BEGIN
		If @GroupType = 0 
			Set @GroupID =''''' as GroupID,  ''''  as GroupName '
		If @GroupType = 1 	
			Set @GroupID =' AT1703.CreditAccountID as GroupID,  T05.AccountName  as GroupName '
		If @GroupType = 2 
			Set @GroupID =' AT1703.DebitAccountID as GroupID, AT1005.AccountName   as GroupName  '
	END
ELSE

	BEGIN
		If @GroupType = 0 
			Set @GroupID =''''' as GroupID,  ''''  as GroupName '
		If @GroupType = 1 	
			Set @GroupID =' AT1703.DebitAccountID as GroupID,  AT1005.AccountName  as GroupName '
		If @GroupType = 2 
			Set @GroupID =' AT1703.CreditAccountID as GroupID, T05.AccountName   as GroupName  '
	END
 
			

Set @sSQL='	
SELECT  	AT1703.DivisionID,
			AT1703.JobID,
        	AT1703.JobName, 
		AT1703.SerialNo,
		AT1703.CreditAccountID,
		AT1703.DebitAccountID,
		AT1703.Ana01ID,
		AT1011.AnaName as AnaName01ID,
		AT1703.Ana02ID,
		AT1703.Ana03ID,
		AT1703.ObjectID,
		AT1202.ObjectName,
		AT1703.ConvertedAmount,
		AT1703.Periods,
		AT1703.DepMonths,
		AT1703.UseStatus,	
		AT1703.Description,	
		AT1703.VoucherNo,
		AT1703.VoucherID,
		AT1703.BeginMonth,
		AT1703.BeginYear,		
		Case When IsNull(AT1703.Periods,0)=0 then 0 
		Else 
		AT1703.ConvertedAmount/AT1703.Periods
		End as DepreciatedPeriods,
		AccuDepAmount = ISNULL(AT1703.DepValue,0) + isnull((Select sum (isnull(DepAmount,0)) from AT1704  
				     Where AT1704.DivisionID like '''+@DivisionID+'''  and 
				     AT1703.JobID = AT1704.JobID and
	   			     AT1704.TranMonth+AT1704.Tranyear*100<= '+cast(@ToPeriod as varchar(10))+' 
				 and  AT1703.D_C =  '''+@D_C+ '''),0),
		DepAmount =(Select sum (DepAmount) from AT1704
				     Where AT1704.DivisionID like '''+@DivisionID+'''  and 
				     AT1703.JobID=AT1704.JobID and
				     AT1704.TranMonth+ AT1704.Tranyear*100 between  '+cast(@FromPeriod as varchar(10))+'   and '+cast(@ToPeriod as varchar(10))+' 
					 and  AT1703.D_C =  '''+@D_C+ ''' ),

		DepreciatedMonths= (select count(*) from (select distinct JobID, TranMonth, TranYear from AT1704
				Where AT1704.TranMonth + AT1704.TranYear*100 <= '+cast(@ToPeriod as varchar(10))+'  and                 
					isnull(AT1704.DepAmount, 0) >1  and  AT1703.D_C =  '''+@D_C+ ''' 
		) A where A.JobID = AT1703.JobID), '+ @GroupID +'
	
From 	AT1703 
		Inner join AT1005 on AT1005.AccountID =  AT1703.DebitAccountID and AT1005.DivisionID =  AT1703.DivisionID
		Inner join AT1005  T05 on  T05.AccountID =  AT1703.CreditAccountID and T05.DivisionID =  AT1703.DivisionID
		left join AT1102 on 	AT1102.DepartmentID = AT1703.Ana02ID and
					AT1102.DivisionID = AT1703.DivisionID
		left Join AT1011 on AT1011.AnaID = AT1703.Ana01ID and AT1011.DivisionID = AT1703.DivisionID
		lEFT JOIN AT1202 on AT1202.ObjectID = AT1703.ObjectID and AT1202.DivisionID = AT1703.DivisionID
Where 	AT1703.DivisionID like  '''+@DivisionID+'''  and 	
 	AT1703.BeginMonth+AT1703.BeginYear*100    <='+cast(@ToPeriod as varchar(10))+'
 and  AT1703.D_C =  '''+@D_C+ '''



'

/*if   @IsFail = 1 and  @Condition = 1
	Set @SSQL = @sSQL 
if    @IsFail = 0  and  @Condition =1  
	Set @SSQL = @sSQL  +'and (AT1603.ToolID  not in (Select ToolID From AT1602) ) '
if    @IsFail =1 and  @Condition =0 
	Set @SSQL = @sSQL  +'and (AT1603.ToolID   in (Select ToolID From AT1602) ) '
*/


---Print @sSQL
If  Exists (Select 1 From sysObjects Where Name ='AV1714')
	DROP VIEW AV1714
Exec ('Create view AV1714  --Tao boi AP1714

			as '+@sSQL)