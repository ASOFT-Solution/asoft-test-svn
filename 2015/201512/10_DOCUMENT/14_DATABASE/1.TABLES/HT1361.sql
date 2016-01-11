-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1361]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1361](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[SignPersonID] [nvarchar](50) NULL,
	[SignDate] [datetime] NULL,
	[ContractTypeID] [nvarchar](50) NULL,
	[WorkDate] [datetime] NULL,
	[WorkEndDate] [datetime] NULL,
	[TestFromDate] [datetime] NULL,
	[TestEndDate] [datetime] NULL,
	[WorkAddress] [nvarchar](250) NULL,
	[WorkTime] [nvarchar](250) NULL,
	[IssueTool] [nvarchar](250) NULL,
	[Conveyance] [nvarchar](250) NULL,
	[PayForm] [nvarchar](250) NULL,
	[RestRegulation] [nvarchar](250) NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LstModifyUserID] [nvarchar](50) NULL,
	CONSTRAINT [PK_HT1361] PRIMARY KEY CLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
