DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2092'
---------------------------------------------------------------

SET @LanguageValue  = N' Project/work group templates detail'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'TaskSampleID'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.TaskSampleID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Task Sample Name'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.TaskSampleName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Description'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.Description',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Project/work group templates information'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.ChiTietMauDuAn',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Working process'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.QuyTrinhLamViec',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Attachment'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.DinhKem',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Notes'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.GhiChu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'History'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.LichSu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Creator'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Create Date'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.CreateDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Update By'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.LastModifyUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Update Date'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.LastModifyDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'ProcessID'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Process Name'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.ProcessName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'StepID'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.StepID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Step Name'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.StepName',  @FormID, @LanguageValue, @Language;

