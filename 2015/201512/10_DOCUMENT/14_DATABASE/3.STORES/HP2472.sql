IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP2472]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP2472]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--Create by: Dang Le Bao Quynh; Date: 14/07/2006
--Purpose: Create dynamic view to load into form data source.
--- Edited by Bao Anh	Date: 12/11/2012
--- Purpose: Bo sung loc theo ngay (VietRoll)
/********************************************
'* Edited by: [GS] [Vi?t Khánh] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2472]
    @TimesID NVARCHAR(50), 
    @DivisionID NVARCHAR(50), 
    @DepartmentID NVARCHAR(50), 
    @TeamID NVARCHAR(50), 
    @TranMonth NVARCHAR(50), 
    @TranYear NVARCHAR(50),
    @TrackingDate datetime = NULL
AS

DECLARE 
    @sSQL NVARCHAR(max),
    @sSQL1 NVARCHAR(4000),
    @cur CURSOR, 
    @ProductID NVARCHAR(50), 
    @Column INT     

SET @sSQL = '
    CREATE VIEW HV2431 ---tao boi HP2472
    AS 
    SELECT HT.* FROM HT2413 HT
    WHERE HT.DivisionID = ''' + @DivisionID + ''' 
        AND HT.DepartmentID like ''' + @DepartmentID + ''' 
        AND ISNULL(HT.TeamID, ''' + ''') like ISNULL(''' + @TeamID + ''', ''' + ''') 
        AND HT.TranMonth = ' + CAST(@TranMonth AS NVARCHAR(2)) + ' 
        AND HT.TranYear = ' + CAST(@TranYear AS NVARCHAR(4)) + ' 
        AND HT.TimesID = ''' + @TimesID + '''
        AND CONVERT(VARCHAR(10),ISNULL(HT.TrackingDate,''01/01/1900''),101) = ''' + CONVERT(VARCHAR(10),ISNULL(@TrackingDate,'01/01/1900'),101) + ''''
print @sSQL
IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND name = 'HV2431')
    EXEC(@sSQL)
ELSE 
    BEGIN
        DROP VIEW HV2431
        EXEC(@sSQL)
    END

SET @sSQL = 'CREATE VIEW HV2430 ---tao boi HP2472
    AS SELECT HV1.DivisionID, HV1.DepartmentID, AT1.DepartmentName, HV1.TeamID, HT2.TeamName, HV1.TrackingDate,'
    
  

SET @cur = CURSOR FOR
SELECT DISTINCT ProductID FROM HT1017 WHERE DivisionID = @DivisionID ORDER BY ProductID

SET @Column = 1 --Gan column = 1 truoc khi thuc hien gia tang

OPEN @cur
FETCH NEXT FROM @cur INTO @ProductID

WHILE @@FETCH_STATUS = 0
    BEGIN
		SET @sSQL = @sSQL + 'SUM(CASE WHEN HV1.ProductID = ''' + @ProductID + ''' THEN HV1.Quantity ELSE NULL END) AS C' + LTRIM(@Column) + ', '        						
        SET @Column = @Column + 1
        FETCH NEXT FROM @cur INTO @ProductID
    END

SET @sSQL = left(@sSQL, LEN(@sSQL)-1)  


   set @sSQL1 = '
    FROM HV2431 HV1 INNER JOIN AT1102 AT1 ON HV1.DepartmentID = AT1.DepartmentID And HV1.DivisionID = AT1.DivisionID 
        INNER JOIN HT1101 HT2 ON HV1.DepartmentID = HT2.DepartmentID and HV1.TeamID = HT2.TeamID and HV1.DivisionID = HT2.DivisionID 
    GROUP BY HV1.DivisionID, HV1.DepartmentID, AT1.DepartmentName, 
        HV1.TeamID, HT2.TeamName, HV1.TrackingDate'            
        
IF NOT EXISTS (SELECT 1 FROM sysObjects WHERE XType = 'V' AND name = 'HV2430')
    EXEC( @sSQL+@sSQL1)
ELSE 
    BEGIN
        DROP VIEW HV2430
        EXEC(@sSQL+@sSQL1)
    END


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

