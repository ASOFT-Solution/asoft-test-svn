-- <Summary>
---- Danh mục biểu thuế tiêu thụ đặc biệt
-- <History>
---- Create on 22/05/2015 by Lê Thị Hạnh 
DECLARE @Cur CURSOR,
	    @DivisionID NVARCHAR(50)
SET @Cur = CURSOR SCROLL KEYSET FOR
SELECT AT11.DivisionID 
FROM AT1101 AT11
OPEN @Cur
FETCH NEXT FROM @Cur INTO @DivisionID
WHILE @@FETCH_STATUS = 0
BEGIN
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'101')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'101',N'Thuốc lá điếu, xì gà và các chế phẩm từ cây thuốc lá',NULL,NULL,N'HH',NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10101')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10101',N'Xì gàBao ',N'Bao',65,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10102')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10102',N'Thuốc lá điếu ',N'Bao',65,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10103')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10103',N'Các chế phẩm khác từ cây thuốc lá ',NULL,65,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'102')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'102',N'Rượu',NULL,NULL,N'HH',NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10200')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10200',N'Rượu từ 20 độ trở lên ',N'Lít',50,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10203')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10203',N'Rượu dưới 20 độ, rượu hoa quả, rượu thuốc ',N'Lít',25,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10300')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10300',N'Bia',N'Lít',50,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104',N'Ô tô',NULL,NULL,N'HH',NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10404')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10404',N'Xe ô tô dưới 24 chỗ',NULL,NULL,N'HH',NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'1040401')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'1040401',N'Xe ô tô chở người từ 9 chỗ trở xuống',NULL,NULL,N'HH',NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040101')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040101',N'Loại có dung tích xi lanh từ 2.000 cm3 trở xuống',N'Cái',45,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040102')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040102',N'Loại có dung tích xi lanh trên 2.000 cm3 đến 3.000 cm3',N'Cái',50,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040103')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040103',N'Loại có dung tích xi lanh trên 3.000 cm3',N'Cái',60,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'1040402')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'1040402',N'Xe ô tô chở người từ 10 đến dưới 16 chỗ',N'Cái',30,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'1040403')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'1040403',N'Xe ô tô chở người từ 16 đến dưới 24 chỗ ngồi',N'Cái',15,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'1040404')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'1040404',N'Xe ô tô vừa chở người, vừa chở hàng',N'Cái',15,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'1040405')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'1040405',N'Xe ô tô chạy bằng xăng kết hợp năng lượng điện, năng lượng sinh học, trong đó tỷ trọng xăng sử dụng không quá 70% số năng lượng sử dụng',NULL,NULL,N'HH',NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040501')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040501',N'Xe ô tô từ 9 chỗ trở xuống',NULL,NULL,N'HH',NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10404050101')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10404050101',N'Loại có dung tích xi lanh từ 2.000 cm3 trở xuống',N'Cái',31.5,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10404050102')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10404050102',N'Loại có dung tích xi lanh trên 2.000 cm3 đến 3.000 cm3',N'Cái',35,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10404050103')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10404050103',N'Loại có dung tích xi lanh trên 3.000 cm3',N'Cái',42,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040502')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040502',N'Xe ô tô chở người từ 10 đến dưới 16 chỗ',N'Cái',21,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040503')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040503',N'Xe ô tô chở người từ 16 đến dưới 24 chỗ',N'Cái',10.5,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040504')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040504',N'Xe ô tô vừa chở người, vừa chở hàng',N'Cái',10.5,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'1040406')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'1040406',N'Xe ô tô chạy bằng năng lượng sinh học',NULL,NULL,N'HH',NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040601')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040601',N'Xe ô tô chở người từ 9 chỗ trở xuống',NULL,NULL,N'HH',NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10404060101')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10404060101',N'Loại có dung tích xi lanh từ 2.000 cm3 trở xuống',N'Cái',22.5,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10404060102')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10404060102',N'Loại có dung tích xi lanh trên 2.000 cm3 đến 3.000 cm3',N'Cái',25,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10404060103')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10404060103',N'Loại có dung tích xi lanh trên 3.000 cm3',N'Cái',30,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040602')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040602',N'Xe ô tô chở người từ 10 đến dưới 16 chỗ',N'Cái',15,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040603')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040603',N'Xe ô tô chở người từ 16 đến dưới 24 chỗ',N'Cái',7.5,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040604')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040604',N'Xe ô tô vừa chở người, vừa chở hàng',N'Cái',7.5,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'1040407')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'1040407',N'Xe ô tô chạy bằng điện',NULL,NULL,N'HH',NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040701')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040701',N'Loại chở người từ 9 chỗ trở xuống',N'Cái',25,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040702')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040702',N'Loại chở người từ 10 đến dưới 16 chỗ',N'Cái',15,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040703')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040703',N'Loại chở người từ 16 đến dưới 24 chỗ',N'Cái',10,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'104040704')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'104040704',N'Loại thiết kế vừa chở người, vừa chở hàng',N'Cái',10,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10900')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10900',N'Xe mô tô hai bánh, xe mô tô ba bánh có dung tích xi lanh trên 125 cm3',N'Cái',20,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'11000')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'11000',N'Tàu bay',N'Chiếc',30,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'11100')INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'11100',N'Du thuyền',N'Chiếc',30,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10500')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10500',N'Xăng các loại, nap-ta, chế phẩm tái hợp và các chế phẩm khác để pha chế ',N'Lít',10,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10600')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10600',N'Điều hoà nhiệt độ công suất từ 90.000 BTU trở xuống',N'Cái',10,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10700')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10700',N'Bài lá',NULL,40,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'10800')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10800',N'Vàng mã, hàng ',NULL,70,N'HH',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'20100')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'20100',N'Kinh doanh vũ trường, mát-xa, ka-ra-ô-kê',NULL,NULL,N'DV',NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'20101')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'20101',N'Kinh doanh vũ trường',NULL,40,N'DV',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'20102')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'20102',N'Kinh doanh mát-xa, ka-ra-ô-kê',NULL,30,N'DV',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'20200')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'20200',N'Kinh doanh ca-si-nô, trò chơi điện tử có thưởng',NULL,30,N'DV',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'20300')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'20300',N'Kinh doanh đặt cược',NULL,30,N'DV',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'20400')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'20400',N'Kinh doanh gôn',NULL,20,N'DV',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0136 WHERE DivisionID = @DivisionID AND SETID = N'20500')
INSERT INTO AT0136(DivisionID, SETID, SETName, UnitID, TaxRate, SETClassifyID,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'20500',N'Kinh doanh xổ số',NULL,15,N'DV',NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
FETCH NEXT FROM @Cur INTO @DivisionID
END
CLOSE @Cur