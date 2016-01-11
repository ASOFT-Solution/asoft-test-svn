
/****** Object:  StoredProcedure [dbo].[MP6623]    Script Date: 08/03/2010 10:09:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created  by: VO THANH HUONG, 18/04/2005
------- Purpose: In bao cao chi tiet chi phi nguyen vat lieu truc tiep, CP nhan cong , CP SXC
-- Edit by: Dang Le Bao Quynh; Date 23/03/07
-- Purpose: Hieu chinh lai cac view phuc vu In bao cao
-- Edit by: Dang Le Bao Quynh; Date 20/06/07
-- Purpose: Hieu chinh lai cac view phuc vu In bao cao

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'* Edited by: [GS] [Thiên Huỳnh] [27/09/2011]: Set cac dieu kien where mac dinh = ''
'********************************************/

ALTER PROCEDURE [dbo].[MP6623] 
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
				@IsBegin tinyint,  --Do dang dau ky
				@IsEnd tinyint	-- Do dang cuoi ky		
AS
Declare @sSQL as nvarchar(MAX),
	@sWhere nvarchar(4000),
	@sWhere1612 nvarchar(4000),
	@sWhere1613 nvarchar(4000), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

Set @sWhere = ''
set @sWhere1612 = ''
Set @sWhere1613 = ''

If (@IsBegin = 1  and @IsEnd = 1) or  (@IsBegin = 0  and @IsEnd = 0)
	Set @sWhere = @sWhere + ' and Type in (''B'', ''E'') '
ELSE  
	IF (@IsBegin = 1  and @IsEnd = 0) 
		Set @sWhere = @sWhere + ' and Type = ''B'' '
	ELSE
		Set @sWhere = @sWhere + ' and Type = ''E'' '


If 	(@Is621 = 1 or  @Is622 = 1 or @Is627 = 1) 
Begin
	Set @sWhere1613 = @sWhere + ' and ('  + 
		case when @Is621 = 1 then ' MT1613.ExpenseID = ''COST001'' or '  else '' end + 
		case when  @Is622 = 1  then ' MT1613.ExpenseID = ''COST002'' or ' else '' end + 
		case when  @Is627 = 1  then ' MT1613.ExpenseID = ''COST003'' or ' else '' end  
	Set @sWhere1613 = left(@sWhere1613, len(@sWhere1613) -2) + ')'

	Set @sWhere1612 = @sWhere +  ' and ('  + 
		case when @Is621 = 1 then ' MT1612.ExpenseID = ''COST001'' or '  else '' end + 
		case when  @Is622 = 1  then ' MT1612.ExpenseID = ''COST002'' or ' else '' end + 
		case when  @Is627 = 1  then ' MT1612.ExpenseID = ''COST003'' or ' else '' end  
	Set @sWhere1612 = left(@sWhere1612, len(@sWhere1612) -2) + ')'

End

--print @sWhere1612

--Neu dau ky la nhap bang tay

Set @sSQL = '
Select   		WipVoucherID, 
		MT1612.VoucherID, 
		MT1612.DivisionID, 
		MT1612.TranMonth, 
		MT1612.TranYear, 
		MT1612.VoucherTypeID, 
		MT1612.VoucherNo, 
		MT1612.EmployeeID, 
		MT1612.Description, 
		MT1612.VoucherDate, 
		MT1612.PeriodID, 
		MT1601.Description as PeriodName, 
		MT1612.ProductID, 
		AT1302_P.InventoryName as ProductName,
		MT1612.ProductQuantity, 
		MT1612.PerfectRate, 
		MT1612.WipQuantity, 
		MT1612.ConvertedAmount, 
		MT1612.ConvertedUnit, 
		MT1612.MaterialID, 
		AT1302_M.InventoryName as MaterialName,
		MT1612.ExpenseID, 
		MT1612.MaterialTypeID, 
		MT0699.UserName as MaterialTypeName,
		MT1612.MaterialPrice, 
		MT1612.Type,
		(Select Top 1 UnitName from at1304 Where UnitID = AT1302_M.UnitID) As UnitName
From MT1612 inner join AT1302 AT1302_P on AT1302_P.InventoryID = MT1612.ProductID AND  AT1302_P.DivisionID = MT1612.DivisionID
		left join AT1302 AT1302_M on AT1302_M.InventoryID = MT1612.MaterialID  AND AT1302_M.DivisionID = MT1612.DivisionID
		left join MT0699 on MT0699.MaterialTypeID = MT1612.MaterialTypeID AND MT0699.DivisionID = MT1612.DivisionID
		left join MT1601 on MT1601.PeriodID = MT1612.PeriodID AND MT1601.DivisionID = MT1612.DivisionID
Where 		MT1612.DivisionID = '''+@DivisionID+''' and  ' + 
		case when @IsDate = 0 then '  MT1612.TranMonth + 100*MT1612.TranYear between  '+ 
		@FromMonthYearText  + ' and  ' +
		@ToMonthYearText   else 
		' (MT1612.VoucherDate between ''' + @FromDateText + ''' and 
		''' +  @ToDateText  + '''' end  + ' and    
		isnull(MT1612.ConvertedAmount,0) + isnull(MT1612.ConvertedUnit, 0) <> 0 and 
		MT1612.PeriodID In (Select PeriodID from mt1601,mt1608
				where mt1601.InProcessID = mt1608.InProcessID
				And BeginMethodID = 1
				And PeriodID like ''' + @PeriodID+ ''') And Type = ''B''' + 
		@sWhere1612  

