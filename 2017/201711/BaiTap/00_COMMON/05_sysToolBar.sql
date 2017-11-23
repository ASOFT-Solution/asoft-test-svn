
GO
SET IDENTITY_INSERT [dbo].[sysToolBar] ON 
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayDelete')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (1, N'DisplayDelete', N'DisplayDelete')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayDeleteDetail')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (2, N'DisplayDeleteDetail', N'DisplayDeleteDetail')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayAdd')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (3, N'DisplayAdd', N'DisplayAdd')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayEdit')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (4, N'DisplayEdit', N'DisplayEdit')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayPrint')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (5, N'DisplayPrint', N'DisplayPrint')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayExport')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (6, N'DisplayExport', N'DisplayExport')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayExportExcel')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (7, N'DisplayExportExcel', N'DisplayExportExcel')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayShow')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (8, N'DisplayShow', N'DisplayShow')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayHide')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (9, N'DisplayHide', N'DisplayHide')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayAddToCampaign')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (10, N'DisplayAddToCampaign', N'DisplayAddToCampaign')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplaySendEmail')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (11, N'DisplaySendEmail', N'DisplaySendEmail')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayExportF')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (12, N'DisplayExportF', N'DisplayExportF')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayImport')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (13, N'DisplayImport', N'DisplayImport')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplaySendDocVPL')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (14, N'DisplaySendDocVPL', N'DisplaySendDocVPL')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplaySendDocXR')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (15, N'DisplaySendDocXR', N'DisplaySendDocXR')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayClose')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (16, N'DisplayClose', N'DisplayClose')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayEmpToTeam')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (17, N'DisplayEmpToTeam', N'DisplayEmpToTeam')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayInherit')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (18, N'DisplayInherit', N'DisplayInherit')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayDeleteAll')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (19, N'DisplayDeleteAll', N'DisplayDeleteAll')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayImportBank')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (20, N'DisplayImportBank', N'DisplayImportBank')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayPrintCV')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (21, N'DisplayPrintCV', N'DisplayPrintCV')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayLockUser')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (22, N'DisplayLockUser', N'DisplayLockUser')
END
If not exists(select top 1 1 from [dbo].[sysToolBar] where [ToolBarID] = N'DisplayUnlockUser')
Begin
INSERT [dbo].[sysToolBar] ([sysToolBarID], [sysToolBarName], [ToolBarID]) VALUES (23, N'DisplayUnlockUser', N'DisplayUnlockUser')
END
SET IDENTITY_INSERT [dbo].[sysToolBar] OFF
