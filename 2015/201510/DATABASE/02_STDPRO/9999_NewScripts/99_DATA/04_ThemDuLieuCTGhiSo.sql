DECLARE @sSoHieu varchar(150)

Set @sSoHieu = N'PNB'

IF NOT EXISTS (SELECT TOP 1 1 FROM [CTGS] WHERE  [SoHieu] = @sSoHieu 
							AND [NDKT] =N'Phiếu nghiệp vụ tài khoản ngoài bảng')
INSERT [dbo].[CTGS] ([SoHieu], [NDKT], [MaCT]) VALUES (@sSoHieu, N'Phiếu nghiệp vụ tài khoản ngoài bảng', @sSoHieu)

