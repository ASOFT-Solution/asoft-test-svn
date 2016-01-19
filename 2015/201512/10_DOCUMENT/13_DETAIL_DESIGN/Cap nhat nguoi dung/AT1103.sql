-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on 20/11/2015 by Hoàng vũ: CusmizeIndex = 51 (Khách hàng hoáng trần), bổ sung thêm 2 trường SipID, SipPassword tài khoản mặc định của nhân viên dùng crm
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1103]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1103](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[FullName] [nvarchar](250) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[EmployeeTypeID] [nvarchar](50) NULL,
	[HireDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[BirthDay] [datetime] NULL,
	[Address] [nvarchar](250) NULL,
	[Tel] [nvarchar](100) NULL,
	[Fax] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[IsUserID] [tinyint] NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_AT1103] PRIMARY KEY NONCLUSTERED 
(
	[EmployeeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1103_IsUserID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1103] ADD  CONSTRAINT [DF_AT1103_IsUserID]  DEFAULT ((0)) FOR [IsUserID]
END
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1103_Disabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1103] ADD  CONSTRAINT [DF_AT1103_Disabled]  DEFAULT ((0)) FOR [Disabled]
END

--SipID: Dùng cho CRM, giá trị này do bên tổng đài cung cap
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1103' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT1103' AND col.name = 'SipID')
        ALTER TABLE AT1103 ADD SipID NVARCHAR(50) NULL
    END

--SipPassword: Dùng cho CRM, giá trị này do bên tổng đài cung cap
IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE [name] = 'AT1103' AND xtype = 'U')
    BEGIN
        IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col INNER JOIN sysobjects tab
        ON col.id = tab.id WHERE tab.name = 'AT1103' AND col.name = 'SipPassword')
        ALTER TABLE AT1103 ADD SipPassword NVARCHAR(50) NULL
    END