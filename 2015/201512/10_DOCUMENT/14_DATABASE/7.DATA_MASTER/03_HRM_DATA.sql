IF OBJECT_ID ('HX1400', 'TR') IS NOT NULL
	DROP TRIGGER HX1400;
	
IF OBJECT_ID ('HY1400', 'TR') IS NOT NULL
	DROP TRIGGER HY1400;
	
Update HT0006 set ParentID = null WHERE ParentID =''

/****** Object:  Table [dbo].[HT0018STD]    Script Date: 01/12/2012 11:06:37 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0018STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HT0018STD](
	[ImportMethod] [nvarchar](100) NOT NULL,
	[Tab_char] [tinyint] NOT NULL,
	[Space_char] [tinyint] NOT NULL,
	[Semilicon_char] [tinyint] NOT NULL,
	[Comma_char] [tinyint] NOT NULL,
	[Others_char] [tinyint] NOT NULL,
	[Others_Define] [nchar](100) NULL,
	[S_InCode] [nvarchar](50) NULL,
	[S_OutCode] [nvarchar](50) NULL
) ON [PRIMARY]
END
DELETE [HT0018STD]
INSERT [dbo].[HT0018STD] ([ImportMethod], [Tab_char], [Space_char], [Semilicon_char], [Comma_char], [Others_char], [Others_Define], [S_InCode], [S_OutCode]) VALUES (N'CC', 0, 0, 0, 0, 0, N'-', N'IN', N'OUT')

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT6666STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HT6666STD](
	[PeriodID] [nvarchar](50) NOT NULL,
	[PeriodName] [nvarchar](50) NULL,
	[IsDefault] [tinyint] NOT NULL
) ON [PRIMARY]
END
IF NOT EXISTS(SELECT TOP 1 * FROM HT6666STD WHERE PeriodID = N'P01')
BEGIN
	INSERT dbo.HT6666STD (PeriodID, PeriodName, IsDefault) VALUES (N'P01', N'Kỳ I', 1)
END	
IF NOT EXISTS(SELECT TOP 1 * FROM HT6666STD WHERE PeriodID = N'P02')
BEGIN
	INSERT dbo.HT6666STD (PeriodID, PeriodName, IsDefault) VALUES (N'P02', N'Kỳ II', 0)
END	

/****** Object:  Table [dbo].[HT0017STD]    Script Date: 01/11/2012 17:18:24 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0017STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HT0017STD](
	[ParaID] [nvarchar](50) NOT NULL,
	[Parameter] [nvarchar](50) NOT NULL,
	[ParameterE] [nvarchar](50) NULL,
	[Position] [int] NOT NULL,
	[Width] [int] NULL,
	[IsUsed] [tinyint] NOT NULL,
	[ViewIndex] [int] NOT NULL
) ON [PRIMARY]
END
DELETE [HT0017STD]
INSERT [dbo].[HT0017STD] ([ParaID], [Parameter], [ParameterE], [Position], [Width], [IsUsed], [ViewIndex]) VALUES (N'PBAR', N'Vị trí cột mã thẻ', N'Barcode position column', 1, 5, 1, 0)
INSERT [dbo].[HT0017STD] ([ParaID], [Parameter], [ParameterE], [Position], [Width], [IsUsed], [ViewIndex]) VALUES (N'PDAY', N'Vị trí cột ngày', N'Day position column', 2, 10, 1, 1)
INSERT [dbo].[HT0017STD] ([ParaID], [Parameter], [ParameterE], [Position], [Width], [IsUsed], [ViewIndex]) VALUES (N'PDMY', N'Vị trí côt ngày-tháng-năm', N'dd-mm-yyyy position column', 2, 10, 0, 4)
INSERT [dbo].[HT0017STD] ([ParaID], [Parameter], [ParameterE], [Position], [Width], [IsUsed], [ViewIndex]) VALUES (N'PHMS', N'Vị trí cột giờ:phút:giây', N'hh:mm:ss position column', 3, 8, 0, 8)
INSERT [dbo].[HT0017STD] ([ParaID], [Parameter], [ParameterE], [Position], [Width], [IsUsed], [ViewIndex]) VALUES (N'PHOU', N'Vị trí cột giờ', N'Hour position column', 0, 2, 0, 5)
INSERT [dbo].[HT0017STD] ([ParaID], [Parameter], [ParameterE], [Position], [Width], [IsUsed], [ViewIndex]) VALUES (N'PIOS', N'Vị trí cột mã vào/ra ca', N'In/Out shift position column', 1, 3, 0, 11)
INSERT [dbo].[HT0017STD] ([ParaID], [Parameter], [ParameterE], [Position], [Width], [IsUsed], [ViewIndex]) VALUES (N'PMAC', N'Vị trí cột mã máy quét', N'Scan machine code position column', 0, 3, 0, 9)
INSERT [dbo].[HT0017STD] ([ParaID], [Parameter], [ParameterE], [Position], [Width], [IsUsed], [ViewIndex]) VALUES (N'PMIN', N'Vị trí cột phút', N'Minute position column', 0, 2, 0, 6)
INSERT [dbo].[HT0017STD] ([ParaID], [Parameter], [ParameterE], [Position], [Width], [IsUsed], [ViewIndex]) VALUES (N'PMON', N'Vị trí cột tháng', N'Month position column', 0, 2, 1, 2)
INSERT [dbo].[HT0017STD] ([ParaID], [Parameter], [ParameterE], [Position], [Width], [IsUsed], [ViewIndex]) VALUES (N'PSEC', N'Vị trí cột giây', N'Second position column', 0, 2, 0, 7)
INSERT [dbo].[HT0017STD] ([ParaID], [Parameter], [ParameterE], [Position], [Width], [IsUsed], [ViewIndex]) VALUES (N'PSHI', N'Vị trí cột mã ca', N'Shift position column', 0, 2, 0, 10)
INSERT [dbo].[HT0017STD] ([ParaID], [Parameter], [ParameterE], [Position], [Width], [IsUsed], [ViewIndex]) VALUES (N'PYEA', N'Vị trí cột năm', N'Year position column', 0, 4, 1, 3)

/****** Object:  Table dbo.HT0002STD    Script Date: 11/30/2011 10:52:05 ******/
--- Edited by Bao Anh	Date: 14/12/2012	Bo sung truong Tinh thuc lanh IsCalculateNetIncome
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0002STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HT0002STD](
	[IncomeID] [nvarchar](50) NOT NULL,
	[FieldName] [nvarchar](250) NULL,
	[IncomeName] [nvarchar](250) NULL,
	[Caption] [nvarchar](250) NULL,
	[IsUsed] [tinyint] NOT NULL,
	[IsTax] [tinyint] NOT NULL,
	[CaptionE] [nvarchar](250) NULL,
	[IncomeNameE] [nvarchar](50) NULL,
	[IsCalculateNetIncome] [tinyint] NOT NULL
) ON [PRIMARY]
END
DELETE [HT0002STD]
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I01', N'I01', N'Thu nhập 01', N'Lương cứng', 1, 1, N'', NULL,1)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I02', N'I02', N'Thu nhập 02', N'Lương mềm', 1, 1, N'', NULL,1)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I03', N'I03', N'Thu nhập 03', N'Phụ cấp', 1, 1, N'', NULL,1)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I04', N'I04', N'Thu nhập 04', N'Thu nhập 04', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I05', N'I05', N'Thu nhập 05', N'Thu nhập 05', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I06', N'I06', N'Thu nhập 06', N'Thu nhập 06', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I07', N'I07', N'Thu nhập 07', N'Thu nhập 07', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I08', N'I08', N'Thu nhập 08', N'Thu nhập 08', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I09', N'I09', N'Thu nhập 09', N'Thu nhập 09', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I10', N'I10', N'Thu nhập 10', N'Thu nhập 10', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I11', N'I11', N'Thu nhập 11', N'Thu nhập 11', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I12', N'I12', N'Thu nhập 12', N'Thu nhập 12', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I13', N'I13', N'Thu nhập 13', N'Thu nhập 13', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I14', N'I14', N'Thu nhập 14', N'Thu nhập 14', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I15', N'I15', N'Thu nhập 15', N'Thu nhập 15', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I16', N'I16', N'Thu nhập 16', N'Thu nhập 16', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I17', N'I17', N'Thu nhập 17', N'Thu nhập 17', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I18', N'I18', N'Thu nhập 18', N'Thu nhập 18', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I19', N'I19', N'Thu nhập 19', N'Thu nhập 19', 0, 0, N'', NULL,0)
INSERT dbo.HT0002STD (IncomeID, FieldName, IncomeName, Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome) VALUES (N'I20', N'I20', N'Thu nhập 20', N'Thu nhập 20', 0, 0, N'', NULL,0)

