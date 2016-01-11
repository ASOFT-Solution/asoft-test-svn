-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2407]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2407](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[AbsentCardNo] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[AbsentDate] [datetime] NULL,
	[ShiftID] [nvarchar](50) NULL,
	[Orders] [int] NULL,
	[FromTime] [datetime] NULL,
	[ToTime] [datetime] NULL,
	[AbsentHour] [decimal](28, 8) NULL,
	[TypeShiftID] [int] NULL,
	[FromTimeValid] [datetime] NULL,
	[ToTimevalid] [datetime] NULL,
	[BeginShiftID] [tinyint] NULL,
	[EndShiftID] [tinyint] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifydate] [datetime] NULL,
	[AbsentTypeID] [nvarchar](50) NULL,
	[RestrictID] [nvarchar](50) NULL,
	[InEarlyMinutes] [int] NULL,
	[InLateMinutes] [int] NULL,
	[OutEarlyMinutes] [int] NULL,
	[OutLateMinutes] [int] NULL,
	[DeductMinutes] [int] NULL,
	[Coefficient] [decimal](28, 8) NULL,
	[DeductTotal] [int] NULL,
 CONSTRAINT [PK_HT2407] PRIMARY KEY NONCLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
