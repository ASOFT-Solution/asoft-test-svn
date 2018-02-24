DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2102'
---------------------------------------------------------------

SET @LanguageValue  = N'Project/work group detail'
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Department';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.DepartmentID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Leader';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.LeaderID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Contract No';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.ContractNo',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'ProjectID';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.ProjectID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Project Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.ProjectName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Status';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.StatusID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Participants';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.AssignedToUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Start Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.StartDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'End Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.EndDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Project Type';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.ProjectType',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Cheking Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.CheckingDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Task Sample';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.TaskSampleID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Attachment';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.DinhKem',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Notes';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.GhiChu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'History';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.LichSu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Create Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.CreateDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Creator';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Updated date';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.LastModifyDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Update By';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.LastModifyUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'General Information';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.ChiTietDuAn',  @FormID, @LanguageValue, @Language;