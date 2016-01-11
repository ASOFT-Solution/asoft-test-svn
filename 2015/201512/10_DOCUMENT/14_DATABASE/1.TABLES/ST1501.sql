-- <Summary>
---- 
-- <History>
---- Create on 09/08/2010 by Ngoc Nhut
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ST1501]') AND type in (N'U'))
CREATE TABLE [dbo].[ST1501](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[SMSComSys] [tinyint] NULL,
	[SpeedSys] [int] NULL,
	[ParitySys] [tinyint] NULL,
	[BitStopSys] [decimal](28, 8) NULL,
	[DataBitSys] [tinyint] NULL,
	[SMSComUser] [tinyint] NULL,
	[SpeedUser] [int] NULL,
	[ParityUser] [tinyint] NULL,
	[BitStopUser] [decimal](28, 8) NULL,
	[DataBitUser] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	CONSTRAINT [PK_ST1501] PRIMARY KEY NONCLUSTERED 
	(	
		[APK] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]