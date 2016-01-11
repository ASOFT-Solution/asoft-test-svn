-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT2003]') AND type in (N'U'))
CREATE TABLE [dbo].[MT2003](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PlanID] [nvarchar](50) NOT NULL,
	[Date01] [datetime] NULL,
	[Date02] [datetime] NULL,
	[Date03] [datetime] NULL,
	[Date04] [datetime] NULL,
	[Date05] [datetime] NULL,
	[Date06] [datetime] NULL,
	[Date07] [datetime] NULL,
	[Date08] [datetime] NULL,
	[Date09] [datetime] NULL,
	[Date10] [datetime] NULL,
	[Date11] [datetime] NULL,
	[Date12] [datetime] NULL,
	[Date13] [datetime] NULL,
	[Date14] [datetime] NULL,
	[Date15] [datetime] NULL,
	[Date16] [datetime] NULL,
	[Date17] [datetime] NULL,
	[Date18] [datetime] NULL,
	[Date19] [datetime] NULL,
	[Date20] [datetime] NULL,
	[Date21] [datetime] NULL,
	[Date22] [datetime] NULL,
	[Date23] [datetime] NULL,
	[Date24] [datetime] NULL,
	[Date25] [datetime] NULL,
	[Date26] [datetime] NULL,
	[Date27] [datetime] NULL,
	[Date28] [datetime] NULL,
	[Date29] [datetime] NULL,
	[Date30] [datetime] NULL,
	[Date31] [datetime] NULL,
	[Date32] [datetime] NULL,
	[Date33] [datetime] NULL,
	[Date34] [datetime] NULL,
	[Date35] [datetime] NULL,
	[Date36] [datetime] NULL,
	[Date37] [datetime] NULL,
	[Date38] [datetime] NULL,
	[Date39] [datetime] NULL,
	[Date40] [datetime] NULL,
 CONSTRAINT [PK_MT2003] PRIMARY KEY NONCLUSTERED 
(
	[PlanID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
