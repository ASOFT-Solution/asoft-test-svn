IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP1280]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP1280]
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
---- Modified on 13/08/2013 by 
-- <Example>
---- EXEC HP1280 'CTY', 'HONGMAI', 4, 2013
CREATE PROCEDURE HP1280
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
		@ID AS NVARCHAR(50),
		@OrderNo AS TINYINT,
		@No AS TINYINT,
		@sSQL AS NVARCHAR(MAX),
		@sSQL1 AS NVARCHAR(MAX),
		@sWHERE AS NVARCHAR(MAX),
		@sWhere1 AS NVARCHAR(MAX),
		@Time AS int

SET @sWHERE = ''
SET @sWHERE1 = ''
SET @OrderNo = 1

SET @ID = ( SELECT TOP 1 ID FROM HT0276 
			WHERE	DivisionID = @DivisionID
					AND (CONVERT(DATETIME,GETDATE(), 12) BETWEEN CONVERT(DATETIME , BeginDate, 12) AND CONVERT(DATETIME , EndDate, 12))
			)
		

DECLARE @cursor CURSOR 

SET @cursor = CURSOR FORWARD_ONLY FOR
SELECT	Mode, Sex, Years, ISNULL(TIME,0) AS Time
FROM	HT0276
WHERE	ID = @ID

--SELECT * FROM HV1400 

OPEN @cursor

FETCH NEXT FROM @cursor INTO @Mode, @Sex, @Years, @Time

WHILE @@FETCH_STATUS = 0
BEGIN
	
	SET @sWhere1 = 'HT00.DivisionID = '''+@DivisionID+''''
		
	IF @Mode = 1
		SET @sWHERE1 = @sWHERE1 + '
			AND DATEDIFF(YEAR, HT03.WorkDate, DATEADD ( mm , -'+STR(@Time)+' , GETDATE() ))>= '+STR(@Years)+' '
	IF @Mode = 0
		SET @sWHERE1 = @sWHERE1 + '
			AND DATEDIFF(YEAR, HT00.Birthday, DATEADD ( mm , -'+STR(@Time)+' , GETDATE() ))>= '+STR(@Years)+' '
	IF @Sex = 0
		SET @sWHERE1 = @sWHERE1 + '
			AND HT00.IsMale = 0 '
	IF @Sex = 1 
		SET @sWHERE1 = @sWHERE1 + '
			AND HT00.IsMale = 1 '
	
	SET @sWHERE = @sWHERE +' OR ( '+@sWhere1+' ) '
	
	
  FETCH NEXT FROM @cursor INTO @Mode, @Sex, @Years, @Time
END 


CLOSE @cursor
DEALLOCATE @cursor

IF @sWHERE = ''
SET @sWHERE = ''

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
WHERE	(1=0) 
		'
PRINT(@sSQL)
PRINT(@sWHERE)

EXEC (@sSQL+ @sWHERE)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

