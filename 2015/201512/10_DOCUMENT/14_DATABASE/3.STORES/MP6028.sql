
/****** Object:  StoredProcedure [dbo].[MP6028]    Script Date: 12/16/2010 14:00:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

---Created by: Vo Thanh Huong, date: 12/06/2005
---purpose: IN bao cao QLSX > Tong hop tinh hinh san xuat thanh pham -Dang 2: Ket qua san xuat toi thoi diem xem bao cao 

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP6028]  @DivisionID nvarchar(50),
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
		@FromPeriod nvarchar(50),
		@ToPeriod nvarchar(50),
		@sFromDate nvarchar(50),
		@sToDate nvarchar(50)
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MT6022]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
Begin
CREATE TABLE [dbo].[MT6022](
	[APK] [uniqueidentifier] NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[PlanID] [nvarchar](50) NULL,
	[PlanDetailID] [nvarchar](50) NULL,
 CONSTRAINT [PK_MT6022] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[MT6022] ADD  DEFAULT (newid()) FOR [APK]
End
ELSE 
	DELETE MT6022

Select @sWHERE = '', @sSQL = '', @FromPeriod = cast(@FromMonth + @FromYear*100 as nvarchar(20)) , 
		@ToPeriod = cast(@ToMonth + @ToYear*100 as nvarchar(20)),
		@sFromDate = convert(nvarchar(20), @FromDate, 101),
		@sToDate = convert(nvarchar(20), @ToDate, 101) + ' 23:59:59'
		
Set @sWHERE = ' and '+ case when @IsDate = 1 then ' MT2001.VoucherDate between ''' + @sFromDate + ''' and ''' + @sToDate + '''' 
		else ' MT2001.TranMonth + MT2001.TranYear*100 between ' + @FromPeriod + ' and ' + 
		@ToPeriod end


----Lay  nhung LSX, MSK, Mat hang ky truoc chua san xuat xong  loai tru nhung LSX tinh trng 4, 9
----- va nhung LSX co tinh trang 4,9 nhung ky nay co san xuat
Set @sSQL = '
INSERT MT6022 (DivisionID, PlanID, PlanDetailID) 
Select Distinct MT2002.DivisionID,MT2002.PlanID, MT2002.PlanDetailID
From 	MT2002 inner join MT2001 on MT2001.PlanID = MT2002.PlanID and  MT2001.DivisionID = MT2002.DivisionID and MT2002.Finish = 1 
	left join (Select 	MT2005.DivisionID,MT2005.PlanID, 
		MT2005.InventoryID, 
		isnull(MT2005.LinkNo, '''') as LinkNo,
		MT2005.WorkID, 
		MT2005.LevelID, 
		sum(isnull(ActualQuantity, 0)) as ActualQuantity		
	From MT2005 inner join MT2004 on  MT2004.VoucherID = MT2005.VoucherID and  MT2004.DivisionID = MT2005.DivisionID 
	Where  Isnull(MT2005.PlanID, '''') <> ''''  and MT2005.DivisionID like ''' + @DivisionID + '''   and ' + 
		case when @IsDate = 1 then ' MT2004.VoucherDate < ' + @sFromDate  else
		 ' MT2004.TranMonth + MT2004.TranYear*100 < ' + @FromPeriod end + '
	Group by MT2005.DivisionID,MT2005.PlanID, 
		MT2005.InventoryID, 
		isnull(MT2005.LinkNo, ''''),
		MT2005.WorkID, 
		MT2005.LevelID) MT2005 
	on MT2005.PlanID = MT2002.PlanID and MT2005.DivisionID = MT2002.DivisionID and 
	isnull(MT2005.LinkNo, '''') = isnull(MT2002.LinkNo, '''') and 
	isnull(MT2005.WorkID, '''') = isnull(MT2002.WorkID, '''') and 
	isnull(MT2005.LevelID, '''') = isnull(MT2002.LevelID, '''') and
	MT2005.InventoryID = MT2002.InventoryID
Where MT2002.DivisionID = ''' + @DivisionID + ''' and ' +	
	case when @IsDate = 1 then ' MT2001.VoucherDate < ' + @sFromDate  else
	 ' MT2001.TranMonth + MT2001.TranYear*100 < ' + @FromPeriod end + ' and 
	MT2001.PlanStatus not in(4, 9) and  
	isnull(MT2002.DepartmentID, ''' + @FromDepartmentID + ''') between N''' + @FromDepartmentID + ''' and N''' + @ToDepartmentID +  ''' and 	
	MT2002.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''' and 
	MT2002.PlanQuantity > MT2005.ActualQuantity
Union
Select Distinct MT2002.DivisionID,MT2002.PlanID, MT2002.PlanDetailID
From MT2002 inner join MT2001 on MT2001.PlanID = MT2002.PlanID and MT2001.DivisionID = MT2002.DivisionID and MT2002.Finish = 1
Where MT2002.DivisionID = ''' + @DivisionID +  ''' and 
	isnull(MT2002.DepartmentID, ''' +@FromDepartmentID + ''') between N''' + @FromDepartmentID + ''' and N''' + @ToDepartmentID +  ''' and 	
	MT2002.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + ''' and   
	PlanDetailID in (Select Distinct PlanDetailID From MT2002 inner join MT2001 on MT2001.PlanID = MT2002.PlanID and MT2001.DivisionID = MT2002.DivisionID
		inner join (Select Distinct MT2005.DivisionID, PlanID, InventoryID, LinkNo, WorkID, LevelID
		From MT2005 inner join MT2004 on MT2004.VoucherID = MT2005.VoucherID and MT2004.DivisionID = MT2005.DivisionID
		Where MT2004.DivisionID = ''' + @DivisionID + ''' and ' +
		case when @IsDate = 1 then ' MT2004.VoucherDate between ''' + @sFromDate + ''' and ''' + @sToDate + '''' 
		else ' MT2004.TranMonth + MT2004.TranYear*100 between ' + @FromPeriod + ' and ' + 
		@ToPeriod end + ') MT2005  on MT2005.PlanID = MT2002.PlanID and 
		isnull(MT2005.LinkNo, '''') = isnull(MT2002.LinkNo, '''') and 
		isnull(MT2005.WorkID, '''') = isnull(MT2002.WorkID, '''') and 
		isnull(MT2005.LevelID, '''') = isnull(MT2002.LevelID, '''') and
		MT2005.InventoryID = MT2002.InventoryID and MT2005.DivisionID = MT2002.DivisionID
	Where MT2001.DivisionID = ''' + @DivisionID + '''' + @sWHERE+')'
EXEC(@sSQL)
/*
If  exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV6028')
	DROP VIEW MV6028
EXEC('Create view MV6028 ---tao boi MP6028
	as ' + @sSQL)       				
*/

