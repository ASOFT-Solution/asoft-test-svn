IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMLHD]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[DMLHD](
	[MaLoaiHD] [varchar](16) NOT NULL,
	[TenLoaiHD] [nvarchar](128) NOT NULL,
	[TenLoaiHD2] [nvarchar](128) NULL,
 CONSTRAINT [PK_DMLHD] PRIMARY KEY CLUSTERED 
(
	[MaLoaiHD] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMLHD]') AND type in (N'U'))
BEGIN

if not exists (select top 1 1 from DMLHD where MaLoaiHD = '01')
INSERT INTO [DMLHD](MaLoaiHD, [TenLoaiHD],[TenLoaiHD2])
VALUES( '01', N'Hóa đơn giá trị gia tăng', NULL)

if not exists (select top 1 1 from DMLHD where MaLoaiHD = '02')
INSERT INTO [DMLHD](MaLoaiHD, [TenLoaiHD],[TenLoaiHD2])
VALUES( '02', N'Hóa đơn thông thường', NULL)

if not exists (select top 1 1 from DMLHD where MaLoaiHD = '03')
INSERT INTO [DMLHD](MaLoaiHD, [TenLoaiHD],[TenLoaiHD2])
VALUES( '03', N'Không có hóa đơn', NULL)

END