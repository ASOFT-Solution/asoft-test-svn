-- <Summary>
---- 
-- <History>
---- Create on 16/10/2013 by Lưu Khánh Vân
---- Modified on ... by ...
---- <Example>
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0305]') AND type in (N'U'))
CREATE TABLE [dbo].[HT0305](
	[APK] [uniqueidentifier] NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[EmployeeID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[ContractNo] [nvarchar](50) NULL,
	[ContractDate] [datetime] NULL,
	[AppliedDate] [datetime] NULL,
	[ContractTypeID][nvarchar](50) NULL,
	[DutyID][nvarchar](50) NULL,
	[InsuranceSalary][decimal]  (28,8) NULL,
	[Salary01][decimal]  (28,8) NULL,
	[Salary02][decimal]  (28,8) NULL,
	[Salary03][decimal]  (28,8) NULL,
	[OrtherSalary][decimal]  (28,8) NULL,
	[SoInsuranceNo][nvarchar](50) NULL,
	[HeInsuranceNo][nvarchar](50) NULL,
	[Description1][nvarchar](50) NULL,
	[Description2] [nvarchar](250) NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL
 CONSTRAINT [PK_HT0305] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[EmployeeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_HT0305_APK]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HT0305] ADD  CONSTRAINT [DF_HT0305_APK]  DEFAULT (newid()) FOR [APK]
END


