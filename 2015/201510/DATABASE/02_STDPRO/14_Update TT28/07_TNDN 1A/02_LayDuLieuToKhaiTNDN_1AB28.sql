IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LayDuLieuToKhaiTNDN1AB28]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LayDuLieuToKhaiTNDN1AB28]
GO

CREATE PROCEDURE [dbo].[LayDuLieuToKhaiTNDN1AB28] 
    @Quy INT,
    @Nam INT
AS

DECLARE
@TuKy INT,
@DenKy INT,
@21 decimal(20,6),
@22 decimal(20,6)

IF @Quy = 1 SELECT @TuKy = 1, @DenKy = 3
ELSE IF @Quy = 2 SELECT @TuKy = 4, @DenKy = 6
ELSE IF @Quy = 3 SELECT @TuKy = 7, @DenKy = 9
ELSE IF @Quy = 4 SELECT @TuKy = 10, @DenKy = 12
ELSE SELECT @TuKy = 0, @DenKy = 0

SELECT @21 = SUM(psno) FROM bltk 
WHERE (Tk LIKE '51%' OR Tk LIKE '71%') AND TKdu = '911'
AND Month(NgayCT) >= @TuKy AND Month(NgayCT) <= @DenKy AND Year(NgayCT) = @Nam

SELECT @22 = SUM(psco) FROM bltk 
where (Tk LIKE '63%' OR Tk LIKE '64%' OR Tk LIKE '81%') AND TKdu = '911'
AND Month(NgayCT) >= @TuKy AND Month(NgayCT) <= @DenKy AND Year(NgayCT) = @Nam

SELECT @21, @22