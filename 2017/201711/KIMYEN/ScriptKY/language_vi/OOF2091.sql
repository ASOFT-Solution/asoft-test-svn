DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'vi-VN';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2091'
---------------------------------------------------------------

SET @LanguageValue  = N'Cập nhật mẫu dự án/nhóm công việc'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã mẫu'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.TaskSampleID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên mẫu'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.TaskSampleName',  @FormID, @LanguageValue, @Language;


SET @LanguageValue  = N'Không hiển thị'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Diễn giải'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.Description',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên bước'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.StepName',  @FormID, @LanguageValue, @Language;
