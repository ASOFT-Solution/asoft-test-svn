-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT5001]') AND type in (N'U'))
CREATE TABLE [dbo].[HT5001](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[GeneralCoID] [nvarchar](50) NOT NULL,
	[LineID] [tinyint] NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Sign] [nvarchar](50) NULL,
	[C01ID] [nvarchar](50) NULL,
	[C02ID] [nvarchar](50) NULL,
	[C03ID] [nvarchar](50) NULL,
	[C04ID] [nvarchar](50) NULL,
	[C05ID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT5001] PRIMARY KEY NONCLUSTERED 
(
	[GeneralCoID] ASC,
	[LineID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT5001_Disbled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT5001] ADD  CONSTRAINT [DF_HT5001_Disbled]  DEFAULT ((0)) FOR [Disabled]
END