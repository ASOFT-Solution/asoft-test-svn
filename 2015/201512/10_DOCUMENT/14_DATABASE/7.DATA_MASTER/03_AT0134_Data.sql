-- <Summary>
---- Danh mục biểu thuế tài nguyên
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
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'01')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'01',N'Khoáng sản kim loại',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0101')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0101',N'Khoáng sản kim loại đen',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010101')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010101',N'Sắt',N'Kg',12,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010102')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010102',N'Măng-gan',N'Kg',11,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010103')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010103',N'Ti-tan (titan)',N'Kg',16,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0102')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0102',N'Khoáng sản kim loại màu',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010201')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010201',N'Đất hiếm',N'Kg',15,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010202')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010202',N'Vàng',N'Kg',15,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010203')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010203',N'Bạch kim',N'Kg',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010204')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010204',N'Bạc, thiếc',N'Kg',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010205')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010205',N'Thiếc',N'Kg',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010206')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010206',N'Vôn-phờ-ram (wolfram), ăng-ti-moan (antimoan)',N'Kg',18,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010207')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010207',N'Chì, kẽm',N'Kg',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010208')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010208',N'Nhôm, bô-xít (bouxite)',N'Kg',12,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010209')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010209',N'Đồng',N'Kg',13,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010210')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010210',N'Ni-ken (niken)',N'Kg',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'010211')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'010211',N'Cô-ban (coban), mô-lip-đen (molipden), thủy ngân, ma-nhê (magie), va-na-đi (vanadi)',N'Kg',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0103')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0103',N'Khoáng sản kim loại khác',N'Kg',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'02')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'02',N'Khoáng sản không kim loại',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0201')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0201',N'Khoáng sản không kim loại dùng làm VLXD thông thường',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020101')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020101',N'Đất khai thác để san lấp, xây dựng công trình',N'M3',4,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020102')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020102',N'Đá, sỏi',N'M3',7,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020103')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020103',N'Đá nung vôi và sản xuất xi măng',N'M3',7,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020104')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020104',N'Đá hoa trắng',N'M3',9,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020105')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020105',N'Cát',N'M3',11,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020106')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020106',N'Cát làm thủy tinh',N'M3',13,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020107')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020107',N'Đất làm gạch',N'M3',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0202')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0202',N'Khoáng sản không kim loại dùng làm VLXD cao cấp',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020201')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020201',N'Gờ-ra-nít (granite)',N'M3',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020202')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020202',N'Sét chịu lửa',N'M3',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020203')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020203',N'Đô-lô-mít (dolomite), quắc-zít (quartzite)',N'M3',12,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0203')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0203',N'Khoáng sản không kim loại dùng trong SXCN',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020301')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020301',N'Cao lanh',N'M3',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020302')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020302',N'Mi-ca (mica), thạch anh kỹ thuật',N'M3',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020303')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020303',N'Pi-rít (pirite), phốt-pho-rít (phosphorite)',N'M3',7,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020304')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020304',N'A-pa-tít (apatit)',N'M3',5,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'020305')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'020305',N'Séc-păng-tin (secpentin)',N'M3',3,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'03')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'03',N'Than',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0301')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0301',N'Than an-tra-xít (antraxit) hầm lò',N'Tấn',7,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0302')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0302',N'Than an-tra-xít (antraxit) lộ thiên',N'Tấn',9,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0303')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0303',N'Than nâu, than mỡ',N'Tấn',9,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0304')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0304',N'Than khác',N'Tấn',7,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'04')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'04',N'Đá quý',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0401')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0401',N'Kim cương, ru-bi (rubi), sa-phia (sapphire)',N'M3',22,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0402')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0402',N'E-mô-rốt (emerald), a-lếch-xan-đờ-rít (alexandrite), ô-pan (opan) quý màu đen',N'M3',20,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0403')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0403',N'Adít, rô-đô-lít (rodolite), py-rốp (pyrope), bê-rin (berin), sờ-pi-nen (spinen), tô-paz (topaz)',N'M3',15,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0404')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0404',N'Thạch anh tinh thể màu tím xanh, vàng lục, da cam; cờ-ri-ô-lít (cryolite); ô-pan (opan) quý màu trắng, đỏ lửa; phen-sờ-phát (fenspat); birusa; nê-phờ-rít (nefrite)',N'M3',15,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0405')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0405',N'Khoáng sản không kim loại khác',N'M3',5,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'05')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'05',N'Sản phẩm cửa rừng tự nhiên',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0501')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0501',N'Gỗ tròn các loại',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'050101')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'050101',N'Gỗ nhóm I',N'M3',35,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'050102')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'050102',N'Gỗ nhóm II',N'M3',30,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'050103')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'050103',N'Gỗ nhóm III, IV',N'M3',20,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'050104')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'050104',N'Gỗ nhóm V, VI, VII, VIII và các loại gỗ khác',N'M3',15,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0502')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0502',N'Gỗ cành, ngọn, củi',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'050201')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'050201',N'Cành, ngọn, gốc, rễ',N'M3',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'050202')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'050202',N'Củi',N'M3',5,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0503')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0503',N'Tre, trúc, nứa, mai, giang, tranh, vầu, lồ ô',N'M3',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0504')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0504',N'Dược liệu',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'050401')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'050401',N'Trầm hương, kỳ nam',N'Kg',25,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'050402')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'050402',N'Hồi, quế, sa nhân, thảo quả',N'Kg',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0505')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0505',N'Sản phẩm khác của rừng tự nhiên',N'Kg',5,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'06')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'06',N'Hải sản tự nhiên',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0601')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0601',N'Ngọc trai, bào ngư, hải sâm',N'Kg',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0602')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0602',N'Hải sản tự nhiên khác',N'Kg',2,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'07')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'07',N'Nước thiên nhiên',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0701')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0701',N'Nước khoáng thiên nhiên, nước nóng thiên nhiên, nước thiên nhiên tinh lọc đóng chai, đóng hộp',N'M3',8,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0702')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0702',N'Nước thiên nhiên dùng cho sản xuất thủy điện',N'KWh',4,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0703')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0703',N'Nước thiên nhiên dùng cho sản xuất, kinh doanh, trừ nước quy định tại điểm 1 và điểm 2 nhóm này',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'070301')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'070301',N'Nước mặt',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'07030101')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'07030101',N'Nước dùng cho sản xuất nước sạch',N'M3',1,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'07030102')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'07030102',N'Nước dùng cho mục đích khác',N'M3',3,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'070302')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'070302',N'Nước dưới đất',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'07030201')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'07030201',N'Nước dùng cho sản xuất nước sạch (Nước dưới đất)',N'M3',3,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'07030202')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'07030202',N'Nước dùng cho mục đích khác (Nước dưới đất)',N'M3',5,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'08')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'08',N'Dầu thô',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0801')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0801',N'Dầu thô đối với DAKKĐT',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'080101')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'080101',N'Sản lượng đến 20.000 thùng/ngày',N'Tấn',7,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'080102')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'080102',N'Sản lượng trên 20.000 thùng đến 50.000 thùng/ngày',N'Tấn',9,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'080103')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'080103',N'Sản lượng trên 50.000 thùng đến 75.000 thùng/ngày',N'Tấn',11,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'080104')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'080104',N'Sản lượng trên 75.000 thùng đến 100.000 thùng/ngày',N'Tấn',13,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'080105')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'080105',N'Sản lượng trên 100.000 thùng đến 150.000 thùng/ngày',N'Tấn',18,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'080106')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'080106',N'Sản lượng trên 150.000 thùng/ngày',N'Tấn',23,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0802')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0802',N'Dầu thô đối với dự án khác',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'080201')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'080201',N'Sản lượng đến 20.000 thùng/ngày (đối với Dự án khác)',N'Tấn',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'080202')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'080202',N'Sản lượng trên 20.000 thùng đến 50.000 thùng/ngày (đối với Dự án khác)',N'Tấn',12,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'080203')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'080203',N'Sản lượng trên 50.000 thùng đến 75.000 thùng/ngày (đối với Dự án khác)',N'Tấn',14,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'080204')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'080204',N'Sản lượng trên 75.000 thùng đến 100.000 thùng/ngày (đối với Dự án khác)',N'Tấn',19,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'080205')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'080205',N'Sản lượng trên 100.000 thùng đến 150.000 (đối với Dự án khác)',N'Tấn',24,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'080206')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'080206',N'Sản lượng trên 150.000 thùng/ngày (đối với Dự án khác)',N'Tấn',29,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'09')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'09',N'Khí thiên nhiên, khí than',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0901')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0901',N'Khí thiên nhiên, khí than đối với DAKKĐT',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'090101')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'090101',N'Sản lượng đến 5 triệu m3/ngày',N'M3',1,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'090102')INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'090102',N'Sản lượng trên 5 triệu m3 đến 10 triệu m3/ngày',N'M3',3,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'090103')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'090103',N'Sản lượng trên 10 triệu m3/ngày',N'M3',6,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'0902')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'0902',N'Khí thuên nhiên, khí than (với mức thuế suất áp cho dự án khác)',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'090201')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'090201',N'Sản lượng đến 5 triệu m3/ngày (đối với Dự án khác)',N'M3',2,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'090202')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'090202',N'Sản lượng trên 5 triệu m3 đến 10 triệu m3/ngày (đối với Dự án khác)',N'M3',5,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'090203')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'090203',N'Sản lượng trên 10 triệu m3/ngày (đối với Dự án khác)',N'M3',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'10')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'10',N'Yến sào thiên nhiên',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'1001')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'1001',N'Yến sào thiên nhiên',N'Kg',20,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'11')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'11',N'Tài nguyên khác',NULL,NULL,NULL,1,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
IF NOT EXISTS (SELECT TOP 1 1 FROM AT0134 WHERE DivisionID = @DivisionID AND NRTClassifyID =N'1101')
INSERT INTO AT0134(DivisionID, NRTClassifyID, NRTClassifyName, UnitID, TaxRate,
            [Description], ChildRoot, [Disabled], CreateUserID, CreateDate,
            LastModifyUserID, LastModifyDate)
VALUES(@DivisionID,N'1101',N'Tài nguyên khác',N'Kg',10,NULL,0,0,'ASOFTADMIN',GETDATE(),'ASOFTADMIN',GETDATE())
FETCH NEXT FROM @Cur INTO @DivisionID
END
CLOSE @Cur