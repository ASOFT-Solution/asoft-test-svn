DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'vi-VN';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2092'
---------------------------------------------------------------

SET @LanguageValue  = N'Xem chi tiết mẫu dự án/nhóm công việc'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã mẫu'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.TaskSampleID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên mẫu'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.TaskSampleName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Diễn giải'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.Description',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thông tin mẫu dự án/nhóm công việc'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.ChiTietMauDuAn',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Quy trình làm việc'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.QuyTrinhLamViec',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đính kèm'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.DinhKem',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ghi chú'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.GhiChu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Lịch sử'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.LichSu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người tạo'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày tạo'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.CreateDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người cập nhật'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.LastModifyUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày cập nhật'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.LastModifyDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã quy trình'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên quy trình'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.ProcessName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã bước'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.StepID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên bước'
EXEC ERP9AddLanguage @ModuleID, 'OOF2092.StepName',  @FormID, @LanguageValue, @Language;

