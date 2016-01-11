
/****** Object:  StoredProcedure [dbo].[MP6025]    Script Date: 12/16/2010 13:57:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





---Created by: Vo Thanh Huong, date: 12/06/2005
---purpose: IN bao cao QLSX > Tong hop ket qua san xuat > Dang 1 : Ket qua san xuat den thoi diem hien tai 

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP6025]  @DivisionID nvarchar(50),
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

Set @sWHERE = ' and '+ case when @IsDate = 1 then 
						' MT2001.VoucherDate between ''' + @FromDateText + ''' and ''' +  @ToDateText + '''' 
					else ' MT2001.TranMonth + MT2001.TranYear*100 between ' + @FromMonthYearText + ' and ' +  @ToMonthYearText end 

EXEC MP6020   @DivisionID,	@FromMonth,	@FromYear,	@ToMonth,	@ToYear,	@FromDate,	@ToDate,	@IsDate,
		@FromDepartmentID, 	@ToDepartmentID,	'%' , NULL,  0

Set @sSQL = '
SELECT distinct	MT2002.DivisionID, MT2001.PlanID as VoucherID,
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
FROM MT2002 inner join MT2001 on MT2002.PlanID = MT2001.PlanID  
	left join AT1302 on AT1302.InventoryID = MT2002.InventoryID 
	left join AT1304 on AT1304.UnitID = MT2002.UnitID 
	left join AT1102 on AT1102.DepartmentID = MT2002.DepartmentID and AT1102.DivisionID = MT2002.DivisionID
	left join MT1702 on MT1702.LevelID = MT2002.LevelID and MT1702.WorkID = MT2002.WorkID
	left join (Select PlanID, PlanDetailID, max(EndDate) as EndDate From  MT6007 Group by  PlanID, PlanDetailID) MT6007 on
		MT6007.PlanID = MT2002.PlanID and MT6007.PlanDetailID = MT2002.PlanDetailID
	left join (Select 	max(MT2004.VoucherDate) as ActualDate,
		MT2005.PlanID, 
		MT2005.InventoryID, 
		isnull(MT2005.LinkNo, '''') as LinkNo,
		MT2005.WorkID, 
		MT2005.LevelID, 
		sum(isnull(ActualQuantity, 0)) as ActualQuantity		
	FROM MT2005 inner join MT2004 on  MT2004.VoucherID = MT2005.VoucherID 
	WHERE  Isnull(MT2005.PlanID, '''') <> ''''  and MT2005.DivisionID like ''' + @DivisionID + '''   
	GROUP BY MT2005.PlanID, 
		MT2005.InventoryID, 
		isnull(MT2005.LinkNo, ''''),
		MT2005.WorkID, 
		MT2005.LevelID) MT2005 on MT2005.PlanID = MT2002.PlanID and 
		isnull(MT2005.LinkNo, '''') = isnull(MT2002.LinkNo, '''') and 
		isnull(MT2005.WorkID, '''') = isnull(MT2002.WorkID, '''') and 
		isnull(MT2005.LevelID, '''') = isnull(MT2002.LevelID, '''') and
		MT2005.InventoryID = MT2002.InventoryID
WHERE MT2001.DivisionID like ''' + @DivisionID + ''' and 
	isnull(MT2002.DepartmentID,''' + @FromDepartmentID + ''')  between ''' + @FromDepartmentID + '''  and '''+ @ToDepartmentID + ''' and 
	MT2002.InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + '''			
' +  @sWHERE 

----print @sWHERE

If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV6025')
	Drop view MV6025

EXEC('Create view MV6025 --tao boi MP6025
		as ' + @sSQL) 