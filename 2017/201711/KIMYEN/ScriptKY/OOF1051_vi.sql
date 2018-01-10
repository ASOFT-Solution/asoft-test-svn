DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'vi-VN';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1051'
---------------------------------------------------------------

SET @LanguageValue  = N'Cập nhật thông báo'
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tiêu đề';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.InformName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày hiệu lực';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.EffectDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày hết hạn';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.ExpiryDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thông báo chung';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.InformType1',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thông báo nội bộ';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.InformType2',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.InformDivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Phòng ban';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.DepartmentID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Nội dung';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.Content',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã phòng ban';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.DepartmentID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên phòng ban';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.DepartmentName.CB',  @FormID, @LanguageValue, @Language;
