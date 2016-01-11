
/****** Object:  StoredProcedure [dbo].[MP6023]    Script Date: 12/16/2010 13:54:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




---Created by: Vo Thanh Huong, date: 12/06/2005
---purpose: IN bao cao QLSX > Chi tiet tinh hinh san xuat Thanh pham > Dang 1 : Ket qua san xuat den thoi diem hien tai 

ALTER  PROCEDURE [dbo].[MP6023]  @DivisionID nvarchar(50),
				@FromMonth int,
				@FromYear int,
				@ToMonth int,
				@ToYear int,
				@FromDate datetime,
				@ToDate datetime,
				@IsDate tinyint,
				@PlanID nvarchar(50),
				@LinkNo nvarchar(50),
				@InventoryID nvarchar(50),
				@OrderID nvarchar(50)

AS
DECLARE  @sSQL varchar(max),
	@sWHERE varchar(500), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

Select @sWHERE = '', @sSQL = ''

Set @sWHERE = ' and '+ case when @IsDate = 1 then ' convert(NVARCHAR(50), MT2001.VoucherDate, 101) between ''' + @FromDateText + ''' and ''' + 
		@ToDateText + '''' 
		else ' MT2001.TranMonth + MT2001.TranYear*100 between ' + @FromMonthYearText + ' and ' + 
		@ToMonthYearText end 

EXEC MP6020   @DivisionID,	@FromMonth,	@FromYear,	@ToMonth,	@ToYear,	@FromDate,	@ToDate,	@IsDate,
		NULL, 	NULL,	'%' , NULL,  0

Set @sSQL = '
Select 	MT2002.DivisionID, MT2001.PlanID as VoucherID,
	MT2001.VoucherNo ,
	MT2001.VoucherDate,
	MT2001.PlanID as PlanID,
	MT2002.BeginDate,
	MT2005.ActualDate,
	MT6007.EndDate, 
	MT2002.InventoryID, 
	AT1302.InventoryName,
	AT1304.UnitName, 
	MT2002.LinkNo,
	MT2002.WorkID, 
	MT2002.LevelID,
	MT1702.LevelName,
	MT2002.Finish,
	MT2002.PlanQuantity, 
	MT2005.ActualQuantity,
	MT2002.DepartmentID,
	AT1102.DepartmentName,	
	MT2002.Notes as Description,
	MT2001.SOderID as MOrderID,
	0 as IsNotPlan
From MT2002 inner join MT2001 on MT2002.PlanID = MT2001.PlanID AND MT2002.DivisionID = MT2001.DivisionID  and MT2002.Finish = 1 
	left join AT1302 on AT1302.InventoryID = MT2002.InventoryID AND AT1302.DivisionID = MT2002.DivisionID
	left join AT1304 on AT1304.UnitID = MT2002.UnitID AND AT1304.DivisionID = MT2002.DivisionID
	left join AT1102 on AT1102.DepartmentID = MT2002.DepartmentID and AT1102.DivisionID = MT2002.DivisionID
	left join MT1702 on MT1702.LevelID = MT2002.LevelID and MT1702.WorkID = MT2002.WorkID and MT1702.DivisionID = MT2002.DivisionID
	left join (Select PlanID, PlanDetailID, max(EndDate) as EndDate From  MT6007 Group by  PlanID, PlanDetailID) MT6007 on
		MT6007.PlanID = MT2002.PlanID and MT6007.PlanDetailID = MT2002.PlanDetailID
	left join (Select 	max(MT2004.VoucherDate) as ActualDate,
		MT2005.PlanID, 
		MT2005.InventoryID, 
		isnull(MT2005.LinkNo, '''') as LinkNo,
		MT2005.WorkID, 
		MT2005.LevelID, 
		sum(isnull(ActualQuantity, 0)) as ActualQuantity		
	From MT2005 inner join MT2004 on  MT2004.VoucherID = MT2005.VoucherID 
	Where  Isnull(MT2005.PlanID, '''') <> ''''  and MT2005.DivisionID like ''' + @DivisionID + '''   
	Group by MT2005.PlanID, 
		MT2005.InventoryID, 
		isnull(MT2005.LinkNo, ''''),
		MT2005.WorkID, 
		MT2005.LevelID) MT2005 on MT2005.PlanID = MT2002.PlanID and 
		isnull(MT2005.LinkNo, '''') = isnull(MT2002.LinkNo, '''') and 
		isnull(MT2005.WorkID, '''') = isnull(MT2002.WorkID, '''') and 
		isnull(MT2005.LevelID, '''') = isnull(MT2002.LevelID, '''') and
		MT2005.InventoryID = MT2002.InventoryID
Where MT2001.DivisionID like ''' + @DivisionID + ''' and 
	isnull(MT2001.PlanID,'''')  like ''' + isnull(@PlanID, '%') + ''' and
	isnull(MT2002.LinkNo, '''') like ''' + isnull(@LinkNo, '%') + ''' and 
	isnull(MT2001.SOderID,'''') like ''' + isnull(@OrderID, '%') + ''' and 
	MT2002.InventoryID like ''' + isnull(@InventoryID, '%') + '''' +  @sWHERE + '
Union
Select MT2005.DivisionID, MT2004.VoucherID,
	MT2004.VoucherNo ,
	MT2004.VoucherDate,
	MT2005.PlanID as PlanID,
	'''' as BeginDate,
	'''' as ActualDate,
	'''' as EndDate, 
	MT2005.InventoryID, 
	AT1302.InventoryName,
	AT1304.UnitName,
	MT2005.LinkNo,
	MT2005.WorkID, 
	MT2005.LevelID,
	MT1702.LevelName,
	1 as Finish,
	0 as PlanQuantity, 
	MT2005.ActualQuantity,
	MT2005.DepartmentID,
	AT1102.DepartmentName,	
	MT2005.Description,
	MT2001.SOderID as MOrderID,
	1 as IsNotPlan
From MT2005 inner join MT2004 on MT2004.VoucherID = MT2005.VoucherID AND MT2004.DivisionID = MT2005.DivisionID
	left join AT1304 on AT1304.UnitID = MT2005.UnitID AND AT1304.DivisionID = MT2005.DivisionID
	left join AT1102 on AT1102.DepartmentID = MT2005.DepartmentID AND
		AT1102.DivisionID = MT2005.DivisionID 
	left join AT1302 on AT1302.InventoryID = MT2005.InventoryID AND AT1302.DivisionID = MT2005.DivisionID
	left join MT1702 on MT1702.LevelID = MT2005.LevelID and MT1702.DivisionID = MT2005.DivisionID AND
		MT1702.WorkID = MT2005.WorkID  
	inner join MT2001 on MT2005.PlanID = MT2001.PlanID  AND MT2005.DivisionID = MT2001.DivisionID ' + @sWHERE + '
	inner join MT2002 on MT2002.PlanID = MT2001.PlanID AND MT2002.DivisionID = MT2001.DivisionID and MT2002.Finish  = 1
Where MT2004.DivisionID like ''' + @DivisionID + ''' and 
	MT2005.PlanID like ''' +  isnull(@PlanID,'%') + ''' and  
	isnull(MT2005.LinkNo, '''') like ''' + isnull(@LinkNo, '%') + ''' and 
	isnull(MT2005.InventoryID, '''') like ''' + isnull(@InventoryID, '%') + ''' and 
	isnull(MT2001.SOderID, '''') like ''' + isnull(@OrderID, '%' ) + ''''

If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV6023')
	Drop view MV6023

EXEC('Create view MV6023 --tao boi MP6023
		as ' + @sSQL)
