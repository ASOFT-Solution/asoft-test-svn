use [CDT]

declare @sysTableTHID int,
		@sysTableID int,
		@sysFieldId int,
		@sysDataConfigID int
		
-- 1) Phiếu bán hàng xuất kho
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
select @sysTableTHID = sysTableID from sysTable where TableName = 'BLTK'

-- Update sysDataConfigDt
-- HDB3
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableTHID and mtTableID = @sysTableID and NhomDK = 'HDB3'

-- MaNT
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableTHID
and FieldName = 'MaNT'

Update sysDataConfigDt set mtFieldID = (select sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'MaNT')
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

-- TyGia
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableTHID
and FieldName = 'TyGia'

Update sysDataConfigDt set mtFieldID = (select sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TyGia')
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

-- PsNoNT
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableTHID
and FieldName = 'PsNoNT'

Update sysDataConfigDt set dtFieldID = NULL, Formula = N'TienVon/MT32.TyGia'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

-- HDB4
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableTHID and mtTableID = @sysTableID and NhomDK = 'HDB4'

-- MaNT
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableTHID
and FieldName = 'MaNT'

Update sysDataConfigDt set mtFieldID = (select sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'MaNT')
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

-- TyGia
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableTHID
and FieldName = 'TyGia'

Update sysDataConfigDt set mtFieldID = (select sysFieldID from sysField where sysTableID = @sysTableID and FieldName = 'TyGia')
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

-- PsCoNT
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableTHID
and FieldName = 'PsCoNT'

Update sysDataConfigDt set dtFieldID = NULL, Formula = N'TienVon/MT32.TyGia'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID