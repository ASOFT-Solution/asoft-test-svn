DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1032'
---------------------------------------------------------------

SET @LanguageValue  = N'Xem chi tiết bước'
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thông tin bước';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.XemChiTietBuoc',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã bước';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.StepID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên bước';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.StepName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Quy trình';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thứ tự hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Mô tả';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.Description',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Đính kèm';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.DinhKem',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Ghi chú';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.GhiChu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Lịch sử';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.LichSu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Người tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Ngày tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.CreateDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Người cập nhật';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.LastModifyUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Ngày cập nhật';
EXEC ERP9AddLanguage @ModuleID, 'OOF1032.LastModifyDate',  @FormID, @LanguageValue, @Language;


