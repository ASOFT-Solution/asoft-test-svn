USE CDT

if not exists (select 1 from Dictionary where Content = N'MST:') INSERT INTO Dictionary (Content, Content2) VALUES (N'MST:', N'Tax Code:');
if not exists (select 1 from Dictionary where Content = N'Điện thoại:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Điện thoại:', N'Phone:');
if not exists (select 1 from Dictionary where Content = N'.Ngân hàng:') INSERT INTO Dictionary (Content, Content2) VALUES (N'.Ngân hàng:', N'Bank:');
if not exists (select 1 from Dictionary where Content = N'Thanh toán:') INSERT INTO Dictionary (Content, Content2) VALUES (N'Thanh toán:', N'Pay:');



