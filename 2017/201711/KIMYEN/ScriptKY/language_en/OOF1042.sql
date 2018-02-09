DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1042'
---------------------------------------------------------------

SET @LanguageValue  = N'Status details'
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Status information';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.XemChiTietTrangThai',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'StatusID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.StatusID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Status name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.StatusName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Orders';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Common';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.IsCommon',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Notes';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.GhiChu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'History';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.LichSu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Created Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.CreateDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Creator';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Updated Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.LastModifyDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Update By';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.LastModifyUserID',  @FormID, @LanguageValue, @Language;
