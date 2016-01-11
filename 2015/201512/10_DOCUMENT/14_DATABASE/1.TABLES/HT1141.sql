-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1141]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1141](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[MethodID] [nvarchar](50) NOT NULL,
	[Orders] [int] NOT NULL,
	[FromMonth] [int] NOT NULL,
	[ToMonth] [int] NOT NULL,
	[Coefficient] [decimal](28, 8) NOT NULL,
	CONSTRAINT [PK_HT1141] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]	

) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1141_Orders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1141] ADD  CONSTRAINT [DF_HT1141_Orders]  DEFAULT ((0)) FOR [Orders]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1141_FromMonth]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1141] ADD  CONSTRAINT [DF_HT1141_FromMonth]  DEFAULT ((0)) FOR [FromMonth]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1141_ToMonth]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1141] ADD  CONSTRAINT [DF_HT1141_ToMonth]  DEFAULT ((0)) FOR [ToMonth]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1141_Coefficient]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1141] ADD  CONSTRAINT [DF_HT1141_Coefficient]  DEFAULT ((1)) FOR [Coefficient]
END
