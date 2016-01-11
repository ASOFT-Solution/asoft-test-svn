-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0000STD]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0000STD](
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NULL,
	[ExpenseAccountID] [nvarchar](50) NULL,
	[PayableAccountID] [nvarchar](50) NULL,
	[TimeConvert] [decimal](28, 8) NOT NULL,
	[PayrollMethodID] [nvarchar](50) NULL,
	[DayPerMonth] [decimal](28, 8) NULL,
	[LenAbsentCardNo] [int] NULL,
	[RateExchange] [decimal](28, 8) NOT NULL,
	[OtherDayPerMonth] [decimal](28, 8) NULL,
	[IsOtherDayPerMonth] [tinyint] NULL,
	[CoefficientDecimals] [tinyint] NOT NULL,
	[AbsentDecimals] [tinyint] NOT NULL,
	[OriginalDecimals] [tinyint] NOT NULL,
	[ConvertedDecimals] [tinyint] NOT NULL,
	[PriceDecimals] [tinyint] NOT NULL,
	[QuantityDecimals] [tinyint] NOT NULL,
	[OthersDecimals] [tinyint] NOT NULL,
	[GAbsentLoanID] [nvarchar](50) NULL,
	[OtherDecimals] [int] NULL,
	[ProductAbsentMethod] [tinyint] NOT NULL,
	[ConvertedProductAbsent] [tinyint] NOT NULL
) ON [PRIMARY]
---- Add Columns
-- Them column vào table chuẩn
If Exists (Select * From sysobjects Where name = 'HT0000STD' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0000STD'  and col.name = 'PerInTaxID')
           Alter Table  HT0000STD Add PerInTaxID nvarchar(50) Null

           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0000STD'  and col.name = 'IsTranEntrySalary')
           Alter Table  HT0000STD Add IsTranEntrySalary tinyint Not Null Default(0)

           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT0000STD'  and col.name = 'IsTranferEmployee')
           Alter Table  HT0000STD Add IsTranferEmployee tinyint Not Null Default(0)

           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'HT0000STD'  and col.name = 'IsWarningContract')
           Alter Table  HT0000STD Add IsWarningContract INT Null 

           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'HT0000STD'  and col.name = 'IsWarningIDDef')
           Alter Table  HT0000STD Add IsWarningIDDef INT Null 

           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'HT0000STD'  and col.name = 'IsWarningPassPort')
           Alter Table  HT0000STD Add IsWarningPassPort INT Null 

           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'HT0000STD'  and col.name = 'IsWarningDrivingLic')
           Alter Table  HT0000STD Add IsWarningDrivingLic INT Null

		   --- Modify on 02/12/2015 by Bảo Anh: Bổ sung loại công đi trễ/về sớm (IPL)
		   If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'HT0000STD'  and col.name = 'InOutAbsentTypeID')
           Alter Table  HT0000STD Add InOutAbsentTypeID nvarchar(50) Null

		   --- Modify on 14/12/2015 by Bảo Anh: Bổ sung loại công cộng thêm cho nhân viên nữ (Meiko)
		   If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name = 'HT0000STD'  and col.name = 'FEAbsentTypeID')
           Alter Table  HT0000STD Add FEAbsentTypeID nvarchar(50) Null
End