-- <Summary>
---- 
-- <History>
---- Create on 01/08/2013 by Bảo Anh
---- Modified on ... by ...
---- <Example>

IF NOT EXISTS(SELECT TOP 1 1 FROM HT0003STD WHERE CoefficientID = N'C14')
	INSERT INTO HT0003STD(CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
	VALUES (N'C14', N'C14', N'Hệ số 14', N'C14', 0)
	
INSERT INTO HT0003(APK, DivisionID, CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
SELECT NEWID(), A00.DefDivisionID, STD.CoefficientID, STD.FieldName, STD.CoefficientName, STD.Caption, STD.IsUsed
FROM HT0003STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.CoefficientID = 'C14'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0003 WHERE DivisionID = A00.DefDivisionID AND CoefficientID = 'C14')
---------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0003STD WHERE CoefficientID = N'C15')
	INSERT INTO HT0003STD(CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
	VALUES (N'C15', N'C15', N'Hệ số 15', N'C15', 0)

INSERT INTO HT0003(APK, DivisionID, CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
SELECT NEWID(), A00.DefDivisionID, STD.CoefficientID, STD.FieldName, STD.CoefficientName, STD.Caption, STD.IsUsed
FROM HT0003STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.CoefficientID = 'C15'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0003 WHERE DivisionID = A00.DefDivisionID AND CoefficientID = 'C15')
---------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0003STD WHERE CoefficientID = N'C16')
	INSERT INTO HT0003STD(CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
	VALUES (N'C16', N'C16', N'Hệ số 16', N'C16', 0)
	
INSERT INTO HT0003(APK, DivisionID, CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
SELECT NEWID(), A00.DefDivisionID, STD.CoefficientID, STD.FieldName, STD.CoefficientName, STD.Caption, STD.IsUsed
FROM HT0003STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.CoefficientID = 'C16'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0003 WHERE DivisionID = A00.DefDivisionID AND CoefficientID = 'C16')
---------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0003STD WHERE CoefficientID = N'C17')
	INSERT INTO HT0003STD(CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
	VALUES (N'C17', N'C17', N'Hệ số 17', N'C17', 0)

INSERT INTO HT0003(APK, DivisionID, CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
SELECT NEWID(), A00.DefDivisionID, STD.CoefficientID, STD.FieldName, STD.CoefficientName, STD.Caption, STD.IsUsed
FROM HT0003STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.CoefficientID = 'C17'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0003 WHERE DivisionID = A00.DefDivisionID AND CoefficientID = 'C17')
---------------------------------------------------------------------------------------------------------------------------------------	
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0003STD WHERE CoefficientID = N'C18')
	INSERT INTO HT0003STD(CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
	VALUES (N'C18', N'C18', N'Hệ số 18', N'C18', 0)

INSERT INTO HT0003(APK, DivisionID, CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
SELECT NEWID(), A00.DefDivisionID, STD.CoefficientID, STD.FieldName, STD.CoefficientName, STD.Caption, STD.IsUsed
FROM HT0003STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.CoefficientID = 'C18'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0003 WHERE DivisionID = A00.DefDivisionID AND CoefficientID = 'C18')
---------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0003STD WHERE CoefficientID = N'C19')
	INSERT INTO HT0003STD(CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
	VALUES (N'C19', N'C19', N'Hệ số 19', N'C19', 0)
	
INSERT INTO HT0003(APK, DivisionID, CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
SELECT NEWID(), A00.DefDivisionID, STD.CoefficientID, STD.FieldName, STD.CoefficientName, STD.Caption, STD.IsUsed
FROM HT0003STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.CoefficientID = 'C19'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0003 WHERE DivisionID = A00.DefDivisionID AND CoefficientID = 'C19')
---------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0003STD WHERE CoefficientID = N'C20')
	INSERT INTO HT0003STD(CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
	VALUES (N'C20', N'C20', N'Hệ số 20', N'C20', 0)

INSERT INTO HT0003(APK, DivisionID, CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
SELECT NEWID(), A00.DefDivisionID, STD.CoefficientID, STD.FieldName, STD.CoefficientName, STD.Caption, STD.IsUsed
FROM HT0003STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.CoefficientID = 'C20'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0003 WHERE DivisionID = A00.DefDivisionID AND CoefficientID = 'C20')
---------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0003STD WHERE CoefficientID = N'C21')
	INSERT INTO HT0003STD(CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
	VALUES (N'C21', N'C21', N'Hệ số 21', N'C21', 0)

INSERT INTO HT0003(APK, DivisionID, CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
SELECT NEWID(), A00.DefDivisionID, STD.CoefficientID, STD.FieldName, STD.CoefficientName, STD.Caption, STD.IsUsed
FROM HT0003STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.CoefficientID = 'C21'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0003 WHERE DivisionID = A00.DefDivisionID AND CoefficientID = 'C21')
---------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0003STD WHERE CoefficientID = N'C22')
	INSERT INTO HT0003STD(CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
	VALUES (N'C22', N'C22', N'Hệ số 22', N'C22', 0)
	
INSERT INTO HT0003(APK, DivisionID, CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
SELECT NEWID(), A00.DefDivisionID, STD.CoefficientID, STD.FieldName, STD.CoefficientName, STD.Caption, STD.IsUsed
FROM HT0003STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.CoefficientID = 'C22'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0003 WHERE DivisionID = A00.DefDivisionID AND CoefficientID = 'C22')
---------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0003STD WHERE CoefficientID = N'C23')
	INSERT INTO HT0003STD(CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
	VALUES (N'C23', N'C23', N'Hệ số 23', N'C23', 0)
	
INSERT INTO HT0003(APK, DivisionID, CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
SELECT NEWID(), A00.DefDivisionID, STD.CoefficientID, STD.FieldName, STD.CoefficientName, STD.Caption, STD.IsUsed
FROM HT0003STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.CoefficientID = 'C23'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0003 WHERE DivisionID = A00.DefDivisionID AND CoefficientID = 'C23')
---------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0003STD WHERE CoefficientID = N'C24')
	INSERT INTO HT0003STD(CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
	VALUES (N'C24', N'C24', N'Hệ số 24', N'C24', 0)
	
INSERT INTO HT0003(APK, DivisionID, CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
SELECT NEWID(), A00.DefDivisionID, STD.CoefficientID, STD.FieldName, STD.CoefficientName, STD.Caption, STD.IsUsed
FROM HT0003STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.CoefficientID = 'C24'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0003 WHERE DivisionID = A00.DefDivisionID AND CoefficientID = 'C24')
---------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0003STD WHERE CoefficientID = N'C25')
	INSERT INTO HT0003STD(CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
	VALUES (N'C25', N'C25', N'Hệ số 25', N'C25', 0)

INSERT INTO HT0003(APK, DivisionID, CoefficientID, FieldName, CoefficientName, Caption, IsUsed)
SELECT NEWID(), A00.DefDivisionID, STD.CoefficientID, STD.FieldName, STD.CoefficientName, STD.Caption, STD.IsUsed
FROM HT0003STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.CoefficientID = 'C25'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0003 WHERE DivisionID = A00.DefDivisionID AND CoefficientID = 'C25')
