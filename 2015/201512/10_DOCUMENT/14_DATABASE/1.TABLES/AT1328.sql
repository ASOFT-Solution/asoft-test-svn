-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1328]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT1328](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PromoteID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[OID] [nvarchar](50) NULL,
	[InventoryTypeID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[FromQuantity] [decimal](28, 8) NULL,
	[ToQuantity] [decimal](28, 8) NULL,
	[Disabled] [TinyInt] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[IsCommon] [tinyint] NULL,
	[PromoteTypeID] [tinyint] NULL,
	CONSTRAINT [PK_AT1328] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add giá trị default 
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1328_IsCommon]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1328] ADD  CONSTRAINT [DF_AT1328_IsCommon]  DEFAULT ((0)) FOR [IsCommon]
END