Use CDT
declare @sysTableID int
Select @sysTableID = sysTableID FROM sysTable WHERE TableName = N'DToKhaiTTDB'
IF NOT EXISTS (SELECT * FROM [dbo].[sysField] WHERE [FieldName] = N'TaxCheck')
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) VALUES (@sysTableID, N'TaxCheck', 1, NULL, NULL, NULL, NULL, 10, N'Không phát sinh giá trị tính thuế TTDB trong kỳ', N'Tax Check', 6, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)
