DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1030'
---------------------------------------------------------------

SET @LanguageValue  = N'Step List'
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division';
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'StepID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.StepID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Step Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.StepName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Process';
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled';
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Orders';
EXEC ERP9AddLanguage @ModuleID, 'OOF1030.Orders',  @FormID, @LanguageValue, @Language;


