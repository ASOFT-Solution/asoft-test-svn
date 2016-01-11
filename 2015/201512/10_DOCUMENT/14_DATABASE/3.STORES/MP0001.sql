
/****** Object:  StoredProcedure [dbo].[MP0001]    Script Date: 07/29/2010 15:03:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




----Created  by: VO THANH HUONG, 18/04/2005
------- Purpose: In bao cao chi tiet chi phi nguyen vat lieu truc tiep, CP nhan cong , CP SXC
----Edit by: Dang Le Bao Quynh; Date : 20/06/2007
----Purpose: Them truong FromTable de xac dinh nguoc goc du lieu phuc vu cho bao' cao'

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/



ALTER  PROCEDURE [dbo].[MP0001] @DivisionID nvarchar(50),
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
				@Is627 as tinyint			
AS
Declare @sSQL1 as nvarchar(4000),
	@sSQL2 as nvarchar(4000),
	@sSQL3 as nvarchar(4000),
	@sWhere nvarchar(4000), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

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

If @Is621 = 1 and @Is622 = 0 and @Is627 = 0
BEGIN
Set @sSQL1 = '
Select    V00.DivisionID, V00.TransactionTypeID,T03.UserName as  MaterialTypeIDUserName  , 
		V00.InventoryID as MaterialID,      
		T00.InventoryName as MaterialName , 
		V00.UnitID, 
		T02.UnitName,   
		V00.ProductID, 
		T01.InventoryName as ProductName,  
		V00.DebitAccountID, 
		V00.CreditAccountID,
		V00.PeriodID, 
		T04.Description as PeriodName,  
		Sum( isnull(Quantity,0)) as  Quantity,
		Sum( Case D_C  when ''D'' then   Isnull(ConvertedAmount,0) else - Isnull(ConvertedAmount,0) end) as ConvertedAmount,
		sum(case when isnull(T05.AccountID, '''') = '''' then ConvertedAmount else 0 end) as CreditAmount,
		sum(case when isnull(T05.AccountID, '''') <> '''' then ConvertedAmount else 0 end) as DebitAmount 	'

Set @sSQL2 = '					 				
From MV9000 V00 left  join AT1302 T00 on T00.InventoryID = V00.InventoryID and T00.DivisionID = V00.DivisionID
		left join AT1302 T01 on T01.InventoryID = V00.ProductID and T01.DivisionID = V00.DivisionID
		left join AT1304 T02 on V00.UnitID= T02.UnitID		 and T02.DivisionID = V00.DivisionID
		left join MT0699 T03 on V00.MaterialTypeID = T03.MaterialTypeID and T03.DivisionID = V00.DivisionID
		left join MT1601 T04 on T04.PeriodID = V00.PeriodID and T04.DivisionID = V00.DivisionID
		left join MT0700 T05 on T05.AccountID = V00.DebitAccountID and T05.DivisionID = V00.DivisionID
Where 		V00.DivisionID = '''+@DivisionID+''' and  ' + 
		case when @IsDate = 0 
			then '  V00.TranMonth + 100*V00.TranYear between  '+ 
				@FromMonthYearText  + ' and  ' +
				@ToMonthYearText   
			else 
			' convert(nvarchar(10), V00.VoucherDate, 101) between ''' + @FromDateText + ''' and 
			''' +  @ToDateText  + '''' end  + ' and    
			V00.PeriodID like ''' + @PeriodID+ '''' +
			@sWhere 

Set @sSQL3 = '		
Group by 	 V00.DivisionID, V00.TransactionTypeID,
		T03.UserName, 
		V00.InventoryID,      
		T00.InventoryName , 
		V00.UnitID, 
		T02.UnitName,  
		V00.ProductID, 
		T01.InventoryName,
		V00.DebitAccountID, 
		V00.CreditAccountID, 
		V00.PeriodID, 
		T04.Description 
Having Sum(Isnull(ConvertedAmount,0))  +Sum( isnull(Quantity,0)) <> 0	'
END
Else
BEGIN
Set @sSQL1 = '
Select    V00.DivisionID, V00.TransactionTypeID,T03.UserName as  MaterialTypeIDUserName  ,  
		'''' as MaterialID,     
		'''' as MaterialName , 
		'''' as UnitID, 
		'''' as UnitName,   
		V00.ProductID, 
		T01.InventoryName as ProductName,  
		V00.DebitAccountID, 
		V00.CreditAccountID,
		V00.PeriodID, 
		T04.Description as PeriodName, 
		0 as  Quantity,
		Sum(Isnull(ConvertedAmount,0)) as ConvertedAmount, 
		sum(case when isnull(T05.AccountID, '''') = '''' then ConvertedAmount else 0 end) as CreditAmount,
		sum(case when isnull(T05.AccountID, '''') <> '''' then ConvertedAmount else 0 end) as DebitAmount '	

Set @sSQL2 = ' 	 				
From MV9000 V00 --left  join AT1302 T00 on T00.InventoryID = V00.InventoryID
		left join AT1302 T01 on T01.InventoryID = V00.ProductID and T01.DivisionID = V00.DivisionID
		left join AT1304 T02 on V00.UnitID= T02.UnitID		 and T02.DivisionID = V00.DivisionID
		left join MT0699 T03 on V00.MaterialTypeID = T03.MaterialTypeID and T03.DivisionID = V00.DivisionID
		left join MT1601 T04 on T04.PeriodID = V00.PeriodID and T04.DivisionID = V00.DivisionID
		left join MT0700 T05 on T05.AccountID = V00.DebitAccountID and T05.DivisionID = V00.DivisionID
Where 		V00.DivisionID = '''+@DivisionID+''' and  '
		 + case when @IsDate = 0 
				then '  V00.TranMonth + 100*V00.TranYear between  '+ 
				@FromMonthYearText  + ' and  ' +
				@ToMonthYearText   else 
				' convert(nvarchar(10), V00.VoucherDate, 101) between ''' + @FromDateText + ''' and ''' +  
				@ToDateText  + '''' 
			end  + ' and V00.PeriodID like ''' + @PeriodID+ '''' 
				+ @sWhere  
		
Set @sSQL3 = ' 
Group by 	 V00.DivisionID, V00.TransactionTypeID,
		T03.UserName,  
		V00.ProductID, 
		T01.InventoryName,
		V00.DebitAccountID, 
		V00.CreditAccountID, 
		V00.PeriodID, 
		T04.Description 
Having Sum(Isnull(ConvertedAmount,0)) <> 0'
END

print @sSQL1+@sSQL2+@sSQL3

If not exists (Select top 1 1 From SysObjects Where name = 'MV0001' and Xtype ='V')
	Exec ('Create view MV0001 as -- MP0001 
	 '+@sSQL1+@sSQL2+@sSQL3)
Else
	Exec ('Alter view MV0001 as -- MP0001 
	'+@sSQL1+@sSQL2+@sSQL3)
