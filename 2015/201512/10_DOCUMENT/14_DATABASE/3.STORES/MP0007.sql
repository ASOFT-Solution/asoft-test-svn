/****** Object:  StoredProcedure [dbo].[MP0007]    Script Date: 07/29/2010 17:07:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created  by: VO THANH HUONG, 15/06/2005
----Purpose: In bao cao so sanh chi tiet chi phi nguyen vat lieu truc tiep, CP nhan cong , CP SXC voi ket qua phan bo

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/
---- Edited by Bao Anh	Date: 23/07/2012
---- Purpose: Bo sung so phan bo cua doi tuong cha (ParentDistributedAmount)

ALTER PROCEDURE [dbo].[MP0007] 
				@DivisionID nvarchar(50),				
				@FromMonth as int,
				@FromYear as int,
				@ToMonth as int,
				@ToYear as int,			
				@PeriodID as nvarchar(50),				
				@Is621 as tinyint,
				@Is622 as tinyint,
				@Is627 as tinyint,
				@IsDifferent tinyint			
AS
Declare @sSQL1 as nvarchar(4000),
	@sSQL2 as nvarchar(4000),
	@sWhere nvarchar(4000),
	@sWhere2 nvarchar(4000), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)



If 	(@Is621 = 1 or  @Is622 = 1 or @Is627 = 1) 
Begin
	Select @sWhere =  ' and ('  + 
		case when @Is621 = 1 then ' V00.ExpenseID = ''COST001'' or '  else '' end + 
		case when  @Is622 = 1  then ' V00.ExpenseID = ''COST002'' or ' else '' end + 
		case when  @Is627 = 1  then ' V00.ExpenseID = ''COST003'' or ' else '' end ,  
		 @sWhere2 =  ' and ('  + 
		case when @Is621 = 1 then ' ExpenseID = ''COST001'' or '  else '' end + 
		case when  @Is622 = 1  then 'ExpenseID = ''COST002'' or ' else '' end + 
		case when  @Is627 = 1  then ' ExpenseID = ''COST003'' or ' else '' end  
	Select @sWhere = left(@sWhere, len(@sWhere) -2) + ')',
		 @sWhere2 = left(@sWhere2, len(@sWhere2) -2) + ')'
End
Else 
	Select  @sWhere  = '', @sWhere2 ='' 
If @Is621 = 1 and @Is622 = 0 and @Is627 = 0   --neu la NVL
BEGIN
Set @sSQL1 =
'Select   V00.DivisionID, V00.PeriodID, T04.Description as PeriodName,  V00.ExpenseID, 
	V00.MaterialTypeID, T03.UserName as  MaterialTypeName  , 
	V00.InventoryID as MaterialID,   T00.InventoryName as MaterialName , V00.UnitID, T02.UnitName,   
	sum( case D_C when ''D'' then isnull(Quantity,0) else -isnull(Quantity,0) end) as  SetQuantity, 
	AVG( isnull(T06.MaterialQuantity,0)) as DistributionQuantity, 
	sum( case D_C when ''D'' then isnull(Quantity,0) else -isnull(Quantity,0) end) -	AVG( isnull(T06.MaterialQuantity,0)) as RemainQuantity, 	

	Sum( Case D_C  when ''D'' then   Isnull(V00.ConvertedAmount,0) else - Isnull(V00.ConvertedAmount,0) end) as SetConvertedAmount, 
	AVG(Isnull(T06.ConvertedAmount,0)) as DistributionConvertedAmount,  
	Sum( Case D_C  when ''D'' then   Isnull(V00.ConvertedAmount,0) else - Isnull(V00.ConvertedAmount,0) end) -
	AVG(Isnull(T06.ConvertedAmount,0)) as RemainConvertedAmount,
	(Select Sum(isnull(ConvertedAmount,0)) 
	From MT9000 Where MT9000.DivisionID = V00.DivisionID And MT9000.ParentPeriodID=V00.PeriodID 
	And MT9000.ExpenseID = V00.ExpenseID And MT9000.MaterialTypeID = V00.MaterialTypeID And V00.InventoryID = MT9000.InventoryID)  as ParentDistributedAmount
	'
	
Set @sSQL2 ='
From MV9000 V00 left  join AT1302 T00 on T00.InventoryID = V00.InventoryID and T00.DivisionID = V00.DivisionID
	left join AT1304 T02 on V00.UnitID= T02.UnitID		 and T02.DivisionID = V00.DivisionID
	left join MT0699 T03 on V00.MaterialTypeID = T03.MaterialTypeID and T03.DivisionID = V00.DivisionID
	left join MT1601 T04 on T04.PeriodID = V00.PeriodID and T04.DivisionID = V00.DivisionID
	left join MT0700 T05 on T05.AccountID = V00.DebitAccountID and T05.DivisionID = V00.DivisionID
	left join (Select DivisionID, PeriodID,  ExpenseID, MaterialTypeID, MaterialID,sum(isnull(MaterialQuantity,0)) as MaterialQuantity, 
		sum(isnull(ConvertedAmount, 0)) as ConvertedAmount 
		From  MT0400 
		Where 		DivisionID = '''+@DivisionID+''' and  
		TranMonth + 100*TranYear between  '+ @FromMonthYearText  + ' and  ' +
		@ToMonthYearText + ' and
		PeriodID like ''' + @PeriodID+ '''' + @sWhere2 + '
		Group by DivisionID,PeriodID, ExpenseID, MaterialTypeID, MaterialID
		) T06 on T06.PeriodID = V00.PeriodID and 
		T06.MaterialID = V00.InventoryID and T06.MaterialTypeID =  V00.MaterialTypeID and T06.ExpenseID = V00.ExpenseID and T06.DivisionID = V00.DivisionID
Where 	V00.DivisionID = '''+@DivisionID+''' and  
	V00.TranMonth + 100*V00.TranYear between  '+ @FromMonthYearText  + ' and  ' +
	@ToMonthYearText + ' and
	V00.PeriodID like ''' + @PeriodID+ '''' + @sWhere + 
' Group by    V00.DivisionID, V00.PeriodID, T04.Description,  V00.ExpenseID, 
	V00.MaterialTypeID, T03.UserName, 
	V00.InventoryID,   T00.InventoryName, V00.UnitID, T02.UnitName' +
case when @IsDifferent = 1 then ' Having ( Sum( Case D_C  when ''D'' then   Isnull(V00.ConvertedAmount,0) else - Isnull(V00.ConvertedAmount,0) end) -
	avg(Isnull(T06.ConvertedAmount,0)) <> 0) or (sum( isnull(Quantity,0)) - avg( isnull(T06.MaterialQuantity,0)) <> 0) ' else '' end

END
Else  --Tat ca cac truong hop khac
BEGIN
Set @sSQL1 = 
'Select  V00.DivisionID, V00.PeriodID, T04.Description as PeriodName,  V00.ExpenseID, 
	V00.MaterialTypeID, T03.UserName as  MaterialTypeName  , 
	'''' as MaterialID,  '''' as MaterialName , '''' as UnitID, '''' as UnitName,    0 as SetQuantity, 0 as DistributionQuantity, 0 as RemainQuantity,
	sum(case when isnull(T05.AccountID, '''') <> '''' then V00.ConvertedAmount else 0 end) 
	-sum(case when isnull(T05.AccountID, '''') = '''' then V00.ConvertedAmount else 0 end) as SetConvertedAmount,					 				
	AVG(Isnull(T06.ConvertedAmount,0)) as DistributionConvertedAmount,
	sum(case when isnull(T05.AccountID, '''') <> '''' then V00.ConvertedAmount else 0 end)
	-sum(case when isnull(T05.AccountID, '''') = '''' then V00.ConvertedAmount else 0 end) 	
	-AVG(Isnull(T06.ConvertedAmount,0)) as RemainConvertedAmount,
	(Select sum(isnull(ConvertedAmount,0)) 
	From MT9000 Where MT9000.DivisionID = V00.DivisionID And MT9000.ParentPeriodID=V00.PeriodID 
	And MT9000.ExpenseID = V00.ExpenseID And MT9000.MaterialTypeID = V00.MaterialTypeID) as ParentDistributedAmount
	'
	
Set @sSQL2 ='
From MV9000 V00 --left  join AT1302 T00 on T00.InventoryID = V00.InventoryID and T00.DivisionID = V00.DivisionID
	left join MT0699 T03 on V00.MaterialTypeID = T03.MaterialTypeID and T03.DivisionID = V00.DivisionID
	left join MT1601 T04 on T04.PeriodID = V00.PeriodID and T04.DivisionID = V00.DivisionID
	left join MT0700 T05 on T05.AccountID = V00.DebitAccountID and T05.DivisionID = V00.DivisionID
	left join (Select DivisionID, PeriodID, ExpenseID, MaterialTypeID, sum(isnull(ConvertedAmount, 0)) as ConvertedAmount 
		From  MT0400 
		Where 	DivisionID = '''+@DivisionID+''' and  
		TranMonth + 100*TranYear between  '+ @FromMonthYearText  + ' and  ' +
		@ToMonthYearText + ' and
		PeriodID like ''' + @PeriodID+ '''' + @sWhere2 + '
		Group by DivisionID,PeriodID, ExpenseID, MaterialTypeID
		) T06 on T06.PeriodID = V00.PeriodID and  T06.MaterialTypeID =  V00.MaterialTypeID and T06.ExpenseID = V00.ExpenseID and T06.DivisionID = V00.DivisionID
Where 		V00.DivisionID = '''+@DivisionID+''' and  
	  V00.TranMonth + 100*V00.TranYear between  '+ @FromMonthYearText  + ' and  ' +
	@ToMonthYearText +  ' and    
	V00.PeriodID like ''' + @PeriodID+ '''' + @sWhere + 
' Group by    V00.DivisionID, V00.PeriodID, T04.Description,  V00.ExpenseID, V00.MaterialTypeID, T03.UserName' + 
case when @IsDifferent = 1 then ' Having sum(case when isnull(T05.AccountID, '''') <> '''' then V00.ConvertedAmount else 0 end)
	-sum(case when isnull(T05.AccountID, '''') = '''' then V00.ConvertedAmount else 0 end) 	
	-avg(Isnull(T06.ConvertedAmount,0)) <> 0 ' else '' end

END

--print @sSQL1+@sSQL2

If not exists (Select top 1 1 From SysObjects Where name = 'MV0007' and Xtype ='V')
	Exec ('Create view MV0007 --MP0007
	as '+@sSQL1+@sSQL2)
Else
	Exec ('Alter view MV0007  --MP0007
	as '+@sSQL1+@sSQL2)