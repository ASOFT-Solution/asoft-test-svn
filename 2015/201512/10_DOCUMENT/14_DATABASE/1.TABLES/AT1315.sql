-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1315]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1315](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[ToolMethod] [nvarchar](50) NOT NULL,
	[ToolStatus] [tinyint] NOT NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[BeginMonth] [int] NULL,
	[BeginYear] [int] NULL,
	[EndMonth] [int] NULL,
	[EndYear] [int] NULL,
	[PercentAmount] [decimal](28, 8) NULL,
	[CostAccountID] [nvarchar](50) NULL,
	[InterAccountID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1315] PRIMARY KEY NONCLUSTERED 
(
	[InventoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1315_ToolMethod]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1315] ADD CONSTRAINT [DF_AT1315_ToolMethod] DEFAULT ((0)) FOR [ToolMethod]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1315_ToolStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1315] ADD CONSTRAINT [DF_AT1315_ToolStatus] DEFAULT ((0)) FOR [ToolStatus]
END