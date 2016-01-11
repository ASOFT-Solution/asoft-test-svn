-- <Summary>
---- 
-- <History>
---- Create on 18/12/2012 by Lê Thị Thu Hiền
---- Modified on 19/02/2014 by Le Thi Thu Hien
---- <Example>
---- Add Data
IF NOT EXISTS(SELECT TOP 1 1 FROM AT6000STD WHERE Code = N'PC' AND Type = 0)
	INSERT INTO AT6000STD(Code, Description, Type, Orders, Disabled, IsASOFTFA, DescriptionE)
	VALUES (N'PC', N'Phát sinh có trong kỳ (Period Credit)', 0, 0, 0, NULL, N'Credit Period')
ELSE
	UPDATE AT6000STD
	SET Description = N'Phát sinh có trong kỳ (Period Credit)', Orders = 0, Disabled = 0, IsASOFTFA = NULL, DescriptionE = N'Credit Period'
	WHERE Code = N'PC' AND Type = 0 AND DescriptionE = N'Inventory period'

IF NOT EXISTS(SELECT TOP 1 1 FROM AT6000STD WHERE Code = N'PD' AND Type = 0)
	INSERT INTO AT6000STD(Code, Description, Type, Orders, Disabled, IsASOFTFA, DescriptionE)
	VALUES (N'PD', N'Phát sinh nợ trong kỳ (Period Debit)', 0, 0, 0, NULL, N'Period Debit')
ELSE
	UPDATE AT6000STD
	SET Description = N'Phát sinh nợ trong kỳ (Period Debit)', Orders = 0, Disabled = 0, IsASOFTFA = NULL, DescriptionE = N'Period Debit'
	WHERE Code = N'PD' AND Type = 0 AND DescriptionE = N'Warehousing period'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT6000STD WHERE Code = N'A06' AND Type = 1)
	INSERT INTO AT6000STD(Code, Description, Type, Orders, Disabled, IsASOFTFA, DescriptionE)
	SELECT DISTINCT TypeID,UserName, 1, 0, 0, NULL, UserNameE 
	FROM AT0005STD
	WHERE TypeID = 'A06' 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT6000STD WHERE Code = N'A07' AND Type = 1)
	INSERT INTO AT6000STD(Code, Description, Type, Orders, Disabled, IsASOFTFA, DescriptionE)
	SELECT DISTINCT TypeID,UserName, 1, 0, 0, NULL, UserNameE 
	FROM AT0005STD
	WHERE TypeID = 'A07' 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT6000STD WHERE Code = N'A08' AND Type = 1)
	INSERT INTO AT6000STD(Code, Description, Type, Orders, Disabled, IsASOFTFA, DescriptionE)
	SELECT DISTINCT TypeID,UserName, 1, 0, 0, NULL, UserNameE 
	FROM AT0005STD
	WHERE TypeID = 'A08' 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT6000STD WHERE Code = N'A09' AND Type = 1)
	INSERT INTO AT6000STD(Code, Description, Type, Orders, Disabled, IsASOFTFA, DescriptionE)
	SELECT DISTINCT TypeID,UserName, 1, 0, 0, NULL, UserNameE 
	FROM AT0005STD
	WHERE TypeID = 'A09' 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT6000STD WHERE Code = N'A10' AND Type = 1)
	INSERT INTO AT6000STD(Code, Description, Type, Orders, Disabled, IsASOFTFA, DescriptionE)
	SELECT DISTINCT TypeID ,UserName, 1, 0, 0, NULL, UserNameE 
	FROM AT0005STD
	WHERE TypeID = 'A10' 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT6000STD WHERE Code = 'BD' AND [Type] = 0)
