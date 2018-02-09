DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'vi-VN';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1050'
---------------------------------------------------------------

SET @LanguageValue  = N'Danh mục thông báo'
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày hiệu lực';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.EffectDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày hết hạn';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.ExpiryDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Loại';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.InformType',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Phòng ban';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.DepartmentID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thông báo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.InformName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã phòng ban';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.DepartmentID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên phòng ban';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.DepartmentName.CB',  @FormID, @LanguageValue, @Language;

