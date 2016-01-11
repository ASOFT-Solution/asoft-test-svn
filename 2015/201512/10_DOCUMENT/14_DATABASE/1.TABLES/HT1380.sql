-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on 30/08/2013 by Bảo Anh: Bổ sung phân loại mã tự động cho quyết định thôi việc
---- Modify on 30/09/2014 by Bảo Anh: Bổ sung thông tin tạm nghỉ
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1380]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1380](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[DecidingNo] [nvarchar](50) NOT NULL,
	[DecidingDate] [datetime] NULL,
	[DecidingPerson] [nvarchar](50) NULL,
	[DecidingPersonDuty] [nvarchar](250) NULL,
	[Proposer] [nvarchar](100) NULL,
	[ProposerDuty] [nvarchar](250) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[DutyName] [nvarchar](250) NULL,
	[WorkDate] [datetime] NULL,
	[LeaveDate] [datetime] NOT NULL,
	[QuitJobID] [nvarchar](50) NOT NULL,
	[Allowance] [nvarchar](50) NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT1380] PRIMARY KEY CLUSTERED 
(
	[DecidingNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1380_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1380] ADD  CONSTRAINT [DF_HT1380_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
END
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1380_LastModifyDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1380] ADD  CONSTRAINT [DF_HT1380_LastModifyDate]  DEFAULT (getdate()) FOR [LastModifyDate]
END
---- Add Columns
If Exists (Select * From sysobjects Where name = 'HT1380' and xtype ='U') 
Begin          
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1380'  and col.name = 'S1')
           Alter Table  HT1380 Add S1 nvarchar(50) Null           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1380'  and col.name = 'S2')
           Alter Table  HT1380 Add S2 nvarchar(50) Null           
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'HT1380'  and col.name = 'S3')
           Alter Table  HT1380 Add S3 nvarchar(50) Null
END
IF EXISTS (SELECT * FROM sysobjects WHERE NAME='HT1380' AND xtype='U')
BEGIN
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1380' AND col.name='Subsidies')
	ALTER TABLE HT1380 ADD Subsidies NVARCHAR (500) NULL	
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1380' AND col.name='IsBreaking')
	ALTER TABLE HT1380 ADD IsBreaking tinyint NULL default(0)	
	IF NOT EXISTS (SELECT * FROM syscolumns col INNER JOIN sysobjects tab 
	ON col.id=tab.id WHERE tab.name='HT1380' AND col.name='LeaveToDate')
	ALTER TABLE HT1380 ADD LeaveToDate Datetime NULL
END
