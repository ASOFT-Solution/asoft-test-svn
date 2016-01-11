-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Mỹ Tuyền
---- Modified on 23/01/2012 by Bảo Anh
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1606]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1606](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[RevaluateID] [nvarchar](50) NOT NULL,
	[Tranmonth] [int] NULL,
	[Tranyear] [int] NULL,
	[ToolID] [nvarchar](50) NOT NULL,
	[ToolName] [nvarchar](250) NULL,
	[RevaluateNo] [nvarchar](50) NULL,
	[RevaluateDate] [datetime] NULL,
	[Revaluator] [nvarchar](100) NULL,
	[Description] [nvarchar](250) NULL,
	[OriginalOldAmount] [decimal](28, 8) NULL,
	[ConvertedOldAmount] [decimal](28, 8) NULL,
	[DepOldPeriods] [int] NULL,
	[DepOldAmount] [decimal](28, 8) NULL,
	[OldDepartmentID] [nvarchar](50) NULL,
	[DepreciatedPeriods] [int] NULL,
	[AccuDepAmount] [decimal](28, 8) NULL,
	[DepNewPeriods] [decimal](28, 8) NULL,
	[OriginalNewAmount] [decimal](28, 8) NULL,
	[ConvertedNewAmount] [decimal](28, 8) NULL,
	[DepNewAmount] [decimal](28, 8) NULL,
	[DepNewPercent] [decimal](28, 8) NULL,
	[ResidualOldValue] [decimal](28, 8) NULL,
	[ResidualNewValue] [decimal](28, 8) NULL,
	[AccruedDepNewAmount] [decimal](28, 8) NULL,
	[NewMethodID] [int] NULL,
	[IsChange] [int] NULL,
	[NewDepartmentID] [nvarchar](50) NULL,
	[NewEmployeeID] [nvarchar](50) NULL,
	[IsRevaluate] [int] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Status] [tinyint] NULL,
	CONSTRAINT [PK_AT1606] PRIMARY KEY NONCLUSTERED 
	(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add Columns
If Exists (Select * From sysobjects Where name = 'AT1606' and xtype ='U') 
Begin
           If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'AT1606'  and col.name = 'ReVoucherID')
           Alter Table  AT1606 Add ReVoucherID NVARCHAR(50) NULL
End
