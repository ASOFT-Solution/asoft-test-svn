-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh L�m
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2807]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2807](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[LoaCondDetailID] [nvarchar](50) NOT NULL,
	[LoaCondID] [nvarchar](50) NULL,
	[FromPeriod] [int] NULL,
	[ToPeriod] [int] NULL,
	[DaysBeAllowed] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT2807] PRIMARY KEY NONCLUSTERED 
(
	[LoaCondDetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
