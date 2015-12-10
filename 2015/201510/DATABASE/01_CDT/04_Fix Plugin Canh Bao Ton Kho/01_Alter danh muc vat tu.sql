use [CDT];
if not exists (select top 1 1 from systable t inner join sysfield f on t.systableid = f.systableid and t.tablename = 'DMVT' and f.fieldname = 'IsTon'
)

insert into sysfield 
(sysTableID,FieldName,AllowNull,RefField,RefTable,DisplayMember,RefCriteria,Type,LabelName,LabelName2,TabIndex,Formula,FormulaDetail,MaxValue,MinValue,DefaultValue,Tip,TipE,Visible,IsBottom,IsFixCol,IsGroupCol,SmartView,RefName,DefaultName,EditMask,IsUnique,DynCriteria)
select systableid
,'IsTon',1,NULL,NULL,NULL,NULL,10,N'Quản lý tồn kho',N'Inventory Management',11,NULL,NULL,NULL,NULL,0,N'Chọn: Cảnh báo khi vật tư/hàng hóa đã hết trong kho',N'Checked: warning when inventories are out of number',1,0,0,0,1,NULL,'DF_DMVT_IsTon',NULL,0,NULL
from systable where tablename = 'DMVT'

