-- <Summary>
---- Thiết lập mã phân tích
-- <History>
---- Create on 16/05/2012 by Thien Huynh: Bo sung 5 Khoan muc Ana06ID - Ana10ID
---- Modified on 04/11/2013 by Thanh Sơn: Bổ sung 5 khoản mục Ngày D01 - D05 và 10 khoản mục Ghi chú N01 - N10

---- Modified on ... by 
-- <Example>

DECLARE @DivisionID NVarchar(50)
DECLARE cur_AllDivision CURSOR FOR
SELECT AT1101.DivisionID FROM AT1101
OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @DivisionID
WHILE @@fetch_status = 0
  BEGIN	
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'A06')
	InSert Into AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
	Values (NEWID(), @DivisionID, N'A06', N'A06 - Mã phân tich 6', N'Mã phân tích 6', 0, N'A06 - Analysis code 6', 0, 0, N'A06 - Analysis code 6')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'A07')
	InSert Into AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
	Values (NEWID(), @DivisionID, N'A07', N'A07 - Mã phân tich 7', N'Mã phân tích 7', 0, N'A06 - Analysis code 7', 0, 0, N'A07 - Analysis code 7')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'A08')
	InSert Into AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
	Values (NEWID(), @DivisionID, N'A08', N'A08 - Mã phân tich 8', N'Mã phân tích 8', 0, N'A08 - Analysis code 8', 0, 0, N'A08 - Analysis code 8')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'A09')
	InSert Into AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
	Values (NEWID(), @DivisionID, N'A09', N'A09 - Mã phân tich 9', N'Mã phân tích 9', 0, N'A09 - Analysis code 9', 0, 0, N'A09 - Analysis code 9')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'A10')
	InSert Into AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
	Values (NEWID(), @DivisionID, N'A10', N'A10 - Mã phân tich 10', N'Mã phân tích 10', 0, N'A10 - Analysis code 10', 0, 0, N'A10 - Analysis code 10')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'D01')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'D01', N'D01 - Ngày 01', N'Ngày 1', 0, N'Date 1', 0, 0, N'D01 - Date 01')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'D02')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'D02', N'D02 - Ngày 02', N'Ngày 2', 0, N'Date 2', 0, 0, N'D02 - Date 02')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'D03')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'D03', N'D03 - Ngày 03', N'Ngày 3', 0, N'Date 3', 0, 0, N'D03 - Date 03')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'D04')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'D04', N'D04 - Ngày 04', N'Ngày 4', 0, N'Date 4', 0, 0, N'D04 - Date 04')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'D05')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'D05', N'D05 - Ngày 05', N'Ngày 5', 0, N'Date 5', 0, 0, N'D05 - Date 05')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'N01')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'N01', N'N01 - Ghi chú 01', N'Ghi chú 1', 0, N'Notes 1', 0, 0, N'N01 - Notes 01')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'N02')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'N02', N'N02 - Ghi chú 02', N'Ghi chú 2', 0, N'Notes 2', 0, 0, N'N02 - Notes 02')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'N03')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'N03', N'N03 - Ghi chú 03', N'Ghi chú 3', 0, N'Notes 3', 0, 0, N'N03 - Notes 03')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'N04')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'N04', N'N04 - Ghi chú 04', N'Ghi chú 4', 0, N'Notes 4', 0, 0, N'N04 - Notes 04')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'N05')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'N05', N'N05 - Ghi chú 05', N'Ghi chú 5', 0, N'Notes 5', 0, 0, N'N05 - Notes 05')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'N06')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'N06', N'N06 - Ghi chú 06', N'Ghi chú 6', 0, N'Notes 6', 0, 0, N'N06 - Notes 06')	
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'N07')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'N07', N'N07 - Ghi chú 07', N'Ghi chú 7', 0, N'Notes 7', 0, 0, N'N07 - Notes 07')	
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'N08')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'N08', N'N08 - Ghi chú 08', N'Ghi chú 8', 0, N'Notes 8', 0, 0, N'N08 - Notes 08')	
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'N09')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'N09', N'N09 - Ghi chú 09', N'Ghi chú 9', 0, N'Notes 9', 0, 0, N'N09 - Notes 09')
IF NOT EXISTS ( SELECT TypeID FROM AT0005 WHERE TypeID = N'N10')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, Status, IsCommon, SystemNameE)
		VALUES (NEWID(), @DivisionID, N'N10', N'N10 - Ghi chú 10', N'Ghi chú 10', 0, N'Notes 10', 0, 0, N'N10 - Notes 10')
