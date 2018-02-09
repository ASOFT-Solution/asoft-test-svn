DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1031'
---------------------------------------------------------------

SET @LanguageValue  = N'Update Step'
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Process';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'StepID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.StepID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Step Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.StepName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Orders';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Description';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Description',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'WorkID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.WorkID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Work Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.WorkName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Description';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.DescriptionW',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Implementation time(hours)';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.ExecutionTime',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Notes';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Notes',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'WorkID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.WorkID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Work Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.WorkName.CB',  @FormID, @LanguageValue, @Language;




