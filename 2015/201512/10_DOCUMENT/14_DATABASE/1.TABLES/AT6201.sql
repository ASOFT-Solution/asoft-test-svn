-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Thanh Nguyen
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT6201]') AND type in (N'U'))
CREATE TABLE [dbo].[AT6201](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[LineID] [nvarchar](50) NOT NULL,
	[LineCode] [nvarchar](50) NOT NULL,
	[LineDescription] [nvarchar](250) NULL,
	[AccountIDFrom] [nvarchar](50) NULL,
	[AccountIDTo] [nvarchar](50) NULL,
	[CorAccountIDFrom] [nvarchar](50) NULL,
	[CorAccountIDTo] [nvarchar](50) NULL,
	[LineType] [nvarchar](50) NULL,
	[BreakDetail] [tinyint] NULL,
	[AmountSign] [tinyint] NULL,
	[AccuSign] [nvarchar](5) NULL,
	[Accumulator] [nvarchar](100) NULL,
	[Accumulator1] [nvarchar](100) NULL,
	[Accumulator2] [nvarchar](100) NULL,
	[PrintStatus] [tinyint] NULL,
	[Type] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[IsAccount] [tinyint] NULL,
	[LevelID] [tinyint] NULL,
	[Sign] [nvarchar](5) NULL,
	CONSTRAINT [PK_AT6201] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

