IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0134_1]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0134_1]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- <Summary>
--- Bảng giá đặc thù cho khách hàng KHK
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Thanh Sơn on: 26/05/2015
---- Modified on 
-- <Example>
/*
	AP0134_1 'HD','','','COE003_0001','BUDDY_1.20',91,'1','2','3','4','5','6','7','8','9','10','','','','','','','','','',''
*/
CREATE PROCEDURE AP0134_1
(
	@DivisionID VARCHAR(50),
	@UserID VARCHAR(50),
	@ObjectID VARCHAR(50),	
	@PriceID VARCHAR(50),
	@InventoryID VARCHAR(50),
	@Quantity DECIMAL(28,8),
	@S01 VARCHAR(50),
	@S02 VARCHAR(50),
	@S03 VARCHAR(50),
	@S04 VARCHAR(50),
	@S05 VARCHAR(50),
	@S06 VARCHAR(50),
	@S07 VARCHAR(50),
	@S08 VARCHAR(50),
	@S09 VARCHAR(50),
	@S10 VARCHAR(50),
	@S11 VARCHAR(50),
	@S12 VARCHAR(50),
	@S13 VARCHAR(50),
	@S14 VARCHAR(50),
	@S15 VARCHAR(50),
	@S16 VARCHAR(50),
	@S17 VARCHAR(50),
	@S18 VARCHAR(50),
	@S19 VARCHAR(50),
	@S20 VARCHAR(50)	
)
AS
DECLARE @SalesPrice DECIMAL(28,8) = 0,
		@NormalColor DECIMAL(28,8) = 0,
		@BasePrice DECIMAL(28,8) = 0,
		@Width DECIMAL(28,8) = 0,
		@EffectCharge DECIMAL(28,8) = 0,
		@HotMelt DECIMAL(28,8) = 0,
		@Rate DECIMAL(28,8) = 0
		
---- Lấy giá cho từng quy cách
SELECT @EffectCharge = ISNULL((SELECT TOP 1 UnitPrice FROM AV0026 WHERE PriceID = @PriceID AND StandardID = @S05
							AND (InventoryID = @InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S05') = 1)),0)
					 + ISNULL((SELECT TOP 1 UnitPrice FROM AV0026 WHERE PriceID = @PriceID AND StandardID = @S06
							AND (InventoryID = @InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S06') = 1)),0)
					 + ISNULL((SELECT TOP 1 UnitPrice FROM AV0026 WHERE PriceID = @PriceID AND StandardID = @S07
							AND (InventoryID = @InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S07') = 1)),0)
				     + ISNULL((SELECT TOP 1 UnitPrice FROM AV0026 WHERE PriceID = @PriceID AND StandardID = @S04
							AND (InventoryID = @InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S04') = 1)),0)		

SELECT @HotMelt = ISNULL((SELECT TOP 1 UnitPrice FROM AV0026 WHERE PriceID = @PriceID AND StandardID = @S08
							AND (InventoryID = @InventoryID OR (SELECT TOP 1 ISNULL(IsExtraFee, 0) FROM AT0005 WHERE DivisionID = @DivisionID AND TypeID = 'S08') = 1)),0)
					 
SELECT @BasePrice = UnitPrice, @NormalColor = (CASE WHEN ISNUMERIC(ISNULL(Notes,0)) = 1 THEN CONVERT (DECIMAL(28,8), ISNULL(Notes,0)) ELSE 0 END)
FROM OT1302
WHERE DivisionID = @DivisionID AND ID = @PriceID AND InventoryID = @InventoryID AND UnitID = 'M'

SELECT @Width = (CASE WHEN ISNUMERIC(ISNULL(Specification,0)) = 1 THEN CONVERT (DECIMAL(28,8), ISNULL(Specification,0)) ELSE 0 END)
FROM AT1302
WHERE DivisionID = @DivisionID AND InventoryID = @InventoryID

IF (@Quantity >= 0   AND @Quantity < 45)  SET @Rate = 2
IF (@Quantity >= 45  AND @Quantity < 90)  SET @Rate = 1.25
IF (@Quantity >= 90  AND @Quantity < 180) SET @Rate = 1.05
IF @Quantity >= 180 SET @Rate = 1

SET @SalesPrice = ((@NormalColor + @EffectCharge) * @Rate + @BasePrice) * @Width + @HotMelt
SELECT @SalesPrice SalesPrice
 
 
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
