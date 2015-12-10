IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TinhGia]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TinhGia]
GO

/****** Object:  StoredProcedure [dbo].[TinhGia]    Script Date: 02/14/2012 16:13:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO






CREATE		PROCEDURE [dbo].[TinhGia]
@mtiddt uniqueidentifier = null,
@tungay datetime,
@denngay datetime,
@makho varchar(16),
@mavt varchar(16),
@SlXuat decimal(16,6),
@DonGia Float output
as
declare @TonKho int
select @TonKho = Tonkho from DMVT where MaVT = @MaVT

set @DonGia = -1
if (@TonKho = 2)
 	EXEC TinhGiaNTXT @MTIDDT,@DenNgay,@MaKho,@MaVT,@SlXuat, @DonGia output
if (@TonKho = 3 or @TonKho = 4)
	EXEC TinhGiaBQDD @MTIDDT,@TuNgay,@DenNgay,@MaKho,@MaVT, @DonGia output
