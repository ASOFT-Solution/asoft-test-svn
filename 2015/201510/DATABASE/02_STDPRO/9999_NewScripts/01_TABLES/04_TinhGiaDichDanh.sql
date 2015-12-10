If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OBVT'  and col.name = 'SoCTOBVT')
BEGIN
	ALTER TABLE OBVT ADD  SoCTOBVT [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OBVT'  and col.name = 'LotNumber')
BEGIN
	ALTER TABLE OBVT ADD  LotNumber [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OBVT'  and col.name = 'ExpireDate')
BEGIN
	ALTER TABLE OBVT ADD  [ExpireDate] smalldatetime NULL
END

GO

-- [BEGIN] - Tự động cập nhật số liệu field SoCTOBVT
declare @soct nvarchar(512),
		@NextSoct int,
		@id uniqueidentifier,
		@PrefixSoCT varchar(5)

set @PrefixSoCT = 'OB'

-- Lấy danh sách các số dư vật tư chưa được đánh số chứng từ
declare cur_obvt cursor for
select OBVTID from OBVT where SoCTOBVT is null

Open cur_obvt

fetch cur_obvt into @id

WHILE @@FETCH_STATUS = 0 
BEGIN
	select @NextSoct = Max(isnull(substring(SoCTOBVT, len(@PrefixSoCT) + 1 , len(SoCTOBVT) - 2),0)) + 1 from OBVT
	
	set @soct = @PrefixSoCT + cast(@NextSoct as nvarchar(512))
	Update OBVT set SoCTOBVT = @soct from OBVT where OBVTID = @id
	
	fetch cur_obvt into @id
END

close cur_obvt
deallocate cur_obvt

if @soct is not null
BEGIN
Update CDT.dbo.sysField set EditMask = @soct
where sysTableID = (select sysTableID from CDT.dbo.sysTable where TableName = N'OBVT')
		and FieldName = 'SoCTOBVT'
END
-- [END] - Tự động cập nhật số liệu field SoCTOBVT

If exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'OBVT'  and col.name = 'SoCTOBVT')
BEGIN
	ALTER TABLE OBVT ALTER COLUMN  SoCTOBVT [nvarchar](512) NOT NULL
END

-- BLVT
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'BLVT'  and col.name = 'SoCTDT')
BEGIN
	ALTER TABLE BLVT ADD  SoCTDT [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'BLVT'  and col.name = 'LotNumber')
BEGIN
	ALTER TABLE BLVT ADD  LotNumber [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'BLVT'  and col.name = 'ExpireDate')
BEGIN
	ALTER TABLE BLVT ADD  [ExpireDate] smalldatetime NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'BLVT'  and col.name = 'MTIDDoiTru')
BEGIN
	ALTER TABLE BLVT ADD  MTIDDoiTru uniqueidentifier NULL
END

-- DT45
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT45'  and col.name = 'SoCTDT')
BEGIN
	ALTER TABLE DT45 ADD  SoCTDT [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT45'  and col.name = 'LotNumber')
BEGIN
	ALTER TABLE DT45 ADD  LotNumber [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT45'  and col.name = 'ExpireDate')
BEGIN
	ALTER TABLE DT45 ADD  [ExpireDate] smalldatetime NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT45'  and col.name = 'MTIDDoiTru')
BEGIN
	ALTER TABLE DT45 ADD  MTIDDoiTru uniqueidentifier NULL
END

-- DT24
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT24'  and col.name = 'SoCTDT')
BEGIN
	ALTER TABLE DT24 ADD  SoCTDT [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT24'  and col.name = 'LotNumber')
BEGIN
	ALTER TABLE DT24 ADD  LotNumber [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT24'  and col.name = 'ExpireDate')
BEGIN
	ALTER TABLE DT24 ADD  [ExpireDate] smalldatetime NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT24'  and col.name = 'MTIDDoiTru')
BEGIN
	ALTER TABLE DT24 ADD  MTIDDoiTru uniqueidentifier NULL
END

-- DT32
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT32'  and col.name = 'SoCTDT')
BEGIN
	ALTER TABLE DT32 ADD  SoCTDT [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT32'  and col.name = 'LotNumber')
BEGIN
	ALTER TABLE DT32 ADD  LotNumber [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT32'  and col.name = 'ExpireDate')
BEGIN
	ALTER TABLE DT32 ADD  [ExpireDate] smalldatetime NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT32'  and col.name = 'MTIDDoiTru')
BEGIN
	ALTER TABLE DT32 ADD  MTIDDoiTru uniqueidentifier NULL
END

-- DT44
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT44'  and col.name = 'SoCTDT')
BEGIN
	ALTER TABLE DT44 ADD  SoCTDT [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT44'  and col.name = 'LotNumber')
BEGIN
	ALTER TABLE DT44 ADD  LotNumber [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT44'  and col.name = 'ExpireDate')
BEGIN
	ALTER TABLE DT44 ADD  [ExpireDate] smalldatetime NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT44'  and col.name = 'MTIDDoiTru')
BEGIN
	ALTER TABLE DT44 ADD  MTIDDoiTru uniqueidentifier NULL
END

-- DT43
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT43'  and col.name = 'SoCTDT')
BEGIN
	ALTER TABLE DT43 ADD  SoCTDT [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT43'  and col.name = 'LotNumber')
BEGIN
	ALTER TABLE DT43 ADD  LotNumber [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT43'  and col.name = 'ExpireDate')
BEGIN
	ALTER TABLE DT43 ADD  [ExpireDate] smalldatetime NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT43'  and col.name = 'MTIDDoiTru')
BEGIN
	ALTER TABLE DT43 ADD  MTIDDoiTru uniqueidentifier NULL
END

-- DT22
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT22'  and col.name = 'LotNumber')
BEGIN
	ALTER TABLE DT22 ADD  LotNumber [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT22'  and col.name = 'ExpireDate')
BEGIN
	ALTER TABLE DT22 ADD  [ExpireDate] smalldatetime NULL
END

-- DT23
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT23'  and col.name = 'LotNumber')
BEGIN
	ALTER TABLE DT23 ADD  LotNumber [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT23'  and col.name = 'ExpireDate')
BEGIN
	ALTER TABLE DT23 ADD  [ExpireDate] smalldatetime NULL
END

-- DT41
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT41'  and col.name = 'LotNumber')
BEGIN
	ALTER TABLE DT41 ADD  LotNumber [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT41'  and col.name = 'ExpireDate')
BEGIN
	ALTER TABLE DT41 ADD  [ExpireDate] smalldatetime NULL
END

-- DT42
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT42'  and col.name = 'LotNumber')
BEGIN
	ALTER TABLE DT42 ADD  LotNumber [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT42'  and col.name = 'ExpireDate')
BEGIN
	ALTER TABLE DT42 ADD  [ExpireDate] smalldatetime NULL
END

-- DT33
If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT33'  and col.name = 'LotNumber')
BEGIN
	ALTER TABLE DT33 ADD  LotNumber [nvarchar](512) NULL
END

If not exists (select * from syscolumns col inner join sysobjects tab 
           On col.id = tab.id where tab.name =   'DT33'  and col.name = 'ExpireDate')
BEGIN
	ALTER TABLE DT33 ADD  [ExpireDate] smalldatetime NULL
END