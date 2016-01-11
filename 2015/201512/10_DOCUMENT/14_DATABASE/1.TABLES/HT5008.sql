-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT5008]') AND type in (N'U'))
CREATE TABLE [dbo].[HT5008](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[GeneralIncomeID] [nvarchar](50) NOT NULL,
	[IncomeID] [nvarchar](50) NOT NULL,
	[Orders] [tinyint] NOT NULL,
 CONSTRAINT [PK_HT5008] PRIMARY KEY CLUSTERED 
(
	[GeneralIncomeID] ASC,
	[IncomeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT5008_Orders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5008] ADD  CONSTRAINT [DF_HT5008_Orders]  DEFAULT ((0)) FOR [Orders]
END