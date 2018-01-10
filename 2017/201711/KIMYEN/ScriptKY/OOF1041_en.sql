DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1041'
---------------------------------------------------------------

SET @LanguageValue  = N'Cập nhật trạng thái'
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Phân loại';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.StatusType',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã số';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.StatusID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên trạng thái';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.StatusName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thứ tự hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Màu';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.Color',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Dùng chung';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.IsCommon',  @FormID, @LanguageValue, @Language;


