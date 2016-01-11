IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3027]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP3027]
/****** Object:  StoredProcedure [dbo].[OP3027]    Script Date: 08/02/2010 11:56:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- Create By: Dang Le Bao Quynh; Date 20/11/2009
-- Purpose: In bao cao so sanh du tru va tinh hinh xuat kho thu te

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/
-- <History>
---- Modified on 29/09/2014 by Lê Thị Hạnh 
----- In báo cáo Tình hình xuất vật tư[Customize Index: 36 - Sài Gòn Petro]
----- Moified on 04/11/2014 by Lê Thị Hạnh: Thay đổi cách lấy thông tin dự trù của dầu gốc và phụ gia [Customize Index: 36 - Sài Gòn Petro]
---- Modified on ... by 
-- <Example>
/* OP3027 @DivisionID = 'AP', @FromTranMonth = 9, @FromTranYear = 2014, @ToTranMonth = 9, @ToTranYear = 2014, 
@IsDate = 0, @FromDate = '2014-09-10', @ToDate = '2014-09-30'
*/

CREATE PROCEDURE [dbo].[OP3027] 
	@DivisionID nvarchar(50),
	@FromTranMonth int,
	@FromTranYear int,
	@ToTranMonth int,
	@ToTranYear int,
	@IsDate tinyint,
	@FromDate datetime,
	@ToDate datetime
	
AS

DECLARE @CustomerName INT
--Tạo bảng tạm để kiểm tra đây có phải là khách hàng Sài Gòn Petro không (CustomerName = 36)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName) 

Declare @sSQL nvarchar(4000), 
    @FromMonthYearText NVARCHAR(20), 
    @ToMonthYearText NVARCHAR(20), 
    @FromDateText NVARCHAR(20), 
    @ToDateText NVARCHAR(20),
    @sWHERE NVARCHAR(MAX)
    
SET @FromMonthYearText = STR(@FromTranMonth + @FromTranYear * 12)
SET @ToMonthYearText = STR(@ToTranMonth + @ToTranYear * 12)
SET @FromDateText = CONVERT(NVARCHAR(20), @FromDate, 101)
SET @ToDateText = CONVERT(NVARCHAR(20), @ToDate, 101) + ' 23:59:59'
If @IsDate = 0
	Set @sSQL = 
	'Select DivisionID,
	VoucherNo, VoucherDate, 
	ObjectID, ObjectName, 
	MaterialID, MaterialName, UnitID, 
	MaterialQuantity, InheritedQuantity, 
	EstimateExportDate, ExportDate, 
	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, 
	Ana01Name, Ana02Name, Ana03Name, Ana04Name, Ana05Name
	From WQ3027
	Where DivisionID = ''' + @DivisionID + ''' 
	And TranMonth +  TranYear * 12 Between ' + @FromMonthYearText + ' And ' + @ToMonthYearText
ELSE 
	Set @sSQL = 
	'Select DivisionID,
	VoucherNo, VoucherDate, 
	ObjectID, ObjectName, 
	MaterialID, MaterialName, UnitID, 
	MaterialQuantity, InheritedQuantity, 
	EstimateExportDate, ExportDate, 
	Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID, 
	Ana01Name, Ana02Name, Ana03Name, Ana04Name, Ana05Name
	From WQ3027
	Where DivisionID = ''' + @DivisionID + ''' 
	And VoucherDate Between ''' + @FromDateText + ''' And ''' + @ToDateText + ''''

