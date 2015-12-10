/****** Object:  StoredProcedure [dbo].[gtGiandon]    Script Date: 02/16/2012 09:49:24 ******/
IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = Object_id(N'[dbo].[gtGiandon]')
                  AND type IN ( N'P', N'PC' ))
  DROP PROCEDURE [dbo].[gtGiandon]

/****** Object:  StoredProcedure [dbo].[gtGiandon]    Script Date: 02/16/2012 09:49:24 ******/
SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE PROCEDURE [dbo].[Gtgiandon] @tungay  DATETIME,
                                   @denngay DATETIME,
                                   @tk      NVARCHAR(256),
                                   @manhom  NVARCHAR(256)= ''
AS
    IF ( @manhom = '' )
      BEGIN
          SELECT masp,
                 Sum(psno) AS tien
          FROM   bltk
          WHERE  masp IN
                 (SELECT mavt
                  FROM   dmvt
                  WHERE  loaivt = 4)
                 AND LEFT(tk, Len(@tk)) = @tk
                 and NgayCt between @tungay and @denngay
          GROUP  BY masp
      END
    ELSE
      BEGIN
          SELECT masp,
                 Sum(psno)AS tien
          FROM   bltk
          WHERE  masp IN
                 (SELECT mavt
                  FROM   dmvt
                  WHERE  loaivt = 4
                         AND nhomgt = @manhom)
                 AND LEFT(tk, Len(@tk)) = @tk
                 and NgayCt between @tungay and @denngay
          GROUP  BY masp
      END
