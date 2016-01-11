/****** Object: StoredProcedure [dbo].[MP0811] Script Date: 07/30/2010 10:31:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoµng ThÞ Lan
--Date 31/10/2003
--Purpose:KÕt qu¶ s¶n xuÊt
--Created by: Vo Thanh Huong, date: 19/05/2005
---purpose: In chung tu ket qua san xuat
--Edit by: Dang Le Bao Quynh; Date 15/12/2009
--Purpose: Them truong ma doi tuong, ten doi tuong (ObjectID,ObjectName) 
--- Edit by Bao Anh, date 05/04/2010    Lay cac truong dung cho DVT quy doi
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/
-- Edit by : Trong Khanh [10/02/2012] -- Thêm 5 mã phân tích
--- Edit by Tan Phu, date 29/08/2012: 0018242: [TIENTIEN] thêm mã kho, tên kho vào báo cáo MR0811 (view MV0811)
--- Modified by Tieu Mai on 25/12/2015: Bo sung thong tin quy cach khi co thiet lap quan ly mat hang theo quy cach

ALTER PROCEDURE [dbo].[MP0811]    @DivisionID nvarchar(50),    
                    @VoucherID nvarchar(50),
                    @ResultTypeID AS nvarchar(50)                        
AS 
Declare @sSQL1 AS nvarchar(4000)
Declare @sSQL2 AS nvarchar(4000), @sSQL3 NVARCHAR(MAX)

SET @sSQL3 = ''
Set @sSQL1 = '
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
    MT0810.EmployeeID,
    MT0810.KCSEmployeeID,
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
    MT1001.UnitID,
    MT1001.TransactionID,
    MT1001.Price,
    MT1001.ConvertedAmount,
    MT1001.Note,
    MT1001.Quantity,
    MT1001.MaterialRate,
    MT1001.HumanResourceRate,
    MT1001.OthersRate,
    MT1001.Orders,
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
    MT0810.ObjectID, AT1202.ObjectName,
    MT1001.Parameter01, MT1001.Parameter02, MT1001.Parameter03, MT1001.Parameter04, MT1001.Parameter05,
    MT1001.ConvertedQuantity, MT1001.ConvertedPrice, MT1001.ConvertedUnitID,
    T01.UnitName AS UnitName, T02.UnitName AS ConvertedUnitName
    ,MT0810.WareHouseID
    ,AT1303.WareHouseName
    , MT1001.MOrderID
'
Set @sSQL2 = '
FROM MT0810 
    INNER JOIN MT1001 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID
    LEFT JOIN AT1302 ON MT0810.DivisionID = AT1302.DivisionID AND MT1001.ProductID = AT1302.InventoryID
    LEFT JOIN MT1601 ON MT0810.DivisionID = MT1601.DivisionID AND MT0810.PeriodID = MT1601.PeriodID 
    LEFT JOIN AT1301 ON MT0810.DivisionID = AT1301.DivisionID AND AT1301.InventoryTypeID = MT0810.InventoryTypeID 
    LEFT JOIN AT1102 ON MT0810.DivisionID = AT1102.DivisionID AND AT1102.DepartmentID = MT0810.DepartmentID
    LEFT JOIN MT0811 ON MT0810.DivisionID = MT0811.DivisionID AND MT0810.ResultTypeID = MT0811.ResultTypeID 
    LEFT JOIN AT1011 AT1011_01 ON MT0810.DivisionID = AT1011_01.DivisionID AND AT1011_01.AnaID = MT1001.Ana01ID AND AT1011_01.AnaTypeID = ''A01'' 
    LEFT JOIN AT1011 AT1011_02 ON MT0810.DivisionID = AT1011_02.DivisionID AND AT1011_02.AnaID = MT1001.Ana02ID AND AT1011_02.AnaTypeID = ''A02'' 
    LEFT JOIN AT1011 AT1011_03 ON MT0810.DivisionID = AT1011_03.DivisionID AND AT1011_03.AnaID = MT1001.Ana03ID AND AT1011_03.AnaTypeID = ''A03'' 
    LEFT JOIN AT1011 AT1011_04 ON MT0810.DivisionID = AT1011_04.DivisionID AND AT1011_04.AnaID = MT1001.Ana04ID AND AT1011_04.AnaTypeID = ''A04'' 
    LEFT JOIN AT1011 AT1011_05 ON MT0810.DivisionID = AT1011_05.DivisionID AND AT1011_05.AnaID = MT1001.Ana05ID AND AT1011_05.AnaTypeID = ''A05''
    LEFT JOIN AT1011 AT1011_06 ON MT0810.DivisionID = AT1011_06.DivisionID AND AT1011_06.AnaID = MT1001.Ana06ID AND AT1011_06.AnaTypeID = ''A06''
    LEFT JOIN AT1011 AT1011_07 ON MT0810.DivisionID = AT1011_07.DivisionID AND AT1011_07.AnaID = MT1001.Ana07ID AND AT1011_07.AnaTypeID = ''A07''
    LEFT JOIN AT1011 AT1011_08 ON MT0810.DivisionID = AT1011_08.DivisionID AND AT1011_08.AnaID = MT1001.Ana08ID AND AT1011_08.AnaTypeID = ''A08''
    LEFT JOIN AT1011 AT1011_09 ON MT0810.DivisionID = AT1011_09.DivisionID AND AT1011_09.AnaID = MT1001.Ana09ID AND AT1011_09.AnaTypeID = ''A09''
    LEFT JOIN AT1011 AT1011_10 ON MT0810.DivisionID = AT1011_10.DivisionID AND AT1011_10.AnaID = MT1001.Ana10ID AND AT1011_10.AnaTypeID = ''A10''
    LEFT JOIN AT1202 ON MT0810.DivisionID = AT1202.DivisionID AND MT0810.ObjectID = AT1202.ObjectID 
    LEFT JOIN AT1304 T01 ON MT0810.DivisionID = T01.DivisionID AND MT1001.UnitID = T01.UnitID 
    LEFT JOIN AT1304 T02 ON MT0810.DivisionID = T02.DivisionID AND MT1001.ConvertedUnitID = T02.UnitID 
	LEFT JOIN AT1303 ON MT0810.WareHouseID = AT1303.WareHouseID AND MT0810.DivisionID = AT1303.DivisionID
'

IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	SET @sSQL1 =  @sSQL1 + ',
			O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID, 
			O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
			A01.StandardName AS S01Name, A02.StandardName AS S02Name, A03.StandardName AS S03Name, A04.StandardName AS S04Name, A05.StandardName AS S05Name,
			A06.StandardName AS S06Name, A07.StandardName AS S07Name, A08.StandardName AS S08Name, A09.StandardName AS S09Name, A10.StandardName AS S10Name,
			A11.StandardName AS S11Name, A12.StandardName AS S12Name, A13.StandardName AS S13Name, A14.StandardName AS S14Name, A15.StandardName AS S15Name,
			A16.StandardName AS S16Name, A17.StandardName AS S17Name, A18.StandardName AS SName18, A19.StandardName AS S19Name, A20.StandardName AS S20Name
	'
	SET @sSQL3 = '
			LEFT JOIN MT8899 O99 ON O99.DivisionID = MT1001.DivisionID AND O99.VoucherID = MT1001.VoucherID AND O99.TransactionID  = MT1001.TransactionID and O99.TableID  = ''MT1001''
			LEFT JOIN AT0128 A01 ON A01.DivisionID = O99.DivisionID AND A01.StandardID = O99.S01ID AND A01.StandardTypeID = ''S01''
			LEFT JOIN AT0128 A02 ON A02.DivisionID = O99.DivisionID AND A02.StandardID = O99.S02ID AND A02.StandardTypeID = ''S02''
			LEFT JOIN AT0128 A03 ON A03.DivisionID = O99.DivisionID AND A03.StandardID = O99.S03ID AND A03.StandardTypeID = ''S03''
			LEFT JOIN AT0128 A04 ON A04.DivisionID = O99.DivisionID AND A04.StandardID = O99.S04ID AND A04.StandardTypeID = ''S04''
			LEFT JOIN AT0128 A05 ON A05.DivisionID = O99.DivisionID AND A05.StandardID = O99.S05ID AND A05.StandardTypeID = ''S05''
			LEFT JOIN AT0128 A06 ON A06.DivisionID = O99.DivisionID AND A06.StandardID = O99.S06ID AND A06.StandardTypeID = ''S06''
			LEFT JOIN AT0128 A07 ON A07.DivisionID = O99.DivisionID AND A07.StandardID = O99.S07ID AND A07.StandardTypeID = ''S07''
			LEFT JOIN AT0128 A08 ON A08.DivisionID = O99.DivisionID AND A08.StandardID = O99.S08ID AND A08.StandardTypeID = ''S08''
			LEFT JOIN AT0128 A09 ON A09.DivisionID = O99.DivisionID AND A09.StandardID = O99.S09ID AND A09.StandardTypeID = ''S09''
			LEFT JOIN AT0128 A10 ON A10.DivisionID = O99.DivisionID AND A10.StandardID = O99.S10ID AND A10.StandardTypeID = ''S10''
			LEFT JOIN AT0128 A11 ON A11.DivisionID = O99.DivisionID AND A11.StandardID = O99.S11ID AND A11.StandardTypeID = ''S11''
			LEFT JOIN AT0128 A12 ON A12.DivisionID = O99.DivisionID AND A12.StandardID = O99.S12ID AND A12.StandardTypeID = ''S12''
			LEFT JOIN AT0128 A13 ON A13.DivisionID = O99.DivisionID AND A13.StandardID = O99.S13ID AND A13.StandardTypeID = ''S13''
			LEFT JOIN AT0128 A14 ON A14.DivisionID = O99.DivisionID AND A14.StandardID = O99.S14ID AND A14.StandardTypeID = ''S14''
			LEFT JOIN AT0128 A15 ON A15.DivisionID = O99.DivisionID AND A15.StandardID = O99.S15ID AND A15.StandardTypeID = ''S15''
			LEFT JOIN AT0128 A16 ON A16.DivisionID = O99.DivisionID AND A16.StandardID = O99.S16ID AND A16.StandardTypeID = ''S16''
			LEFT JOIN AT0128 A17 ON A17.DivisionID = O99.DivisionID AND A17.StandardID = O99.S17ID AND A17.StandardTypeID = ''S17''
			LEFT JOIN AT0128 A18 ON A18.DivisionID = O99.DivisionID AND A18.StandardID = O99.S18ID AND A18.StandardTypeID = ''S18''
			LEFT JOIN AT0128 A19 ON A19.DivisionID = O99.DivisionID AND A19.StandardID = O99.S19ID AND A19.StandardTypeID = ''S19''
			LEFT JOIN AT0128 A20 ON A20.DivisionID = O99.DivisionID AND A20.StandardID = O99.S20ID AND A20.StandardTypeID = ''S20''
	'+ '	
WHERE MT0810.VoucherID = ''' + @VoucherID + ''' 
    AND MT0810.ResultTypeID = ''' + @ResultTypeID + ''''
END
ELSE 
	SET @sSQL2 = @sSQL2 + '	
WHERE MT0810.VoucherID = ''' + @VoucherID + ''' 
    AND MT0810.ResultTypeID = ''' + @ResultTypeID + ''''
	
If not exists (SELECT top 1 1 FROM SysObjects WHERE name = 'MV0811' AND Xtype = 'V')
    Exec ('CREATE VIEW MV0811 AS ' + @sSQL1 + @sSQL2 + @sSQL3)
Else
    Exec ('ALTER VIEW MV0811 AS ' + @sSQL1 + @sSQL2 + @sSQL3)  