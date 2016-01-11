-- <Summary>
---- Danh mục mã phụ (Đính kèm trong danh mục mặt hàng, mỗi mặt hàng hàng có nhiều mã phụ và 1 mã phụ có nhiều mặt hàng)
-- <History>
---- Create on 21/07/2015 by Hoàng Vũ
---- Modified on 21/07/2015 by Hoàng Vũ: Customize index secoin = 43 
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1320]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1320](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ExtraID] [nvarchar](50) NOT NULL,
	[InventoryID] [nvarchar](50) NOT NULL,
	[ExtraName] [nvarchar](250) NULL,
	[Disabled] [tinyint] NOT NULL,
	[Orders] [int] NULL,
	[Note] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
 CONSTRAINT [PK_AT1320] PRIMARY KEY CLUSTERED 
(
	[APK] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
