/****** Object: StoredProcedure [dbo].[MP4000] Script Date: 08/02/2010 10:47:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoµng ThÞ Lan
--Date 17/12/2003
--Purpose : Chiet tinh gia thanh

/********************************************
'* Edited BY: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP4000] 
    @DivisionID NVARCHAR(50), 
    @PeriodID NVARCHAR (50), 
    @TranMonth INT, 
    @TranYear INT
AS

DECLARE 
    @sSQL NVARCHAR(4000), 
    @VoucherID NVARCHAR(50), 
    @CMonth NVARCHAR, 
    @CYear NVARCHAR

IF @TranMonth > 9
    SET @CMonth = LTRIM(RTRIM(STR(@TranMonth)))
ELSE
    SET @CMonth = '0' + LTRIM(RTRIM(STR(@TranMonth)))

SET @CYear = RIGHT(LTRIM(RTRIM(STR(@TranYear))), 2)

EXEC AP0000 @DivisionID, @VoucherID OUTPUT, 'MT4000', 'IV', @CMonth, @CYear, 16, 3, 0, '-' 

DELETE FROM MT4000 WHERE PeriodID = @PeriodID AND TranMonth = @TranMonth AND TranYear = @TranYear
AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))

--Chiet tinh NVL 
EXEC MP4621 @DivisionID, @PeriodID, @VoucherID, @TranMonth, @TranYear

--Chiet tinh Nhan cong va SXC
EXEC MP4622 @DivisionID, @PeriodID, @VoucherID, @TranMonth, @TranYear