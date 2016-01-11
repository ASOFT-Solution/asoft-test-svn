-- <Summary>
---- 
-- <History>
---- Create on 29/05/2011 by Việt Khánh
---- Modified on ... by ...
---- <Example>
DECLARE
@ReportCode NVARCHAR(50),
@Cursor CURSOR

SET @Cursor = CURSOR SCROLL KEYSET FOR
SELECT ReportCode FROM AT4712 WHERE ColumnID = 0
OPEN @Cursor
FETCH NEXT FROM @Cursor INTO @ReportCode
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE AT4712 SET ColumnID = ColumnID + 1 WHERE ReportCode = @ReportCode
	FETCH NEXT FROM @Cursor INTO @ReportCode
END
CLOSE @Cursor