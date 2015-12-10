use [CDT]
declare @sysTableBLVTID int,
		@sysTableID int,
		@sysTableTTDB int,
		@sysFieldId int,
		@sysDataConfigID int

select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
select @sysTableBLVTID = sysTableID from sysTable where TableName = 'BLVT'
select @sysTableTTDB = sysTableID from sysTable where TableName = 'TTDBin'

-- Update sysDataConfig
Update sysDataConfig set dt2TableID = @sysTableTTDB
where sysTableID = @sysTableBLVTID and mtTableID = @sysTableID and NhomDK = 'PNK1' and dt2TableID is null

select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLVTID and mtTableID = @sysTableID and NhomDK = 'PNK1'

-- Update sysDataConfigDt
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLVTID
and FieldName = 'DonGia'

Update sysDataConfigDt set Formula = N'((DT23.Ps - isnull(DT23.TienCK,0) + isnull(TTDBin.TienTTDB,0) + DT23.CPCt + DT23.CtThueNk)/DT23.SoLuong)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLVTID
and FieldName = 'DonGiaNT'

Update sysDataConfigDt set Formula = N'((DT23.Ps - isnull(DT23.TienCK,0) + isnull(TTDBin.TienTTDB,0) + DT23.CPCt + DT23.CtThueNk)/(DT23.SoLuong*MT23.TyGia))'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLVTID
and FieldName = 'PsNo'

Update sysDataConfigDt set Formula = N'(DT23.Ps - isnull(DT23.TienCK,0) + isnull(TTDBin.TienTTDB,0) + DT23.CPCt + DT23.CtThueNk)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLVTID
and FieldName = 'PsNoNT'

Update sysDataConfigDt set Formula = N'(DT23.PsNT - isnull(DT23.TienCKNT,0) + isnull(TTDBin.TienTTDBNT,0) + DT23.CPCtNT + DT23.CtThueNkNT)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID