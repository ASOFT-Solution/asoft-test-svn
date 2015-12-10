use [CDT]

declare @sysTableID as varchar(50)

-- Chiet khau chi tiet
select @sysTableID = sysTableID from sysTable 
where TableName = 'DT32'

if not exists (select top 1 1 from sysField where sysTableID = @sysTableID and FieldName = N'PCK')
INSERT [sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'PCK', 1, NULL, NULL, NULL, NULL, 8, N'% Chiết khấu', N'Amount Discount', 15, NULL, NULL, NULL, NULL, N'0', NULL, NULL, 1, 0, 0, 0, 1, NULL, N'DF_DT32_PSCK', N'### ### ### ##0.##', 0, NULL)

Update sysField set Formula = N'@PS*@PCK/100'
where sysTableID = @sysTableID
and FieldName = 'CK'
