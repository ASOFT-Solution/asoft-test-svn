
/****** Object:  StoredProcedure [dbo].[MP6029]    Script Date: 12/16/2010 14:01:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by: Vo Thanh Huong, date: 16/08/2005
--purpose: Bao cao Tong hop LSX

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP6029] 	@DivisionID nvarchar(50),
					@DepartmentID nvarchar(50),
					@PlanID nvarchar(50),
					@FromMonth int,
					@FromYear int,
					@ToMonth int,
					@ToYear int,
					@FromDate datetime,
					@ToDate datetime,	
					@IsDate tinyint
 AS
DECLARE @sSQL nvarchar(4000), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 100)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 100)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

Set @sSQL = 
'Select MT2002.DivisionID, MT2001.VoucherNo, 
	MT2001.VoucherDate, 
	MT2001.SOderID as MOrderID, 
	OT2001.DepartmentID, 
	AT1102.DepartmentName,
	MT2002.InventoryID, 
	AT1302.InventoryName,
	MT2002.UnitID, 
	AT1304.UnitName,
	MT2002.PlanQuantity, 	
	MT2002.LinkNo, 
	MT2002.LevelID, 
	MT2002.WorkID, 
	MT2002.Finish, 
	MT2002.BeginDate,
	MT2002.Notes,
	MT2002.RefInfor 
From MT2002 inner join MT2001 on MT2002.PlanID = MT2001.PlanID and MT2002.DivisionID = MT2001.DivisionID
	left join OT2001 on MT2001.SOderID = OT2001.SOrderID and MT2001.DivisionID = OT2001.DivisionID
	left join AT1102 on AT1102.DivisionID = MT2002.DivisionID and AT1102.DepartmentID = OT2001.DepartmentID
	left join AT1302 on AT1302.InventoryID = MT2002.InventoryID  and MT2002.DivisionID = AT1302.DivisionID
	left join AT1304 on AT1304.UnitID = MT2002.UnitID and MT2002.DivisionID = AT1304.DivisionID
Where MT2001.DivisionID like N''' + @DivisionID + ''' and
	isnull(OT2001.DepartmentID,'''') like N''' + @DepartmentID + ''' and
	MT2001.PlanID like ''' + @PlanID + ''' and ' +
	case when @IsDate = 1 then ' convert(nvarchar(20), MT2001.VoucherDate, 101) between ''' + @FromDateText + ''' and ''' + 
	@ToDateText + '''' 
	else ' MT2001.TranMonth + MT2001.TranYear*100 between ' + @FromMonthYearText + ' and ' + 
	@ToMonthYearText  end 


If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV6029')
	DROP VIEW MV6029

print @sSQL

EXEC('Create view MV6029 ---tao boi MP6029
			as ' + @sSQL)