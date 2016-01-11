-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1111]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1111](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PeriodID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	[UserName] [nvarchar](50) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[ProductID] [nvarchar](50) NULL,
	[MaterialID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NULL,
	[Quantity] [decimal](28, 8) NULL,
	CONSTRAINT [PK_MT1111] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON
)
) ON [PRIMARY]
