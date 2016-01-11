-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1309]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1309](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[UnitID] [nvarchar](50) NOT NULL,
	[ConversionFactor] [decimal](28, 8) NULL,
	[Disabled] [tinyint] NOT NULL,
	[Orders] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Operator] [tinyint] NOT NULL,
 CONSTRAINT [PK_HT1309] PRIMARY KEY NONCLUSTERED 
(
	[InventoryID] ASC,
	[UnitID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1309_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1309] ADD  CONSTRAINT [DF_HT1309_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT1309__Operator__6CDF4ED9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1309] ADD  CONSTRAINT [DF__HT1309__Operator__6CDF4ED9]  DEFAULT ((0)) FOR [Operator]
END
