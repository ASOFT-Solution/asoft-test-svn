DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1040'
---------------------------------------------------------------

SET @LanguageValue  = N'Status List'
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'StatusID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.StatusID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Status Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.StatusName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Status Type';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.StatusType',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Common';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.IsCommon',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Color';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.Color',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Orders';
EXEC ERP9AddLanguage @ModuleID, 'OOF1040.Orders',  @FormID, @LanguageValue, @Language;
