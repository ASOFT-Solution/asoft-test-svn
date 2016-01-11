/****** Object: StoredProcedure [dbo].[MP5003] Script Date: 08/03/2010 16:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------ Created BY Quoc Hoai, Date 12/05/2004.
------ Purpose: Kiem tra truoc khi bo phan bo
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP5003] 
    @DivisionID AS NVARCHAR(50), 
    @PeriodID AS NVARCHAR(50), 
    @TranMonth AS INT, 
    @TranYear AS INT
AS
DECLARE 
    @Status AS TINYINT, 
    @MethodID AS NVARCHAR(50), 
    @Message AS NVARCHAR(250), 
    @DistributionID AS NVARCHAR(50), 
    @FaPeriodID AS NVARCHAR(50)

SET NOCOUNT OFF
SET @Status = 0

--1 Kiem tra DT con da phan bo chua?
IF EXISTS (SELECT 1 FROM MT1601 
            WHERE MT1601.PeriodID IN (SELECT MT1609.ChildPeriodID FROM MT1609 WHERE MT1609.PeriodID = @PeriodID)
                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                AND IsDistribute = 1)
    BEGIN
        SET @Status = 1 
        SET @Message = N'MFML000202' --Đối tượng con đã phân bổ không thể bỏ phân bổ ở đối tượng cha!
        GOTO RETURN_VALUES
    END

--2 Kiem tra DT con da tinh gia thanh chua?
IF EXISTS (SELECT 1 FROM MT1601 
            WHERE MT1601.PeriodID IN (SELECT MT1609.ChildPeriodID FROM MT1609 WHERE MT1609.PeriodID = @PeriodID) 
                AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID))
                AND IsCost = 1)
    BEGIN
        SET @Status = 1 
        SET @Message = N'MFML000203' --Đối tượng con đã tính giá thành không thể bỏ phân bổ ở đối tượng cha!
        GOTO RETURN_VALUES
    END

RETURN_VALUES:
SET NOCOUNT ON 
SELECT @Status AS Status, @Message AS Message
GO