--PRINT @sSQL

If not exists (Select top 1 1 From SysObjects Where name = 'MV6624' and Xtype ='V')
	Exec ('Create view MV6624 as /*Tao boi MP6623*/ '+@sSQL)
Else
	Exec ('Alter view MV6624 as /*Tao boi MP6623*/ '+@sSQL)

--Neu cuoi ky la nhap bang tay

Set @sSQL = '
Select   		WipVoucherID, 
		MT1612.VoucherID, 
		MT1612.DivisionID, 
		MT1612.TranMonth, 
		MT1612.TranYear, 
		MT1612.VoucherTypeID, 
		MT1612.VoucherNo, 
		MT1612.EmployeeID, 
		MT1612.Description, 
		MT1612.VoucherDate, 
		MT1612.PeriodID, 
		MT1601.Description as PeriodName, 
		MT1612.ProductID, 
		AT1302_P.InventoryName as ProductName,
		MT1612.ProductQuantity, 
		MT1612.PerfectRate, 
		MT1612.WipQuantity, 
		MT1612.ConvertedAmount, 
		MT1612.ConvertedUnit, 
		MT1612.MaterialID, 
		AT1302_M.InventoryName as MaterialName,
		MT1612.ExpenseID, 
		MT1612.MaterialTypeID, 
		MT0699.UserName as MaterialTypeName,
		MT1612.MaterialPrice, 
		MT1612.Type,
		(Select Top 1 UnitName from at1304 Where UnitID = AT1302_M.UnitID) As UnitName
From MT1612 inner join AT1302 AT1302_P on AT1302_P.InventoryID = MT1612.ProductID AND AT1302_P.DivisionID = MT1612.DivisionID
		left join AT1302 AT1302_M on AT1302_M.InventoryID = MT1612.MaterialID  AND AT1302_M.DivisionID = MT1612.DivisionID
		left join MT0699 on MT0699.MaterialTypeID = MT1612.MaterialTypeID AND MT0699.DivisionID = MT1612.DivisionID
		left join MT1601 on MT1601.PeriodID = MT1612.PeriodID AND MT1601.DivisionID = MT1612.DivisionID
Where 		MT1612.DivisionID = '''+@DivisionID+''' and  ' + 
		case when @IsDate = 0 then '  MT1612.TranMonth + 100*MT1612.TranYear between  '+ 
		@FromMonthYearText  + ' and  ' +
		@ToMonthYearText   else 
		' (MT1612.VoucherDate between ''' + @FromDateText + ''' and 
		''' +  @ToDateText  + '''' end  + ' and    
		isnull(MT1612.ConvertedAmount,0) + isnull(MT1612.ConvertedUnit, 0) <> 0 and 
		MT1612.PeriodID In (Select PeriodID from mt1601,mt1608
				where mt1601.InProcessID = mt1608.InProcessID
				And EndMethodID = 1
				And PeriodID like ''' + @PeriodID+ ''') And Type = ''E''' + 
		@sWhere1612  

--PRINT @sSQL

If not exists (Select top 1 1 From SysObjects Where name = 'MV6625' and Xtype ='V')
	Exec ('Create view MV6625 as /*Tao boi MP6623*/ '+@sSQL)
Else
	Exec ('Alter view MV6625 as /*Tao boi MP6623*/ '+@sSQL)


--Neu dau ky la ket chuyen tu ky truoc sang

Set @sSQL = '
Select   		'''' as WipVoucherID, 
		MT1613.VoucherID, 
		MT1613.DivisionID, 
		MT1613.TranMonth, 
		MT1613.TranYear, 
		MT1613.VoucherTypeID, 
		MT1613.VoucherNo, 
		MT1613.EmployeeID, 
		MT1613.Description, 
		MT1613.VoucherDate, 
		MT1613.PeriodID, 
		MT1601.Description as PeriodName, 
		MT1613.ProductID, 
		AT1302_P.InventoryName as ProductName,
		MT1613.ProductQuantity, 
		MT1613.PerfectRate, 
		MT1613.MaterialQuantity As WipQuantity, 
		MT1613.ConvertedAmount, 
		MT1613.ConvertedUnit, 
		MT1613.MaterialID, 
		AT1302_M.InventoryName as MaterialName,
		MT1613.ExpenseID, 
		MT1613.MaterialTypeID, 
		MT0699.UserName as MaterialTypeName,
		Null as MaterialPrice, 
		MT1613.Type,
		(Select Top 1 UnitName from at1304 Where UnitID = AT1302_M.UnitID) As UnitName
From MT1613 inner join AT1302 AT1302_P on AT1302_P.InventoryID = MT1613.ProductID AND AT1302_P.DivisionID = MT1613.DivisionID
		left join AT1302 AT1302_M on AT1302_M.InventoryID = MT1613.MaterialID  AND AT1302_M.DivisionID = MT1613.DivisionID  
		left join MT0699 on MT0699.MaterialTypeID = MT1613.MaterialTypeID AND MT0699.DivisionID = MT1613.DivisionID
		left join MT1601 on MT1601.PeriodID = MT1613.PeriodID AND MT1601.DivisionID = MT1613.DivisionID
Where 		MT1613.DivisionID = '''+@DivisionID+''' and  ' + 
		case when @IsDate = 0 then '  MT1613.TranMonth + 100*MT1613.TranYear between  '+ 
		@FromMonthYearText  + ' and  ' +
		@ToMonthYearText   else 
		' (MT1613.VoucherDate between ''' + @FromDateText + ''' and 
		''' +  @ToDateText  + '''' end  + ' and    
		isnull(MT1613.ConvertedAmount,0) + isnull(MT1613.ConvertedUnit, 0) <> 0 and 
		MT1613.PeriodID In (Select PeriodID from mt1601,mt1608
				where mt1601.InProcessID = mt1608.InProcessID
				And BeginMethodID = 2
				And PeriodID like ''' + @PeriodID+ ''') And Type = ''B''' + 
		@sWhere1613  

