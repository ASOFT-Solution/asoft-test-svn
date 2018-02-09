DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'vi-VN';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2090'
---------------------------------------------------------------

SET @LanguageValue  = N'Danh sách mẫu dự án/nhóm công việc'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã mẫu'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.TaskSampleID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên mẫu'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.TaskSampleName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Diễn giải'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.Description',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã đơn vị'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.DivisionID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên đơn vị'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.DivisionName.CB',  @FormID, @LanguageValue, @Language;