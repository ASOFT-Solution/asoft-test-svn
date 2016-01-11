
/****** Object:  StoredProcedure [dbo].[MP6009]    Script Date: 12/16/2010 16:22:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by :Hoµng ThÞ Lan
--Date :11/12/2003
--Purpose: Chi phÝ dë dang ®Çu kú (dïng cho Report MR1622)

--edited by: Vo Thanh Huong, date: 19/05/2005
---purpose: IN chung tu chi phi phat sinh trong ky

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP6009]    
    @DivisionID AS NVARCHAR(50), 
    @VoucherID AS NVARCHAR(50), 
    @PeriodID AS NVARCHAR(50)
 AS
 
DECLARE @sSQL AS NVARCHAR(4000)
    
SET @sSQL ='
SELECT Distinct  VoucherID, 
     MT1612.DivisionID, 
    TranMonth, 
    TranYear, 
    VoucherTypeID, 
    VoucherNo, 
    EmployeeID, 
    Description, 
    VoucherDate, 
    PeriodID, 
    MT1612.ProductID, 
     AT1302_P.InventoryName AS ProductName, 
    ProductQuantity, 
    PerfectRate, 
    WipQuantity, 
    ConvertedAmount, 
    ConvertedUnit, 
    (CASE WHEN MT1612.ExpenseID =''COST001'' THEN MT1612.MaterialID ELSE MT1612.MaterialTypeID END) AS MaterialID, 
    (CASE WHEN MT1612.ExpenseID =''COST001'' THEN AT1302_M.InventoryName ELSE UserName END) AS MaterialName, 
    MT1612. ExpenseID, 
    MT1612.MaterialTypeID, 
    MaterialPrice, 
    AT1302_M.UnitID AS MaterialUnitID, 
    AT1302_P.UnitID AS ProductIDUnitID
FROM MT1612     LEFT JOIN AT1302 AT1302_P ON MT1612.ProductID = AT1302_P.InventoryID And MT1612.DivisionID = AT1302_P.DivisionID AND AT1302_P.Disabled = 0
    LEFT JOIN AT1302 AT1302_M ON MT1612.MaterialID = AT1302_M.InventoryID AND MT1612.DivisionID = AT1302_M.DivisionID AND AT1302_M.Disabled = 0
    LEFT JOIN MT0699 ON MT1612.ExpenseID = MT0699.ExpenseID AND MT1612.MaterialTypeID = MT0699.MaterialTypeID and MT1612.DivisionID = MT0699.DivisionID
WHERE MT1612.DivisionID = ''' + @DivisionID + ''' AND 
    VoucherID = ''' + @VoucherID + ''''



IF NOT EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV6009' AND Xtype ='V')
    EXEC ('CREATE VIEW MV6009 AS '+@sSQL)
ELSE
    EXEC ('ALTER VIEW MV6009 AS '+@sSQL)