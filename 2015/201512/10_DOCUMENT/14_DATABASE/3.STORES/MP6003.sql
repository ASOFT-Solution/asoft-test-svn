/****** Object: StoredProcedure [dbo].[MP6003] Script Date: 08/03/2010 10:34:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created BY Hoang Lan, Date 08/11/2003.
------ Purpose: Kiem tra truoc khi phan bo(Theo ®èi t­îng)

/********************************************
'* Edited BY: [GS] [Việt Khánh] [03/08/2010]
'********************************************/

ALTER Procedure [dbo].[MP6003] 
    @DivisionID NVARCHAR(50), 
    @PeriodID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT
AS

DECLARE 
    @Status TINYINT, 
    @MethodID NVARCHAR(50), 
    @Message NVARCHAR(250), 
    @CoefficientID NVARCHAR(50), 
    @IsFromCost TINYINT

SET NOCOUNT OFF
SET @Status = 0

--- 1. Kiem tra da tinh gia thanh hay chua?
IF EXISTS (SELECT 1 FROM MT1601 WHERE IsCost = 1 AND PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
    BEGIN
        SET @Status = 1 
        SET @Message = 'MFML000204' --Đối tượng tập hợp chi phí đã tính giá thành. Bạn không thể phân bổ được.
        GOTO RETURN_VALUES
    END

--- 2. Kiem tra da phan bo hay chua?
IF EXISTS (SELECT 1 FROM MT1601 WHERE IsDistribute = 1 AND PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
    BEGIN
        SET @Status = 2 
        SET @Message = 'MFML000205' --Đối tượng tập hợp chi phí đã được phân bổ. Bạn không thể phân bổ được.
        GOTO RETURN_VALUES
    END
    
--- 3. Kiem tra da tap hop hay chua
IF NOT EXISTS (SELECT TOP 1 1 FROM MV9000 WHERE PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
    BEGIN
        SET @Status = 1 
        SET @Message = 'MFML000206' --Chi phí chưa được tập hợp vào đối tượng tập hợp chi phí. Bạn không thể phân bổ được.
        GOTO RETURN_VALUES
    END

---- 4. Kiem tra he so cã hay chua
SELECT @CoefficientID = CoefficientID, @IsFromCost = IsFromCost FROM MT1601
WHERE PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))

IF @IsFromCost = 0 AND @CoefficientID = '' 
    BEGIN
        SET @Status = 1 
        SET @Message = 'MFML000207' --Chưa có bộ hệ số cho đối tượng. Bạn phải nhập vào bộ hệ số.
        GOTO RETURN_VALUES
    END

RETURN_VALUES:
SET NOCOUNT ON 
SELECT @Status AS Status, @Message AS Message