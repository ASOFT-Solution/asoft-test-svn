-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Minh Lâm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT2803]') AND type in (N'U'))
CREATE TABLE [dbo].[HT2803](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmpLoaMonthID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[WorkTerm] [decimal](28, 8) NULL,
	[DaysPrevYear] [decimal](28, 8) NULL,
	[DaysInYear] [decimal](28, 8) NULL,
	[DaysSpent] [decimal](28, 8) NULL,
	[DaysRemained] [decimal](28, 8) NULL,
	[IsAdded] [tinyint] NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_HT2802] PRIMARY KEY CLUSTERED 
(
	[EmpLoaMonthID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT2802_IsAdded]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT2803] ADD  CONSTRAINT [DF_HT2802_IsAdded]  DEFAULT ((1)) FOR [IsAdded]
END