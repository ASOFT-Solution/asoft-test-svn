USE CDT
 

IF NOT EXISTS (SELECT 1
               FROM   Dictionary
               WHERE  Content = N'Thiết lập hệ thống trên máy tính của bạn không phù hợp với ASoft-Accounting \n' +
									N'Nhấn nút OK màn hình Regional Setting sẽ hiện ra \n' +
									N'Mục Numbers và thiết lập: \n' +
									N'Negative sign symbol về dấu phẩy (-)')
  INSERT INTO Dictionary
              (Content,
               Content2)
  VALUES      (N'Thiết lập hệ thống trên máy tính của bạn không phù hợp với ASoft-Accounting \n' +
									N'Nhấn nút OK màn hình Regional Setting sẽ hiện ra \n' +
									N'Mục Numbers và thiết lập: \n' +
									N'Negative sign symbol về dấu phẩy (-)',
               N'System Settings of Negative sign (-).')
               
