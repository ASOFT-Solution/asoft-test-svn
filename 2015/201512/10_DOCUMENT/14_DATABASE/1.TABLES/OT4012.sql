-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT4012]') AND type in (N'U'))
CREATE TABLE [dbo].[OT4012](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[LineID] [nvarchar](50) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[ReportCode] [nvarchar](50) NULL,
	[Orders] [int] NULL,
	[Disabled] [tinyint] NOT NULL,
	[LineDescription] [nvarchar](250) NULL,
	[Method] [int] NULL,
	[MonthAmount] [int] NULL,
	[DataType] [nvarchar](100) NULL,
	[AmountType] [nvarchar](100) NULL,
	[IsPast] [tinyint] NULL,
	[FromAccountID] [nvarchar](50) NULL,
	[ToAccountID] [nvarchar](50) NULL,
	[FromCorAccountID] [nvarchar](50) NULL,
	[ToCorAccountID] [nvarchar](50) NULL,
	[Sign10] [nvarchar](100) NULL,
	[Sign20] [nvarchar](100) NULL,
	[Col10] [decimal](28, 8) NULL,
	[Col11] [nvarchar](50) NULL,
	[Col12] [nvarchar](50) NULL,
	[Col13] [nvarchar](50) NULL,
	[Col14] [nvarchar](50) NULL,
	[Col15] [nvarchar](50) NULL,
	[Col20] [decimal](28, 8) NULL,
	[Col21] [nvarchar](50) NULL,
	[Col22] [nvarchar](50) NULL,
	[Col23] [nvarchar](50) NULL,
	[Col24] [nvarchar](50) NULL,
	[Col25] [nvarchar](50) NULL,
 CONSTRAINT [PK_OT4012] PRIMARY KEY CLUSTERED 
(
	[LineID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT4012_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT4012] ADD  CONSTRAINT [DF_OT4012_Disabled]  DEFAULT ((0)) FOR [Disabled]
END