-- <Summary>
---- UPDATE DỮ LIỆU CHO BẢNG AT1005:[200/2014/TT-BTC]
-- <History>
---- Create on 02/03/2015 by Lê Thị Hạnh 
---- Modified on 15/04/2015 by Lê Thị Hạnh: Bổ sung 1311, 1312, 3311, 3312 - yêu cầu 15/04/2015 
---- Modified on 21/04/2015 by Lê Thị Hạnh: Cập nhật update tài khoản AT1005 - yêu cầu 21/04/2015 
---- Modified on 24/11/2015 by Kim Vũ : Không cập nhật Fix cho khách hang OFFICIENCE(53), KOYO(52)
---- Modified on ... by 

------ Update dữ liệu vào AT1005STD theo [200/2014/TT-BTC]
IF NOT EXISTS(SELECT TOP 1 1 FROM CustomerIndex  where CustomerName IN(53,52))
BEGIN
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'001')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'001', N'Tài sản cho thuê ngoài', NULL, NULL, N'G00', N'G0001', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Hired assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tài sản cho thuê ngoài',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G00',
    SubGroupID = N'G0001',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Hired assets'
WHERE AccountID = N'001'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'002')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'002', N'Vật tư, hàng hóa nhận giữ hộ, nhận gia công', NULL, NULL, N'G00', N'G0002', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Supplies, goods kept for others or received for processing')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Vật tư, hàng hóa nhận giữ hộ, nhận gia công',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G00',
    SubGroupID = N'G0002',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Supplies, goods kept for others or received for processing'
WHERE AccountID = N'002'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'003')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'003', N'Hàng hóa nhận bán hộ, nhận ký gửi', NULL, NULL, N'G00', N'G0003', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Goods taken for sale, entrusted sale for others')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Hàng hóa nhận bán hộ, nhận ký gửi',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G00',
    SubGroupID = N'G0003',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Goods taken for sale, entrusted sale for others'
WHERE AccountID = N'003'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'004')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'004', N'Nợ khó đòi đã xử lý', NULL, NULL, N'G00', N'G0004', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Bad debts already handled')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Nợ khó đòi đã xử lý',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G00',
    SubGroupID = N'G0004',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Bad debts already handled'
WHERE AccountID = N'004'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'007')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'007', N'Ngoại tệ các loại', NULL, NULL, N'G00', N'G0005', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Assorted foreign currencies')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Ngoại tệ các loại',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G00',
    SubGroupID = N'G0005',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Assorted foreign currencies'
WHERE AccountID = N'007'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'008')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'008', N'Dự toán chi sự nghiệp, dự án', NULL, NULL, N'G00', N'G0006', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Funding levels')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Dự toán chi sự nghiệp, dự án',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G00',
    SubGroupID = N'G0006',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Funding levels'
WHERE AccountID = N'008'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'009')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'009', N'Nguồn vốn khấu hao cơ bản hiện có', NULL, NULL, N'G00', N'G0007', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Existing basic depreciation capital source')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Nguồn vốn khấu hao cơ bản hiện có',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G00',
    SubGroupID = N'G0007',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Existing basic depreciation capital source'
WHERE AccountID = N'009'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'111')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'111', N'Tiền mặt', NULL, NULL, N'G01', N'G0101', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Cash on hand')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tiền mặt',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0101',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Cash on hand'
WHERE AccountID = N'111'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1111')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1111', N'Tiền Việt Nam', N'Vietnamese currency', NULL, N'G01', N'G0101', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Viet Nam Dong')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tiền Việt Nam',
    Notes1 = N'Vietnamese currency',
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0101',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Viet Nam Dong'
WHERE AccountID = N'1111'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1112')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1112', N'Ngoại tệ', NULL, NULL, N'G01', N'G0101', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Foreign currency')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Ngoại tệ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0101',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Foreign currency'
WHERE AccountID = N'1112'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1113')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1113', N'Vàng tiền tệ', N'Gold, precious stone, silver', NULL, N'G01', N'G0101', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Gold and other')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Vàng tiền tệ',
    Notes1 = N'Gold, precious stone, silver',
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0101',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Gold and other'
WHERE AccountID = N'1113'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'112')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'112', N'Tiền gửi Ngân hàng', N'Bank deposit', NULL, N'G01', N'G0102', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Cash in bank')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tiền gửi Ngân hàng',
    Notes1 = N'Bank deposit',
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0102',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Cash in bank'
WHERE AccountID = N'112'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1121')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1121', N'Tiền Việt Nam', N'Vietnamese currency', NULL, N'G01', N'G0102', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Viet Nam Dong')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tiền Việt Nam',
    Notes1 = N'Vietnamese currency',
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0102',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Viet Nam Dong'
WHERE AccountID = N'1121'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1122')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1122', N'Ngoại tệ', NULL, NULL, N'G01', N'G0102', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Foreign currency')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Ngoại tệ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0102',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Foreign currency'
WHERE AccountID = N'1122'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1123')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1123', N'Vàng tiền tệ', N'Gold, precious stones, silver', NULL, N'G01', N'G0102', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Gold and other')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Vàng tiền tệ',
    Notes1 = N'Gold, precious stones, silver',
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0102',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Gold and other'
WHERE AccountID = N'1123'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'113')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'113', N'Tiền đang chuyển', N'Money being on transfer', NULL, N'G01', N'G0103', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Cash in transit')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tiền đang chuyển',
    Notes1 = N'Money being on transfer',
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0103',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Cash in transit'
WHERE AccountID = N'113'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1131')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1131', N'Tiền Việt Nam', N'Vietnamese currency', NULL, N'G01', N'G0103', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Viet Nam Dong')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tiền Việt Nam',
    Notes1 = N'Vietnamese currency',
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0103',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Viet Nam Dong'
WHERE AccountID = N'1131'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1132')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1132', N'Ngoại tệ', NULL, NULL, N'G01', N'G0103', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Foreign currency')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Ngoại tệ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0103',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Foreign currency'
WHERE AccountID = N'1132'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'121')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'121', N'Chứng khoán kinh doanh', N'Short-term securities investment', NULL, N'G01', N'G0104', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Security investments')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chứng khoán kinh doanh',
    Notes1 = N'Short-term securities investment',
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0104',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Security investments'
WHERE AccountID = N'121'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1211')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1211', N'Cổ phiếu', N'Shares', NULL, N'G01', N'G0104', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Stocks')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Cổ phiếu',
    Notes1 = N'Shares',
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0104',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Stocks'
WHERE AccountID = N'1211'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1212')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1212', N'Trái phiếu', NULL, NULL, N'G01', N'G0104', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Bonds')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Trái phiếu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0104',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Bonds'
WHERE AccountID = N'1212'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1218')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1218', N'Chứng khoán và công cụ tài chính khác', NULL, NULL, N'G01', N'G0104', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chứng khoán và công cụ tài chính khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0104',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other'
WHERE AccountID = N'1218'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'128')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'128', N'Đầu tư nắm giữ đến ngày đáo hạn', N'Other short-term investments', NULL, N'G01', N'G0105', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Đầu tư nắm giữ đến ngày đáo hạn',
    Notes1 = N'Other short-term investments',
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0105',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'128'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1281')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1281', N'Tiền gửi có kỳ hạn', NULL, NULL, N'G01', N'G0105', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Term deposits')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tiền gửi có kỳ hạn',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0105',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Term deposits'
WHERE AccountID = N'1281'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1282')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1282', N'Trái phiếu', NULL, NULL, N'G01', N'G0105', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Bonds')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Trái phiếu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0105',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Bonds'
WHERE AccountID = N'1282'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1283')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1283', N'Cho vay', NULL, NULL, N'G01', N'G0105', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Cho vay',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0105',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'1283'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1288')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1288', N'Các khoản đầu tư khác nắm giữ đến ngày đáo hạn', NULL, NULL, N'G01', N'G0105', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other short-term investments')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Các khoản đầu tư khác nắm giữ đến ngày đáo hạn',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0105',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other short-term investments'
WHERE AccountID = N'1288'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'243')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'243', N'Tài sản thuế thu nhập hoãn lại', NULL, NULL, N'G02', N'G0206', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Deferred income tax assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tài sản thuế thu nhập hoãn lại',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0206',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Deferred income tax assets'
WHERE AccountID = N'243'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'244')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'244', N'Cầm cố, thế chấp, ký quỹ, ký cược', N'Long-term collateral, security amounts', NULL, N'G01', N'G0106', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Pledge, security, collateral')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Cầm cố, thế chấp, ký quỹ, ký cược',
    Notes1 = N'Long-term collateral, security amounts',
    Notes2 = NULL,
    GroupID = N'G01',
    SubGroupID = N'G0106',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Pledge, security, collateral'
