USE [CDT]

DECLARE @sysTableID INT

select @sysTableID = sysTableID from sysTable
					where tableName = 'DT32'
					
Update sysTable set  Report = 'HDBHDATIN,HDBHTUIN,HDBLE,INPXK-GB,INPXK-GV,BKHH-DVTHEOHD'
where sysTableID = @sysTableID
and sysPackageID = 8
and Report = 'HDBHDATIN,HDBHTUIN,HDBLE,INPXK-GB,INPXK-GV'

-- Them field GhiChu
if not exists (select top 1 1 from sysField where FieldName = N'GhiChu' and sysTableID = @sysTableID)
insert into sysField (sysTableID, AllowNull, RefField, RefTable, DisplayMember, RefCriteria, Type, FieldName, LabelName, LabelName2, TabIndex, Formula, FormulaDetail, MaxValue, MinValue, DefaultValue, Tip, TipE, Visible, IsBottom, IsFixCol, IsGroupCol, SmartView, RefName, DefaultName, EditMask, IsUnique, DynCriteria)
values (@sysTableID, 1, NULL, NULL, NULL, NULL, 2, N'GhiChu', N'Ghi chú', N'Note', 30, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL)
