IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3023]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3023]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- in bao cao chi tiet don hang san xuat
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 07/09/2004 by Vo Thanh Huong
---- 
---Created by: Vo Thanh Huong, date: 30/12/2004
--- 
-- Edit by: Thuy Tuyen, bo sung them MPT nghiep vu, date 11/05//2010
-- Edit by: Thien Huynh: Bo sung PeriodID, PeriodName -- Date 07/11/2011
---- Modified on 19/11/2011 by Le Thi Thu Hien : Bổ sung Note
---- Modified on 30/01/2013 by Le Thi Thu Hien : Bo sung tham so Nvarchar01->nvarchar10
--- Modify by Lê Thị Hạnh on 11/09/2014: Bổ sung Báo cáo Kế hoạch sản xuất cho Sài Gòn Petro (Customize Index: 36)
--- Modify by Lê Thị Hạnh on 15/01/2015: Thay đổi cách lấy dữ liệu đơn vị tính cho KHSX (Customize Index: 36)
--- Modified by Tiểu Mai on 09/09/2015: Bổ sung mã, tên MPT Ana06-->Ana10, 10 tham số S01ID --> S10ID
--- Modified by Tiểu Mai on 06/01/2016: Fix lỗi, bỏ SxxID
-- <Example> 
-- exec OP3023 @DivisionID=N'AS',@FromMonth=4,@ToMonth=4,@FromYear=2011,@ToYear=2012,@FromDate='2012-04-01 00:00:00',@ToDate='2012-04-30 00:00:00',@FromObjectID=N'243355677',@ToObjectID=N'SZ.0001',@IsDate=0,@IsGroup=0,@GroupID=N''
-- SELECT * FROM OV3023



CREATE PROCEDURE [dbo].[OP3023] 
				@DivisionID as nvarchar(50),
				@FromMonth as int,
				@ToMonth as int,
				@FromYear as int,
				@ToYear as int,
				@FromDate as datetime,
				@ToDate as datetime,
				@FromObjectID as nvarchar(50),
				@ToObjectID as nvarchar(50),				
				@IsDate as tinyint,
				@IsGroup as tinyint,
				@GroupID nvarchar(50) -- GroupID: OB, CI1, CI2, CI3, I01, I02, I03, I04, I05		
 AS

DECLARE @CustomerName INT = -1
--Tạo bảng tạm để kiểm tra đây có phải là khách hàng Sài Gòn Petro không (CustomerName = 36)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName) 
 
DECLARE @sSQL nvarchar(max),
		@GroupField nvarchar(20),
		@sFROM nvarchar(max),
		@sSELECT nvarchar(max),
		@sWHERE nvarchar(max), 
		@FromMonthYearText NVARCHAR(20), 
		@ToMonthYearText NVARCHAR(20), 
		@FromDateText NVARCHAR(20), 
		@ToDateText NVARCHAR(20)
    
SET @FromMonthYearText = STR(@FromMonth + @FromYear * 12)
SET @ToMonthYearText = STR(@ToMonth + @ToYear * 12)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'

Select @sFROM = '',  @sSELECT = ''
Set @sSQL = '
SELECT DISTINCT  T04.SOrderID, InventoryID, LinkNo, max(T01.VoucherDate) as ActualDate, sum(isnull(ActualQuantity, 0)) as ActualQuantity
FROM		MT2005 T00 
INNER JOIN MT2004 T01 on T00.VoucherID = T00.VoucherID   and VoucherTypeID = ''GTP''
INNER JOIN	MT2001 T02 on  T02.PlanID = T00.PlanID 
INNER JOIN	OT2001 T04 on T04.SOrderID = T02.SOderID 
WHERE 		T00.DivisionID = ''' + @DivisionID + ''' 			
GROUP BY	T04.SOrderID, InventoryID, LinkNo'	 

IF EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV3025')
	DROP VIEW OV3025
