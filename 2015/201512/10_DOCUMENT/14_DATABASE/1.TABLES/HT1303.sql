-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Cam Loan
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1303]') AND type in (N'U'))
CREATE TABLE [dbo].[HT1303](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[EmpAssignedID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[FromDate] [datetime] NULL,
	[NumberOfDays] [decimal](28, 8) NULL,
	[ToPlace] [nvarchar](50) NULL,
	[Price] [decimal](28, 8) NULL,
	[AbsentTypeID] [nvarchar](50) NOT NULL,
	[IsTimeKeeping] [tinyint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[AbsentAmount] [decimal](28, 8) NULL,
 CONSTRAINT [PK_HT1303] PRIMARY KEY CLUSTERED 
(
	[EmpAssignedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT1303_IsTimeKeeping]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT1303] ADD  CONSTRAINT [DF_HT1303_IsTimeKeeping]  DEFAULT ((0)) FOR [IsTimeKeeping]
END
