DECLARE 
@ModuleID VARCHAR(5), 
@FormID VARCHAR(50), 
@Language VARCHAR(10), 
@LanguageValue NVARCHAR(4000), 
@LanguageCustomValue NVARCHAR(4000)

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1000'; 
SET @LanguageValue = N'Mã hội viên'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1000.MemberID' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 
 


SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1000'; 
SET @LanguageValue = N'Tên hội viên'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1000.MemberName' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1000'; 
SET @LanguageValue = N'Người tạo'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1000.CreateUserID' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 
 
 SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1000'; 
SET @LanguageValue = N'Số điện thoại'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1000.Phone' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1000'; 
SET @LanguageValue = N'Thành phố'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1000.CityName' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1000'; 
SET @LanguageValue = N'Website'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1000.Website' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1000'; 
SET @LanguageValue = N'Quận/Huyện'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1000.WardName' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Mã đơn vị'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.DivisionID' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Mã hội viên'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.MemberID' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Tên hội viên'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.MemberName' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Địa chỉ'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.Address' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Số điện thoại'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.Tel' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Di động'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.Phone' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Số Fax'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.Fax' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Email'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1000.Email' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Ngày sinh'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.Birthday' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Website'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.Website' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Hộp thư'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.Mailbox' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Mã vùng'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.AreaName' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Tỉnh/Thành'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.CityName' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1001'; 
SET @LanguageValue = N'Quận/Huyện'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.WardName' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue; 

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Mã đơn vị'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.DivisionID' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Mã hội viên'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.MemberID' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Tên hội viên'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.MemberName' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Địa chỉ'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.Address' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Người tạo'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.CreateUserID' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Số điện thoại'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.Tel' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Di động'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.Phone' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Số Fax'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1001.Fax' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Email'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.Email' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Disable'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.Disable' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Ngày sinh'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.Birthday' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Website'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.Website' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Hộp thư'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.Mailbox' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Mã vùng'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.AreaName' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Tỉnh/thành'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.CityName' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Quận/Huyện'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.WardName' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Ngày tạo'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.CreateDate' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Ngày chỉnh sửa cuối'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.LastModifyDate' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;

SET @Language = 'vi-VN';  
SET @ModuleID = 'S'; 
SET @FormID = 'SF1002'; 
SET @LanguageValue = N'Người chỉnh sửa cuối'; 
SET @LanguageCustomValue = N''; 
EXEC ERP9AddLanguage @ModuleID, 'SF1002.LastModifyUserID' , @FormID, @LanguageValue, 
@Language, @LanguageCustomValue;





 




