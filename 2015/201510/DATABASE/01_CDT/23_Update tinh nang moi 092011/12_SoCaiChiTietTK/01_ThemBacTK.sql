use [CDT]

Declare @sysTableID int

select @sysTableID = sysTableID from sysTable
where TableName = 'DMTK'

if not exists (select top 1 1 from sysField where FieldName = 'GradeTK' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'GradeTK', 0, NULL, NULL, NULL, NULL, 5, N'Bậc tài khoản', N'Account Grade', 2, NULL, NULL, 6, 0, 1, N'1: Tài khoản cấp 1; 2: Tài khoản cấp 2; 3: Tài khoản cấp 3; 4: Tài khoản cấp 4; 5: Tài khoản cấp 5; 6: Tài khoản cấp 6', N'1: Account Grade 1; 2: Account Grade 2; 3: Account Grade 3; 4: Account Grade 4; 5: Account Grade 5; 6: Account Grade 6', 1, 0, 0, 0, 1, NULL, N'DF_DMTK_GradeTK', '#', 0, NULL)

-- Dictionary
if not exists (select top 1 1 from Dictionary where Content = N'Bậc tài khoản phải từ 1 đến 6')
	insert into Dictionary(Content, Content2) Values (N'Bậc tài khoản phải từ 1 đến 6',N'Account Grade must be between 1 and 6')