WHERE AccountID = N'244'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'211')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'211', N'Tài sản cố định hữu hình', NULL, NULL, N'G02', N'G0201', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Tangible fixed assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tài sản cố định hữu hình',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0201',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Tangible fixed assets'
WHERE AccountID = N'211'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2111')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2111', N'Nhà cửa, vật kiến trúc', NULL, NULL, N'G02', N'G0201', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Buildings and architectural models')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Nhà cửa, vật kiến trúc',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0201',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Buildings and architectural models'
WHERE AccountID = N'2111'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2112')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2112', N'Máy móc, thiết bị', NULL, NULL, N'G02', N'G0201', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Equipment and machines')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Máy móc, thiết bị',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0201',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Equipment and machines'
WHERE AccountID = N'2112'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2113')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2113', N'Phương tiện vận tải, truyền dẫn', NULL, NULL, N'G02', N'G0201', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Transportation and transmit instrument')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phương tiện vận tải, truyền dẫn',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0201',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Transportation and transmit instrument'
WHERE AccountID = N'2113'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2114')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2114', N'Thiết bị, dụng cụ quản lý', NULL, NULL, N'G02', N'G0201', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Instruments and tools for management')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thiết bị, dụng cụ quản lý',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0201',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Instruments and tools for management'
WHERE AccountID = N'2114'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2115')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2115', N'Cây lâu năm, súc vật làm việc và cho sản phẩm', NULL, NULL, N'G02', N'G0201', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Long term trees, working and dead animals')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Cây lâu năm, súc vật làm việc và cho sản phẩm',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0201',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Long term trees, working and dead animals'
WHERE AccountID = N'2115'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2118')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2118', N'TSCĐ khác', NULL, NULL, N'G02', N'G0201', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other fixed assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'TSCĐ khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0201',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other fixed assets'
WHERE AccountID = N'2118'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'212')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'212', N'Tài sản cố định thuê tài chính', N'Financial leasing fixed assets', NULL, N'G02', N'G0202', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Fixed assets of finance leasing')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tài sản cố định thuê tài chính',
    Notes1 = N'Financial leasing fixed assets',
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0202',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Fixed assets of finance leasing'
WHERE AccountID = N'212'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2121')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2121', N'TSCĐ hữu hình thuê tài chính', NULL, NULL, N'G02', N'G0202', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Tangible fixed assets of finance leasing')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'TSCĐ hữu hình thuê tài chính',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0202',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Tangible fixed assets of finance leasing'
WHERE AccountID = N'2121'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2122')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2122', N'TSCĐ vô hình thuê tài chính', NULL, NULL, N'G02', N'G0202', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Intangible fixed assets  of finance leasing')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'TSCĐ vô hình thuê tài chính',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0202',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Intangible fixed assets  of finance leasing'
WHERE AccountID = N'2122'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'213')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'213', N'Tài sản cố định vô hình', NULL, NULL, N'G02', N'G0203', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Intangible fixed assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tài sản cố định vô hình',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0203',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Intangible fixed assets'
WHERE AccountID = N'213'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2131')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2131', N'Quyền sử dụng đất', NULL, NULL, N'G02', N'G0203', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Land use rights')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quyền sử dụng đất',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0203',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Land use rights'
WHERE AccountID = N'2131'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2132')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2132', N'Quyền phát hành', NULL, NULL, N'G02', N'G0203', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Establishment and productive rights')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quyền phát hành',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0203',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Establishment and productive rights'
WHERE AccountID = N'2132'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2133')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2133', N'Bản quyền, bằng sáng chế', NULL, NULL, N'G02', N'G0203', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Patents and creations')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Bản quyền, bằng sáng chế',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0203',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Patents and creations'
WHERE AccountID = N'2133'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2134')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2134', N'Nhãn hiệu, tên thương mại', NULL, NULL, N'G02', N'G0203', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Trademarks')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Nhãn hiệu, tên thương mại',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0203',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Trademarks'
WHERE AccountID = N'2134'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2135')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2135', N'Chương trình phần mềm', NULL, NULL, N'G02', N'G0203', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Software')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chương trình phần mềm',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0203',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Software'
WHERE AccountID = N'2135'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2136')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2136', N'Giấy phép và giấy phép nhượng quyền', NULL, NULL, N'G02', N'G0203', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Licenses and concession licenses')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Giấy phép và giấy phép nhượng quyền',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0203',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Licenses and concession licenses'
WHERE AccountID = N'2136'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2138')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2138', N'TSCĐ vô hình khác', NULL, NULL, N'G02', N'G0203', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other intangible fixed assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'TSCĐ vô hình khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0203',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other intangible fixed assets'
WHERE AccountID = N'2138'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'214')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'214', N'Hao mòn tài sản cố định', N'Fixed asset tear and wear', NULL, N'G02', N'G0204', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Depreciation of fixed assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Hao mòn tài sản cố định',
    Notes1 = N'Fixed asset tear and wear',
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0204',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Depreciation of fixed assets'
WHERE AccountID = N'214'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2141')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2141', N'Hao mòn TSCĐ hữu hình', NULL, NULL, N'G02', N'G0204', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Tangible fixed asset')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Hao mòn TSCĐ hữu hình',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0204',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Tangible fixed asset'
WHERE AccountID = N'2141'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2142')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2142', N'Hao mòn TSCĐ thuê tài chính', NULL, NULL, N'G02', N'G0204', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Financial leasing fixed assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Hao mòn TSCĐ thuê tài chính',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0204',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Financial leasing fixed assets'
WHERE AccountID = N'2142'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2143')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2143', N'Hao mòn TSCĐ vô hình', NULL, NULL, N'G02', N'G0204', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Intangible fixed asset')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Hao mòn TSCĐ vô hình',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0204',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Intangible fixed asset'
WHERE AccountID = N'2143'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2147')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2147', N'Hao mòn bất động sản đầu tư', NULL, NULL, N'G02', N'G0204', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Investment real estate')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Hao mòn bất động sản đầu tư',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0204',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Investment real estate'
WHERE AccountID = N'2147'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'217')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'217', N'Bất động sản đầu tư', NULL, NULL, N'G02', N'G0205', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Investment real estate')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Bất động sản đầu tư',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0205',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Investment real estate'
WHERE AccountID = N'217'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'241')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'241', N'Xây dựng cơ bản dỡ dang', N'Unfinished capital construction', NULL, N'G02', N'G0205', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Construction in process')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Xây dựng cơ bản dỡ dang',
    Notes1 = N'Unfinished capital construction',
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0205',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Construction in process'
WHERE AccountID = N'241'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2411')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2411', N'Mua sắm TSCĐ', NULL, NULL, N'G02', N'G0205', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Fixed assets purchases')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Mua sắm TSCĐ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0205',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Fixed assets purchases'
WHERE AccountID = N'2411'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2412')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2412', N'Xây dựng cơ bản', NULL, NULL, N'G02', N'G0205', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Capital construction')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Xây dựng cơ bản',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0205',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Capital construction'
WHERE AccountID = N'2412'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2413')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2413', N'Sửa chữa lớn TSCĐ', NULL, NULL, N'G02', N'G0205', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Overhauls of fixed assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Sửa chữa lớn TSCĐ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0205',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Overhauls of fixed assets'
WHERE AccountID = N'2413'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'242')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'242', N'Chi phí trả trước', NULL, NULL, N'G02', N'G0206', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Prepayments')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí trả trước',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G02',
    SubGroupID = N'G0206',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Prepayments'
