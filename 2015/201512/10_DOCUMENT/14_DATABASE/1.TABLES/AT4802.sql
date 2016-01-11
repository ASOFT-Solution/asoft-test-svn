-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT4802]') AND type in (N'U'))
CREATE TABLE [dbo].[AT4802](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[ColumnID] [tinyint] NOT NULL,
	[Caption] [nvarchar](250) NULL,
	[AmountTypeID] [nvarchar](50) NULL,
	[CaculatorID] [nvarchar](50) NULL,
	[IsUsed] [tinyint] NULL,
 CONSTRAINT [PK_AT4802] PRIMARY KEY NONCLUSTERED 
(
	[ReportCode] ASC,
	[ColumnID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT4802_ColumnID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT4802] ADD  CONSTRAINT [DF_AT4802_ColumnID]  DEFAULT ((1)) FOR [ColumnID]
END
