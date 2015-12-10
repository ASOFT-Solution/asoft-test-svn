use [CDT]

declare @sysTableID int,
		@sysFieldID int,
		@sysTableBLID int

--1) Hóa đơn mua hàng kiêm phiếu nhập kho
select @sysTableID = sysTableID from sysTable
where TableName = 'MT22'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTCT' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTCT', N'Số chứng từ chi', N'Payment voucher number', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'MaThue'

Update sysField set TabIndex = 19
where sysFieldID = @sysFieldID and TabIndex = 18

-- Update sysDataConfig
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'

-- PNM1
Update sysDataConfig set Condition = N'TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'PNM1' and Condition is null

-- PNM2
Update sysDataConfig set Condition = N'TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'PNM2' and Condition is null

-- PNM3
Update sysDataConfig set Condition = N'(Tthue<>0) and TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'PNM3' and Condition = N'(Tthue<>0)'

-- PNM4
Update sysDataConfig set Condition = N'(Tthue<>0) and TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'PNM4' and Condition = N'(Tthue<>0)'

--2) Hóa đơn nhập khẩu kiêm phiếu nhập kho
select @sysTableID = sysTableID from sysTable
where TableName = 'MT23'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTCT' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTCT', N'Số chứng từ chi', N'Payment voucher number', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'HanTT'

Update sysField set TabIndex = 19
where sysFieldID = @sysFieldID and TabIndex = 18

-- Update sysDataConfig
-- PNK1
Update sysDataConfig set Condition = N'TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'PNK1' and Condition is null

-- PNK2
Update sysDataConfig set Condition = N'TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'PNK2' and Condition is null

--3) Hóa đơn giảm giá, hàng bán trả lại
select @sysTableID = sysTableID from sysTable
where TableName = 'MT33'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTCT' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTCT', N'Số chứng từ chi', N'Payment voucher number', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'MaThue'

Update sysField set TabIndex = 19
where sysFieldID = @sysFieldID and TabIndex = 18

-- Update sysDataConfig
-- HTL1
Update sysDataConfig set Condition = N'TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'HTL1' and Condition is null

-- HTL2
Update sysDataConfig set Condition = N'TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'HTL2' and Condition is null

-- HTL5
Update sysDataConfig set Condition = N'(Tthue<>0) And TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'HTL5' and Condition = N'(Tthue<>0)'

-- HTL6
Update sysDataConfig set Condition = N'(Tthue<>0) And TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'HTL6' and Condition = N'(Tthue<>0)'

--4) Hóa đơn mua dịch vụ
select @sysTableID = sysTableID from sysTable
where TableName = 'MT21'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTCT' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTCT', N'Số chứng từ chi', N'Payment voucher number', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'MaThue'

Update sysField set TabIndex = 19
where sysFieldID = @sysFieldID and TabIndex = 18

-- Update sysDataConfig
-- MDV1
Update sysDataConfig set Condition = N'TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'MDV1' and isnull(Condition,'') = ''

-- MDV2
Update sysDataConfig set Condition = N'TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'MDV2' and isnull(Condition,'') = ''

-- MDV3
Update sysDataConfig set Condition = N'(TThue<>0) And TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'MDV3' and Condition = N'(TThue<>0)'

-- MDV4
Update sysDataConfig set Condition = N'(TThue<>0) And TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'MDV4' and Condition = N'(TThue<>0)'

--5) Chứng từ chi phí mua hàng
select @sysTableID = sysTableID from sysTable
where TableName = 'MT25'

