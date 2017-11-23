
GO
SET IDENTITY_INSERT [dbo].[sysFieldType] ON 
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'TextBox')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (1, N'TextBox', N'TextBox')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'CheckBox')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (2, N'CheckBox', N'CheckBox')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'ComboBox')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (3, N'ComboBox', N'ComboBox')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'ComboCheckList')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (4, N'ComboCheckList', N'ComboCheckList')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'DateTimePicker')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (5, N'DateTimePicker', N'DateTimePicker')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'SpecialControl')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (6, N'SpecialControl', N'SpecialControl')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'LongDateTimePicker')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (7, N'LongDateTimePicker', N'LongDateTimePicker')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'Uploader')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (8, N'Uploader', N'Uploader')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'RadioButton')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (9, N'RadioButton', N'RadioButton')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'AutoComplete')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (10, N'AutoComplete', N'AutoComplete')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'TimePicker')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (11, N'TimePicker', N'TimePicker')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'Spinner')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (12, N'Spinner', N'Spinner')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'TextArea')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (13, N'TextArea', N'TextArea')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'StarVote')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (14, N'StarVote', N'StarVote')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'ComboBoxMultiSelect')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (15, N'ComboBoxMultiSelect', N'ComboBoxMultiSelect')
END
If not exists(select top 1 1 from [dbo].[sysFieldType] where [FieldTypeID] = N'SelectObject')
Begin
INSERT [dbo].[sysFieldType] ([sysFieldTypeID], [sysFieldTypeName], [FieldTypeID]) VALUES (16, N'SelectObject', N'SelectObject')
END

SET IDENTITY_INSERT [dbo].[sysFieldType] OFF
