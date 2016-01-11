-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1019]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1019](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[LineID] [int] NOT NULL,
	[InterestID] [nvarchar](50) NOT NULL,
	[FromValues] [decimal](28, 8) NULL,
	[ToValues] [decimal](28, 8) NULL,
	[PercentValues] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT1019] PRIMARY KEY NONCLUSTERED 
(
	[LineID] ASC,
	[InterestID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

