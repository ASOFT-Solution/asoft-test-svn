-- <Summary>
---- 
-- <History>
---- Create on 11/10/2010 by Thanh Trẫm
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OT3020]') AND type in (N'U'))
CREATE TABLE [dbo].[OT3020](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] nvarchar(3) NOT NULL,
	[VoucherID] [nvarchar](50) NOT NULL,
	[SOKitID] [nvarchar](50) NOT NULL,
	[Quantity] [decimal](28, 8) NULL,
	[SOrderID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_OT3020] PRIMARY KEY CLUSTERED 
(
	[VoucherID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


