-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CT5003]') AND type in (N'U'))
CREATE TABLE [dbo].[CT5003](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[RequestNo] [nvarchar](50) NOT NULL,
	[WMFileID] [nvarchar](50) NOT NULL,
	[WMFileName] [nvarchar](250) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[ObjectName] [nvarchar](250) NULL,
	[Address] [nvarchar](250) NULL,
	[Contactor] [nvarchar](100) NULL,
	[Mobile] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[PositionMan] [nvarchar](100) NULL,
	[RecordMan] [nvarchar](100) NULL,
	[AssignMan] [nvarchar](100) NULL,
	[PerformMan] [nvarchar](100) NULL,
	[PerformManName] [nvarchar](250) NULL,
	[RecordDate] [datetime] NOT NULL,
	[PerformDate] [datetime] NULL,
	[PerFormTime] [nvarchar](100) NULL,
	[InventoryID] [nvarchar](50) NULL,
	[Serial] [nvarchar](50) NULL,
	[Place] [nvarchar](100) NULL,
	[RecordStatus] [nvarchar](250) NOT NULL,
	[Notes] [nvarchar](250) NULL,
	[WProducer] [int] NULL,
	[WCompany] [int] NULL,
	[Timelimit] [int] NULL,
	[IsUpDateName] [int] NULL,
	[IsSystem] [int] NULL,
	[Status] [int] NULL,
	[Disabled] [tinyint] NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[RecordTime] [nvarchar](50) NULL,
 CONSTRAINT [PK_CT5003] PRIMARY KEY CLUSTERED 
(
	[VoucherID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]