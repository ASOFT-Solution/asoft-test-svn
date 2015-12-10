IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMLThue]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[DMLThue](
	[MaLoaiThue] [int] NOT NULL,
	[TenLoaiThue] [nvarchar](128) NOT NULL,
	[TenLoaiThue2] [nvarchar](128) NULL,
 CONSTRAINT [PK_DMLThue] PRIMARY KEY CLUSTERED 
(
	[MaLoaiThue] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMLThue]') AND type in (N'U'))
BEGIN

if not exists (select top 1 1 from DMLThue where MaLoaiThue = 1)
INSERT INTO [DMLThue](MaLoaiThue, [TenLoaiThue],[TenLoaiThue2])
VALUES( 1, N'Hàng hóa, dịch vụ riêng cho SXKD chịu thuế GTGT đủ điều kiện khấu trừ thuế', NULL)

if not exists (select top 1 1 from DMLThue where MaLoaiThue = 2)
INSERT INTO [DMLThue](MaLoaiThue, [TenLoaiThue],[TenLoaiThue2])
VALUES( 2, N'Hàng hóa, dịch vụ không đủ điều kiện khấu trừ thuế', NULL)

if not exists (select top 1 1 from DMLThue where MaLoaiThue = 3)
INSERT INTO [DMLThue](MaLoaiThue, [TenLoaiThue],[TenLoaiThue2])
VALUES( 3, N'Hàng hóa, dịch vụ dùng chung cho SXKD chịu thuế và không chịu thuế đủ điều kiện khấu trừ', NULL)

if not exists (select top 1 1 from DMLThue where MaLoaiThue = 4)
INSERT INTO [DMLThue](MaLoaiThue, [TenLoaiThue],[TenLoaiThue2])
VALUES( 4, N'Hàng hóa, dịch vụ dùng cho dự án đầu tư đủ điều kiện được khấu trừ thuế', NULL)

if not exists (select top 1 1 from DMLThue where MaLoaiThue = 5)
INSERT INTO [DMLThue](MaLoaiThue, [TenLoaiThue],[TenLoaiThue2])
VALUES( 5, N'Hàng hóa, dịch vụ không phải tổng hợp trên tờ khai 01/GTGT', NULL)

END