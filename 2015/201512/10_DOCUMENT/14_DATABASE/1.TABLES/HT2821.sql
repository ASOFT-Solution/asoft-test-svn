-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2821]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2821](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[SalaryCondDetailID] [nvarchar](50) NOT NULL,
	[SalaryCondID] [nvarchar](50) NULL,
	[FromValue] [decimal](28, 8) NULL,
	[ToValue] [decimal](28, 8) NULL,
	[Value] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT2821] PRIMARY KEY NONCLUSTERED 
(
	[SalaryCondDetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
