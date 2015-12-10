USE [CDT]
declare @sysTableID int,
		@sysFieldID int
		
-- 1) Hóa đơn mua hàng kiêm phiếu nhập kho
select @sysTableID = sysTableID from sysTable where TableName = 'DT22'
select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'GhiChu'

Update sysField set Visible = 1
where sysFieldID = @sysFieldID and Visible = 0

-- 2) Hóa đơn nhập khẩu
select @sysTableID = sysTableID from sysTable where TableName = 'DT23'
select @sysFieldID = sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'GhiChu'

Update sysField set Visible = 1
where sysFieldID = @sysFieldID and Visible = 0

-- 3) Hóa đơn giảm giá, hàng bán trả lại
select @sysTableID = sysTableID from sysTable where TableName = 'DT33'

if not exists (select top 1 1 from sysField where FieldName = 'GhiChu' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'GhiChu', 1, NULL, NULL, NULL, NULL, 2, N'Ghi chú', N'Notes', 98, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)