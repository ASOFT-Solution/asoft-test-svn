

/****** Object:  StoredProcedure [dbo].[HP2473]    Script Date: 12/08/2011 15:28:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2473]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2473]
GO



/****** Object:  StoredProcedure [dbo].[HP2473]    Script Date: 12/08/2011 15:28:03 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


--Create by: Dang Le Bao Quynh; Date: 14/07/2006
--Purpose: Importing the produce result FROM AsoftM Module

/********************************************
'* Edited by: [GS] [Việt Khánh] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2473]
    @TimesID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT, 
    @DivisionID NVARCHAR(50), 
    @DepartmentID NVARCHAR(50), 
    @TeamID NVARCHAR(50)
AS

DECLARE @sSQL NVARCHAR(4000)

SET @sSQL = '
    SELECT ''' + @TimesID + ''' AS TimesID, MT1.TranMonth, MT1.TranYear, 
        MT1.DivisionID, MT1.DepartmentID, MT1.TeamID, MT2.ProductID, 
        SUM(MT2.Quantity) AS SumofQuantity
    FROM MT0810 MT1 INNER JOIN MT1001 MT2 ON MT1.VoucherID = MT2.VoucherID and MT1.DivisionID = MT2.DivisionID
    GROUP BY MT1.TranMonth, MT1.TranYear, MT1.DivisionID, 
        MT1.DepartmentID, MT1.TeamID, MT2.ProductID
    HAVING MT1.TranMonth = ' + LTRIM(@TranMonth) + ' 
        AND MT1.TranYear = ' + LTRIM(@TranYear) + ' 
        AND MT1.DivisionID = ''' + @DivisionID + ''' 
        AND MT1.DepartmentID Like ''' + @DepartmentID + ''' 
        AND MT1.TeamID Like ''' + @TeamID + ''' 
        AND LEN(MT1.TeamID)>0'
  
IF EXISTS (SELECT id FROM sysobjects WHERE id = object_id('HV2413') AND xtype = 'V')
    DROP VIEW HV2413
    
--PRINT '====================' PRINT ('--Tao boi HP2473
--    CREATE VIEW HV2413 AS ' + @sSQL)
EXEC ('--Tao boi HP2473
    CREATE VIEW HV2413 AS ' + @sSQL)

SET @sSQL = '
DELETE FROM HT2413 
WHERE DivisionID + TimesID + LTRIM(TranMonth) + LTRIM(TranYear) + DivisionID + DepartmentID + TeamID + ProductID 
IN (SELECT DivisionID + TimesID + LTRIM(TranMonth) + LTRIM(TranYear) + DivisionID + DepartmentID + TeamID + ProductID 
    FROM HV2413 where DivisionID= '''+@DivisionID+'''  )
    and DivisionID = '''+@DivisionID+'''  
'
 
--PRINT '====================' PRINT @sSQL
EXEC (@sSQL)

SET @sSQL = '
INSERT INTO HT2413 (DivisionID, TimesID,TranMonth,TranYear,DepartmentID,
TeamID,ProductID, OriginalQuantity,CreateUserID,CreateDate,LastModifyUserID,
LastModifyDate) 
SELECT DivisionID, 
	TimesID, 
    TranMonth, 
    TranYear, 
    DepartmentID, 
    TeamID, 
    ProductID, 
    SumofQuantity, ''ASOFTADMIN'' , getDate(), ''ASOFTADMIN'', getDate()
FROM HV2413 
WHERE ProductID IN (SELECT ProductID 
                    FROM HT1015 
                    WHERE Disabled = 0 and DivisionID='''+@DivisionID+'''  )
AND DivisionID = '''+@DivisionID+'''               '
PRINT @sSQL
--PRINT '====================' PRINT @sSQL
EXEC (@sSQL)

GO


