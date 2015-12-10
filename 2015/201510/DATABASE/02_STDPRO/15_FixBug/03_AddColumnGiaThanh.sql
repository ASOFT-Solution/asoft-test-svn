Declare @MaYT varchar(16)
Declare @MaNhom varchar(16)

set @MaYT = 'GDLUONG'
set @MaNhom = 'GDC'

-- Ton tai MaNhom = 'GDC'
if exists (select top 1 1 from DMNhomGT where MaNhom = @MaNhom)
BEGIN

	-- Ton tai MaYT = 'GDLUONG'
	if exists (select top 1 1 from DMYTGT where MaYT = @MaYT)
	BEGIN
		-- Chua ton tai cach tinh gia
		if not exists (select top 1 1 from CoDTGT where MaNhom = @MaNhom and MaYT = @MaYT)
		BEGIN
			Insert into CoDTGT(MaNhom, MaYt) values(@MaNhom, @MaYT)
			
			alter table CoGiaGDC add GDLUONG [decimal](20, 6) not null CONSTRAINT [df_CoGiaGDC_GDLUONG] DEFAULT (0)
		END
	END
END

set @MaYT = 'GDSXC'
set @MaNhom = 'GDC'

-- Ton tai MaNhom = 'GDC'
if exists (select top 1 1 from DMNhomGT where MaNhom = @MaNhom)
BEGIN

	-- Ton tai MaYT = 'GDSXC'
	if exists (select top 1 1 from DMYTGT where MaYT = @MaYT)
	BEGIN
		-- Chua ton tai cach tinh gia
		if not exists (select top 1 1 from CoDTGT where MaNhom = @MaNhom and MaYT = @MaYT)
		BEGIN
			Insert into CoDTGT(MaNhom, MaYt) values(@MaNhom, @MaYT)
			
			alter table CoGiaGDC add GDSXC [decimal](20, 6) not null CONSTRAINT [df_CoGiaGDC_GDSXC] DEFAULT (0)
		END
	END
END