use [CDT]

declare @sysTable as int

-- Số dư NTXT
select @sysTable = sysTableID from sysTable where TableName = 'OBNTXT' and sysPackageID = 8

Update sysField set DisplayMember = 'TenVT'
where [sysTableID] = @sysTable and FieldName = 'MaVT' and DisplayMember is null

if not exists (select top 1 1 from sysField where FieldName = 'TKkho' and sysTableID = @sysTable)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTable, N'TKkho', 0, NULL, NULL, NULL, NULL, 2, N'Tài khoản kho', N'Inventory account', 6, NULL, N'MaVT.TKkho', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

Update sysField set [TabIndex] = 7
where [sysTableID] = @sysTable and FieldName = 'SoLuong'

Update sysField set [TabIndex] = 8
where [sysTableID] = @sysTable and FieldName = 'DuDau'

Update sysField set [TabIndex] = 9
where [sysTableID] = @sysTable and FieldName = 'DuDauNT'

-- Số dư BQCK
select @sysTable = sysTableID from sysTable where TableName = 'OBVT' and sysPackageID = 8

Update sysField set DisplayMember = 'TenVT'
where [sysTableID] = @sysTable and FieldName = 'MaVT' and DisplayMember is null

if not exists (select top 1 1 from sysField where FieldName = 'TKkho' and sysTableID = @sysTable)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTable, N'TKkho', 0, NULL, NULL, NULL, NULL, 2, N'Tài khoản kho', N'Inventory account', 4, NULL, N'MaVT.TKkho', NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)

Update sysField set [TabIndex] = 5
where [sysTableID] = @sysTable and FieldName = 'SoLuong'

Update sysField set [TabIndex] = 6
where [sysTableID] = @sysTable and FieldName = 'DuDau'

Update sysField set [TabIndex] = 7
where [sysTableID] = @sysTable and FieldName = 'DuDauNT'

-- OBTK
select @sysTable = sysTableID from sysTable where TableName = 'OBTK' and sysPackageID = 8

if not exists (select top 1 1 from sysField where FieldName = 'TrangThaiVT' and sysTableID = @sysTable)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTable, N'TrangThaiVT', 0, NULL, NULL, NULL, NULL, 10, N'Trạng thái vật tư', N'Inventory status', 11, NULL, NULL, NULL, NULL, N'0', N'0: trạng thái không phải số dư vật tư; 1: trạng thái nhập số dư vật tư', NULL, 0, 0, 0, 0, 0, NULL, N'df_obtk_TrangThaiVT', NULL, 0, NULL)

if not exists (select top 1 1 from Dictionary where Content = N'Số dư tài khoản này được nhập bên số dư tồn kho. Bạn không được chỉnh sửa!')
	insert into Dictionary(Content, Content2) Values (N'Số dư tài khoản này được nhập bên số dư tồn kho. Bạn không được chỉnh sửa!',N'The balance of this account is entered the inventory balance. You may not edit!')
	
