-- <Summary>
---- Định nghĩa tham số
-- <History>
---- Create on 08/06/2010 by Tố Oanh
---- Modified on 30/01/2011 by Việt Khánh: Thêm cột SystemNameE vào bảng AT0009
-- <Example>
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AT0009]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AT0009](
	[APK] [uniqueidentifier] DEFAULT NEWID(),
	[DivisionID] [nvarchar](3) NOT NULL,
	[TypeID] [nvarchar](50) NOT NULL,
	[SystemName] [nvarchar](250) NULL,
	[UserName] [nvarchar](250) NULL,
	[IsUsed] [tinyint] NOT NULL,
	[UserNameE] [nvarchar](250) NULL,
 CONSTRAINT [PK_AT0009] PRIMARY KEY CLUSTERED 
(
	[TypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
---- Add Columns
IF(ISNULL(COL_LENGTH('AT0009', 'SystemNameE'), 0) <= 0)
ALTER TABLE AT0009 ADD SystemNameE NVARCHAR(50) NULL