---------------------------------------------------- Quy cách hàng ----------------------------------------------------------------------------------------------------
		
IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S01')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S01', N'S01 - Quy cách hàng 01', N'Quy cách hàng 1', 0, N'Inventory Standard 1', 0, 0, N'S01 - Inventory Standard 01', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S02')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S02', N'S02 - Quy cách hàng 02', N'Quy cách hàng 2', 0, N'Inventory Standard 2', 0, 0, N'S02 - Inventory Standard 02', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S03')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S03', N'S03 - Quy cách hàng 03', N'Quy cách hàng 3', 0, N'Inventory Standard 3', 0, 0, N'S03 - Inventory Standard 03', 0)
	
IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S04')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S04', N'S04 - Quy cách hàng 04', N'Quy cách hàng 4', 0, N'Inventory Standard 4', 0, 0, N'S04 - Inventory Standard 04', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S05')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S05', N'S05 - Quy cách hàng 05', N'Quy cách hàng 5', 0, N'Inventory Standard 5', 0, 0, N'S05 - Inventory Standard 05', 0)
		
IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S06')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S06', N'S06 - Quy cách hàng 06', N'Quy cách hàng 6', 0, N'Inventory Standard 6', 0, 0, N'S06 - Inventory Standard 06', 0)
		
IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S07')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S07', N'S07 - Quy cách hàng 07', N'Quy cách hàng 7', 0, N'Inventory Standard 7', 0, 0, N'S07 - Inventory Standard 07', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S08')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S08', N'S08 - Quy cách hàng 08', N'Quy cách hàng 8', 0, N'Inventory Standard 8', 0, 0, N'S08 - Inventory Standard 08', 0)
		
IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S09')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S09', N'S09 - Quy cách hàng 09', N'Quy cách hàng 9', 0, N'Inventory Standard 9', 0, 0, N'S09 - Inventory Standard 09', 0)
		
IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S10')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S10', N'S10 - Quy cách hàng 10', N'Quy cách hàng 10', 0, N'Inventory Standard 10', 0, 0, N'S10 - Inventory Standard 10', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S11')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S11', N'S11 - Quy cách hàng 11', N'Quy cách hàng 11', 0, N'Inventory Standard 11', 0, 0, N'S11 - Inventory Standard 11', 0)
		
IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S12')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S12', N'S12 - Quy cách hàng 12', N'Quy cách hàng 12', 0, N'Inventory Standard 12', 0, 0, N'S12 - Inventory Standard 12', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S13')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S13', N'S13 - Quy cách hàng 13', N'Quy cách hàng 13', 0, N'Inventory Standard 13', 0, 0, N'S13 - Inventory Standard 13', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S14')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S14', N'S14 - Quy cách hàng 14', N'Quy cách hàng 14', 0, N'Inventory Standard 14', 0, 0, N'S14 - Inventory Standard 14', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S15')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S15', N'S15 - Quy cách hàng 15', N'Quy cách hàng 15', 0, N'Inventory Standard 15', 0, 0, N'S15 - Inventory Standard 15', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S16')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S16', N'S16 - Quy cách hàng 16', N'Quy cách hàng 16', 0, N'Inventory Standard 16', 0, 0, N'S16 - Inventory Standard 16', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S17')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S17', N'S17 - Quy cách hàng 17', N'Quy cách hàng 17', 0, N'Inventory Standard 17', 0, 0, N'S17 - Inventory Standard 17', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S18')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S18', N'S18 - Quy cách hàng 18', N'Quy cách hàng 18', 0, N'Inventory Standard 18', 0, 0, N'S18 - Inventory Standard 18', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S19')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S19', N'S19 - Quy cách hàng 19', N'Quy cách hàng 19', 0, N'Inventory Standard 19', 0, 0, N'S19 - Inventory Standard 19', 0)

IF NOT EXISTS (SELECT TypeID FROM AT0005 WHERE TypeID = N'S20')
		INSERT INTO AT0005 (APK, DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, [Status], IsCommon, SystemNameE, IsExtraFee)
		VALUES (NEWID(), @DivisionID, N'S20', N'S20 - Quy cách hàng 20', N'Quy cách hàng 20', 0, N'Inventory Standard 20', 0, 0, N'S20 - Inventory Standard 20', 0)

    FETCH NEXT FROM cur_AllDivision INTO @DivisionID
  END  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision

