use [CDT]

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sodutaikhoanthuongNt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sodutaikhoanthuongNt]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sops]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sops]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sodutaikhoanCn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sodutaikhoanCn]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sodutaikhoanCnNt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sodutaikhoanCnNt]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sopsKetChuyen]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sopsKetChuyen]
GO
