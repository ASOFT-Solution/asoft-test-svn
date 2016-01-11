-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CT6002]') AND type in (N'U'))
CREATE TABLE [dbo].[CT6002](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[Phonenumber] [nvarchar](50) NULL,
	[Contact] [nvarchar](100) NULL,
	[ObjectID] [nvarchar](50) NULL,
	[ContractNo] [nvarchar](50) NULL,
	[MessageText] [nvarchar](100) NULL,
	[Dates] [smalldatetime] NULL,
	[Status] [tinyint] NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[OutBoxID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_CT6002] PRIMARY KEY CLUSTERED 
(
	[OutBoxID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]