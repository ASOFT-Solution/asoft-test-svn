use [CDT]

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Tiền gửi')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Tiền gửi',
               N'Deposits') 

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'LN trước thuế')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'LN trước thuế',
               N'Profit (no tax)')

IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'LRòng tạm tính')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'LRòng tạm tính',
               N'Net profit')
 
 
 IF NOT EXISTS (SELECT TOP 1 1
               FROM   [Dictionary]
               WHERE  [Content] = N'Phải trả')
  INSERT INTO [dbo].[Dictionary]
              ([Content],
               [Content2])
  VALUES      (N'Phải trả',
               N'Payments')
               
               
                             
               
               
                              
               


