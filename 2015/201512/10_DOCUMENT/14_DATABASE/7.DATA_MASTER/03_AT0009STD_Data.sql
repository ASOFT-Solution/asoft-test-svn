-- <Summary>
---- Định nghĩa tham số
-- <History>
---- Create on 30/01/2011 by Việt Khánh
-- <Example>
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0009STD WHERE TypeID = 'T01')
INSERT [dbo].[AT0009STD] ([TypeID], [SystemName], [UserName], [IsUsed], [UserNameE]) VALUES (N'T01', N'@T01 - Tham số 1', NULL, 0, NULL)
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0009STD WHERE TypeID = 'T02')
INSERT [dbo].[AT0009STD] ([TypeID], [SystemName], [UserName], [IsUsed], [UserNameE]) VALUES (N'T02', N'@T02 - Tham  số 2', NULL, 0, NULL)
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0009STD WHERE TypeID = 'T03')
INSERT [dbo].[AT0009STD] ([TypeID], [SystemName], [UserName], [IsUsed], [UserNameE]) VALUES (N'T03', N'@T03 - Tham  số 3', NULL, 0, NULL)
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0009STD WHERE TypeID = 'T04')
INSERT [dbo].[AT0009STD] ([TypeID], [SystemName], [UserName], [IsUsed], [UserNameE]) VALUES (N'T04', N'@T04 - Tham  số 4', NULL, 0, NULL)
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0009STD WHERE TypeID = 'T05')
INSERT [dbo].[AT0009STD] ([TypeID], [SystemName], [UserName], [IsUsed], [UserNameE]) VALUES (N'T05', N'@T05 - Tham  số 5', NULL, 0, NULL)
---- Update Data
UPDATE AT0009STD SET SystemName = N'@T01 - Tham số 1', UserName = N'NULL', SystemNameE = N'@T01 - Parameter 1', UserNameE = N'NULL' WHERE TypeID = 'T01'
UPDATE AT0009STD SET SystemName = N'@T02 - Tham số 2', UserName = N'NULL', SystemNameE = N'@T02 - Parameter 2', UserNameE = N'NULL' WHERE TypeID = 'T02'
UPDATE AT0009STD SET SystemName = N'@T03 - Tham số 3', UserName = N'NULL', SystemNameE = N'@T03 - Parameter 3', UserNameE = N'NULL' WHERE TypeID = 'T03'
UPDATE AT0009STD SET SystemName = N'@T04 - Tham số 4', UserName = N'NULL', SystemNameE = N'@T04 - Parameter 4', UserNameE = N'NULL' WHERE TypeID = 'T04'
UPDATE AT0009STD SET SystemName = N'@T05 - Tham số 5', UserName = N'NULL', SystemNameE = N'@T05 - Parameter 5', UserNameE = N'NULL' WHERE TypeID = 'T05'
-- Cập nhật AT0009
UPDATE AT0009 SET AT0009.SystemName = AT0009STD.SystemName, AT0009.SystemNameE = AT0009STD.SystemNameE FROM AT0009STD WHERE AT0009.TypeID = AT0009STD.TypeID
UPDATE AT0009 SET AT0009.UserName = AT0009STD.UserName FROM AT0009STD WHERE AT0009.TypeID = AT0009STD.TypeID AND ISNULL(AT0009.UserName, '') = ''
UPDATE AT0009 SET AT0009.UserNameE = AT0009STD.UserNameE FROM AT0009STD WHERE AT0009.TypeID = AT0009STD.TypeID AND ISNULL(AT0009.UserNameE, '') = ''