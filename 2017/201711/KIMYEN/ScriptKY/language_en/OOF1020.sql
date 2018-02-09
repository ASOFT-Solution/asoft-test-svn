DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1020'
---------------------------------------------------------------

SET @LanguageValue  = N'Category Process'
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'ProcessID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Process Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.ProcessName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Common';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.IsCommon',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Orders';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Creator';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Created Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1020.CreateDate',  @FormID, @LanguageValue, @Language;


