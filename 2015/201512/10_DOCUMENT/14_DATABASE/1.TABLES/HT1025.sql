-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1025]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1025](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,	
	[EmployeeID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[D01] [nvarchar](50) NULL,
	[D02] [nvarchar](50) NULL,
	[D03] [nvarchar](50) NULL,
	[D04] [nvarchar](50) NULL,
	[D05] [nvarchar](50) NULL,
	[D06] [nvarchar](50) NULL,
	[D07] [nvarchar](50) NULL,
	[D08] [nvarchar](50) NULL,
	[D09] [nvarchar](50) NULL,
	[D10] [nvarchar](50) NULL,
	[D11] [nvarchar](50) NULL,
	[D12] [nvarchar](50) NULL,
	[D13] [nvarchar](50) NULL,
	[D14] [nvarchar](50) NULL,
	[D15] [nvarchar](50) NULL,
	[D16] [nvarchar](50) NULL,
	[D17] [nvarchar](50) NULL,
	[D18] [nvarchar](50) NULL,
	[D19] [nvarchar](50) NULL,
	[D20] [nvarchar](50) NULL,
	[D21] [nvarchar](50) NULL,
	[D22] [nvarchar](50) NULL,
	[D23] [nvarchar](50) NULL,
	[D24] [nvarchar](50) NULL,
	[D25] [nvarchar](50) NULL,
	[D26] [nvarchar](50) NULL,
	[D27] [nvarchar](50) NULL,
	[D28] [nvarchar](50) NULL,
	[D29] [nvarchar](50) NULL,
	[D30] [nvarchar](50) NULL,
	[D31] [nvarchar](50) NULL,
	[Notes] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_HT1025] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

