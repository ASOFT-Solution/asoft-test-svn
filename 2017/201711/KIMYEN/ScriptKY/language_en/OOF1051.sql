DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1051'
---------------------------------------------------------------

SET @LanguageValue  = N'Update Message List';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Inform name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.InformName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Effective Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.EffectDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Expiration Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.ExpiryDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'General Information';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.InformType1',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Internal Information';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.InformType2',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.InformDivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Department';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.DepartmentID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Content';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.Content',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'DepartmentID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.DepartmentID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Department Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.DepartmentName.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'DivisionID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.DivisionID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1051.DivisionName.CB',  @FormID, @LanguageValue, @Language;
