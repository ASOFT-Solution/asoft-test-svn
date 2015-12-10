IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetValueForExcelReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetValueForExcelReport]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE    procedure [dbo].[GetValueForExcelReport]

@ngayCt1 datetime,
@ngayCt2 datetime,
@LoaiCt int,
@tk nvarchar (256),
@tkdu nvarchar (256),
@value decimal(28, 6) output,
@iscn bit = 0

as
declare @duno decimal(28, 6)
declare @duco decimal(28, 6)

if (@LoaiCt = 1 or @LoaiCt = 2) and left(@tk,1) not in ('5','6','7','8') --dau ky
begin
	set @ngayCt1= dateadd(day,-1,@ngayCt1)
	exec sodutaikhoan @tk, @ngayCt1, DEFAULT, @duno OUTPUT , @duco OUTPUT 
	if @iscn=1
		begin	
			if @loaiCt=1 set @value=@duno
			if @loaiCt=2 set @value=@duco
		end
	if @iscn=0
		begin	
			if @loaiCt=1 set @value=@duno - @duco
			if @loaiCt=2 set @value=@duco - @duno
		end
end
if (@LoaiCt = 5 or @LoaiCt = 6) --cuoi ky
begin
	exec sodutaikhoan @tk, @ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT
 	if @iscn=1
		begin	
			if @loaiCt=5 set @value=@duno
			if @loaiCt=6 set @value=@duco
		end
	if @iscn=0
		begin	
			if @loaiCt=5 set @value=@duno - @duco
			if @loaiCt=6 set @value=@duco - @duno
		end
end
if @LoaiCt = 3 or @LoaiCt = 4 or left(@tk,1) in ('5','6','7','8')--phat sinh
begin	--lay so phat sinh nam truoc cho truong hop muon lay so nam truoc cua cac tai khoan doanh thu chi phi
	if (@LoaiCt = 1 or @LoaiCt = 2) and left(@tk,1) in ('5','6','7','8')
	begin
		set @ngayct2 = dateadd(day,-1,@ngayCt1)
		set @ngayct1 = cast('01/01/' + convert(nvarchar,year(@ngayct2)) as datetime)
	end
	if @tkdu is not null 
	begin		
		set @tkdu=' tkdu like ''' +replace(@tkdu,',','%'' or tkdu like ''') + '%''' 
		print @tkdu
		exec sopstaikhoan @tk, @ngayCt1,@ngayCt2,@tkdu , @duno OUTPUT , @duco OUTPUT 
	end
	else 		
		exec sopstaikhoan @tk, @ngayCt1,@ngayCt2, DEFAULT, @duno OUTPUT , @duco OUTPUT 
	if @loaiCt=3 or @loaict = 1 set @value=@duno
	if @loaiCt=4 or @loaict = 2 set @value=@duco
end