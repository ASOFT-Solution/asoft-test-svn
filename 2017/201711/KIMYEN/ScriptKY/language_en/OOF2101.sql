DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en_US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2101'
---------------------------------------------------------------

SET @LanguageValue  = N'Update project/work group'
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'ProjectID';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.ProjectID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Project Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.ProjectName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'TaskSample';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.TaskSampleID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Contract';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.ContractID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Start Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.StartDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'End Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.EndDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Checking Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.CheckingDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Project';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.ProjectType1',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Work group';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.ProjectType2',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Department';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.DepartmentName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Participants';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.AssignedToUserName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Leader';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.LeaderName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Status';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.StatusID',  @FormID, @LanguageValue, @Language;