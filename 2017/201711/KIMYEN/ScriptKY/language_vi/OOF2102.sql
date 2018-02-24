DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'vi-VN';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2102'
---------------------------------------------------------------

SET @LanguageValue  = N'Xem chi tiết dự án/nhóm công việc'
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Phòng ban';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.DepartmentID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Trưởng dự án';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.LeaderID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Số hợp đồng';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.ContractNo',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã dự án/nhóm công việc';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.ProjectID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên dự án';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.ProjectName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Trạng thái';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.StatusID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người tham gia';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.AssignedToUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày bắt đầu';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.StartDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày kết thúc';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.EndDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Loại dự án';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.ProjectType',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày nghiệm thu';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.CheckingDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mẫu dự án/nhóm công việc';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.TaskSampleID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đính kèm';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.DinhKem',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ghi chú';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.GhiChu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Lịch sử';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.LichSu',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.CreateDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người tạo';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.CreateUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày chỉnh sửa';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.LastModifyDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người chỉnh sửa';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.LastModifyUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thông tin chung';
EXEC ERP9AddLanguage @ModuleID, 'OOF2102.ChiTietDuAn',  @FormID, @LanguageValue, @Language;