-- <Summary>
---- Danh mục loại hàng hoá chịu thuế bảo vệ môi trường - Hỗ trợ 17/03/2015
-- <History>
---- Create on 19/03/2015 by Lê Thị Hạnh 
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'010101')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'010101',N'Thu từ xăng sản xuất trong nước',N'Lít',1000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'010102')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'010102',N'Thu từ nhiên liệu bay sản xuất trong nước',N'Lít',1000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'010103')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'010103',N'Thu từ dầu diezel sản xuất trong nước',N'Lít',500,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'010104')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'010104',N'Thu từ dầu hỏa sản xuất trong nước',N'Lít',300,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'010105')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'010105',N'Thu từ dầu mazut sản xuất trong nước',N'Lít',300,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'010201')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'010201',N'Than nâu',N'Tấn',10000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'010202')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'010202',N'Than an - tra - xít (antraxit)',N'Tấn',20000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'010203')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'010203',N'Than mỡ',N'Tấn',10000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'010204')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'010204',N'Than đá khác',N'Tấn',10000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'0103')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'0103',N'Thu từ dung dịch Hydro-chloro-fluoro-carbon (HCFC) sản xuất trong nước',N'Kg',4000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'0104')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'0104',N'Thu từ túi ni lông sản xuất trong nước',N'Kg',40000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'0105')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'0105',N'Thu từ thuốc diệt cỏ sản xuất trong nước',N'Kg',500,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'0106')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'0106',N'Thu từ các sản phẩm hàng hóa khác sản xuất trong nước',N'Kg',1000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020101')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020101',N'Thu từ xăng nhập khẩu',N'Lít',1000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020102')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020102',N'Thu từ nhiên liệu bay nhập khẩu',N'Lít',1000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020103')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020103',N'Thu từ dầu Diezel nhập khẩu',N'Lít',500,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020104')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020104',N'Thu từ dầu hỏa nhập khẩu',N'Lít',300,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020105')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020105',N'Thu từ dầu mazut nhập khẩu',N'Lít',300,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020201')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020201',N'Than nâu nhập khẩu',N'Tấn',10000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020202')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020202',N'Than an - tra - xít (antraxit) nhập khẩu',N'Tấn',20000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020203')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020203',N'Than mỡ nhập khẩu',N'Tấn',10000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020204')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020204',N'Than đá nhập khẩu khác ',N'Tấn',10000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'0203')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'0203',N'Thu từ dung dịch hydro, chloro, fluoro, carbon nhập khẩu',N'Kg',4000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'0204')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'0204',N'Thu từ túi ni lông nhập khẩu',N'Kg',40000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'0205')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'0205',N'Thu từ thuốc diệt cỏ nhập khẩu',N'Kg',500,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'0206')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'0206',N'Thu từ các sản phẩm, hàng hóa nhập khẩu khác',N'Kg',1000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'010106')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'010106',N'Thu từ dầu nhờn sản xuất trong nước',N'Lít',300,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'010107')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'010107',N'Thu từ mỡ nhờn sản xuất trong nước',N'Kg',300,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020106')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020106',N'Thu từ dầu nhờn nhập khẩu',N'Lít',300,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020107')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020107',N'Thu từ mỡ nhờn nhập khẩu',N'Kg',300,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020111')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020111',N'Thu từ xăng nhập khẩu để bán trong nước',N'Lít',1000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020112')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020112',N'Thu từ nhiên liệu bay nhập khẩu để bán trong nước',N'Lít',1000,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020113')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020113',N'Thu từ dầu Diezel nhập khẩu để bán trong nước',N'Lít',500,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020114')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020114',N'Thu từ dầu hỏa nhập khẩu để bán trong nước',N'Lít',300,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0293 WHERE ETaxID = N'020115')
INSERT INTO AT0293(TransactionID, ETaxID, ETaxName, UnitID, ETaxAmount,
            [Disabled], IsCommon, CreateUserID, CreateDate, LastModifyUserID,
            LastModifyDate)
VALUES(NEWID(),N'020115',N'Thu từ dầu mazut, dầu mỡ nhờn nhập khẩu để bán trong nước',N'Lít',300,0,1,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
