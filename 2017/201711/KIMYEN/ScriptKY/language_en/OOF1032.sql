DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1032'
---------------------------------------------------------------

SET @LanguageValue  = N'Step Details'
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Step information';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.XemChiTietBuoc',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'StepID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.StepID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Step Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.StepName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Process';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Orders';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Description';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.Description',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Disabled';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Attachment';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.DinhKem',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Notes';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.GhiChu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'History';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.LichSu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Creator';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Created date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.CreateDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Update by';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.LastModifyUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Updated Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.LastModifyDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'WorkID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.WorkID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Work Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.WorkName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Description';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.DescriptionW',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Implementation time(hours)';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.ExecutionTime',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Notes';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.Notes',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Work list in step';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.DanhSachMauCongViecTheoBuoc',  @FormID, @LanguageValue, @Language;

