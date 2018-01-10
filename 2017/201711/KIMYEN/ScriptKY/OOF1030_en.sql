DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1030'
---------------------------------------------------------------

SET @LanguageValue  = N'Danh mục bước'
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã bước';
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.StepID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên bước';
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.StepName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Quy trình';
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thứ tự hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.Orders',  @FormID, @LanguageValue, @Language;


