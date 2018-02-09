DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2104'
---------------------------------------------------------------

SET @LanguageValue  = N'Select the contract'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'ContractID'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.ContractID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'ContractNo'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.ContractNo',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Contract Name'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.ContractName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Customer'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.ObjectID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Sign Date'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.SignDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Begin Date'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.BeginDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'End Date'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.EndDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Amount'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.Amount',  @FormID, @LanguageValue, @Language;