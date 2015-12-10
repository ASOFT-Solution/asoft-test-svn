use [CDT]
Declare @sysTableID int,
		@sysFieldID int

select @sysTableID = sysTableID from sysTable
where TableName = 'DMThueSuat'

if not exists(select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = 'Stt')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'Stt', 0, NULL, NULL, NULL, NULL, 5, N'Số thứ tự', N'Order No.', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 1, NULL)


