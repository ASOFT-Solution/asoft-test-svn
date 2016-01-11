-- <Summary>
---- 
-- <History>
---- Create on 09/12/2013 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HTT2433]') AND type in (N'U'))
CREATE TABLE [dbo].[HTT2433]
(
	[APK] [uniqueidentifier] NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](100) NULL,
	[TranMonth] [int]  NULL,
	[TranYear] [int]  NULL,
	[AbsentCardNo] [nvarchar](100)  NULL,
	[AbsentDate] [datetime] NULL,
	[AbsentTime] [nvarchar](200)  NULL,
	[MachineCode] [nvarchar](100) NULL,
	[ShiftCode] [nvarchar](100) NULL,
	[IOCode] [tinyint]  NULL,
	[InputMethod] [tinyint]  NULL,
	[ScanDate] [datetime] NULL
)
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HTT2433_APK]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HTT2433] ADD  CONSTRAINT [DF_HTT2433_APK]  DEFAULT (newid()) FOR [APK]
END

