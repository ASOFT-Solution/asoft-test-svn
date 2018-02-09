DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1052'
---------------------------------------------------------------

SET @LanguageValue  = N'Message details'
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Details information';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.XemChiTietThongBao',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Inform Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.InformName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Effective Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.EffectDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Expiration Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.ExpiryDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Inform type';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.InformType',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Department';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.DepartmentID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Attachment';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.DinhKem',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Notes';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.GhiChu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'History';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.LichSu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Creator';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Created Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.CreateDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Updated Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.LastModifyDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Update By';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.LastModifyUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.InformDivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Description';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.Description',  @FormID, @LanguageValue, @Language;

