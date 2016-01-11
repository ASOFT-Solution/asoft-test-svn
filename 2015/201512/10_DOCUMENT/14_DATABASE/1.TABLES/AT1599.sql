-- <Summary>
---- 
-- <History>
---- Create on 13/12/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1599]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1599](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[LineID] [nvarchar](50) NOT NULL,
	[ReportCode] [nvarchar](50) NULL,
	[LineDescription] [nvarchar](250) NULL,
	[AccountIDFrom] [nvarchar](50) NULL,
	[AccountIDTo] [nvarchar](50) NULL,
	[D_C] [tinyint] NULL,
	[Detail] [tinyint] NULL,
	[Method] [nvarchar](50) NULL,
	[TypeValues] [nvarchar](100) NULL,
	[Cause] [nvarchar](100) NULL,
	[Level1] [tinyint] NULL,
	[PrintStatus] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LineDescriptionE] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[Sign] [nvarchar](50) NOT NULL,
	[NowstatusID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1599] PRIMARY KEY CLUSTERED 
(
	[LineID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT1599__Sign__22A1D06D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1599] ADD  CONSTRAINT [DF__AT1599__Sign__22A1D06D]  DEFAULT ('+') FOR [Sign]
END