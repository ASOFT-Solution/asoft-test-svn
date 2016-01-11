
/****** Object:  StoredProcedure [dbo].[MP6020]    Script Date: 12/16/2010 13:45:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 28/06/2005
---purpose MT6007 bang tam lay ngay y/c hoan thanh sau cung cua tung LSX

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP6020] 
    @DivisionID NVARCHAR(50), 
    @FromMonth INT, 
    @FromYear INT, 
    @ToMonth INT, 
    @ToYear INT, 
    @FromDate datetime, 
    @ToDate datetime, 
    @IsDate TINYINT, 
    @FromDepartmentID NVARCHAR(50), 
    @ToDepartmentID NVARCHAR(50), 
    @PlanID NVARCHAR(50), 
    @PlanDetailID NVARCHAR(50), 
    @Finish TINYINT ---1: Chi lay thanh pham sau cung., 0: Lay TP, BTP    
AS
DECLARE 
    @sSQL NVARCHAR(max), 
    @sSQL1 NVARCHAR(max), 
    @FromPeriod NVARCHAR(50), 
    @ToPerioD NVARCHAR(50), 
    @sFromDate NVARCHAR(100), 
    @sToDate NVARCHAR(100)

SELECT @FromPeriod = CAST(@FromMonth + @FromYear*100 AS NVARCHAR(10)), 
    @ToPerioD = CAST(@ToMonth + @ToYear*100 AS NVARCHAR(10)), 
    @sFromDate = CONVERT(NVARCHAR(50), @FromDate, 101), @sToDate = CONVERT(NVARCHAR(50), @ToDate, 101)


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[MT6007]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
    DROP TABLE MT6007
    
SET NOCOUNT ON

--Xac dinh ngay yeu cau hoan thanh
SET @sSQL = 
'SELECT distinct T00.DivisionID, T00.PlanID, T00.PlanDetailID, 
    CASE WHEN ISNULL(Quantity40, 0) <> 0 THEN Date40 
    ELSE CASE WHEN ISNULL(Quantity39, 0) <> 0 THEN Date39 
    ELSE CASE WHEN ISNULL(Quantity38, 0) <> 0 THEN Date38 
    ELSE CASE WHEN ISNULL(Quantity37, 0) <> 0 THEN Date37 
    ELSE CASE WHEN ISNULL(Quantity36, 0) <> 0 THEN Date36 
    ELSE CASE WHEN ISNULL(Quantity35, 0) <> 0 THEN Date35 
    ELSE CASE WHEN ISNULL(Quantity34, 0) <> 0 THEN Date34 
    ELSE CASE WHEN ISNULL(Quantity33, 0) <> 0 THEN Date33 
    ELSE CASE WHEN ISNULL(Quantity32, 0) <> 0 THEN Date32 
    ELSE CASE WHEN ISNULL(Quantity31, 0) <> 0 THEN Date31 
    END END END END END END END END END END 
 AS EndDate
INTO MT6007 
FROM MT2002 T00 INNER JOIN MT2003 T01 ON T00.PlanID = T01.PlanID  and  T00.DivisionID = T01.DivisionID
    INNER JOIN MT2001 T02 ON T02.PlanID = T00.PlanID   and  T00.DivisionID = T02.DivisionID
WHERE ' + CASE WHEN @IsDate = 1 THEN ' T02.VoucherDate BETWEEN ''' + @sFromDate + ''' AND ''' + @sToDate + ''''  ELSE 
    ' T02.TranMonth + T02.TranYear*100  BETWEEN ' + @FromPeriod + ' AND ' + @ToPeriod  END + '
    AND T00.DivisionID = ''' + @DivisionID + '''
 AND T00.PlanID LIKE ''' + @PlanID + CASE WHEN ISNULL(@FromDepartmentID, '') <> '' THEN  ''' AND
    T00.DepartmentID BETWEEN ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''''  ELSE '''' END + 
    CASE WHEN ISNULL(@PlanDetailID, '') <> '' THEN ' AND T00.PlanDetailID LIKE ''' + @PlanDetailID + '''' ELSE '' END + '
UNION
SELECT T00.DivisionID, T00.PlanID, T00.PlanDetailID, 
    CASE WHEN ISNULL(Quantity30, 0) <> 0 THEN Date30 
    ELSE CASE WHEN ISNULL(Quantity29, 0) <> 0 THEN Date29 
    ELSE CASE WHEN ISNULL(Quantity28, 0) <> 0 THEN Date28 
    ELSE CASE WHEN ISNULL(Quantity27, 0) <> 0 THEN Date27 
    ELSE CASE WHEN ISNULL(Quantity26, 0) <> 0 THEN Date26 
    ELSE CASE WHEN ISNULL(Quantity25, 0) <> 0 THEN Date25 
    ELSE CASE WHEN ISNULL(Quantity24, 0) <> 0 THEN Date24 
    ELSE CASE WHEN ISNULL(Quantity23, 0) <> 0 THEN Date23 
    ELSE CASE WHEN ISNULL(Quantity22, 0) <> 0 THEN Date22 
    ELSE CASE WHEN ISNULL(Quantity21, 0) <> 0 THEN Date21 
    END END END END END END END END END END 
 AS EndDate
FROM MT2002 T00 INNER JOIN MT2003 T01 ON T00.PlanID = T01.PlanID and  T00.DivisionID = T01.DivisionID
        INNER JOIN MT2001 T02 ON T02.PlanID = T00.PlanID  and  T00.DivisionID = T02.DivisionID
WHERE ' + CASE WHEN @IsDate = 1 THEN ' T02.VoucherDate BETWEEN ''' + @sFromDate + ''' AND ''' + @sToDate + ''''  ELSE '
     T02.TranMonth + T02.TranYear*100  BETWEEN ' + @FromPeriod + ' AND ' + @ToPeriod  END + '
     AND T00.DivisionID = ''' + @DivisionID + '''
 AND T00.PlanID LIKE ''' + @PlanID + CASE WHEN ISNULL(@FromDepartmentID, '') <> '' THEN  ''' AND
    T00.DepartmentID BETWEEN ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''''  ELSE '''' END + 
    CASE WHEN ISNULL(@PlanDetailID, '') <> '' THEN ' AND T00.PlanDetailID LIKE ''' + @PlanDetailID + '''' ELSE '' END + ' 
 '

SET @sSQL1 = ' UNION SELECT T00.DivisionID, T00.PlanID, T00.PlanDetailID, 
    CASE WHEN ISNULL(Quantity20, 0) <> 0 THEN Date20
    ELSE CASE WHEN ISNULL(Quantity19, 0) <> 0 THEN Date19
    ELSE CASE WHEN ISNULL(Quantity18, 0) <> 0 THEN Date18
    ELSE CASE WHEN ISNULL(Quantity17, 0) <> 0 THEN Date17 
    ELSE CASE WHEN ISNULL(Quantity16, 0) <> 0 THEN Date16 
    ELSE CASE WHEN ISNULL(Quantity15, 0) <> 0 THEN Date15 
    ELSE CASE WHEN ISNULL(Quantity14, 0) <> 0 THEN Date14 
    ELSE CASE WHEN ISNULL(Quantity13, 0) <> 0 THEN Date13
    ELSE CASE WHEN ISNULL(Quantity12, 0) <> 0 THEN Date12
    ELSE CASE WHEN ISNULL(Quantity11, 0) <> 0 THEN Date11  
    END END END END END END END END END END 
 AS EndDate
FROM MT2002 T00 INNER JOIN MT2003 T01 ON T00.PlanID = T01.PlanID and T00.DivisionID = T01.DivisionID 
        INNER JOIN MT2001 T02 ON T02.PlanID = T00.PlanID  and T00.DivisionID = T02.DivisionID
WHERE ' + CASE WHEN @IsDate = 1 THEN ' T02.VoucherDate BETWEEN ''' + @sFromDate + ''' AND ''' + @sToDate + ''''  ELSE 
    ' T02.TranMonth + T02.TranYear*100  BETWEEN ' + @FromPeriod + ' AND ' + @ToPeriod  END + '
    AND T00.DivisionID = ''' + @DivisionID + '''
 AND T00.PlanID LIKE ''' + @PlanID + CASE WHEN ISNULL(@FromDepartmentID, '') <> '' THEN  ''' AND
    T00.DepartmentID BETWEEN ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''''  ELSE '''' END + 
    CASE WHEN ISNULL(@PlanDetailID, '') <> '' THEN ' AND T00.PlanDetailID LIKE ''' + @PlanDetailID + '''' ELSE '' END + '
UNION
SELECT T00.DivisionID, T00.PlanID, T00.PlanDetailID, 
    CASE WHEN ISNULL(Quantity10, 0) <> 0 THEN Date10 
    ELSE CASE WHEN ISNULL(Quantity09, 0) <> 0 THEN Date09 
    ELSE CASE WHEN ISNULL(Quantity08, 0) <> 0 THEN Date08 
    ELSE CASE WHEN ISNULL(Quantity07, 0) <> 0 THEN Date07 
    ELSE CASE WHEN ISNULL(Quantity06, 0) <> 0 THEN Date06 
    ELSE CASE WHEN ISNULL(Quantity05, 0) <> 0 THEN Date05 
    ELSE CASE WHEN ISNULL(Quantity04, 0) <> 0 THEN Date04 
    ELSE CASE WHEN ISNULL(Quantity03, 0) <> 0 THEN Date03 
    ELSE CASE WHEN ISNULL(Quantity02, 0) <> 0 THEN Date02 
    ELSE CASE WHEN ISNULL(Quantity01, 0) <> 0 THEN Date01 
    END END END END END END END END END END 
 AS EndDate
FROM MT2002 T00 INNER JOIN MT2003 T01 ON T00.PlanID = T01.PlanID and  T00.DivisionID = T01.DivisionID 
        INNER JOIN MT2001 T02 ON T02.PlanID = T00.PlanID  and  T00.DivisionID = T02.DivisionID 
WHERE ' + CASE WHEN @IsDate = 1 THEN ' T02.VoucherDate BETWEEN ''' + @sFromDate + ''' AND ''' + @sToDate + ''''  ELSE ' 
    T02.TranMonth + T02.TranYear*100  BETWEEN ' + @FromPeriod + ' AND ' + @ToPeriod  END + ' 
    AND T00.DivisionID = ''' + @DivisionID + '''
 AND T00.PlanID LIKE ''' + @PlanID + CASE WHEN ISNULL(@FromDepartmentID, '') <> '' THEN  ''' AND
    T00.DepartmentID BETWEEN ''' + @FromDepartmentID + ''' AND ''' + @ToDepartmentID + ''''  ELSE '''' END + 
    CASE WHEN ISNULL(@PlanDetailID, '') <> '' THEN ' AND T00.PlanDetailID LIKE ''' + @PlanDetailID + '''' ELSE '' END

EXEC(@sSQL + @sSQL1) 

----print @sSQL1 
SET NOCOUNT OFF