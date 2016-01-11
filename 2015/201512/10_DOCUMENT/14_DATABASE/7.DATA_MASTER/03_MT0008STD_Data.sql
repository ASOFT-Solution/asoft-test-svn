-- <Summary>
---- 
-- <History>
---- Create  on 04/09/2015 by Tiểu Mai: Tham số kết quả sản xuất
---- <Example>
---- Add Data

---- Tham số Kết quả sản xuất thành phẩm
IF NOT EXISTS(SELECT TOP 1 1 FROM MT0008STD WHERE TypeID = N'MD01') INSERT INTO MT0008STD (TypeID, SystemName, SystemNameE, IsUsed) values ('MD01'	,N'M01 - Tham số 01',N'Parameter 01',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM MT0008STD WHERE TypeID = N'MD02') INSERT INTO MT0008STD (TypeID, SystemName, SystemNameE, IsUsed) values ('MD02',	N'M02 - Tham số 02',N'Parameter 02',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM MT0008STD WHERE TypeID = N'MD03') INSERT INTO MT0008STD (TypeID, SystemName, SystemNameE, IsUsed) values ('MD03',	N'M03 - Tham số 03',N'Parameter 03',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM MT0008STD WHERE TypeID = N'MD04') INSERT INTO MT0008STD (TypeID, SystemName, SystemNameE, IsUsed) values ('MD04',	N'M04 - Tham số 04',N'Parameter 04',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM MT0008STD WHERE TypeID = N'MD05') INSERT INTO MT0008STD (TypeID, SystemName, SystemNameE, IsUsed) values ('MD05',	N'M05 - Tham số 05',N'Parameter 05',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM MT0008STD WHERE TypeID = N'MD06') INSERT INTO MT0008STD (TypeID, SystemName, SystemNameE, IsUsed) values ('MD06',	N'M06 - Tham số 06',N'Parameter 06',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM MT0008STD WHERE TypeID = N'MD07') INSERT INTO MT0008STD (TypeID, SystemName, SystemNameE, IsUsed) values ('MD07',	N'M07 - Tham số 07',N'Parameter 07',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM MT0008STD WHERE TypeID = N'MD08') INSERT INTO MT0008STD (TypeID, SystemName, SystemNameE, IsUsed) values ('MD08',	N'M08 - Tham số 08',N'Parameter 08',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM MT0008STD WHERE TypeID = N'MD09') INSERT INTO MT0008STD (TypeID, SystemName, SystemNameE, IsUsed) values ('MD09',	N'M09 - Tham số 09',N'Parameter 09',0)

IF NOT EXISTS(SELECT TOP 1 1 FROM MT0008STD WHERE TypeID = N'MD10') INSERT INTO MT0008STD (TypeID, SystemName, SystemNameE, IsUsed) values ('MD10',	N'M10 - Tham số 10',N'Parameter 10',0)
