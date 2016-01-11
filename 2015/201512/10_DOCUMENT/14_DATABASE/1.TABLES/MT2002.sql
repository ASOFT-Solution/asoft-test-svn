-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on 19/08/2015 by Quốc Tuấn bổ sung thêm ApportionID
---- Modified on 18/12/2015 by Tiểu Mai: Bổ sung 10 MPT Ana01ID --> Ana10ID
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT2002]') AND type in (N'U'))
CREATE TABLE [dbo].[MT2002](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PlanDetailID] [nvarchar](50) NOT NULL,
	[PlanID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[InventoryID] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[PlanQuantity] [decimal](28, 8) NULL,
	[Quantity01] [decimal](28, 8) NULL,
	[Quantity02] [decimal](28, 8) NULL,
	[Quantity03] [decimal](28, 8) NULL,
	[Quantity04] [decimal](28, 8) NULL,
	[Quantity05] [decimal](28, 8) NULL,
	[Quantity06] [decimal](28, 8) NULL,
	[Quantity07] [decimal](28, 8) NULL,
	[Quantity08] [decimal](28, 8) NULL,
	[Quantity09] [decimal](28, 8) NULL,
	[Quantity10] [decimal](28, 8) NULL,
	[Quantity11] [decimal](28, 8) NULL,
	[Quantity12] [decimal](28, 8) NULL,
	[Quantity13] [decimal](28, 8) NULL,
	[Quantity14] [decimal](28, 8) NULL,
	[Quantity15] [decimal](28, 8) NULL,
	[Quantity16] [decimal](28, 8) NULL,
	[Quantity17] [decimal](28, 8) NULL,
	[Quantity18] [decimal](28, 8) NULL,
	[Quantity19] [decimal](28, 8) NULL,
	[Quantity20] [decimal](28, 8) NULL,
	[Quantity21] [decimal](28, 8) NULL,
	[Quantity22] [decimal](28, 8) NULL,
	[Quantity23] [decimal](28, 8) NULL,
	[Quantity24] [decimal](28, 8) NULL,
	[Quantity25] [decimal](28, 8) NULL,
	[Quantity26] [decimal](28, 8) NULL,
	[Quantity27] [decimal](28, 8) NULL,
	[Quantity28] [decimal](28, 8) NULL,
	[Quantity29] [decimal](28, 8) NULL,
	[Quantity30] [decimal](28, 8) NULL,
	[Quantity31] [decimal](28, 8) NULL,
	[Quantity32] [decimal](28, 8) NULL,
	[Quantity33] [decimal](28, 8) NULL,
	[Quantity34] [decimal](28, 8) NULL,
	[Quantity35] [decimal](28, 8) NULL,
	[Quantity36] [decimal](28, 8) NULL,
	[Quantity37] [decimal](28, 8) NULL,
	[Quantity38] [decimal](28, 8) NULL,
	[Quantity39] [decimal](28, 8) NULL,
	[Quantity40] [decimal](28, 8) NULL,
	[LinkNo] [nvarchar](50) NULL,
	[Notes] [nvarchar](250) NULL,
	[RefInfor] [nvarchar](250) NULL,
	[BeginDate] [datetime] NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[LevelID] [nvarchar](50) NULL,
	[WorkID] [nvarchar](50) NULL,
	[Finish] [tinyint] NULL,
	[Orders] [int] NULL,
 CONSTRAINT [PK_MT2002] PRIMARY KEY NONCLUSTERED 
(
	[PlanDetailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

--Thêm column
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'MT2002' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT2002' AND col.name = 'ApportionID')
		ALTER TABLE MT2002 ADD ApportionID VARCHAR(50) NULL
	END

-- Tieu Mai, Add columns	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'MT2002' AND xtype = 'U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id = tab.id WHERE tab.name = 'MT2002' AND col.name = 'Ana01ID')
		ALTER TABLE MT2002 ADD  Ana01ID VARCHAR(50) NULL,
								Ana02ID VARCHAR(50) NULL,
								Ana03ID VARCHAR(50) NULL,
								Ana04ID VARCHAR(50) NULL,
								Ana05ID VARCHAR(50) NULL,
								Ana06ID VARCHAR(50) NULL,
								Ana07ID VARCHAR(50) NULL,
								Ana08ID VARCHAR(50) NULL,
								Ana09ID VARCHAR(50) NULL,
								Ana10ID VARCHAR(50) NULL
	END	