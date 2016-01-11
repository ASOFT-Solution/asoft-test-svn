/****** Object:  StoredProcedure [dbo].[MP0810]    Script Date: 02/07/2012 16:06:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MP0810]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MP0810]
GO

/****** Object:  StoredProcedure [dbo].[MP0810]    Script Date: 02/07/2012 16:06:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoµng Thi Lan
--Date 31/10/2003
--Purpose:Ket qua san xuat
--Edit By: Dang Le Bao Quynh; Date 27/10/2009
--Purpose: Them truong OTransactionID
--Edit By: Dang Le Bao Quynh; Date 16/11/2009
--Purpose: Them truong MTransactionID
--Edit by: Thuy Tuyen, date: 26/03/2010
--Purpose:them cac truong lien quan den DVT qui doi
--Edit by B.Anh, date: 30/06/2010 Lay them truong ExWarehouseID, ApportionID
--Edit by T.Khanh, date: 07/02/2012 Bo sung them 5 ma phan tich
--Modify on 19/08/2013 by Bao Anh: Bo sung HRMEmployeeID, HRMEmployeeName (Thuan Loi)
--Modify on 18/06/2015 by Hoàng Vũ: Bổ sung phân quyền xem dữ liệu của người khác, Bổ sung trường IsPhase, IsJob, IsResult, ExtraID, ExtraName, ProductTypeName 
--									Để xử lý nghiệp vụ sản xuất phân biệt rõ 2 công đoan, 1 công đoạn hay là mặc định của phần mềm

-- Modified on 07/09/2015 by Tiểu Mai: Bổ sung 10 tham số MD01 --> MD10
-- Modified on 08/10/2015 by Phương Thảo: Bổ sung Period
-- Modified on 28/10/2015 by Tiểu Mai: Bổ sung 20 quy cách hàng hóa ở MT8899
-- Modified by Tieu Mai on 04/01/2016: Bo sung truong KITID, KITQuantity
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/
---Example: exec MP0810 @DivisionID=N'AS',@PeriodID=N'%',@FromMonth=1,@FromYear=2014,@ToMonth=3,@ToYear=2014, @UserID = 'ASOFTADMIN'
CREATE Procedure [dbo].[MP0810] @DivisionID AS nvarchar(50), 
 @PeriodID AS nvarchar(50), 
 @FromMonth AS int, 
 @FromYear AS int, 
 @ToMonth AS int, 
 @ToYear AS int,
 @UserID AS nvarchar(50)
AS
Declare 
    @sSQL1 AS nvarchar(max), 
    @sSQL2 AS nvarchar(max), 
	@sSQL3 AS nvarchar(max), 
	@sSQL4 AS nvarchar(max),
    @FromPeriod AS int, 
    @ToPeriod AS int
    
Set @FromPeriod = @FromMonth + @FromYear*100
Set @ToPeriod = @ToMonth + @ToYear*100

----------------->>>>>> Phân quyền xem chứng từ của người dùng khác		
DECLARE @sSQLPer AS NVARCHAR(MAX),
		@sWHEREPer AS NVARCHAR(MAX)
SET @sSQLPer = ''
SET @sWHEREPer = ''		

IF EXISTS (SELECT TOP 1 1 FROM MT0000 WHERE DivisionID = @DivisionID AND IsPermissionView = 1) -- Nếu check Phân quyền xem dữ liệu tại Thiết lập hệ thống thì mới thực hiện
	BEGIN
		SET @sSQLPer = ' LEFT JOIN AT0010 ON AT0010.DivisionID = MT0810.DivisionID 
											AND AT0010.AdminUserID = '''+@UserID+''' 
											AND AT0010.UserID = MT0810.CreateUserID '
		SET @sWHEREPer = ' AND (MT0810.CreateUserID = AT0010.UserID
								OR  MT0810.CreateUserID = '''+@UserID+''') '		
	END

-----------------<<<<<< Phân quyền xem chứng từ của người dùng khác	

set @sSQL1 = 'Select x.*, AV2001.Name as ProductTypeName from 
(
SELECT 
    MT0810.VoucherID, 
    MT0810.VoucherTypeID, 
    MT0810.PeriodID, 
    MT0810.TranMonth, 
    MT0810.TranYear, 
    MT1601.Description AS PeriodName, 
    MT0810.DivisionID, 
    MT0810.DepartmentID, 
    AT1102.DepartmentName, 
    MT0810.VoucherNo, 
    MT0810.VoucherDate, 
    MT0810.IsWareHouse, 
    MT0810.WareHouseID, 
    AT1303.WareHouseName, 
    MT0810.EmployeeID, 
    AT1103_E.FullName AS EmployeeName, 
    MT0810.KCSEmployeeID, 
    AT1103_K.FullName AS KCSEmployeeName, 
    MT0810.Description, 
    MT0810.CreateDate, 
    MT0810.CreateUserID, 
    MT0810.LastModifyUserID, 
    MT0810.LastModifyDate, 
    MT0810.ResultTypeID, 
    MT0811.ResultTypeName, 
    MT0810.InventoryTypeID, 
    AT1301.InventoryTypeName, 
    MT1001.PerfectRate, 
    MT1001.ProductID, 
    AT1302.InventoryName AS ProductName, 
    AT1302.IsStocked, 
    AT1302.IsSource, 
    AT1302.IsLimitDate, 
    MT1001.SourceNo, 
    MT1001.LimitDate, 
    MT1001.UnitID, 
    MT1001.TransactionID, 
    MT1001.Price, 
    MT1001.ConvertedAmount, 
    (SELECT SUM(CAST(ConvertedAmount AS real)) FROM MT1001 T01 WHERE T01.VoucherID = MT0810.VoucherID) AS SumConvertedAmount, 
    MT1001.Note, 
    MT1001.Quantity, 
    (SELECT SUM(CAST(Quantity AS real)) FROM MT1001 T01 WHERE T01.VoucherID = MT0810.VoucherID) AS SumQuantity, 
    MT1001.DebitAccountID, 
    MT1001.CreditAccountID, 
    MT1001.MaterialRate, 
    MT1001.HumanResourceRate, 
    MT1001.OthersRate, 
    MT1001.Ana01ID, 
    MT1001.Ana02ID, 
    MT1001.Ana03ID, 
    MT1001.Ana04ID, 
    MT1001.Ana05ID,
    MT1001.Ana06ID,
    MT1001.Ana07ID,
    MT1001.Ana08ID,
    MT1001.Ana09ID,
    MT1001.Ana10ID,
    AT1011_01.AnaName AS AnaName01, 
    AT1011_02.AnaName AS AnaName02, 
    AT1011_03.AnaName AS AnaName03, 
    AT1011_04.AnaName AS AnaName04, 
    AT1011_05.AnaName AS AnaName05,
    AT1011_06.AnaName AS AnaName06,
    AT1011_07.AnaName AS AnaName07,
    AT1011_08.AnaName AS AnaName08,
    AT1011_09.AnaName AS AnaName09,
    AT1011_10.AnaName AS AnaName10,
    MT0810.TeamID, MT0810.ObjectID, 
    MT0810.TransferPeriodID, 
    MT0810.IsTransfer, 
    MT1001.ProductID1, 
    T02.InventoryName AS ProductName1, 
    MT1001.OTransactionID, 
    MT1001.MTransactionID, 
    ------------------------------------ Thong tin lien quan den DVT qui doi----------------
    MT1001.Parameter01, MT1001.Parameter02, MT1001.Parameter03, MT1001.Parameter04, MT1001.Parameter05, 
    MT1001.ConvertedQuantity, MT1001.ConvertedPrice, ISNULL(MT1001.ConvertedUnitID, AT1302.UnitID ) AS ConvertedUnitID, 
    ISNULL(T09.Operator, 0) AS Operator, 
    ISNULL(T09.ConversionFactor, 1) AS ConversionFactor, 
    ISNULL(T09.DataType, 0) AS DataType, T09.FormulaID, AT1319.FormulaDes, 
    MT0810.ExWareHouseID, MT0810.ApportionID,
    MT1001.MOrderID,
    MT1001.SOrderID,
    AT1302.Barcode,
    MT1001.HRMEmployeeID,
    HV1400.FullName as HRMEmployeeName,
	MT1001.HRMEmployeeID as OldHRMEmployeeID,
    MT1001.Quantity as OldQuantity,
	MT0810.IsPhase,--Customize Secoin
	MT0810.IsJob,--Customize Secoin
	MT0810.IsResult,--Customize Secoin
	MT1001.ExtraID,--Customize Secoin
	AT1311.ExtraName,--Customize Secoin
	MT1001.InventoryID, --Customize Secoin (Lưu mặt hàng của đơn hàng bán gốc)
	T03.InventoryName,--Customize Secoin (Lưu mặt hàng của đơn hàng bán gốc)
	MT1001.InheritVoucherID,
	MT1001.InheritTransactionID,
	MT1001.InheritTableID,
	Case When MT0810.IsPhase = 1 and MT0810.IsJob = 1 then 6
	     When MT0810.IsPhase = 1 and MT0810.IsResult = 1 then 5
		 When MT0810.IsPhase = 2 then 5
		 Else 5
		 end as ProductTypeID,
	MT2007.VoucherNo as ReVoucherNo,
	MT1001.MD01, MT1001.MD02, MT1001.MD03, MT1001.MD04, MT1001.MD05,
	MT1001.MD06, MT1001.MD07, MT1001.MD08, MT1001.MD09, MT1001.MD10,
	REPLACE(STR(MT0810.TranMonth, 2), '' '', ''0'') + ''/'' + STR(MT0810.TranYear, 4) AS Period,
	MT1001.KITID, Isnull(MT1001.KITQuantity,0) as KITQuantity, AT1326.InventoryQuantity'

IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	SET @sSQL2 =
		',M89.S01ID, M89.S02ID, M89.S03ID, M89.S04ID, M89.S05ID, M89.S06ID, M89.S07ID, M89.S08ID, M89.S09ID, M89.S10ID, 
		M89.S11ID, M89.S12ID, M89.S13ID, M89.S14ID, M89.S15ID, M89.S16ID, M89.S17ID, M89.S18ID, M89.S19ID, M89.S20ID
	'
	set @sSQL3 = '
	LEFT JOIN MT8899 M89 ON M89.DivisionID = MT1001.DivisionID and M89.VoucherID = MT1001.VoucherID and M89.TransactionID = MT1001.TransactionID
	'
END
ELSE 
BEGIN
	SET @sSQL2 = ''
	SET @sSQL3 = ''
END
	
SET @sSQL4 = '
FROM MT0810 
    INNER JOIN MT1001 ON MT0810.VoucherID = MT1001.VoucherID AND MT0810.DivisionID = MT1001.DivisionID
    LEFT JOIN AT1326 ON AT1326.DivisionID = MT1001.DivisionID AND AT1326.KITID = MT1001.KITID AND AT1326.InventoryID = MT1001.ProductID
    LEFT JOIN AT1103 AS AT1103_E ON MT0810.EmployeeID = AT1103_E.EmployeeID AND MT0810.DivisionID = AT1103_E.DivisionID
    LEFT JOIN AT1103 AS AT1103_K ON MT0810.KCSEmployeeID = AT1103_K.EmployeeID AND MT0810.DivisionID = AT1103_K.DivisionID
    LEFT JOIN AT1302 ON MT1001.ProductID = AT1302.InventoryID AND MT0810.DivisionID = AT1302.DivisionID
    LEFT JOIN AT1302 T02 ON MT1001.ProductID1 = T02.InventoryID AND MT0810.DivisionID = T02.DivisionID
	LEFT JOIN AT1302 T03 ON MT1001.InventoryID = T03.InventoryID and MT1001.DivisionID = T03.DivisionID
    LEFT JOIN MT1601 ON MT0810.PeriodID = MT1601.PeriodID AND MT0810.DivisionID = MT1601.DivisionID
    LEFT JOIN AT1301 ON AT1301.InventoryTypeID = MT0810.InventoryTypeID AND MT0810.DivisionID = AT1301.DivisionID
    LEFT JOIN AT1102 ON AT1102.DepartmentID = MT0810.DepartmentID AND MT0810.DivisionID = AT1102.DivisionID
    LEFT JOIN MT0811 ON MT0810.ResultTypeID = MT0811.ResultTypeID AND MT0810.DivisionID = MT0811.DivisionID
    LEFT JOIN AT1303 ON MT0810.WareHouseID = AT1303.WareHouseID AND MT0810.DivisionID = AT1303.DivisionID
    Left join AT1311 on MT1001.DivisionID = AT1311.DivisionID and MT1001.ExtraID = AT1311.ExtraID
	LEFT JOIN AT1011 AT1011_01 ON AT1011_01.AnaID = MT1001.Ana01ID AND AT1011_01.AnaTypeID = ''A01'' AND MT0810.DivisionID = AT1011_01.DivisionID
    LEFT JOIN AT1011 AT1011_02 ON AT1011_02.AnaID = MT1001.Ana02ID AND AT1011_02.AnaTypeID = ''A02'' AND MT0810.DivisionID = AT1011_02.DivisionID
    LEFT JOIN AT1011 AT1011_03 ON AT1011_03.AnaID = MT1001.Ana03ID AND AT1011_03.AnaTypeID = ''A03'' AND MT0810.DivisionID = AT1011_03.DivisionID
    LEFT JOIN AT1011 AT1011_04 ON AT1011_04.AnaID = MT1001.Ana04ID AND AT1011_04.AnaTypeID = ''A04'' AND MT0810.DivisionID = AT1011_04.DivisionID
    LEFT JOIN AT1011 AT1011_05 ON AT1011_05.AnaID = MT1001.Ana05ID AND AT1011_05.AnaTypeID = ''A05'' AND MT0810.DivisionID = AT1011_05.DivisionID
    LEFT JOIN AT1011 AT1011_06 ON AT1011_06.AnaID = MT1001.Ana06ID AND AT1011_06.AnaTypeID = ''A06'' AND MT0810.DivisionID = AT1011_06.DivisionID
    LEFT JOIN AT1011 AT1011_07 ON AT1011_07.AnaID = MT1001.Ana07ID AND AT1011_07.AnaTypeID = ''A07'' AND MT0810.DivisionID = AT1011_07.DivisionID
    LEFT JOIN AT1011 AT1011_08 ON AT1011_08.AnaID = MT1001.Ana08ID AND AT1011_08.AnaTypeID = ''A08'' AND MT0810.DivisionID = AT1011_08.DivisionID
    LEFT JOIN AT1011 AT1011_09 ON AT1011_09.AnaID = MT1001.Ana09ID AND AT1011_09.AnaTypeID = ''A09'' AND MT0810.DivisionID = AT1011_09.DivisionID
    LEFT JOIN AT1011 AT1011_10 ON AT1011_10.AnaID = MT1001.Ana10ID AND AT1011_10.AnaTypeID = ''A10'' AND MT0810.DivisionID = AT1011_10.DivisionID
    LEFT JOIN AT1309 T09 ON T09.InventoryID = MT1001.ProductID AND MT1001.ConvertedUnitID = T09.UnitID AND MT0810.DivisionID = T09.DivisionID
    LEFT JOIN AT1319 ON T09.FormulaID = AT1319.FormulaID AND MT0810.DivisionID = AT1319.DivisionID
    LEFT JOIN HV1400 ON MT1001.DivisionID = HV1400.DivisionID AND MT1001.HRMEmployeeID = HV1400.EmployeeID 
	LEFT JOIN (Select APK, DivisionID, SOrderID as VoucherID, VoucherNo, OrderDate, VoucherTypeID from OT2001
			   Union all
			   Select APK, DivisionID, VoucherID, VoucherNo, VoucherDate, VoucherTypeID from MT2007
			   ) MT2007 ON MT1001.InheritVoucherID = MT2007.VoucherID and MT1001.DivisionID = MT2007.DivisionID
    '+@sSQLPer+@sSQL3+' 
WHERE MT0810.PeriodID like ''' + @PeriodID + ''' AND MT0810.DivisionID = ''' + @DivisionID + '''
    AND MT0810.TranMonth + MT0810.TranYear * 100 BETWEEN ' + str(@FromPeriod) + ' AND ' + str(@ToPeriod) + ''
	+ @sWHEREPer +
	' ) x left join AV2001 on x.ProductTypeID = AV2001.ID
	'

If not exists (SELECT top 1 1 FROM SysObjects WHERE name = 'MV0810' AND Xtype = 'V')
    Exec ('CREATE VIEW MV0810 --Created by MP0810
    AS ' + @sSQL1 + @sSQL2 + @sSQL4)
Else
    Exec ('ALTER VIEW MV0810 --Created by MP0810
    AS ' + @sSQL1 + @sSQL2 + @sSQL4)

