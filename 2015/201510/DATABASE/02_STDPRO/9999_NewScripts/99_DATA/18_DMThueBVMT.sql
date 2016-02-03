--10
if not exists(select * from [DMThueBVMT] where [TaxID] = 010101)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('010101',N'Thu từ xăng sản xuất trong nước','010101',NULL,1000,N'Lít',NULL,0)
--11
if not exists(select * from [DMThueBVMT] where [TaxID] = 010102)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('010102',N'Thu từ nhiên liệu bay sản xuất trong nước','010102',NULL,1000,N'Lít',NULL,0)
--12
if not exists(select * from [DMThueBVMT] where [TaxID] = 010103)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('010103',N'Thu từ dầu diezel sản xuất trong nước','010103',NULL,500,N'Lít',NULL,0)
--13
if not exists(select * from [DMThueBVMT] where [TaxID] = 010104)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('010104',N'Thu từ dầu hỏa sản xuất trong nước','010104',NULL,300,N'Lít',NULL,0)
--14
if not exists(select * from [DMThueBVMT] where [TaxID] = 010105)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('010105',N'Thu từ dầu mazut sản xuất trong nước','010105',NULL,300,N'Lít',NULL,0)
--15
if not exists(select * from [DMThueBVMT] where [TaxID] = 010201)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('010201',N'Than nâu','010201',NULL,10000,N'Tấn',NULL,0)
--16
if not exists(select * from [DMThueBVMT] where [TaxID] = 010202)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('010202',N'Than an - tra - xít (antraxit)','010202',NULL,20000,N'Tấn',NULL,0)
--17
if not exists(select * from [DMThueBVMT] where [TaxID] = 010203)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('010203',N'Than mỡ','010203',NULL,10000,N'Tấn',NULL,0)
--18
if not exists(select * from [DMThueBVMT] where [TaxID] = 010204)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('010204',N'Than đá khác','010204',NULL,10000,N'Tấn',NULL,0)
--19
if not exists(select * from [DMThueBVMT] where [TaxID] = 0103)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('0103',N'Thu từ dung dịch Hydro-chloro-fluoro-carbon (HCFC) sản xuất trong nước','0103',NULL,4000,N'Kg',NULL,0)
--20
if not exists(select * from [DMThueBVMT] where [TaxID] = 0104)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('0104',N'Thu từ túi ni lông sản xuất trong nước','0104',NULL,40000,N'Kg',NULL,0)
--21
if not exists(select * from [DMThueBVMT] where [TaxID] = 0105)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('0105',N'Thu từ thuốc diệt cỏ sản xuất trong nước','0105',NULL,500,N'Kg',NULL,0)
--22
if not exists(select * from [DMThueBVMT] where [TaxID] = 0106)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('0106',N'Thu từ các sản phẩm hàng hóa khác sản xuất trong nước','0106',NULL,1000,N'Kg',NULL,0)
--23
if not exists(select * from [DMThueBVMT] where [TaxID] = 020101)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020101',N'Thu từ xăng nhập khẩu','020101',NULL,1000,N'Lít',NULL,0)
--24
if not exists(select * from [DMThueBVMT] where [TaxID] = 020102)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020102',N'Thu từ nhiên liệu bay nhập khẩu','020102',NULL,1000,N'Lít',NULL,0)
--25
if not exists(select * from [DMThueBVMT] where [TaxID] = 020103)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020103',N'Thu từ dầu Diezel nhập khẩu','020103',NULL,500,N'Lít',NULL,0)
--26
if not exists(select * from [DMThueBVMT] where [TaxID] = 020104)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020104',N'Thu từ dầu hỏa nhập khẩu','020104',NULL,300,N'Lít',NULL,0)
--27
if not exists(select * from [DMThueBVMT] where [TaxID] = 020105)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020105',N'Thu từ dầu mazut nhập khẩu','020107',NULL,300,N'Lít',NULL,0)
--28
if not exists(select * from [DMThueBVMT] where [TaxID] = 020201)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020201',N'Than nâu nhập khẩu','020201',NULL,10000,N'Tấn',NULL,0)
--29
if not exists(select * from [DMThueBVMT] where [TaxID] = 020202)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020202',N'Than an - tra - xít (antraxit) nhập khẩu','020202',NULL,20000,N'Tấn',NULL,0)
--30
if not exists(select * from [DMThueBVMT] where [TaxID] = 020203)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020203',N'Than mỡ nhập khẩu','020203',NULL,10000,N'Tấn',NULL,0)
--31
if not exists(select * from [DMThueBVMT] where [TaxID] = 020204)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020204',N'Than đá nhập khẩu khác ','020204',NULL,10000,N'Tấn',NULL,0)
--32
if not exists(select * from [DMThueBVMT] where [TaxID] = 0203)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('0203',N'Thu từ dung dịch hydro, chloro, fluoro, carbon nhập khẩu','0203',NULL,4000,N'Kg',NULL,0)
--33
if not exists(select * from [DMThueBVMT] where [TaxID] = 0204)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('0204',N'Thu từ túi ni lông nhập khẩu','0204',NULL,40000,N'Kg',NULL,0)
--34
if not exists(select * from [DMThueBVMT] where [TaxID] = 0205)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('0205',N'Thu từ thuốc diệt cỏ nhập khẩu','0205',NULL,500,N'Kg',NULL,0)
--35
if not exists(select * from [DMThueBVMT] where [TaxID] = 0206)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('0206',N'Thu từ các sản phẩm, hàng hóa nhập khẩu khác','0206',NULL,1000,N'Kg',NULL,0)
--36
if not exists(select * from [DMThueBVMT] where [TaxID] = 010106)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('010106',N'Thu từ dầu nhờn sản xuất trong nước','010106',NULL,300,N'Lít',NULL,0)
--37
if not exists(select * from [DMThueBVMT] where [TaxID] = 010107)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
	VALUES('010107',N'Thu từ mỡ nhờn sản xuất trong nước','010107',NULL,300,N'Kg',NULL,0)
