DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'vi-VN';
SET @ModuleID = 'OO';
SET @FormID = 'OOF2101'
---------------------------------------------------------------

SET @LanguageValue  = N'Cập nhật dự án/nhóm công việc'
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã dự án/nhóm công việc';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.ProjectID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên dự án/nhóm công việc';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.ProjectName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mẫu dự án/nhóm công việc';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.TaskSampleID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Hợp đồng';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.ContractName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày bắt đầu';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.StartDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày kết thúc';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.EndDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Ngày nghiệm thu';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.CheckingDate',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Dự án';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.ProjectType1',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Nhóm công việc';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.ProjectType2',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Phòng ban';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.DepartmentName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Người tham gia';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.AssignedToUserName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Trưởng dự án';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.LeaderName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Trạng thái';
EXEC ERP9AddLanguage @ModuleID, 'OOF2101.StatusID',  @FormID, @LanguageValue, @Language;