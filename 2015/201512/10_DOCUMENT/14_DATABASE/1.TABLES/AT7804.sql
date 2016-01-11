-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT7804]') AND type in (N'U'))
CREATE TABLE [dbo].[AT7804](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[DetailID] [int] NOT NULL,
	[CoefficientID] [nvarchar](50) NOT NULL,
	[AnaID] [nvarchar](50) NULL,
	[CoValues] [decimal](28, 8) NOT NULL,
	[Notes] [nvarchar](250) NULL,
CONSTRAINT [PK_AT7804] PRIMARY KEY NONCLUSTERED 
(
	[DetailID] ASC,
	[CoefficientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT7804_CoValues]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT7804] ADD  CONSTRAINT [DF_AT7804_CoValues]  DEFAULT ((0)) FOR [CoValues]
END
