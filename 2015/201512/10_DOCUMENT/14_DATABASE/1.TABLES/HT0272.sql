-- <Summary>
---- 
-- <History>
---- Create on 23/05/2013 by Lê Thị Thu Hiền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0272]') AND type in (N'U')) 
BEGIN
CREATE TABLE [dbo].[HT0272](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](50) NOT NULL,
	[PriceID] [nvarchar](50) NOT NULL,
	[Orders] [int] NULL,
	[InventoryTypeID] [nvarchar](50) NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[WorkID] [nvarchar](50) NOT NULL,
	[PlanID] [nvarchar](50) NOT NULL,
	[SubPlanID] [nvarchar](50) NOT NULL,
	[SalaryPlanID] [nvarchar](50) NOT NULL,
	[WorkTypeID] [nvarchar](50) NOT NULL,
	[UnitID] [nvarchar](50) NULL,
	[Price] [decimal](28, 8) NULL,
	[DeleteFlag] [tinyint] default(0) NOT NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	
 CONSTRAINT [PK_HT0272] PRIMARY KEY CLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

