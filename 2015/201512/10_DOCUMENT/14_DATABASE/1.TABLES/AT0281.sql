-- <Summary>
---- 
-- <History>
---- Create on 30/06/2014 by Lê Thị Thu Hiền
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0281]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0281](
	[APK] UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
	[DivisionID] [nvarchar](50) NOT NULL,
	[UserID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[TranMonth] [int] NOT NULL,
	[TranYear] [int] NOT NULL,
	[AnaID] [nvarchar](50) NOT NULL,
	[VoucherDate] [datetime] NOT NULL,
	[APKMaster] [nvarchar](50) NOT NULL,	
	[VoucherNo] [nvarchar](50) NOT NULL,	
	[MemberID] [nvarchar](50) NOT NULL,	
	[MemberName] [nvarchar](500) NOT NULL,	
	[TotalAmount] [decimal](28, 8) NULL,
	[TotalDiscountAmount] [decimal](28, 8) NULL,
	[TotalRedureAmount] [decimal](28, 8) NULL,
	[TotalInventoryAmount] [decimal](28, 8) NULL,
	[TransferredAPK] [nvarchar](50) NULL,	
	[SalesVoucherNo] [nvarchar](50) NULL,	
	[WareVoucherNo] [nvarchar](50) NULL,		
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,	
 CONSTRAINT [PK_AT0281] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[UserID] ASC,
	[VoucherDate] ASC,
	[AnaID] ASC,
	[APKMaster] ASC,
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]	
END
