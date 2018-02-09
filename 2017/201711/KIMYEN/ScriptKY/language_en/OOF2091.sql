DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2091'
---------------------------------------------------------------

SET @LanguageValue  = N'Update project/work group templates'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'TaskSampleID'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.TaskSampleID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Task Sample Name'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.TaskSampleName',  @FormID, @LanguageValue, @Language;


SET @LanguageValue  = N'Disabled'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Description'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.Description',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Step Name'
EXEC ERP9AddLanguage @ModuleID, 'OOF2091.StepName',  @FormID, @LanguageValue, @Language;
