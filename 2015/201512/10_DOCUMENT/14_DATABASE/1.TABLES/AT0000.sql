-- <Summary>
---- Thiết lập hệ thống ASOFT-T
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on 24/06/2014 by Lê Thị Hạnh: Thêm mới trường IsCreditLimit cho nghiệp vụ cảnh báo công nợ
---- Modify by Lê Thị Hạnh on 06/10/2014: Bổ sung trường: Tờ khai thuế bảo vệ môi trường
---- Modify by Lê Thị Hạnh on 19/03/2015: Bổ sung IsInsertPayable: Tự động tạo phiếu thu, chi khi duyệt phiếu tạm thu chi
---- Modified on 25/05/2015 by Lê Thị Hạnh: Thiết lập thuế tài nguyên và tiêu thụ đặc biệt
---- Modified on 25/10/2012 by Huỳnh Tấn Phú: Không cho sửa giá khi kế thừa hoá đơn bán hàng
---- Modified on 30/03/2015 by Mai Trí Thiện: Bổ sung phân quyền màn hình vào thiết lập thông tin mail server
---- Modified on 28/02/2014 by Lê Thị Thu Hiền: Bổ sung phân quyền xem dữ liệu IsPermissionView
---- Modified on 28/01/2013 by Lê Thị Thu Hiền: Bổ sung tự động cập nhật giá IsUpDatePrice
---- Modified on 12/10/2013 by Bảo Anh: Chuyển OF0121, OF0122 sang CI
---- Modified on 12/10/2013 by Quốc Tuấn: Add column IsEliminateDebt, chuyển column IsCreditLimit sang 01_AT0000_Addcolumns
---- Modified on 29/08/2012 by Huỳnh Tấn Phú:[IPL] Tự động nhảy số hoá đơn trong phiếu bán hàng,kế toán sẽ không biết phiếu nào đã xuất hoá đơn và phiếu nào chưa , yêu cầu Asoft bỏ tự động đó để bên I.P.L tự đánh số hoá đơn vào
---- Modified on 17/02/2012 by Nguyễn Bình Minh: Bổ sung IsConvertUnit,ContractAnaTypeID,ExpCurExchDiffAccType,InterestExpCurExchDiffAccID,LostExpCurExchDiffAccID,SalesContractAnaTypeID
---- Modified on 23/10/2015 by Tiểu Mai: Bổ sung thêm trường Quản lý quy cách hàng hóa.
---- Modified on 09/11/2015 by Phương Thảo: Bổ sung thiết lập sử dụng thuế nhà thầu (IsWithhodingTax)
---- Modified on 09/12/2015 by Phương Thảo: Bổ sung thiết lập loại mã phân tích phòng ban (DepartmentAnaTypeID)
-- <Example>
IF NOT EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[AT0000]') AND TYPE IN (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0000](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DefDivisionID] [nvarchar](3) NOT NULL,
	[DefTranMonth] [int] NULL,
	[DefTranYear] [int] NULL,
	[DefLoginDate] [datetime] NULL,
	[ScheduleDays] [int] NULL,
	[StartHour] [int] NULL,
	[StartMinute] [int] NULL,
	[EndHour] [int] NULL,
	[EndMinute] [int] NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[CurrencyID] [nvarchar](50) NULL,
	[CashAccountID] [nvarchar](50) NULL,
	[ReceivedAccountID] [nvarchar](50) NULL,
	[PayableAccountID] [nvarchar](50) NULL,
	[TurnOverAccountID] [nvarchar](50) NULL,
	[PrimeCostAccountID] [nvarchar](50) NULL,
	[VATInAccountID] [nvarchar](50) NULL,
	[VATOutAccountID] [nvarchar](50) NULL,
	[DifferenceAccountID] [nvarchar](50) NULL,
	[LossExchangeAccID] [nvarchar](50) NOT NULL,
	[InterestExchangeAccID] [nvarchar](50) NOT NULL,
	[VATGroupID] [nvarchar](50) NULL,
	[IsNegativeStock] [tinyint] NOT NULL,
	[PaymentTermID] [nvarchar](50) NULL,
	[IsDiscount] [tinyint] NOT NULL,
	[IsAsoftM] [tinyint] NOT NULL,
	[IsAsoftHRM] [tinyint] NOT NULL,
	[IsAsoftOP] [tinyint] NOT NULL,
	[PreCostAccountID] [nvarchar](50) NULL,
	[IsCommission] [tinyint] NULL,
	[CommissionAccountID] [nvarchar](50) NULL,
	[IsNegativeCash] [tinyint] NULL,
	[IsLockSalePrice] [tinyint] NULL,
	[IsAutoSourceNo] [tinyint] NOT NULL,
	[IsTestSalePrice] [tinyint] NULL,
	[IsConsecutiveExchange] [tinyint] NOT NULL,
	[IsNotDebit] [tinyint] NULL,
	[ImportExcel] [tinyint] NULL,
	[IsBarcode] [tinyint] NULL,
	[IsPrintedInvoice] [tinyint] NULL,
	[Image01ID] [image] NULL,
	[Image02ID] [image] NULL,
	CONSTRAINT [PK_AT0000] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON

)) ON [PRIMARY]
END
---- Add giá trị default
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0000_StartHour]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF_AT0000_StartHour]  DEFAULT ((8)) FOR [StartHour]
END
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0000_StartMinute]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF_AT0000_StartMinute]  DEFAULT ((0)) FOR [StartMinute]
END
IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0000_EndHour]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF_AT0000_EndHour]  DEFAULT ((17)) FOR [EndHour]
END
IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0000_EndMinute]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF_AT0000_EndMinute]  DEFAULT ((0)) FOR [EndMinute]
END
IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0000_LossExchangeAccID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF_AT0000_LossExchangeAccID]  DEFAULT ((635)) FOR [LossExchangeAccID]
END
IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0000_InterestExchangeAccID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF_AT0000_InterestExchangeAccID]  DEFAULT ((515)) FOR [InterestExchangeAccID]
END
IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0000_IsNegativeStock]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF_AT0000_IsNegativeStock]  DEFAULT ((0)) FOR [IsNegativeStock]
END
IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT0000__IsDiscou__697D6489]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF__AT0000__IsDiscou__697D6489]  DEFAULT ((0)) FOR [IsDiscount]
END
IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT0000__IsAsoftM__3668A02E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF__AT0000__IsAsoftM__3668A02E]  DEFAULT ((0)) FOR [IsAsoftM]
END
IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT0000__IsAsoftH__375CC467]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF__AT0000__IsAsoftH__375CC467]  DEFAULT ((0)) FOR [IsAsoftHRM]
END
IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT0000__IsAsoftO__3850E8A0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF__AT0000__IsAsoftO__3850E8A0]  DEFAULT ((0)) FOR [IsAsoftOP]
END
IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__AT0000__IsAutoSo__092A807F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF__AT0000__IsAutoSo__092A807F]  DEFAULT ((0)) FOR [IsAutoSourceNo]
END
IF NOT EXISTS(SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT0000_IsConsecutiveExchange]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT0000] ADD  CONSTRAINT [DF_AT0000_IsConsecutiveExchange]  DEFAULT ((0)) FOR [IsConsecutiveExchange]
END
---- Add Columns
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='IsCreditLimit')
		ALTER TABLE AT0000 ADD IsCreditLimit TINYINT NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='ITypeID')
		ALTER TABLE AT0000 ADD ITypeID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='IsEnvironmentTax')
		ALTER TABLE AT0000 ADD IsEnvironmentTax TINYINT NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='ETaxDebitAccountID')
		ALTER TABLE AT0000 ADD ETaxDebitAccountID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='ETaxCreditAccountID')
		ALTER TABLE AT0000 ADD ETaxCreditAccountID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='IsInsertPayable')
		ALTER TABLE AT0000 ADD IsInsertPayable TINYINT DEFAULT 1 NOT NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='IsNRT')
		ALTER TABLE AT0000 ADD IsNRT TINYINT NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='IsSET')
		ALTER TABLE AT0000 ADD IsSET TINYINT NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='NRTDebitAccountID')
		ALTER TABLE AT0000 ADD NRTDebitAccountID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='NRTCreditAccountID')
		ALTER TABLE AT0000 ADD NRTCreditAccountID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='InSETDebitAccountID')
		ALTER TABLE AT0000 ADD InSETDebitAccountID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='InSETCreditAccountID')
		ALTER TABLE AT0000 ADD InSETCreditAccountID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='OSETDebitAccountID')
		ALTER TABLE AT0000 ADD OSETDebitAccountID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='OSETCreditAccountID')
		ALTER TABLE AT0000 ADD OSETCreditAccountID NVARCHAR(50) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='IsNoEditPrice')
		ALTER TABLE AT0000 ADD IsNoEditPrice TINYINT NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='MailSetting')
		ALTER TABLE AT0000 ADD MailSetting NVARCHAR(2000) NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='IsPermissionView')
		ALTER TABLE AT0000 ADD IsPermissionView TINYINT Default(0) NOT NULL
	END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='IsUpDatePrice')
		ALTER TABLE AT0000 ADD IsUpDatePrice TINYINT NULL
	END