WHERE AccountID = N'242'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'161')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'161', N'Chi sự nghiệp', N'Public-service expenditure', NULL, N'G03', N'G0301', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Non-business expenditures')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi sự nghiệp',
    Notes1 = N'Public-service expenditure',
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0301',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Non-business expenditures'
WHERE AccountID = N'161'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1611')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1611', N'Chi sự nghiệp năm trước', N'Preceding year''s public-service expenditure', NULL, N'G03', N'G0301', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Current period')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi sự nghiệp năm trước',
    Notes1 = N'Preceding year''s public-service expenditure',
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0301',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Current period'
WHERE AccountID = N'1611'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1612')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1612', N'Chi sự nghiệp năm nay', N'Current year''s public-service expenditure', NULL, N'G03', N'G0301', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Prior periods')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi sự nghiệp năm nay',
    Notes1 = N'Current year''s public-service expenditure',
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0301',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Prior periods'
WHERE AccountID = N'1612'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'171')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'171', N'Giao dịch mua bán lại trái phiếu chính phủ', NULL, NULL, N'G03', N'G0302', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Government bonds transaction')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Giao dịch mua bán lại trái phiếu chính phủ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0302',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Government bonds transaction'
WHERE AccountID = N'171'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'131')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'131', N'Phải thu của khách hàng', N'To be collected from customers', NULL, N'G03', N'G0303', 0, 0, 1, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Receivable from customers')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải thu của khách hàng',
    Notes1 = N'To be collected from customers',
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0303',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Receivable from customers'
WHERE AccountID = N'131'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1311')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1311', N'Phải thu của khách hàng', NULL, NULL, N'G03', N'G0303', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Short-term Receivable from customers')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải thu của khách hàng ngắn hạn',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0303',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Short-term Receivable from customers'
WHERE AccountID = N'1311'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1312')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1312', N'Phải thu của khách hàng', NULL, NULL, N'G03', N'G0303', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Long-term Receivable from customers')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải thu của khách hàng dài hạn',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0303',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Long-term Receivable from customers'
WHERE AccountID = N'1312'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'133')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'133', N'Thuế GTGT được khấu trừ', N'Deducted value-added tax', NULL, N'G03', N'G0304', 0, 0, 1, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Value added tax deductible')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế GTGT được khấu trừ',
    Notes1 = N'Deducted value-added tax',
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0304',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Value added tax deductible'
WHERE AccountID = N'133'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1331')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1331', N'Thuế GTGT được khấu trừ của hàng hóa, dịch vụ', NULL, NULL, N'G03', N'G0304', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Goods and services')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế GTGT được khấu trừ của hàng hóa, dịch vụ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0304',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Goods and services'
WHERE AccountID = N'1331'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1332')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1332', N'Thuế GTGT được khấu trừ của TSCĐ', NULL, NULL, N'G03', N'G0304', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Fixed assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế GTGT được khấu trừ của TSCĐ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0304',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Fixed assets'
WHERE AccountID = N'1332'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'136')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'136', N'Phải thu nội bộ', NULL, NULL, N'G03', N'G0305', 0, 0, 1, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Internal receivable')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải thu nội bộ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0305',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Internal receivable'
WHERE AccountID = N'136'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1361')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1361', N'Vốn kinh doanh ở các đơn vị trực thuộc', N'Business capital at attached units', NULL, N'G03', N'G0305', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Capital in dependent units')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Vốn kinh doanh ở các đơn vị trực thuộc',
    Notes1 = N'Business capital at attached units',
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0305',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Capital in dependent units'
WHERE AccountID = N'1361'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1362')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1362', N'Phải thu nội bộ về chênh lệch tỷ giá', NULL, NULL, N'G03', N'G0305', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải thu nội bộ về chênh lệch tỷ giá',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0305',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'1362'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1363')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1363', N'Phải thu nội bộ về chi phí đi vay đủ điều kiện được vốn hoá', NULL, NULL, N'G03', N'G0305', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải thu nội bộ về chi phí đi vay đủ điều kiện được vốn hoá',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0305',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'1363'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1368')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1368', N'Phải thu nội bộ khác', N'Other to be internally collected amounts', NULL, N'G03', N'G0305', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải thu nội bộ khác',
    Notes1 = N'Other to be internally collected amounts',
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0305',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other'
WHERE AccountID = N'1368'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'138')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'138', N'Phải thu khác', N'Other to be-collected amounts', NULL, N'G03', N'G0306', 0, 0, 1, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other receivables')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải thu khác',
    Notes1 = N'Other to be-collected amounts',
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0306',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other receivables'
WHERE AccountID = N'138'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1381')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1381', N'Tài sản thiếu chờ xử lý', N'Deficit assets awaiting the handling', NULL, N'G03', N'G0306', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other receivable-shortage assets awaiting resolution')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tài sản thiếu chờ xử lý',
    Notes1 = N'Deficit assets awaiting the handling',
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0306',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other receivable-shortage assets awaiting resolution'
WHERE AccountID = N'1381'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1385')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1385', N'Phải thu về cổ phần hoá', NULL, NULL, N'G03', N'G0306', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Receivable for equitization')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải thu về cổ phần hoá',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0306',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Receivable for equitization'
WHERE AccountID = N'1385'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1388')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1388', N'Phải thu khác', NULL, NULL, N'G03', N'G0306', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other receivables')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải thu khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0306',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other receivables'
WHERE AccountID = N'1388'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'141')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'141', N'Tạm ứng', NULL, NULL, N'G03', N'G0307', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Advances')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tạm ứng',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G03',
    SubGroupID = N'G0307',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Advances'
