/****** Object: StoredProcedure [dbo].[MP8003] Script Date: 12/22/2010 15:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created BY Hoang Lan, Date 13/11/2003.
------ Purpose: Kiểm tra trường khi tính dỡ dang cuối kỳ.

/********************************************
'* Edited BY: [GS] [Hoàng Phước] [02/08/2010]
'* Edited BY: [GS] [Cẩm Loan] [22/12/2010]
'********************************************/

ALTER Procedure [dbo].[MP8003] 
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
    @InprocessID AS NVARCHAR(50)

SET @InprocessID = (SELECT InprocessID FROM MT1601 WHERE PeriodID = @PeriodID AND DivisionID = @DivisionID)

SET NOCOUNT OFF
SET @Status = 0

--- 1. Kiểm tra đã tính giá thành hay chưa?
IF EXISTS (SELECT 1 FROM MT1601 WHERE IsCost = 1 AND PeriodID = @PeriodID AND DivisionID = @DivisionID)
    BEGIN
        SET @Status = 1 
        SET @Message = 'MFML000110' -- Đối tượng tập hợp chi phí đã tính giá thành. Bạn không thể tính chi phí dở dang được.
        GOTO RETURN_VALUES
    END

--- 2. Kiểm tra đã phân bổ hay chưa?
IF EXISTS (SELECT 1 FROM MT1601 WHERE IsDistribute = 0 AND PeriodID = @PeriodID AND DivisionID = @DivisionID)
    BEGIN
        SET @Status = 2 
        SET @Message = 'MFML000111' -- Đối tượng tập hợp chi phí chưa được phân bổ. Bạn không thể tính chi phí dở dang được.
        GOTO RETURN_VALUES
    END

--3. Kiểm tra đã có kết quả sản xuất hay chưa?
IF NOT EXISTS (SELECT TOP 1 1 FROM MT1001 INNER JOIN MT0810 ON MT1001.VoucherID = MT0810.VoucherID AND MT1001.DivisionID = MT0810.DivisionID
                WHERE MT0810.PeriodID = @PeriodID AND MT0810.ResultTypeID IN ('R03', 'R01') AND MT1001.DivisionID = @DivisionID)
    BEGIN
        SET @Status = 1 
        SET @Message = 'MFML000112' -- Chưa có kết quả sản xuất dở dang. Bạn không thể tính chi phí dở dang cuối kỳ được.
        GOTO RETURN_VALUES
    END

--4. Kiểm tra đã tính chi phí dở dang hay chưa?
IF EXISTS (SELECT TOP 1 1 FROM MT1601 WHERE PeriodID = @PeriodID AND IsInprocess = 1 AND DivisionID = @DivisionID)
    BEGIN
        SET @Status = 1 
        SET @Message = 'MFML000113' -- Đã tính chi phí dở dang cuối kỳ. Bạn không thể tính chi phí dở dang cuối kỳ được.
        GOTO RETURN_VALUES
    END

----5. Kiểm tra đinh mức tương thích hay chưa
SET @DistributionID = (SELECT DistributionID FROM MT1601 WHERE PeriodID = @PeriodID AND DivisionID = @DivisionID)

----5.1 Kiểm tra tính tương thích của NVL TT
EXEC MP8121 @DivisionID, @PeriodID, @TranMonth, @TranYear, @InprocessID, @Status Output, @Message output 
IF @Status <> 0 GOTO RETURN_VALUES

---- 5.2 Kiểm tra tính tương thích của NC TT
EXEC MP8122 @DivisionID, @PeriodID, @TranMonth, @TranYear, @InprocessID, @Status Output, @Message output 
IF @Status <> 0 GOTO RETURN_VALUES

---- 5.3 Kiểm tra tính tương thích của CPSXC 
EXEC MP8127 @DivisionID, @PeriodID, @TranMonth, @TranYear, @InprocessID, @Status Output, @Message output 
IF @Status <> 0 GOTO RETURN_VALUES

---6. Kiểm tra các trường hợp khác

RETURN_VALUES:
SET NOCOUNT ON 
SELECT @Status AS Status, @Message AS Message




















