use [CDT]

declare @sysTableID int,
		@sysFieldID int,
		@sysTableBLID int

-- Hóa đơn bán hàng kiêm phiếm xuất kho
select @sysTableID = sysTableID from sysTable
where TableName = 'MT32'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTTT' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTTT', N'Số chứng từ thu', N'Received voucher number', 33, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'Saleman'

Update sysField set TabIndex = 34
where sysFieldID = @sysFieldID and TabIndex = 32

-- Fix bug
Update sysField set Visible = 1
where sysTableID IN (select sysTableID from sysTable where TableName IN ('VATOut','VATIn'))
and FieldName = 'MaLoaiHD' and Visible = 0
-- End fix bug

-- Update sysDataConfig
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'

-- HDB1
Update sysDataConfig set Condition = N'TKNo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'HDB1' and Condition is null

-- HDB2
Update sysDataConfig set Condition = N'TKNo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'HDB2' and Condition is null

-- Hóa đơn dịch vụ
select @sysTableID = sysTableID from sysTable
where TableName = 'MT31'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTTT' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTTT', N'Số chứng từ thu', N'Received voucher number', 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'DienGiai'

Update sysField set TabIndex = 15
where sysFieldID = @sysFieldID and TabIndex = 14

-- Update sysDataConfig
select @sysTableID = sysTableID from sysTable where TableName = 'MT31'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'

-- HDV1
Update sysDataConfig set Condition = N'TKNo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'HDV1' and Condition is null

-- HDV2
Update sysDataConfig set Condition = N'TKNo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'HDV2' and Condition is null

-- Chứng từ trả hàng kiêm phiếu xuất kho
select @sysTableID = sysTableID from sysTable
where TableName = 'MT24'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTTT' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTTT', N'Số chứng từ thu', N'Received voucher number', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'MaThue'

Update sysField set TabIndex = 19
where sysFieldID = @sysFieldID and TabIndex = 18

-- Update sysDataConfig
select @sysTableID = sysTableID from sysTable where TableName = 'MT24'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'

-- PXT1
Update sysDataConfig set Condition = N'TKNo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'PXT1' and Condition is null

-- PXT2
Update sysDataConfig set Condition = N'TKNo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'PXT2' and Condition is null

-- Dictionary
if not exists (select 1 from Dictionary where Content = N'Mã chứng từ đã tồn tại (bên phiếu thu). Vui lòng nhập mã mới!') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Mã chứng từ đã tồn tại (bên phiếu thu). Vui lòng nhập mã mới!', N'Voucher code already exists (Receiving receipt). Please input another code!');
	
if not exists (select 1 from Dictionary where Content = N'Mã chứng từ đã tồn tại (bên Giấy báo có). Vui lòng nhập mã mới!') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Mã chứng từ đã tồn tại (bên Giấy báo có). Vui lòng nhập mã mới!', N'Voucher code already exists (Credit note receipt). Please input another code!');

--select * from Dictionary
--where Content like N'%Phải nhập%'