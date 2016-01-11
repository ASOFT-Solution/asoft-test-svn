IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP6026]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP6026]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---Created by: Vo Thanh Huong, date: 12/06/2005
---purpose: IN bao cao QLSX > Tong hop  tinh hinh thuc hien ke hoach san xuat ----------Dang 2: Ket qua san xuat toi thoi diem xem bao cao 

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/
-- Last Edit 01/03/2013 by Thiên Huỳnh: Đa chi nhánh
--- Modified on 10/09/2015 by Tiểu Mai: Bổ sung lấy 10 MPT, 10 Tham số ở đơn hàng sản xuất, ngày nhận hàng cuối cùng ở kế hoạch sản xuất.

CREATE PROCEDURE [dbo].[MP6026]  @DivisionID nvarchar(50),
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
		@sSQL1 NVARCHAR(4000),	
		@sWHERE nvarchar(500),
		@FromPeriod nvarchar(50),
		@ToPeriod nvarchar(50),
		@sFromDate nvarchar(50),
		@sToDate nvarchar(50)

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MT6022]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE TABLE [dbo].[MT6022](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(50) NOT NULL,
	[PlanID] [nvarchar](50) NULL,
	[PlanDetailID] [nvarchar](50) NULL,
	CONSTRAINT [PK_MT6022] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

) ON [PRIMARY]

ELSE 
	DELETE MT6022


Select @sWHERE = '', @sSQL = '', @FromPeriod = cast(@FromMonth + @FromYear*100 as nvarchar(50)) , 
		@ToPeriod = cast(@ToMonth + @ToYear*100 as nvarchar(50)),
		@sFromDate = convert(nvarchar(50), @FromDate, 101),
		@sToDate = convert(nvarchar(50), @ToDate, 101)  + ' 23:59:59'
		
