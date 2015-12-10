-- [CRM: TT9629]: Fix lỗi lưu tiền thuế nguyên tệ giấy báo nợ
use [CDT]
declare @sysTableBLID int,
		@sysTableID int,
		@sysFieldId int,
		@sysDataConfigID int

-- Update sysDataConfigDt
select @sysTableID = sysTableID from sysTable where TableName = 'MT16'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'

-- PBN3
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'PBN3'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLID
and FieldName = 'PsNoNT'

Update sysDataConfigDt set Formula = N'case when MT16.TyGia = 0 then 0 else TTThue/MT16.TyGia end'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID and Formula is null

-- PBN4
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = 'PBN4'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLID
and FieldName = 'PsCoNT'

Update sysDataConfigDt set Formula = N'case when MT16.TyGia = 0 then 0 else TTThue/MT16.TyGia end'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID and Formula is null
