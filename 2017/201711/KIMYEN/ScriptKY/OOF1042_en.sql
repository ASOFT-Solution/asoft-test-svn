DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1042'
---------------------------------------------------------------

SET @LanguageValue  = N'Xem chi tiết trạng thái'
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thông tin chung';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.XemChiTietTrangThai',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã trạng thái';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.StatusID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên trạng thái';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.StatusName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thứ tự hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Dùng chung';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.IsCommon',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ghi chú';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.GhiChu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Lịch sử';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.LichSu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.CreateDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày cập nhật';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.LastModifyDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người cập nhật';
EXEC ERP9AddLanguage @ModuleID, 'OOF1042.LastModifyUserID',  @FormID, @LanguageValue, @Language;
