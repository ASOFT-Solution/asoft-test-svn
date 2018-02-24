DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'vi-VN';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2103'
---------------------------------------------------------------

SET @LanguageValue  = N'Chọn phòng ban'
EXEC ERP9AddLanguage @ModuleID, 'OOF2103.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị'
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Phòng ban'
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.DepartmentName',  @FormID, @LanguageValue, @Language;