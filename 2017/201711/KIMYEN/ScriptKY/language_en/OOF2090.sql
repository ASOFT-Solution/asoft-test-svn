DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2090'
---------------------------------------------------------------

SET @LanguageValue  = N'Project/work group templates list'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division_ID'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'TaskSampleID'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.TaskSampleID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Task Sample Name'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.TaskSampleName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Description'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.Description',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'DivisionID'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.DivisionID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division Name'
EXEC ERP9AddLanguage @ModuleID, 'OOF2090.DivisionName.CB',  @FormID, @LanguageValue, @Language;