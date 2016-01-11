/****** Object: StoredProcedure [dbo].[OP2203] Script Date: 12/16/2010 11:43:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 28/12/2004
---purpose: In cac thanh pham du toan NVL
-- Last Edit: Thuy Tuyen , date : 15/05/2009 Lay truong EndDate
--- Last edit: B.Anh, date 18/12/2009 Lay them truong SOrderID cua don hang san xuat
--- Modify on 16/07/2014 by Bảo Anh: Bổ sung chi tiết NVL sản xuất thành phẩm
--- Modified on 09/09/2015 by Tiểu Mai: Bổ sung 10 tham số chi tiết
/********************************************
'* Edited by: [GS] [Tố Oanh] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP2203] @DivisionID nvarchar(50),
 @EstimateID nvarchar(50)
 
AS
Declare @sSQL nvarchar(4000)
		
Set @sSQL = '
SELECT T00.DivisionID, VoucherNo, VoucherDate, T01.SOrderID, ApportionType, 
    T01.DepartmentID, DepartmentName, T01.EmployeeID, FullName, 
    ApportionID, T01.Description, PDescription, T00.LinkNo, T00.Orders, 
    ProductID, InventoryName AS ProductName, UnitName, ProductQuantity,
    ConertedAmount621 = (SELECT SUM(ISNULL(ConvertedAmount, 0)) FROM OT2203 
    WHERE OT2203.EDetailID = T00.EDetailID AND OT2203.ExpenseID = ''COST001''), 
    ConertedAmount622 = (SELECT SUM(ISNULL(ConvertedAmount, 0)) FROM OT2203 
    WHERE OT2203.EDetailID = T00.EDetailID AND OT2203.ExpenseID = ''COST002''),
    ConertedAmount627 = (SELECT SUM(ISNULL(ConvertedAmount, 0)) FROM OT2203 
    WHERE OT2203.EDetailID = T00.EDetailID AND OT2203.ExpenseID = ''COST003''),
    ConertedUnit621 = (SELECT SUM(ISNULL(ConvertedUnit, 0)) FROM OT2203 
    WHERE OT2203.EDetailID = T00.EDetailID AND OT2203.ExpenseID = ''COST001''), 
    ConertedUnit622 = (SELECT SUM(ISNULL(ConvertedUnit, 0)) FROM OT2203 
    WHERE OT2203.EDetailID = T00.EDetailID AND OT2203.ExpenseID = ''COST002''),
    ConertedUnit627 = (SELECT SUM(ISNULL(ConvertedUnit, 0)) FROM OT2203 
    WHERE OT2203.EDetailID = T00.EDetailID AND OT2203.ExpenseID = ''COST003''),
    T01.ObjectID, AT1202.ObjectName, 
    T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
    OT1002_1.AnaName AS AnaName1,
    OT1002_2.AnaName AS AnaName2,
    OT1002_3.AnaName AS AnaName3,
    OT1002_4.AnaName AS AnaName4,
    OT1002_5.AnaName AS AnaName5,
    OT2002.EndDate, OT2002.SOrderID AS MOOrderID,
    T26.ItemID, T26.ItemName, T26.ItemUnitID, T26.ItemQuantity,
    T00.ED01, T00.ED02, T00.ED03, T00.ED04, T00.ED05, T00.ED06,
    T00.ED07, T00.ED08, T00.ED09, T00.ED10

FROM OT2202 T00 
    INNER JOIN OT2201 T01 ON T00.DivisionID = T01.DivisionID AND T00.EstimateID = T01.EstimateID
    INNER JOIN AT1302 T02 ON T02.DivisionID = T00.DivisionID AND T02.InventoryID = T00.ProductID
    INNER JOIN AT1304 T03 ON T03.DivisionID = T02.DivisionID AND T03.UnitID = T02.UnitID
    LEFT JOIN AT1102 T04 ON T04.DivisionID = T01.DivisionID AND T04.DepartmentID = T01.DepartmentID
    LEFT JOIN AT1103 T05 ON T05.DivisionID = T01.DivisionID AND T05.EmployeeID = T01.EmployeeID
    LEFT JOIN AT1202 ON AT1202.DivisionID = T01.DivisionID AND AT1202.ObjectID = T01.ObjectID
    LEFT JOIN AT1011 OT1002_1 ON OT1002_1.DivisionID = T00.DivisionID AND OT1002_1.AnaID = T00.Ana01ID AND OT1002_1.AnaTypeID = ''A01'' 
    LEFT JOIN AT1011 OT1002_2 ON OT1002_2.DivisionID = T00.DivisionID AND OT1002_2.AnaID = T00.Ana02ID AND OT1002_2.AnaTypeID = ''A02'' 
    LEFT JOIN AT1011 OT1002_3 ON OT1002_3.DivisionID = T00.DivisionID AND OT1002_3.AnaID = T00.Ana03ID AND OT1002_3.AnaTypeID = ''A03'' 
    LEFT JOIN AT1011 OT1002_4 ON OT1002_4.DivisionID = T00.DivisionID AND OT1002_4.AnaID = T00.Ana04ID AND OT1002_4.AnaTypeID = ''A04'' 
    LEFT JOIN AT1011 OT1002_5 ON OT1002_5.DivisionID = T00.DivisionID AND OT1002_5.AnaID = T00.Ana05ID AND OT1002_5.AnaTypeID = ''A05'' 
    LEFT JOIN OT2002 ON OT2002.DivisionID = T00.DivisionID AND OT2002.TransactionID = T00.MOTransactionID
    INNER JOIN OT1326 T26 ON T00.DivisionID = T26.DivisionID AND T00.EstimateID = T26.EstimateID AND T00.ProductID=T26.InventoryID
 
WHERE T01.DivisionID = ''' + @DivisionID + ''' AND 
    T00.EstimateID = ''' + @EstimateID + ''''
      
If exists(SELECT Top 1 1 FROM sysObjects WHERE XType = 'V' AND Name = 'OV2204')
 Drop view OV2204
EXEC('Create view OV2204 ---tao boi OP2203
 AS ' + @sSQL)