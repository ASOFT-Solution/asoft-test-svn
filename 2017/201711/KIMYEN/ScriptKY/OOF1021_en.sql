DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1021'
---------------------------------------------------------------

SET @LanguageValue  = N'Cập nhật quy trình'
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã quy trình';
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên quy trình';
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.ProcessName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Dùng chung';
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.IsCommon',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thứ tự hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mô tả';
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.Description',  @FormID, @LanguageValue, @Language;



