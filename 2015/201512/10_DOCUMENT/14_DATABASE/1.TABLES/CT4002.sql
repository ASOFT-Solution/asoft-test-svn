-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CT4002]') AND type in (N'U'))
CREATE TABLE [dbo].[CT4002](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[ReVoucherID] [nvarchar](50) NULL,
	[RequestNo] [nvarchar](50) NULL,
	[Finish] [tinyint] NULL,
	[WMFileID] [nvarchar](50) NOT NULL,
	[CaseID] [nvarchar](50) NULL,
	[TaskID] [nvarchar](50) NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[Serial] [nvarchar](50) NULL,
	[UnitID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[ErrorStatusID] [nvarchar](50) NULL,
	[ErrorLevelID] [nvarchar](50) NULL,
	[ErrorTypeID] [nvarchar](50) NULL,
	[FileLog] [nvarchar](100) NULL,
	[ErrorIssueID] [nvarchar](50) NULL,
	[Repair] [nvarchar](100) NULL,
	[Signature01] [tinyint] NULL,
	[IsTest] [tinyint] NULL,
	[FixDate] [datetime] NULL,
	[StartTime] [nvarchar](100) NULL,
	[EndTime] [nvarchar](100) NULL,
	[MonitorTime] [tinyint] NULL,
	[FixNextDate] [datetime] NULL,
	[Signature02] [tinyint] NULL,
	[Notes01] [nvarchar](250) NULL,
	[Notes02] [nvarchar](250) NULL,
	[Notes03] [nvarchar](250) NULL,
	[Notes04] [nvarchar](250) NULL,
	[Notes05] [nvarchar](250) NULL,
	[IsReplace] [int] NULL,
	[TimelinessID] [nvarchar](50) NULL,
	[MannerID] [nvarchar](50) NULL,
	[QualityID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	CONSTRAINT [PK_CT4002] PRIMARY KEY NONCLUSTERED 
	(
		[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
