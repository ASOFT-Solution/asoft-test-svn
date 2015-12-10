use [CDT]
declare @sysSiteIDPRO as int
declare @sysSiteIDSTD as int
declare @DbName as varchar(50)
declare @sysSiteID as int

select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = N'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = N'STD'

declare curDbName CURSOR FOR
select DbName, sysSiteID from sysDatabase where DbName <> 'CDT'

open curDbName 
fetch curDbName into @DbName, @sysSiteID

while @@FETCH_STATUS = 0
BEGIN

-- PRO
if isnull(@sysSiteIDPRO,'') <> '' AND @sysSiteID = @sysSiteIDPRO
BEGIN
	if not exists (select top 1 1 from sysConfig where _Key = N'QuanHuyen' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'QuanHuyen', N'', 1, @sysSiteIDPRO, 0, N'Quận/Huyện', N'District', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'TinhThanh' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'TinhThanh', N'', 1, @sysSiteIDPRO, 0, N'Tỉnh/thành phố', N'City', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'DienThoai' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'DienThoai', N'', 1, @sysSiteIDPRO, 0, N'Điện thoại', N'Telephone', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'Fax' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'Fax', N'', 1, @sysSiteIDPRO, 0, N'Fax', N'Fax', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'Email' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'Email', N'', 1, @sysSiteIDPRO, 0, N'Email', N'Email', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'TenDaiLyThue' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'TenDaiLyThue', N'', 1, @sysSiteIDPRO, 0, N'Tên đại lý thuế', N'Tax Agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'MSTDLThue' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'MSTDLThue', N'', 1, @sysSiteIDPRO, 0, N'Mã số thuế đại lý', N'Tax number of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'DienThoaiDL' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'DienThoaiDL', N'', 1, @sysSiteIDPRO, 0, N'Điện thoại đại lý', N'Telephone of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'EmailDL' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'EmailDL', N'', 1, @sysSiteIDPRO, 0, N'Email đại lý', N'Email of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'FaxDL' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'FaxDL', N'', 1, @sysSiteIDPRO, 0, N'Fax đại lý', N'Fax of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'AddressTA' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'AddressTA', N'', 1, @sysSiteIDPRO, 0, N'Địa chỉ đại lý', N'Address of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'QuanHuyenDL' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'QuanHuyenDL', N'', 1, @sysSiteIDPRO, 0, N'Quận/Huyện đại lý', N'District of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'TinhThanhDL' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'TinhThanhDL', N'', 1, @sysSiteIDPRO, 0, N'Tỉnh/TP đại lý', N'City of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'HDDLThueSo' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'HDDLThueSo', N'', 1, @sysSiteIDPRO, 0, N'Hợp đồng đại lý thuế số', N'Tax contract number', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'NgayHDDL' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'NgayHDDL', N'', 1, @sysSiteIDPRO, 0, N'Ngày hợp đồng đại lý', N'Date of tax agent contract', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'NVDLThue' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'NVDLThue', N'', 1, @sysSiteIDPRO, 0, N'Nhân viên đại lý thuế', N'Tax Agent Employee', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'CCHNThue' and sysSiteID = @sysSiteIDPRO and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'CCHNThue', N'', 1, @sysSiteIDPRO, 0, N'Chứng chỉ hành nghề thuế', N'Certificate about Tax', @DbName)
END

-- STD
if isnull(@sysSiteIDSTD,'') <> '' AND @sysSiteID = @sysSiteIDSTD
BEGIN
	if not exists (select top 1 1 from sysConfig where _Key = N'QuanHuyen' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'QuanHuyen', N'', 1, @sysSiteIDSTD, 0, N'Quận/Huyện', N'District', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'TinhThanh' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'TinhThanh', N'', 1, @sysSiteIDSTD, 0, N'Tỉnh/thành phố', N'City', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'DienThoai' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'DienThoai', N'', 1, @sysSiteIDSTD, 0, N'Điện thoại', N'Telephone', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'Fax' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'Fax', N'', 1, @sysSiteIDSTD, 0, N'Fax', N'Fax', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'Email' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'Email', N'', 1, @sysSiteIDSTD, 0, N'Email', N'Email', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'TenDaiLyThue' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'TenDaiLyThue', N'', 1, @sysSiteIDSTD, 0, N'Tên đại lý thuế', N'Tax Agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'MSTDLThue' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'MSTDLThue', N'', 1, @sysSiteIDSTD, 0, N'Mã số thuế đại lý', N'Tax number of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'DienThoaiDL' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'DienThoaiDL', N'', 1, @sysSiteIDSTD, 0, N'Điện thoại đại lý', N'Telephone of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'EmailDL' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'EmailDL', N'', 1, @sysSiteIDSTD, 0, N'Email đại lý', N'Email of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'FaxDL' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'FaxDL', N'', 1, @sysSiteIDSTD, 0, N'Fax đại lý', N'Fax of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'AddressTA' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'AddressTA', N'', 1, @sysSiteIDSTD, 0, N'Địa chỉ đại lý', N'Address of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'QuanHuyenDL' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'QuanHuyenDL', N'', 1, @sysSiteIDSTD, 0, N'Quận/Huyện đại lý', N'District of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'TinhThanhDL' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'TinhThanhDL', N'', 1, @sysSiteIDSTD, 0, N'Tỉnh/TP đại lý', N'City of tax agent', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'HDDLThueSo' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'HDDLThueSo', N'', 1, @sysSiteIDSTD, 0, N'Hợp đồng đại lý thuế số', N'Tax contract number', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'NgayHDDL' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'NgayHDDL', N'', 1, @sysSiteIDSTD, 0, N'Ngày hợp đồng đại lý', N'Date of tax agent contract', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'NVDLThue' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'NVDLThue', N'', 1, @sysSiteIDSTD, 0, N'Nhân viên đại lý thuế', N'Tax Agent Employee', @DbName)
	
	if not exists (select top 1 1 from sysConfig where _Key = N'CCHNThue' and sysSiteID = @sysSiteIDSTD and DbName = @DbName)
	INSERT [dbo].[sysConfig] ([_Key], [_Value], [IsUser], [sysSiteID], [StartConfig], [DienGiai], [DienGiai2], [DbName]) 
	VALUES (N'CCHNThue', N'', 1, @sysSiteIDSTD, 0, N'Chứng chỉ hành nghề thuế', N'Certificate about Tax', @DbName)
END

fetch curDbName into @DbName, @sysSiteID
END

close curDbName
deallocate curDbName