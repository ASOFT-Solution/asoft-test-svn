-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Quốc Cường
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1507]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1507](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ReduceID] [nvarchar](50) NOT NULL,
	[Tranmonth] [int] NULL,
	[Tranyear] [int] NULL,
	[AssetID] [nvarchar](50) NOT NULL,
	[AssetName] [nvarchar](250) NULL,
	[OldAssetStatusID] [nvarchar](50) NULL,
	[ReduceNo] [nvarchar](50) NULL,
	[ReduceDate] [datetime] NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[DepartmentID] [nvarchar](50) NULL,
	[AssetUser] [nvarchar](100) NULL,
	[Description] [nvarchar](250) NULL,
	[AssetStatusID] [nvarchar](50) NULL,
	[OriginalReduceFee] [decimal](28, 8) NULL,
	[ConvertedReduceFee] [decimal](28, 8) NULL,
	[OriginalAmount] [decimal](28, 8) NULL,
	[ConvertedAmount] [decimal](28, 8) NULL,
	[ResidualValue] [decimal](28, 8) NULL,
	[AccruedDepAmount] [decimal](28, 8) NULL,
	[OriginalReduceAmount] [decimal](28, 8) NULL,
	[ConvertedReduceAmount] [decimal](28, 8) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[Status] [tinyint] NULL,
	CONSTRAINT [PK_AT1507] PRIMARY KEY NONCLUSTERED 
(
	[APK] ASC
    )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]