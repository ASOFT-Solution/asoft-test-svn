IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].GetVoucher') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].GetVoucher
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].GetVoucher 
@ngayct1 datetime,
@ngayct2 datetime,
@Mact varchar(16),
@OtherVoucher int,
@TableName varchar(50),
@PK varchar(50)
as
Declare @sql nvarchar(4000)
if (@OtherVoucher = 0)
	BEGIN
	set @sql = 'Select Distinct b.' + @PK + ', x.MaCT,x.TenCT, x.TenCT2 ,b.Ngayct, b.Soct,'''' as SoCT_New
			From (Select	f2.DefaultValue as MaCT , f.Diengiai as TenCT, f.Diengiai2 as TenCT2
								from CDT.dbo.sysTable f inner join CDT.dbo.sysField f2 on f.sysTableID = f2.sysTableID
								Where f2.FieldName = ''MaCT'' AND f2.DefaultValue IS NOT NULL 
															and f.Tablename <> ''wPhieuNhapHang'' and f2.DefaultValue <> N''PTR''
				) x inner join ' + @TableName + ' b on x.mact = b.mact 
			Where b.mact = ''' + @Mact + ''' and b.ngayct between cast(''' + CONVERT(NVARCHAR, @ngayct1) + ''' as datetime) and cast(''' + CONVERT(NVARCHAR,@ngayct2) + ''' as datetime)
			order by b.ngayct,b.soct'
	END
ELSE
BEGIN
	BEGIN
		set @sql = 'Select Distinct b.' + @PK + ', x.MaCT,x.TenCT, x.TenCT2 ,b.Ngayct, b.Soct,'''' as SoCT_New
				From (Select	f2.DefaultValue as MaCT , f.Diengiai as TenCT, f.Diengiai2 as TenCT2
									from CDT.dbo.sysTable f inner join CDT.dbo.sysField f2 on f.sysTableID = f2.sysTableID
									Where f2.FieldName = ''MaCT'' AND f2.DefaultValue IS NOT NULL 
																and f.Tablename <> ''wPhieuNhapHang'' and f2.DefaultValue <> N''PTR''
					) x inner join ' + @TableName + ' b on x.mact = b.mact 
				Where b.mact = ''' + @Mact + ''' and (b.ngayct < cast(''' + CONVERT(NVARCHAR,@ngayct1) + ''' as datetime) or  b.ngayct > cast(''' + CONVERT(NVARCHAR,@ngayct2) + ''' as datetime)) 
				order by b.ngayct,b.soct '
	END
END

exec(@sql)