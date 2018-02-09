DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1041'
---------------------------------------------------------------

SET @LanguageValue  = N'Update status'
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Status type';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.StatusType',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'StatusID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.StatusID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Status Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.StatusName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Orders';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Color';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.Color',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Common';
EXEC ERP9AddLanguage @ModuleID, 'OOF1041.IsCommon',  @FormID, @LanguageValue, @Language;


