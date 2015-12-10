USE CDT
DELETE FROM   Dictionary  WHERE  Content = N'Thiết lập hệ thống về số phân cách thập phân và dấu phân cách hàng nghìn ' +
									N'trên máy tính của bạn không hợp với ASoft-Accounting ' +
									N'Nhấn nút OK màn hình Regional Setting sẽ hiện ra ' +
									N'Mục Numbers và thiết lập: ' +
									N'Decimal Symbol về dấu chấm (.) ' +
									N'Digit Grouping Symbol về dấu phẩy (,) ' +
									N'Negative sign symbol về dấu phẩy (-)'
								
              
Delete  FROM Dictionary   WHERE  Content = N'Thiết lập hệ thống về số phân cách thập phân và dấu phân cách hàng nghìn ' +
									N'trên máy tính của bạn không hợp với ASoft-Accounting ' +
									N'Nhấn nút OK màn hình Regional Setting sẽ hiện ra ' +
									N'Mục Currency và thiết lập: ' +
									N'Decimal Symbol về dấu chấm (.) ' +
									N'Digit Grouping Symbol về dấu phẩy (,)'
  

IF NOT EXISTS (SELECT 1
               FROM   Dictionary
               WHERE  Content = N'Thiết lập hệ thống về số phân cách thập phân và dấu phân cách hàng nghìn \n' +
									N'trên máy tính của bạn không hợp với ASoft-Accounting \n' +
									N'Nhấn nút OK màn hình Regional Setting sẽ hiện ra \n' +
									N'Mục Numbers và thiết lập: \n' +
									N'Decimal Symbol về dấu chấm (,) \n' +
									N'Digit Grouping Symbol về dấu phẩy (.) \n' +
									N'Negative sign symbol về dấu phẩy (-)')
  INSERT INTO Dictionary
              (Content,
               Content2)
  VALUES      (N'Thiết lập hệ thống về số phân cách thập phân và dấu phân cách hàng nghìn \n' +
									N'trên máy tính của bạn không hợp với ASoft-Accounting \n' +
									N'Nhấn nút OK màn hình Regional Setting sẽ hiện ra \n' +
									N'Mục Numbers và thiết lập: \n' +
									N'Decimal Symbol về dấu chấm (,) \n' +
									N'Digit Grouping Symbol về dấu phẩy (.) \n' +
									N'Negative sign symbol về dấu phẩy (-)',
               N'System Settings of decimal separator, thousand separator and Negative sign.')
               
IF NOT EXISTS (SELECT 1
   FROM   Dictionary
   WHERE  Content = N'Thiết lập hệ thống về số phân cách thập phân và dấu phân cách hàng nghìn \n' +
									N'trên máy tính của bạn không hợp với ASoft-Accounting \n' +
									N'Nhấn nút OK màn hình Regional Setting sẽ hiện ra \n' +
									N'Mục Currency và thiết lập: \n' +
									N'Decimal Symbol về dấu chấm (,) \n' +
									N'Digit Grouping Symbol về dấu phẩy (.)')
									
									
  INSERT INTO Dictionary
              (Content,
               Content2)
  VALUES      (N'Thiết lập hệ thống về số phân cách thập phân và dấu phân cách hàng nghìn \n' +
									N'trên máy tính của bạn không hợp với ASoft-Accounting \n' +
									N'Nhấn nút OK màn hình Regional Setting sẽ hiện ra \n' +
									N'Mục Currency và thiết lập: \n' +
									N'Decimal Symbol về dấu chấm (,) \n' +
									N'Digit Grouping Symbol về dấu phẩy (.)',
               N'System Settings of decimal separator, thousand separator.');
