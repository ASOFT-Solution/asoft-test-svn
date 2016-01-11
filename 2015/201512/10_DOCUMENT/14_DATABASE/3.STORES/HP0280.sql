IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0280]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0280]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Đổ nguồn cảnh báo
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 13/08/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 31/12/2013 by Thanh Sơn: Bổ sung load theo 2 trường thiết lập: DutyID và TitleID
---- Modified on 31/12/2013 by Le Thi Thu Hien : Chinh Sua dieu kien WHERE
-- <Example>
---- exec HP0280 @DivisionID=N'SAS',@UserID=N'ASOFTADMIN',@TranMonth=11,@TranYear=2013
CREATE PROCEDURE HP0280
( 
	@DivisionID as nvarchar(50),
	@UserID AS nvarchar(50),
	@TranMonth as int,
	@TranYear AS int
) 
AS 

DECLARE @Mode AS NVARCHAR(50),
		@Sex AS TINYINT,
		@Years AS INT,
		@TitleID VARCHAR(50),
		@DutyID VARCHAR(50),
		@ID AS NVARCHAR(50),
		@OrderNo AS TINYINT,
		@No AS TINYINT,
		@sSQL AS NVARCHAR(MAX),
		@sSQL1 AS NVARCHAR(MAX),
		@sWhere AS NVARCHAR(MAX),
		@sWhere1 AS NVARCHAR(MAX),
		@Time AS int

SET @sWHERE = ''
SET @sWHERE1 = ''
SET @OrderNo = 1

SET @ID = ( SELECT TOP 1 ID FROM HT0276 
			WHERE	DivisionID = @DivisionID
					AND (CONVERT(DATETIME,GETDATE(), 12) BETWEEN CONVERT(DATETIME , BeginDate, 12) AND CONVERT(DATETIME , EndDate, 12))			)
		
DECLARE @cursor CURSOR 

SET @cursor = CURSOR FORWARD_ONLY FOR
SELECT	Mode, Sex, ISNULL(TitleID,'') AS TitleID, ISNULL(DutyID,'') AS DutyID, ISNULL(Years,0) AS Years, ISNULL(TIME,0) AS Time
FROM	HT0276
WHERE	ID = @ID
AND GETDATE() BETWEEN BeginDate AND EndDate

OPEN @cursor

FETCH NEXT FROM @cursor INTO @Mode, @Sex,  @TitleID, @DutyID,@Years, @Time

WHILE @@FETCH_STATUS = 0
BEGIN	
	
	SET @sWhere1 = 'HT00.DivisionID = '''+@DivisionID+''''
	IF @Mode = 1 
		SET @sWHERE1 = @sWHERE1 + '
			AND DATEDIFF(YEAR, DATEADD(mm,'+STR(@Time)+',HT03.WorkDate),GETDATE()) >= '+STR(@Years)+' '
			--AND DATEDIFF(YEAR, HT03.WorkDate, DATEADD ( mm , -'+STR(@Time)+' , GETDATE() ))>= '+STR(@Years)+' '
	IF @Mode = 2
		SET @sWhere1 = @sWhere1 + '
			AND DATEDIFF(YEAR, DATEADD(mm,'+STR(@Time)+',HT00.Birthday),GETDATE()) >= '+STR(@Years)+' '
			--AND DATEDIFF(YEAR, HT00.Birthday, DATEADD ( mm , -'+STR(@Time)+' , GETDATE() ))>= '+STR(@Years)+' '
	IF @Sex = 0 
		SET @sWhere1 = @sWhere1 + '
			AND HT00.IsMale = 0 '
	IF @Sex = 1 
		SET @sWhere1 = @sWhere1 + '
			AND HT00.IsMale = 1 '
	IF ISNULL(@TitleID,'') <> '' 
		SET @sWhere1 = @sWhere1 + '
	        AND HT03.TitleID = '+@TitleID+' '
	IF ISNULL(@DutyID,'') <> '' 
		SET @sWhere1 = @sWhere1 + '
	        AND HT03.DutyID = '+@DutyID+' '
	IF @OrderNo = 1      
		SET @sWhere = @sWhere +' WHERE ( '+@sWhere1+' ) '
	ELSE
		SET @sWhere = @sWhere +' OR ( '+@sWhere1+' ) '
	SET @OrderNo = @OrderNo + 1
	
	PRINT(@sWhere1)
	PRINT(@sWhere)
	
  FETCH NEXT FROM @cursor INTO @Mode, @Sex, @TitleID, @DutyID, @Years, @Time
END 


CLOSE @cursor
DEALLOCATE @cursor

SET @sSQL = N'
SELECT  HT00.EmployeeID,
		Ltrim(RTrim(isnull(HT00.LastName,'''')))+ '' '' + LTrim(RTrim(isnull(HT00.MiddleName,''''))) + '' '' + LTrim(RTrim(Isnull(HT00.FirstName,''''))) As EmployeeName,
		CAST(HT00.Birthday As DateTime) as Birthday,
		HT00.IsMale,
		(Case When HT00.IsMale=1 then N''Nam'' else N''Nữ'' End) as IsMaleName, 
		WorkDate,		
		DATEDIFF(YEAR, HT03.WorkDate, GETDATE()) AS WorkTime
FROM	HT1400 HT00
LEFT JOIN HT1403 AS HT03 ON HT00.EmployeeID = HT03.EmployeeID AND  HT00.DivisionID = HT03.DivisionID
		'
PRINT(@sSQL)
PRINT(@sWHERE)

EXEC (@sSQL+ @sWHERE)


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

