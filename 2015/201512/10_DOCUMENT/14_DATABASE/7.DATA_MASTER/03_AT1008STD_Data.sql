-- <Summary>
---- Danh mục bút toán TransactionTypeID, Thêm TransactionTypeID = 'T94' - Bút toán thuế bảo vệ môi trường
-- <History>
---- Create on 20/03/2015 by Lê Thị Hạnh 
---- Modified on 29/01/2013 by Lê Thị Thu Hiền: Bổ sung T25
---- Modified on 31/05/2013 by Le Thi Thu Hien
---- Modified on 09/11/2015 by Phuong Thao: Bo sung but toan Thue Nha Thau ('T43')
IF NOT EXISTS (SELECT TOP 1 1 FROM AT1008STD WHERE TransactionTypeID = N'T94')
INSERT INTO AT1008STD(TransactionTypeID, [Description], DescriptionE)
VALUES(N'T94',N'Bút toán thuế bảo vệ môi trường',N'Entry of Environment Tax')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008 WHERE TransactionTypeID = N'T94') 
INSERT INTO AT1008(DivisionID, TransactionTypeID, [Description], DescriptionE)
SELECT AT11.DivisionID, AT18STD.TransactionTypeID, AT18STD.[Description], AT18STD.DescriptionE 
FROM AT1008STD AT18STD, (SELECT DISTINCT AT11.DivisionID FROM AT1101 AT11) AT11
WHERE AT18STD.TransactionTypeID = N'T94' 
---- Modified on 25/05/2015 by Lê Thị Hạnh: Thêm T95, T96 cho thuế tài nguyên, TTĐB
IF NOT EXISTS (SELECT TOP 1 1 FROM AT1008STD WHERE TransactionTypeID = N'T95')
INSERT INTO AT1008STD(TransactionTypeID, [Description], DescriptionE)
VALUES(N'T95',N'Bút toán thuế tài nguyên',N'Entry of Natural Resource Tax')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008 WHERE TransactionTypeID = N'T95') 
INSERT INTO AT1008(DivisionID, TransactionTypeID, [Description], DescriptionE)
SELECT AT11.DivisionID, AT18STD.TransactionTypeID, AT18STD.[Description], AT18STD.DescriptionE 
FROM AT1008STD AT18STD, (SELECT DISTINCT AT11.DivisionID FROM AT1101 AT11) AT11
WHERE AT18STD.TransactionTypeID = N'T95' 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT1008STD WHERE TransactionTypeID = N'T96')
INSERT INTO AT1008STD(TransactionTypeID, [Description], DescriptionE)
VALUES(N'T96',N'Bút toán thuế tiêu thụ đặc biệt mua vào',N'Entry of deductible Special Excise Tax')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008 WHERE TransactionTypeID = N'T96') 
INSERT INTO AT1008(DivisionID, TransactionTypeID, [Description], DescriptionE)
SELECT AT11.DivisionID, AT18STD.TransactionTypeID, AT18STD.[Description], AT18STD.DescriptionE 
FROM AT1008STD AT18STD, (SELECT DISTINCT AT11.DivisionID FROM AT1101 AT11) AT11
WHERE AT18STD.TransactionTypeID = N'T96' 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT1008STD WHERE TransactionTypeID = N'T97')
INSERT INTO AT1008STD(TransactionTypeID, [Description], DescriptionE)
VALUES(N'T97',N'Bút toán thuế tiêu thụ đặc biệt bán ra',N'Entry of invoices for goods and services to Special Excise Tax')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008 WHERE TransactionTypeID = N'T97') 
INSERT INTO AT1008(DivisionID, TransactionTypeID, [Description], DescriptionE)
SELECT AT11.DivisionID, AT18STD.TransactionTypeID, AT18STD.[Description], AT18STD.DescriptionE 
FROM AT1008STD AT18STD, (SELECT DISTINCT AT11.DivisionID FROM AT1101 AT11) AT11
WHERE AT18STD.TransactionTypeID = N'T97' 
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1008STD WHERE TransactionTypeID = 'T25')
	BEGIN
	 INSERT INTO AT1008STD
		(
    		TransactionTypeID,
    		[Description],
    		DescriptionE
		)
		VALUES
		(
    		'T25',
    		N'Hàng mua trả lại',
    		N'Purchase return'
		)
	END
IF NOT EXISTS ( SELECT TOP 1 1 FROM AT1008 WHERE TransactionTypeID = 'T25') 
    INSERT INTO AT1008
    (
    	DivisionID,
    	TransactionTypeID,
    	[Description],
    	DescriptionE
    )
   SELECT AT1101.DivisionID ,
		TransactionTypeID,
    	[Description],
    	DescriptionE
   FROM AT1008STD , AT1101 
   WHERE AT1008STD.TransactionTypeID = 'T25'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008STD WHERE TransactionTypeID = 'T65')	