WHERE AccountID = N'141'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'331')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'331', N'Phải trả cho người bán', N'To be paid to the seller', NULL, N'G04', N'G0401', 0, 0, 1, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Payable to sellers')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả cho người bán',
    Notes1 = N'To be paid to the seller',
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0401',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Payable to sellers'
WHERE AccountID = N'331'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3311')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3311', N'Phải trả cho người bán ngắn hạn', NULL, NULL, N'G04', N'G0401', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Payable to sellers - Short-term')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả cho người bán ngắn hạn',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0401',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Payable to sellers - Short-term'
WHERE AccountID = N'3311'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3312')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3312', N'Phải trả cho người bán dài hạn', NULL, NULL, N'G04', N'G0401', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Payable to sellers - Long-term')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả cho người bán dài hạn',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0401',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Payable to sellers - Long-term'
WHERE AccountID = N'3312'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'333')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'333', N'Thuế và các khoản phải nộp nhà nước', N'Taxes and amounts payable to the State', NULL, N'G04', N'G0402', 0, 0, 1, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Taxes and payable to state budget')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế và các khoản phải nộp nhà nước',
    Notes1 = N'Taxes and amounts payable to the State',
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Taxes and payable to state budget'
WHERE AccountID = N'333'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3331')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3331', N'Thuế giá trị gia tăng phải nộp', NULL, NULL, N'G04', N'G0402', 0, 0, 1, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'VAT payable')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế giá trị gia tăng phải nộp',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'VAT payable'
WHERE AccountID = N'3331'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'33311')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'33311', N'Thuế GTGT đầu ra', NULL, NULL, N'G04', N'G0402', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'The output VAT')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế GTGT đầu ra',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'The output VAT'
WHERE AccountID = N'33311'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'33312')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'33312', N'Thuế GTGT hàng nhập khẩu', NULL, NULL, N'G04', N'G0402', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'VAT on import goods')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế GTGT hàng nhập khẩu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'VAT on import goods'
WHERE AccountID = N'33312'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3332')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3332', N'Thuế tiêu thụ đặc biệt', NULL, NULL, N'G04', N'G0402', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Special consumption tax')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế tiêu thụ đặc biệt',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Special consumption tax'
WHERE AccountID = N'3332'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3333')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3333', N'Thuế xuất, nhập khẩu', N'Import and export duties', NULL, N'G04', N'G0402', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Export tax, import tax')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế xuất, nhập khẩu',
    Notes1 = NULL,
    Notes2 = N'Import and export duties',
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Export tax, import tax'
WHERE AccountID = N'3333'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3334')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3334', N'Thuế thu nhập doanh nghiệp', NULL, NULL, N'G04', N'G0402', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Enterprise income tax')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế thu nhập doanh nghiệp',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Enterprise income tax'
WHERE AccountID = N'3334'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3335')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3335', N'Thuế thu nhập cá nhân', NULL, NULL, N'G04', N'G0402', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Personal income tax')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế thu nhập cá nhân',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Personal income tax'
WHERE AccountID = N'3335'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3336')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3336', N'Thuế tài nguyên', NULL, NULL, N'G04', N'G0402', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Natural resource tax')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế tài nguyên',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Natural resource tax'
WHERE AccountID = N'3336'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3337')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3337', N'Thuế nhà đất, tiền thuê đất', N'Housing and land tax, land rent', NULL, N'G04', N'G0402', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Land & housing tax, land rental charges')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế nhà đất, tiền thuê đất',
    Notes1 = N'Housing and land tax, land rent',
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Land & housing tax, land rental charges'
WHERE AccountID = N'3337'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3338')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3338', N'Thuế bảo vệ môi trường và các loại thuế khác', NULL, NULL, N'G04', N'G0402', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế bảo vệ môi trường và các loại thuế khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'3338'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'33381')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'33381', N'Thuế bảo vệ môi trường', NULL, NULL, N'G04', N'G0402', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế bảo vệ môi trường',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'33381'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'33382')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'33382', N'Các loại thuế khác', NULL, NULL, N'G04', N'G0402', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other taxes')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Các loại thuế khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other taxes'
WHERE AccountID = N'33382'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3339')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3339', N'Phí, lệ phí và các khoản phải nộp khác', NULL, NULL, N'G04', N'G0402', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Fees, charges& other payables')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phí, lệ phí và các khoản phải nộp khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0402',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Fees, charges& other payables'
WHERE AccountID = N'3339'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'334')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'334', N'Phải trả người lao động', NULL, NULL, N'G04', N'G0403', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Payable to employees')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả người lao động',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0403',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Payable to employees'
WHERE AccountID = N'334'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3341')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3341', N'Phải trả công nhân viên', NULL, NULL, N'G04', N'G0403', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Payable to employees')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả công nhân viên',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0403',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Payable to employees'
WHERE AccountID = N'3341'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3348')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3348', N'Phải trả người lao động khác', NULL, NULL, N'G04', N'G0403', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Payable to other employees')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả người lao động khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0403',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Payable to other employees'
WHERE AccountID = N'3348'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'335')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'335', N'Chi phí phải trả', N'Accruals', NULL, N'G04', N'G0404', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Payable expenses')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí phải trả',
    Notes1 = N'Accruals',
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0404',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Payable expenses'
WHERE AccountID = N'335'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'336')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'336', N'Phải trả nội bộ', NULL, NULL, N'G04', N'G0405', 0, 0, 1, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Internally payables')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả nội bộ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0405',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Internally payables'
WHERE AccountID = N'336'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3361')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3361', N'Phải trả nội bộ về vốn kinh doanh', NULL, NULL, N'G04', N'G0405', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả nội bộ về vốn kinh doanh',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0405',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'3361'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3362')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3362', N'Phải trả nội bộ về chênh lệch tỷ giá', NULL, NULL, N'G04', N'G0405', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả nội bộ về chênh lệch tỷ giá',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0405',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'3362'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3363')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3363', N'Phải trả nội bộ về chi phí đi vay đủ điều kiện được vốn hoá', NULL, NULL, N'G04', N'G0405', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả nội bộ về chi phí đi vay đủ điều kiện được vốn hoá',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0405',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'3363'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3368')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3368', N'Phải trả nội bộ khác', NULL, NULL, N'G04', N'G0405', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả nội bộ khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0405',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other'
WHERE AccountID = N'3368'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'337')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'337', N'Thanh toán theo tiến độ kế hoạch hợp đồng xây dựng', NULL, NULL, N'G04', N'G0406', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Construction contract progress payment due to customers')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thanh toán theo tiến độ kế hoạch hợp đồng xây dựng',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0406',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Construction contract progress payment due to customers'
WHERE AccountID = N'337'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'338')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'338', N'Phải trả, phải nộp khác', N'Other amounts to be repaid, to be remitted', NULL, N'G04', N'G0407', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other payables')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả, phải nộp khác',
    Notes1 = N'Other amounts to be repaid, to be remitted',
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0407',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other payables'
WHERE AccountID = N'338'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3381')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3381', N'Tài sản thừa chờ giải quyết', NULL, NULL, N'G04', N'G0407', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Surplus assets awaiting the handling')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Tài sản thừa chờ giải quyết',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0407',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Surplus assets awaiting the handling'
WHERE AccountID = N'3381'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3382')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3382', N'Kinh phí công đoàn', NULL, NULL, N'G04', N'G0407', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Trade union fees')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Kinh phí công đoàn',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0407',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Trade union fees'
WHERE AccountID = N'3382'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3383')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3383', N'Bảo hiểm xã hội', NULL, NULL, N'G04', N'G0407', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Social insurance')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Bảo hiểm xã hội',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0407',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Social insurance'
WHERE AccountID = N'3383'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3384')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3384', N'Bảo hiểm y tế', NULL, NULL, N'G04', N'G0407', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Health insurance')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Bảo hiểm y tế',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0407',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Health insurance'
WHERE AccountID = N'3384'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3385')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3385', N'Phải trả về cổ phần hoá', NULL, NULL, N'G04', N'G0407', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Equitization payable')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả về cổ phần hoá',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0407',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Equitization payable'
WHERE AccountID = N'3385'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3386')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3386', N'Bảo hiểm thất nghiệp', NULL, NULL, N'G04', N'G0407', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Unemployment insurance')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Bảo hiểm thất nghiệp',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0407',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Unemployment insurance'
WHERE AccountID = N'3386'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3387')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3387', N'Doanh thu chưa thực hiện', N'Turnover received in advance', NULL, N'G04', N'G0407', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Unrealized turnover')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Doanh thu chưa thực hiện',
    Notes1 = N'Turnover received in advance',
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0407',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Unrealized turnover'
WHERE AccountID = N'3387'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3388')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3388', N'Phải trả, phải nộp khác', NULL, NULL, N'G04', N'G0407', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other payables')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phải trả, phải nộp khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0407',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other payables'
WHERE AccountID = N'3388'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'341')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'341', N'Vay và nợ thuê tài chính', N'Long-term loans', NULL, N'G04', N'G0408', 0, 0, 1, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Borrowing and finance leasing')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Vay và nợ thuê tài chính',
    Notes1 = N'Long-term loans',
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0408',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Borrowing and finance leasing'
WHERE AccountID = N'341'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3411')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3411', N'Các khoản đi vay', NULL, NULL, N'G04', N'G0408', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Bank and other borrowing')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Các khoản đi vay',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0408',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Bank and other borrowing'
WHERE AccountID = N'3411'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3412')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3412', N'Nợ thuê tài chính', NULL, NULL, N'G04', N'G0408', 0, 0, 1, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Finance leasing and other liabilities')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Nợ thuê tài chính',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0408',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Finance leasing and other liabilities'
WHERE AccountID = N'3412'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'343')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'343', N'Trái phiếu phát hành', NULL, NULL, N'G04', N'G0409', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Issued bonds')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Trái phiếu phát hành',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0409',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Issued bonds'
WHERE AccountID = N'343'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3431')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3431', N'Trái phiếu thường', NULL, NULL, N'G04', N'G0409', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Trái phiếu thường',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0409',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 1,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'3431'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'34311')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'34311', N'Mệnh giá trái phiếu', NULL, NULL, N'G04', N'G0409', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Bond face value')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Mệnh giá trái phiếu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0409',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Bond face value'
WHERE AccountID = N'34311'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'34312')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'34312', N'Chiết khấu trái phiếu', NULL, NULL, N'G04', N'G0409', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Bond discount')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chiết khấu trái phiếu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0409',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Bond discount'
WHERE AccountID = N'34312'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'34313')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'34313', N'Phụ trội trái phiếu', NULL, NULL, N'G04', N'G0409', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Additional bonds')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Phụ trội trái phiếu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0409',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Additional bonds'
WHERE AccountID = N'34313'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3432')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3432', N'Trái phiếu chuyển đổi', NULL, NULL, N'G04', N'G0409', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Trái phiếu chuyển đổi',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0409',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'3432'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'344')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'344', N'Nhận ký quỹ, ký cược', N'Taken as collateral, security', NULL, N'G04', N'G0410', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Deposits received')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Nhận ký quỹ, ký cược',
    Notes1 = N'Taken as collateral, security',
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0410',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Deposits received'
WHERE AccountID = N'344'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'347')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'347', N'Thuế thu nhập hoãn lại phải trả', NULL, NULL, N'G04', N'G0411', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Deferred income taxes')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế thu nhập hoãn lại phải trả',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0411',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Deferred income taxes'
WHERE AccountID = N'347'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'352')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'352', N'Dự phòng phải trả', NULL, NULL, N'G04', N'G0412', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Provisions for payables')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Dự phòng phải trả',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0412',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Provisions for payables'
WHERE AccountID = N'352'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3521')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3521', N'Dự phòng bảo hành sản phẩm hàng hoá', NULL, NULL, N'G04', N'G0412', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Provisions for payables - goods')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Dự phòng bảo hành sản phẩm hàng hoá',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0412',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Provisions for payables - goods'
WHERE AccountID = N'3521'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3522')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3522', N'Dự phòng bảo hành công trình xây dựng', NULL, NULL, N'G04', N'G0412', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Dự phòng bảo hành công trình xây dựng',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0412',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'3522'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3523')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3523', N'Dự phòng tái cơ cấu doanh nghiệp', NULL, NULL, N'G04', N'G0412', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Dự phòng tái cơ cấu doanh nghiệp',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0412',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'3523'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3524')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3524', N'Dự phòng phải trả khác', NULL, NULL, N'G04', N'G0412', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Provisions for payables - other')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Dự phòng phải trả khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0412',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Provisions for payables - other'
WHERE AccountID = N'3524'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'353')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'353', N'Quỹ khen thưởng, phúc lợi', NULL, NULL, N'G04', N'G0413', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Bonus fund- welfare fund')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quỹ khen thưởng, phúc lợi',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0413',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Bonus fund- welfare fund'
WHERE AccountID = N'353'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3531')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3531', N'Quỹ khen thưởng', NULL, NULL, N'G04', N'G0413', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Bonus fund')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quỹ khen thưởng',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0413',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Bonus fund'
WHERE AccountID = N'3531'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3532')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3532', N'Quỹ phúc lợi', NULL, NULL, N'G04', N'G0413', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Welfare fund')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quỹ phúc lợi',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0413',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Welfare fund'
WHERE AccountID = N'3532'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3533')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3533', N'Quỹ phúc lợi đã hình thành TSCĐ', NULL, NULL, N'G04', N'G0413', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Welfare fund used to acquire fixed assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quỹ phúc lợi đã hình thành TSCĐ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0413',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Welfare fund used to acquire fixed assets'
WHERE AccountID = N'3533'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3534')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3534', N'Quỹ thưởng ban quản lý điều hành công ty', NULL, NULL, N'G04', N'G0413', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Bonus for management')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quỹ thưởng ban quản lý điều hành công ty',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0413',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Bonus for management'
WHERE AccountID = N'3534'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'356')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'356', N'Quỹ phát triển khoa học và công nghệ', NULL, NULL, N'G04', N'G0414', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Science and technology development fund')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quỹ phát triển khoa học và công nghệ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0414',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Science and technology development fund'
WHERE AccountID = N'356'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3561')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3561', N'Quỹ phát triển khoa học và công nghệ', NULL, NULL, N'G04', N'G0414', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Science and technology development fund')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quỹ phát triển khoa học và công nghệ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0414',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Science and technology development fund'
WHERE AccountID = N'3561'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'3562')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'3562', N'Quỹ phát triển khoa học và công nghệ đã hình thành TSCĐ', NULL, NULL, N'G04', N'G0414', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Science and technology development fund used to acquire fixed assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quỹ phát triển khoa học và công nghệ đã hình thành TSCĐ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0414',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Science and technology development fund used to acquire fixed assets'
WHERE AccountID = N'3562'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'357')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'357', N'Quỹ bình ổn giá', NULL, NULL, N'G04', N'G0415', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Price valorization fund')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quỹ bình ổn giá',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G04',
    SubGroupID = N'G0415',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Price valorization fund'