If exists (Select Top 1 1 From sysObjects Where Id  = Object_ID('OV3027') And xType = 'V')
Exec ( 'Drop View OV3027')
Exec (' Create View OV3027 --- Create by OP3027
	As ' + @sSQL)
	
----- Báo cáo Tình hình xuất vật tư - Sài Gòn Petro (Customize Index: 36)
IF @CustomerName = 36 
BEGIN
	IF @IsDate = 1	SET @sWHERE = '
	AND CONVERT(VARCHAR(10),MT07.VoucherDate,112) BETWEEN '''+CONVERT(VARCHAR(10),@FromDate,112)+''' AND '''+CONVERT(VARCHAR(10),@ToDate,112)+''' '
	IF @IsDate = 0	SET @sWHERE = '
	AND (MT07.TranYear*12 + MT07.TranMonth) BETWEEN '+@FromMonthYearText+' AND '+@ToMonthYearText+' '
	SET @sSQL = '
SELECT MT07.DivisionID, '''' AS ObjectID, '''' AS ObjectName, OT21.VoucherNo, OT21.OrderDate AS VoucherDate, MT08.MaterialID, 
       AT12.InventoryName AS MaterialName, AT12.UnitID,
       MT08.WeightTotal AS MaterialQuantity, SUM(ISNULL(AT27.ActualQuantity,0)) AS InheritedQuantity, 
       MT07.VoucherDate AS EstimateExportDate, AT26.VoucherDate AS ExportDate
FROM MT0107 MT07
INNER JOIN MT0108 MT08 ON MT08.DivisionID = MT07.DivisionID AND MT08.VoucherID = MT07.VoucherID
LEFT JOIN OT2001 OT21 ON OT21.DivisionID = MT07.DivisionID AND OT21.SOrderID = MT07.MOVoucherID
LEFT JOIN MT2001 MT21 ON MT21.DivisionID = MT07.DivisionID AND MT21.MixVoucherID = MT07.VoucherID
LEFT JOIN AT2007 AT27 ON AT27.DivisionID = MT21.DivisionID AND AT27.InheritTableID = ''MT2001'' AND AT27.InheritVoucherID = MT21.PlanID AND AT27.InheritTransactionID = MT08.TransactionID
LEFT JOIN AT2006 AT26 ON AT26.DivisionID = AT27.DivisionID AND AT26.VoucherID = AT27.VoucherID
LEFT JOIN AT1302 AT12 ON AT12.DivisionID = MT08.DivisionID AND AT12.InventoryID = MT08.MaterialID
WHERE MT07.DivisionID = '''+@DivisionID+''' 
--AND MT21.ProductID IS NOT NULL  '+@sWHERE+'
GROUP BY MT07.DivisionID, OT21.VoucherNo, OT21.OrderDate, MT21.VoucherNo, MT21.VoucherDate, MT08.MaterialID, 
      AT12.InventoryName, AT12.UnitID, MT08.WeightTotal, MT07.VoucherDate, MT21.MaterialDate, AT26.VoucherDate
UNION ALL      
SELECT MT21.DivisionID, '''' AS ObjectID, '''' AS ObjectName, MT21.VoucherNo, MT21.VoucherDate, 
       MT64.InventoryID AS MaterialID, AT132.InventoryName AS MaterialName, AT132.UnitID,
       MT64.Quantity AS MaterialQuantity, SUM(ISNULL(AT127.ActualQuantity,0)) AS InheritedQuantity, 
       MT64.InventoryDate AS EstimateExportDate, AT126.VoucherDate AS ExportDate
FROM MT0107 MT07
LEFT JOIN MT2001 MT21 ON MT21.DivisionID = MT07.DivisionID AND MT21.MixVoucherID = MT07.VoucherID
INNER JOIN MT0164 MT64 ON MT64.DivisionID = MT21.DivisionID AND MT64.PlanID = MT21.PlanID
LEFT JOIN AT2007 AT127 ON AT127.DivisionID = MT21.DivisionID AND AT127.InheritTableID = ''MT2001'' AND AT127.InheritVoucherID = MT21.PlanID AND AT127.InheritTransactionID = MT64.APK
LEFT JOIN AT2006 AT126 ON AT126.DivisionID = AT127.DivisionID AND AT126.VoucherID = AT127.VoucherID
LEFT JOIN AT1302 AT132 ON AT132.DivisionID = MT64.DivisionID AND AT132.InventoryID = MT64.InventoryID
WHERE MT21.DivisionID = '''+@DivisionID+''' 
AND ISNULL(MT21.ProductID,'''') != '''' '+@sWHERE+' 
GROUP BY MT21.DivisionID, MT21.VoucherNo, MT21.VoucherDate, MT64.InventoryID, AT132.InventoryName,
      AT132.UnitID, MT64.Quantity, MT64.InventoryDate, AT126.VoucherDate 
	'
PRINT (@sSQL)
	--EXEC (@sSQL)
	IF EXISTS(SELECT TOP 1 1 FROM SYSOBJECTS WHERE XTYPE = 'V' AND NAME = 'OV3027')
	DROP VIEW OV3027
    EXEC('CREATE VIEW OV3027---tao boi OP3027
		as ' + @sSQL)
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