INSERT INTO AT1008STD
(
	TransactionTypeID,
	[Description],
	DescriptionE
)
VALUES
(

	'T65',
	N'Bút toán chênh lệch kho',
	N'Entry of difference warehouse'
)
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008 WHERE TransactionTypeID = 'T65')	
	INSERT INTO AT1008 (DivisionID, TransactionTypeID, [Description])
		SELECT	AT.DivisionID, STD.TransactionTypeID, STD.[Description] 
		FROM	AT1008STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.TransactionTypeID = 'T65' 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008STD WHERE TransactionTypeID = 'T64')
	INSERT INTO AT1008STD (TransactionTypeID, [Description], DescriptionE) VALUES ('T64', N'Bút toán chiết khấu, thưởng doanh số', N'Entry of sales bonus')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008 WHERE TransactionTypeID = 'T64')	
	INSERT INTO AT1008 (DivisionID, TransactionTypeID, [Description])
		SELECT	AT.DivisionID, STD.TransactionTypeID, STD.[Description] 
		FROM	AT1008STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.TransactionTypeID = 'T64' 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008STD WHERE TransactionTypeID = 'T20')
	INSERT INTO AT1008STD (TransactionTypeID, [Description], DescriptionE) VALUES ('T20', N'Bút toán chi phí khác', N'Entry of other expenses')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008 WHERE TransactionTypeID = 'T20')	
	INSERT INTO AT1008 (DivisionID, TransactionTypeID, [Description])
		SELECT	AT.DivisionID, STD.TransactionTypeID, STD.[Description] 
		FROM	AT1008STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.TransactionTypeID = 'T20' 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008STD WHERE TransactionTypeID = 'T19')
	INSERT INTO AT1008STD (TransactionTypeID, [Description]) VALUES ('T19', N'Bút toán chênh lệch tỷ giá xuất')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008 WHERE TransactionTypeID = 'T19')	
	INSERT INTO AT1008 (DivisionID, TransactionTypeID, [Description])
		SELECT	AT.DivisionID, STD.TransactionTypeID, STD.[Description] 
		FROM	AT1008STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.TransactionTypeID = 'T19' 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008STD WHERE TransactionTypeID = 'Z00')
	INSERT INTO AT1008STD (TransactionTypeID, [Description], DescriptionE) VALUES ('Z00', N'Bút toán số dư tài khoản ngoại bảng', N'Entry of out table balance')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008 WHERE TransactionTypeID = 'Z00')
	INSERT INTO AT1008 (DivisionID, TransactionTypeID, [Description])
		SELECT	AT.DivisionID, STD.TransactionTypeID, STD.[Description] 
		FROM	AT1008STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.TransactionTypeID = 'Z00' 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008STD WHERE TransactionTypeID = 'Z99')
	INSERT INTO AT1008STD (TransactionTypeID, [Description], DescriptionE) VALUES ('Z99', N'Nghiệp vụ ngoại bảng', N'Entry of out table')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008 WHERE TransactionTypeID = 'Z99')
	INSERT INTO AT1008 (DivisionID, TransactionTypeID, [Description])
		SELECT	AT.DivisionID, STD.TransactionTypeID, STD.[Description] 
		FROM	AT1008STD STD, (SELECT DISTINCT DivisionID FROM AT1101) AT	
		WHERE	STD.TransactionTypeID = 'Z99'
--- Modify by Phương Thảo: Thêm loại bút toán THuế nhà Thầu ('T43')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1008 WHERE TransactionTypeID = 'T43')
	INSERT INTO AT1008STD(TransactionTypeID, [Description], DescriptionE)
	VALUES(N'T43',N'Bút toán thuế nhà thầu',N'Entry of Withhoding Tax')



---- Update Data
UPDATE OT0005STD SET TransactionID = 'Purchase' WHERE TypeID LIKE 'P__'
UPDATE OT0005 SET TransactionID = 'Purchase' WHERE TypeID LIKE 'P__'
UPDATE OT0005STD SET TransactionID = 'Sales' WHERE TypeID LIKE 'S__'
UPDATE OT0005 SET TransactionID = 'Sales' WHERE TypeID LIKE 'S__'
UPDATE OT0005STD SET TransactionID = 'Sales Detail' WHERE TypeID LIKE 'SD__'
UPDATE OT0005 SET TransactionID = 'Sales Detail' WHERE TypeID LIKE 'SD__'
UPDATE OT0005STD SET TransactionID = 'Quotation' WHERE TypeID LIKE 'Q__'
UPDATE OT0005 SET TransactionID = 'Quotation' WHERE TypeID LIKE 'Q__'