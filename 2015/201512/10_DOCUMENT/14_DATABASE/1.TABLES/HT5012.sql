-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT5012]') AND type in (N'U'))
CREATE TABLE [dbo].[HT5012](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PayrollMethodID] [nvarchar](50) NOT NULL,
	[TimesID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_HT5012] PRIMARY KEY NONCLUSTERED 
(
	[PayrollMethodID] ASC,
	[TimesID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
