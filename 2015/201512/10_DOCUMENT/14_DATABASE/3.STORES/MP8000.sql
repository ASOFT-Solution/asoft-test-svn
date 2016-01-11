/****** Object: StoredProcedure [dbo].[MP8000] Script Date: 12/16/2010 16:35:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan
--Date 12/11/2003
--Purpose TÝnh chi phÝ dë dang 

/**********************************************
** Edited BY: [GS] [Cẩm Loan] [03/08/2010]
***********************************************/

ALTER PROCEDURE [dbo].[MP8000] 
    @DivisionID AS NVARCHAR(50), 
    @PeriodID AS NVARCHAR(50), 
    @TranMonth AS INT, 
    @TranYear AS INT
AS 

DECLARE 
    @sSQL AS NVARCHAR(4000), 
    @InprocessID AS NVARCHAR(50), 
    @VoucherID AS NVARCHAR(50), 
    @CMonth AS NVARCHAR(50), 
    @CYear AS NVARCHAR(50)

IF @TranMonth >9
    SET @CMonth = LTRIM(RTRIM(STR(@TranMonth)))
ELSE
    SET @CMonth = '0' + LTRIM(RTRIM(STR(@TranMonth)))

SET @CYear = right(LTRIM(RTRIM(STR(@TranYear))), 2)

EXEC AP0000 @DivisionID, @VoucherID OUTPUT, 'MT1613', 'IV', @CMonth, @CYear, 16, 3, 0, '-' 

SET @InprocessID = (SELECT InprocessID FROM MT1601 WHERE PeriodID = @PeriodID AND DivisionID = @DivisionID)

----- Tinh chi phi do dang dau ky cho DT THCP
DELETE MT1613 WHERE PeriodID = @PeriodID AND DivisionID = @DivisionID
EXEC MP8001 @DivisionID, @PeriodID, @TranMonth, @TranYear, @InProcessID

----- Tinh chi phi do dang cuoi ky cho DT THCP
EXEC MP8002 @DivisionID, @PeriodID, @TranMonth, @TranYear, @InProcessID, @VoucherID, @CMonth, @CYear
