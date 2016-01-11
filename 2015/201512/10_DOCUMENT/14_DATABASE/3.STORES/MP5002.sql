/****** Object: StoredProcedure [dbo].[MP5002] Script Date: 08/03/2010 16:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------ Created BY Hoang Lan, Date 06/11/2003.
------ Purpose: Kiem tra truoc khi phan bo
------ Edit BY: Dang Le Bao Quynh; Date: 11/08/2007
------ Purpose: Cho phep phan bo khi cho doi tuong chi co san pham do dang
/********************************************
'* Edited BY: [GS] [Thành Nguyên] [03/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP5002] 
    @DivisionID AS NVARCHAR(50),
    @PeriodID AS NVARCHAR(50),
    @TranMonth AS INT,
    @TranYear AS INT
AS

DECLARE 
    @Status AS TINYINT, --0: Thuc hien phan bo, 1: Khong duoc phan bo, 2: Thong bao va cho phep chon co thuc hien PB C/K
    @MethodID AS NVARCHAR(50),
    @Message AS NVARCHAR(250),
    @DistributionID AS NVARCHAR(50),
    @FaPeriodID AS NVARCHAR(50)
Declare	@TempTable table(CustomerName  int,IsExcel  int)
DECLARE @IsType INT

INSERT @TempTable
EXEC	[dbo].[AP4444]

select @IsType= CustomerName from @TempTable

SET NOCOUNT OFF
SELECT @Status = 0, @Message = ''

--- 1. Kiểm tra đã tích giá thành hay chưa?
IF EXISTS (SELECT TOP 1 1 FROM MT1601 WHERE IsCost = 1 AND PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
    BEGIN
        SET @Status = 1 
        SET @Message = N'MFML000146'
        GOTO RETURN_VALUES 
    END

--- 2. Kiểm tra đã phân bổ hay chưa?
IF EXISTS (SELECT TOP 1 1 FROM MT1601 WHERE IsDistribute = 1 AND PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
    BEGIN
        SET @Status = 2 
        SET @Message = N'MFML000147'
        GOTO RETURN_VALUES 
    END

-- Khách hàng Minh phương, sẽ không kiểm tra tập hợp chi phí
if(@IsType <> 1)
begin
--- 3. Kiểm tra đã tập hợp chi phí hay chưa?
IF NOT EXISTS (SELECT TOP 1 1 FROM MV9000 WHERE PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
    BEGIN
        SET @Status = 1 
        SET @Message = N'MFML000148'
        GOTO RETURN_VALUES
    END
end
--- 4. Kiểm tra đã có kết quả sản xuất hay chưa?
IF NOT EXISTS (SELECT TOP 1 1 FROM MT1001 INNER JOIN MT0810 ON MT1001.VoucherID = MT0810.VoucherID AND MT1001.DivisionID = MT0810.DivisionID
WHERE MT0810.PeriodID = @PeriodID AND MT0810.ResultTypeID IN ('R01','R03') AND MT1001.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
    BEGIN
        SET @Status = 1 
        SET @Message = N'MFML000149'
        GOTO RETURN_VALUES 
    END

---- 5. Kiểm tra hệ số, định mức tương thích hay chưa?
SET @DistributionID = (SELECT DistributionID FROM MT1601 WHERE PeriodID = @PeriodID AND DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))

---- 5.1 Kiểm tra tính tương thích của NVL TT
EXEC MP5621 @DivisionID, @PeriodID, @TranMonth, @TranYear, @DistributionID, @Status OUTPUT, @Message OUTPUT 
IF @Status <> 0 GOTO RETURN_VALUES

---- 5.2 Kiểm tra tính tương thích của NC TT
EXEC MP5622 @DivisionID, @PeriodID, @TranMonth, @TranYear,@DistributionID, @Status OUTPUT, @Message OUTPUT 
IF @Status <> 0 GOTO RETURN_VALUES

---- 5.3 Kiểm tra tính tương thích của CPSXC
EXEC MP5627 @DivisionID, @PeriodID, @TranMonth, @TranYear,@DistributionID, @Status OUTPUT, @Message OUTPUT 
IF @Status <> 0 GOTO RETURN_VALUES
    
--6 Kiểm tra có là đối tượng con của DTTHCP không?
IF EXISTS (SELECT TOP 1 1 FROM MT1609 INNER JOIN MT1601 ON MT1609.PeriodID = MT1601.PeriodID AND MT1601.IsForPeriodID = 1 AND MT1601.IsDistribute = 0 AND MT1601.DivisionID = MT1609.DivisionID
WHERE MT1609.ChildPeriodID = @PeriodID AND MT1601.DivisionID IN (SELECT DivisionID FROM dbo.GetDivisionID(@DivisionID)))
    BEGIN
        SET @Status = 1 
        SET @Message = N'MFML000150'
        GOTO RETURN_VALUES
    END

RETURN_VALUES:
SET NOCOUNT ON 
SELECT @Status AS Status, @Message AS Message
GO
