-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0003]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0003](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[CoefficientID] [nvarchar](50) NOT NULL,
	[FieldName] [nvarchar](250) NULL,
	[CoefficientName] [nvarchar](250) NULL,
	[Caption] [nvarchar](250) NULL,
	[IsUsed] [tinyint] NULL,
	[IsConstant] [tinyint] NULL,
	[ValueOfConstant] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT0003] PRIMARY KEY NONCLUSTERED 
(
	[CoefficientID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