/****** Object:  Table dbo.HT0005STD    Script Date: 11/30/2011 13:21:46 ******/
--- Edited by Bao Anh	Date: 14/12/2012	Bo sung truong Tinh thuc lanh IsCalculateNetIncome
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0005STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HT0005STD](
	[SubID] [nvarchar](50) NOT NULL,
	[FieldName] [nvarchar](250) NULL,
	[SubName] [nvarchar](250) NULL,
	[Caption] [nvarchar](100) NULL,
	[IsTranfer] [tinyint] NULL,
	[IsUsed] [tinyint] NOT NULL,
	[SourceFieldName] [nvarchar](250) NULL,
	[SourceTableName] [nvarchar](250) NULL,
	[IsTax] [tinyint] NULL,
	[CaptionE] [nvarchar](250) NULL,
	[SubNameE] [nvarchar](50) NULL,
	[IsCalculateNetIncome] [tinyint] NOT NULL
) ON [PRIMARY]
END
DELETE [HT0005STD]
/****** Object:  Table [dbo].[HT0005STD]    Script Date: 02/27/2012 16:45:09 ******/
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S01', N'S01', N'Giảm trừ 01', N'BHXH', 1, 1, N'SAmount', N'HT2461', 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S02', N'S02', N'Giảm trừ 02', N'BHYT', 1, 1, N'HAmount', N'HT2461', 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S03', N'S03', N'Giảm trừ 03', N'BHTN', 1, 1, N'TAmount', N'HT2461', 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S04', N'S04', N'Giảm trừ 04', N'Trừ tạm ứng', 1, 1, N'AdvanceAmount', N'HT2500', 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S05', N'S05', N'Giảm trừ 05', N'Nghỉ trừ lương Có phép (100%)', 0, 1, NULL, NULL, 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S06', N'S06', N'Giảm trừ 06', N'Nghỉ trừ lương Không phép (300%)', 0, 1, NULL, NULL, 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S07', N'S07', N'Giảm trừ 07', N'Trừ vi phạm', 0, 1, NULL, NULL, 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S08', N'S08', N'Giảm trừ 08', N'Trừ khác', 0, 1, NULL, NULL, 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S09', N'S09', N'Giảm trừ 09', N'Trừ khác (Ko.TNCN)', 0, 1, NULL, NULL, 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S10', N'S10', N'Giảm trừ 10', N'Trừ mượn', 0, 1, NULL, NULL, 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S11', N'S11', N'Giảm trừ 11', N'Trừ trễ 30', 0, 1, NULL, NULL, 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S12', N'S12', N'Giảm trừ 12', N'Trừ trể 60', 0, 1, NULL, NULL, 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S13', N'S13', N'Giảm trừ 13', N'Trừ người PT', 0, 1, NULL, NULL, 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S14', N'S14', N'Giảm trừ 14', N'Trừ cá nhân', 0, 1, NULL, NULL, 0, NULL, NULL,1)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S15', N'S15', N'Giảm trừ 15', N'Chưa sử dụng', 0, 0, NULL, NULL, 0, NULL, NULL,0)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S16', N'S16', N'Giảm trừ 16', N'Chưa sử dụng', 0, 0, NULL, NULL, 0, NULL, NULL,0)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S17', N'S17', N'Giảm trừ 17', N'Chưa sử dụng', 0, 0, NULL, NULL, 0, NULL, NULL,0)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S18', N'S18', N'Giảm trừ 18', N'Chưa sử dụng', 0, 0, NULL, NULL, 0, NULL, NULL,0)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S19', N'S19', N'Giảm trừ 19', N'Chưa sử dụng', 0, 0, NULL, NULL, 0, NULL, NULL,0)
INSERT [dbo].[HT0005STD] ([SubID], [FieldName], [SubName], [Caption], [IsTranfer], [IsUsed], [SourceFieldName], [SourceTableName], [IsTax], [CaptionE], [SubNameE], [IsCalculateNetIncome]) VALUES (N'S20', N'S20', N'Giảm trừ 20', N'Chưa sử dụng', 0, 0, NULL, NULL, 0, NULL, NULL,0)


