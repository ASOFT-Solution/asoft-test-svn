
/****** Object:  StoredProcedure [dbo].[MP6500]    Script Date: 12/16/2010 14:02:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--Created by: Vo Thanh Huong, date: 18/06/2005
--purpose: In cao QLSX - Tong hop tinh hinh thuc hien san xuat, 

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE  [dbo].[MP6500] 
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
				@Status int,
				@Type int /*0: Tat ca, 
				1: Chi cong thuc te san xuat den thoi diem ky da chon va ca nhung LSX ky truoc 
					chua san xuat xong, hoac nhung LSX co:tinh trang = 2: da hoan tat nhung  ky nay co phat sinh
				2: Chi hien thi nhung LSX cua ky nay va san xuat den thoi diem hien tai */
AS
DECLARE  @sSQL nvarchar(4000),	
	@FromPeriod nvarchar(50),
	@ToPeriod nvarchar(50),	
	@sTime nvarchar(200),
	@sFromDate nvarchar(50),
	@sToDate nvarchar(50),
	@sWhere nvarchar(4000)

Select @FromPeriod =cast(@FromMonth +@FromYear*100 as nvarchar(20)) , 
	@ToPeriod =  cast(@ToMonth +@ToYear*100 as nvarchar(20)),
	@sFromDate = convert(nvarchar(20), @FromDate, 101),
	@sToDate = convert(nvarchar(20), @ToDate, 101)

Set @sTime = 	case when @IsDate = 1 then ' MT2001.VoucherDate between ''' + 
		convert(nvarchar(20), @FromDate, 103)  + ''' and ''' + 
		convert(nvarchar(20), @ToDate, 103)  else ' MT2001.TranMonth + MT2001.TranYear*100 between ' + 
		cast(@FromMonth +@FromYear*100 as nvarchar(20)) + ' and ' + cast(@ToMonth +@ToYear*100 as nvarchar(20)) end

