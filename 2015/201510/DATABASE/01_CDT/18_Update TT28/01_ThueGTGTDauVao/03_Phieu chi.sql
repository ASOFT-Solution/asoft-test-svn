use [CDT]

declare @sysTableID as int

select @sysTableID = sysTableID from sysTable
where TableName = 'VATIn'

-- Change caption
Update sysField set LabelName = N'Ngày HT VAT', LabelName2 = N'Post date'
where sysTableID = @sysTableID
and FieldName = 'NgayCt'

Update sysField set LabelName = N'Tên vật tư', LabelName2 = N'Material name'
where sysTableID = @sysTableID
and FieldName = 'DienGiai'

-- Cot LoaiThue va LoaiHD
Update sysField set RefField = 'MaLoaiThue', RefTable = 'DMLThue', Type = 1, RefName = 'FK_VATIn_DMLThue', DefaultName = NULL, MinValue = NULL, MaxValue = NULL, DefaultValue = NULL
where sysTableID = @sysTableID
and FieldName = 'Type'

if not exists (select top 1 1 from [sysField] where [sysTableID] = @sysTableID and FieldName = 'MaLoaiHD')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'MaLoaiHD', 0, N'MaLoaiHD', N'DMLHD', NULL, NULL, 1, N'Loại hóa đơn', N'Invoice type', 27, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_VATIn_DMLHD', NULL, NULL, 0, NULL)