/****** Object:  Table dbo.HT1000STD    Script Date: 12/22/2011 10:27:35 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT1000STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HT1000STD](
	[MethodID] [nvarchar](50) NOT NULL,
	[SystemName] [nvarchar](250) NULL,
	[UserName] [nvarchar](250) NULL,
	[Description] [nvarchar](250) NULL,
	[IsDivision] [tinyint] NOT NULL,
	[IsUsed] [tinyint] NULL
) ON [PRIMARY]
END
DELETE [HT1000STD]
INSERT dbo.HT1000STD (MethodID, SystemName, UserName, Description, IsDivision, IsUsed) VALUES (N'P01', N'Lương nhân', N'Lương công nhật ', N'Bằng lương cơ bản nhân với hệ số chung nhân với ngày công chia cho số ngày quy đinh', 0, 1)
INSERT dbo.HT1000STD (MethodID, SystemName, UserName, Description, IsDivision, IsUsed) VALUES (N'P02', N'Lương chia', N'Lương khoán', N'Bằng quỹ lương chia cho tổng của tích hệ số chung nhân với ngày công sau đó nhân với ngày công và hệ số chung của nhân viên ', 1, 1)
INSERT dbo.HT1000STD (MethodID, SystemName, UserName, Description, IsDivision, IsUsed) VALUES (N'P03', N'Lương sản phẩm', N'Lương sản phẩm', N'Tổng giá trị của một bộ bộ phận phân bổ cho từng người theo ngày công và hệ số', 3, 1)
INSERT dbo.HT1000STD (MethodID, SystemName, UserName, Description, IsDivision, IsUsed) VALUES (N'P04', N'Lương sản phẩm chỉ định', N'Lương sản phẩm chỉ định', N'Tính giá trị cho lương sản phẩm chỉ định', 0, 1)
INSERT dbo.HT1000STD (MethodID, SystemName, UserName, Description, IsDivision, IsUsed) VALUES (N'P10', N'Lương tổng hợp', N'Lương tổng hợp', N'Bằng (TN1 + TN2  + … + TNn) nhân với hệ số chung nhân với số ngày công chia cho số ngày quy định', 2, 1)

/****** Object:  Table dbo.HT0003STD    Script Date: 01/03/2012 15:59:59 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HT0003STD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HT0003STD](
	[CoefficientID] [nvarchar](50) NOT NULL,
	[FieldName] [nvarchar](250) NULL,
	[CoefficientName] [nvarchar](250) NULL,
	[Caption] [nvarchar](250) NULL,
	[IsUsed] [tinyint] NULL,
	[IsConstant] [tinyint] NULL,
	[ValueOfConstant] [decimal](28, 8) NULL
) ON [PRIMARY]
END
DELETE [HT0003STD]
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C01', N'C01', N'Hệ số 01', N'He so chuc vu', 1, NULL, NULL)
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C02', N'C02', N'Hệ số 02', N'C02', 1, NULL, NULL)
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C03', N'C03', N'Hệ số 03', N'C03', 1, NULL, NULL)
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C04', N'C04', N'Hệ số 04', N'C04', 1, NULL, NULL)
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C05', N'C05', N'Hệ số 05', N'C05', 0, NULL, NULL)
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C06', N'C06', N'Hệ số 06', N'C06', 0, NULL, NULL)
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C07', N'C07', N'Hệ số 07', N'C07', 0, NULL, NULL)
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C08', N'C08', N'Hệ số 08', N'C08', 1, NULL, NULL)
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C09', N'C09', N'Hệ số 09', N'C09', 0, NULL, NULL)
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C10', N'C10', N'Hệ số 10', N'C10', 0, NULL, NULL)
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C11', N'C11', N'Hệ số 11', N'C11', 0, NULL, NULL)
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C12', N'C12', N'Hệ số 12', N'C12', 0, NULL, NULL)
INSERT dbo.HT0003STD (CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant) VALUES (N'C13', N'C13', N'Hệ số 13', N'C13', 0, NULL, NULL)

delete [HT8888STD] 
/****** Object:  Table [dbo].[HT8888STD]    Script Date: 04/18/2012 11:43:23 ******/
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR1363', N'Hợp đồng lao động', N'HỢP ĐỒNG LAO ĐỘNG', N'G09', 0, 0, N'Select * From HV1360 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'', N'LABOUR CONTRACT REPORT', N'Labour Contract Report', N'Hợp đồng lao động', N'Labour Contract Report')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR1407', N'Danh sách nhân viên (mẫu 1)', N'Danh sách nhân viên', N'G09', 0, 0, N'Select * From HV1400  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, Orders', N'List of Employees ', N'List of Employees (form 1)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR1408', N'Danh sách nhân viên ', N'Danh sách nhân viên (mẫu 1) ', N'G09', 0, 0, N'Select * From HV1400  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, Orders', N'List of Employees ', N'List of Employees (form 2)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR1410', N'Danh sách lao động xí nghiệp', N'Danh sách lao động xí nghiệp', N'G09', 0, 0, N'Select * From HV1400  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, Orders', N'List of Employees', N'List of Employees', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2404', N'Báo cáo chấm công tháng nhân viên', N'Chấm công', N'G06', 3, 0, N'SELECT a.AbsentTypeID,a.Caption,b.DepartmentID,b.DepartmentName,b.EmployeeID,b.FullName,b.Birthday,b.AbsentAmount   From HV2415 as a inner join HV2424 as b On a.AbsentTypeID = b.AbsentTypeID', NULL, N'MONTHLY TIMEKEEPING REPORT', N'MONTHLY TIMEKEEPING REPORT', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2407', N'Báo cáo chấm công nhiều tháng', N'Chấm công', N'G06', 3, 0, N'SELECT a.AbsentTypeID,a.Caption,b.DepartmentID,b.DepartmentName,b.EmployeeID,b.FullName,b.Birthday,b.AbsentAmount   From HV2415 as a inner join HV2424 as b On a.AbsentTypeID = b.AbsentTypeID', NULL, N'REPORT OF TIMEKEEPING IN MANY MONTHS', N'REPORT OF TIMEKEEPING IN MANY MONTHS', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2492', N'Báo cáo biến động lương 12 tháng', N'Báo cáo biến động lương 12 tháng', N'G19', 72, 0, N'Select * From HV2494  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),EmployeeID', N'FLUCTUATION SALARY  REPORT IN 12 MONTH', N'FLUCTUATION SALARY REPORT IN 12 MONTH ', N'Báo cáo biến động lương 12 tháng', N'FLUCTUATION SALARY REPORT IN 12 MONTH')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2493', N'Báo cáo biến động lương 3 tháng', N'Báo cáo biến động lương 3 tháng', N'G19', 73, 0, N'Select * From HV2494  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),EmployeeID', N'FLUCTUATION SALARY  REPORT IN 3 MONTH', N'FLUCTUATION SALARY REPORT IN 3 MONTH ', N'Báo cáo biến động lương 3 tháng', N'FLUCTUATION SALARY REPORT IN 3 MONTH')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2496', N'Báo cáo biến động lương 6 tháng', N'Báo cáo biến động lương 6 tháng', N'G19', 76, 0, N'Select * From HV2494  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),EmployeeID', N'FLUCTUATION SALARY  REPORT IN 6 MONTH', N'FLUCTUATION SALARY REPORT IN 6 MONTH ', N'Báo cáo biến động lương 6 tháng', N'FLUCTUATION SALARY REPORT IN 6 MONTH')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2499', N'Báo cáo biến động lương 9 tháng', N'Báo cáo biến động lương 9 tháng', N'G19', 79, 0, N'Select * From HV2494  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),EmployeeID', N'FLUCTUATION SALARY  REPORT IN 9 MONTH', N'FLUCTUATION SALARY REPORT IN 9 MONTH ', N'Báo cáo biến động lương 9 tháng', N'FLUCTUATION SALARY REPORT IN 9 MONTH')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2503', N'Danh sách LĐ và QTL trích nộp BHXH', N'DANH SÁCH LAO ĐỘNG VÀ QUỸ TIỀN LƯƠNG TRÍCH NỘP BHXH', N'G03', 1, 0, N'Select * from HV2505  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'Order by SNo,EmployeeID', N'List of Employees Paying Social Security and Syndical Fund', N'List of Employees Paying Social Security and Syndical Fund', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2513', N'Bảng lương', N'BẢNG LƯƠNG', N'G05', 0, 0, N'Select * From HV2409 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, isnull(TeamID, ''''), EmployeeID, IncomeID, Orders', N'Salary Report', N'Salary Report', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3461', N'Phiếu lương khổ nhỏ', N'Phiếu lương', N'G08', 20, 0, N'Select * From HV7111 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', NULL, N'SALARY SLIP', N'SALARY SLIP', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2503a', N'Danh sách LĐ và QTL trích nộp BHXH (Thang bảng lương nhà nước)', N'DANH SÁCH LAO ĐỘNG VÀ QUỸ TIỀN LƯƠNG TRÍCH NỘP BHXH', N'G03', 1, 0, N'Select * from HV2505 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'Order by SNo,EmployeeID', N'List of Employees Paying Social Security and Syndical Fund', N'List of Employees Paying Social Security and Syndical Fund', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2507', N'Danh sách lao động nộp BHXH theo quý', N'Danh sách lao động nộp BHXH theo quý', N'G03', 3, 0, N'Select * From HV2506 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N' Order by DepartmentID', N'List of Employees paying social insurance (quater)', N'List of Employees paying social insurace(quater)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2508', N'Tổng hợp tình hình nộp BHXH quý', N'Tổng hợp tình hình nộp BHXH quý', N'G03', 4, 0, N'Select * from HV2506 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'Order by DepartmentID', N'Sumarize about Social Insurance', N'Sumarize about Social Insurance', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2509', N'Danh sách người lao động đề nghị cấp sổ BHXH', N'Danh sách người lao động đề nghị cấp sổ', N'G03', 5, 0, N'select EmployeeID,FullName,Birthday,IsMale,IdentifyCardNo,IdentifyPlace,FullAddress,SoInsurBeginDate,DutyName from HV1400 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'', N'Lisf of Employee offer issue Social Insurance Book', N'Lisf of Employee offer issue Social Insurance Book', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2510', N'Quỹ tiền lương điều chỉnh mức nộp BHXH theo quý', N'Danh sách lao động, quỹ tiền lương điều chỉnh mức nộp BHXH ', N'G03', 8, 0, N'select EmployeeID,Status,BaseSalary1,BaseSalary2,Notes,CNo,SNo,IsMale,Birthday,FullName,HospitalName,FullAddress,DutyName from HV2509 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'order by Status, Orders, EmployeeID', N'List of Employee, Wage-fund adjust Social Insurance payment level(In quater)', N'Wage-fund adjust So.Insurance payment', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2517', N'Phiếu lương', N'PHIẾU LƯƠNG', N'G05', 1, 0, N'Select * From HV3406 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N' Order by DepartmentID, EmployeeID, Signs desc,IncomeID', N'Salary Slip', N'Salary Slip', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2518', N'Tạm ứng', N'DANH SÁCH KÝ NHẬN LƯƠNG', N'G05', 0, 0, N'Select * From HV2409  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, isnull(TeamID, ''''), Orders, EmployeeID', NULL, NULL, NULL, NULL)
--INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2519', N'In Bìa thư (Lần I)', N'LƯƠNG LẦN 1 THÁNG', N'G05', 1, 0, N'Select * From HV3406 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'Order by DepartmentID,  isnull(TeamiD, ''''), EmployeeID, Signs desc,IncomeID', NULL, NULL, NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2520', N'Tạm ứng', N'BÁO CÁO TẠM ỨNG', N'G04', 1, 0, N'Select * From HV2521 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N' Order by DepartmentID ', N'Advance Payment Report', N'Advance Payment Report', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2521', N'Tạm ứng chi tiết ', N'BÁO CÁO TẠM ỨNG', N'G04', 1, 0, N'Select * From HV2521 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N' Order by DepartmentID', N'Advance Payment in Details Report', N'Advance Payment in Details Report', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2522', N'Báo cá tạm ứng ', N'BÁO CÁO TẠM ỨNG ', N'G04', 2, 0, N'Select * From HV2522 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N' Order by DepartmentID', N'Advance Payment Report', N'Advance Payment Report', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2523', N'Bảng lương (TỔNG HỢP PHÒNG BAN)', N'BẢNG LƯƠNG KỲ II', N'G05', 0, 0, N'Select * From HV2409  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, isnull(TeamID, ''''), Orders, EmployeeID', NULL, NULL, NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2505', N'Danh sách trích nộp BHXH', N'DANH SÁCH NHÂN VIÊN TRÍCH NỘP BHXH', N'G03', 1, 0, N'Select * From HV2505 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'Order by DepartmentID, Isnull(TeamID,''''), EmployeeID', N'List of Employees Paying Social Security and Syndical Fund', N'List of Employees Paying Social Security and Syndical Fund', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2526', N'Danh sách nhân viên trích nộp BHXH', N'BẢNG PHÂN BỔ LƯƠNG', N'G03', 2, 0, N'Select * From HV2505 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N' Order by DepartmentID ', N'List of Employees paying social security', N'List of Employees paying social security', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2527', N'In bìa thư (Lần II)', N'LƯƠNG LẦN 2 THÁNG', N'G05', 1, 0, N'Select * From HV3406 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N' Order by DepartmentID,isnull(TeamID,''''), EmployeeID, Signs desc,IncomeID', NULL, NULL, NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2528', N'Ký nhận lương (Lần II)', N'DANH SÁCH KÝ NHẬN LƯƠNG LẦN II', N'G05', 0, 0, N'Select * From HV2409  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'Order by DepartmentID,  isnull(TeamiD, ''''), EmployeeID, Signs desc,IncomeID', NULL, NULL, NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2529', N'Bảng lương kỳ II', N'BẢNG LƯƠNG KỲ II', N'G05', 0, 0, N'Select * From HV2409  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, isnull(TeamID, ''''), Orders, EmployeeID', NULL, NULL, NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2535', N'Danh sách công nhân nộp BHXH, KPCĐ (nhóm theo PB)', N'DANH SÁCH CÔNG NHÂN NỘP BHXH, KPCĐ', N'G03', 1, 0, N'Select * From HV2505 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N' Order by DepartmentID, Isnull(TeamID,''''), EmployeeID', N'List of Employees Paying Social Security and Syndical Fund (Group by Department)', N'List of Employees Paying Social Security and Syndical Fund (Group by Department)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2562', N'Quỹ tiền lương điều chỉnh mức nộp BHXH', N'Danh sách lao động, quỹ tiền lương bổ sung mức nộp BHXH', N'G03', 7, 0, N'select Months,BaseSalary,CNo,SNo,FullName,Notes,TranMonth,TranYear,ToMonth,ToYear,ReportType,Rate2,Amount2', N'order by Status, Orders, EmployeeID from HV2567', N'List of Employee, Wage-fund adding Social Insurance level', N'List of Employee, Wage-fund adding Social Insurance level', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2563', N'Quỹ tiền lương điều chỉnh mức nộp BHXH', N'Danh sách lao động, quỹ tiền lương điều chỉnh mức nộp BHXH', N'G03', 6, 0, N'select EmployeeID,Status,BaseSalary1,BaseSalary2,CNo,SNo,IsMale,Birthday,FullName,HospitalName,FullAddress,DutyName from HV2563 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'order by Status, Orders, EmployeeID', N'List of Employee, Wage-fund adjust Social Insurance payment level', N'Wage-fund adjust So.Insurance payment', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2610', N'Bảng chấm công sản phẩm ', N'BẢNG CHẤM CÔNG SẢN PHẨM ', N'G06', 1, 0, N'Select * From HV2610 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N' Order by DepartmentID', N'Work Marked on Product Report', N'Work Marked on Product Report', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2700', N'Tờ khai nộp thuế thu nhập thường xuyên của cá nhân', N'Tờ khai nộp thuế thu nhập thường xuyên của cá nhân', N'G10', 1, 0, N'SELECT      AT1101.DivisionName, AT1101.Tel, AT1101.Fax, AT1101.Address, AT1101.VATNO,      HT2704.LineDescription, HT2704.Code, HT2704.Code0, HT2704.IsBold, HT2704.DataType, HT2704.Amount   FROM      SITC.dbo.AT1101 AT1101, sitc.dbo.HT2704 HT2704    WHERE      AT1101.DivisionID = HT2704.DivisionID  And AT1101.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'orderby Code', N'', N'', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR2704', N'Tờ khai khấu trừ thuế thu nhập cá nhân', N'Tờ khai khấu trừ thuế thu nhập cá nhân', N'G08', 1, 0, N'Select * From HV3499 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'', N'Personal Incoming Tax Deduction', N'Personal Incoming Tax Deduction', N'Tờ khai khấu trừ thuế thu nhập cá nhân', N'Personal Incoming Tax Deduction')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3421', N'Báo cáo lương', N'Báo cáo lương (1 cột)', N'G07', 1, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (1 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3422', N'Báo cáo lương', N'Báo cáo lương (1 cột)', N'G07', 2, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'Select * From HT7110 ', N'SALARY REPORT', N'SALARY REPORT', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3423', N'Báo cáo lương', N'Báo cáo lương (3 cột)', N'G07', 3, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Report ', N'Salary Report (3 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3424', N'Báo cáo lương', N'Báo cáo lương (4 cột)', N'G07', 4, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Report ', N'Salary Report (4 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3425', N'Báo cáo lương', N'Báo cáo lương (5 cột)', N'G07', 5, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Report ', N'Salary Report (5 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3426', N'Báo cáo lương', N'Báo cáo lương (6 cột)', N'G07', 6, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Report ', N'Salary Report (6 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3427', N'Báo cáo lương', N'Báo cáo lương (7 cột)', N'G07', 7, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Report ', N'Salary Report (7 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3428', N'Báo cáo lương', N'Báo cáo lương (8 cột)', N'G07', 8, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Report ', N'Salary Report (8 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3429', N'Báo cáo lương', N'Báo cáo lương (9 cột)', N'G07', 9, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Report ', N'Salary Report (9 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3430', N'Báo cáo lương', N'Báo cáo lương (10 cột)', N'G07', 10, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Report ', N'Salary Report (10 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3431', N'Báo cáo lương', N'Báo cáo lương (11 cột)', N'G07', 11, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Report ', N'Salary Report (11 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3432', N'Báo cáo lương', N'Báo cáo lương (12 cột)', N'G07', 12, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Report ', N'Salary Report (12 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3433', N'Báo cáo lương', N'Báo cáo lương (13 cột)', N'G07', 13, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Report ', N'Salary Report (13 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3434', N'Báo cáo lương', N'Báo cáo lương (14 cột)', N'G07', 14, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Report ', N'Salary Report (14 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3437', N'Báo cáo lương', N'Báo cáo lương (17 cột)', N'G07', 27, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (17 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3449', N'Báo cáo lương', N'Báo cáo lương (29 cột)', N'G07', 29, 0, N'Select * From HQ7110 HT7110 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID', N'Salary Report ', N'Salary Report (29 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3451', N'Báo cáo lương phần I', N'Báo cáo lương (15 cột)', N'G07', 15, 0, N'Select * From HQ7110 HT7110 Where isnull(BankAccountNo,'''')=''''  And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (15 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3452', N'Báo cáo lương phần II', N'Báo cáo lương (9 cột)', N'G07', 15, 0, N'Select * From HQ7110 HT7110 Where isnull(BankAccountNo,'''')='''' And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (9 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3453', N'Báo cáo lương phần I', N'Báo cáo lương (15 cột)', N'G07', 15, 0, N'Select * From HQ7110 HT7110 Where isnull(BankAccountNo,'''')<>'''' And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (15 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3454', N'Báo cáo lương phần II', N'Báo cáo lương (9 cột)', N'G07', 15, 0, N'Select * From HQ7110 HT7110 Where isnull(BankAccountNo,'''')<>'''' And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (9 COLUMNS)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3455', N'Báo cáo lương', N'Báo cáo lương', N'G07', 9, 0, N'Select * From HQ7110 HT7110 Where isnull(BankAccountNo,'''')<>'''' And DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'Order by DepartmentID,Isnull(TeamID,''''),Orders,EmployeeID', N'SALARY REPORT', N'SALARY REPORT (1 COLUMN)', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3460', N'Phiếu lương', N'Phiếu lương', N'G08', 27, 0, N'Select * From HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'Salary Slip ', N'Salary Slip', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3462', N'Phiếu lương khổ nhỏ (Dạng 2)', N'Phiếu lương', N'G08', 20, 0, N'Select * From HT7110 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY SLIP', N'SALARY SLIP', NULL, NULL)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3463', N'Báo cáo lương', N'Báo cáo lương (1 cột)', N'G07', 1, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (1 COLUMNS)', N'Báo cáo lương (1 cột)', N'SALARY REPORT (1 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3464', N'Báo cáo lương', N'Báo cáo lương (2 cột)', N'G07', 2, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (2 COLUMNS)', N'Báo cáo lương (2 cột)', N'SALARY REPORT (2 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3465', N'Báo cáo lương', N'Báo cáo lương (3 cột)', N'G07', 3, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (3 COLUMNS)', N'Báo cáo lương (3 cột)', N'SALARY REPORT (3 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3466', N'Báo cáo lương', N'Báo cáo lương (16 cột)', N'G07', 16, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (16 COLUMNS)', N'Báo cáo lương (16 cột)', N'SALARY REPORT (16 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3467', N'Báo cáo lương', N'Báo cáo lương (18 cột)', N'G07', 18, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (18 COLUMNS)', N'Báo cáo lương (18 cột)', N'SALARY REPORT (18 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3468', N'Báo cáo lương', N'Báo cáo lương (19 cột)', N'G07', 19, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (19 COLUMNS)', N'Báo cáo lương (19 cột)', N'SALARY REPORT (19 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3469', N'Báo cáo lương', N'Báo cáo lương (20 cột)', N'G07', 20, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (20 COLUMNS)', N'Báo cáo lương (20 cột)', N'SALARY REPORT (20 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3470', N'Báo cáo lương', N'Báo cáo lương (21 cột)', N'G07', 21, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (21 COLUMNS)', N'Báo cáo lương (21 cột)', N'SALARY REPORT (21 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3471', N'Báo cáo lương', N'Báo cáo lương (22 cột)', N'G07', 22, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (22 COLUMNS)', N'Báo cáo lương (22 cột)', N'SALARY REPORT (22 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3472', N'Báo cáo lương', N'Báo cáo lương (23 cột)', N'G07', 23, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (23 COLUMNS)', N'Báo cáo lương (23 cột)', N'SALARY REPORT (23 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3473', N'Báo cáo lương', N'Báo cáo lương (24 cột)', N'G07', 24, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (24 COLUMNS)', N'Báo cáo lương (24 cột)', N'SALARY REPORT (24 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3474', N'Báo cáo lương', N'Báo cáo lương (25 cột)', N'G07', 25, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (25 COLUMNS)', N'Báo cáo lương (25 cột)', N'SALARY REPORT (25 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3475', N'Báo cáo lương', N'Báo cáo lương (26 cột)', N'G07', 26, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (26 COLUMNS)', N'Báo cáo lương (26 cột)', N'SALARY REPORT (26 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3476', N'Báo cáo lương', N'Báo cáo lương (27 cột)', N'G07', 27, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (27 COLUMNS)', N'Báo cáo lương (27 cột)', N'SALARY REPORT (27 COLUMNS)')
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE]) VALUES (N'HR3477', N'Báo cáo lương', N'Báo cáo lương (28 cột)', N'G07', 28, 0, N'Select * From HQ7110 HT7110  Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'ORDER BY DepartmentID, IsNull(TeamID,''''),Orders', N'SALARY REPORT', N'SALARY REPORT (28 COLUMNS)', N'Báo cáo lương (28 cột)', N'SALARY REPORT (28 COLUMNS)')
/****** Object:  Table [dbo].[HT8888STD]    Script Date: 08/24/2012 13:39:24 ******/
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE], [IsDelete]) VALUES (N'HR2401', N'Điều chuyển công tác', N'ĐIỀU CHUYỂN CÔNG TÁC', N'G06', 2, 0, N'', N'', N'WORK TRANFER', N'WORK TRANFER', N'Báo cáo chấm công', N'TIMESHEET', 0)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE], [IsDelete]) VALUES (N'HR2402', N'Bảng chấm công', N'BẢNG CHẤM CÔNG', N'G06', 2, 0, N'', N'', N'TIME RECORD SHEET', N'TIME RECORD SHEET', N'Báo cáo chấm công', N'TIMESHEET', 0)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE], [IsDelete]) VALUES (N'HR2403', N'Báo cáo chấm công ngày', N'BÁO CÁO CHẤM CÔNG NGÀY', N'G06', 2, 0, N'', N'', N'DAILY TIME & ATTENDANCE TRACKING REPORT', N'DAILY TIME & ATTENDANCE TRACKING REPORT', N'Báo cáo chấm công', N'TIMESHEET', 0)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE], [IsDelete]) VALUES (N'HR2405', N'Báo cáo chấm công ngày', N'BÁO CÁO CHẤM CÔNG NGÀY', N'G06', 2, 0, N'', N'', N'DAILY TIME & ATTENDANCE TRACKING REPORT', N'DAILY TIME & ATTENDANCE TRACKING REPORT', N'Báo cáo chấm công', N'TIMESHEET', 0)
INSERT [dbo].[HT8888STD] ([ReportID], [ReportName], [Title], [GroupID], [Type], [Disabled], [SQLstring], [Orderby], [TitleE], [ReportNameE], [Description], [DescriptionE], [IsDelete]) VALUES (N'HR2490', N'Báo cáo chấm công tháng', N'BÁO CÁO CHẤM CÔNG THÁNG', N'G06', 3, 0, N'Select * From HV2495 Where DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))', N'Order By DepartmentID, EmployeeID, AbsentTypeID', N'TIMESHEET', N'TIMESHEET', N'Báo cáo chấm công', N'TIMESHEET', 0)


DECLARE @DivisionID NVARCHAR(50)
DECLARE cur_AllDivision CURSOR FOR 
SELECT DivisionID FROM AT1101
		
OPEN cur_AllDivision
FETCH NEXT FROM cur_AllDivision INTO @DivisionID
WHILE @@fetch_status = 0
BEGIN
    IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I01' AND FieldName =N'I01' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I01' AND FieldName =N'I01' 
	END 

	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I02' AND FieldName =N'I02' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I02' AND FieldName =N'I02' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I03' AND FieldName =N'I03' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I03' AND FieldName =N'I03' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I04' AND FieldName =N'I04' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I04' AND FieldName =N'I04' 
	END 
	
	 IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I05' AND FieldName =N'I05' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I05' AND FieldName =N'I05' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I06' AND FieldName =N'I06' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I06' AND FieldName =N'I06' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I07' AND FieldName =N'I07' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I07' AND FieldName =N'I07' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I08' AND FieldName =N'I08' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I08' AND FieldName =N'I08' 
	END
	
	 IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I09' AND FieldName =N'I09' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I09' AND FieldName =N'I09' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I10' AND FieldName =N'I10' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I10' AND FieldName =N'I10' 
	END 	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I11' AND FieldName =N'I11' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I11' AND FieldName =N'I11' 
	END 

	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I12' AND FieldName =N'I12' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I12' AND FieldName =N'I12' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I13' AND FieldName =N'I13' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I13' AND FieldName =N'I13' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I14' AND FieldName =N'I14' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I14' AND FieldName =N'I14' 
	END 
	
	 IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I15' AND FieldName =N'I15' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I15' AND FieldName =N'I15' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I16' AND FieldName =N'I16' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I16' AND FieldName =N'I16' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I17' AND FieldName =N'I17' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I17' AND FieldName =N'I17' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I18' AND FieldName =N'I18' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I18' AND FieldName =N'I18' 
	END
	
	 IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I19' AND FieldName =N'I19' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I19' AND FieldName =N'I19' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0002 WHERE IncomeID = N'I20' AND FieldName =N'I20' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0002(DivisionID, IncomeID, FieldName, IncomeName,Caption, IsUsed, IsTax, CaptionE, IncomeNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0002STD WHERE IncomeID = N'I20' AND FieldName =N'I20' 
	END
	ELSE	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S01' AND FieldName =N'S01' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S01' AND FieldName =N'S01' 
	END 
	BEGIN
		UPDATE HT0005 SET SourceFieldName = N'SAmount', SourceTableName = N'HT2461' WHERE SubID = N'S01' AND FieldName =N'S01' and DivisionID = @DivisionID
	END

	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S02' AND FieldName =N'S02' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S02' AND FieldName =N'S02' 
	END 
	BEGIN
		UPDATE HT0005 SET SourceFieldName = N'HAmount', SourceTableName = N'HT2461' WHERE SubID = N'S02' AND FieldName =N'S02' and DivisionID = @DivisionID
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S03' AND FieldName =N'S03' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S03' AND FieldName =N'S03' 
	END 
	BEGIN
		UPDATE HT0005 SET SourceFieldName = N'TAmount', SourceTableName = N'HT2461' WHERE SubID = N'S03' AND FieldName =N'S03' and DivisionID = @DivisionID
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S04' AND FieldName =N'S04' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S04' AND FieldName =N'S04' 
	END 
	BEGIN
		UPDATE HT0005 SET SourceFieldName = N'AdvanceAmount', SourceTableName = N'HT2500' WHERE SubID = N'S04' AND FieldName =N'S04' and DivisionID = @DivisionID
	END
	
	 IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S05' AND FieldName =N'S05' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S05' AND FieldName =N'S05' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S06' AND FieldName =N'S06' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S06' AND FieldName =N'S06' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S07' AND FieldName =N'S07' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S07' AND FieldName =N'S07' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S08' AND FieldName =N'S08'  and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S08' AND FieldName =N'S08' 
	END
	
	 IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S09' AND FieldName =N'S09' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S09' AND FieldName =N'S09' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S10' AND FieldName =N'S10'  and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S10' AND FieldName =N'S10' 
	END 	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S11' AND FieldName =N'S11'  and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S11' AND FieldName =N'S11' 
	END 

	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S12' AND FieldName =N'S12'  and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S12' AND FieldName =N'S12' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S13' AND FieldName =N'S13' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S13' AND FieldName =N'S13' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S14' AND FieldName =N'S14' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S14' AND FieldName =N'S14' 
	END 
	
	 IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S15' AND FieldName =N'S15' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S15' AND FieldName =N'S15' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S16' AND FieldName =N'S16'  and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S16' AND FieldName =N'S16' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S17' AND FieldName =N'S17'  and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S17' AND FieldName =N'S17' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S18' AND FieldName =N'S18'  and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S18' AND FieldName =N'S18' 
	END
	
	 IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S19' AND FieldName =N'S19'  and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S19' AND FieldName =N'S19' 
	END 
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0005 WHERE SubID = N'S20' AND FieldName =N'S20' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0005(DivisionID, SubID, FieldName, SubName, Caption, IsTranfer, IsUsed, SourceFieldName, SourceTableName, IsTax, CaptionE, SubNameE, IsCalculateNetIncome)  
		SELECT @DivisionID, * FROM HT0005STD WHERE SubID = N'S20' AND FieldName =N'S20' 
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT1000 WHERE MethodID = N'P01' AND SystemName = N'Lương nhân' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT1000(DivisionID ,MethodID, SystemName, UserName, Description, IsDivision, IsUsed)  
		SELECT @DivisionID, * FROM HT1000STD WHERE MethodID = N'P01' AND SystemName = N'Lương nhân'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT1000 WHERE MethodID = N'P02' AND SystemName = N'Lương chia' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT1000(DivisionID ,MethodID, SystemName, UserName, Description, IsDivision, IsUsed)  
		SELECT @DivisionID, * FROM HT1000STD WHERE MethodID = N'P02' AND SystemName = N'Lương chia'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT1000 WHERE MethodID = N'P03' AND SystemName = N'Lương sản phẩm' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT1000(DivisionID ,MethodID, SystemName, UserName, Description, IsDivision, IsUsed)  
		SELECT @DivisionID, * FROM HT1000STD WHERE MethodID = N'P03' AND SystemName = N'Lương sản phẩm'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT1000 WHERE MethodID = N'P04' AND SystemName = N'Lương sản phẩm chỉ định' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT1000(DivisionID ,MethodID, SystemName, UserName, Description, IsDivision, IsUsed)  
		SELECT @DivisionID, * FROM HT1000STD WHERE MethodID = N'P04' AND SystemName = N'Lương sản phẩm chỉ định'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT1000 WHERE MethodID = N'P10' AND SystemName = N'Lương tổng hợp' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT1000(DivisionID ,MethodID, SystemName, UserName, Description, IsDivision, IsUsed)  
		SELECT @DivisionID, * FROM HT1000STD WHERE MethodID = N'P10' AND SystemName = N'Lương tổng hợp'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C01' AND FieldName = N'C01' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C01' AND FieldName = N'C01'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C02' AND FieldName = N'C02' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C02' AND FieldName = N'C02'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C03' AND FieldName = N'C03' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C03' AND FieldName = N'C03'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C04' AND FieldName = N'C04' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C04' AND FieldName = N'C04'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C05' AND FieldName = N'C05' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C05' AND FieldName = N'C05'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C06' AND FieldName = N'C06' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C06' AND FieldName = N'C06'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C07' AND FieldName = N'C07' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C07' AND FieldName = N'C07'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C08' AND FieldName = N'C08' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C08' AND FieldName = N'C08'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C09' AND FieldName = N'C09' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C09' AND FieldName = N'C09'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C10' AND FieldName = N'C10' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C10' AND FieldName = N'C10'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C11' AND FieldName = N'C11' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C11' AND FieldName = N'C11'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C12' AND FieldName = N'C12' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C12' AND FieldName = N'C12'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0003 WHERE CoefficientID = N'C13' AND FieldName = N'C13' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0003(DivisionID ,CoefficientID, FieldName, CoefficientName, Caption, IsUsed, IsConstant, ValueOfConstant)  
		SELECT @DivisionID, * FROM HT0003STD WHERE CoefficientID = N'C13' AND FieldName = N'C13'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT6666 WHERE PeriodID = N'P01' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT6666 (DivisionID, PeriodID, PeriodName, IsDefault)
		SELECT @DivisionID, * FROM HT6666STD WHERE PeriodID = N'P01'
	END	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT6666 WHERE PeriodID = N'P02' and DivisionID = @DivisionID)
    BEGIN
		INSERT HT6666 (DivisionID, PeriodID, PeriodName, IsDefault)
		SELECT @DivisionID, * FROM HT6666STD WHERE PeriodID = N'P02'
	END	
	
	/* Insert dữ liệu HT0017 */
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0017 WHERE ParaID = N'PBAR'  and DivisionID = @DivisionID)
    BEGIN
		INSERT HT0017(DivisionID, ParaID, Parameter, ParameterE, Position, Width, IsUsed, ViewIndex)  
		SELECT @DivisionID, * FROM HT0017STD WHERE ParaID = N'PBAR'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0017 WHERE ParaID = N'PDAY' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0017(DivisionID, ParaID, Parameter, ParameterE, Position, Width, IsUsed, ViewIndex)  
		SELECT @DivisionID, * FROM HT0017STD WHERE ParaID = N'PDAY'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0017 WHERE ParaID = N'PDMY' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0017(DivisionID, ParaID, Parameter, ParameterE, Position, Width, IsUsed, ViewIndex)  
		SELECT @DivisionID, * FROM HT0017STD WHERE ParaID = N'PDMY'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0017 WHERE ParaID = N'PHMS' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0017(DivisionID, ParaID, Parameter, ParameterE, Position, Width, IsUsed, ViewIndex)  
		SELECT @DivisionID, * FROM HT0017STD WHERE ParaID = N'PHMS'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0017 WHERE ParaID = N'PHOU' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0017(DivisionID, ParaID, Parameter, ParameterE, Position, Width, IsUsed, ViewIndex)  
		SELECT @DivisionID, * FROM HT0017STD WHERE ParaID = N'PHOU'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0017 WHERE ParaID = N'PIOS' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0017(DivisionID, ParaID, Parameter, ParameterE, Position, Width, IsUsed, ViewIndex)  
		SELECT @DivisionID, * FROM HT0017STD WHERE ParaID = N'PIOS'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0017 WHERE ParaID = N'PMAC' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0017(DivisionID, ParaID, Parameter, ParameterE, Position, Width, IsUsed, ViewIndex)  
		SELECT @DivisionID, * FROM HT0017STD WHERE ParaID = N'PMAC'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0017 WHERE ParaID = N'PMIN' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0017(DivisionID, ParaID, Parameter, ParameterE, Position, Width, IsUsed, ViewIndex)  
		SELECT @DivisionID, * FROM HT0017STD WHERE ParaID = N'PMIN'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0017 WHERE ParaID = N'PMON' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0017(DivisionID, ParaID, Parameter, ParameterE, Position, Width, IsUsed, ViewIndex)  
		SELECT @DivisionID, * FROM HT0017STD WHERE ParaID = N'PMON'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0017 WHERE ParaID = N'PSEC' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0017(DivisionID, ParaID, Parameter, ParameterE, Position, Width, IsUsed, ViewIndex)  
		SELECT @DivisionID, * FROM HT0017STD WHERE ParaID = N'PSEC'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0017 WHERE ParaID = N'PSHI' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0017(DivisionID, ParaID, Parameter, ParameterE, Position, Width, IsUsed, ViewIndex)  
		SELECT @DivisionID, * FROM HT0017STD WHERE ParaID = N'PSHI'
	END
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0017 WHERE ParaID = N'PYEA' and DivisionID = @DivisionID )
    BEGIN
		INSERT HT0017(DivisionID, ParaID, Parameter, ParameterE, Position, Width, IsUsed, ViewIndex)  
		SELECT @DivisionID, * FROM HT0017STD WHERE ParaID = N'PYEA'
	END	
	
	IF NOT EXISTS(SELECT TOP 1 * FROM HT0018 where DivisionID = @DivisionID)
	BEGIN
		INSERT HT0018(DivisionID, ImportMethod, Tab_char, Space_char, Semilicon_char, Comma_char, Others_char, Others_Define, S_InCode, S_OutCode)  
		SELECT @DivisionID, * FROM HT0018STD
	END			
	
    FETCH NEXT FROM cur_AllDivision INTO @DivisionID
END  
CLOSE cur_AllDivision
DEALLOCATE cur_AllDivision

--Xoá và Insert lại bảng HT8888 đúng với HT8888STD
DELETE HT8888 WHERE ReportID in (Select distinct ReportID From HT8888STD) And IsDelete = 0

INSERT HT8888(APK, DivisionID, ReportID, ReportName, Title, GroupID, Type, Disabled, SQLstring, Orderby, TitleE, ReportNameE, Description, DescriptionE, IsDelete)
SELECT NEWID() AS APK, DivisionID, ReportID, ReportName, Title, GroupID, Type, HT8888STD.Disabled, SQLstring, Orderby, TitleE, ReportNameE, Description, DescriptionE, IsDelete
FROM HT8888STD, AT1101