USE [CDT]
declare @sysTableID int,
		@ListTypeID int

-- 1) Insert ListType data
if not exists (select 1 from ListType where ListType = N'Tài khoản')
	Insert into ListType(ListType,ListType2) values (N'Tài khoản',N'Account')
	
if not exists (select 1 from ListType where ListType = N'Nhân viên')
	Insert into ListType(ListType,ListType2) values (N'Nhân viên',N'Employees')
	
if not exists (select 1 from ListType where ListType = N'Khách hàng')
	Insert into ListType(ListType,ListType2) values (N'Khách hàng',N'Customer')
	
if not exists (select 1 from ListType where ListType = N'Nhà cung cấp')
	Insert into ListType(ListType,ListType2) values (N'Nhà cung cấp',N'Supplier')
	
if not exists (select 1 from ListType where ListType = N'Vật tư hàng hóa')
	Insert into ListType(ListType,ListType2) values (N'Vật tư hàng hóa',N'Items')
	
if not exists (select 1 from ListType where ListType = N'Thuế')
	Insert into ListType(ListType,ListType2) values (N'Thuế',N'Tax')

-- 2) Tạo cấu trúc table ListType trong CDT
if not exists (select top 1 1 from sysTable where TableName = 'ListType')
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES (N'ListType', N'Nhóm danh mục', NULL, N'ListTypeID', NULL, NULL, 2, NULL, NULL, 1, NULL, 5, NULL, 0)

select @sysTableID = sysTableID from sysTable where TableName = 'ListType'

if not exists (select top 1 1 from sysField where FieldName = 'ListTypeID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ListTypeID', 0, NULL, NULL, NULL, NULL, 3, N'ListTypeID', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ListType' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ListType', 0, NULL, NULL, NULL, NULL, 2, N'Nhóm danh mục', N'List type', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ListType2' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ListType2', 0, NULL, NULL, NULL, NULL, 2, N'Nhóm danh mục 2', N'List type 2', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 3) Thêm cột ListType trong sysMenu

select @sysTableID = sysTableID from sysTable where TableName = 'sysMenu'

if not exists (select top 1 1 from sysField where FieldName = 'ListType' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ListType', 1, N'ListTypeID', N'ListType', N'ListType', NULL, 4, N'Nhóm danh mục', N'List type', 14, NULL, NULL, NULL, NULL, NULL, N'Nhóm danh mục để nhóm trên menu top', NULL, 1, 0, 0, 0, 1, N'FK_sysMenu_ListType', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'ListTypeOrder' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ListTypeOrder', 1, NULL, NULL, NULL, NULL, 5, N'Thứ tự trong nhóm danh mục', N'List type order', 15, NULL, NULL, NULL, NULL, NULL, N'Thứ tự trong nhóm danh mục trên menu top', NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

-- 4) Update số liệu trong sysMenu

-- Nhóm Tài khoản
select @ListTypeID = ListTypeID from ListType where ListType = N'Tài khoản'

if @ListTypeID is not null
BEGIN
	Update sysMenu set ListType = @ListTypeID
	where MenuName = N'Tài khoản' and UIType = 1 and ListType is null
	
	Update sysMenu set ListType = @ListTypeID
	where MenuName = N'Kết chuyển' and UIType = 1 and ListType is null
END

-- Nhóm Nhân viên
select @ListTypeID = ListTypeID from ListType where ListType = N'Nhân viên'

if @ListTypeID is not null
BEGIN
	Update sysMenu set ListType = @ListTypeID
	where MenuName = N'Nhóm nhân viên' and UIType = 1 and ListType is null
	
	Update sysMenu set ListType = @ListTypeID
	where MenuName = N'Nhân viên' and UIType = 1 and ListType is null
END

-- Nhóm Khách hàng
select @ListTypeID = ListTypeID from ListType where ListType = N'Khách hàng'

if @ListTypeID is not null
BEGIN
	Update sysMenu set ListType = @ListTypeID
	where MenuName = N'Nhóm khách hàng' and UIType = 1 and ListType is null
	
	Update sysMenu set ListType = @ListTypeID
	where MenuName = N'Khách hàng' and UIType = 1 and ListType is null
END

-- Nhóm Nhà cung cấp
select @ListTypeID = ListTypeID from ListType where ListType = N'Nhà cung cấp'

if @ListTypeID is not null
BEGIN
	Update sysMenu set ListType = @ListTypeID
	where MenuName = N'Nhóm nhà cung cấp' and UIType = 1 and ListType is null
	
	Update sysMenu set ListType = @ListTypeID
	where MenuName = N'Nhà cung cấp' and UIType = 1 and ListType is null
END

-- Nhóm Vật tư hàng hóa
select @ListTypeID = ListTypeID from ListType where ListType = N'Vật tư hàng hóa'

if @ListTypeID is not null
BEGIN
	Update sysMenu set ListType = @ListTypeID
	where MenuName = N'Vật tư hàng hóa' and UIType = 1 and ListType is null
	
	Update sysMenu set ListType = @ListTypeID
	where MenuName = N'Vật tư lắp ráp, tháo dỡ' and UIType = 1 and ListType is null
END

-- Nhóm Thuế
select @ListTypeID = ListTypeID from ListType where ListType = N'Thuế'

if @ListTypeID is not null
BEGIN
	Update sysMenu set ListType = @ListTypeID
	where MenuName = N'Thuế suất' and UIType = 1 and ListType is null
	
	Update sysMenu set ListType = @ListTypeID
	where MenuName = N'Nhóm thuế TTDB' and UIType = 1 and ListType is null
END

-- Thứ tự nhóm danh mục
Update sysMenu set ListTypeOrder = 1
where MenuName = N'Tài khoản' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 20
where MenuName = N'Kết chuyển' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 30
where MenuName = N'Ngoại tệ' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 40
where MenuName = N'Bộ phận' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 50
where MenuName = N'Nhóm nhân viên' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 60
where MenuName = N'Nhân viên' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 70
where MenuName = N'Nhóm khách hàng' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 80
where MenuName = N'Khách hàng' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 90
where MenuName = N'Nhóm nhà cung cấp' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 100
where MenuName = N'Nhà cung cấp' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 110
where MenuName = N'Kho hàng' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 120
where MenuName = N'Nhóm vật tư' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 130
where MenuName = N'Đơn vị tính' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 140
where MenuName = N'Vật tư hàng hóa' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 160
where MenuName = N'Vật tư lắp ráp, tháo dỡ' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 170
where MenuName = N'Đơn vị tính quy đổi' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 180
where MenuName = N'Vụ Việc' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 190
where MenuName = N'Khoản mục phí' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 200
where MenuName = N'Công trình' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 210
where MenuName = N'Nhóm tài sản cố định' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 220
where MenuName = N'Phân bổ' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 230
where MenuName = N'Thuế suất' and UIType = 1 and ListTypeOrder is null

Update sysMenu set ListTypeOrder = 240
where MenuName = N'Nhóm thuế TTDB' and UIType = 1 and ListTypeOrder is null

select * from sysMenu
where UITYPE = 1
and ListTypeOrder is null