--38
if not exists(select * from [DMThueBVMT] where [TaxID] = 020106)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020106',N'Thu từ dầu nhờn nhập khẩu','020106',NULL,300,N'Lít',NULL,0)
--39
if not exists(select * from [DMThueBVMT] where [TaxID] = 020107)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020107',N'Thu từ mỡ nhờn nhập khẩu','020107',NULL,300,N'Kg',NULL,0)
--40
if not exists(select * from [DMThueBVMT] where [TaxID] = 020111)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020111',N'Thu từ xăng nhập khẩu để bán trong nước','020111',NULL,1000,N'Lít',NULL,0)
--41
if not exists(select * from [DMThueBVMT] where [TaxID] = 020112)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020112',N'Thu từ nhiên liệu bay nhập khẩu để bán trong nước','020112',NULL,1000,N'Lít',NULL,0)
--42
if not exists(select * from [DMThueBVMT] where [TaxID] = 020113)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020113',N'Thu từ dầu Diezel nhập khẩu để bán trong nước','020113',NULL,500,N'Lít',NULL,0)
--43
if not exists(select * from [DMThueBVMT] where [TaxID] = 020114)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020114',N'Thu từ dầu hỏa nhập khẩu để bán trong nước','020114',NULL,300,N'Lít',NULL,0)
--44
if not exists(select * from [DMThueBVMT] where [TaxID] = 020115)
INSERT INTO [dbo].[DMThueBVMT]([TaxID],[TaxName],[TaxHTKK],[TaxName2],[TaxRate],[TaxUnit],[Notes],[Disabled])
     VALUES('020115',N'Thu từ dầu mazut, dầu mỡ nhờn nhập khẩu để bán trong nước','020115',NULL,300,N'Lít',NULL,0)







