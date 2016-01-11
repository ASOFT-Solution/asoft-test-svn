-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT1328]') AND type in (N'U'))
CREATE TABLE [dbo].[OT1328](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DetailID] [nvarchar](50) NOT NULL,
	[ApportionID] [nvarchar](50) NULL,
	[ApportionName] [nvarchar](250) NULL,
	[ColorNum] [int] NULL,
	[FromSheetNum] [int] NULL,
	[ToSheetNum] [int] NULL,
	[PrintShopNum] [int] NULL,
	[ProductNum] [int] NULL,
	[Type] [tinyint] NULL,
	[InventoryID] [nvarchar](50) NULL,
	[Rate] [decimal](28, 8) NULL,
	[Disabled] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_OT1328] PRIMARY KEY CLUSTERED 
(
	[DetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

