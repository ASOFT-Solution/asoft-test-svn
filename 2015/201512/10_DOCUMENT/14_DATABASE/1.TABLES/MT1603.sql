-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 19/08/2015 by Quốc Tuấn  bổ sung PhaseID
---- Modified on 07/09/2015 by Tiểu Mai: customize An Phú Gia
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1603]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1603](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ApportionProductID] [nvarchar](50) NOT NULL,
	[ApportionID] [nvarchar](50) NOT NULL,
	[MaterialID] [nvarchar](50) NULL,
	[ProductID] [nvarchar](50) NOT NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	[Rate] [decimal](28, 8) NULL,
	[UnitID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NOT NULL,
	[DiminishPercent] [decimal](28, 8) NULL,
	[MaterialAmount] [decimal](28, 8) NULL,
	[ProductQuantity] [decimal](28, 8) NULL,
	[DetailUse] [nvarchar](250) NULL,
	[QuantityUnit] [decimal](28, 8) NULL,
	[ConvertedUnit] [decimal](28, 8) NULL,
	[MaterialQuantity] [decimal](28, 8) NULL,
	[MaterialUnitID] [nvarchar](50) NULL,
	[MaterialPrice] [decimal](28, 8) NULL,
	[Description] [nvarchar](250) NULL,
	[IsExtraMaterial] [tinyint] NOT NULL,
	[MaterialGroupID] [nvarchar](50) NULL,
 CONSTRAINT [PK_MT1603] PRIMARY KEY NONCLUSTERED 
(
	[ApportionProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__MT1603__IsExtraM__0116BF70]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MT1603] ADD  CONSTRAINT [DF__MT1603__IsExtraM__0116BF70]  DEFAULT ((0)) FOR [IsExtraMaterial]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'MT1603' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT1603'  and col.name = 'WasteID')
           Alter Table  MT1603 Add WasteID nvarchar(50) Null
END
-- Thêm cột RateWastage vào bảng MT1603
IF(ISNULL(COL_LENGTH('MT1603', 'RateWastage'), 0) <= 0)
ALTER TABLE MT1603 ADD RateWastage tinyint NULL
If Exists (Select * From sysobjects Where name = 'MT1603' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT1603'  and col.name = 'MParameter01')
           Alter Table  MT1603 Add MParameter01 nvarchar(1000) NULL
End
If Exists (Select * From sysobjects Where name = 'MT1603' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT1603'  and col.name = 'MParameter02')
           Alter Table  MT1603 Add MParameter02 nvarchar(1000) NULL
End
If Exists (Select * From sysobjects Where name = 'MT1603' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT1603'  and col.name = 'MParameter03')
           Alter Table  MT1603 Add MParameter03 nvarchar(1000) NULL
End
If Exists (Select * From sysobjects Where name = 'MT1603' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT1603'  and col.name = 'DParameter01')
           Alter Table  MT1603 Add DParameter01 nvarchar(1000) NULL
End
If Exists (Select * From sysobjects Where name = 'MT1603' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT1603'  and col.name = 'DParameter02')
           Alter Table  MT1603 Add DParameter02 nvarchar(1000) NULL
End
If Exists (Select * From sysobjects Where name = 'MT1603' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'MT1603'  and col.name = 'DParameter03')
           Alter Table  MT1603 Add DParameter03 nvarchar(1000) NULL
END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'MT1603' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1603' AND col.name = 'PhaseID')
		ALTER TABLE MT1603 ADD PhaseID VARCHAR(50) NULL
	END
---- Alter Columns
 If not exists ( SELECT *  FROM INFORMATION_SCHEMA.COLUMNS WHERE DATA_TYPE = 'DECIMAL' AND TABLE_NAME = 'MT1603' AND COLUMN_NAME='RateWastage')
		ALTER TABLE MT1603 ALTER COLUMN RateWastage DECIMAL(28,8)

---Customize cho An Phú Gia
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'MT1603' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1603' AND col.name = 'InheritTableID')
		ALTER TABLE MT1603 ADD InheritTableID VARCHAR(50) NULL
	END	

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'MT1603' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1603' AND col.name = 'InheritQuotationID')
		ALTER TABLE MT1603 ADD InheritQuotationID VARCHAR(50) NULL
	END	

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'MT1603' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT1603' AND col.name = 'InheritTransactionID')
		ALTER TABLE MT1603 ADD InheritTransactionID VARCHAR(50) NULL
	END			