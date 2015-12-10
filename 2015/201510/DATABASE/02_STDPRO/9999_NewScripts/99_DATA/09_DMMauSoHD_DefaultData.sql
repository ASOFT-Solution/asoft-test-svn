IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'01GTKT')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'01GTKT', N'Hóa đơn giá trị gia tăng', N'01GTKT', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'02GTTT')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'02GTTT', N'Hóa đơn bán hàng', N'02GTTT', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'06HDXK')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'06HDXK', N'Hóa đơn xuất khẩu', N'06HDXK', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'07KPTQ')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'07KPTQ', N'Hóa đơn bán hàng (dành cho tổ chức, cá nhân trong khu phi thuế quan)', N'07KPTQ', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'03XKNB')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'03XKNB', N'Phiếu xuất kho kiêm vận chuyển hàng hóa nội bộ', N'03XKNB', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'04HGDL')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'04HGDL', N'Phiếu xuất kho gửi bán hàng đại lý', N'04HGDL', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'01/')           
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'01/', N'Tem/vé/thẻ thuộc loại hóa đơn GTGT', N'01/', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'02/')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'02/', N'Tem/vé/thẻ thuộc loại hóa đơn bán hàng', N'02/', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'01TEDB')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'01TEDB', N'Tem vận tải đường bộ theo pp khấu trừ', N'01TEDB', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'01VEDB')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'01VEDB', N'Vé vận tải đường bộ theo pp khấu trừ', N'01VEDB', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'01THDB')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'01THDB', N'Thẻ vận tải đường bộ theo pp khấu trừ', N'01THDB', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'02TEDB')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'02TEDB', N'Tem vận tải đường bộ theo pp trực tiếp', N'02TEDB', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'02VEDB')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'02VEDB', N'Vé vận tải đường bộ theo pp trực tiếp', N'02VEDB', 0)

IF NOT EXISTS (SELECT TOP 1 1 FROM   [DMMauSoHD] WHERE  [FormID] = N'02THDB')
INSERT [dbo].[DMMauSoHD] ([FormID], [FormName], [FormSymbol], [Disabled]) 
VALUES (N'02THDB', N'Thẻ vận tải đường bộ theo pp trực tiếp', N'02THDB', 0)