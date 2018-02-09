DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2100'
---------------------------------------------------------------

SET @LanguageValue  = N'Project/work group list'
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'DivisionID';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'DepartmentID';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.DepartmentID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Leader';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.LeaderID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Contract';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.ContractID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'ProjectID';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.ProjectID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Project Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.ProjectName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Status';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.StatusID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Participants';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.AssignedToUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Start Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.StartDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'End Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.EndDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'DepartmentID';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.DepartmentID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Department Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.DepartmentName.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Leader ID';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.LeaderID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Leader Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.LeaderName.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'ContractID';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.ContractID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Contract Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.ContractName.CB',  @FormID, @LanguageValue, @Language;