Set @sSQL = --Ket qua san xuat thanh pham (Cong doan cuoi) cua ky nay
'Select MT2004.DivisionID, Max(VoucherDate) as ActualDate,
	MT2005.PLanID, InventoryID, isnull(LinkNo, '''') as LinkNo, WorkID, LevelID, Finish, 
	sum(ActualQuantity) as ActualQuantity
From MT2005 inner join MT2004 on MT2004.VoucherID = MT2005.VoucherID
Where 	MT2005.Finish = 1 and 
	MT2004.DivisionID like ''' + @DivisionID + ''' and ' + 
	case when @IsDate = 1 then  'MT2004.VoucherDate <= ''' + @sToDate  + ''''   else 
	'MT2004.TranMonth + MT2004.TranYear*100 <= ' + @ToPeriod  end + '  
Group by MT2004.DivisionID, MT2005.PLanID, InventoryID, isnull(LinkNo, ''''), WorkID, LevelID, Finish'

If  exists (Select top 1 1 From SysObjects Where name = 'MV6501' and Xtype ='V')
	DROP VIEW MV6501
Exec ('Create view MV6501 as '+@sSQL)

Set @sSQL = --Ket qua san xuat thanh pham (Cong doan cuoi) cua ky truoc 
'Select MT2004.DivisionID, Max(VoucherDate) as ActualDate,
	MT2005.PLanID, InventoryID, isnull(LinkNo, '''') as LinkNo, WorkID, LevelID, Finish,
	sum(ActualQuantity) as ActualQuantity
From MT2005 inner join MT2004 on MT2004.VoucherID = MT2005.VoucherID
Where 	MT2005.Finish = 1 and 
	MT2004.DivisionID like ''' + @DivisionID + ''' and ' + 
	case when @IsDate = 1 then  'MT2004.VoucherDate <= ''' + @sFromDate  + ''''   else 
	'MT2004.TranMonth + MT2004.TranYear*100 <= ' + @FromPeriod  end + '  
Group by MT2004.DivisionID, MT2005.PLanID, InventoryID, isnull(LinkNo, ''''), WorkID, LevelID, Finish'

If  exists (Select top 1 1 From SysObjects Where name = 'MV6502' and Xtype ='V')
	DROP VIEW MV6502
Exec ('Create view MV6502 as '+@sSQL)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Set @sSQL =  --LSX ky nay
'Select MT2002.DivisionID, MT2001.VoucherNo as  PlanNo, MT2001.VoucherDate as PlanDate, MT2001.SOderID as MOrderNo, MT2001.PlanStatus,
	MT2001.EmployeeID, AT1103.FullName,	MT2002.Notes as VDescription,
	MT2002.DepartmentID, AT1102.DepartmentName, MT2002.BeginDate, MT2002.Notes as TDescription,
	MT2002.InventoryID, AT1302.InventoryName, MT2002.UnitID,MT2002.PlanQuantity, 
	MT2002.WorkID, MT1701.WorkName, MT2002.LevelID,  MT1702.LevelName, MT2002.LinkNo,
	isnull(MT2005.ActualDate, '''') as ActualDate, isnull(MT2005.ActualQuantity, 0) as ActualQuantity

From MT2002 inner join MT2001 on MT2001.PlanID = MT2002.PlanID                   
	left join AT1103 on AT1103.EmployeeID = AT1103.EmployeeID and AT1103.DivisionID = MT2001.DivisionID 
	left join AT1102 on AT1102.DepartmentID = MT2002.DepartmentID and AT1102.DivisionID = MT2002.DepartmentID 		
	left join AT1302 on AT1302.InventoryID = MT2002.InventoryID
	left join MT1701 on  MT1701.WorkID = MT2002.WorkID 
	left join MT1702 on MT1702.WorkID = MT2002.WorkID and MT1702.LevelID = MT2002.LevelID
	left join (Select * From MV6501) MT2005 on MT2005.PlanID = MT2002.PlanID and MT2005.InventoryID = MT2002.InventoryID and 
	MT2002.LinkNo = case when isnull(MT2002.LinkNo, '''') <> '''' then MT2005.LinkNo  else MT2002.LinkNo end   and 
	MT2002.WorkID = case when isnull(MT2002.WorkID, '''') <> '''' then MT2005.WorkID else MT2002.WorkID  end and 
	MT2002.LevelID = case when isnull(MT2002.LevelID, '''') <> '''' then MT2005.LevelID else MT2002.LevelID end 
Where 	MT2002.Finish = 1 and 
	MT2002.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
	MT2001.DivisionID like ''' + @DivisionID + ''' and ' + 
	case when @IsDate = 1 then  'MT2001.VoucherDate between ''' + @sFromDate  + ''' and ''' + @sToDate + ''''   else 
	'MT2001.TranMonth + MT2001.TranYear*100 between ' + @FromPeriod + ' and ' + @ToPeriod   end  + 
 ---lay LSX ky truoc chua san xuat xong 
'Union
Select MT2002.DivisionID, MT2001.VoucherNo as  PlanNo, MT2001.VoucherDate as PlanDate, MT2001.SOderID as MOrderNo, MT2001.PlanStatus, 
	MT2001.EmployeeID, AT1103.FullName,	MT2002.Notes as VDescription,
	MT2002.DepartmentID, AT1102.DepartmentName, MT2002.BeginDate, MT2002.Notes as TDescription,
	MT2002.InventoryID, AT1302.InventoryName, MT2002.UnitID,MT2002.PlanQuantity, 
	MT2002.WorkID, MT1701.WorkName, MT2002.LevelID,  MT1702.LevelName, MT2002.LinkNo,
	isnull(MT2005.ActualDate, '''') as ActualDate, isnull(MT2005.ActualQuantity, 0) as ActualQuantity
From MT2002 inner join MT2001 on MT2001.PlanID = MT2002.PlanID                   
	left join AT1103 on AT1103.EmployeeID = AT1103.EmployeeID and AT1103.DivisionID = MT2001.DivisionID 
	left join AT1102 on AT1102.DepartmentID = MT2002.DepartmentID and AT1102.DivisionID = MT2002.DepartmentID 		
	left join AT1302 on AT1302.InventoryID = MT2002.InventoryID
	left join MT1701 on  MT1701.WorkID = MT2002.WorkID 
	left join MT1702 on MT1702.WorkID = MT2002.WorkID and MT1702.LevelID = MT2002.LevelID
	left join (Select * From MV6501) MT2005 on MT2005.PlanID = MT2002.PlanID and MT2005.InventoryID = MT2002.InventoryID and 
		MT2002.LinkNo = case when isnull(MT2002.LinkNo, '''') <> '''' then MT2005.LinkNo  else MT2002.LinkNo end   and 
		MT2002.WorkID = case when isnull(MT2002.WorkID, '''') <> '''' then MT2005.WorkID else MT2002.WorkID  end and 
		MT2002.LevelID = case when isnull(MT2002.LevelID, '''') <> '''' then MT2005.LevelID else MT2002.LevelID end 
	left join (Select * From MV6502) MT2005_2 on MT2005.PlanID = MT2002.PlanID and 
		MT2005_2.InventoryID = MT2002.InventoryID and 
		MT2002.LinkNo = case when isnull(MT2002.LinkNo, '''') <> '''' then MT2005_2.LinkNo  else MT2002.LinkNo end   and 
		MT2002.WorkID = case when isnull(MT2002.WorkID, '''') <> '''' then MT2005_2.WorkID else MT2002.WorkID  end and 
		MT2002.LevelID = case when isnull(MT2002.LevelID, '''') <> '''' then MT2005_2.LevelID else MT2002.LevelID end 
Where 	MT2002.Finish = 1 and 
	MT2002.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and 
	MT2002.DivisionID like ''' + @DivisionID + ''' and ' + 
	case when @IsDate = 1 then  'MT2001.VoucherDate <= ''' + @sFromDate  + ''''   else 
	'MT2001.TranMonth + MT2001.TranYear*100 <= ' + @FromPeriod  end + ' and 
	PlanQuantity - MT2005_2.ActualQuantity > 0 and MT2001.PlanStatus not in(4,9)'

If  exists (Select top 1 1 From SysObjects Where name = 'MV6500' and Xtype ='V')
	DROP VIEW MV6500
Exec ('Create view MV6500 as '+@sSQL)