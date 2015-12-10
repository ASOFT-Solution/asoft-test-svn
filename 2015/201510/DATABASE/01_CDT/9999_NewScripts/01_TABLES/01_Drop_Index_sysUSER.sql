USE [CDT]
GO

/****** Object:  Index [Idx_UserName]    Script Date: 02/21/2012 16:41:06 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[sysUser]') AND name = N'Idx_UserName')
DROP INDEX [Idx_UserName] ON [dbo].[sysUser] WITH ( ONLINE = OFF )
GO


