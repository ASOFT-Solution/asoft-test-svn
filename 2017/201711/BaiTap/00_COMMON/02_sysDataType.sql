
GO
SET IDENTITY_INSERT [dbo].[sysDataType] ON 
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'PK_APK')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (1, N'Khóa chính kiểu APK
', 17, N'PK_APK')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'PK_Int')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (2, N'Khóa chính tự tăng kiểu số nguyên
', 3, N'PK_Int')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'PK_String')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (3, N'Khóa chính kiểu chuỗi
', 14, N'PK_String')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'BigInt')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (4, N'Số nguyên lớn
', 7, N'BigInt')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'Int')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (5, N'Số nguyên
', 3, N'Int')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'TinyInt')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (6, N'Số nguyên nhỏ
', 1, N'TinyInt')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'String')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (7, N'Chuỗi kí tự
', 14, N'String')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'Decimal')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (8, N'Số thập phân
', 15, N'Decimal')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'Date')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (9, N'Ngày
', 16, N'Date')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'Bool')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (10, N'Luận lý
', 12, N'Bool')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'Time')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (11, N'Giờ
', 16, N'Time')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'Text')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (12, N'Đoạn văn
', 14, N'Text')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'DateTime')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (13, N'Ngày giờ
', 16, N'DateTime')
END
If not exists(select top 1 1 from [dbo].[sysDataType] where [DataTypeID] = N'Binary')
Begin
INSERT [dbo].[sysDataType] ([sysDataTypeID], [sysDataTypeName], [sysDataViewID], [DataTypeID]) VALUES (14, N'Images
', 18, N'Binary')
END
SET IDENTITY_INSERT [dbo].[sysDataType] OFF
GO