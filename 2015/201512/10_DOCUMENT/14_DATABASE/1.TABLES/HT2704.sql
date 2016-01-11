-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2704]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2704](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[ReportCode] [nvarchar](50) NOT NULL,
	[LineID] [nvarchar](50) NOT NULL,
	[LineDescription] [nvarchar](250) NULL,
	[Code] [nvarchar](50) NULL,
	[Code0] [nvarchar](50) NULL,
	[Rate] [decimal](28, 8) NULL,
	[Step] [int] NULL,
	[Sign] [int] NULL,
	[IsBold] [tinyint] NULL,
	[IsItalic] [tinyint] NULL,
	[IsGray] [tinyint] NULL,
	[IsNotPrint] [tinyint] NULL,
	[DataType] [nvarchar](50) NULL,
	[EmployeeType] [int] NULL,
	[Amount] [decimal](28, 8) NULL,
	CONSTRAINT [PK_HT2704] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
