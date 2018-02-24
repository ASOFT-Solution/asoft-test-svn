DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = '00';
SET @FormID = 'CMNF9003'
---------------------------------------------------------------

SET @LanguageValue  = N'Select Employee'
EXEC ERP9AddLanguage @ModuleID, 'CMNF9003.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'EmployeeID'
EXEC ERP9AddLanguage @ModuleID, 'CMNF9003.EmployeeID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Employee Name'
EXEC ERP9AddLanguage @ModuleID, 'CMNF9003.EmployeeName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Department'
EXEC ERP9AddLanguage @ModuleID, 'CMNF9003.DepartmentName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Address'
EXEC ERP9AddLanguage @ModuleID, 'CMNF9003.Address',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Telephone'
EXEC ERP9AddLanguage @ModuleID, 'CMNF9003.Tel',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Email'
EXEC ERP9AddLanguage @ModuleID, 'CMNF9003.Email',  @FormID, @LanguageValue, @Language;