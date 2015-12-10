use [CDT]

declare @sysTableBLID int,
		@DetailTableID int,
		@TienCK int,
		@TienCKNT int,
		@PsNo int,
		@PsNoNT int,
		@PsCo int,
		@PsCoNT int,
		@NhomDK varchar(50)

select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @DetailTableID = sysTableID from sysTable where TableName = 'DT33'

select @TienCK = sysFieldID from sysField where sysTableID = @DetailTableID and FieldName = 'TienCK'
select @TienCKNT = sysFieldID from sysField where sysTableID = @DetailTableID and FieldName = 'TienCKNT'

select @PsNo = sysFieldID from sysField where sysTableID = @sysTableBLID and FieldName = 'PsNo'
select @PsNoNT = sysFieldID from sysField where sysTableID = @sysTableBLID and FieldName = 'PsNoNT'

select @PsCo = sysFieldID from sysField where sysTableID = @sysTableBLID and FieldName = 'PsCo'
select @PsCoNT = sysFieldID from sysField where sysTableID = @sysTableBLID and FieldName = 'PsCoNT'

-- HTL7
set @NhomDK = 'HTL7'

Update sysDataConfigDt set mtFieldID = null, dtFieldID = @TienCK
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @DetailTableID and NhomDK = @NhomDK)
				and blFieldID = @PsNo and dtFieldID is null
				
Update sysDataConfigDt set mtFieldID = null, dtFieldID = @TienCKNT
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @DetailTableID and NhomDK = @NhomDK)
				and blFieldID = @PsNoNT and dtFieldID is null

-- HTL8
set @NhomDK = 'HTL8'

Update sysDataConfigDt set mtFieldID = null, dtFieldID = @TienCK
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @DetailTableID and NhomDK = @NhomDK)
				and blFieldID = @PsCo and dtFieldID is null
				
Update sysDataConfigDt set mtFieldID = null, dtFieldID = @TienCKNT
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and dtTableID = @DetailTableID and NhomDK = @NhomDK)
				and blFieldID = @PsCoNT and dtFieldID is null