-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1523]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1523](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ReduceID] [nvarchar](50) NOT NULL,
	[AssetID] [nvarchar](50) NULL,
	[AssetName] [nvarchar](250) NULL,
	[ReduceMonth] [int] NULL,
	[ReduceYear] [int] NULL,
	[ReduceNo] [nvarchar](50) NULL,
	[ReduceVoucherNo] [nvarchar](50) NULL,
	[ReduceDate] [datetime] NULL,
	[Notes] [nvarchar](250) NULL,
	[OldStatus] [int] NULL,
	[AssetStatus] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[AccuDepAmount] [decimal](28, 8) NULL,
	[RemainAmount] [decimal](28, 8) NULL,
	[DepPeriods] [int] NULL,
	[DepreciatedMonths] [int] NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[EmployeeID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1523] PRIMARY KEY CLUSTERED 
(
	[ReduceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AT1523_AssetStatus]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AT1523] ADD  CONSTRAINT [DF_AT1523_AssetStatus]  DEFAULT ((3)) FOR [AssetStatus]
END