-- <Summary>
---- 
-- <History>
---- Create on 02/08/2013 by Bảo Anh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0002STD WHERE IncomeID = N'I21')
	INSERT INTO HT0002STD(IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IsCalculateNetIncome)
	VALUES (N'I21', N'I21', N'Thu nhập 21', N'Thu nhập 21', 0, 0, NULL, 0)
INSERT INTO HT0002(APK, DivisionID, IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
SELECT NEWID(), A00.DefDivisionID, STD.IncomeID, STD.FieldName, STD.IncomeName, STD.Caption, STD.IsUsed, STD.IsTax, STD.CaptionE, STD.IncomeNameE, STD.IsCalculateNetIncome
FROM HT0002STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.IncomeID = 'I21'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0002 WHERE DivisionID = A00.DefDivisionID AND IncomeID = 'I21')
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0002STD WHERE IncomeID = N'I22')
	INSERT INTO HT0002STD(IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IsCalculateNetIncome)
	VALUES (N'I22', N'I22', N'Thu nhập 22', N'Thu nhập 22', 0, 0, NULL, 0)
INSERT INTO HT0002(APK, DivisionID, IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
SELECT NEWID(), A00.DefDivisionID, STD.IncomeID, STD.FieldName, STD.IncomeName, STD.Caption, STD.IsUsed, STD.IsTax, STD.CaptionE, STD.IncomeNameE, STD.IsCalculateNetIncome
FROM HT0002STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.IncomeID = 'I22'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0002 WHERE DivisionID = A00.DefDivisionID AND IncomeID = 'I22')
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0002STD WHERE IncomeID = N'I23')
	INSERT INTO HT0002STD(IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IsCalculateNetIncome)
	VALUES (N'I23', N'I23', N'Thu nhập 23', N'Thu nhập 23', 0, 0, NULL, 0)
INSERT INTO HT0002(APK, DivisionID, IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
SELECT NEWID(), A00.DefDivisionID, STD.IncomeID, STD.FieldName, STD.IncomeName, STD.Caption, STD.IsUsed, STD.IsTax, STD.CaptionE, STD.IncomeNameE, STD.IsCalculateNetIncome
FROM HT0002STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.IncomeID = 'I23'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0002 WHERE DivisionID = A00.DefDivisionID AND IncomeID = 'I23')
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0002STD WHERE IncomeID = N'I24')
	INSERT INTO HT0002STD(IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IsCalculateNetIncome)
	VALUES (N'I24', N'I24', N'Thu nhập 24', N'Thu nhập 24', 0, 0, NULL, 0)
INSERT INTO HT0002(APK, DivisionID, IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
SELECT NEWID(), A00.DefDivisionID, STD.IncomeID, STD.FieldName, STD.IncomeName, STD.Caption, STD.IsUsed, STD.IsTax, STD.CaptionE, STD.IncomeNameE, STD.IsCalculateNetIncome
FROM HT0002STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.IncomeID = 'I24'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0002 WHERE DivisionID = A00.DefDivisionID AND IncomeID = 'I24')
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0002STD WHERE IncomeID = N'I25')
	INSERT INTO HT0002STD(IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IsCalculateNetIncome)
	VALUES (N'I25', N'I25', N'Thu nhập 25', N'Thu nhập 25', 0, 0, NULL, 0)	
INSERT INTO HT0002(APK, DivisionID, IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
SELECT NEWID(), A00.DefDivisionID, STD.IncomeID, STD.FieldName, STD.IncomeName, STD.Caption, STD.IsUsed, STD.IsTax, STD.CaptionE, STD.IncomeNameE, STD.IsCalculateNetIncome
FROM HT0002STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.IncomeID = 'I25'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0002 WHERE DivisionID = A00.DefDivisionID AND IncomeID = 'I25')
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0002STD WHERE IncomeID = N'I26')
	INSERT INTO HT0002STD(IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IsCalculateNetIncome)
	VALUES (N'I26', N'I26', N'Thu nhập 26', N'Thu nhập 26', 0, 0, NULL, 0)	
INSERT INTO HT0002(APK, DivisionID, IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
SELECT NEWID(), A00.DefDivisionID, STD.IncomeID, STD.FieldName, STD.IncomeName, STD.Caption, STD.IsUsed, STD.IsTax, STD.CaptionE, STD.IncomeNameE, STD.IsCalculateNetIncome
FROM HT0002STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.IncomeID = 'I26'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0002 WHERE DivisionID = A00.DefDivisionID AND IncomeID = 'I26')
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0002STD WHERE IncomeID = N'I27')
	INSERT INTO HT0002STD(IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IsCalculateNetIncome)
	VALUES (N'I27', N'I27', N'Thu nhập 27', N'Thu nhập 27', 0, 0, NULL, 0)	
INSERT INTO HT0002(APK, DivisionID, IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
SELECT NEWID(), A00.DefDivisionID, STD.IncomeID, STD.FieldName, STD.IncomeName, STD.Caption, STD.IsUsed, STD.IsTax, STD.CaptionE, STD.IncomeNameE, STD.IsCalculateNetIncome
FROM HT0002STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.IncomeID = 'I27'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0002 WHERE DivisionID = A00.DefDivisionID AND IncomeID = 'I27')
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0002STD WHERE IncomeID = N'I28')
	INSERT INTO HT0002STD(IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IsCalculateNetIncome)
	VALUES (N'I28', N'I28', N'Thu nhập 28', N'Thu nhập 28', 0, 0, NULL, 0)
INSERT INTO HT0002(APK, DivisionID, IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
SELECT NEWID(), A00.DefDivisionID, STD.IncomeID, STD.FieldName, STD.IncomeName, STD.Caption, STD.IsUsed, STD.IsTax, STD.CaptionE, STD.IncomeNameE, STD.IsCalculateNetIncome
FROM HT0002STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.IncomeID = 'I28'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0002 WHERE DivisionID = A00.DefDivisionID AND IncomeID = 'I28')
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0002STD WHERE IncomeID = N'I29')
	INSERT INTO HT0002STD(IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IsCalculateNetIncome)
	VALUES (N'I29', N'I29', N'Thu nhập 29', N'Thu nhập 29', 0, 0, NULL, 0)	
INSERT INTO HT0002(APK, DivisionID, IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
SELECT NEWID(), A00.DefDivisionID, STD.IncomeID, STD.FieldName, STD.IncomeName, STD.Caption, STD.IsUsed, STD.IsTax, STD.CaptionE, STD.IncomeNameE, STD.IsCalculateNetIncome
FROM HT0002STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.IncomeID = 'I29'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0002 WHERE DivisionID = A00.DefDivisionID AND IncomeID = 'I29')
IF NOT EXISTS(SELECT TOP 1 1 FROM HT0002STD WHERE IncomeID = N'I30')
	INSERT INTO HT0002STD(IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IsCalculateNetIncome)
	VALUES (N'I30', N'I30', N'Thu nhập 30', N'Thu nhập 30', 0, 0, NULL, 0)	
INSERT INTO HT0002(APK, DivisionID, IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
SELECT NEWID(), A00.DefDivisionID, STD.IncomeID, STD.FieldName, STD.IncomeName, STD.Caption, STD.IsUsed, STD.IsTax, STD.CaptionE, STD.IncomeNameE, STD.IsCalculateNetIncome
FROM HT0002STD STD CROSS JOIN (SELECT DISTINCT DefDivisionID FROM AT0000) A00
WHERE STD.IncomeID = 'I30'
    AND NOT EXISTS(SELECT TOP 1 1 FROM HT0002 WHERE DivisionID = A00.DefDivisionID AND IncomeID = 'I30')