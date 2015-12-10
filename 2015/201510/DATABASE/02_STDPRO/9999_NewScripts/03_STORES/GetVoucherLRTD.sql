IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].GetVoucherLRTD') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].GetVoucherLRTD
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].GetVoucherLRTD 
@ngayct1 datetime,
@ngayct2 datetime,
@Mact varchar(16),
@NhapXuat bit,
@OtherVoucher bit
as
-- Loai 1: Lắp ráp
--	Nhập : PTR1 (BLVT), PTR7, PTR8 (BLTK)
--	Xuất : PTR2, PTR5, PTR6
-- Loai 0: Tháo dở
--	Nhập : PTR3, PTR9, PTR10
--	Xuất : PTR4, PTR11, PTR12

if (@OtherVoucher = 0)
BEGIN
   if (@NhapXuat = '0')
		BEGIN
			Select Distinct b.MTID, x.MaCT,x.TenCT, x.TenCT2,b.Ngayct, b.Soct,'' as SoCT_New,  b.nhapxuat
			From (SELECT N'PLR' as MaCT , N'Phiếu lắp ráp' as TenCT,  N'Assembly''s type' as TenCT2
				  union
				  SELECT N'PTD' as MaCT , N'Phiếu tháo dỡ' as TenCT,  N'Dismantled''s type' as TenCT2	
				  ) x inner join wGetVoucherLRTD b on x.mact = b.mact 
			Where b.MaCT = @MaCT and b.nhapxuat = '0' and (b.ngayct between @ngayct1 and @ngayct2) 
			order by b.ngayct,b.soct 
		END
	Else if (@NhapXuat = '1')
	Begin
		BEGIN
			Select Distinct b.MTID, x.MaCT,x.TenCT, x.TenCT2, b.Ngayct, b.Soct,'' as SoCT_New,  b.nhapxuat
			From (SELECT N'PLR' as MaCT , N'Phiếu lắp ráp' as TenCT,  N'Assembly''s type' as TenCT2
				  union
				  SELECT N'PTD' as MaCT , N'Phiếu tháo dỡ' as TenCT	,  N'Dismantled''s type' as TenCT2	
				  ) x inner join wGetVoucherLRTD b on x.mact = b.mact 
			Where b.MaCT = @MaCT and b.nhapxuat = '1' and (b.ngayct between @ngayct1 and @ngayct2) 
			order by b.ngayct,b.soct 
		END
	END
END
ELSE
	BEGIN
		if (@NhapXuat = '0')
		BEGIN
			Select Distinct b.MTID, x.MaCT,x.TenCT ,b.Ngayct, b.Soct,'' as SoCT_New,   b.nhapxuat
			From (SELECT N'PLR' as MaCT , N'Phiếu lắp ráp' as TenCT
				  union
				  SELECT N'PTD' as MaCT , N'Phiếu tháo dỡ' as TenCT	
				  ) x inner join wGetVoucherLRTD b on x.mact = b.mact 
			Where b.MaCT = @MaCT and b.nhapxuat = '0' and (b.ngayct < @ngayct1 or  b.ngayct > @ngayct2)  
			order by b.ngayct,b.soct 
		END
	Else if (@NhapXuat = '1')
	Begin
		BEGIN
			Select Distinct b.MTID, x.MaCT,x.TenCT ,b.Ngayct, b.Soct,'' as SoCT_New, b.nhapxuat
			From (SELECT N'PLR' as MaCT , N'Phiếu lắp ráp' as TenCT
				  union
				  SELECT N'PTD' as MaCT , N'Phiếu tháo dỡ' as TenCT	
				  ) x inner join wGetVoucherLRTD b on x.mact = b.mact 
			Where b.MaCT = @MaCT and b.nhapxuat = '1' and (b.ngayct < @ngayct1 or  b.ngayct > @ngayct2) 
			order by b.ngayct,b.soct 
		END
	END
END

