-- <Summary>
---- 
-- <History>
---- Create on 06/08/2010 by Việt Khánh
---- Modified on ... by ...
---- <Example>
IF NOT EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CT0005]') AND type in (N'U'))
CREATE TABLE [dbo].[CT0005](
    [APK] [uniqueidentifier] DEFAULT NEWID(),
    [DivisionID] [nvarchar] (3) NOT NULL,
	[TypeID] [nvarchar](50) NOT NULL,
	[SystemName] [nvarchar](250) NULL,
	[UserName] [nvarchar](250) NULL,
	[IsUsed] [tinyint] NOT NULL,
	[UserNameE] [nvarchar](250) NULL,
CONSTRAINT [PK_CT0005] PRIMARY KEY CLUSTERED 
(
	[TypeID] ASC,
	[DivisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
---- Add giá trị default
IF NOT EXISTS(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_CT0005_IsUsed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CT0005] ADD  CONSTRAINT [DF_CT0005_IsUsed]  DEFAULT ((1)) FOR [IsUsed]
END
---- Add giá trị default
-- Thêm cột SystemNameE vào bảng CT0005
IF(ISNULL(COL_LENGTH('CT0005', 'SystemNameE'), 0) <= 0)
ALTER TABLE CT0005 ADD SystemNameE NVARCHAR(50) NULL