Set @sWHERE = ' and '+ case when @IsDate = 1 then ' MT2001.VoucherDate between ''' + @sFromDate + ''' and ''' + @sToDate + '''' 
		else ' MT2001.TranMonth + MT2001.TranYear*100 between ' + @FromPeriod + ' and ' + 
		@ToPeriod end


----Lay  nhung LSX, MSK, Mat hang ky truoc chua san xuat xong  loai tru nhung LSX tinh trng 4, 9
----- va nhung LSX co tinh trang 4,9 nhung ky nay co san xuat
Set @sSQL = '
INSERT MT6022 (DivisionID, PlanID, PlanDetailID) 
Select Distinct MT2002.DivisionID, MT2002.PlanID, MT2002.PlanDetailID
From 	MT2002 inner join MT2001 on MT2001.PlanID = MT2002.PlanID and MT2002.Finish = 1 And MT2001.DivisionID = MT2002.DivisionID
	left join (Select 	MT2005.PlanID, 
		MT2005.InventoryID, 
		isnull(MT2005.LinkNo, '''') as LinkNo,
		isnull(MT2005.WorkID, '''') as WorkID,
		isnull(MT2005.LevelID, '''') as LevelID,
		sum(isnull(ActualQuantity, 0)) as ActualQuantity		
	From MT2005 inner join MT2004 on  MT2004.VoucherID = MT2005.VoucherID And MT2004.DivisionID = MT2005.DivisionID 
	Where  Isnull(MT2005.PlanID, '''') <> ''''  and MT2005.DivisionID like ''' + @DivisionID + '''   and ' + 
		case when @IsDate = 1 then ' MT2004.VoucherDate < ' + @sFromDate  else
		 ' MT2004.TranMonth + MT2004.TranYear*100 < ' + @FromPeriod end + '
	Group by MT2005.PlanID, 
		MT2005.InventoryID, 
		isnull(MT2005.LinkNo, ''''),
		isnull(MT2005.WorkID, ''''),
		isnull(MT2005.LevelID, '''') 
		) MT2005 
	on MT2005.PlanID = MT2002.PlanID and 
	isnull(MT2005.LinkNo, '''') = isnull(MT2002.LinkNo, '''') and 
	isnull(MT2005.WorkID, '''') = isnull(MT2002.WorkID, '''') and 
	isnull(MT2005.LevelID, '''') = isnull(MT2002.LevelID, '''') and
	MT2005.InventoryID = MT2002.InventoryID
Where MT2002.DivisionID = ''' + @DivisionID + ''' and 
	isnull(MT2002.DepartmentID, ''' + @FromDepartmentID + ''') between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and 
	MT2002.InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''' and ' + 
	case when @IsDate = 1 then ' MT2001.VoucherDate < ' + @sFromDate  else
	' MT2001.TranMonth + MT2001.TranYear*100 < ' + @FromPeriod end + ' and 
	MT2001.PlanStatus not in(4, 9) and  
	MT2002.PlanQuantity*0.9 > MT2005.ActualQuantity
Union
Select Distinct MT2002.DivisionID, MT2002.PlanID, MT2002.PlanDetailID
From MT2002 inner join MT2001 on MT2001.PlanID = MT2002.PlanID And MT2001.DivisionID = MT2002.DivisionID
Where MT2002.DivisionID = ''' + @DivisionID +  ''' and 
	isnull(MT2002.DepartmentID, ''' + @FromDepartmentID + ''') between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and 
	MT2002.InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''' and 
	PlanDetailID in (Select Distinct PlanDetailID From MT2002 inner join MT2001 on MT2001.PlanID = MT2002.PlanID And MT2001.DivisionID = MT2002.DivisionID
		inner join (Select Distinct PlanID, InventoryID, LinkNo, WorkID, LevelID
		From MT2005 inner join MT2004 on MT2004.VoucherID = MT2005.VoucherID And MT2004.DivisionID = MT2005.DivisionID
		Where MT2004.DivisionID = ''' + @DivisionID + ''' and ' +
		case when @IsDate = 1 then ' MT2004.VoucherDate between ''' + @sFromDate + ''' and ''' + @sToDate + '''' 
		else ' MT2004.TranMonth + MT2004.TranYear*100 between ' + @FromPeriod + ' and ' + 
		@ToPeriod end + ') MT2005  on MT2005.PlanID = MT2002.PlanID and 
		isnull(MT2005.LinkNo, '''') = isnull(MT2002.LinkNo, '''') and 
		isnull(MT2005.WorkID, '''') = isnull(MT2002.WorkID, '''') and 
		isnull(MT2005.LevelID, '''') = isnull(MT2002.LevelID, '''') and 
		MT2005.InventoryID = MT2002.InventoryID
	Where MT2001.DivisionID = ''' + @DivisionID + '''' + @sWHERE+')'

Print @sSQL

EXEC(@sSQL)
/*
If  exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV6026')
	DROP VIEW MV6026
EXEC('Create view MV6026 ---tao boi MP6026
	as ' + @sSQL)       				
*/

EXEC MP6020   @DivisionID,	1,		1990,	@ToMonth,	@ToYear,	'01/01/1990',	'01/01/1990',	@IsDate,
		@FromDepartmentID, 	@ToDepartmentID,	'%' , NULL, 0

Set @sSQL = '
Select distinct	MT2002.DivisionID, MT2001.PlanID as VoucherID,
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
	MT2003.Maxdate,
	OT2002.S01ID, OT2002.S02ID, OT2002.S03ID, OT2002.S04ID, OT2002.S05ID,
	OT2002.S06ID, OT2002.S07ID, OT2002.S08ID, OT2002.S09ID, OT2002.S10ID,
	OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID,
	OT2002.Ana06ID, OT2002.Ana07ID, OT2002.Ana08ID, OT2002.Ana09ID, OT2002.Ana10ID,
	A1.AnaName as Ana01Name,
	A2.AnaName as Ana02Name,
	A3.AnaName as Ana03Name,
	A4.AnaName as Ana04Name,
	A5.AnaName as Ana05Name,
	A6.AnaName as Ana06Name,
	A7.AnaName as Ana07Name,
	A8.AnaName as Ana08Name,
	A9.AnaName as Ana09Name,
	A10.AnaName as Ana10Name
From MT2002 inner join MT2001 on MT2002.PlanID = MT2001.PlanID And MT2002.DivisionID = MT2001.DivisionID 
	left join AT1302 on AT1302.InventoryID = MT2002.InventoryID And AT1302.DivisionID = MT2002.DivisionID 
	left join AT1304 on AT1304.UnitID = MT2002.UnitID And AT1304.DivisionID = MT2002.DivisionID 
	left join AT1102 on AT1102.DepartmentID = MT2002.DepartmentID and AT1102.DivisionID = MT2002.DivisionID
	left join MT1702 on MT1702.LevelID = MT2002.LevelID and MT1702.WorkID = MT2002.WorkID And MT1702.DivisionID = MT2002.DivisionID
	LEFT JOIN OT2002 ON OT2002.DivisionID = MT2001.DivisionID AND OT2002.QuotationID = MT2001.SOderID
	left join AT1011 A1 on A1.AnaTypeID = ''A01'' and A1.AnaID = OT2002.Ana01ID  and A1.DivisionID= OT2002.DivisionID
	left join AT1011 A2 on A2.AnaTypeID = ''A02'' and A2.AnaID = OT2002.Ana02ID  and A2.DivisionID= OT2002.DivisionID
	left join AT1011 A3 on A3.AnaTypeID = ''A03'' and A3.AnaID = OT2002.Ana03ID  and A3.DivisionID= OT2002.DivisionID
	left join AT1011 A4 on A4.AnaTypeID = ''A04'' and A4.AnaID = OT2002.Ana04ID  and A4.DivisionID= OT2002.DivisionID
	left join AT1011 A5 on A5.AnaTypeID = ''A05'' and A5.AnaID = OT2002.Ana05ID  and A5.DivisionID= OT2002.DivisionID
	left join AT1011 A6 on A6.AnaTypeID = ''A06'' and A6.AnaID = OT2002.Ana06ID  and A6.DivisionID= OT2002.DivisionID
	left join AT1011 A7 on A7.AnaTypeID = ''A07'' and A7.AnaID = OT2002.Ana07ID  and A7.DivisionID= OT2002.DivisionID
	left join AT1011 A8 on A8.AnaTypeID = ''A08'' and A8.AnaID = OT2002.Ana08ID  and A8.DivisionID= OT2002.DivisionID
	left join AT1011 A9 on A9.AnaTypeID = ''A09'' and A9.AnaID = OT2002.Ana09ID  and A9.DivisionID= OT2002.DivisionID
	left join AT1011 A10 on A10.AnaTypeID = ''A10'' and A10.AnaID = OT2002.Ana10ID  and A10.DivisionID= OT2002.DivisionID	
	 ' 
SET @sSQL1 = '
	LEFT JOIN (select  (select MAX(v) from (Values(MT2003.Date01),(MT2003.Date02),(MT2003.Date03),(MT2003.Date04),(MT2003.Date05),(MT2003.Date06),(MT2003.Date07),(MT2003.Date08),(MT2003.Date09),
											(MT2003.Date10),(MT2003.Date11),(MT2003.Date12),(MT2003.Date13),(MT2003.Date14),(MT2003.Date15),(MT2003.Date16),(MT2003.Date17),(MT2003.Date18),
											(MT2003.Date19),(MT2003.Date20),(MT2003.Date21),(MT2003.Date22),(MT2003.Date23),(MT2003.Date24),(MT2003.Date25),(MT2003.Date26),(MT2003.Date27),
											(MT2003.Date28),(MT2003.Date29),(MT2003.Date30))as value(v)) as Maxdate, PlanID, DivisionID from MT2003) MT2003 ON MT2003.DivisionID = MT2002.DivisionID AND MT2003.PlanID = MT2002.PlanID
		left join (Select DivisionID, PlanID, PlanDetailID, max(EndDate) as EndDate From  MT6007 Group by  DivisionID, PlanID, PlanDetailID) MT6007 on
			MT6007.PlanID = MT2002.PlanID and MT6007.PlanDetailID = MT2002.PlanDetailID And MT6007.DivisionID = MT2002.DivisionID
		left join (Select 	max(MT2004.VoucherDate) as ActualDate,
			MT2005.PlanID, 
			MT2005.InventoryID, 
			isnull(MT2005.LinkNo, '''') as LinkNo,
			MT2005.WorkID, 
			MT2005.LevelID, 
			sum(isnull(ActualQuantity, 0)) as ActualQuantity		
		From MT2005 inner join MT2004 on  MT2004.VoucherID = MT2005.VoucherID And MT2004.DivisionID = MT2005.DivisionID 
		Where  Isnull(MT2005.PlanID, '''') <> ''''  and MT2005.DivisionID like ''' + @DivisionID + '''   and ' + 
			case when @IsDate = 1 then ' MT2004.VoucherDate <= ''' + @sToDate + '''' else '
				MT2004.TranMonth + MT2004.TranYear*100 <= ' 	+ @ToPeriod end + '	
		Group by MT2005.PlanID, 
			MT2005.InventoryID, 
			isnull(MT2005.LinkNo, ''''),
			MT2005.WorkID, 
			MT2005.LevelID) MT2005 on MT2005.PlanID = MT2002.PlanID and 
			isnull(MT2005.LinkNo, '''') = isnull(MT2002.LinkNo, '''') and 
			isnull(MT2005.WorkID, '''') = isnull(MT2002.WorkID, '''') and 
			isnull(MT2005.LevelID, '''') = isnull(MT2002.LevelID, '''') and
			MT2005.InventoryID = MT2002.InventoryID
	Where (MT2001.DivisionID like ''' + @DivisionID + ''' and 
		isnull(MT2002.DepartmentID, ''' + @FromDepartmentID + ''') between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID +  ''' and 	
		MT2002.InventoryID between ''' + @FromInventoryID + ''' and ''' + @ToInventoryID + ''' 
		' +  @sWHERE + ') 
		or  MT2002.PlanDetailID in (Select Distinct  PlanDetailID From MT6022 MV6026)'

--Print @sSQL

If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV6025')
	Drop view MV6025

EXEC('Create view MV6025 --tao boi MP6026
		as ' + @sSQL+@sSQL1)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
