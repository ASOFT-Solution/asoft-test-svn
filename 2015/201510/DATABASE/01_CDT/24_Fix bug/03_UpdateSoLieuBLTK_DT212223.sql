use [CDT]

declare @sysTableBLTKID int,
		@sysTableID int,
		@sysFieldId int,
		@sysDataConfigID int
		
-- 1) Hóa đơn dịch vụ
select @sysTableID = sysTableID from sysTable where TableName = 'DT21'
select @sysTableBLTKID = sysTableID from sysTable where TableName = 'BLTK'

-- Update sysDataConfigDt
-- PsNo
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLTKID and dtTableID = @sysTableID and NhomDK = 'MDV1'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLTKID
and FieldName = 'PSNo'

Update sysDataConfigDt set DtFieldID = null, Formula = N'Ps - isnull(TienCK,0)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLTKID
and FieldName = 'PSNoNT'

Update sysDataConfigDt set DtFieldID = null, Formula = N'PsNT - isnull(TienCKNT,0)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

-- PSCo
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLTKID and dtTableID = @sysTableID and NhomDK = 'MDV2'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLTKID
and FieldName = 'PSCo'

Update sysDataConfigDt set DtFieldID = null, Formula = N'Ps - isnull(TienCK,0)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLTKID
and FieldName = 'PSCoNT'

Update sysDataConfigDt set DtFieldID = null, Formula = N'PsNT - isnull(TienCKNT,0)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

-- 2) Hóa đơn nhập khẩu kiêm phiếu nhập kho
select @sysTableID = sysTableID from sysTable where TableName = 'DT23'
select @sysTableBLTKID = sysTableID from sysTable where TableName = 'BLTK'

-- Update sysDataConfigDt
-- PsNo
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLTKID and dtTableID = @sysTableID and NhomDK = 'PNK1'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLTKID
and FieldName = 'PSNo'

Update sysDataConfigDt set Formula = N'Ps + CPCt - isnull(TienCK,0)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLTKID
and FieldName = 'PSNoNT'

Update sysDataConfigDt set Formula = N'PsNT + CPCtNT - isnull(TienCKNT,0)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

-- PSCo
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLTKID and dtTableID = @sysTableID and NhomDK = 'PNK2'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLTKID
and FieldName = 'PSCo'

Update sysDataConfigDt set Formula = N'Ps + CPCt - isnull(TienCK,0)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLTKID
and FieldName = 'PSCoNT'

Update sysDataConfigDt set Formula = N'PsNT + CPCtNT - isnull(TienCKNT,0)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

-- 3) Hóa đơn mua hàng
select @sysTableID = sysTableID from sysTable where TableName = 'DT22'
select @sysTableBLTKID = sysTableID from sysTable where TableName = 'BLTK'

-- Update sysDataConfigDt
-- PsNo
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLTKID and dtTableID = @sysTableID and NhomDK = 'PNM1'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLTKID
and FieldName = 'PSNo'

Update sysDataConfigDt set DtFieldID = null, Formula = N'Ps - isnull(TienCK,0)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLTKID
and FieldName = 'PSNoNT'

Update sysDataConfigDt set DtFieldID = null, Formula = N'PsNT - isnull(TienCKNT,0)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

-- PSCo
select @sysDataConfigID = blConfigID 
from sysDataConfig
where sysTableID = @sysTableBLTKID and dtTableID = @sysTableID and NhomDK = 'PNM2'

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLTKID
and FieldName = 'PSCo'

Update sysDataConfigDt set DtFieldID = null, Formula = N'Ps - isnull(TienCK,0)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID

select @sysFieldId = sysFieldID from sysField
where sysTableID = @sysTableBLTKID
and FieldName = 'PSCoNT'

Update sysDataConfigDt set DtFieldID = null, Formula = N'PsNT - isnull(TienCKNT,0)'
where blFieldId = @sysFieldId and blConfigID = @sysDataConfigID