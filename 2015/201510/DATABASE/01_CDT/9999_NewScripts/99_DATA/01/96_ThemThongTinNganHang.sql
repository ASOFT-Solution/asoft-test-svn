USE [CDT]
declare @sysTableID int,
		@sysSiteIDPRO int,
		@sysSiteIDSTD int,
		@sysMenuParent int
		
select @sysSiteIDPRO = sysSiteID from sysSite where SiteCode = 'PRO'
select @sysSiteIDSTD = sysSiteID from sysSite where SiteCode = 'STD'


-- 1) Giấy báo nợ
select @sysTableID = sysTableID from sysTable where TableName = 'MT16'

if not exists (select top 1 1 from sysField where FieldName = 'BankID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'BankID', 1, N'BankID', N'DMNH', NULL, N'Disabled <> 1', 1, N'Ngân hàng', N'Bank', 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT16_DMNH19', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'BankAccountID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'BankAccountID', 1, N'BankAccountID', N'DMTKNH', NULL, N'Disabled <> 1', 1, N'Tài khoản ngân hàng', N'Bank account ID', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT16_DMTKNH20', NULL, NULL, 0, N'BankID = @BankID')

Update [sysField] set TabIndex = 13
where FieldName = N'TkThue'
and sysTableID = @sysTableID
and TabIndex = 10

-- 2) Giấy báo có
select @sysTableID = sysTableID from sysTable where TableName = 'MT15'

if not exists (select top 1 1 from sysField where FieldName = 'BankID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'BankID', 1, N'BankID', N'DMNH', NULL, N'Disabled <> 1', 1, N'Ngân hàng', N'Bank', 12, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT15_DMNH', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'BankAccountID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'BankAccountID', 1, N'BankAccountID', N'DMTKNH', NULL, N'Disabled <> 1', 1, N'Tài khoản ngân hàng', N'Bank account ID', 13, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT15_DMTKNH', NULL, NULL, 0, N'BankID = @BankID')

-- 3) Hóa đơn bán hàng kiêm phiếu xuất kho
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'

if not exists (select top 1 1 from sysField where FieldName = 'BankID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'BankID', 1, N'BankID', N'DMNH', NULL, N'Disabled <> 1', 1, N'Ngân hàng', N'Bank', 34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT32_DMNH', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'BankAccountID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'BankAccountID', 1, N'BankAccountID', N'DMTKNH', NULL, N'Disabled <> 1', 1, N'Tài khoản ngân hàng', N'Bank account ID', 35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT32_DMTKNH', NULL, NULL, 0, N'BankID = @BankID')

Update [sysField] set TabIndex = 36
where FieldName = N'Saleman'
and sysTableID = @sysTableID
and TabIndex = 34

-- 4) Hóa đơn dịch vụ
select @sysTableID = sysTableID from sysTable where TableName = 'MT31'

if not exists (select top 1 1 from sysField where FieldName = 'BankID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'BankID', 1, N'BankID', N'DMNH', NULL, N'Disabled <> 1', 1, N'Ngân hàng', N'Bank', 34, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT31_DMNH', NULL, NULL, 0, NULL)

if not exists (select top 1 1 from sysField where FieldName = 'BankAccountID' and sysTableID = @sysTableID)
INSERT [dbo].[sysField] ([sysTableID], [FieldName], [AllowNull], [RefField], [RefTable], [DisplayMember], [RefCriteria], [Type], [LabelName], [LabelName2], [TabIndex], [Formula], [FormulaDetail], [MaxValue], [MinValue], [DefaultValue], [Tip], [TipE], [Visible], [IsBottom], [IsFixCol], [IsGroupCol], [SmartView], [RefName], [DefaultName], [EditMask], [IsUnique], [DynCriteria]) 
VALUES (@sysTableID, N'BankAccountID', 1, N'BankAccountID', N'DMTKNH', NULL, N'Disabled <> 1', 1, N'Tài khoản ngân hàng', N'Bank account ID', 35, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, N'FK_MT31_DMTKNH', NULL, NULL, 0, N'BankID = @BankID')

Update [sysField] set TabIndex = 36
where FieldName = N'Saleman'
and sysTableID = @sysTableID
and TabIndex = 30