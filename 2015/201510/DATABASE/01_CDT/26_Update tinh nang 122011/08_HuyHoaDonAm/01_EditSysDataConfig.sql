use [CDT]
declare @sysTableBLID int,
		@sysTableID int,
		@NhomDK nvarchar(255),
		@Condition nvarchar(255)

-- PC13
set @NhomDK = 'PC13'
select @sysTableID = sysTableID from sysTable where TableName = 'MT12'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
set @Condition = N'(TTThue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PC14
set @NhomDK = 'PC14'
select @sysTableID = sysTableID from sysTable where TableName = 'MT12'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
set @Condition = N'(TTThue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PBN3
set @NhomDK = 'PBN3'
select @sysTableID = sysTableID from sysTable where TableName = 'MT16'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
set @Condition = N'(MT16.TTThue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PBN4
set @NhomDK = 'PBN4'
select @sysTableID = sysTableID from sysTable where TableName = 'MT16'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
set @Condition = N'(MT16.TTThue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- MDV4
set @NhomDK = 'MDV4'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
set @Condition = N'(TThue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- MDV3
set @NhomDK = 'MDV3'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
set @Condition = N'(TThue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- MDV5
set @NhomDK = 'MDV5'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
set @Condition = N'(DT21.ChiuThueTTDB = 1 and MT21.ToTalTienTTDB <> 0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- MDV6
set @NhomDK = 'MDV6'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT21'
set @Condition = N'(DT21.ChiuThueTTDB = 1 and MT21.ToTalTienTTDB <> 0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PNM3
set @NhomDK = 'PNM3'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @Condition = N'(Tthue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PNM4
set @NhomDK = 'PNM4'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @Condition = N'(Tthue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PNM5
set @NhomDK = 'PNM5'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @Condition = N'(CPCt<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PNM6
set @NhomDK = 'PNM6'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @Condition = N'(CPCT<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PNM7
set @NhomDK = 'PNM7'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @Condition = N'(DT22.ChiuThueTTDB = 1 and MT22.ToTalTienTTDB <> 0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PNM8
set @NhomDK = 'PNM8'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT22'
set @Condition = N'(DT22.ChiuThueTTDB = 1 and MT22.ToTalTienTTDB <> 0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- HDV3
set @NhomDK = 'HDV3'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT31'
set @Condition = N'(Tthue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- HDV4
set @NhomDK = 'HDV4'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT31'
set @Condition = N'(Tthue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- HDV5
set @NhomDK = 'HDV5'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT31'
set @Condition = N'(TCK<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- HDV6
set @NhomDK = 'HDV6'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT31'
set @Condition = N'(TCK<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- HDB5
set @NhomDK = 'HDB5'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
set @Condition = N'(Tthue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- HDB6
set @NhomDK = 'HDB6'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
set @Condition = N'(Tthue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- HDB7
set @NhomDK = 'HDB7'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
set @Condition = N'(TCK<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- HDB8
set @NhomDK = 'HDB8'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT32'
set @Condition = N'(TCK<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- HTL5
set @NhomDK = 'HTL5'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT33'
set @Condition = N'(Tthue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- HTL6
set @NhomDK = 'HTL6'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT33'
set @Condition = N'(Tthue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- HTL8
set @NhomDK = 'HTL8'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT33'
set @Condition = N'(TCK<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- HTL7
set @NhomDK = 'HTL7'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT33'
set @Condition = N'(TCK<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PKT5
set @NhomDK = 'PKT5'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @Condition = N'(MT51.TPsNo<>0 and MT51.TTThue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PKT6
set @NhomDK = 'PKT6'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @Condition = N'(Mt51.TPsNo<>0  and MT51.TTThue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PKT7
set @NhomDK = 'PKT7'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @Condition = N'(Mt51.TPsNo=0  and MT51.TTThue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PKT8
set @NhomDK = 'PKT8'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @Condition = N'(Mt51.TPsNo=0  and MT51.TTThue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PKT1
set @NhomDK = 'PKT1'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @Condition = N'(dt51.PsNo<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PKT2
set @NhomDK = 'PKT2'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT51'
set @Condition = N'(dt51.PsNo<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PNK3
set @NhomDK = 'PNK3'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @Condition = N'(Tthue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PNK4
set @NhomDK = 'PNK4'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @Condition = N'(Tthue<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PNK5
set @NhomDK = 'PNK5'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @Condition = N'(ThueNK<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PNK6
set @NhomDK = 'PNK6'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @Condition = N'(ThueNK<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PNK7
set @NhomDK = 'PNK7'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @Condition = N'(DT23.ChiuThueTTDB = 1 and MT23.ToTalTienTTDB <> 0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- PNK8
set @NhomDK = 'PNK8'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT23'
set @Condition = N'(DT23.ChiuThueTTDB = 1 and MT23.ToTalTienTTDB <> 0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- DCN1
set @NhomDK = 'DCN1'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT35'
set @Condition = N'(dt35.TienThu<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- DCN2
set @NhomDK = 'DCN2'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT35'
set @Condition = N'(dt35.TienThu<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- DCN3
set @NhomDK = 'DCN3'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT35'
set @Condition = N'(dt35.TienChi<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition

-- DCN4
set @NhomDK = 'DCN4'
select @sysTableBLID = sysTableID from sysTable where TableName = 'BLTK'
select @sysTableID = sysTableID from sysTable where TableName = 'MT35'
set @Condition = N'(dt35.TienChi<>0)'

Update sysDataConfig set Condition = @Condition
where sysTableID = @sysTableBLID and mtTableID = @sysTableID and NhomDK = @NhomDK and Condition <> @Condition
