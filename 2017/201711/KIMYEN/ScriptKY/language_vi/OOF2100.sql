DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'vi-VN';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2100'
---------------------------------------------------------------

SET @LanguageValue  = N'Danh sách dự án/nhóm công việc'
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Đơn vị';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.DivisionID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Phòng ban';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.DepartmentID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Trưởng dự án';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.LeaderID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Hợp đồng';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.ContractID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã dự án';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.ProjectID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên dự án';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.ProjectName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Trạng thái';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.StatusID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người tham gia';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.AssignedToUserID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày bắt đầu';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.StartDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày kết thúc';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.EndDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã phòng ban';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.DepartmentID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên phòng ban';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.DepartmentName.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã trưởng dự án';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.LeaderID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên trưởng dự án';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.LeaderName.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã hợp đồng';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.ContractID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên hợp đồng';
EXEC ERP9AddLanguage @ModuleID, 'OOF2100.ContractName.CB',  @FormID, @LanguageValue, @Language;

