USE CDT

IF NOT EXISTS (SELECT 1
               FROM   Dictionary
               WHERE  Content = N'Server và Client không cùng phiên bản, bạn hãy kiểm tra lại.')
  INSERT INTO Dictionary
              (Content,
               Content2)
  VALUES      (N'Server và Client không cùng phiên bản, bạn hãy kiểm tra lại.',
               N'Server and Client are not same version, user must check again.');
               