If Exists (Select * From sysobjects Where name = 'AT0000' and xtype ='U') 
Begin
    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT0000'  and col.name = 'CheckSerialInvoiceNo')
    Alter Table  AT0000 Add CheckSerialInvoiceNo tinyint Null Default(0)
           
    ---------------- Bổ sung cho Sinolife
    If not exists (select * from syscolumns col inner join sysobjects tab 
    On col.id = tab.id where tab.name =   'AT0000'  and col.name = 'LevelCounts')
    Alter Table  AT0000 Add LevelCounts int Null Default(3)
    -------------------------------------------------------------------------
	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='IsCreditLimit')
	ALTER TABLE AT0000 ADD IsCreditLimit TINYINT NULL
	-------------------------------------------------------------------------
	IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='IsEliminateDebt')
	ALTER TABLE AT0000 ADD IsEliminateDebt TINYINT NULL
End
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='IsAutoSerialInvoiceNo')
		ALTER TABLE AT0000 ADD IsAutoSerialInvoiceNo TINYINT DEFAULT(1) NULL
	END
IF(ISNULL(COL_LENGTH('AT0000', 'IsConvertUnit'), 0) <= 0)
BEGIN
	ALTER TABLE AT0000 ADD IsConvertUnit TINYINT
	EXEC('UPDATE AT0000 SET IsConvertUnit = 0 WHERE IsConvertUnit IS NULL')
