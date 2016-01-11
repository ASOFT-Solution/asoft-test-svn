/****** Object:  StoredProcedure [dbo].[MP8001]    Script Date: 01/07/2011 10:05:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created BY Hoang Thi Lan
--Date 18/11/2003
--Purpose:Tinh chi phi do dang dau ky cho DT THCP

ALTER PROCEDURE  [dbo].[MP8001] @DivisionID AS NVARCHAR(50), 
                 @PeriodID AS NVARCHAR(50), 
                 @TranMonth AS INT, 
                 @TranYear AS INT, 
                 @InProcessID AS NVARCHAR(50)
AS
DECLARE @sSQL AS VARCHAR(8000), @BeginMethodID AS tinyint

SET @BeginMethodID = (SELECT BeginMethodID FROM MT1608 WHERE InProcessID = @InProcessID And DivisionID = @DivisionID)
--print 'Chi phi DD dau ky 1'

IF @BeginMethodID = 1 ---Cap nhat bang tay
    EXEC MP8006 @DivisionID, @PeriodID, @TranMonth, @TranYear

IF @BeginMethodID = 2 --- Chuyen tu ky truoc
    EXEC MP8007 @DivisionID, @PeriodID, @TranMonth, @TranYear

GO