INSERT INTO AT6000STD
(
	Code,
	[Description],
	[Type],
	Orders,
	[Disabled],
	IsASOFTFA,
	DescriptionE
)
VALUES
(
	'BD',
	N'Số dư đầu kỳ bên nợ',
	0,
	0,
	0,
	0,
	N'Opening Debit Balance '
)
IF NOT EXISTS (SELECT TOP 1 1 FROM AT6000STD WHERE Code = 'BD' AND [Type] = 0)
INSERT INTO AT6000STD
(
	Code,
	[Description],
	[Type],
	Orders,
	[Disabled],
	IsASOFTFA,
	DescriptionE
)
VALUES
(
	'BC',
	N'Số dư đầu kỳ bên có',
	0,
	0,
	0,
	0,
	N'Opening Credit Balance '
)
IF NOT EXISTS (SELECT TOP 1 1 FROM AT6000STD WHERE Code = 'BD' AND [Type] = 0)
INSERT INTO AT6000STD
(
	Code,
	[Description],
	[Type],
	Orders,
	[Disabled],
	IsASOFTFA,
	DescriptionE
)
VALUES
(
	'ED',
	N'Số dư cuối kỳ bên nợ',
	0,
	0,
	0,
	0,
	N'Ending Debit Balance '
)
IF NOT EXISTS (SELECT TOP 1 1 FROM AT6000STD WHERE Code = 'BD' AND [Type] = 0)
INSERT INTO AT6000STD
(
	Code,
	[Description],
	[Type],
	Orders,
	[Disabled],
	IsASOFTFA,
	DescriptionE
)
VALUES
(
	'EC',
	N'Số dư cuối kỳ bên có',
	0,
	0,
	0,
	0,
	N'Ending Credit Balance '
)
-- Cập nhật bảng chuẩn theo tiếng Anh, nếu dùng ngôn ngữ khác cần tạo bản cập nhật mới
UPDATE AT6000STD SET DescriptionE = N'Analysis code 01' WHERE Code = 'A01'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 02' WHERE Code = 'A02'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 03' WHERE Code = 'A03'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 04' WHERE Code = 'A04'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 05' WHERE Code = 'A05'
UPDATE AT6000STD SET DescriptionE = N'Actual' WHERE Code = 'AA'
UPDATE AT6000STD SET DescriptionE = N'Account' WHERE Code = 'AC'
UPDATE AT6000STD SET DescriptionE = N'Reduction arising' WHERE Code = 'AD'
UPDATE AT6000STD SET DescriptionE = N'Incurred increased' WHERE Code = 'AI'
UPDATE AT6000STD SET DescriptionE = N'The actual quantity' WHERE Code = 'AQ'
UPDATE AT6000STD SET DescriptionE = N'Accumulated number' WHERE Code = 'AU'
UPDATE AT6000STD SET DescriptionE = N'Monthly budget' WHERE Code = 'B1'
UPDATE AT6000STD SET DescriptionE = N'Quarter budget' WHERE Code = 'B2'
UPDATE AT6000STD SET DescriptionE = N'Year budget' WHERE Code = 'B3'
UPDATE AT6000STD SET DescriptionE = N'4 Budget' WHERE Code = 'B4'
UPDATE AT6000STD SET DescriptionE = N'5 Budget' WHERE Code = 'B5'
UPDATE AT6000STD SET DescriptionE = N'Period Balance' WHERE Code = 'BA'
UPDATE AT6000STD SET DescriptionE = N'Opening balance' WHERE Code = 'BB'
UPDATE AT6000STD SET DescriptionE = N'Balance' WHERE Code = 'BC'
UPDATE AT6000STD SET DescriptionE = N'Last Period Balance' WHERE Code = 'BL'
UPDATE AT6000STD SET DescriptionE = N'Opening balance amount' WHERE Code = 'BQ'
UPDATE AT6000STD SET DescriptionE = N'Original price' WHERE Code = 'CA'
UPDATE AT6000STD SET DescriptionE = N'Despite' WHERE Code = 'CB'
UPDATE AT6000STD SET DescriptionE = N'Inventory type 1' WHERE Code = 'CI1'
UPDATE AT6000STD SET DescriptionE = N'Inventory type 2' WHERE Code = 'CI2'
UPDATE AT6000STD SET DescriptionE = N'Inventory type 3' WHERE Code = 'CI3'
UPDATE AT6000STD SET DescriptionE = N'Object type 1' WHERE Code = 'CO1'
UPDATE AT6000STD SET DescriptionE = N'Object type 2' WHERE Code = 'CO2'
UPDATE AT6000STD SET DescriptionE = N'Object type 3' WHERE Code = 'CO3'
UPDATE AT6000STD SET DescriptionE = N'Unused' WHERE Code = 'CSD'
UPDATE AT6000STD SET DescriptionE = N'Pending liquidation' WHERE Code = 'CTL'
UPDATE AT6000STD SET DescriptionE = N'Original currency' WHERE Code = 'CV'
UPDATE AT6000STD SET DescriptionE = N'Debit balance' WHERE Code = 'DB'
UPDATE AT6000STD SET DescriptionE = N'Depreciation' WHERE Code = 'DE'
UPDATE AT6000STD SET DescriptionE = N'Unit' WHERE Code = 'DV'
UPDATE AT6000STD SET DescriptionE = N'End balance' WHERE Code = 'EB'
UPDATE AT6000STD SET DescriptionE = N'Followers' WHERE Code = 'EM'
UPDATE AT6000STD SET DescriptionE = N'Ending balance amount' WHERE Code = 'EQ'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 01' WHERE Code = 'I01'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 02' WHERE Code = 'I02'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 03' WHERE Code = 'I03'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 04' WHERE Code = 'I04'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 05' WHERE Code = 'I05'
UPDATE AT6000STD SET DescriptionE = N'Item' WHERE Code = 'IN'
UPDATE AT6000STD SET DescriptionE = N'Period' WHERE Code = 'IP'
UPDATE AT6000STD SET DescriptionE = N'Fully depreciated' WHERE Code = 'KHH'
UPDATE AT6000STD SET DescriptionE = N'Beginning balance before' WHERE Code = 'LB'
UPDATE AT6000STD SET DescriptionE = N'Inventory period' WHERE Code = 'LC'
UPDATE AT6000STD SET DescriptionE = N'Warehousing period' WHERE Code = 'LD'
UPDATE AT6000STD SET DescriptionE = N'Ending balance ago' WHERE Code = 'LE'
UPDATE AT6000STD SET DescriptionE = N'Until this month (last year)' WHERE Code = 'LM'
UPDATE AT6000STD SET DescriptionE = N'Until this quarter (last year)' WHERE Code = 'LQ'
UPDATE AT6000STD SET DescriptionE = N'Until this year (last year) ' WHERE Code = 'LY'
UPDATE AT6000STD SET DescriptionE = N'Month' WHERE Code = 'MO'
UPDATE AT6000STD SET DescriptionE = N'Same period the previous month' WHERE Code = 'MP'
UPDATE AT6000STD SET DescriptionE = N'New Purchase' WHERE Code = 'MU'
UPDATE AT6000STD SET DescriptionE = N'Sale' WHERE Code = 'NB'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 01' WHERE Code = 'O01'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 02' WHERE Code = 'O02'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 03' WHERE Code = 'O03'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 04' WHERE Code = 'O04'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 05' WHERE Code = 'O05'
UPDATE AT6000STD SET DescriptionE = N'Object' WHERE Code = 'OB'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 01 purchase orders' WHERE Code = 'P01'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 02 purchase orders' WHERE Code = 'P02'
UPDATE AT6000STD SET DescriptionE = N'Analysis code 03 purchase orders' WHERE Code = 'P03'
UPDATE AT6000STD SET DescriptionE = N'Period Actual' WHERE Code = 'PA'
UPDATE AT6000STD SET DescriptionE = N'Balance beginning this period' WHERE Code = 'PB'
UPDATE AT6000STD SET DescriptionE = N'Credit Period' WHERE Code = 'PC'
UPDATE AT6000STD SET DescriptionE = N'Inventory period' WHERE Code = 'PC'
UPDATE AT6000STD SET DescriptionE = N'Sort order sale' WHERE Code = 'PCO'
UPDATE AT6000STD SET DescriptionE = N'Period Debit' WHERE Code = 'PD'
UPDATE AT6000STD SET DescriptionE = N'Warehousing period' WHERE Code = 'PD'
UPDATE AT6000STD SET DescriptionE = N'This ending balance' WHERE Code = 'PE'
UPDATE AT6000STD SET DescriptionE = N'Purchase orders (OP)' WHERE Code = 'PO'
UPDATE AT6000STD SET DescriptionE = N'Order status' WHERE Code = 'PSO'
UPDATE AT6000STD SET DescriptionE = N'Sum in reducing the number' WHERE Code = 'QD'
UPDATE AT6000STD SET DescriptionE = N'Sum in increasing the number' WHERE Code = 'QI'
UPDATE AT6000STD SET DescriptionE = N'Quarterly' WHERE Code = 'QU'
UPDATE AT6000STD SET DescriptionE = N'Residual value' WHERE Code = 'RE'
UPDATE AT6000STD SET DescriptionE = N'Order code analysis part 01' WHERE Code = 'S01'
UPDATE AT6000STD SET DescriptionE = N'Order code analysis part 02' WHERE Code = 'S02'
UPDATE AT6000STD SET DescriptionE = N'Code analysis of 03 single-ers' WHERE Code = 'S03'
UPDATE AT6000STD SET DescriptionE = N'Sort order sale' WHERE Code = 'SCO'
UPDATE AT6000STD SET DescriptionE = N'Vendor' WHERE Code = 'SM'
UPDATE AT6000STD SET DescriptionE = N'Sell ​​orders (OP)' WHERE Code = 'SO'
UPDATE AT6000STD SET DescriptionE = N'Order status' WHERE Code = 'SSO'
UPDATE AT6000STD SET DescriptionE = N'Liquidation' WHERE Code = 'TL'
UPDATE AT6000STD SET DescriptionE = N'Until this month' WHERE Code = 'TM'
UPDATE AT6000STD SET DescriptionE = N'Until this quarter' WHERE Code = 'TQ'
UPDATE AT6000STD SET DescriptionE = N'Until this year' WHERE Code = 'TY'
UPDATE AT6000STD SET DescriptionE = N'Date documents' WHERE Code = 'VD'
UPDATE AT6000STD SET DescriptionE = N'Voucher type' WHERE Code = 'VT'
UPDATE AT6000STD SET DescriptionE = N'New Construction' WHERE Code = 'XA'
UPDATE AT6000STD SET DescriptionE = N'Year Actual' WHERE Code = 'YA'
UPDATE AT6000STD SET DescriptionE = N'Year Credit' WHERE Code = 'YC'
UPDATE AT6000STD SET DescriptionE = N'Year Debit' WHERE Code = 'YD'
UPDATE AT6000STD SET DescriptionE = N'Year' WHERE Code = 'YE'
UPDATE AT6000STD SET DescriptionE = N'Same period last year' WHERE Code = 'YP'
-- Cập nhật các record chưa có diễn giải tiếng Anh
UPDATE AT6000
SET AT6000.DescriptionE = AT6000STD.DescriptionE
FROM AT6000STD
WHERE AT6000.Code = AT6000STD.Code
AND ISNULL(AT6000.DescriptionE, '') = ''	
	

