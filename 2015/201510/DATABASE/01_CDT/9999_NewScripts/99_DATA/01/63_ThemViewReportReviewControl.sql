USE [CDT]
declare @sysTableID int
		
-- Them view wReportRvCtrl
if not exists (select top 1 1 from sysTable where TableName = 'wReportRvCtrl')
INSERT [dbo].[sysTable] ([TableName], [DienGiai], [DienGiai2], [Pk], [ParentPk], [MasterTable], [Type], [SortOrder], [DetailField], [System], [MaCT], [sysPackageID], [Report], [CollectType]) 
VALUES (N'wReportRvCtrl', N'View đa ngôn ngữ cho màn hình report review', NULL, N'ReportReviewControlID', NULL, NULL, 6, NULL, NULL, 0, NULL, 8, NULL, -1)

select @sysTableID = sysTableID from sysTable where TableName = 'wReportRvCtrl'

if not exists (select top 1 1 from sysField where FieldName = 'ReportReviewControlID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'ReportReviewControlID', 0, NULL, NULL, NULL, NULL, 3, N'ReportReviewControlID', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)