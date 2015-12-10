IF NOT EXISTS(SElECT TOP 1 1 FROM [DMThueSuat] WHERE [MaThue] = 'NHOM5')
INSERT INTO [DMThueSuat]([MaThue], [TenThue], [TenThue2], [ThueSuat], [TKThue], [TKTHUE1])
VALUES(N'NHOM5', N'Hàng hóa, dịch vụ không phải tổng hợp trên tờ khai 01/GTGT', NULL, 0, '33311', '1331')

IF NOT EXISTS (SELECT TOP 1 1 FROM syscolumns col JOIN sysobjects tbl ON tbl.id = col.id AND tbl.name = 'DMThueSuat' AND col.name = 'Stt')
ALTER TABLE [dbo].[DMThueSuat] ADD [Stt] INT NULL
GO

UPDATE [dbo].[DMThueSuat] SET [TKThue] = '33311', [TKTHUE1] = '1331'
    
UPDATE [dbo].[DMThueSuat] SET [Stt] = 1 WHERE [MaThue] = N'KT'
UPDATE [dbo].[DMThueSuat] SET [Stt] = 2 WHERE [MaThue] = N'00'
UPDATE [dbo].[DMThueSuat] SET [Stt] = 3 WHERE [MaThue] = N'05'
UPDATE [dbo].[DMThueSuat] SET [Stt] = 4 WHERE [MaThue] = N'10'
UPDATE [dbo].[DMThueSuat] SET [Stt] = 5 WHERE [MaThue] = N'NHOM5'
UPDATE [dbo].[DMThueSuat] SET [Stt] = 6 WHERE [MaThue] = N'15'
UPDATE [dbo].[DMThueSuat] SET [Stt] = 7 WHERE [MaThue] = N'20'

ALTER TABLE [dbo].[DMThueSuat] ALTER COLUMN [Stt] INT NOT NULL