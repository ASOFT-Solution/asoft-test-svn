-- <Summary>
---- 
-- <History>
---- Create on 15/05/2012 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT TOP 1 1 FROM WT1005STD WHERE TypeID = N'L01') INSERT INTO WT1005STD(TypeID, UserName, UserNameE, SystemName, SystemNameE, IsUsed) VALUES (N'L01', N'L01 - Vị trí 01', N'L01 - Location 01', N'L01 - Vị trí 01', N'L01 - Location 01', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM WT1005STD WHERE TypeID = N'L02') INSERT INTO WT1005STD(TypeID, UserName, UserNameE, SystemName, SystemNameE, IsUsed) VALUES (N'L02', N'L02 - Vị trí 02', N'L02 - Location 02', N'L02 - Vị trí 02', N'L02 - Location 02', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM WT1005STD WHERE TypeID = N'L03') INSERT INTO WT1005STD(TypeID, UserName, UserNameE, SystemName, SystemNameE, IsUsed) VALUES (N'L03', N'L03 - Vị trí 03', N'L03 - Location 03', N'L03 - Vị trí 03', N'L03 - Location 03', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM WT1005STD WHERE TypeID = N'L04') INSERT INTO WT1005STD(TypeID, UserName, UserNameE, SystemName, SystemNameE, IsUsed) VALUES (N'L04', N'L04 - Vị trí 04', N'L04 - Location 04', N'L04 - Vị trí 04', N'L04 - Location 04', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM WT1005STD WHERE TypeID = N'L05') INSERT INTO WT1005STD(TypeID, UserName, UserNameE, SystemName, SystemNameE, IsUsed) VALUES (N'L05', N'L05 - Vị trí 05', N'L05 - Location 05', N'L05 - Vị trí 05', N'L05 - Location 05', 0)
IF NOT EXISTS(SELECT TOP 1 1 FROM WT1005 WHERE TypeID LIKE 'L%') 
INSERT INTO WT1005 (DivisionID, TypeID, SystemName, UserName, IsUsed, UserNameE, SystemNameE)
SELECT A.DivisionID, STD.TypeID, STD.SystemName, STD.UserName, STD.IsUsed, STD.UserNameE, STD.SystemNameE 
FROM WT1005STD STD, (SELECT DISTINCT DivisionID FROM AT1101) A
WHERE STD.TypeID LIKE 'L%'