print @sSQL

EXEC MP6020   @DivisionID,	1,	1990,	@ToMonth,	@ToYear,	'01/01/1990',	'01/01/1990',	@IsDate,
		@FromDepartmentID, 	@ToDepartmentID,	'%' , NULL, 0

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

From MT2002 inner join MT2001 on MT2002.PlanID = MT2001.PlanID and  MT2002.DivisionID = MT2001.DivisionID  and MT2002.Finish = 1 
	left join AT1302 on AT1302.InventoryID = MT2002.InventoryID  and  MT2002.DivisionID = AT1302.DivisionID
	left join AT1304 on AT1304.UnitID = MT2002.UnitID  and  MT2002.DivisionID = AT1304.DivisionID
	left join AT1102 on AT1102.DepartmentID = MT2002.DepartmentID and AT1102.DivisionID = MT2002.DivisionID
	left join MT1702 on MT1702.LevelID = MT2002.LevelID and MT1702.WorkID = MT2002.WorkID and  MT2002.DivisionID = MT1702.DivisionID
	left join (Select DivisionID, PlanID, PlanDetailID, max(EndDate) as EndDate From  MT6007 Group by  DivisionID,PlanID, PlanDetailID) MT6007 on
		MT6007.PlanID = MT2002.PlanID and MT6007.PlanDetailID = MT2002.PlanDetailID and MT6007.DivisionID = MT2002.DivisionID
	left join (Select 	MT2005.DivisionID, max(MT2004.VoucherDate) as ActualDate,
		MT2005.PlanID, 
		MT2005.InventoryID, 
		isnull(MT2005.LinkNo, '''') as LinkNo,
		MT2005.WorkID, 
		MT2005.LevelID, 
		sum(isnull(ActualQuantity, 0)) as ActualQuantity		
	From MT2005 inner join MT2004 on  MT2004.VoucherID = MT2005.VoucherID  and MT2004.DivisionID = MT2005.DivisionID
	Where  Isnull(MT2005.PlanID, '''') <> ''''  and MT2005.DivisionID like ''' + @DivisionID + '''   and ' + 
		case when @IsDate = 1 then ' MT2004.VoucherDate <= ''' + @sToDate + '''' else '
			MT2004.TranMonth + MT2004.TranYear*100 <= ' 	+ @ToPeriod end + '	
	Group by MT2005.DivisionID, MT2005.PlanID, 
		MT2005.InventoryID, 
		isnull(MT2005.LinkNo, ''''),
		MT2005.WorkID, 
		MT2005.LevelID) MT2005 on MT2005.PlanID = MT2002.PlanID and 
		isnull(MT2005.LinkNo, '''') = isnull(MT2002.LinkNo, '''') and 
		isnull(MT2005.WorkID, '''') = isnull(MT2002.WorkID, '''') and 
		isnull(MT2005.LevelID, '''') = isnull(MT2002.LevelID, '''') and
		MT2005.InventoryID = MT2002.InventoryID and MT2005.DivisionID = MT2002.DivisionID
Where (MT2001.DivisionID like ''' + @DivisionID + ''' and 
	isnull(MT2002.DepartmentID, ''' + @FromDepartmentID + ''') between N''' + @FromDepartmentID + ''' and N''' + @ToDepartmentID +  ''' and 	
	MT2002.InventoryID between N''' + @FromInventoryID + ''' and N''' + @ToInventoryID + '''
	'  +  @sWHERE + ')' + 	' 
	or  MT2002.PlanDetailID in (Select Distinct  PlanDetailID From MT6022 MV6028) '



If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV6027')
	Drop view MV6027

EXEC('Create view MV6027 --tao boi MP6028
		as ' + @sSQL)