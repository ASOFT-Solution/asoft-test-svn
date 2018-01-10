DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'en-US';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1052'
---------------------------------------------------------------

SET @LanguageValue  = N'Xem chi tiết thông báo'
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thông tin thông báo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.XemChiTietThongBao',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tiêu đề';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.InformName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày hiệu lực';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.EffectDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày hết hạn';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.ExpiryDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Loại thông báo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.InformType',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Phòng ban';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.DepartmentID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đính kèm';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.DinhKem',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ghi chú';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.GhiChu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Lịch sử';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.LichSu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.CreateDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày cập  nhật';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.LastModifyDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người cập nhật';
EXEC ERP9AddLanguage @ModuleID, 'OOF1052.LastModifyUserID',  @FormID, @LanguageValue, @Language;

