DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1040'
---------------------------------------------------------------

SET @LanguageValue  = N'Danh mục trạng thái'
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã trạng thái';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.StatusID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên trạng thái';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.StatusName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Phân loại';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.StatusType',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Dùng chung';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.IsCommon',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Màu';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.Color',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thứ tự hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.Orders',  @FormID, @LanguageValue, @Language;
