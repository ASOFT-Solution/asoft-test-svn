-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1601]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1601](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PeriodID] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[IsDistribute] [tinyint] NOT NULL,
	[IsCost] [tinyint] NOT NULL,
	[IsInprocess] [tinyint] NOT NULL,
	[PeriodType] [tinyint] NOT NULL,
	[FromMonth] [int] NULL,
	[FromYear] [int] NULL,
	[ToMonth] [int] NULL,
	[ToYear] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[DistributionID] [nvarchar](50) NULL,
	[CoefficientID] [nvarchar](50) NULL,
	[InProcessID] [nvarchar](50) NULL,
	[IsFromCost] [tinyint] NOT NULL,
	[IsForPeriodID] [tinyint] NOT NULL,
	[FromPeriodID] [nvarchar](50) NULL,
	[IsDetailCost] [tinyint] NULL,
 CONSTRAINT [PK_MT1601] PRIMARY KEY NONCLUSTERED 
(
	[PeriodID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1601_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1601] ADD  CONSTRAINT [DF_MT1601_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1601_IsDistribute]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1601] ADD  CONSTRAINT [DF_MT1601_IsDistribute]  DEFAULT ((0)) FOR [IsDistribute]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1601_IsCost]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1601] ADD  CONSTRAINT [DF_MT1601_IsCost]  DEFAULT ((0)) FOR [IsCost]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1601_IsInprocess]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1601] ADD  CONSTRAINT [DF_MT1601_IsInprocess]  DEFAULT ((0)) FOR [IsInprocess]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1601_PeriodType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1601] ADD  CONSTRAINT [DF_MT1601_PeriodType]  DEFAULT ((0)) FOR [PeriodType]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1601_IsCoefficient]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1601] ADD  CONSTRAINT [DF_MT1601_IsCoefficient]  DEFAULT ((0)) FOR [IsFromCost]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1601_IsForPeriodID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1601] ADD  CONSTRAINT [DF_MT1601_IsForPeriodID]  DEFAULT ((0)) FOR [IsForPeriodID]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_MT1601_IsDetailCost]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1601] ADD  CONSTRAINT [DF_MT1601_IsDetailCost]  DEFAULT ((0)) FOR [IsDetailCost]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'MT1601' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT1601'  and col.name = 'WasteID')
           Alter Table  MT1601 Add WasteID nvarchar(50) Null
END
if(isnull(COL_LENGTH('MT1601','OrderID'),0)<=0)
ALTER TABLE MT1601 ADD OrderID nvarchar(50) NULL
if(isnull(COL_LENGTH('MT1601','RefTransactionID'),0)<=0)
ALTER TABLE MT1601 ADD RefTransactionID nvarchar(50) NULL