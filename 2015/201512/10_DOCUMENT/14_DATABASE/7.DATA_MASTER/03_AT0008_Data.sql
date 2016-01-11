-- <Summary>
---- THÊM DỮ LIỆU CHO BẢNG AT0008
-- <History>
---- Create on 03/10/2014 by Lê Thị Hạnh 
---- Modified on ... by 
---- THAM SỐ MASTER - ĐỊNH DẠNG THAM SỐ
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'S01')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE) 
VALUES ('S01',N'S01 - Tham số 1',N'Số hợp đồng',0,'Contract number') 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'S02')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE) 
VALUES ('S02',N'S02 - Tham số 2',N'Ngày hợp đồng',0,'Contract date') 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'S03')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE) 
VALUES ('S03',N'S03 - Tham số 3',N'Hình thức thanh toán',0,'Payment method') 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'S04')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE) 
VALUES ('S04',N'S04 - Tham số 4',N'Địa điểm giao hàng',0,'Delivery address')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'S05') 
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE) 
VALUES ('S05',N'S05 - Tham số 5',N'Địa điểm nhận hàng',0,'Receipt address')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'S06') 
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE) 
VALUES ('S06',N'S06 - Tham số 6',N'Số vận đơn',0,'Way-bill number') 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'S07')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE) 
VALUES ('S07',N'S07 - Tham số 7',N'Số container',0,'Container number') 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'S08')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE) 
VALUES ('S08',N'S08 - Tham số 8',N'Đơn vị vận chuyển',0,'Transport unit')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'S09') 
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE) 
VALUES ('S09',N'S09 - Tham số 9','',0,'') 
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'S10')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE) 
VALUES ('S10',N'S10 - Tham số 10','',0,'')
--- THAM SỐ DETAIL - ĐỊNH DẠNG THAM SỐ TRÊN LƯỚI
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'D01')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE)
VALUES('D01',N'D01 - Tham số 1',N'Tham số 1',0,N'Parameter 1')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'D02')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE)
VALUES('D02',N'D02 - Tham số 2',N'Tham số 2',0,N'Parameter 2')	
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'D03')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE)
VALUES('D03',N'D03 - Tham số 3',N'Tham số 3',0,N'Parameter 3')	
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'D04')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE)
VALUES('D04',N'D04 - Tham số 4',N'Tham số 4',0,N'Parameter 4')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'D05')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE)
VALUES('D05',N'D05 - Tham số 5',N'Tham số 5',0,N'Parameter 5')	
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'D06')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE)
VALUES('D06',N'D06 - Tham số 6',N'Tham số 6',0,N'Parameter 6')	
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'D07')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE)
VALUES('D07',N'D07 - Tham số 7',N'Tham số 7',0,N'Parameter 7')	
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'D08')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE)
VALUES('D08',N'D08 - Tham số 8',N'Tham số 8',0,N'Parameter 8')
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'D09')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE)
VALUES('D09',N'D09 - Tham số 9',N'Tham số 9',0,N'Parameter 9')	
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008STD WHERE TypeID = N'D10')
INSERT INTO AT0008STD (TypeID, SystemName, UserName, IsUsed, UserNameE)
VALUES('D10',N'D10 - Tham số 10',N'Tham số 10',0,N'Parameter 10')	
---- THÊM DỮ LIỆU VÀO AT0008
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008 WHERE TypeID LIKE 'S%') 
INSERT INTO AT0008 (DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE)
SELECT AT11.DivisionID, AT08STD.TypeID, AT08STD.SystemName, AT08STD.UserName,
       AT08STD.IsUsed, AT08STD.UserNameE 
FROM AT0008STD AT08STD, (SELECT DISTINCT AT11.DivisionID FROM AT1101 AT11) AT11
WHERE AT08STD.TypeID LIKE 'S%'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT0008 WHERE TypeID LIKE 'D%') 
INSERT INTO AT0008 (DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE)
SELECT AT11.DivisionID, AT08STD.TypeID, AT08STD.SystemName, AT08STD.UserName,
       AT08STD.IsUsed, AT08STD.UserNameE 
FROM AT0008STD AT08STD, (SELECT DISTINCT AT11.DivisionID FROM AT1101 AT11) AT11
WHERE AT08STD.TypeID LIKE 'D%'

