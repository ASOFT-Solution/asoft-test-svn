-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Tố Oanh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MT1614]') AND type in (N'U'))
CREATE TABLE [dbo].[MT1614](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[PeriodID] [nvarchar](50) NOT NULL,
	[ProductID] [nvarchar](50) NULL,
	[Cost] [decimal](28, 8) NULL,
	[CostUnit] [decimal](28, 8) NULL,
	[ProductQuantity] [decimal](28, 8) NULL,
	[EmployeeID] [nvarchar](50) NULL,
	[VoucherDate] [datetime] NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[TransactionID] [nvarchar](50) NOT NULL,
	[LastModifyDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[TranMonth] [int] NULL,
	[TranYear] [int] NULL,
	[VoucherTypeID] [nvarchar](50) NULL,
	[Cost621] [decimal](28, 8) NULL,
	[Cost622] [decimal](28, 8) NULL,
	[Cost627] [decimal](28, 8) NULL,
	[BeginningInprocessCost] [decimal](28, 8) NULL,
	[AriseCost] [decimal](28, 8) NULL,
	[EndInprocessCost] [decimal](28, 8) NULL,
	[Description] [nvarchar](250) NULL,
 CONSTRAINT [PK_MT1614] PRIMARY KEY NONCLUSTERED 
(
	[VoucherID] ASC,
	[TransactionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

