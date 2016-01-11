/****** Object:  StoredProcedure [dbo].[MP6008]    Script Date: 12/30/2010 11:36:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Create by Nguyen Ngoc My
--Date 9/1/2004
--Bao cao chi phi do dang cuoi ky

--Created by: Vo Thanh Huong, date: 19/05/2005
---Purpose: IN chung tu chi phi  do dang cuoi ky

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP6008]  
    @DivisionID NVARCHAR(50), 
    @VoucherID NVARCHAR(50) 
AS 

DECLARE @sSQL AS NVARCHAR(4000)
    
SET @sSQL =
'SELECT Distinct MT1612.DivisionID,VoucherID, 
    VoucherTypeID, 
    VoucherNo, 
    MT1612.EmployeeID, FullName
    Description, 
    VoucherDate, 
    MT1612.PeriodID, 
    MT1601.Description AS PeriodName, 
    MT1612.ProductID, 
    P.InventoryName AS ProductName, 
    ProductQuantity, 
    PerfectRate, 
    ISNULL(WipQuantity, 0) AS WipQuantity, 
    ConvertedAmount, 
    ConvertedUnit, 
    MaterialID, 
    I.InventoryName AS MaterialName, 
    I.UnitID AS MaterialUnitID, 
    MT1612.ExpenseID, UserName, 
    MT1612.MaterialTypeID, 
    MaterialPrice, 
    Type
FROM MT1612 LEFT JOIN AT1302 P ON P.InventoryID = MT1612.ProductID and P.DivisionID = MT1612.DivisionID
    LEFT JOIN AT1302 I ON I.InventoryID = MT1612.MaterialID and I.DivisionID = MT1612.DivisionID
    LEFT JOIN AT1103 ON AT1103.EmployeeID = MT1612.EmployeeID AND  AT1103.DivisionID = MT1612.DivisionID 
    LEFT JOIN MT0699 ON MT0699.MaterialTypeID = MT1612.MaterialTypeID and MT0699.DivisionId = MT1612.DivisionId
    LEFT JOIN MT1601 ON MT1601.PeriodID = MT1612.PeriodID and MT1601.DivisionID = MT1612.DivisionID
WHERE MT1612.DivisionID = ''' + @DivisionID + ''' AND 
    VoucherID = ''' + @VoucherID + ''''    


IF EXISTS (SELECT TOP 1 1 FROM SysObjects WHERE name = 'MV6008' AND Xtype ='V')
    DROP VIEW MV6008
EXEC ('CREATE VIEW MV6008 AS '+@sSQL)