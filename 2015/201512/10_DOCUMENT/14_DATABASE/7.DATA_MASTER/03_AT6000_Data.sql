-- <Summary>
---- 
-- <History>
---- Create on 18/12/2012 by Lê Thị Thu Hiền
---- Modified on 19/02/2014 by Le Thi Thu Hien
---- Modified on 03/12/2015 by Phương Thảo: Bổ sung tiêu thức 'JBY' - Customize Meiko
---- <Example>
---- Add Data
IF NOT EXISTS(SELECT TOP 1 1 FROM AT6000 WHERE Code = 'A06')	
	INSERT INTO AT6000 (DivisionID, Code, Description, Type, Orders, Disabled, IsASOFTFA, DescriptionE)
		SELECT	AT.DivisionID, STD.Code, STD.Description, STD.Type, STD.Orders, STD.Disabled, STD.IsASOFTFA, STD.DescriptionE
		FROM	AT6000STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.Code  = 'A06'

IF NOT EXISTS(SELECT TOP 1 1 FROM AT6000 WHERE Code = 'A07')	
	INSERT INTO AT6000 (DivisionID, Code, Description, Type, Orders, Disabled, IsASOFTFA, DescriptionE)
		SELECT	AT.DivisionID, STD.Code, STD.Description, STD.Type, STD.Orders, STD.Disabled, STD.IsASOFTFA, STD.DescriptionE
		FROM	AT6000STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.Code  = 'A07'

IF NOT EXISTS(SELECT TOP 1 1 FROM AT6000 WHERE Code = 'A08')	
	INSERT INTO AT6000 (DivisionID, Code, Description, Type, Orders, Disabled, IsASOFTFA, DescriptionE)
		SELECT	AT.DivisionID, STD.Code, STD.Description, STD.Type, STD.Orders, STD.Disabled, STD.IsASOFTFA, STD.DescriptionE
		FROM	AT6000STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.Code  = 'A08'
		
IF NOT EXISTS(SELECT TOP 1 1 FROM AT6000 WHERE Code = 'A09')	
	INSERT INTO AT6000 (DivisionID, Code, Description, Type, Orders, Disabled, IsASOFTFA, DescriptionE)
		SELECT	AT.DivisionID, STD.Code, STD.Description, STD.Type, STD.Orders, STD.Disabled, STD.IsASOFTFA, STD.DescriptionE
		FROM	AT6000STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.Code  = 'A09'
		
IF NOT EXISTS(SELECT TOP 1 1 FROM AT6000 WHERE Code = 'A10')	
	INSERT INTO AT6000 (DivisionID, Code, Description, Type, Orders, Disabled, IsASOFTFA, DescriptionE)
		SELECT	AT.DivisionID, STD.Code, STD.Description, STD.Type, STD.Orders, STD.Disabled, STD.IsASOFTFA, STD.DescriptionE
		FROM	AT6000STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.Code  = 'A10'
IF NOT EXISTS (SELECT TOP 1 1 FROM AT6000 WHERE Code = 'BD' AND [Type] = 0)
INSERT INTO AT6000
(
	DivisionID, Code,
	[Description],
	[Type],
	Orders,
	[Disabled],
	IsASOFTFA,
	DescriptionE
)
SELECT DivisionID,
	'BD',
	N'Số dư đầu kỳ bên nợ',
	0,
	0,
	0,
	0,
	N'Opening Debit Balance '
FROM AT1101 

IF NOT EXISTS (SELECT TOP 1 1 FROM AT6000 WHERE Code = 'BC' AND [Type] = 0)
INSERT INTO AT6000
(
	DivisionID, Code,
	[Description],
	[Type],
	Orders,
	[Disabled],
	IsASOFTFA,
	DescriptionE
)
SELECT DivisionID,
	'BC',
	N'Số dư đầu kỳ bên có',
	0,
	0,
	0,
	0,
	N'Opening Credit Balance '
FROM AT1101 

IF NOT EXISTS (SELECT TOP 1 1 FROM AT6000 WHERE Code = 'ED' AND [Type] = 0)
INSERT INTO AT6000
(
	DivisionID, Code,
	[Description],
	[Type],
	Orders,
	[Disabled],
	IsASOFTFA,
	DescriptionE
)
SELECT DivisionID,
	'ED',
	N'Số dư cuối kỳ bên nợ',
	0,
	0,
	0,
	0,
	N'Ending Debit Balance '
FROM AT1101 

IF NOT EXISTS (SELECT TOP 1 1 FROM AT6000 WHERE Code = 'EC' AND [Type] = 0)
INSERT INTO AT6000
(
	DivisionID, Code,
	[Description],
	[Type],
	Orders,
	[Disabled],
	IsASOFTFA,
	DescriptionE
)
SELECT DivisionID,
	'EC',
	N'Số dư cuối kỳ bên có',
	0,
	0,
	0,
	0,
	N'Ending Credit Balance '
FROM AT1101

----- Update Data: thiết lập loại khoản mục bên CI
UPDATE A
SET
	A.Description = A5.UserName ,
	A.DescriptionE = A5.UserNameE 
FROM AT6000 A
INNER JOIN AT0005 A5 ON A5.DivisionID = A.DivisionID AND A.Code = A5.TypeID
WHERE A.Code LIKE 'A%'

DECLARE @CustomerName int
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

IF (@CustomerName = 50)
BEGIN
	IF NOT EXISTS (SELECT TOP 1 1 FROM AT6000 WHERE Code = 'JBY' AND [Type] = 0)
	INSERT INTO AT6000
	(
		DivisionID, Code,
		[Description],
		[Type],
		Orders,
		[Disabled],
		IsASOFTFA,
		DescriptionE
	)
	SELECT DivisionID,
		'JBY',
		N'Số dư đầu năm theo Niên độ Nhật Bản',
		0,
		0,
		0,
		0,
		N'Japanese Opening Year Balance '
	FROM AT1101

END
DROP TABLE #CustomerName