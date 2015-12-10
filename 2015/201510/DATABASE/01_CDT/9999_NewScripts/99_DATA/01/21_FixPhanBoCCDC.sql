USE CDT
--1-- Ẩn cột Kỳ Phân Bổ
UPDATE sysField
SET    Visible = 0
WHERE  sysTableID = (SELECT sysTableID
                     FROM   sysTable
                     WHERE  TableName = N'DT45')
       AND FieldName = N'KyPb' 

--2-- Thêm ngôn ngữ thông báo lỗi
IF NOT EXISTS (SELECT 1
               FROM   Dictionary
               WHERE  Content = N'Chứng từ xuất CCDC số {0} đã phân bổ!\n Vui lòng xóa phân bổ của chứng từ này và thực hiện phân bổ lại!')
  INSERT INTO Dictionary
              (Content, Content2)
  VALUES      (N'Chứng từ xuất CCDC số {0} đã phân bổ!\n Vui lòng xóa phân bổ của chứng từ này và thực hiện phân bổ lại!',
               N'Receipt of delivering tools no.{0} was allocated!\n Please delete one and try to allocat again!');
--3-- Báo cáo CCDC
Update sysReport set Query = N'declare @ngayCt1 datetime
declare @ngayCt2 datetime
set @ngayct1=@@ngayct1
set @ngayct2=@@ngayct2
SELECT x.*,vt.tenvt, TConLai as [Tiền còn lại], TPhanBo as [Tiền phân bổ trong kỳ] ,case when SLHong <> 0 then (soluong - SLConLai) else 0 end as [Số lượng hỏng trước kỳ]
FROM   (
SELECT m.ngayct as [Ngày xuất], b.mact,  m.soct, m.makh,  m.diengiai,  b.ngayct, d.mt45id, d.dt45id, 
			   b.SLHong, b.SLConLai, ps, tkno, tkcp, b.mabp, b.maphi,manv,TienHong,
               kypb,soky,d.soluong, b.TPhanBo, (SELECT Count (*)
               FROM   LSPBO tt
               WHERE  nhomdk = ''PBC''
               AND tt.soct = b.soct AND psno >= 0
               AND tt.mtiddt = b.mtiddt
			   AND tt.mtid = b.mtid
               AND tt.ngayct <= b.ngayct) as [Phân bổ lần thứ],
               TDaPhanBo as [Tiền đã phân bổ],
               TConLai,
               d.mavt,
               madvt
        FROM   mt45 m INNER JOIN dt45 d ON m.mt45id = d.mt45id 
				INNER JOIN LSPBO b ON b.mtid = m.mt45id AND b.mtiddt = d.dt45id
        WHERE  ( b.ngayct BETWEEN dbo.Layngaydauthang(@ngayct1) AND dbo.Layngayghiso(@ngayct2) )
               AND b.nhomdk = ''PBC''
               AND psno >= 0) x
       INNER JOIN dmvt vt
         ON x.mavt = vt.mavt
--WHERE  soluong >= slHong + 
ORDER  BY vt.mavt,x.ngayct, x.soct'
where ReportName = N'Báo cáo chi tiết phân bổ công cụ dụng cụ'
-- 4 - Định dạng cột
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysFormatString]
               WHERE  [Fieldname] = N'Tiền còn lại')
INSERT INTO [dbo].[sysFormatString]
           ([_Key]
           ,[Fieldname])
     VALUES
           (N'Tien'
           ,N'Tiền còn lại')
GO

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysFormatString]
               WHERE  [Fieldname] = N'Số lượng hỏng')
INSERT INTO [dbo].[sysFormatString]
           ([_Key]
           ,[Fieldname])
     VALUES
           (N'SoLuong'
           ,N'Số lượng hỏng')
GO

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysFormatString]
               WHERE  [Fieldname] = N'Số lượng hỏng trước kỳ')
INSERT INTO [dbo].[sysFormatString]
           ([_Key]
           ,[Fieldname])
     VALUES
           (N'SoLuong'
           ,N'Số lượng hỏng trước kỳ')
GO


IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysFormatString]
               WHERE  [Fieldname] = N'Tien')
INSERT INTO [dbo].[sysFormatString]
           ([_Key]
           ,[Fieldname])
     VALUES
           (N'Tien'
           ,N'TienHong')
GO


IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysFormatString]
               WHERE  [Fieldname] = N'TPhanBo')
INSERT INTO [dbo].[sysFormatString]
           ([_Key]
           ,[Fieldname])
     VALUES
           (N'Tien'
           ,N'TPhanBo')
GO


IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysFormatString]
               WHERE  [Fieldname] = N'Tiền đã Phân Bổ')
INSERT INTO [dbo].[sysFormatString]
           ([_Key]
           ,[Fieldname])
     VALUES
           (N'Tien'
           ,N'Tiền đã Phân Bổ')
GO

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysFormatString]
               WHERE  [Fieldname] = N'TConLai')
INSERT INTO [dbo].[sysFormatString]
           ([_Key]
           ,[Fieldname])
     VALUES
           (N'Tien'
           ,N'TConLai')
GO


IF NOT EXISTS (SELECT TOP 1 1
               FROM   [sysFormatString]
               WHERE  [Fieldname] = N'Tiền phân bổ trong kỳ')
INSERT INTO [dbo].[sysFormatString]
           ([_Key]
           ,[Fieldname])
     VALUES
           (N'Tien'
           ,N'Tiền phân bổ trong kỳ')
GO


-- 5 - Đa ngôn ngữ
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Mã vật tư:')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Mã vật tư:',
               N'Material code:') 

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Tên vật tư:')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Tên vật tư:',
               N'Material name:') 

 IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Ngày phân bổ')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Ngày phân bổ',
               N'Allocation Date:') 
IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Ngày xuất')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Ngày xuất',
               N'Delivering Date')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Phân bổ lần thứ')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Phân bổ lần thứ',
               N'Allocation Times')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'|--- Số chứng từ:')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'|--- Số chứng từ:',
               N'|--- Voucher number:')
