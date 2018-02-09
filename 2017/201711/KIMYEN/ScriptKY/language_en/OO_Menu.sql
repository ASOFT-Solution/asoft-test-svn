DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = '00';
SET @FormID = 'A00'
---------------------------------------------------------------

SET @LanguageValue  = N'List'
EXEC ERP9AddLanguage @ModuleID, 'DanhMuc',  @FormID, @LanguageValue, @Language;

------

SET @LanguageValue  = N'Manage'
EXEC ERP9AddLanguage @ModuleID, 'QuanLy',  @FormID, @LanguageValue, @Language;

------
SET @LanguageValue  = N'Message List'
EXEC ERP9AddLanguage @ModuleID, 'DanhMucThongBao',  @FormID, @LanguageValue, @Language;

------
SET @LanguageValue  = N'Category Process'
EXEC ERP9AddLanguage @ModuleID, 'DanhMucQuyTrinh',  @FormID, @LanguageValue, @Language;
------

SET @LanguageValue  = N'Step List'
EXEC ERP9AddLanguage @ModuleID, 'DanhMucBuoc',  @FormID, @LanguageValue, @Language;

------
SET @LanguageValue  = N'Status List'
EXEC ERP9AddLanguage @ModuleID, 'DanhMucTrangThai',  @FormID, @LanguageValue, @Language;

------

SET @LanguageValue  = N'Project/work group templates list'
EXEC ERP9AddLanguage @ModuleID, 'DanhSachMauDuAn',  @FormID, @LanguageValue, @Language;