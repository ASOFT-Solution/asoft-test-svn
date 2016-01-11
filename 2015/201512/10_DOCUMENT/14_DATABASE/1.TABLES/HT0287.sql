-- <Summary>
---- 
-- <History>
---- Create on 06/09/2013 by Thanh Sơn
---- Modified on 03/12/2015 by Hoàng Vũ: Customzie index = 43 (Khách hàng secoin): cập nhật chấm công sản phẩm theo phương pháp chỉ định ( HF0288) cho phép kế thừa từ phiếu nhập kết quả sản xuất.
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0287]') AND type in (N'U')) 
BEGIN
CREATE TABLE [dbo].[HT0287](
	[APK] [uniqueidentifier] DEFAULT NEWID() NOT NULL,
	[DivisionID] [nvarchar](3) NOT NULL,
	[TimesID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[TeamID] [nvarchar](50) NULL,
	[TrackingDate] [datetime] NULL,
	[ShiftID][NVARCHAR](50) NULL,
	[ProductID] [nvarchar](50) NOT NULL,
	[Quantity] [decimal](28, 8) NULL,
	[OriginalQuantity] [decimal](28, 8) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL			
 CONSTRAINT [PK_HT0287] PRIMARY KEY CLUSTERED 
(
	APK ASC	
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

---Customzie index = 43 (Khách hàng secoin): cập nhật chấm công sản phẩm theo phương pháp chỉ định ( HF0288) cho phép kế thừa từ phiếu nhập kết quả sản xuất.
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT0287' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'HT0287' AND col.name = 'InheritVoucherID')
        ALTER TABLE HT0287 ADD InheritVoucherID NVARCHAR(50) NULL
    END
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'HT0287' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'HT0287' AND col.name = 'InheritTransactionID')
        ALTER TABLE HT0287 ADD InheritTransactionID NVARCHAR(50) NULL
    END
---Customzie index = 43 (Khách hàng secoin): cập nhật chấm công sản phẩm theo phương pháp chỉ định ( HF0288) cho phép kế thừa từ phiếu nhập kết quả sản xuất.
