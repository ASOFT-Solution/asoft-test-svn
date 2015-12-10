IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LayDuLieuToKhaiTNDN0360]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LayDuLieuToKhaiTNDN0360]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[LayDuLieuToKhaiTNDN0360] 
    @TuKyDenKy INT,
    @TuKy INT,
    @DenKy INT,
    @Nam INT
AS

---- TEST ----
--DECLARE @TuKyDenKy INT
--DECLARE @TuKy INT
--DECLARE @DenKy INT
--DECLARE @Nam INT

--SET @TuKyDenKy = 1
--SET @TuKy = 1
--SET @DenKy = 9
--SET @Nam = 2010

DECLARE @A1 DECIMAL(28,6)
DECLARE @ngayCt1 DATETIME
DECLARE @ngayCt2 DATETIME

SET @ngayCt1 = convert(DATETIME, 0)
SET @ngayCt2 = convert(DATETIME, 0)

IF @TuKyDenKy = 0
    BEGIN
        SET @ngayCt1 = DATEADD (year, @Nam - 1900, @ngayCt1)
        SET @ngayCt2 = DATEADD (year, @Nam - 1900 + 1, @ngayCt2)
    END
ELSE
     BEGIN
         SET @ngayCt1 = DATEADD (year, @Nam - 1900, @ngayCt1)
         SET @ngayCt2 = DATEADD (year, @Nam - 1900, @ngayCt2)
         SET @ngayCt1 = DATEADD (month, @TuKy - 1, @ngayCt1)
         SET @ngayCt2 = DATEADD (month, @DenKy, @ngayCt2)
     END 

DECLARE @sysReportID INT
SELECT @sysReportID = sysReportID FROM CDT.dbo.sysReport WHERE ReportName = N'Báo cáo kết quả kinh doanh'

DECLARE @temp TABLE
(
    Stt INT,
    tk NVARCHAR(256),
    tkdu NVARCHAR(256),
    MaSo NVARCHAR(256),
    LoaiCT INT,
    CachTinh NVARCHAR(256),
    Tien decimal(28, 6)
)
INSERT INTO @temp
SELECT Stt, tk, tkdu, MaSo, LoaiCT, CachTinh, 0 FROM sysFormReport WHERE sysReportID = @sysReportID ORDER BY Stt

DECLARE cur CURSOR FOR SELECT tk, tkdu, MaSo, LoaiCT, CachTinh FROM @temp 
WHERE MaSo IN ('01', '02', '11', '21', '22', '24', '25', '31', '32')
OPEN cur

DECLARE @Stt INT
DECLARE @tk NVARCHAR(256)
DECLARE @tkdu NVARCHAR(256)
DECLARE @MaSo NVARCHAR(256)
DECLARE @LoaiCT INT
DECLARE @CachTinh NVARCHAR(256)
DECLARE @Tien decimal(28, 6)
 
DECLARE @psno decimal(28, 6)
DECLARE @psco decimal(28, 6)

FETCH cur INTO @tk, @tkdu, @MaSo, @LoaiCT, @CachTinh
WHILE @@fetch_status = 0
BEGIN
	IF @tk IS NOT NULL AND @loaiCt<>0	
	    BEGIN	    	    
            IF @tkdu IS NOT NULL             
                BEGIN 
			        SET @tkdu = replace(@tkdu, ' ', '')
			        SET @tkdu = ' tkdu like''' + replace(@tkdu, ',', '%'' or tkdu like''') + '%''' 			    
                    EXEC sopstaikhoan @tk, @ngayCt1, @ngayCt2, @tkdu, @psno OUTPUT, @psco OUTPUT 
                END
                    ELSE EXEC sopstaikhoan @tk, @ngayCt1, @ngayCt2, DEFAULT, @psno OUTPUT, @psco OUTPUT 
                    
            IF @loaiCt = 3 SET @Tien = @psno
            IF @loaiCt = 4 SET @Tien = @psco

            UPDATE @temp SET Tien = @Tien WHERE Maso = @Maso
        END
    FETCH cur INTO @tk, @tkdu, @MaSo, @LoaiCT, @CachTinh
END

CLOSE cur
DEALLOCATE cur

DECLARE @01 DECIMAL(28,6)
DECLARE @02 DECIMAL(28,6)
DECLARE @11 DECIMAL(28,6)
DECLARE @21 DECIMAL(28,6)
DECLARE @22 DECIMAL(28,6)
DECLARE @24 DECIMAL(28,6)
DECLARE @25 DECIMAL(28,6)
DECLARE @31 DECIMAL(28,6)
DECLARE @32 DECIMAL(28,6)

SELECT @01 = Tien FROM @temp WHERE MaSo = '01'
SELECT @02 = Tien FROM @temp WHERE MaSo = '02'
SELECT @11 = Tien FROM @temp WHERE MaSo = '11'
SELECT @21 = Tien FROM @temp WHERE MaSo = '21'
SELECT @22 = Tien FROM @temp WHERE MaSo = '22'
SELECT @24 = Tien FROM @temp WHERE MaSo = '24'
SELECT @25 = Tien FROM @temp WHERE MaSo = '25'
SELECT @31 = Tien FROM @temp WHERE MaSo = '31'
SELECT @32 = Tien FROM @temp WHERE MaSo = '32'

SELECT @01-@02-@11+@21-@22-@24-@25+@31-@32