WHERE AccountID = N'357'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'152')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'152', N'Nguyên liệu, vật liệu', NULL, NULL, N'G05', N'G0501', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Raw materials, materials')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Nguyên liệu, vật liệu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0501',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Raw materials, materials'
WHERE AccountID = N'152'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'153')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'153', N'Công cụ, dụng cụ', NULL, NULL, N'G05', N'G0502', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Instrument, tools')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Công cụ, dụng cụ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0502',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Instrument, tools'
WHERE AccountID = N'153'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1531')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1531', N'Công cụ, dụng cụ', NULL, NULL, N'G05', N'G0502', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Instrument, tools')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Công cụ, dụng cụ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0502',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Instrument, tools'
WHERE AccountID = N'1531'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1532')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1532', N'Bao bì luân chuyển', NULL, NULL, N'G05', N'G0502', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Packing')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Bao bì luân chuyển',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0502',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Packing'
WHERE AccountID = N'1532'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1533')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1533', N'Đồ dùng cho thuê', NULL, NULL, N'G05', N'G0502', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Instruments and tools for lease')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Đồ dùng cho thuê',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0502',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Instruments and tools for lease'
WHERE AccountID = N'1533'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1534')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1534', N'Thiết bị, phụ tùng thay thế', NULL, NULL, N'G05', N'G0502', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thiết bị, phụ tùng thay thế',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0502',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'1534'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'155')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'155', N'Thành phẩm', NULL, NULL, N'G05', N'G0503', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Finished products')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thành phẩm',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0503',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Finished products'
WHERE AccountID = N'155'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1551')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1551', N'Thành phẩm nhập kho', NULL, NULL, N'G05', N'G0503', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Finished products')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thành phẩm nhập kho',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0503',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Finished products'
WHERE AccountID = N'1551'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1557')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1557', N'Thành phẩm bất động sản', NULL, NULL, N'G05', N'G0503', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thành phẩm bất động sản',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0503',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'1557'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'156')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'156', N'Hàng hóa', NULL, NULL, N'G05', N'G0504', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Goods')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Hàng hóa',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0504',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Goods'
WHERE AccountID = N'156'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1561')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1561', N'Giá mua hàng hoá', NULL, NULL, N'G05', N'G0504', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Price of purchases')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Giá mua hàng hoá',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0504',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Price of purchases'
WHERE AccountID = N'1561'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1562')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1562', N'Chi phí thu mua hàng hoá', NULL, NULL, N'G05', N'G0504', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Cost of purchases')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí thu mua hàng hoá',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0504',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Cost of purchases'
WHERE AccountID = N'1562'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'1567')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'1567', N'Hàng hoá bất động sản', NULL, NULL, N'G05', N'G0504', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Real estate')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Hàng hoá bất động sản',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0504',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Real estate'
WHERE AccountID = N'1567'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'157')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'157', N'Hàng gửi đi bán', N'Goods delivered for sale', NULL, N'G05', N'G0505', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Goods in transit for sale')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Hàng gửi đi bán',
    Notes1 = N'Goods delivered for sale',
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0505',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Goods in transit for sale'
WHERE AccountID = N'157'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'158')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'158', N'Hàng hoá kho bảo thuế', NULL, NULL, N'G05', N'G0506', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Goods in bonded warehouse')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Hàng hoá kho bảo thuế',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G05',
    SubGroupID = N'G0506',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Goods in bonded warehouse'
