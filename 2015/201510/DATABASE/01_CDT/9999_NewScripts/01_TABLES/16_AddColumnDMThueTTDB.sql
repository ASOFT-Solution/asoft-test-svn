declare @sysTableID int
select  @sysTableID = sysTableID from sysTable where TableName = 'DMThueTTDB'
if not exists(select * from sysField where [FieldName] = N'MaHTKK' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'MaHTKK', 1, NULL, NULL, NULL, NULL, 2, N'Mã xuất XML qua HTKK', N'Code HTKK', 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
