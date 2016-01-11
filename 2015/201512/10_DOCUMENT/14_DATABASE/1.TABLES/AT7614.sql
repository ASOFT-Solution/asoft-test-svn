-- <Summary>
---- 
-- <History>
---- Create on 26/05/2015 by Bảo Anh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7614]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7614](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[LineCode] [nvarchar](50) NOT NULL,
	[LineDescription] [nvarchar](250) NULL,
	[PrintCode] [nvarchar](50) NULL,
	[MonthYear] [nvarchar](7) NULL,
	[Amount] [decimal](28, 8) NULL,
	[AccuSign] [nvarchar](5) NULL,
	[Accumulator] [nvarchar](100) NULL,
	[Level1] [tinyint] NULL,
	[PrintStatus] [tinyint] NULL,
	[LineDescriptionE] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[DisplayedMark] tinyint NULL default(0),
	[TypeID] [nvarchar](1) NULL,	--- trường nhận biết doanh thu hay chi phí
 CONSTRAINT [PK_AT7614] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7614_Amount]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7614] ADD  CONSTRAINT [DF_AT7614_Amount]  DEFAULT ((0)) FOR [Amount]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7614_PrintStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7614] ADD  CONSTRAINT [DF_AT7614_PrintStatus]  DEFAULT ((1)) FOR [PrintStatus]
END