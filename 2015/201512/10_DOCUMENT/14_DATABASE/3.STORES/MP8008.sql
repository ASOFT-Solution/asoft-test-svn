/****** Object: StoredProcedure [dbo].[MP8008] Script Date: 01/06/2011 17:05:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created BY Hoang Lan, Date 20/11/2003.
------ Purpose: Kiem tra truoc khi tính gia thành sản phẩm

/********************************************
'* Edited BY: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/
--Last Edit by Thiên Huỳnh: Đa chi nhánh Bổ sung Where thêm DivisionID

ALTER Procedure [dbo].[MP8008] 
    @DivisionID AS NVARCHAR(50), 
    @PeriodID AS NVARCHAR(50)
AS

DECLARE 
    @Status AS TINYINT, 
    @MethodID AS NVARCHAR(50), 
    @Message AS NVARCHAR(250), 
    @DistributionID AS NVARCHAR(20), 
    @InprocessID AS NVARCHAR(20), 
    @BeginMethodID AS TINYINT, 
    @IsInprocess AS TINYINT, 
    @FromPeriodID AS NVARCHAR(50)

SET @InprocessID = (SELECT InprocessID FROM MT1601 WHERE PeriodID = @PeriodID AND DivisionID = @DivisionID)

SET NOCOUNT OFF

SET @Status = 0
--- 1. Kiem tra da tinh gia thanh hay chua?
IF EXISTS (SELECT 1 FROM MT1601 WHERE IsCost = 1 AND PeriodID = @PeriodID And DivisionID = @DivisionID)
    BEGIN
        SET @Status = 1 
        SET @Message = N'MFML000187' -- Đối tượng tập hợp chi phí đã tính giá thành. Bạn không thể tính giá thành sản phẩm.
        GOTO RETURN_VALUES
    END

--- 2. Kiem tra da phan bo hay chua?
IF EXISTS (SELECT 1 FROM MT1601 WHERE IsDistribute = 0 AND PeriodID = @PeriodID  And DivisionID = @DivisionID)
    BEGIN
        SET @Status = 2 
        SET @Message = N'MFML000188' -- Đối tượng tập hợp chi phí chưa được phân bổ. Bạn không thể tính giá thành được.
        GOTO RETURN_VALUES
    END

--3. Kiem tra da co ket qua san xuat hay chua
IF NOT EXISTS (SELECT TOP 1 1 FROM MT1001 INNER JOIN MT0810 ON MT1001.VoucherID = MT0810.VoucherID AND MT1001.DivisionID = MT0810.DivisionID
                WHERE MT0810.PeriodID = @PeriodID AND MT0810.ResultTypeID = 'R01' And MT1001.DivisionID = @DivisionID)
    BEGIN
        SET @Status = 1 
        SET @Message = N'MFML000189' -- Chưa có kết quả sản xuất. Bạn không thể tính giá thành sản phẩm.
        GOTO RETURN_VALUES
    END

---4. Kiểm tra các trường hợp khác ( Kiem tra xem da tinh chi phi do dang hay chua ?)
SET @BeginMethodID = (SELECT BeginMethodID FROM MT1608 WHERE InprocessID = @InprocessID And DivisionID = @DivisionID)
SELECT @FromPeriodID = FromPeriodID, @IsInprocess = IsInprocess FROM MT1601 WHERE PeriodID = @PeriodID And DivisionID = @DivisionID

IF EXISTS (SELECT TOP 1 1 FROM MT1001 INNER JOIN MT0810 ON MT0810.DivisionID = MT1001.DivisionID AND MT0810.VoucherID = MT1001.VoucherID 
            WHERE PeriodID = @PeriodID AND ResultTypeID = 'R03' And MT1001.DivisionID = @DivisionID) AND @IsInprocess = 0
    BEGIN
        SET @Status = 1 
        SET @Message = N'MFML000190' -- Có sản phẩm dở dang cuối kỳ nhưng chưa tính chi phí dở dang cuối kỳ. Bạn phải tính chi phí dở dang cuối kỳ trước khi tính giá thành.
        GOTO RETURN_VALUES
    END

IF @BeginMethodID = 1 AND @IsInprocess = 0 ---- Nhập bằng tay
    BEGIN
        IF EXISTS (SELECT TOP 1 1 FROM MT1612 WHERE DivisionID = @DivisionID AND PeriodID = @PeriodID)
            BEGIN
                SET @Status = 1 
                SET @Message = N'MFML000191' -- Có chi phí dở dang đầu kỳ nhập bằng tay. Bạn phải tính chi phí dở dang cuối kỳ trước khi tính giá thành.
                GOTO RETURN_VALUES
            END
    END

IF @BeginMethodID = 2 AND @IsInprocess = 0 ---- Nhập chuyển từ kỳ trước
    BEGIN
        IF EXISTS (SELECT TOP 1 1 FROM MT1613 WHERE DivisionID = @DivisionID AND PeriodID = @PeriodID)
            BEGIN
                SET @Status = 1 
                SET @Message = N'MFML000192' -- Có chi phí dở dang đầu kỳ được chuyển từ kỳ trước sang. Bạn phải tính chi phí dở dang cuối kỳ trước khi tính giá thành.
                GOTO RETURN_VALUES
            END
    END

RETURN_VALUES:
SET NOCOUNT ON 
SELECT @Status AS Status, @Message AS Message