WHERE AccountID = N'158'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'811')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'811', N'Chi phí khác', N'Financial operation expenses', NULL, N'G06', N'G0601', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other expenses')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí khác',
    Notes1 = N'Financial operation expenses',
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0601',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other expenses'
WHERE AccountID = N'811'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'611')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'611', N'Mua hàng', NULL, NULL, N'G06', N'G0602', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Purchases')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Mua hàng',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0602',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Purchases'
WHERE AccountID = N'611'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6111')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6111', N'Mua nguyên liệu, vật liệu', NULL, NULL, N'G06', N'G0602', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Raw material purchases')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Mua nguyên liệu, vật liệu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0602',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Raw material purchases'
WHERE AccountID = N'6111'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6112')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6112', N'Mua hàng hoá', NULL, NULL, N'G06', N'G0602', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Goods purchases')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Mua hàng hoá',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0602',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Goods purchases'
WHERE AccountID = N'6112'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'621')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'621', N'Chi phí nguyên liệu, vật liệu trực tiếp', N'Cost for direct raw materials', NULL, N'G06', N'G0603', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Direct raw materials cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí nguyên liệu, vật liệu trực tiếp',
    Notes1 = N'Cost for direct raw materials',
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0603',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Direct raw materials cost'
WHERE AccountID = N'621'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'622')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'622', N'Chi phí nhân công trực tiếp', N'Cost for direct labours', NULL, N'G06', N'G0604', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Direct labor cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí nhân công trực tiếp',
    Notes1 = N'Cost for direct labours',
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0604',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Direct labor cost'
WHERE AccountID = N'622'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'623')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'623', N'Chi phí sử dụng máy thi công', NULL, NULL, N'G06', N'G0605', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Executing machine using cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí sử dụng máy thi công',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0605',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Executing machine using cost'
WHERE AccountID = N'623'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6231')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6231', N'Chi phí nhân công', NULL, NULL, N'G06', N'G0605', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Labor cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí nhân công',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0605',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Labor cost'
WHERE AccountID = N'6231'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6232')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6232', N'Chi phí nguyên, vật liệu', NULL, NULL, N'G06', N'G0605', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Material cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí nguyên, vật liệu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0605',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Material cost'
WHERE AccountID = N'6232'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6233')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6233', N'Chi phí dụng cụ sản xuất', NULL, NULL, N'G06', N'G0605', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Production tool cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí dụng cụ sản xuất',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0605',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Production tool cost'
WHERE AccountID = N'6233'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6234')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6234', N'Chi phí khấu hao máy thi công', NULL, NULL, N'G06', N'G0605', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Executing machine depreciation')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí khấu hao máy thi công',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0605',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Executing machine depreciation'
WHERE AccountID = N'6234'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6237')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6237', N'Chi phí dịch vụ mua ngoài', NULL, NULL, N'G06', N'G0605', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Outside purchasing services cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí dịch vụ mua ngoài',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0605',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Outside purchasing services cost'
WHERE AccountID = N'6237'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6238')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6238', N'Chi phí bằng tiền khác', NULL, NULL, N'G06', N'G0605', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí bằng tiền khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0605',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other cost'
WHERE AccountID = N'6238'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'627')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'627', N'Chi phí sản xuất chung', NULL, NULL, N'G06', N'G0606', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'General operation cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí sản xuất chung',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0606',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'General operation cost'
WHERE AccountID = N'627'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6271')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6271', N'Chi phí nhân viên phân xưởng', NULL, NULL, N'G06', N'G0606', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Labor cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí nhân viên phân xưởng',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0606',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Labor cost'
WHERE AccountID = N'6271'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6272')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6272', N'Chi phí nguyên, vật liệu', NULL, NULL, N'G06', N'G0606', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Material cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí nguyên, vật liệu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0606',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Material cost'
WHERE AccountID = N'6272'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6273')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6273', N'Chi phí dụng cụ sản xuất', NULL, NULL, N'G06', N'G0606', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Production tool cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí dụng cụ sản xuất',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0606',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Production tool cost'
WHERE AccountID = N'6273'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6274')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6274', N'Chi phí khấu hao TSCĐ', N'Factory overhead - salary', NULL, N'G06', N'G0606', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Fixed asset depreciation')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí khấu hao TSCĐ',
    Notes1 = N'Factory overhead - salary',
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0606',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Fixed asset depreciation'
WHERE AccountID = N'6274'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6277')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6277', N'Chi phí chung dịch vụ ngoài', NULL, NULL, N'G06', N'G0606', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Outside purchasing services cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí chung dịch vụ ngoài',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0606',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Outside purchasing services cost'
WHERE AccountID = N'6277'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6278')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6278', N'Chi phí bằng tiền khác', NULL, NULL, N'G06', N'G0606', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other cash expense')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí bằng tiền khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0606',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other cash expense'
WHERE AccountID = N'6278'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'631')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'631', N'Giá thành sản xuất', NULL, NULL, N'G06', N'G0607', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Production cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Giá thành sản xuất',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0607',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Production cost'
WHERE AccountID = N'631'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'632')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'632', N'Giá vốn hàng bán', NULL, NULL, N'G06', N'G0608', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Cost of goods sold')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Giá vốn hàng bán',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0608',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Cost of goods sold'
WHERE AccountID = N'632'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'635')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'635', N'Chi phí tài chính', NULL, NULL, N'G06', N'G0609', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Financial activities expenses')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí tài chính',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0609',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Financial activities expenses'
WHERE AccountID = N'635'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'641')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'641', N'Chi phí bán hàng', NULL, NULL, N'G06', N'G0610', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Selling expenses')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí bán hàng',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0610',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Selling expenses'
WHERE AccountID = N'641'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6411')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6411', N'Chi phí nhân viên', NULL, NULL, N'G06', N'G0610', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Labor cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí nhân viên',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0610',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Labor cost'
WHERE AccountID = N'6411'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6412')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6412', N'Chi phí nguyên vật liệu, bao bì', NULL, NULL, N'G06', N'G0610', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Materials, packing cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí nguyên vật liệu, bao bì',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0610',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Materials, packing cost'
WHERE AccountID = N'6412'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6413')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6413', N'Chi phí dụng cụ, đồ dùng', NULL, NULL, N'G06', N'G0610', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Tools cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí dụng cụ, đồ dùng',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0610',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Tools cost'
WHERE AccountID = N'6413'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6414')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6414', N'Chi phí khấu hao TSCĐ', NULL, NULL, N'G06', N'G0610', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Fixed asset depreciation')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí khấu hao TSCĐ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0610',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Fixed asset depreciation'
WHERE AccountID = N'6414'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6415')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6415', N'Chi phí bảo hành', NULL, NULL, N'G06', N'G0610', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Warranty cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí bảo hành',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0610',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Warranty cost'
WHERE AccountID = N'6415'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6417')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6417', N'Chi phí dịch vụ mua ngoài', NULL, NULL, N'G06', N'G0610', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Outside purchasing services cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí dịch vụ mua ngoài',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0610',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Outside purchasing services cost'
WHERE AccountID = N'6417'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6418')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6418', N'Chi phí bằng tiền khác', NULL, NULL, N'G06', N'G0610', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other cash expense')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí bằng tiền khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0610',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other cash expense'
WHERE AccountID = N'6418'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'642')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'642', N'Chi phí quản lý doanh nghiệp', N'Enterprise management expenses', NULL, N'G06', N'G0611', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'General & administration expenses')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí quản lý doanh nghiệp',
    Notes1 = N'Enterprise management expenses',
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0611',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'General & administration expenses'
WHERE AccountID = N'642'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6421')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6421', N'Chi phí nhân viên quản lý', NULL, NULL, N'G06', N'G0611', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Labour cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí nhân viên quản lý',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0611',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Labour cost'
WHERE AccountID = N'6421'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6422')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6422', N'Chi phí vật liệu quản lý', NULL, NULL, N'G06', N'G0611', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Management tools')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí vật liệu quản lý',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0611',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Management tools'
WHERE AccountID = N'6422'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6423')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6423', N'Chi phí đồ dùng văn phòng', NULL, NULL, N'G06', N'G0611', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Stationery cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí đồ dùng văn phòng',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0611',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Stationery cost'
WHERE AccountID = N'6423'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6424')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6424', N'Chi phí khấu hao TSCĐ', NULL, NULL, N'G06', N'G0611', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Fixed asset depreciation')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí khấu hao TSCĐ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0611',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Fixed asset depreciation '
WHERE AccountID = N'6424'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6425')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6425', N'Thuế, phí và lệ phí', NULL, NULL, N'G06', N'G0611', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Taxes, fees and charges')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thuế, phí và lệ phí',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0611',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Taxes, fees and charges'
WHERE AccountID = N'6425'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6426')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6426', N'Chi phí dự phòng', NULL, NULL, N'G06', N'G0611', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Provisions')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí dự phòng',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0611',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Provisions'
WHERE AccountID = N'6426'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6427')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6427', N'Chi phí dịch vụ mua ngoài', NULL, NULL, N'G06', N'G0611', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Outside purchasing services cost')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí dịch vụ mua ngoài',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0611',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Outside purchasing services cost'
WHERE AccountID = N'6427'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'6428')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'6428', N'Chi phí bằng tiền khác', NULL, NULL, N'G06', N'G0611', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other cash expenses')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí bằng tiền khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G06',
    SubGroupID = N'G0611',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other cash expenses'
WHERE AccountID = N'6428'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'711')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'711', N'Thu nhập khác', N'Financial operation income', NULL, N'G07', N'G0701', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other income')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thu nhập khác',
    Notes1 = N'Financial operation income',
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0701',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other income'
WHERE AccountID = N'711'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'511')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'511', N'Doanh thu bán hàng và cung cấp dịch vụ', NULL, NULL, N'G07', N'G0702', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Sale turnover')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Doanh thu bán hàng và cung cấp dịch vụ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0702',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Sale turnover'
WHERE AccountID = N'001'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'5111')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'5111', N'Doanh thu bán hàng hóa', NULL, NULL, N'G07', N'G0702', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Goods')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Doanh thu bán hàng hóa',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0702',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Goods'
WHERE AccountID = N'5111'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'5112')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'5112', N'Doanh thu bán các thành phẩm', NULL, NULL, N'G07', N'G0702', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Finished Products')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Doanh thu bán các thành phẩm',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0702',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Finished Products'
WHERE AccountID = N'5112'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'5113')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'5113', N'Doanh thu cung cấp dịch vụ', NULL, NULL, N'G07', N'G0702', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Services')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Doanh thu cung cấp dịch vụ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0702',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Services'
WHERE AccountID = N'5113'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'5114')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'5114', N'Doanh thu trợ cấp, trợ giá', NULL, NULL, N'G07', N'G0702', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Allowances')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Doanh thu trợ cấp, trợ giá',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0702',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Allowances'
WHERE AccountID = N'5114'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'5117')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'5117', N'Doanh thu kinh doanh bất động sản đầu tư', NULL, NULL, N'G07', N'G0702', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Investments in real estate')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Doanh thu kinh doanh bất động sản đầu tư',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0702',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Investments in real estate'
WHERE AccountID = N'5117'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'5118')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'5118', N'Doanh thu khác', NULL, NULL, N'G07', N'G0702', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other revenues')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Doanh thu khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0702',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other revenues'
WHERE AccountID = N'5118'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'515')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'515', N'Doanh thu hoạt động tài chính', NULL, NULL, N'G07', N'G0703', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Financial activities income')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Doanh thu hoạt động tài chính',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0703',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Financial activities income'
WHERE AccountID = N'515'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'521')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'521', N'Các khoản giảm trừ doanh thu', NULL, NULL, N'G07', N'G0704', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Các khoản giảm trừ doanh thu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0704',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'521'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'5211')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'5211', N'Chiết khấu thương mại', NULL, NULL, N'G07', N'G0704', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Sale discounts')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chiết khấu thương mại',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0704',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Sale discounts'
WHERE AccountID = N'5211'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'5212')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'5212', N'Giảm giá hàng bán', N'Sale price reduction', NULL, N'G07', N'G0704', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Devaluation of sale price')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Giảm giá hàng bán',
    Notes1 = N'Sale price reduction',
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0704',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Devaluation of sale price'
WHERE AccountID = N'5212'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'5213')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'5213', N'Hàng bán bị trả lại', NULL, NULL, N'G07', N'G0704', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Sale returns')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Hàng bán bị trả lại',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G07',
    SubGroupID = N'G0704',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Sale returns'
WHERE AccountID = N'5213'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'821')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'821', N'Chi phí thuế thu nhập doanh nghiệp', NULL, NULL, N'G99', N'G9901', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Business Income tax charge')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí thuế thu nhập doanh nghiệp',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9901',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Business Income tax charge'
WHERE AccountID = N'821'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'8211')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'8211', N'Chi phí thuế TNDN hiện hành', NULL, NULL, N'G99', N'G9901', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Current business income tax charge')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí thuế TNDN hiện hành',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9901',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Current business income tax charge'
WHERE AccountID = N'8211'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'8212')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'8212', N'Chi phí thuế TNDN hoãn lại', NULL, NULL, N'G99', N'G9901', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Deferred business income tax charge')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí thuế TNDN hoãn lại',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9901',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Deferred business income tax charge'
WHERE AccountID = N'8212'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'911')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'911', N'Xác định kết quả SXKD', N'Determination of business results', NULL, N'G99', N'G9902', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Evaluation of business results')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Xác định kết quả SXKD',
    Notes1 = N'Determination of business results',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9902',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Evaluation of business results'
WHERE AccountID = N'911'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'154')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'154', N'Chi phí sản xuất, kinh doanh dở dang', N'Costs of unfinished production, business', NULL, N'G99', N'G9903', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Goods in process')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chi phí sản xuất, kinh doanh dở dang',
    Notes1 = N'Costs of unfinished production, business',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9903',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Goods in process'
WHERE AccountID = N'154'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'411')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'411', N'Vốn đầu tư của chủ sở hữu', N'Working capital', NULL, N'G99', N'G9904', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Business capital sources')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Vốn đầu tư của chủ sở hữu',
    Notes1 = N'Working capital',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9904',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Business capital sources'
WHERE AccountID = N'411'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'4111')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'4111', N'Vốn đầu tư của chủ sở hữu', NULL, NULL, N'G99', N'G9904', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Charter equity')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Vốn đầu tư của chủ sở hữu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9904',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Charter equity'
WHERE AccountID = N'4111'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'41111')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'41111', N'Cổ phiếu phổ thông có quyền biểu quyết', NULL, NULL, N'G99', N'G9904', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Cổ phiếu phổ thông có quyền biểu quyết',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9904',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'41111'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'41112')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'41112', N'Cổ phiếu ưu đãi', NULL, NULL, N'G99', N'G9904', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Cổ phiếu ưu đãi',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9904',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'41112'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'4112')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'4112', N'Thặng dư vốn cổ phần', NULL, NULL, N'G99', N'G9904', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Surplus equity')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Thặng dư vốn cổ phần',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9904',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Surplus equity'
WHERE AccountID = N'4112'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'4113')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'4113', N'Quyền chọn chuyển đổi trái phiếu', NULL, NULL, N'G99', N'G9904', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', NULL)
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quyền chọn chuyển đổi trái phiếu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9904',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = NULL
WHERE AccountID = N'4113'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'4118')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'4118', N'Vốn khác', NULL, NULL, N'G99', N'G9904', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other capital')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Vốn khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9904',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other capital'
WHERE AccountID = N'4118'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'412')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'412', N'Chênh lệch đánh giá lại tài sản', N'Difference resulting from asset re-evaluation', NULL, N'G99', N'G9905', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Differences upon asset revaluation')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chênh lệch đánh giá lại tài sản',
    Notes1 = N'Difference resulting from asset re-evaluation',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9905',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Differences upon asset revaluation'
WHERE AccountID = N'412'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'413')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'413', N'Chênh lệch tỷ giá hối đoái', NULL, NULL, N'G99', N'G9906', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Foreign Exchange difference')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chênh lệch tỷ giá hối đoái',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9905',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Foreign Exchange difference'
WHERE AccountID = N'413'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'4131')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'4131', N'Chênh lệch tỷ giá do đánh giá lại các khoản mục tiền tệ có gốc ngoại tệ', NULL, NULL, N'G99', N'G9906', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Foreign exchange differences revaluation at the end final year')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chênh lệch tỷ giá do đánh giá lại các khoản mục tiền tệ có gốc ngoại tệ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9906',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Foreign exchange differences revaluation at the end final year'
WHERE AccountID = N'4131'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'4132')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'4132', N'Chênh lệch tỷ giá hối đoái trong giai đoạn trước hoạt động', NULL, NULL, N'G99', N'G9906', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Foreign exchange differences incurred during capital construction period')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Chênh lệch tỷ giá hối đoái trong giai đoạn trước hoạt động',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9906',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Foreign exchange differences incurred during capital construction period'
WHERE AccountID = N'4132'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'414')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'414', N'Quỹ đầu tư phát triển', NULL, NULL, N'G99', N'G9907', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Investment and development funds')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quỹ đầu tư phát triển',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9907',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Investment and development funds'
WHERE AccountID = N'414'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'417')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'417', N'Quỹ hỗ trợ sắp xếp doanh nghiệp', NULL, NULL, N'G99', N'G9908', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Supporting equitization of state-owned companies')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Quỹ hỗ trợ sắp xếp doanh nghiệp',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9908',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Supporting equitization of state-owned companies'
WHERE AccountID = N'417'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'418')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'418', N'Các quỹ khác thuộc vốn chủ sở hữu', NULL, NULL, N'G99', N'G9909', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other funds')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Các quỹ khác thuộc vốn chủ sở hữu',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9909',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other funds'
WHERE AccountID = N'418'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'419')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'419', N'Cổ phiếu quỹ', NULL, NULL, N'G99', N'G9910', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Stock funds')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Cổ phiếu quỹ',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9910',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Stock funds'
WHERE AccountID = N'419'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'421')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'421', N'Lợi nhuận sau thuế chưa phân phối', N'Profits not yet distributed', NULL, N'G99', N'G9911', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Undistributed earnings')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Lợi nhuận sau thuế chưa phân phối',
    Notes1 = N'Profits not yet distributed',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9911',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Undistributed earnings'
WHERE AccountID = N'421'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'4211')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'4211', N'Lợi nhuận sau thuế chưa phân phối năm trước', NULL, NULL, N'G99', N'G9911', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Previous year undistributed earnings')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Lợi nhuận sau thuế chưa phân phối năm trước',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9911',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Previous year undistributed earnings'
WHERE AccountID = N'4211'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'4212')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'4212', N'Lợi nhuận sau thuế chưa phân phối năm nay', NULL, NULL, N'G99', N'G9911', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Current year undistributed earnings')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Lợi nhuận sau thuế chưa phân phối năm nay',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9911',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Current year undistributed earnings'
WHERE AccountID = N'4212'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'441')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'441', N'Nguồn vốn đầu tư xây dựng cơ bản', N'Investment capital sources for capital construction', NULL, N'G99', N'G9912', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Construction investment fund')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Nguồn vốn đầu tư xây dựng cơ bản',
    Notes1 = N'Investment capital sources for capital construction',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9912',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Construction investment fund'
WHERE AccountID = N'441'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'461')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'461', N'Nguồn kinh phí sự nghiệp', N'Public-service funding sources', NULL, N'G99', N'G9913', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Budget resources')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Nguồn kinh phí sự nghiệp',
    Notes1 = N'Public-service funding sources',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9913',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Budget resources'
WHERE AccountID = N'461'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'4611')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'4611', N'Nguồn kinh phí sự nghiệp năm trước', NULL, NULL, N'G99', N'G9913', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Previous year budget resources')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Nguồn kinh phí sự nghiệp năm trước',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9913',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Previous year budget resources'
WHERE AccountID = N'4611'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'4612')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'4612', N'Nguồn kinh phí sự nghiệp năm nay', NULL, NULL, N'G99', N'G9913', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Current year budget resources')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Nguồn kinh phí sự nghiệp năm nay',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9913',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Current year budget resources'
WHERE AccountID = N'4612'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'466')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'466', N'Nguồn kinh phí đã hình thành TSCĐ', N'Funding sources already used for formulation of fixed assets', NULL, N'G99', N'G9914', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Budget resources used to acquire fixed assets')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Nguồn kinh phí đã hình thành TSCĐ',
    Notes1 = N'Funding sources already used for formulation of fixed assets',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9914',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Budget resources used to acquire fixed assets'
WHERE AccountID = N'466'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'151')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'151', N'Hàng mua đang đi trên đường', N'Purchased goods being en route', NULL, N'G99', N'G9915', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Purchased goods in transit')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Hàng mua đang đi trên đường',
    Notes1 = N'Purchased goods being en route',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9915',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Purchased goods in transit'
WHERE AccountID = N'151'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'221')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'221', N'Đầu tư vào công ty con', NULL, NULL, N'G99', N'G9916', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Investment in equity of subsidiaries')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Đầu tư vào công ty con',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9916',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Investment in equity of subsidiaries'
WHERE AccountID = N'221'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'222')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'222', N'Đầu tư vào công ty liên doanh, liên kết', N'Capital contribution to joint ventures', NULL, N'G99', N'G9917', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Joint venture capital contribution')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Đầu tư vào công ty liên doanh, liên kết',
    Notes1 = N'Capital contribution to joint ventures',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9917',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Joint venture capital contribution'
