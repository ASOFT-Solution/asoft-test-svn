-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1607]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1607](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DeCoefficientID] [nvarchar](50) NOT NULL,
	[CoefficientID] [nvarchar](50) NULL,
	[PeriodID] [nvarchar](50) NULL,
	[CoValue] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
 CONSTRAINT [PK_MT1607] PRIMARY KEY NONCLUSTERED 
(
	[DeCoefficientID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
