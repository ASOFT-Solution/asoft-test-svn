-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2411]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2411](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ID] [tinyint] NOT NULL,
	[T01] [nvarchar](50) NULL,
	[T02] [nvarchar](50) NULL,
	[T03] [nvarchar](50) NULL,
	[T04] [nvarchar](50) NULL,
	[T05] [nvarchar](50) NULL,
	[T06] [nvarchar](50) NULL,
	[T07] [nvarchar](50) NULL,
	[T08] [nvarchar](50) NULL,
	[T09] [nvarchar](50) NULL,
	[T10] [nvarchar](50) NULL,
	[T11] [nvarchar](50) NULL,
	[T12] [nvarchar](50) NULL,
	[T13] [nvarchar](50) NULL,
	[T14] [nvarchar](50) NULL,
	[T15] [nvarchar](50) NULL,
	[T16] [nvarchar](50) NULL,
	[T17] [nvarchar](50) NULL,
	[T18] [nvarchar](50) NULL,
	[T19] [nvarchar](50) NULL,
	[T20] [nvarchar](50) NULL,
	[T21] [nvarchar](50) NULL,
	[T22] [nvarchar](50) NULL,
	[T23] [nvarchar](50) NULL,
	[T24] [nvarchar](50) NULL,
	[T25] [nvarchar](50) NULL,
	[T26] [nvarchar](50) NULL,
	[T27] [nvarchar](50) NULL,
	[T28] [nvarchar](50) NULL,
	[T29] [nvarchar](50) NULL,
	[T30] [nvarchar](50) NULL,
	[T31] [nvarchar](50) NULL,
	CONSTRAINT [PK_HT2411] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
