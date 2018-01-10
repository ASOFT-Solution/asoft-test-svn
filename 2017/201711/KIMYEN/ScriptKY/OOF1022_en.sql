DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1022'
---------------------------------------------------------------

SET @LanguageValue  = N'Xem chi tiết quy trình'
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thông tin quy trình';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.XemChiTietQuyTrinh',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã quy trình';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên quy trình';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022,ProcessName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thứ tự hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mô tả';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.Description',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Dùng chung';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.IsCommon',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đính kèm';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.DinhKem',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ghi chú';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.GhiChu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Lịch sử';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.LichSu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.CreateDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày cập nhật';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.LastModifyDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người cập nhật';
EXEC ERP9AddLanguage @ModuleID, 'OOF1022.LastModifyUserID',  @FormID, @LanguageValue, @Language;
