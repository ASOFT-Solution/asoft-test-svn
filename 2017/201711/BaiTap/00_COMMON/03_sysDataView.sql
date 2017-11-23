
GO
SET IDENTITY_INSERT [dbo].[sysDataView] ON 
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'byte')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (1, N'byte', N'byte')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'sbyte')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (2, N'sbyte', N'sbyte')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'int')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (3, N'int', N'int')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'uint')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (4, N'uint', N'uint')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'short')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (5, N'short', N'short')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'ushort')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (6, N'ushort', N'ushort')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'long')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (7, N'long', N'long')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'ulong')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (8, N'ulong', N'ulong')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'float')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (9, N'float', N'float')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'double')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (10, N'double', N'double')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'char')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (11, N'char', N'char')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'bool')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (12, N'bool', N'bool')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'object')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (13, N'object', N'object')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'string')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (14, N'string', N'string')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'decimal')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (15, N'decimal', N'decimal')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'datetime')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (16, N'datetime', N'datetime')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'GUID')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (17, N'GUID', N'GUID')
END
If not exists(select top 1 1 from [dbo].[sysDataView] where [DataViewID] = N'Binary')
Begin
INSERT [dbo].[sysDataView] ([sysDataViewID], [sysDataViewName], [DataViewID]) VALUES (18, N'Binary', N'Binary')
END
SET IDENTITY_INSERT [dbo].[sysDataView] OFF
