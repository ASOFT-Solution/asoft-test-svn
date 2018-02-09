DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1021'
---------------------------------------------------------------

SET @LanguageValue  = N'Update Process'
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'ProcessID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Process Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.ProcessName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Common';
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.IsCommon',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled';
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Orders';
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Description';
EXEC ERP9AddLanguage @ModuleID, 'OOF1021.Description',  @FormID, @LanguageValue, @Language;



