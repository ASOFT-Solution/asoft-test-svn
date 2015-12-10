USE [CDT]

declare @sysTableID int
select @sysTableID = sysTableID from sysTable
where TableName = 'sysReport'

if not exists (select top 1 1 from sysField where FieldName = N'LinkTableAlias' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'LinkTableAlias', N'Alias bảng kết nối', N'Alias bảng kết nối', 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 1, NULL, NULL, NULL, 0, NULL)