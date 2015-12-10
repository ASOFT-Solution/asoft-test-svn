use [CDT]
declare @sysTableID as int

select @sysTableID = sysTableID from sysTable where TableName = 'sysDataConfig'

if not exists (select top 1 1 from sysField where FieldName = 'dt2TableID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'dt2TableID', 1, N'sysTableID', N'sysTable', N'TableName', NULL, 4, N'Bảng chi tiết 2', N'Bảng chi tiết 2 E', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, N'fk_blConfig_sysTable_dt2', NULL, NULL, 0, NULL)

-- sysDataConfig
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'sysDataConfig' AND col.name = 'dt2TableID')
    ALTER TABLE [dbo].[sysDataConfig] ADD [dt2TableID] int NULL 

select @sysTableID = sysTableID from sysTable where TableName = 'sysDataConfigDt'

if not exists (select top 1 1 from sysField where FieldName = 'dt2FieldID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'dt2FieldID', 1, N'sysFieldID', N'sysField', N'FieldName', NULL, 4, N'Trường bảng chi tiết 2', N'Trường bảng chi tiết 2 E', 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'fk_blConfigDetail_sysField22', NULL, NULL, 0, N'sysTableID = @dtTableID')

-- sysDataConfigDt
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'sysDataConfigDt' AND col.name = 'dt2FieldID')
Begin
    ALTER TABLE [dbo].[sysDataConfigDt] ADD [dt2FieldID] int NULL 
    
    ALTER TABLE [dbo].[sysDataConfigDt]  WITH CHECK ADD  CONSTRAINT [fk_blConfigDetail_sysField22] FOREIGN KEY([dt2FieldID])
	REFERENCES [dbo].[sysField] ([sysFieldID])

	ALTER TABLE [dbo].[sysDataConfigDt] CHECK CONSTRAINT [fk_blConfigDetail_sysField22]

End