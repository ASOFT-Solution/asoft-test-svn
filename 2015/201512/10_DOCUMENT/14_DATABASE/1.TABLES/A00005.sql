-- <Summary>
---- 
-- <History>
---- Create on 22/12/2010 by Vĩnh Phong
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[A00005]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[A00005](
	[APK] [varbinary](16) NOT NULL,
	[DivisionID] [nvarchar](3) NULL,
	[DivisionName] [nvarchar](250) NULL,
	[Address] [nvarchar](250) NULL,
	[TaxCode] [nvarchar](50) NULL,
	[ContracNo] [nvarchar](50) NULL,
	[RegistDate] [datetime] NULL,
 CONSTRAINT [PK_A00005_1] PRIMARY KEY CLUSTERED 
(
	[APK] ASC
) ON [PRIMARY]
) 
END
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_A00005_APK_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[A00005] ADD  CONSTRAINT [DF_A00005_APK_1]  DEFAULT (newid()) FOR [APK]
END

