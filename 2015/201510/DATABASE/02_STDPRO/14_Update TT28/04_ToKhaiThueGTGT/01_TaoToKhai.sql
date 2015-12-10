--2) Them table MToKhai
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MToKhai]') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[MToKhai](
	[MToKhaiID] [uniqueidentifier] NOT NULL,
	[Stt] [int] IDENTITY(1,1) NOT NULL,
	[KyToKhai] [int] NOT NULL,
	[NamToKhai] [int] NOT NULL,
	[NgayToKhai] [smalldatetime] NOT NULL,
	[DienGiai] [nvarchar](128) NULL,
	[InLanDau] [bit] NOT NULL,
	[SoLanIn] [int] NULL
 CONSTRAINT [PK_MToKhai] PRIMARY KEY CLUSTERED 
(
	[MToKhaiID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

GO

--2) Them table DToKhai
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DToKhai]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DToKhai](
	[DToKhaiID] [uniqueidentifier] NOT NULL,
	[MToKhaiID] [uniqueidentifier] NOT NULL,
	[Stt] [nvarchar](128) NOT NULL,
	[ChiTieu] [nvarchar](512) NOT NULL,
	[CodeGT] [nvarchar](128) NULL,
	[GTHHDV] [decimal](20, 6) NOT NULL,
	[CodeThue] [nvarchar](128) NULL,
	[ThueGTGT] [decimal](20, 6) NOT NULL,
	[SortOrder] [int] NOT NULL,
 CONSTRAINT [PK_DToKhai] PRIMARY KEY CLUSTERED 
(
	[DToKhaiID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DToKhai]  WITH CHECK ADD  CONSTRAINT [FK_DToKhai_MToKhai2] FOREIGN KEY([MToKhaiID])
REFERENCES [dbo].[MToKhai] ([MToKhaiID])

ALTER TABLE [dbo].[DToKhai] CHECK CONSTRAINT [FK_DToKhai_MToKhai2]

ALTER TABLE [dbo].[DToKhai] ADD  CONSTRAINT [DF_DToKhai_GTHHDV]  DEFAULT ('0') FOR [GTHHDV]

ALTER TABLE [dbo].[DToKhai] ADD  CONSTRAINT [DF_DToKhai_ThueGTGT]  DEFAULT ('0') FOR [ThueGTGT]

END

--4) Tao du lieu to khai mau
if exists (Select id from SysObjects Where id = Object_ID('ToKhai') And xType = 'U')
drop table ToKhai

CREATE TABLE [dbo].[ToKhai](
	[SortOrder] [int] NOT NULL,
	[Stt] [nvarchar](128) NOT NULL,
	[ChiTieu] [nvarchar](512) NOT NULL,
	[CodeGT] [nvarchar](128) NULL,
	[GTHHDV] [decimal](20, 6) NOT NULL,
	[CodeThue] [nvarchar](128) NULL,
	[ThueGTGT] [decimal](20, 6) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[ToKhai] ADD  CONSTRAINT [DF_ToKhai_SortOrder]  DEFAULT ('0') FOR [SortOrder]

ALTER TABLE [dbo].[ToKhai] ADD  CONSTRAINT [DF_ToKhai_GTHHDV]  DEFAULT ('0') FOR [GTHHDV]

ALTER TABLE [dbo].[ToKhai] ADD  CONSTRAINT [DF_ToKhai_ThueGTGT]  DEFAULT ('0') FOR [ThueGTGT]

GO

INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (1, N'A', N'Không phát sinh hoạt động mua, bán trong kỳ (đánh dấu "X")', N'[21]', CAST(0.000000 AS Decimal(20, 6)), NULL, CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (2, N'B', N'Thuế GTGT còn được khấu trừ kỳ trước chuyển sang', NULL, CAST(0.000000 AS Decimal(20, 6)), N'[22]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (3, N'C', N'Kê khai thuế GTGT phải nộp Ngân sách nhà nước', NULL, CAST(0.000000 AS Decimal(20, 6)), NULL, CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (4, N'I', N'Hàng hoá, dịch vụ (HHDV) mua vào trong kỳ', NULL, CAST(0.000000 AS Decimal(20, 6)), NULL, CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (5, N'1', N'Giá trị và thuế GTGT của hàng hoá, dịch vụ mua vào', N'[23]', CAST(0.000000 AS Decimal(20, 6)), N'[24]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (6, N'2', N'Tổng số thuế GTGT  được khấu trừ kỳ này', NULL, CAST(0.000000 AS Decimal(20, 6)), N'[25]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (7, N'II', N'Hàng hoá, dịch vụ bán ra trong kỳ', NULL, CAST(0.000000 AS Decimal(20, 6)), NULL, CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (8, N'1', N'Hàng hóa, dịch vụ bán ra không chịu thuế GTGT ', N'[26]', CAST(0.000000 AS Decimal(20, 6)), NULL, CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (9, N'2', N'Hàng hóa, dịch vụ bán ra chịu thuế GTGT ([27]= [29]+[30]+[32]; [28]= [31]+[33])', N'[27]', CAST(0.000000 AS Decimal(20, 6)), N'[28]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (10, N'a', N'Hàng hoá, dịch vụ bán ra chịu thuế suất 0%', N'[29]', CAST(0.000000 AS Decimal(20, 6)), NULL, CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (11, N'b', N'Hàng hoá, dịch vụ bán ra chịu thuế suất 5%', N'[30]', CAST(0.000000 AS Decimal(20, 6)), N'[31]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (12, N'c', N'Hàng hoá, dịch vụ bán ra chịu thuế suất 10%', N'[32]', CAST(0.000000 AS Decimal(20, 6)), N'[33]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (13, N'3', N'Tổng doanh thu và thuế GTGT của HHDV bán ra ([34] = [26] + [27]; [35] = [28])', N'[34]', CAST(0.000000 AS Decimal(20, 6)), N'[35]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (14, N'III', N'Thuế GTGT phát sinh trong kỳ ([36] = [35] - [25])', NULL, CAST(0.000000 AS Decimal(20, 6)), N'[36]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (15, N'IV', N'Điều chỉnh tăng, giảm thuế GTGT của các kỳ trước', NULL, CAST(0.000000 AS Decimal(20, 6)), NULL, CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (16, N'1', N'Điều chỉnh tăng thuế GTGT của các kỳ trước', NULL, CAST(0.000000 AS Decimal(20, 6)), N'[37]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (17, N'2', N'Điều chỉnh giảm thuế GTGT của các kỳ trước', NULL, CAST(0.000000 AS Decimal(20, 6)), N'[38]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (18, N'V', N'Tổng số thuế GTGT đã nộp của doanh thu kinh doanh xây dựng, lắp đặt, bán hàng vãng lai ngoại tỉnh', NULL, CAST(0.000000 AS Decimal(20, 6)), N'[39]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (19, N'VI', N'Xác định nghĩa vụ thuế GTGT phải nộp trong kỳ:', NULL, CAST(0.000000 AS Decimal(20, 6)), NULL, CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (20, N'1', N'Thuế GTGT phải nộp của hoạt động sản xuất kinh doanh trong kỳ (nếu [40a] = [36] - [22] + [37] - [38] -[39] >0)', NULL, CAST(0.000000 AS Decimal(20, 6)), N'[40a]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (21, N'2', N'Thuế GTGT mua vào của dự án đầu tư (cùng tỉnh, thành phố trực thuộc trung ương) được bù trừ với thuế GTGT phải nộp của hoạt động sản xuất kinh doanh cùng kỳ tính thuế ', NULL, CAST(0.000000 AS Decimal(20, 6)), N'[40b]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (22, N'3', N'Thuế GTGT còn phải nộp trong kỳ ([40]=[40a]-[40b])', NULL, CAST(0.000000 AS Decimal(20, 6)), N'[40]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (23, N'4', N'Thuế GTGT chưa khấu trừ hết kỳ này (nếu ([41] = [36] - [22] + [37] - [38] -[39] <0)', NULL, CAST(0.000000 AS Decimal(20, 6)), N'[41]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (24, N'4.1', N'Thuế GTGT đề nghị hoàn', NULL, CAST(0.000000 AS Decimal(20, 6)), N'[42]', CAST(0.000000 AS Decimal(20, 6)))
INSERT [dbo].[ToKhai] ([SortOrder], [Stt], [ChiTieu], [CodeGT], [GTHHDV], [CodeThue], [ThueGTGT]) VALUES (25, N'4.2', N'Thuế GTGT còn được khấu trừ chuyển kỳ sau ([43] = [41] - [42])', NULL, CAST(0.000000 AS Decimal(20, 6)), N'[43]', CAST(0.000000 AS Decimal(20, 6)))
