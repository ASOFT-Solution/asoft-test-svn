USE CDT 

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[wMaCT]'))
DROP VIEW [dbo].[wMaCT]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create view wMaCT 
	as 
	Select f2.DefaultValue as MaCT , f.Diengiai as TenCT, f.Diengiai2 as TenCT2, f.TableName as TableName, f.PK as PK
	From sysTable f inner join sysField f2 on f.sysTableID = f2.sysTableID
    Where f2.FieldName = N'MaCT' AND f2.DefaultValue IS NOT NULL and f.Tablename <> N'wPhieuNhapHang' and f2.DefaultValue <> N'PTR'
	UNION SELECT N'PLR' as MaCT , N'Phiếu lắp ráp' as TenCT,N'Assembly''s type' as TenCT2, 'MT46', 'MT46ID'
	UNION SELECT N'PTD' as MaCT , N'Phiếu tháo dỡ' as TenCT, N'Dismantled''s type' as TenCT2, 'MT46', 'MT46ID'