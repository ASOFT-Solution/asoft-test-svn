-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT4010]') AND type in (N'U'))
CREATE TABLE [dbo].[OT4010](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ColumnID] [int] NOT NULL,
	[IsColumn] [tinyint] NULL,
	[Caption] [nvarchar](100) NULL,
	[Sign1] [nvarchar](5) NULL,
	[AmountType1] [nvarchar](100) NULL,
	[Sign2] [nvarchar](5) NULL,
	[AmountType2] [nvarchar](100) NULL,
	[Sign3] [nvarchar](5) NULL,
	[AmountType3] [nvarchar](100) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[Sign4] [nvarchar](5) NULL,
	[AmountType4] [nvarchar](100) NULL,
	[Sign5] [nvarchar](5) NULL,
	[AmountType5] [nvarchar](100) NULL,
	CONSTRAINT [PK_OT4010] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
