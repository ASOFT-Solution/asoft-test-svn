-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1904]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1904](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[ProductID] [nvarchar](50) NOT NULL,
	[PriceSheetID] [nvarchar](50) NOT NULL,
	[ProducingProcessID] [nvarchar](50) NOT NULL,
	[StepID] [nvarchar](50) NOT NULL,
	[UnitID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[PeriodID] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[ProduceDate] [datetime] NOT NULL,
	[AUnitID] [nvarchar](50) NULL,
	[ConvertedRate] [decimal](28, 8) NOT NULL,
	[Quantity] [decimal](28, 8) NULL,
	[AQuantity] [decimal](28, 8) NULL,
	[UnitPrice] [decimal](28, 8) NULL,
	[Amount] [decimal](28, 8) NULL,
	[Notes] [nvarchar](250) NULL,
	CONSTRAINT [PK_HT1904] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default 
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__HT1904__AUnitID__267A20ED]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1904] ADD  CONSTRAINT [DF__HT1904__AUnitID__267A20ED]  DEFAULT ((1)) FOR [AUnitID]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1904_ConvertedRate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1904] ADD  CONSTRAINT [DF_HT1904_ConvertedRate]  DEFAULT ((1)) FOR [ConvertedRate]
END