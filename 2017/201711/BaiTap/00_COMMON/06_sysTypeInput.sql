
GO
SET IDENTITY_INSERT [dbo].[sysTypeInput] ON 
If not exists(select top 1 1 from [dbo].[sysTypeInput] where [TypeInputID] = N'InputNoDetail')
Begin
INSERT [dbo].[sysTypeInput] ([InputID], [InputName], [TypeInputID]) VALUES (1, N'Nhập Liệu Không Detail', N'InputNoDetail')
END
If not exists(select top 1 1 from [dbo].[sysTypeInput] where [TypeInputID] = N'InputMasterDetail')
Begin
INSERT [dbo].[sysTypeInput] ([InputID], [InputName], [TypeInputID]) VALUES (2, N'Nhập Liệu Master Datail', N'InputMasterDetail')
END
SET IDENTITY_INSERT [dbo].[sysTypeInput] OFF