END
IF(ISNULL(COL_LENGTH('AT0000', 'ContractAnaTypeID'), 0) <= 0)
BEGIN
	ALTER TABLE AT0000 ADD ContractAnaTypeID NVARCHAR(50) NULL DEFAULT('A03')
	EXEC ('
		UPDATE AT0000
		SET ContractAnaTypeID = ''A01''
		WHERE ContractAnaTypeID IS NULL
		')
END
IF(ISNULL(COL_LENGTH('AT0000', 'ExpCurExchDiffAccType'), 0) <= 0)
	ALTER TABLE AT0000 ADD ExpCurExchDiffAccType TINYINT NOT NULL DEFAULT(0)
IF(ISNULL(COL_LENGTH('AT0000', 'InterestExpCurExchDiffAccID'), 0) <= 0)
	ALTER TABLE AT0000 ADD InterestExpCurExchDiffAccID NVARCHAR(50) NOT NULL DEFAULT('')
IF(ISNULL(COL_LENGTH('AT0000', 'LostExpCurExchDiffAccID'), 0) <= 0)
	ALTER TABLE AT0000 ADD LostExpCurExchDiffAccID NVARCHAR(50) NOT NULL DEFAULT('')


--- Thiet lap thue nha thau
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT0000' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT0000' AND col.name = 'IsWithhodingTax')
        ALTER TABLE AT0000 ADD IsWithhodingTax TINYINT NULL
    END

--- Mã phân tích phòng ban
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT0000' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT0000' AND col.name = 'DepartmentAnaTypeID')
        ALTER TABLE AT0000 ADD DepartmentAnaTypeID NVARCHAR(50) NULL
    END




--------------------------- UPDATE ------------------------------------------------------
IF(ISNULL(COL_LENGTH('AT0000', 'SalesContractAnaTypeID'), 0) <= 0)
BEGIN
	ALTER TABLE AT0000 ADD SalesContractAnaTypeID NVARCHAR(50) NULL DEFAULT('A03')
	EXEC ('
		UPDATE AT0000
		SET SalesContractAnaTypeID = ContractAnaTypeID
		WHERE SalesContractAnaTypeID IS NULL
		')
END


---- Add columns by Tieu Mai on 23/10/2015	
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='AT0000' AND xtype='U')
	BEGIN
		IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab 
		ON col.id=tab.id WHERE tab.name='AT0000' AND col.name='IsSpecificate')
		ALTER TABLE AT0000 ADD IsSpecificate TINYINT DEFAULT(0) NOT NULL
	END	
	
