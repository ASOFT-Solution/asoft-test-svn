-- <Summary>
---- 
-- <History>
---- Create on 09/06/2014 by Huỳnh Tấn Phú
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CST2022]') AND type in (N'U')) 	
BEGIN	
CREATE TABLE [dbo].[CST2022](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](50) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[OrderNo] [int] NULL,	
	[Code] [nvarchar](50) NULL,
	[StatusID] [nvarchar](50) NULL,
	[ProPosed] [nvarchar](50) NULL,	
	[RepairPersonID] [nvarchar](50) NULL,	
	[RepairNotes] [nvarchar](250) NULL,
 CONSTRAINT [PK_CST2022] PRIMARY KEY CLUSTERED 
(
	[DivisionID] ASC,
	[VoucherID] ASC,
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END