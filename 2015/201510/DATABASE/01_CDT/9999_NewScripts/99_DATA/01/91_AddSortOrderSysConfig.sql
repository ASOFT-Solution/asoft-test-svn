USE [CDT]

declare @sysTableID int,
		@Key varchar(128),
		@SortOrder int

select @sysTableID = sysTableID from sysTable
where TableName = 'sysConfig'

-- 1) Add column
if not exists (select top 1 1 from sysField where FieldName = N'SortOrder' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 5, N'SortOrder', N'Thứ tự hiển thị', N'Sort order', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 2) Update data
--set @Key = 'NamLamViec'
--set @SortOrder = 1
--Update sysConfig set SortOrder = @SortOrder
--where IsFormatString is null and IsUser = 1 and StartConfig = 0
--and _Key = @Key

DECLARE @sysConfig TABLE (
	_KeyOrder int IDENTITY(1,1),
     _Key [NVARCHAR](128) NOT NULL
     )

-- Insert theo thứ tự
-- Customize from here

Insert into @sysConfig(_Key) values ('NamLamViec')
Insert into @sysConfig(_Key) values ('NgayKhoaSo')
Insert into @sysConfig(_Key) values ('DiaChi')
Insert into @sysConfig(_Key) values ('QuanHuyen')
Insert into @sysConfig(_Key) values ('TinhThanh')
Insert into @sysConfig(_Key) values ('KeToanTruong')
Insert into @sysConfig(_Key) values ('GiamDoc')
Insert into @sysConfig(_Key) values ('NguoiLap')
Insert into @sysConfig(_Key) values ('DienThoai')
Insert into @sysConfig(_Key) values ('Fax')
Insert into @sysConfig(_Key) values ('Email')
Insert into @sysConfig(_Key) values ('SoTK')
Insert into @sysConfig(_Key) values ('TenNH')
Insert into @sysConfig(_Key) values ('ChiNhanhNH')
Insert into @sysConfig(_Key) values ('DonViTinhQD')
Insert into @sysConfig(_Key) values ('XuatAm')
Insert into @sysConfig(_Key) values ('TenDaiLyThue')
Insert into @sysConfig(_Key) values ('MSTDLThue')
Insert into @sysConfig(_Key) values ('DienThoaiDL')
Insert into @sysConfig(_Key) values ('EmailDL')
Insert into @sysConfig(_Key) values ('FaxDL')
Insert into @sysConfig(_Key) values ('AddressTA')
Insert into @sysConfig(_Key) values ('QuanHuyenDL')
Insert into @sysConfig(_Key) values ('TinhThanhDL')
Insert into @sysConfig(_Key) values ('HDDLThueSo')
Insert into @sysConfig(_Key) values ('NgayHDDL')
Insert into @sysConfig(_Key) values ('NVDLThue')
Insert into @sysConfig(_Key) values ('CCHNThue')

-- End here

declare cur_Config cursor for select _KeyOrder, _Key from @sysConfig order by _KeyOrder

open cur_Config 
fetch cur_Config into @SortOrder, @Key

while @@FETCH_STATUS = 0
BEGIN

Update sysConfig set SortOrder = @SortOrder
where IsFormatString is null and IsUser = 1
and _Key = @Key

fetch cur_Config into @SortOrder, @Key
END

close cur_Config
deallocate cur_Config