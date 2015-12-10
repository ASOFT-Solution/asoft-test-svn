use [CDT]

declare @sysTableID int,
		@sysFieldID int,
		@sysTableBLID int,
		@TTDBInID int,
		@TienTTDB int,
		@TienTTDBNT int,
		@PsNo int,
		@PsNoNT int,
		@PsCo int,
		@PsCoNT int,
		@NhomDK varchar(50)

-- Update sysDataConfig
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @TTDBInID = sysTableID from sysTable where TableName = 'TTDBIn'

select @TienTTDB = sysFieldID from sysField where sysTableID = @TTDBInID and FieldName = 'TienTTDB'
select @TienTTDBNT = sysFieldID from sysField where sysTableID = @TTDBInID and FieldName = 'TienTTDBNT'

select @PsNo = sysFieldID from sysField where sysTableID = @sysTableBLID and FieldName = 'PsNo'
select @PsNoNT = sysFieldID from sysField where sysTableID = @sysTableBLID and FieldName = 'PsNoNT'

select @PsCo = sysFieldID from sysField where sysTableID = @sysTableBLID and FieldName = 'PsCo'
select @PsCoNT = sysFieldID from sysField where sysTableID = @sysTableBLID and FieldName = 'PsCoNT'

-- PNM7
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @NhomDK = 'PNM7'

Update sysDataConfig set dt2TableID = @TTDBInID
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and dt2TableID is null

Update sysDataConfig set Condition = N'(DT22.ChiuThueTTDB = 1 and TTDBIn.TienTTDB <> 0)'
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition = N'(DT22.ChiuThueTTDB = 1 and MT22.ToTalTienTTDB <> 0)'

Update sysDataConfigDt set mtFieldID = null, dt2FieldID = @TienTTDB
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK)
				and blFieldID = @PsNo and dt2FieldID is null
				
Update sysDataConfigDt set mtFieldID = null, dt2FieldID = @TienTTDBNT
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK)
				and blFieldID = @PsNoNT and dt2FieldID is null

-- PNM8
set @NhomDK = 'PNM8'

Update sysDataConfig set dt2TableID = @TTDBInID
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and dt2TableID is null

Update sysDataConfig set Condition = N'(DT22.ChiuThueTTDB = 1 and TTDBIn.TienTTDB <> 0)'
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition = N'(DT22.ChiuThueTTDB = 1 and MT22.ToTalTienTTDB <> 0)'

Update sysDataConfigDt set mtFieldID = null, dt2FieldID = @TienTTDB
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK)
				and blFieldID = @PsCo and dt2FieldID is null
				
Update sysDataConfigDt set mtFieldID = null, dt2FieldID = @TienTTDBNT
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK)
				and blFieldID = @PsCoNT and dt2FieldID is null
				
-- MDV5
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
set @NhomDK = 'MDV5'

Update sysDataConfig set dt2TableID = @TTDBInID
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and dt2TableID is null

Update sysDataConfig set Condition = N'(DT21.ChiuThueTTDB = 1 and TTDBIn.TienTTDB <> 0)'
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition = N'(DT21.ChiuThueTTDB = 1 and MT21.ToTalTienTTDB <> 0)'

Update sysDataConfigDt set mtFieldID = null, dt2FieldID = @TienTTDB
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK)
				and blFieldID = @PsNo and dt2FieldID is null
				
Update sysDataConfigDt set mtFieldID = null, dt2FieldID = @TienTTDBNT
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK)
				and blFieldID = @PsNoNT and dt2FieldID is null

-- MDV6
set @NhomDK = 'MDV6'

Update sysDataConfig set dt2TableID = @TTDBInID
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and dt2TableID is null

Update sysDataConfig set Condition = N'(DT21.ChiuThueTTDB = 1 and TTDBIn.TienTTDB <> 0)'
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition = N'(DT21.ChiuThueTTDB = 1 and MT21.ToTalTienTTDB <> 0)'

Update sysDataConfigDt set mtFieldID = null, dt2FieldID = @TienTTDB
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK)
				and blFieldID = @PsCo and dt2FieldID is null
				
Update sysDataConfigDt set mtFieldID = null, dt2FieldID = @TienTTDBNT
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK)
				and blFieldID = @PsCoNT and dt2FieldID is null
				
-- PNK7
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @NhomDK = 'PNK7'

Update sysDataConfig set dt2TableID = @TTDBInID
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and dt2TableID is null

Update sysDataConfig set Condition = N'(DT23.ChiuThueTTDB = 1 and TTDBIn.TienTTDB <> 0)'
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition = N'(DT23.ChiuThueTTDB = 1 and MT23.ToTalTienTTDB <> 0)'

Update sysDataConfigDt set mtFieldID = null, dt2FieldID = @TienTTDB
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK)
				and blFieldID = @PsNo and dt2FieldID is null
				
Update sysDataConfigDt set mtFieldID = null, dt2FieldID = @TienTTDBNT
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK)
				and blFieldID = @PsNoNT and dt2FieldID is null

-- PNK8
set @NhomDK = 'PNK8'

Update sysDataConfig set dt2TableID = @TTDBInID
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and dt2TableID is null

Update sysDataConfig set Condition = N'(DT23.ChiuThueTTDB = 1 and TTDBIn.TienTTDB <> 0)'
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition = N'(DT23.ChiuThueTTDB = 1 and MT23.ToTalTienTTDB <> 0)'

Update sysDataConfigDt set mtFieldID = null, dt2FieldID = @TienTTDB
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK)
				and blFieldID = @PsCo and dt2FieldID is null
				
Update sysDataConfigDt set mtFieldID = null, dt2FieldID = @TienTTDBNT
where blConfigID = (select blConfigID from sysDataConfig where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK)
				and blFieldID = @PsCoNT and dt2FieldID is null