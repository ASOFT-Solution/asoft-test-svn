DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1031'
---------------------------------------------------------------

SET @LanguageValue  = N'Danh mục bước'
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Quy trình';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã bước';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.StepID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên bước';
EXEC ERP9AddLanguage @ModuleID, 'OF1031.StepName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thứ tự hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Mô tả';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Description',  @FormID, @LanguageValue, @Language;
