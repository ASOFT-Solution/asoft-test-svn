
GO
SET IDENTITY_INSERT [dbo].[sysCategoryBusiness] ON 
If not exists(select top 1 1 from [dbo].[sysCategoryBusiness] where [CategoryBusinessID] = N'List')
Begin
INSERT [dbo].[sysCategoryBusiness] ([sysCategoryBusiness], [sysNameCategoryBusiness], [CategoryBusinessID]) VALUES (1, N'Danh Mục', N'List')
End
If not exists(select top 1 1 from [dbo].[sysCategoryBusiness] where [CategoryBusinessID] = N'List')
Begin
INSERT [dbo].[sysCategoryBusiness] ([sysCategoryBusiness], [sysNameCategoryBusiness], [CategoryBusinessID]) VALUES (2, N'Nghiệp Vụ', N'Bussiness')
End
SET IDENTITY_INSERT [dbo].[sysCategoryBusiness] OFF
