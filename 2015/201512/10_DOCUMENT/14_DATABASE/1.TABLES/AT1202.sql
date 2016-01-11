-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modify on 18/08/2014 by Bảo Anh: Bổ sung cột mã nhánh (Sinolife)
---- Modified on 08/10/2014 by Bảo Anh: Xoa field BranchID
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1202]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1202](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ObjectID] [nvarchar](50) NOT NULL,
	[S1] [nvarchar](50) NULL,
	[S2] [nvarchar](50) NULL,
	[S3] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[IsSupplier] [tinyint] NOT NULL,
	[IsCustomer] [tinyint] NOT NULL,
	[IsUpdateName] [tinyint] NOT NULL,
	[TradeName] [nvarchar](250) NULL,
	[LegalCapital] [decimal](28, 8) NULL,
	[FieldID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[ObjectTypeID] [nvarchar](50) NULL,
	[Address] [nvarchar](250) NULL,
	[CountryID] [nvarchar](50) NULL,
	[CityID] [nvarchar](50) NULL,
	[Tel] [nvarchar](100) NULL,
	[Fax] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[Website] [nvarchar](100) NULL,
	[PaymentID] [nvarchar](50) NULL,
	[Note] [nvarchar](250) NULL,
	[BankName] [nvarchar](250) NULL,
	[BankAddress] [nvarchar](250) NULL,
	[BankAccountNo] [nvarchar](50) NULL,
	[FinanceStatusID] [nvarchar](50) NULL,
	[LicenseNo] [nvarchar](50) NULL,
	[LicenseOffice] [nvarchar](100) NULL,
	[LicenseDate] [datetime] NULL,
	[Register] [nvarchar](50) NULL,
	[Potentility] [nvarchar](50) NULL,
	[BrabNameID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[VATNo] [nvarchar](50) NULL,
	[ReCreditLimit] [decimal](28, 8) NULL,
	[PaCreditLimit] [decimal](28, 8) NULL,
	[ReDueDays] [decimal](28, 8) NULL,
	[PaDueDays] [decimal](28, 8) NULL,
	[PaDiscountDays] [decimal](28, 8) NULL,
	[PaDiscountPercent] [decimal](28, 8) NULL,
	[AreaID] [nvarchar](50) NULL,
	[RePaymentTermID] [nvarchar](50) NULL,
	[PaPaymentTermID] [nvarchar](50) NULL,
	[O01ID] [nvarchar](50) NULL,
	[O02ID] [nvarchar](50) NULL,
	[O03ID] [nvarchar](50) NULL,
	[O04ID] [nvarchar](50) NULL,
	[O05ID] [nvarchar](50) NULL,
	[DeAddress] [nvarchar](250) NULL,
	[ReDays] [int] NULL,
	[IsLockedOver] [tinyint] NOT NULL,
	[ReAddress] [nvarchar](250) NULL,
	[Note1] [nvarchar](250) NULL,
	[PaAccountID] [nvarchar](50) NULL,
	[ReAccountID] [nvarchar](50) NULL,
	[Contactor] [nvarchar](250) NULL,
	[Phonenumber] [nvarchar](100) NULL,
 CONSTRAINT [PK_AT1202] PRIMARY KEY NONCLUSTERED 
(
	[ObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1202_IsSupply]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1202] ADD  CONSTRAINT [DF_AT1202_IsSupply]  DEFAULT ((0)) FOR [IsSupplier]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1202_IsCustomer]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1202] ADD  CONSTRAINT [DF_AT1202_IsCustomer]  DEFAULT ((0)) FOR [IsCustomer]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1202_IsUpdateName]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1202] ADD  CONSTRAINT [DF_AT1202_IsUpdateName]  DEFAULT ((0)) FOR [IsUpdateName]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1202_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1202] ADD  CONSTRAINT [DF_AT1202_Disabled]  DEFAULT ((0)) FOR [Disabled]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1202_IsLockedOver]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1202] ADD  CONSTRAINT [DF_AT1202_IsLockedOver]  DEFAULT ((0)) FOR [IsLockedOver]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT1202' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT1202'  and col.name = 'LevelNo')
           Alter Table  AT1202 Add LevelNo int Null           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT1202'  and col.name = 'ManagerID')
           Alter Table  AT1202 Add ManagerID nvarchar(50) Null           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT1202'  and col.name = 'MiddleID')
           Alter Table  AT1202 Add MiddleID nvarchar(50) Null           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT1202'  and col.name = 'AccAmount')
           Alter Table  AT1202 Add AccAmount decimal(28,8) Null default(0)     
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT1202'  and col.name = 'BranchID')
           Alter Table  AT1202 Add BranchID nvarchar (50) Null
		   -- Thinh Thêm IsCommon
		    IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
			ON col.id = tab.id WHERE tab.name = 'AT1202' AND col.name = 'IsCommon')
			ALTER TABLE AT1202 ADD [IsCommon] [tinyint] NULL
END
---- Delete Columns
If Exists (Select * From sysobjects Where name = 'AT1202' and xtype ='U') 
Begin
        If exists (select * from syscolumns col inner join sysobjects tab 
        On col.id = tab.id where tab.name =   'AT1202'  and col.name = 'BranchID')
			Alter table AT1202 drop column BranchID
End
--CustomizeIndex = 51 Hoàng trần: Thêm nhanh khách hàng---
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1202' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT1202' AND col.name = 'IsVATObjectID')
        ALTER TABLE AT1202 ADD IsVATObjectID TINYINT NULL
    END
--CustomizeIndex = 51 Hoàng trần: Thêm nhanh khách hàng---
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1202' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT1202' AND col.name = 'VATObjectID')
        ALTER TABLE AT1202 ADD VATObjectID VARCHAR(50) NULL
    END
--CustomizeIndex = 51 Hoàng trần: Thêm nhanh khách hàng---	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1202' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT1202' AND col.name = 'IsInvoice')
        ALTER TABLE AT1202 ADD IsInvoice TINYINT NULL
    END
--CustomizeIndex = 51 Hoàng trần: Thêm nhanh khách hàng---
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1202' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT1202' AND col.name = 'IsUsing')
        ALTER TABLE AT1202 ADD IsUsing TINYINT NULL
    END
--CustomizeIndex = 51 Hoàng trần: Thêm nhanh khách hàng---
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1202' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT1202' AND col.name = 'RouteID')
        ALTER TABLE AT1202 ADD RouteID VARCHAR(50) NULL
    END	
	