-- <Summary>
---- 
-- <History>
---- Create on 14/03/2013 by Thiên Huỳnh
---- Modified on ... by ...
---- <Example>
DECLARE @DivisionID NVarchar(50)
DECLARE cur_AllDivision CURSOR FOR
SELECT AT1101.DivisionID FROM AT1101
OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @DivisionID
WHILE @@fetch_status = 0
  BEGIN
	
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T90.Ana04ID')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T90.Ana04ID', N'Mã phân tích 4','',50,1)
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T1011D.AnaName as Ana04Name')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T1011D.AnaName as Ana04Name', N'Tên mã phân tích 4','',51,1)
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T90.Ana05ID')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T90.Ana05ID', N'Mã phân tích 5','',52,1)
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T1011E.AnaName as Ana05Name')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T1011E.AnaName as Ana05Name', N'Tên mã phân tích 5','',53,1)
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T90.Ana06ID')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T90.Ana06ID', N'Mã phân tích 6','',54,1)
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T1011F.AnaName as Ana06Name')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T1011F.AnaName as Ana06Name', N'Tên mã phân tích 6','',55,1)
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T90.Ana07ID')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T90.Ana07ID', N'Mã phân tích 7','',56,1)
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T1011G.AnaName as Ana07Name')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T1011G.AnaName as Ana07Name', N'Tên mã phân tích 7','',57,1)	
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T90.Ana08ID')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T90.Ana08ID', N'Mã phân tích 8','',58,1)
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T1011H.AnaName as Ana08Name')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T1011H.AnaName as Ana08Name', N'Tên mã phân tích 8','',59,1)	
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T90.Ana09ID')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T90.Ana09ID', N'Mã phân tích 9','',60,1)
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T1011I.AnaName as Ana09Name')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T1011I.AnaName as Ana09Name', N'Tên mã phân tích 9','',61,1)	
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T90.Ana10ID')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T90.Ana10ID', N'Mã phân tích 10','',62,1)
	IF NOT EXISTS ( SELECT ColumnID FROM AT9011 WHERE DivisionID = @DivisionID AND ColumnID = N'T1011J.AnaName as Ana10Name')
		InSert Into AT9011 (APK, DivisionID, ColumnID, ColumnName, SysColumnName, Orders, IsChosen)
		Values (NEWID(), @DivisionID, N'T1011J.AnaName as Ana10Name', N'Tên mã phân tích 10','',63,1)	
    FETCH NEXT FROM cur_AllDivision INTO @DivisionID
  END  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision

