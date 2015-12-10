IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMLCTThue]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[DMLCTThue](
	[MaLCTThue] [int] NOT NULL,
	[TenLCTThue] [nvarchar](128) NOT NULL,
	[TenLCTThue2] [nvarchar](128) NULL,
	[TK1] [nvarchar](128) NULL,
	[TKDU1] [nvarchar](128) NULL,
	[TK2] [nvarchar](128) NULL,
	[TKDU2] [nvarchar](128) NULL,
 CONSTRAINT [PK_DMLCTThue] PRIMARY KEY CLUSTERED 
(
	[MaLCTThue] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

IF NOT EXISTS (SELECT TOP 1 1 FROM [DMLCTThue] WHERE [MaLCTThue] = 1)
INSERT INTO [DMLCTThue]([MaLCTThue], [TenLCTThue], [TenLCTThue2], [TK1], [TKDU1], [TK2], [TKDU2])
VALUES(1, N'Khấu trừ thuế', N'Tax Deduction', N'33311', N'1331', N'33311', N'1332')

IF NOT EXISTS (SELECT TOP 1 1 FROM [DMLCTThue] WHERE [MaLCTThue] = 2)
INSERT INTO [DMLCTThue]([MaLCTThue], [TenLCTThue], [TenLCTThue2], [TK1], [TKDU1], [TK2], [TKDU2])
VALUES(2, N'Điều chỉnh giảm thuế GTGT mua vào', NULL, NULL, N'1331', NULL, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [DMLCTThue] WHERE [MaLCTThue] = 3)
INSERT INTO [DMLCTThue]([MaLCTThue], [TenLCTThue], [TenLCTThue2], [TK1], [TKDU1], [TK2], [TKDU2])
VALUES(3, N'Điều chỉnh tăng thuế GTGT mua vào', NULL, N'1331', NULL, NULL, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [DMLCTThue] WHERE [MaLCTThue] = 4)
INSERT INTO [DMLCTThue]([MaLCTThue], [TenLCTThue], [TenLCTThue2], [TK1], [TKDU1], [TK2], [TKDU2])
VALUES(4, N'Điều chỉnh giảm thuế GTGT bán ra', NULL, N'33311', NULL, NULL, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [DMLCTThue] WHERE [MaLCTThue] = 5)
INSERT INTO [DMLCTThue]([MaLCTThue], [TenLCTThue], [TenLCTThue2], [TK1], [TKDU1], [TK2], [TKDU2])
VALUES(5, N'Điều chỉnh tăng thuế GTGT bán ra', NULL, NULL, N'33311', NULL, NULL)

IF NOT EXISTS (SELECT TOP 1 1 FROM [DMLCTThue] WHERE [MaLCTThue] = 6)
INSERT INTO [DMLCTThue]([MaLCTThue], [TenLCTThue], [TenLCTThue2], [TK1], [TKDU1], [TK2], [TKDU2])
VALUES(6, N'Hoàn thuế', NULL, NULL, NULL, NULL, NULL)