WHERE AccountID = N'222'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'228')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'228', N'Đầu tư khác', NULL, NULL, N'G99', N'G9918', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other investments')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Đầu tư khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9918',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other investments'
WHERE AccountID = N'001'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2281')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2281', N'Đầu tư góp vốn vào đơn vị khác', NULL, NULL, N'G99', N'G9918', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Stocks')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Đầu tư góp vốn vào đơn vị khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9918',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Stocks'
WHERE AccountID = N'2281'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2288')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2288', N'Đầu tư khác', NULL, NULL, N'G99', N'G9918', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Other investments')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Đầu tư khác',
    Notes1 = NULL,
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9918',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Other investments'
WHERE AccountID = N'2288'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'229')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'229', N'Dự phòng tổn thất tài sản', N'Investment price reduction reserves', NULL, N'G99', N'G9919', 0, 0, 0, 1, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Provision for devaluation of investments')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Dự phòng tổn thất tài sản',
    Notes1 = N'Investment price reduction reserves',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9919',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 1,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Provision for devaluation of investments'
WHERE AccountID = N'229'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2291')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2291', N'Dự phòng giảm giá chứng khoán kinh doanh', N'Short-term investment price reduction reserve', NULL, N'G99', N'G9919', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Provision for devaluation of short-term investment')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Dự phòng giảm giá chứng khoán kinh doanh',
    Notes1 = N'Short-term investment price reduction reserve',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9919',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Provision for devaluation of short-term investment'
WHERE AccountID = N'2291'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2292')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2292', N'Dự phòng tổn thất đầu từ vào đơn vị khác', N'Long-term investment price reduction reserves', NULL, N'G99', N'G9919', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Provision for devaluation of long-term investments')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Dự phòng tổn thất đầu từ vào đơn vị khác',
    Notes1 = N'Long-term investment price reduction reserves',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9919',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Provision for devaluation of long-term investments'
WHERE AccountID = N'2292'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2293')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2293', N'Dự phòng phải thu khó đòi', N'Bad debt reserves', NULL, N'G99', N'G9919', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Provision for bad debts')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Dự phòng phải thu khó đòi',
    Notes1 = N'Bad debt reserves',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9919',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Provision for bad debts'
WHERE AccountID = N'2293'
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE AccountID = N'2294')
INSERT INTO AT1005STD(AccountID, AccountName, Notes1, Notes2, GroupID, SubGroupID,
            IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled], CreateDate,
            CreateUserID, LastModifyDate, LastModifyUserID, AccountNameE) 
VALUES ( N'2294', N'Dự phòng giảm giá hàng tồn kho', N'Stock goods price reduction reserves', NULL, N'G99', N'G9919', 0, 0, 0, 0, 0, GETDATE(), N'ASOFTADMIN', GETDATE(), N'ASOFTADMIN', N'Provision for devaluation of inventory')
ELSE
UPDATE AT1005STD SET 
	AccountName = N'Dự phòng giảm giá hàng tồn kho',
    Notes1 = N'Stock goods price reduction reserves',
    Notes2 = NULL,
    GroupID = N'G99',
    SubGroupID = N'G9919',
    IsBalance = 0,
    IsDebitBalance = 0,
    IsObject = 0,
    IsNotShow = 0,
    [Disabled] = 0,
    LastModifyDate = GETDATE(),
    LastModifyUserID = N'ASOFTADMIN',
    AccountNameE = N'Provision for devaluation of inventory'
WHERE AccountID = N'2294'
---- Update dữ liệu vào AT1005 theo [200/2014/TT-BTC]
DECLARE @OCur CURSOR,
	    @DivisionID NVARCHAR(50),
	    @UserID NVARCHAR(50),
	    @AccountID NVARCHAR(50),
	    @AccountName NVARCHAR(250),
		@Notes1 NVARCHAR(250),
		@Notes2 NVARCHAR(250),
		@GroupID NVARCHAR(50),
		@SubGroupID NVARCHAR(50),
		@IsBalance TINYINT,
		@IsDebitBalance TINYINT,
		@IsObject TINYINT,
		@IsNotShow TINYINT,
		@Disabled TINYINT,
	    @AccountNameE NVARCHAR(250),
	    @IsCommon TINYINT

SET @OCUR = CURSOR SCROLL KEYSET FOR 
SELECT AT11.DivisionID, AT15STD.AccountID, AT15STD.AccountName, AT15STD.Notes1, AT15STD.Notes2, AT15STD.GroupID, 
	   AT15STD.SubGroupID, AT15STD.IsBalance, AT15STD.IsDebitBalance, AT15STD.IsObject, AT15STD.IsNotShow, 
	   AT15STD.[Disabled], AT15STD.CreateUserID AS UserID, AT15STD.AccountNameE, 0 AS IsCommon
FROM AT1005STD AT15STD, (SELECT DISTINCT AT11.DivisionID FROM AT1101 AT11) AT11
OPEN @OCur
FETCH NEXT FROM @OCur INTO @DivisionID, @AccountID, @AccountName, @Notes1, @Notes2, @GroupID, @SubGroupID, 
@IsBalance, @IsDebitBalance, @IsObject, @IsNotShow, @Disabled, @UserID, @AccountNameE, @IsCommon  
WHILE @@FETCH_STATUS = 0
BEGIN 
	IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005 WHERE DivisionID = @DivisionID AND AccountID = @AccountID) 
	INSERT INTO AT1005 (DivisionID, AccountID, AccountName, Notes1, Notes2, GroupID,
				SubGroupID, IsBalance, IsDebitBalance, IsObject, IsNotShow, [Disabled],
				CreateDate, CreateUserID, LastModifyDate, LastModifyUserID,
				AccountNameE, IsCommon)
	VALUES(@DivisionID,@AccountID,@AccountName,@Notes1,@Notes2,@GroupID,@SubGroupID,@IsBalance, @IsDebitBalance,
		   @IsObject,@IsNotShow,@Disabled,GETDATE(),@UserID,GETDATE(),@UserID,@AccountNameE,@IsCommon)
	ELSE 
		UPDATE AT1005 SET 
			AccountName = @AccountName,
			Notes1 = @Notes1,
			Notes2 = @Notes2,
			GroupID = @GroupID,
			SubGroupID = @SubGroupID,
			IsBalance = @IsBalance,
			IsDebitBalance = @IsDebitBalance,
			IsObject = @IsObject,
			IsNotShow = @IsNotShow,
			[Disabled] = @Disabled,
			LastModifyDate = GETDATE(),
			LastModifyUserID = @UserID,
			AccountNameE = @AccountNameE,
			IsCommon = @IsCommon
		WHERE DivisionID = @DivisionID AND AccountID = @AccountID
FETCH NEXT FROM @OCur INTO @DivisionID, @AccountID, @AccountName, @Notes1, @Notes2, @GroupID, @SubGroupID, 
@IsBalance, @IsDebitBalance, @IsObject, @IsNotShow, @Disabled, @UserID, @AccountNameE, @IsCommon 
END   
CLOSE @OCur                         
---- Phân quyền dữ liệu bằng AP1406 với @ModuleID=N'',@DataType='AC',@Status='A'
DECLARE @Cur CURSOR,
		@ModuleID NVARCHAR(50), 
		@DataID NVARCHAR(50), 
		@DataName NVARCHAR(250), 
		@DataType CHAR(2), 
		@Date DATETIME,  
		@Status CHAR(1)
SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT DivisionID, N'' AS ModuleID, AccountID AS DataID, AccountName AS DataName, 'AC' AS DataType, GETDATE() AS [Date], CreateUserID AS UserID, 'A' AS Status, IsCommon
FROM AT1005
OPEN @Cur
FETCH NEXT FROM @Cur INTO @DivisionID, @ModuleID, @DataID, @DataName, @DataType, @Date, @UserID, @Status, @IsCommon
WHILE @@FETCH_STATUS = 0
BEGIN
--- Thực hiện phân quyền dữ liệu AP1406 với Status = 'A' - thêm mới hoặc 'E' - cập nhật
IF NOT EXISTS(SELECT TOP 1 1 FROM AT1005STD WHERE  AccountID = @DataID )
	EXEC AP1406 @DivisionID = @DivisionID, @ModuleID = @ModuleID, @DataID = @DataID, @DataName= @DataName,@DataType= @DataType,@Date = @Date,@UserID = @UserID,@Status = 'A',@IsCommon = @IsCommon
ELSE 
	EXEC AP1406 @DivisionID = @DivisionID, @ModuleID = @ModuleID, @DataID = @DataID, @DataName= @DataName,@DataType= @DataType,@Date = @Date,@UserID = @UserID,@Status = 'E',@IsCommon = @IsCommon
FETCH NEXT FROM @Cur INTO @DivisionID, @ModuleID, @DataID, @DataName, @DataType, @Date, @UserID, @Status, @IsCommon
END
CLOSE @Cur
END