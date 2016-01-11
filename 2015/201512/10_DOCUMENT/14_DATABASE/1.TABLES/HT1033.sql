-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1033]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1033](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[AbsentTypeID] [nvarchar](50) NULL,
	[ParentID] [nvarchar](50) NULL,
	[FromAbsentAmount] [decimal](28, 8) NULL,
	[ToAbsentAmount] [decimal](28, 8) NULL,
	[Orders] [int] NULL,
	CONSTRAINT [PK_HT1033] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
