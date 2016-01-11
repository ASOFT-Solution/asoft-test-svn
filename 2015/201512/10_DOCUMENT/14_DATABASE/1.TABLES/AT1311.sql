-- <Summary>
---- Danh mục mã phụ (theo quản trị khách hàng)
-- <History>
---- Create on 21/07/2015 by Hoàng Vũ
---- Modified on 21/07/2015 by Hoàng Vũ: Customize index secoin = 43 
---- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT1311]') AND type in (N'U'))
CREATE TABLE [dbo].[AT1311](
	[APK] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[DivisionID] [nvarchar](3) NOT NULL,
	[ExtraID] [nvarchar](50) NOT NULL,
	[ExtraName] [nvarchar](250) NOT NULL,
	[Disabled] [tinyint] NOT NULL,
	[Note] [nvarchar](250) NULL,
	[Note01] [nvarchar](250) NULL,
	[Note02] [nvarchar](250) NULL,
	[Note03] [nvarchar](250) NULL,
	[Note04] [nvarchar](250) NULL,
	[Note05] [nvarchar](250) NULL,
	[Note06] [nvarchar](250) NULL,
	[Note07] [nvarchar](250) NULL,
	[Note08] [nvarchar](250) NULL,
	[Note09] [nvarchar](250) NULL,
	[Note10] [nvarchar](250) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserID] [nvarchar](50) NULL,
	[LastModifyDate] [datetime] NULL,
	[LastModifyUserID] [nvarchar](50) NULL,
 CONSTRAINT [PK_AT1311] PRIMARY KEY CLUSTERED 
(
	[ExtraID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


