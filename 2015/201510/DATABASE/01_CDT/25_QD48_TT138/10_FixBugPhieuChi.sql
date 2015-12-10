use [CDT]

declare @sysTableTHID int,
		@sysTableID int,
		@sysFieldId int,
		@sysDataConfigID int
		
-- 1) Phiếu chi
select @sysTableID = sysTableID from sysTable where TableName = 'MT12'
select @sysTableTHID = sysTableID from sysTable where TableName = 'BLTK'

-- Update sysDataConfigDt
-- PC13
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableTHID and mtTableID = @sysTableID and NhomDK = 'PC13'

-- PsNoNT
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableTHID
and FieldName = 'PsNoNT'

Update sysDataConfigDt set Formula = N'TTThue/MT12.TyGia'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID and Formula is null

-- PC14
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableTHID and mtTableID = @sysTableID and NhomDK = 'PC14'

-- PsCoNT
select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableTHID
and FieldName = 'PsCoNT'

Update sysDataConfigDt set Formula = N'TTThue/MT12.TyGia'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID and Formula is null