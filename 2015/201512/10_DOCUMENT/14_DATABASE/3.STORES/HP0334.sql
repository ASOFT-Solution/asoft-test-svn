IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0334]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0334]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- Update dữ liệu cho hồ sơ lương từ form Cập nhật thay đổi hồ sơ nhân sự
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 02/12/2013 by Thanh Sơn
---- 
---- Modified on 28/08/2013 by 
-- <Example>
---- EXEC HP0334 'SAS', 'ADMIN', 'AACABDF7-CFC6-40C6-B8F1-8A3458E37EF4',9,2013
/*
INSERT INTO HT0330 (DivisionID, VoucherDate, Notes, FromDepartmentID, ToDepartmentID, BaseSalary)
VALUES ('AS', GETDATE(), 'Testing', 'ADM', 'PJS', 1500000)

SELECT * FROM  HT0330

*/
CREATE PROCEDURE HP0334
( 
		@DivisionID VARCHAR(50),
		@UserID VARCHAR(50),
		@APK VARCHAR(50),
		@TranMonth INT,
		@TranYear INT		
) 
AS 
DECLARE @sWhere NVARCHAR(MAX),
		@sSQL1 NVARCHAR(MAX),
		@sSQL2 NVARCHAR(MAX),
		@sSQL3 NVARCHAR(MAX),
		@sSQL4 NVARCHAR(MAX)
		
SET @sWhere = ''
SET @sSQL2 = ''


DECLARE @FromDepartmentID NVARCHAR(50),
		@ToDepartmentID NVARCHAR(50),
		@FromTeamID NVARCHAR(50),
		@ToTeamID NVARCHAR(50),
		@FromEmployeeID NVARCHAR(50),
		@ToEmployeeID NVARCHAR(50)

SELECT	@FromDepartmentID = FromDepartmentID ,
		@ToDepartmentID = ToDepartmentID,
		@FromTeamID = FromTeamID,
		@ToTeamID = ToTeamID,
		@FromEmployeeID = FromEmployeeID,
		@ToEmployeeID = ToEmployeeID
FROM HT0330 
WHERE DivisionID = @DivisionID 
AND APK = @APK

SET @sWhere = '
	AND HT2400.DepartmentID >= '''+@FromDepartmentID+'''
	AND HT2400.DepartmentID <= '''+@ToDepartmentID+'''
	'
IF ISNULL(@FromTeamID,'') <> '' OR  ISNULL(@ToTeamID,'') <> '' 
SET @sWhere = @sWhere + '
	AND HT2400.TeamID >= '''+@FromTeamID+'''
	AND HT2400.TeamID <= '''+@ToTeamID+'''
	'
IF ISNULL(@FromEmployeeID,'') <> '' OR  ISNULL(@ToEmployeeID,'') <> '' 
SET @sWhere = @sWhere + '
	AND HT2400.EmployeeID >= '''+@FromEmployeeID+'''
	AND HT2400.EmployeeID <= '''+@ToEmployeeID+'''
	'
	
CREATE TABLE #VALUES
(	
	TableID VARCHAR(50),
	ID VARCHAR(100)
)
 INSERT INTO #VALUES VALUES ('HT2400','IsJobWage') 
 INSERT INTO #VALUES VALUES ('HT2400','IsPiecework') 
 INSERT INTO #VALUES VALUES ('HT2400','BaseSalary') 
 INSERT INTO #VALUES VALUES ('HT2400','InsuranceSalary') 
 INSERT INTO #VALUES VALUES ('HT2400','Salary01') 
 INSERT INTO #VALUES VALUES ('HT2400','Salary02') 
 INSERT INTO #VALUES VALUES ('HT2400','Salary03') 
 INSERT INTO #VALUES VALUES ('HT2400','SalaryCoefficient') 
 INSERT INTO #VALUES VALUES ('HT2400','TaxObjectID')
 INSERT INTO #VALUES VALUES ('HT2400','DutyCoefficient') 
 INSERT INTO #VALUES VALUES ('HT2400','TimeCoefficient') 
 INSERT INTO #VALUES VALUES ('HT2400','C01') 
 INSERT INTO #VALUES VALUES ('HT2400','C02') 
 INSERT INTO #VALUES VALUES ('HT2400','C03') 
 INSERT INTO #VALUES VALUES ('HT2400','C04') 
 INSERT INTO #VALUES VALUES ('HT2400','C05') 
 INSERT INTO #VALUES VALUES ('HT2400','C06') 
 INSERT INTO #VALUES VALUES ('HT2400','C07') 
 INSERT INTO #VALUES VALUES ('HT2400','C08') 
 INSERT INTO #VALUES VALUES ('HT2400','C09') 
 INSERT INTO #VALUES VALUES ('HT2400','C10') 
 INSERT INTO #VALUES VALUES ('HT2400','C11') 
 INSERT INTO #VALUES VALUES ('HT2400','C12') 
 INSERT INTO #VALUES VALUES ('HT2400','C13') 
 INSERT INTO #VALUES VALUES ('HT2400','C14') 
 INSERT INTO #VALUES VALUES ('HT2400','C15') 
 INSERT INTO #VALUES VALUES ('HT2400','C16') 
 INSERT INTO #VALUES VALUES ('HT2400','C17') 
 INSERT INTO #VALUES VALUES ('HT2400','C18') 
 INSERT INTO #VALUES VALUES ('HT2400','C19') 
 INSERT INTO #VALUES VALUES ('HT2400','C20') 
 INSERT INTO #VALUES VALUES ('HT2400','C21') 
 INSERT INTO #VALUES VALUES ('HT2400','C22') 
 INSERT INTO #VALUES VALUES ('HT2400','C23') 
 INSERT INTO #VALUES VALUES ('HT2400','C24') 
 INSERT INTO #VALUES VALUES ('HT2400','C25') 



SET @sSQL1 = '
DECLARE @SValue NVARCHAR(250)

CREATE TABLE #Employee
(	
	EmployeeID NVARCHAR(50)
)

INSERT INTO #Employee (	EmployeeID)
SELECT EmployeeID 
FROM HT2400 
WHERE DivisionID = '''+@DivisionID+'''
AND TranMonth = '''+STR(@TranMonth)+'''
AND TranYear = '''+STR(@TranYear)+'''
'

DECLARE @cursor CURSOR , 
		@ID VARCHAR(100),
		@TableID VARCHAR(50)		
		
SET @cursor = CURSOR FORWARD_ONLY FOR
SELECT ID, TableID
FROM #VALUES

OPEN @cursor

FETCH NEXT FROM @cursor INTO @ID, @TableID
WHILE @@FETCH_STATUS = 0
BEGIN

	SET @sSQL2 = @sSQL2 + '
	SET @SValue = (SELECT '+@ID+' FROM HT0330 WHERE APK = '''+@APK+''' )
	IF @SValue IS NOT NULL
	BEGIN
		UPDATE	'+@TableID+'
		SET		'+@ID+' = @SValue
		WHERE	DivisionID = '''+@DivisionID+'''
				AND EmployeeID IN (SELECT EmployeeID FROM #Employee )
				AND TranMonth = '''+STR(@TranMonth)+'''
                AND TranYear = '''+STR(@TranYear)+'''
	END
	'
	
  FETCH NEXT FROM @cursor INTO @ID, @TableID
END 
CLOSE @cursor
DEALLOCATE @cursor

PRINT(@sSQL1)
PRINT(@sWhere)
PRINT(@sSQL2)

EXEC (@sSQL1+@sWhere+@sSQL2)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON