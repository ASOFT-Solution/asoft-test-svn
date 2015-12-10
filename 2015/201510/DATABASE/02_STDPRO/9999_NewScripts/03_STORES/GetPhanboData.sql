/****** Object:  StoredProcedure [dbo].[GetPhanboData]    Script Date: 03/16/2012 10:25:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPhanboData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPhanboData]
GO


/****** Object:  StoredProcedure [dbo].[GetPhanboData]    Script Date: 03/16/2012 10:25:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetPhanboData] @ngayCt1 DATETIME,
                                      @ngayCt2 DATETIME
AS
    SELECT z.mact,
           z.soct,
           z.makh,
           z.tenkh,
           z.MaNT,
           diengiai,
           y.*,
           0.0 AS pb
    FROM   (SELECT Max(ngayCt)   AS ngayCt,
                   mt45id,
                   dt45id,
                   Sum(soluong)  AS soluong,
                   Sum(slH)      AS slH,
                   Sum(slHTruoc) AS slHTruoc,
                   Sum(ps)       AS ps,
                   Max(tkno)     AS tkno,
                   Max(tkcp)     AS tkcp,
                   Max(mavt)     AS mavt,
                   Max(mabp)     AS mabp,
                   Max(maphi)    AS maphi,
                   Max(mavv)     AS mavv,
                   Max(macongtrinh)  AS macongtrinh,
                   Sum(kypb)     AS kypb,
                   Sum(soky)     AS soky,
                   0 as SLConLai,
                   0 as SLHong,
                   0 as PhanBoDeu,
                   0.000000 as TienHong,
                   0.000000 as TSBaoHong,
                   0.000000 as TPhanBo,
                   0.000000 as TDaPhanBo,
                   0.000000 as TConLai
                   
            FROM   (SELECT b.ngayCt,
                           a.MT45ID,
                           dt45id,
                           a.soluong,
                           0 AS slH,
                           0 AS slHTruoc,
                           a.mavt,
                           a.ps,
                           a.tkno,
                           a.tkcp,
                           a.mabp,
                           a.maphi,
                           a.mavv,
                           a.macongtrinh,
                           kypb,
                           soky
                    FROM   dt45 a
                           INNER JOIN mt45 b
                             ON a.mt45id = b.mt45id
                   WHERE soky > (select count (*) from LSPBO bl where nhomdk='PBC' and bl.soct = b.soct and bl.MTIDDT = a.dt45id and bl.PsNo >= 0)        
                   AND a.soluong > (select case when sum (bl.slhong) is null then 0 else sum (bl.slhong) end from LSPBO bl where nhomdk='PBC' and bl.soct = b.soct and bl.MTIDDT = a.dt45id and bl.PsNo >= 0)
                   And Datediff(dayofyear, dbo.Layngaydauthang(b.ngayct),dbo.Layngaydauthang(@ngayct1))>=0
                  
                   -- [MINHLAM : 16/03/2012 : Update phan bo
                   --WHERE  @ngayCt1 BETWEEN dbo.Layngaydauthang(ngayct) AND dbo.Layngayghiso(Dateadd(mm, a.kypb * a.soky - 1, b.ngayct))
                   --        AND Datediff(mm, b.ngayct, @ngayct1)% a.kypb = 0
                    UNION ALL
                    SELECT '01/01/1900' AS ngayct,
                           MTid         AS mt45id,
                           dt45id,
                           0            AS soluong,
                           slHong       AS slH,
                           0            AS slHTruoc,
                           NULL         AS mavt,
                           0.0          AS ps,
                           NULL         AS tkno,
                           NULL         AS tkcp,
                           NULL         AS mabp,
                           NULL         AS maphi,
                           NULL         AS mavv,
                           NULL			AS macongtrinh,
                           0            AS kypb,
                           0            AS soky
                    FROM   InvHongcc
                    WHERE  ngayct BETWEEN @ngayct1 AND @ngayct2
                    UNION ALL
                    SELECT '01/01/1900' AS ngayct,
                           MTid         AS mt45id,
                           dt45id,
                           0            AS soluong,
                           0            AS slH,
                           slHong       AS slHTruoc,
                           NULL         AS mavt,
                           0.0          AS ps,
                           NULL         AS tkno,
                           NULL         AS tkcp,
                           NULL         AS mabp,
                           NULL         AS maphi,
                           NULL         AS mavv,
                           NULL			AS macongtrinh,
                           0            AS kypb,
                           0            AS soky
                    FROM   InvHongcc
                    WHERE  ngayct < @ngayct1) x
            GROUP  BY mt45id,
                      dt45id) y
           INNER JOIN mt45 z
             ON y.mt45id = z.mt45id
    WHERE  soluong >= slH + slHtruoc 
    AND soluong > slHtruoc

GO


