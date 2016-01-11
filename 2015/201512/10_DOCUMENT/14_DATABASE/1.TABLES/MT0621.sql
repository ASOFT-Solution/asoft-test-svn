-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on 31/12/2015 by Tieu Mai: bo sung 20 cot quy cach cho SP va NVL
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT0621]') AND type in (N'U'))
CREATE TABLE [dbo].[MT0621](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ID] [decimal](28, 0) IDENTITY(1,1) NOT NULL,
	[MaterialID] [nvarchar](50) NULL,
	[ProductID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[ExpenseID] [nvarchar](50) NULL,
	[Quantity] [decimal](28, 8) NULL,
	[QuantityUnit] [decimal](28, 8) NULL,
	[MaterialTypeID] [nvarchar](50) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[ConvertedUnit] [decimal](28, 8) NULL,
	[ProductQuantity] [decimal](28, 8) NULL,
	[Rate] [decimal](28, 8) NULL,
	CONSTRAINT [PK_MT0621] PRIMARY KEY NONCLUSTERED
	(
	[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]	
) ON [PRIMARY]

--- Add columns quy cach cho SP va NVL
IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT0621' AND col.name = 'PS01ID')
        ALTER TABLE MT0621 ADD	PS01ID NVARCHAR(50) NULL,
								PS02ID NVARCHAR(50) NULL,
								PS03ID NVARCHAR(50) NULL,
								PS04ID NVARCHAR(50) NULL,
								PS05ID NVARCHAR(50) NULL,
								PS06ID NVARCHAR(50) NULL,
								PS07ID NVARCHAR(50) NULL,
								PS08ID NVARCHAR(50) NULL,
								PS09ID NVARCHAR(50) NULL,
								PS10ID NVARCHAR(50) NULL,
								PS11ID NVARCHAR(50) NULL,
								PS12ID NVARCHAR(50) NULL,
								PS13ID NVARCHAR(50) NULL,
								PS14ID NVARCHAR(50) NULL,
								PS15ID NVARCHAR(50) NULL,
								PS16ID NVARCHAR(50) NULL,
								PS17ID NVARCHAR(50) NULL,
								PS18ID NVARCHAR(50) NULL,
								PS19ID NVARCHAR(50) NULL,
								PS20ID NVARCHAR(50) NULL,
								S01ID NVARCHAR(50) NULL,
								S02ID NVARCHAR(50) NULL,
								S03ID NVARCHAR(50) NULL,
								S04ID NVARCHAR(50) NULL,
								S05ID NVARCHAR(50) NULL,
								S06ID NVARCHAR(50) NULL,
								S07ID NVARCHAR(50) NULL,
								S08ID NVARCHAR(50) NULL,
								S09ID NVARCHAR(50) NULL,
								S10ID NVARCHAR(50) NULL,
								S11ID NVARCHAR(50) NULL,
								S12ID NVARCHAR(50) NULL,
								S13ID NVARCHAR(50) NULL,
								S14ID NVARCHAR(50) NULL,
								S15ID NVARCHAR(50) NULL,
								S16ID NVARCHAR(50) NULL,
								S17ID NVARCHAR(50) NULL,
								S18ID NVARCHAR(50) NULL,
								S19ID NVARCHAR(50) NULL,
								S20ID NVARCHAR(50) NULL
