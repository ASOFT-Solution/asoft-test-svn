-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT4445]') AND type in (N'U'))
CREATE TABLE [dbo].[OT4445](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[Col01] [nvarchar](50) NULL,
	[Col02] [nvarchar](50) NULL,
	[Col03] [nvarchar](50) NULL,
	[Col04] [nvarchar](50) NULL,
	[Col05] [nvarchar](50) NULL,
	[Col06] [nvarchar](50) NULL,
	[Col07] [nvarchar](50) NULL,
	[Col08] [nvarchar](50) NULL,
	[Col09] [nvarchar](50) NULL,
	[Col10] [nvarchar](50) NULL,
	[Col11] [nvarchar](50) NULL,
	[Col12] [nvarchar](50) NULL,
	[Col13] [nvarchar](50) NULL,
	[Col14] [nvarchar](50) NULL,
	[Col15] [nvarchar](50) NULL,
	[Col16] [nvarchar](50) NULL,
	[Col17] [nvarchar](50) NULL,
	[Col18] [nvarchar](50) NULL,
	[Col19] [nvarchar](50) NULL,
	[Col20] [nvarchar](50) NULL,
	[Col21] [nvarchar](50) NULL,
	[Col22] [nvarchar](50) NULL,
	[Col23] [nvarchar](50) NULL,
	[Col24] [nvarchar](50) NULL,
	[Col25] [nvarchar](50) NULL,
	[Col26] [nvarchar](50) NULL,
	[Col27] [nvarchar](50) NULL,
	[Col28] [nvarchar](50) NULL,
	[Col29] [nvarchar](50) NULL,
	[Col30] [nvarchar](50) NULL,
	CONSTRAINT [PK_OT4445] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
