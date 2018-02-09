DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1050'
---------------------------------------------------------------

SET @LanguageValue  = N'Message List';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Effective Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.EffectDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Expiration Date';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.ExpiryDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Inform Type';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.InformType',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'CreatorID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'DepartmentID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.DepartmentID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Disabled';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Inform Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.InformName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'DepartmentID';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.DepartmentID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Department Name';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.DepartmentName.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Division';
EXEC ERP9AddLanguage @ModuleID, 'OOF1050.DivisionID',  @FormID, @LanguageValue, @Language;