EXEC('CREATE VIEW OV3025---tao boi OP3023
		as ' + @sSQL)

IF @IsGroup  = 1 
	BEGIN
	Exec AP4700  	@GroupID,	@GroupField OUTPUT
	Select @sFROM = @sFROM + ' left join AV6666 V1 on V1.SelectionType = ''' + @GroupID + ''' and V1.SelectionID = OV2300.' + @GroupField,
		@sSELECT = @sSELECT + ', 
		V1.SelectionID as GroupID, V1.SelectionName as GroupName'
				
	END
ELSE
	Set @sSELECT = @sSELECT +  ', 
		'''' as GroupID, '''' as GroupName'	

Set @sSQL = '
SELECT  DISTINCT 
		OV2300.DivisionID,
		OV2300.OrderID as SOrderID,  
		OV2300.VoucherNo,           
		OV2300.VoucherDate as OrderDate,
		OV2300.ObjectID,
		OV2300.ObjectName,
		OV2300.LinkNo,
		OV2300.Orders,
		OV2300.InventoryID, 
		OV2300.InventoryName, 
		OV2300.Specification,
		OV2300.InventoryTypeID,
		OV2300.UnitName,
		OV2300.OrderQuantity,
		OV2300.SalePrice,
		OV2300.TotalOriginalAmount as TOriginalAmount,
		OV2300.TotalConvertedAmount as TConvertedAmount,
		OV2300.ShipDate as EndDate,
		OV3025.ActualQuantity,
		OV3025.ActualDate,
		OV2300.Ana01ID, OV2300.Ana02ID, OV2300.Ana03ID, OV2300.Ana04ID, OV2300.Ana05ID,
		OV2300.AnaName01, OV2300.AnaName02, OV2300.AnaName03,OV2300.AnaName04, OV2300.AnaName05,
		OV2300.PeriodID, OV2300.PeriodName, 	
		case when isnull(OV2300.ShipDate, '''') = '''' or isnull(OV3025.ActualDate, '''') = '''' then 0 else 
		Datediff(day, OV2300.VoucherDate, OV3025.ActualDate) end as AfterDayAmount, 
		(OV2300.OrderQuantity - isnull(OV3025.ActualQuantity, 0) + isnull(OV2300.AdjustQuantity, 0)) as RemainQuantity,
		OV2300.VDescription AS Note,
		OV2300.nvarchar01,OV2300.nvarchar02,OV2300.nvarchar03,OV2300.nvarchar04,OV2300.nvarchar05,
		OV2300.nvarchar06,OV2300.nvarchar07,OV2300.nvarchar08,OV2300.nvarchar09,OV2300.nvarchar10,
		OV2300.Ana06ID, OV2300.Ana07ID, OV2300.Ana08ID, OV2300.Ana09ID, OV2300.Ana10ID,
		OV2300.AnaName06, OV2300.AnaName07, OV2300.AnaName08,OV2300.AnaName09, OV2300.AnaName10
		--OV2300.S01ID, OV2300.S02ID, OV2300.S03ID, OV2300.S04ID, OV2300.S05ID, OV2300.S06ID, OV2300.S07ID, OV2300.S08ID, OV2300.S09ID, OV2300.S10ID
		' + @sSELECT  + '
FROM		OV2300 
LEFT JOIN	OV3025  on Right(OV3025.InventoryID, len(OV3025.InventoryID)-2) = Right(OV2300.InventoryID, len(OV3025.InventoryID)-2)  
			AND isnull(OV3025.LinkNo, '''')  = isnull(OV2300.LinkNo, '''') 
			AND OV3025.SOrderID = OV2300.OrderID  
' + @sFROM + '
WHERE		OV2300.OrderType = 1 
			AND OV2300.DivisionID = ''' + @DivisionID + ''' 
			AND ' + CASE WHEN @IsDate = 1 then ' OV2300.VoucherDate  between ''' + @FromDateText + ''' and ''' +  @ToDateText + ''''
						else 	' OV2300.TranMonth + OV2300.TranYear*12 between ' +  @FromMonthYearText +  ' and ' + @ToMonthYearText  end 

IF EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV3023')
	DROP VIEW OV3023
EXEC('CREATE VIEW OV3023 ---tao boi OP3023
		AS ' + @sSQL)
----- Báo cáo Kế hoạch sản xuất cho Sài Gòn Petro (Customize Index: 36)
IF @CustomerName = 36 
BEGIN
	IF LTRIM(STR(@IsDate)) = 1	SET @sWHERE = 
	'AND CONVERT(VARCHAR(10),OT21.OrderDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
	IF LTRIM(STR(@IsDate)) = 0	SET @sWHERE = 
	'AND (OT21.TranYear*12 + OT21.TranMonth) BETWEEN '+LTRIM(STR(@FromYear*12 + @FromMonth))+' AND '+LTRIM(STR(@ToYear*12 + @ToMonth))+' '
/*
SELECT ''1'' as [Group], ROW_NUMBER() OVER (PARTITION BY OT22.UnitID + rtrim(OT21.OrderDate) ORDER BY OT21.OrderDate) RowNum,
	OT21.OrderDate, OT22.InventoryID, AT12.InventoryName,
	OT22.UnitID AS ConvertedUnitID, ISNULL(AT19.ConversionFactor,1) as ConversionFactor, 
	RTRIM(convert(int,ISNULL(AT19.ConversionFactor,1))) + AT12.UnitID AS ConvertedUnitSTD,
	OT22.[Description],
    SUM(OT22.OrderQuantity) AS OrderQuantity, SUM(OT22.ConvertedQuantity) AS ConvertedQuantity
FROM OT2001 OT21 
INNER JOIN OT2002 OT22 ON OT22.DivisionID = OT21.DivisionID AND OT22.SOrderID = OT21.SOrderID
INNER JOIN AT1302 AT12 ON AT12.DivisionID = OT22.DivisionID AND AT12.InventoryID = OT22.InventoryID
LEFT JOIN AT1309 AT19 ON AT19.DivisionID = OT22.DivisionID AND AT19.InventoryID = OT22.InventoryID AND AT19.UnitID = OT22.UnitID
WHERE OT21.DivisionID = '''+@DivisionID+''' 
---	AND OT21.ObjectID BETWEEN N'''+@FromObjectID+''' AND N'''+@ToObjectID+''' 
	AND OT21.OrderType = 1 '+@sWHERE+' 
GROUP BY OT21.OrderDate,OT22.InventoryID, AT12.InventoryName, 
	   AT19.ConversionFactor, AT12.UnitID, OT22.UnitID, OT22.[Description]
ORDER BY ConversionFactor, ConvertedUnitSTD, OT21.OrderDate, OT22.InventoryID, OT22.UnitID
*/
	SET @sSQL = N'
SELECT ROW_NUMBER() OVER (PARTITION BY OT22.InventoryID + RTRIM(OT21.OrderDate) ORDER BY OT21.OrderDate) RowNum,
	OT21.OrderDate, OT22.InventoryID, AT12.InventoryName, AT12.UnitID AS UnitID, OT22.UnitID AS ConvertedUnitID, 
	(CASE WHEN ISNUMERIC(AT12.Notes02) = 0 OR AT12.Notes02 LIKE ''.'' OR AT12.Notes02 LIKE ''%e%'' OR AT12.Notes02 LIKE ''%-%'' THEN 0 
		     ELSE CONVERT(DECIMAL(28,8),AT12.Notes02) END) AS Notes02, OT22.[Description],
    SUM(ISNULL(OT22.OrderQuantity,0)) AS OrderQuantity, 
	SUM(CASE WHEN ISNULL(OT22.ConvertedQuantity,0) <> 0 THEN ISNULL(OT22.ConvertedQuantity,0) ELSE ISNULL(OT22.OrderQuantity,0) END) AS ConvertedQuantity
FROM OT2001 OT21 
INNER JOIN OT2002 OT22 ON OT22.DivisionID = OT21.DivisionID AND OT22.SOrderID = OT21.SOrderID
INNER JOIN AT1302 AT12 ON AT12.DivisionID = OT22.DivisionID AND AT12.InventoryID = OT22.InventoryID
WHERE OT21.DivisionID = '''+@DivisionID+''' AND OT21.OrderType = 1 
---	AND OT21.ObjectID BETWEEN N'''+@FromObjectID+''' AND N'''+@ToObjectID+''' 
	  '+@sWHERE+' 
GROUP BY OT21.OrderDate, OT22.InventoryID, AT12.InventoryName, AT12.UnitID, OT22.UnitID, AT12.Notes02, OT22.[Description]
ORDER BY OT21.OrderDate, OT22.InventoryID, OT22.UnitID
	'
	EXEC (@sSQL)
	PRINT(@sSQL)
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
