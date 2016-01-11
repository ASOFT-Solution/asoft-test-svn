IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0304]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0304]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Load dữ liệu cho grid hiệu chỉnh chấm công sản phẩm theo ca (PPCĐ)
-- <History>
----Created by: Nguyễn Thanh Sơn, date: 10/10/2013
-- <Example>
---- 
/*
EXEC HP0304 'CTY', '',10, 2013,'LAN01', 'PQS','%', 0,'2013-10-01 09:19:33.093',0,'ca 1'
*/

CREATE PROCEDURE HP0304
(
        @DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@TimesID AS NVARCHAR(50),
		@DepartmentID AS NVARCHAR(50),
		@TeamID AS NVARCHAR(50),
        @CheckDate AS TINYINT,
        @TrackingDate AS DATETIME,
        @CheckShift AS TINYINT,
        @ShiftID AS NVARCHAR(50)
 )

AS
DECLARE 
	@sSQL NVARCHAR(MAX),
    @sSQL1 NVARCHAR(MAX),
	@cur CURSOR,
	@Column INT,
	@sWhere NVARCHAR(MAX),
	@sGroup NVARCHAR(MAX),
	@ProductID NVARCHAR(50),
	@sUnion NVARCHAR(MAX)
	
SELECT @Column = 1, @sSQL = ''
SET @sWhere=''
SET @sSQL = '' 
IF @CheckDate = 1  SET @sWhere=@sWhere +  N'   
AND convert(nvarchar(10),isnull( HT.TrackingDate,''1900-01-01 00:00:00''), 101)='''+convert(nvarchar(10),@TrackingDate, 101)+'''
'
ELSE SET @sWhere=@sWhere +  N'AND HT.TrackingDate IS NULL
'
IF @CheckShift = 1 SET @sWhere=@sWhere + N'AND HT.ShiftID= '''+@ShiftID+''' '
ELSE SET @sWhere=@sWhere + N'AND HT.ShiftID IS NULL
'

SET @sSQL =N'
SELECT * FROM 
(
 SELECT HT.EmployeeID,HT.DepartmentID,HT.TeamID,HT.TrackingDate,HT.ShiftID,
 LTRIM(RTRIM(ISNULL(HT2.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(HT2.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(HT2.FirstName,''''))) AS EmployeeName,
 AT.DepartmentName, HT1.TeamName,' 
SET @sUnion=N'
 UNION ALL
 SELECT H24.EmployeeID,H24.DepartmentID,H24.TeamID,NULL AS TrackingDate, NULL AS ShiftID,
 LTRIM(RTRIM(ISNULL(H14.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H14.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(H14.FirstName,''''))) AS EmployeeName,
 AT.DepartmentName, HT1.TeamName,'
Set @cur = Cursor scroll keyset for
		Select ProductID 
		From HT1015 
		Where DivisionID = @DivisionID And DISABLED=0
		Order BY ProductID
Open @cur
Fetch next from @cur into @ProductID

WHILE @@Fetch_Status = 0
BEGIN	
	SET @sSQL = @sSQL + N'	
	SUM(CASE WHEN ProductID = N''' + @ProductID + ''' THEN (CASE WHEN Quantity = 0 THEN NULL ELSE Quantity END)  ELSE NULL END) AS P' + right('0' + convert(varchar(2), @Column),2) +','
	SET @sUnion = @sUnion +	N'
	NULL AS P' + right('0' + convert(varchar(2), @Column),2) +','
	Set @Column = @Column + 1
	Fetch next from @cur into @ProductID
END

Set @sSQL = left(@sSQL, len(@sSQL) - 1) + ' 
FROM HT0287 HT 
LEFT JOIN HT1400 HT2 on HT.DivisionID=HT2.DivisionID AND HT.EmployeeID=HT2.EmployeeID
LEFT JOIN AT1102 AT ON HT.DivisionID=AT.DivisionID AND HT.DepartmentID=AT.DepartmentID
LEFT JOIN HT1101 HT1 ON HT.DivisionID=AT.DivisionID AND HT.DepartmentID=HT1.DepartmentID AND HT.TeamID = HT1.TeamID
WHERE HT.DivisionID='''+@DivisionID+'''
AND   HT.TimesID='''+@TimesID+'''
AND   HT.TranMonth= '+LTRIM(STR(@TranMonth))+'
AND   HT.TranYear= '+LTRIM(STR(@TranYear))+'
AND   HT.DepartmentID='''+@DepartmentID+'''
AND   ISNULL(HT.TeamID,'''')LIKE ISNULL('''+@TeamID+''','''')
'
SET @sUnion= LEFT(@sUnion, LEN(@sUnion) -1) +N'
FROM HT2400 H24 
LEFT JOIN HT1400 H14 on H14.DivisionID=H24.DivisionID AND H14.EmployeeID=H24.EmployeeID
LEFT JOIN AT1102 AT ON AT.DivisionID=H24.DivisionID AND AT.DepartmentID=H24.DepartmentID
LEFT JOIN HT1101 HT1 ON HT1.DivisionID=H24.DivisionID AND HT1.DepartmentID=H24.DepartmentID AND HT1.TeamID = H24.TeamID
WHERE H24.DivisionID = '''+@DivisionID+'''
AND   H24.TranMonth= '+LTRIM(STR(@TranMonth))+'
AND   H24.TranYear= '+LTRIM(STR(@TranYear))+'
AND   H24.DepartmentID='''+@DepartmentID+'''
AND   ISNULL(H24.TeamID,'''')LIKE ISNULL('''+@TeamID+''','''')
AND   H24.EmployeeID NOT IN (SELECT EmployeeID FROM HT0287 HT
                             WHERE DivisionID='''+@DivisionID+'''
                             AND   HT.TimesID='''+@TimesID+'''
                             AND   HT.TranMonth= '+LTRIM(STR(@TranMonth))+'
                             AND   HT.TranYear= '+LTRIM(STR(@TranYear))+'
                             AND   HT.DepartmentID='''+@DepartmentID+'''
                             AND   ISNULL(HT.TeamID,'''')LIKE ISNULL('''+@TeamID+''','''')
                             '+@sWhere+')
)A
ORDER BY EmployeeID
'

SET @sGroup=N'
GROUP BY HT.EmployeeID,HT.DepartmentID,HT.TeamID,HT.TrackingDate,HT.ShiftID,
LTRIM(RTRIM(ISNULL(HT2.LastName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(HT2.MiddleName,'''')))+'' ''+LTRIM(RTRIM(ISNULL(HT2.FirstName,''''))),
AT.DepartmentName, HT1.TeamName
'
Close @cur

PRINT(@sSQL+@sWhere)
PRINT(@sGroup)
PRINT(@sUnion)
EXEC(@sSQL+@sWhere+@sGroup+@sUnion)
	

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

