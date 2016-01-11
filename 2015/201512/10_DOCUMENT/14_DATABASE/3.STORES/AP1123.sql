IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1123]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1123]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---- Create on 05/12/2013 by Mai Duyen
---- Purpose: Lay tong gia tri luy ke, tong nhan vien cung cap, tong nhan vien cap duoi
-- AP1123 'AS',1

CREATE PROCEDURE [DBO].[AP1123]
(
	@DivisionID  nvarchar(50),  
	@LevelNo  Int 
)
AS

DECLARE 
	@TotalAccAmount Decimal(28,8) , -- Tong gia trị luy ke
    @TotalSameLevel int , -- tong nhan vien dong cap
    @TotalSubLevel   int ,   -- Tong nhan vien cap duo       
	@TotalCNLevel   int ,   -- Tong nhan vien cap CN
	@TotalGDLevel   int ,   -- Tong nhan vien cap GD
	@TotalTGLevel   int ,    -- Tong nhan vien cap TG
	@MinLevelNo int ,
	@MaxLevelNo int 
SET NOCOUNT ON

	Select @MinLevelNo = Min(LevelNo), @MaxLevelNo = Max(LevelNo) FROM AT0101
	
	SET @TotalAccAmount = ( SELECT SUM(AccAmount)FROM AT1120 WHERE DivisionID = @DivisionID)
	SET @TotalSameLevel =  (SELECT COUNT(ObjectID) FROM AT1120 WHERE LevelNo = @LevelNo  )
	--SET @TotalSubLevel = (SELECT COUNT(ObjectID) FROM AT1120 WHERE LevelNo < @LevelNo  )
	---Tong cac cap con
	Set @TotalCNLevel = ( SELECT COUNT(ObjectID) FROM AT1120 WHERE LevelNo < @LevelNo  AND LevelNo = @MinLevelNo )
	Set @TotalGDLevel = ( SELECT COUNT(ObjectID) FROM AT1120 WHERE LevelNo < @LevelNo AND LevelNo = @MinLevelNo +1 )
	Set @TotalTGLevel =  (SELECT COUNT(ObjectID) FROM AT1120 WHERE LevelNo < @LevelNo  AND LevelNo = @MaxLevelNo)
	SET @TotalSubLevel =@TotalCNLevel + @TotalGDLevel + @TotalTGLevel

   SELECT @TotalAccAmount AS TotalAccAmount ,@TotalSameLevel AS TotalSameLevel,
			@TotalCNLevel as TotalCNLevel, @TotalGDLevel as TotalGDLevel, @TotalTGLevel as TotalTGLevel,
			@TotalSubLevel AS TotalSubLevel

	
	



SET NOCOUNT OFF

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

