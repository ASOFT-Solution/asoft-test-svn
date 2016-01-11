-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on ... by ...
---- <Example>

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1326]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OT1326](
	[APK] [uniqueidentifier] NULL DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL, -- TP
	[ItemID] [nvarchar](50) NOT NULL, -- NVL
	[ItemName] [nvarchar](250) NULL,
	[InventoryUnitID] [nvarchar](50) NULL,
	[ItemUnitID] [nvarchar](50) NULL,
	[MDescription] [nvarchar](250) NULL,
	[InventoryQuantity] [decimal](28, 8) NOT NULL,
	[DDescription] [nvarchar](250) NULL,
	[ItemQuantity] [decimal](28, 8) NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[IsCommon] [tinyint] NULL,
	[MOrderID] [nvarchar](50) NULL,
	[SorderID] [nvarchar](50) NULL,
	[EstimateID] [nvarchar](50) NOT NULL
 CONSTRAINT [PK_OT1326] PRIMARY KEY CLUSTERED 
(
	[InventoryID] ASC,
	[ItemID] ASC,
	[DivisionID] ASC,
	[EstimateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_OT1326_IsCommon]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OT1326] ADD CONSTRAINT [DF_OT1326_IsCommon]  DEFAULT ((0)) FOR [IsCommon]
END

