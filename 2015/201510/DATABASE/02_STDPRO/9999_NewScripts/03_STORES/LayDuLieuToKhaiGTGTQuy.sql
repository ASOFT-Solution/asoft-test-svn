IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LayDuLieuToKhaiGTGTQuy]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LayDuLieuToKhaiGTGTQuy]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[LayDuLieuToKhaiGTGTQuy] 
		@Ky as int,
		@Nam as int
AS

Declare @QuyTruoc int,
		@NamTruoc int,
		@TG22 decimal(28,6),
		@TG23 decimal(28,6),
		@TG24 decimal(28,6),
		@TG25 decimal(28,6),
		@TG26 decimal(28,6),
		@TG27 decimal(28,6),
		@TG28 decimal(28,6),
		@TG29 decimal(28,6),
		@TG30 decimal(28,6),
		@TG31 decimal(28,6),
		@TG32 decimal(28,6),
		@TG33 decimal(28,6),
		@TG34 decimal(28,6),
		@TG35 decimal(28,6),
		@TG36 decimal(28,6),
		@TG37 decimal(28,6),
		@TG38 decimal(28,6),
		@TG39 decimal(28,6),
		@TG40 decimal(28,6),
		@TG40a decimal(28,6),
		@TG40b decimal(28,6),
		@TG41 decimal(28,6),
		@TG42 decimal(28,6),
		@TG43 decimal(28,6)
		
if @Ky = 1
BEGIN
	set @QuyTruoc = 4
	set @NamTruoc = @Nam - 1
END
else
BEGIN
	set @QuyTruoc = @Ky - 1
	set @NamTruoc = @Nam
END

-- Chi tieu [22]
select @TG22 = dt.ThueGTGT from MToKhai mst inner join DToKhai dt on mst.MToKhaiID = dt.MToKhaiID 
where NamToKhai = @NamTruoc and QuyToKhai = @QuyTruoc
and CodeThue = '[43]'

-- Chi tieu [23], [24]
Select @TG23 = sum(TTien), @TG24 = sum(Thue) from MVATIn mst inner join DVATIn dt on 
mst.MVATInID = dt.MVATInID
where  MaLoaiThue  in (1,2,3)
and QuyBKMV = @Ky and NamBKMV = @Nam

-- Chi tieu [25]
Select @TG25 = Sum(Thue) From MVATIn mst inner join DVATIn dt on 
mst.MVATInID = dt.MVATInID  
where MaLoaiThue in (1,3)
and QuyBKMV = @Ky and NamBKMV = @Nam

-- Chi tieu [26]
Select  @TG26 = sum(TTien) From MVATOut mst inner join DVATout dt on 
mst.MVATOutID = dt.MVATOutID 
where dt.MaThue = 'KT'
and QuyBKBR = @Ky and NamBKBR = @Nam

-- Chi tieu [29]
Select @TG29 = sum(TTien) From  MVATOut mst inner join DVATout dt on 
mst.MVATOutID = dt.MVATOutID 
where  MaThue = '00'
and QuyBKBR = @Ky and NamBKBR = @Nam

-- Chi tieu [30], [31]
Select @TG30 = sum(TTien), @TG31 = sum(Thue) From  MVATOut mst inner join DVATout dt on 
mst.MVATOutID = dt.MVATOutID 
where  MaThue = '05'
and QuyBKBR = @Ky and NamBKBR = @Nam

-- Chi tieu [32], [33]
Select @TG32 = sum(TTien), @TG33 = sum(Thue) From  MVATOut mst inner join DVATout dt on 
mst.MVATOutID = dt.MVATOutID 
where  MaThue = '10'
and QuyBKBR = @Ky and NamBKBR = @Nam

-- Chi tieu [27]=29+30+32
set @TG27 = isnull(@TG29,0) + isnull(@TG30,0) + isnull(@TG32,0)

-- Chi tieu [28] = 31+33
set @TG28 = isnull(@TG31,0) + isnull(@TG33,0)

-- Chi tieu [34] = 26+27
set @TG34 = isnull(@TG26,0) + isnull(@TG27,0)

-- Chi tieu [35] = 28
set @TG35 = isnull(@TG28,0)

-- Chi tieu [36] = [35] - [25]
set @TG36 = isnull(@TG35,0) - isnull(@TG25,0)

-- Chi tieu [37]
Select  @TG37 = sum(Totalps) from MT36 
Where MaLCTThue in (5,2) 
and QuyKTT = @QuyTruoc and Year(NgayCt) = @NamTruoc

-- Chi tieu [38]
Select  @TG38 = sum(Totalps) from MT36 
Where MaLCTThue in (4,3) 
and QuyKTT = @QuyTruoc and Year(NgayCt) = @NamTruoc

-- Chi tieu [40a] = 36 - 22 + 37 - 38 -39 > 0 va [41]
set @TG40a = isnull(@TG36,0) - isnull(@TG22,0) + isnull(@TG37,0) - isnull(@TG38,0) - isnull(@TG39,0)

if @TG40a < 0 
BEGIN
	set @TG41 = -@TG40a
	set @TG40a = 0
END

-- Chi tieu [40]=40a-40b	
set @TG40 = isnull(@TG40a,0) - isnull(@TG40b,0)

-- Chi tieu [43] = [41] - [42]
set @TG43 = isnull(@TG41,0) - isnull(@TG42,0)

select @TG22,@TG23,@TG24,@TG25,@TG26,@TG27,@TG28,@TG29,@TG30,@TG31,@TG32,@TG33,@TG34,@TG35,@TG36,@TG37,@TG38,@TG39,@TG40,@TG40a,@TG40b,@TG41,@TG42,@TG43 