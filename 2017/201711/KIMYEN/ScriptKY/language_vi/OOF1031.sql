DECLARE 
@ModuleID VARCHAR(10),
@FormID VARCHAR(200),
@Language VARCHAR(200),
--------------------------------------------------------
@LanguageValue NVARCHAR(4000)
--------------------------------------------------------

SET @Language = 'vi-VN';
SET @ModuleID = 'OO';
SET @FormID = 'OOF1031'
---------------------------------------------------------------

SET @LanguageValue  = N'Cập nhật bước'
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Title',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Quy trình';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.ProcessID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Mã bước';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.StepID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Tên bước';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.StepName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Không hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Disabled',  @FormID, @LanguageValue, @Language;

SET @LanguageValue  = N'Thứ tự hiển thị';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Orders',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Mô tả';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Description',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Mã công việc';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.WorkID',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Tên công việc';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.WorkName',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Mô tả';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.DescriptionW',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Thời gian thực hiện(giờ)';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.ExecutionTime',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Ghi chú';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.Notes',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Mã công việc';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.WorkID.CB',  @FormID, @LanguageValue, @Language;

SET @LanguageValue = N'Tên công việc';
EXEC ERP9AddLanguage @ModuleID, 'OOF1031.WorkName.CB',  @FormID, @LanguageValue, @Language;




