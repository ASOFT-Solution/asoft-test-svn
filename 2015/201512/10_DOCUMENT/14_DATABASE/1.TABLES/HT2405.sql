-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2405]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2405](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[AdvanceID] [nvarchar](50) NOT NULL,
	[Orders] [int] NOT NULL,
	[AdvanceDate] [datetime] NOT NULL,
	[AdvanceNo] [nvarchar](50) NULL,
	[AdvanceReason] [nvarchar](250) NULL,
	[AdvanceAmount] [decimal](28, 8) NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT2405] PRIMARY KEY NONCLUSTERED 
(
	[AdvanceID] ASC,
	[Orders] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

