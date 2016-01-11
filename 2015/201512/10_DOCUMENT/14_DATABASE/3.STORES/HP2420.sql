/****** Object:  StoredProcedure [dbo].[HP2420]    Script Date: 01/09/2012 14:20:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2420]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2420]
GO

/****** Object:  StoredProcedure [dbo].[HP2420]    Script Date: 01/09/2012 14:20:33 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[HP2420]  @DivisionID nvarchar(50), @ProjectID nvarchar(50),
				@TranMonth int,
				@TranYear int
AS
DECLARE @ParentID nvarchar(50)

DECLARE ParentID_Cursor CURSOR FOR
SELECT DISTINCT ParentID FROM HT0006 WHERE IsUsed = 1 And DivisionID = @DivisionID

OPEN ParentID_Cursor

FETCH NEXT FROM ParentID_Cursor
INTO @ParentID

WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @sSQL nvarchar(4000)
	SET @sSQL = 'SELECT EmployeeID,TranMonth,TranYear,'
	DECLARE @DefineID nvarchar(20)

	DECLARE DefineID_Cursor CURSOR FOR
	SELECT DefineID FROM HT0006 WHERE ParentID = '' + @ParentID + '' and IsUsed = 1  And DivisionID = @DivisionID
	
	OPEN DefineID_Cursor

	FETCH NEXT FROM DefineID_Cursor
	INTO @DefineID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sSQL = @sSQL + 'Isnull(' + @DefineID + ',0) + '
		FETCH NEXT FROM DefineID_Cursor
		INTO @DefineID	
	END
	CLOSE DefineID_Cursor
	DEALLOCATE DefineID_Cursor
	SET @sSQL = @sSQL + '0 AS TONG FROM HT2421 WHERE TranMonth = ' + STR(@TranMonth)
	SET @sSQL = @sSQL + ' AND TranYear = ' + STR(@TranYear)
	SET @sSQL = @sSQL + ' AND DivisionID = ''' + @DivisionID+''
	PRINT @sSQL
	If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='HV2420')
		Exec('Create view HV2420
			as '+@sSQL)
	Else	
		Exec('Alter view HV2420
			as '+@sSQL)
	--EXEC (@sSQL)
	If not Exists (Select 1 From SysObjects Where Xtype='V' and Name ='HV2426')
		Exec('Create view HV2426
			as ' + 'SELECT EmployeeID,TranMonth,TranYear,SUM(TONG)AS TONG1 FROM HV2420 GROUP BY EmployeeID,TranMonth,TranYear')
	Else	
		Exec('Alter view HV2426
			as ' + 'SELECT EmployeeID,TranMonth,TranYear,SUM(TONG)AS TONG1 FROM HV2420 GROUP BY EmployeeID,TranMonth,TranYear')
---------------------------------------
	DECLARE @EmployeeID AS nvarchar(50),@SUM AS MONEY--,@TranMonth AS INT,@TranYear AS INT,@SUM AS MONEY

	DECLARE HT2421_Cursor CURSOR FOR
	SELECT EmployeeID,TranMonth,TranYear,Tong1
	FROM HV2426
	
	OPEN HT2421_Cursor
	
	FETCH NEXT FROM HT2421_Cursor
	INTO @EmployeeID,@TranMonth,@TranYear,@SUM
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sSQL = 'UPDATE HT2400 SET '
		SET @sSQL = @sSQL + @ParentID + '=' + CAST(@SUM AS nvarchar(50))
		SET @sSQL = @sSQL + ' WHERE EmployeeID = ''' + @EmployeeID + ''' AND TranMonth =' 
		SET @sSQL = @sSQL + STR(@TranMonth) + ' AND TranYear = ' + STR(@TranYear)
		SET @sSQL = @sSQL + ' And DivisionID = ''' + @DivisionID + ''
		--PRINT @sSQL
		EXEC (@sSQL)
		--UPDATE HT2400
		--SET @ParentID = @SUM
		--WHERE EmployeeID = @EmployeeID AND TranMonth = @TranMonth AND TranYear = @TranYear	
		FETCH NEXT FROM HT2421_Cursor
		INTO @EmployeeID,@TranMonth,@TranYear,@SUM
	END
	CLOSE HT2421_Cursor
	DEALLOCATE HT2421_Cursor
---------------------------------------
	FETCH NEXT FROM ParentID_Cursor
	INTO @ParentID
END
CLOSE ParentID_Cursor
DEALLOCATE ParentID_Cursor


GO