if not exists (select top 1 1 from sysField where FieldName = N'SoCTCT' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'SoCTCT', N'Số chứng từ chi', N'Payment voucher number', 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'MaThue'

Update sysField set TabIndex = 19
where sysFieldID = @sysFieldID and TabIndex = 18

-- Update sysDataConfig
-- MCP1
Update sysDataConfig set Condition = N'TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'MCP1' and isnull(Condition,'') = ''

-- MCP2
Update sysDataConfig set Condition = N'TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'MCP2' and isnull(Condition,'') = ''

-- MCP3
Update sysDataConfig set Condition = N'TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'MCP3' and isnull(Condition,'') = ''

-- MCP4
Update sysDataConfig set Condition = N'TKCo not like ''11%'''
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'MCP4' and isnull(Condition,'') = ''

-- Fix bug
declare @TthueNT int
declare @PsNoNT int

select @TthueNT = sysFieldID from sysField 
where sysTableID = (select sysTableID from sysTable where TableName = 'MT25')
and FieldName = 'TthueNT'

select @PsNoNT = sysFieldID from sysField where sysTableID = @sysTableBLID and FieldName = 'PsNoNT'

Update sysDataConfigDt set mtFieldID = @TthueNT
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'MCP3')
				and blFieldID = @PsNoNT and mtFieldID <> @TthueNT
-- End Fix bug

-- Dictionary
if not exists (select 1 from Dictionary where Content = N'Mã chứng từ đã tồn tại (bên phiếu chi). Vui lòng nhập mã mới!') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Mã chứng từ đã tồn tại (bên phiếu chi). Vui lòng nhập mã mới!', N'Voucher code already exists (Payable receipt). Please input another code!');
	
if not exists (select 1 from Dictionary where Content = N'Mã chứng từ đã tồn tại (bên Giấy báo nợ). Vui lòng nhập mã mới!') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Mã chứng từ đã tồn tại (bên Giấy báo nợ). Vui lòng nhập mã mới!', N'Voucher code already exists (Debit note receipt). Please input another code!');

if not exists (select 1 from Dictionary where Content = N'Bạn phải thao tác chứng từ bên Hóa đơn bán hàng kiêm phiếu xuất kho!') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Bạn phải thao tác chứng từ bên Hóa đơn bán hàng kiêm phiếu xuất kho!', N'You must operate this voucher in Selling invoice!');	

if not exists (select 1 from Dictionary where Content = N'Bạn phải thao tác chứng từ bên Hóa đơn dịch vụ!') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Bạn phải thao tác chứng từ bên Hóa đơn dịch vụ!', N'You must operate this voucher in Service invoice!');	

if not exists (select 1 from Dictionary where Content = N'Bạn phải thao tác chứng từ bên Chứng từ trả hàng kiêm phiếu xuất kho!') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Bạn phải thao tác chứng từ bên Chứng từ trả hàng kiêm phiếu xuất kho!', N'You must operate this voucher in Delivering Receipt of return goods!');	
		
if not exists (select 1 from Dictionary where Content = N'Bạn phải thao tác chứng từ bên Hóa đơn mua hàng kiêm phiếu nhập kho!') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Bạn phải thao tác chứng từ bên Hóa đơn mua hàng kiêm phiếu nhập kho!', N'You must operate this voucher in Receipt of buying goods!');	

if not exists (select 1 from Dictionary where Content = N'Bạn phải thao tác chứng từ bên Hóa đơn nhập khẩu kiêm phiếu nhập kho!') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Bạn phải thao tác chứng từ bên Hóa đơn nhập khẩu kiêm phiếu nhập kho!', N'You must operate this voucher in Receipt of import goods!');	

if not exists (select 1 from Dictionary where Content = N'Bạn phải thao tác chứng từ bên Hóa đơn giảm giá, hàng bán trả lại!') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Bạn phải thao tác chứng từ bên Hóa đơn giảm giá, hàng bán trả lại!', N'You must operate this voucher in Receipt of storing from return goods!');	

if not exists (select 1 from Dictionary where Content = N'Bạn phải thao tác chứng từ bên Hóa đơn mua dịch vụ!') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Bạn phải thao tác chứng từ bên Hóa đơn mua dịch vụ!', N'You must operate this voucher in Buying service invoice!');	

if not exists (select 1 from Dictionary where Content = N'Bạn phải thao tác chứng từ bên Chứng từ chi phí mua hàng!') 
	INSERT INTO Dictionary (Content, Content2) VALUES (N'Bạn phải thao tác chứng từ bên Chứng từ chi phí mua hàng!', N'You must operate this voucher in Purchasing expense receipt!');	