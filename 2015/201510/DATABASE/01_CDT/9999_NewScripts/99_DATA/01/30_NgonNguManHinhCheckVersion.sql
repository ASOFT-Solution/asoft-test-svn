use [CDT]

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Phiên bản mới nhất :')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Phiên bản mới nhất :',
               N'Current Version :') 


IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Cập nhật phiên bản mới tại :')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Cập nhật phiên bản mới tại :',
               N'Download version at : ') 

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Không hiển thị thông báo này vào lần đăng nhập sau.')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Không hiển thị thông báo này vào lần đăng nhập sau.',
               N'Do not show this box on the next times.')                
               
               
