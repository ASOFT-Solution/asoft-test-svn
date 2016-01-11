------------------------------------------------------------------------------------------------------
-- Xử lý chung
------------------------------------------------------------------------------------------------------
-- Thêm các record có trong bảng chuẩn nhưng không có trong bảng dữ liệu
INSERT AT1404(APK, DivisionID, ModuleID, ScreenID, ScreenName, ScreenNameE, ScreenType, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
SELECT NEWID() AS APK, DivisionID, ModuleID, ScreenID, ScreenName, ScreenNameE, ScreenType, GETDATE(), N'ADMIN', N'ADMIN', GETDATE()
FROM AT1404STD, AT1101
WHERE AT1404STD.ScreenID NOT IN 
(
SELECT DISTINCT ScreenID FROM AT1404 
WHERE AT1404.DivisionID = AT1101.DivisionID
AND AT1404.ModuleID = AT1404STD.ModuleID 
AND AT1404.ScreenID = AT1404STD.ScreenID 
)

INSERT AT1403(APK, DivisionID, ScreenID, GroupID, ModuleID, IsAddNew, IsUpdate, IsDelete, IsView, IsPrint, CreateDate, CreateUserID, LastModifyUserID, LastModifyDate)
SELECT NEWID() AS APK, DivisionID, ScreenID, GroupID, ModuleID, IsAddNew, IsUpdate, IsDelete, IsView, IsPrint, GETDATE(), N'ADMIN', N'ADMIN', GETDATE()
FROM AT1403STD, AT1101
WHERE AT1403STD.ScreenID NOT IN 
(
SELECT DISTINCT ScreenID FROM AT1403 
WHERE AT1403.DivisionID = AT1101.DivisionID
AND AT1403.ModuleID = AT1403STD.ModuleID 
AND AT1403.ScreenID = AT1403STD.ScreenID 
)

INSERT INTO A00004 (APK, DivisionID, ModuleID, ScreenID, CommandMenu)
SELECT 
NEWID() AS APK,
AT1101.DivisionID,
A00004STD.ModuleID, 
A00004STD.ScreenID, 
A00004STD.CommandMenu
FROM A00004STD, AT1101
WHERE A00004STD.CommandMenu NOT IN 
(
    SELECT DISTINCT CommandMenu FROM A00004 
    WHERE A00004.DivisionID = AT1101.DivisionID
    AND A00004.ModuleID = A00004STD.ModuleID 
    AND A00004.CommandMenu = A00004STD.CommandMenu
    AND A00004.ScreenID = A00004STD.ScreenID
)
-- Xóa các record có trong bảng dữ liệu nhưng không có trong bảng chuẩn
DELETE FROM AT1403 WHERE ModuleID + ScreenID NOT IN (SELECT ModuleID + ScreenID FROM AT1403STD)
DELETE FROM AT1404 WHERE ModuleID + ScreenID NOT IN (SELECT ModuleID + ScreenID FROM AT1404STD)
DELETE FROM A00004 WHERE ModuleID+ ScreenID+ isnull(CommandMenu,'') NOT IN (SELECT ModuleID+ ScreenID + isnull(CommandMenu,'') FROM A00004STD)
------------------------------------------------------------------------------------------------------
GO