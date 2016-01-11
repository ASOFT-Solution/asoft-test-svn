
/****** Object:  StoredProcedure [dbo].[MP6027]    Script Date: 12/16/2010 14:00:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



---Created by: Vo Thanh Huong, date: 12/06/2005
---purpose: IN bao cao QLSX > Tong hop hinh san xuat Thanh pham > Dang 1 : Ket qua san xuat den thoi diem hien tai 

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP6027]  
				@DivisionID nvarchar(50),
				@FromMonth int,
				@FromYear int,
				@ToMonth int,
				@ToYear int,
				@FromDate datetime,
				@ToDate datetime,
				@IsDate tinyint,
				@FromDepartmentID nvarchar(50),
				@ToDepartmentID nvarchar(50),
				@FromInventoryID nvarchar(50),
				@ToInventoryID nvarchar(50)

AS
DECLARE  @sSQL nvarchar(4000),
	@sWHERE nvarchar(500), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

Select @sWHERE = '', @sSQL = ''

Set @sWHERE = ' and '+ case when @IsDate = 1 then ' MT2001.VoucherDate between ''' + @FromDateText + ''' and ''' + 
		@ToDateText + '''' 
		else ' MT2001.TranMonth + MT2001.TranYear*100 between ' + @FromMonthYearText + ' and ' + 
		@ToMonthYearText end 

EXEC MP6020   @DivisionID,	@FromMonth,	@FromYear,	@ToMonth,	@ToYear,	@FromDate,	@ToDate,	@IsDate,
		@FromDepartmentID, 	@ToDepartmentID,	'%' , NULL,  0

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
	MT2001.SOderID as MOrderID
From MT2002 inner join MT2001 on MT2002.PlanID = MT2001.PlanID  and MT2002.Finish = 1 and MT2002.DivisionID = MT2001.DivisionID
	left join AT1302 on AT1302.InventoryID = MT2002.InventoryID  and MT2002.DivisionID = AT1302.DivisionID
	left join AT1304 on AT1304.UnitID = MT2002.UnitID  and MT2002.DivisionID = AT1304.DivisionID
	left join AT1102 on AT1102.DepartmentID = MT2002.DepartmentID and AT1102.DivisionID = MT2002.DivisionID
	left join MT1702 on MT1702.LevelID = MT2002.LevelID and MT1702.WorkID = MT2002.WorkID and MT2002.DivisionID = MT1702.DivisionID
	left join (Select DivisionID, PlanID, PlanDetailID, max(EndDate) as EndDate From  MT6007 Group by  DivisionID,PlanID, PlanDetailID) MT6007 on
		MT6007.PlanID = MT2002.PlanID and MT6007.PlanDetailID = MT2002.PlanDetailID and MT2002.DivisionID = MT6007.DivisionID
	left join (Select 	max(MT2004.VoucherDate) as ActualDate,
		MT2005.PlanID, 
		MT2005.InventoryID, 
		isnull(MT2005.LinkNo, '''') as LinkNo,
		MT2005.WorkID, 
		MT2005.LevelID, 
		sum(isnull(ActualQuantity, 0)) as ActualQuantity,MT2005.DivisionID 		
	From MT2005 inner join MT2004 on  MT2004.VoucherID = MT2005.VoucherID  and MT2005.DivisionID = MT2004.DivisionID
	Where  Isnull(MT2005.PlanID, '''') <> ''''  and MT2005.DivisionID like ''' + @DivisionID + '''   
	Group by MT2005.DivisionID 	, MT2005.PlanID, 
		MT2005.InventoryID, 
		isnull(MT2005.LinkNo, ''''),
		MT2005.WorkID, 
		MT2005.LevelID) MT2005 on MT2005.PlanID = MT2002.PlanID and 
		isnull(MT2005.LinkNo, '''') = isnull(MT2002.LinkNo, '''') and 
		isnull(MT2005.WorkID, '''') = isnull(MT2002.WorkID, '''') and 
		isnull(MT2005.LevelID, '''') = isnull(MT2002.LevelID, '''') and
		MT2005.InventoryID = MT2002.InventoryID and MT2005.DivisionID = MT2002.DivisionID
Where MT2001.DivisionID like ''' + @DivisionID + ''' and 
	isnull(MT2002.DepartmentID, ''' + @FromDepartmentID + ''')  between N''' + @FromDepartmentID + ''' and N''' + @ToDepartmentID +  ''' and 	
	MT2002.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + '''' 
	
If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV6027')
	Drop view MV6027

EXEC('Create view MV6027 --tao boi MP6027
		as ' + @sSQL+  @sWHERE )