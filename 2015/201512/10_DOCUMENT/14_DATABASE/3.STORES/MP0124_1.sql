IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0124_1]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0124_1]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Tính chỉ tiêu sản lượng cho DNP
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on:13/07/2015
---- Modified on 
-- <Example>
/*
	MP0124_1 'DNP', '', '', 'CNC', 23.70
*/
CREATE PROCEDURE MP0124_1
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@TeamID VARCHAR(50),
	@HourAvg DECIMAL(28,8)
)
AS
---- lấy dữ liệu từ thiết lập
DECLARE @Coe1 DECIMAL(28,8) = 0,
		@Coe2 DECIMAL(28,8) = 0,
		@Coe3 DECIMAL(28,8) = 0,
		@Qty1 DECIMAL(28,8) = 0,
		@Qty2 DECIMAL(28,8) = 0,
		@Qty3 DECIMAL(28,8) = 0,
		@TCGCCoefficient DECIMAL(28,8) = 0,
		@HourCriteria DECIMAL(28,8) = 0,
		@QtyCriteria1h DECIMAL(28,8) = 0,
		@QtyCriteria8h DECIMAL(28,8) = 0,
		@QtyCriteria12h DECIMAL(28,8) = 0
		
IF EXISTS (SELECT TOP 1 1 FROM HT1101 WHERE DivisionID = @DivisionID AND TeamID = @TeamID AND Notes IS NOT NULL AND Notes01 IS NOT NULL)
SELECT TOP 1 @Coe1 = CONVERT(DECIMAL(28,8), LEFT(REPLACE(Notes01,' ',''), 4)),
			 @Coe2 = CONVERT(DECIMAL(28,8), SUBSTRING(REPLACE(Notes01,' ',''), 6,4)),
			 @Coe3 = CONVERT(DECIMAL(28,8), RIGHT(REPLACE(Notes01,' ',''), 4)),
			 
			 @Qty1 = CONVERT(DECIMAL(28,8), LEFT(REPLACE(Notes,' ',''), 2)),
			 @Qty2 = CONVERT(DECIMAL(28,8), SUBSTRING(REPLACE(Notes,' ',''), 4,2)),
			 @Qty3 = CONVERT(DECIMAL(28,8), RIGHT(REPLACE(Notes,' ',''), 2))
FROM HT1101
WHERE DivisionID = @DivisionID
AND TeamID = @TeamID

SET @TCGCCoefficient = CASE WHEN @HourAvg > @Qty1 AND @HourAvg <= @Qty2 THEN @Coe1 
							WHEN @HourAvg > @Qty2 AND @HourAvg <= @Qty3 THEN @Coe2
							WHEN @HourAvg > @Qty3 THEN @Coe3 ELSE 0 END
SET @HourCriteria = ISNULL(@TCGCCoefficient, 0) * ISNULL(@HourAvg,0)
SET @QtyCriteria1h = CASE WHEN @HourCriteria = 0 THEN 0 ELSE 3600 / @HourCriteria END
SET @QtyCriteria8h = CASE WHEN @HourCriteria = 0 THEN 0 ELSE 26700 / @HourCriteria END
SET @QtyCriteria12h = CASE WHEN @HourCriteria = 0 THEN 0 ELSE 38400 / @HourCriteria END
			
SELECT @TCGCCoefficient TCGCCoefficient, @HourCriteria HourCriteria, @QtyCriteria1h QtyCriteria1h,
	@QtyCriteria8h QtyCriteria8h, @QtyCriteria12h QtyCriteria12h

GO
SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS ON
GO