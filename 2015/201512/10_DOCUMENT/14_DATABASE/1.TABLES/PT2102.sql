-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Hoang Phuoc
---- Modified on 03/02/2012 by Huỳnh Tấn Phú: Bo sung 5 ma phan tich Ana
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PT2102]') AND type in (N'U'))
CREATE TABLE [dbo].[PT2102](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[Orders] [int] NULL,
	[OrderGroup] [nvarchar](50) NULL,
	[StyleID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[Quantity] [decimal](28, 8) NULL,
	[PaletteID] [nvarchar](50) NULL,
	[ColorID] [nvarchar](50) NULL,
	[Breadth] [decimal](28, 8) NULL,
	[Weight] [decimal](28, 8) NULL,
	[WeightUnit] [nvarchar](50) NULL,
	[Quality] [nvarchar](50) NULL,
	[ProgressID] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[Ana01ID] [nvarchar](50) NULL,
	[Ana02ID] [nvarchar](50) NULL,
	[Ana03ID] [nvarchar](50) NULL,
	[Ana04ID] [nvarchar](50) NULL,
	[Ana05ID] [nvarchar](50) NULL,
	[IsPlan] [tinyint] NOT NULL,
	[FactoryID] [nvarchar](50) NULL,
	[MacTypeID] [nvarchar](50) NULL,
	[MacQuantity] [int] NULL,
	[RawQuantity] [decimal](28, 8) NULL,
	[BeginDate] [datetime] NULL,
	[PlanFinishedDate] [datetime] NULL,
	[PlanDescription] [nvarchar](250) NULL,
 CONSTRAINT [PK_PT2102] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PT2102_IsPlan]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PT2102] ADD  CONSTRAINT [DF_PT2102_IsPlan]  DEFAULT ((0)) FOR [IsPlan]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'PT2102' and xtype ='U') 
Begin 
If not exists (select * from syscolumns col inner join sysobjects tab 
On col.id = tab.id where tab.name =   'PT2102'  and col.name = 'Ana06ID')
Alter Table  PT2102 Add Ana06ID nvarchar(50) Null,
					 Ana07ID nvarchar(50) Null,
					 Ana08ID nvarchar(50) Null,
					 Ana09ID nvarchar(50) Null,
					 Ana10ID nvarchar(50) Null
End
