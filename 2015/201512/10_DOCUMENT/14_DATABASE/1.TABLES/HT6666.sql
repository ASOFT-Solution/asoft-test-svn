-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT6666]') AND type in (N'U'))
CREATE TABLE [dbo].[HT6666](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PeriodID] [nvarchar](50) NOT NULL,
	[PeriodName] [nvarchar](50) NULL,
	[IsDefault] [tinyint] NOT NULL,
 CONSTRAINT [PK_HT6666] PRIMARY KEY CLUSTERED 
(
	[PeriodID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT6666_IsDefault]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT6666] ADD  CONSTRAINT [DF_HT6666_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
END