--PRINT @sSQL

If not exists (Select top 1 1 From SysObjects Where name = 'MV6626' and Xtype ='V')
	Exec ('Create view MV6626 as /*Tao boi MP6623*/ '+@sSQL)
Else
	Exec ('Alter view MV6626 as /*Tao boi MP6623*/ '+@sSQL)

--Neu cuoi ky la duoc tinh toan

Set @sSQL = '
Select   		'''' as WipVoucherID, 
		MT1613.VoucherID, 
		MT1613.DivisionID, 
		MT1613.TranMonth, 
		MT1613.TranYear, 
		MT1613.VoucherTypeID, 
		MT1613.VoucherNo, 
		MT1613.EmployeeID, 
		MT1613.Description, 
		MT1613.VoucherDate, 
		MT1613.PeriodID, 
		MT1601.Description as PeriodName, 
		MT1613.ProductID, 
		AT1302_P.InventoryName as ProductName,
		MT1613.ProductQuantity, 
		MT1613.PerfectRate, 
		MT1613.MaterialQuantity As WipQuantity, 
		MT1613.ConvertedAmount, 
		MT1613.ConvertedUnit, 
		MT1613.MaterialID, 
		AT1302_M.InventoryName as MaterialName,
		MT1613.ExpenseID, 
		MT1613.MaterialTypeID, 
		MT0699.UserName as MaterialTypeName,
		Null as MaterialPrice, 
		MT1613.Type,
		(Select Top 1 UnitName from at1304 Where UnitID = AT1302_M.UnitID) As UnitName
From MT1613 inner join AT1302 AT1302_P on AT1302_P.InventoryID = MT1613.ProductID AND AT1302_P.DivisionID = MT1613.DivisionID
		left join AT1302 AT1302_M on AT1302_M.InventoryID = MT1613.MaterialID AND AT1302_M.DivisionID = MT1613.DivisionID
		left join MT0699 on MT0699.MaterialTypeID = MT1613.MaterialTypeID AND MT0699.DivisionID = MT1613.DivisionID
		left join MT1601 on MT1601.PeriodID = MT1613.PeriodID AND MT1601.DivisionID = MT1613.DivisionID
Where 		MT1613.DivisionID = '''+@DivisionID+''' and  ' + 
		case when @IsDate = 0 then '  MT1613.TranMonth + 100*MT1613.TranYear between  '+ 
		@FromMonthYearText  + ' and  ' +
		@ToMonthYearText   else 
		' (MT1613.VoucherDate between ''' + @FromDateText + ''' and 
		''' +  @ToDateText  + '''' end  + ' and    
		isnull(MT1613.ConvertedAmount,0) + isnull(MT1613.ConvertedUnit, 0) <> 0 and 
		MT1613.PeriodID In (Select PeriodID from mt1601,mt1608
				where mt1601.InProcessID = mt1608.InProcessID
				And EndMethodID = 0
				And PeriodID like ''' + @PeriodID+ ''') And Type = ''E'''  +
		@sWhere1613 

--PRINT @sSQL

If not exists (Select top 1 1 From SysObjects Where name = 'MV6627' and Xtype ='V')
	Exec ('Create view MV6627 as /*Tao boi MP6623*/ '+@sSQL)
Else
	Exec ('Alter view MV6627 as /*Tao boi MP6623*/ '+@sSQL)

Set @sSQL = '	Select * From MV6624
		Union All 
		Select * From MV6625
		Union All
		Select * From MV6626
		Union All
		Select * From MV6627
		'
If not exists (Select top 1 1 From SysObjects Where name = 'MV6623' and Xtype ='V')
	Exec ('Create view MV6623 as /*Tao boi MP6623*/ '+@sSQL)
Else
	Exec ('Alter view MV6623 as /*Tao boi MP6623*/ '+@sSQL)