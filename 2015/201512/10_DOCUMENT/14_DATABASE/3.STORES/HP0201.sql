IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0201]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0201]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Load dữ liệu cho grid chấm công sản phẩm theo ca cho nhân viên theo phương pháp phân bổ
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Nguyễn Thanh Sơn, date: 27/08/2013
-- <Example>
---- 
/*
EXEC HP0201 'CTY', 'Admin',3, 2013,'LAN01', 0,'2013-03-19 00:00:00',0,'CA2'
*/

CREATE PROCEDURE HP0201
(
@DivisionID AS NVARCHAR(50),
		@UserID AS NVARCHAR(50),
		@TranMonth AS INT,
		@TranYear AS INT,
		@TimesID AS NVARCHAR(50),
        @CheckDate AS TINYINT,
        @TrackingDate AS DATETIME,
        @CheckShift AS TINYINT,
        @ShiftID AS NVARCHAR(50)
 )

AS
DECLARE @sSQL NVARCHAR(MAX),
    @sSQL1 NVARCHAR(MAX),
	@cur CURSOR,
	@Column INT,
	@sWhere NVARCHAR(MAX),
	@sGroup NVARCHAR(MAX),
	@ProductID NVARCHAR(50)

Select @Column = 1, @sSQL = '' 
SET @sWhere=''
SET @sSQL = '' 
Set @sSQL = 
'
SELECT HT.DivisionID,HT.TimesID,HT.TranMonth,HT.TranYear,HT.AllocationID,HT.DepartmentID,HT.TeamID,HT.TrackingDate,HT.ShiftID,
 AT.DepartmentName,
 HT1.TeamName ,' 	
Set @cur = Cursor scroll keyset for
		Select ProductID 
		From HT1015 
		Where DivisionID = @DivisionID And DISABLED=0
		Order BY ProductID
Open @cur
Fetch next from @cur into @ProductID

While @@Fetch_Status = 0
Begin	
	Set @sSQL = @sSQL + '	
	sum(case when ProductID = N''' + @ProductID +
	 ''' then (case when Quantity = 0 then NULL else Quantity end)  else NULL end) as P' + right('0' + convert(varchar(2), @Column),2) +','	
	Set @Column = @Column + 1
	Fetch next from @cur into @ProductID
End

Set @sSQL = left(@sSQL, len(@sSQL) - 1) +  
' 
FROM HT0289 HT 
LEFT JOIN AT1102 AT ON HT.DivisionID=AT.DivisionID AND HT.DepartmentID=AT.DepartmentID
LEFT JOIN HT1101 HT1 ON HT.DivisionID=AT.DivisionID AND HT.DepartmentID=HT1.DepartmentID AND ISNULL(HT.TeamID,'''')= ISNULL(HT1.TeamID,'''')
WHERE HT.DivisionID='''+@DivisionID+'''
AND  TranMonth='+STR(@TranMonth)+'
AND  TranYear='+STR (@TranYear)+' 
AND   HT.TimesID='''+@TimesID+'''
'

 IF @CheckDate = 1  SET @sWhere=@sWhere +  N'   
AND convert(nvarchar(10),isnull( HT.TrackingDate,''1900-01-01 00:00:00''), 101)='''+convert(nvarchar(10),@TrackingDate, 101)+'''
'
ELSE SET @sWhere=@sWhere +  N'  
AND HT.TrackingDate IS NULL
'
IF @CheckShift = 1  SET @sWhere=@sWhere + N'
AND HT.ShiftID= '''+@ShiftID+'''  
'
ELSE SET @sWhere=@sWhere + N'
AND HT.ShiftID IS NULL
'
SET @sGroup=N'
GROUP BY HT.DivisionID,HT.TimesID,HT.TranMonth,HT.TranYear,HT.AllocationID,HT.DepartmentID,HT.TeamID,HT.TrackingDate,HT.ShiftID,
 AT.DepartmentName,
 HT1.TeamName
'

Close @cur
PRINT(@sSQL+@sWhere+@sGroup)
EXEC(@sSQL+@sWhere+@sGroup)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

