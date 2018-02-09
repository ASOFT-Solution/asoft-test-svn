DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1022'
---------------------------------------------------------------

SET @LanguageValue  = N'Process Details'
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Process Information';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.XemChiTietQuyTrinh',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'ProcessID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Process Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022,ProcessName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Orders';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Description';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.Description',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Common';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.IsCommon',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Attachment';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.DinhKem',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Notes';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.GhiChu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'History';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.LichSu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Created Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.CreateDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Creator';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Updated Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.LastModifyDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Updated Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.LastModifyUserID',  @FormID, @LanguageValue, @Language;
