
/****** Object:  StoredProcedure [dbo].[MP0002]    Script Date: 07/29/2010 15:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
----Created  by: VO THANH HUONG, 21/04/2005
------- Purpose: In Bao cao tong hop phi Nguyen vat lieu truc tiep, CP nhan cong , CP SXC

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/


ALTER PROCEDURE [dbo].[MP0002] 
				@DivisionID nvarchar(50),
				@IsDate tinyint,
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,
				@FromDate datetime,
				@ToDate datetime,
				@PeriodID as nvarchar(50),				
				@Is621 as tinyint,
				@Is622 as tinyint,
				@Is627 as tinyint,
				@Type int	-- 0: Theo Doi tuong THCP, 1: theo DT THCP-Loai CP, 		
AS
Declare @sSQL1 as nvarchar(4000),
	@sSQL2 as nvarchar(4000),
	@sWhere nvarchar(4000)
 If 	(@Is621 = 1 or  @Is622 = 1 or @Is627 = 1) 
Begin
	Set @sWhere =  ' and ('  + 
		case when @Is621 = 1 then ' V00.ExpenseID = ''COST001'' or '  else '' end + 
		case when  @Is622 = 1  then ' V00.ExpenseID = ''COST002'' or ' else '' end + 
		case when  @Is627 = 1  then ' V00.ExpenseID = ''COST003'' or ' else '' end  
	Set @sWhere = left(@sWhere, len(@sWhere) -2) + ')'
End
Else 
	Set @sWhere  = ''
IF @Type = 1
BEGIN
Set @sSQL1 = 'Select   V00.DivisionID, V00.MaterialTypeID, T03.UserName as  MaterialTypeIDUserName, 
		 V00.DebitAccountID, V00.CreditAccountID,
		V00.PeriodID, T04.Description as PeriodName,  
		(sum(case when isnull(T05.AccountID, '''') <> '''' then ConvertedAmount else 0 end) - sum(case when isnull(T05.AccountID, '''') = '''' then ConvertedAmount else 0 end))  as ConvertedAmount,
		sum(case when isnull(T05.AccountID, '''') = '''' then ConvertedAmount else 0 end) as CreditAmount,
		sum(case when isnull(T05.AccountID, '''') <> '''' then ConvertedAmount else 0 end) as DebitAmount 	'

Set @sSQL2 = '				 				
From MV9000 V00   left join MT0699 T03 on V00.MaterialTypeID = T03.MaterialTypeID and V00.DivisionID = T03.DivisionID
		left join MT1601 T04 on T04.PeriodID = V00.PeriodID and T04.DivisionID = V00.DivisionID
Where 		V00.DivisionID = '''+@DivisionID+''' and  '
	 + case when @IsDate = 0 then '  V00.TranMonth + 100*V00.TranYear between  '+ cast(@FromMonth + 100*@FromYear as nvarchar(20))  + ' and  ' +
	cast(@ToMonth + 100*@ToYear as nvarchar(20))   else 
	' (V00.VoucherDate between ''' + convert(nvarchar(10), @FromDate, 101) + ''' and ''' +  convert(nvarchar(10), @ToDate, 101)  + '''' end  + ' and    
	V00.PeriodID like ''' + @PeriodID+ '''' + @sWhere  + ')'+
' Group by  V00.DivisionID, V00.MaterialTypeID, T03.UserName, V00.PeriodID, T04.Description 
Having (sum(case when isnull(T05.AccountID, '''') <> '''' then ConvertedAmount else 0 end) - sum(case when isnull(T05.AccountID, '''') = '''' then ConvertedAmount else 0 end))   <> 0	'
END
ELSE
BEGIN
Set @sSQL1 = 'Select  V00.DivisionID, '''' as  MaterialTypeID, ''''  MaterialTypeIDUserName, 
		 V00.DebitAccountID, V00.CreditAccountID,
		V00.PeriodID, T04.Description as PeriodName,  
		(sum(case when isnull(T05.AccountID, '''') <> '''' then ConvertedAmount else 0 end) - sum(case when isnull(T05.AccountID, '''') = '''' then ConvertedAmount else 0 end))  as ConvertedAmount,
		sum(case when isnull(T05.AccountID, '''') = '''' then ConvertedAmount else 0 end) as CreditAmount,
		sum(case when isnull(T05.AccountID, '''') <> '''' then ConvertedAmount else 0 end) as DebitAmount '
		
Set @sSQL2 = '						 				
From MV9000 V00   left join MT0699 T03 on V00.MaterialTypeID = T03.MaterialTypeID and V00.DivisionID = T03.DivisionID
		left join MT1601 T04 on T04.PeriodID = V00.PeriodID and T04.DivisionID = V00.DivisionID
Where 		V00.DivisionID = '''+@DivisionID+''' and  '
	 + case when @IsDate = 0 then '  V00.TranMonth + 100*V00.TranYear between  '+ cast(@FromMonth + 100*@FromYear as nvarchar(20))  + ' and  ' +
	cast(@ToMonth + 100*@ToYear as nvarchar(20))   else 
	' (V00.VoucherDate between ''' + convert(nvarchar(10), @FromDate, 101) + ''' and ''' +  convert(nvarchar(10), @ToDate, 101)  + '''' end  + ' and    
	V00.PeriodID like ''' + @PeriodID+ '''' + @sWhere +  ')'+
' Group by  V00.DivisionID, V00.PeriodID, T04.Description 
Having (sum(case when isnull(T05.AccountID, '''') <> '''' then ConvertedAmount else 0 end) - sum(case when isnull(T05.AccountID, '''') = '''' then ConvertedAmount else 0 end))   <> 0	'
END

print @sSQL1+@sSQL2

If not exists (Select top 1 1 From SysObjects Where name = 'MV0002' and Xtype ='V')
	Exec ('Create view MV0002 as '+@sSQL1+@sSQL2)
Else
	Exec ('Alter view MV0002 as '+@sSQL1+@sSQL2)