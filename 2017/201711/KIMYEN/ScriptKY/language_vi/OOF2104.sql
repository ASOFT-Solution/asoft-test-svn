DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'vi-VN';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2104'
---------------------------------------------------------------

SET @LanguageValue  = N'Chọn hợp đồng'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã hợp đồng'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.ContractID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Số hợp đồng'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.ContractNo',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên hợp đồng'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.ContractName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Khách hàng'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.ObjectID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày ký'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.SignDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày bắt đầu'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.BeginDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày kết thúc'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.EndDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Giá trị hợp đồng'
EXEC ERP9AddLanguage @ModuleID, 'OOF2104.Amount',  @FormID, @LanguageValue, @Language;