DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'vi-VN';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1020'
---------------------------------------------------------------

SET @LanguageValue  = N'Danh mục quy trình'
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã quy trình';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên quy trình';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.ProcessName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Dùng chung';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.IsCommon',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thứ tự hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.CreateDate',  @FormID, @LanguageValue, @Language;


