

/****** Object:  StoredProcedure [dbo].[HP2427]    Script Date: 12/27/2011 16:19:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2427]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2427]
GO



/****** Object:  StoredProcedure [dbo].[HP2427]    Script Date: 12/27/2011 16:19:06 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[HP2427] @DivisionID nvarchar(50),
				@TranMonth int,
				@TranYear int
AS
DECLARE 	@ParentID nvarchar(50),
		@ParentID_Cursor As CURSOR,
		@DefineID_Cursor AS CURSOR ,
		@sSQL as nvarchar(4000),
		@DefineID as  nvarchar(50)

Set @ParentID_Cursor = CURSOR  Static FOR SELECT DISTINCT ParentID FROM HT0006 WHERE IsUsed = 1 And DivisionID = @DivisionID 
OPEN @ParentID_Cursor

FETCH NEXT FROM @ParentID_Cursor INTO @ParentID

WHILE @@FETCH_STATUS = 0
BEGIN
	
	SET @sSQL = ''
	Set @DefineID_Cursor = CURSOR STATIC FOR
	SELECT DefineID FROM HT0006 WHERE ParentID = @ParentID and IsUsed = 1 and DivisionID = @DivisionID
	
	OPEN @DefineID_Cursor

	FETCH NEXT FROM @DefineID_Cursor INTO @DefineID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sSQL = @sSQL + 'Isnull(HT2.' + @DefineID + ',0) +'
		FETCH NEXT FROM @DefineID_Cursor INTO @DefineID	
	END
	CLOSE @DefineID_Cursor
	SET @sSQL = @sSQL + '0'

	SET @sSQL = 'Update HT1 Set HT1.' + @ParentID + ' = ' + @sSQL + ' From HT2400 HT1 Inner Join HT2422 HT2 On HT1.EmployeeID = HT2.EmployeeID and HT1.DivisionID = HT2.DivisionID 
			Where HT1.TranMonth = ' + ltrim(@TranMonth) + ' And HT1.Tranyear = ' + ltrim(@TranYear) + ' And HT2.TranMonth = ' + ltrim(@TranMonth) + ' And HT2.Tranyear = ' + ltrim(@TranYear) + ' And HT1.DivisionID  = '''+@DivisionID+''' '
	
	EXEC (@sSQL)

	FETCH NEXT FROM @ParentID_Cursor INTO @ParentID
END
CLOSE @ParentID_Cursor
DEALLOCATE @ParentID_Cursor
GO


