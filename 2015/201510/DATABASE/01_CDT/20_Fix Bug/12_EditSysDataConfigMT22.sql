use [CDT]
declare @sysTableBLVTID int,
		@sysTableID int,
		@sysTableTTDB int,
		@sysFieldId int,
		@sysDataConfigID int

select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
select @sysTableBLVTID = sysTableID from sysTable where TableName = 'BLVT'
select @sysTableTTDB = sysTableID from sysTable where TableName = 'TTDBin'

-- Update sysDataConfig
Update sysDataConfig set dt2TableID = @sysTableTTDB
where sysTableID = @sysTableBLVTID and mtTableID = @sysTableID and NhomDK = 'PNM1' and dt2TableID is null

select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLVTID and mtTableID = @sysTableID and NhomDK = 'PNM1'

-- Update sysDataConfigDt
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLVTID
and FieldName = 'DonGia'

Update sysDataConfigDt set Formula = N'((DT22.Ps - isnull(DT22.TienCK,0) + isnull(TTDBin.TienTTDB,0) + DT22.CPCt)/DT22.SoLuong)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLVTID
and FieldName = 'DonGiaNT'

Update sysDataConfigDt set Formula = N'((DT22.PsNT - isnull(DT22.TienCKNT,0) + isnull(TTDBin.TienTTDBNT,0) + DT22.CPCtNT)/DT22.SoLuong)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLVTID
and FieldName = 'PsNo'

Update sysDataConfigDt set Formula = N'(DT22.Ps - isnull(DT22.TienCK,0) + isnull(TTDBin.TienTTDB,0) + DT22.CPCt)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLVTID
and FieldName = 'PsNoNT'

Update sysDataConfigDt set Formula = N'(DT22.PsNT - isnull(DT22.TienCKNT,0) + isnull(TTDBin.TienTTDBNT,0) + DT22.CPCtNT)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID