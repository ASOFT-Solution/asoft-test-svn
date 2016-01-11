-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT2016]') AND type in (N'U'))
CREATE TABLE [dbo].[MT2016](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PlanID] [nvarchar](50) NULL,
	[PlanDetailID] [nvarchar](50) NOT NULL,
	[RePlanDetailID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[InventoryID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[PlanQuantity] [decimal](28, 8) NULL,
	[LinkNo] [nvarchar](50) NULL,
	[Notes] [nvarchar](250) NULL,
	[RefInfor] [nvarchar](250) NULL,
	[BeginDate] [datetime] NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[LevelID] [nvarchar](50) NULL,
	[WorkID] [nvarchar](50) NULL,
	[Orders] [int] NULL,
	CONSTRAINT [PK_MT2016] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
