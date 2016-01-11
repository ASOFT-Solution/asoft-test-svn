/****** Object:  StoredProcedure [dbo].[MP8002]    Script Date: 01/07/2011 10:05:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----- Created BY Hoang Thi Lan
----- Date 12/11/2003.
----- Purpose: Tinh gia tri san pham do dang cuoi ky
----- Modify on 19/05/2014 by Bảo Anh: Nếu tồn tại MT2222 thì xóa bảng rồi tạo lại

ALTER PROCEDURE [dbo].[MP8002] @DivisionID AS NVARCHAR(50), 
                @PeriodID AS NVARCHAR(50), 
                @TranMonth AS INT, 
                @TranYear AS INT, 
                @InProcessID AS NVARCHAR(50), 
                @VoucherID AS NVARCHAR(50), 
                @CMonth AS NVARCHAR(50), 
                @CYear AS NVARCHAR(50)
AS
DECLARE @sSQL AS VARCHAR(8000), 
    @EndMethodID AS tinyint

SET NOCOUNT ON

----- Buoc 1: Xac dinh san pham do dang.
SET @sSQL ='
SELECT  D10.DivisionID, 
        D10.ProductID AS ProductID, 
        AT1302.InventoryTypeID, 
        D10.UnitID, 
        SUM(D10.Quantity) AS ProductQuantity, 
        PerfectRate, ---- Ty le % hoan thanh cua san pham
        MaterialRate, ---- Ty le % NVL dua dan vao sP
        HumanResourceRate, ---- Ty le % Nhan cong dua dan vao sP
        OthersRate        ---- Ty le % SXC dua dan vao sP
FROM MT1001 D10 INNER JOIN MT0810 D08 ON D08.VoucherID = D10.VoucherID AND D08.DivisionID = D10.DivisionID        
              INNER JOIN AT1302 ON  AT1302.InventoryID = D10.ProductID AND AT1302.DivisionID = D10.DivisionID
WHERE D08.PeriodID = '''+@PeriodID+''' AND
    D08.DivisionID ='''+@DivisionID+''' AND
    D08.ResultTypeID =''R03''     --- Chi lay cac chi phi do dang cuoi ky
GROUP  BY 
   D10.DivisionID, D10.ProductID, AT1302.InventoryTypeID, 
   D10.UnitID, PerfectRate, MaterialRate, HumanResourceRate, OthersRate '     

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[MT2222]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	DROP TABLE MT2222

    CREATE TABLE [dbo].[MT2222] (
        [DivisionID] NVARCHAR (50) NULL, 
        [ProductID] NVARCHAR (50) NULL, 
        [InventoryTypeID] NVARCHAR (50) NULL, 
        [UnitID] NVARCHAR (50) NULL, 
        [ProductQuantity] DECIMAL(28, 8) NULL, 
        [PerfectRate] DECIMAL(28, 8) null, 
        [MaterialRate] DECIMAL(28, 8) null, 
        [HumanResourceRate] DECIMAL(28, 8) null, 
        [OthersRate] DECIMAL(28, 8) null, 

        ) ON [PRIMARY]


DELETE MT2222  --- bang tam 

    INSERT MT2222(    DivisionID, 
                ProductID, 
                         InventoryTypeID, 
                UnitID, 
                         ProductQuantity, 
                PerfectRate, 
                MaterialRate, 
                HumanResourceRate, 
                OthersRate   
                 ) 

    EXEC (@sSQL)


SELECT @EndMethodID = EndMethodID FROM MT1608 WHERE InprocessID = @InprocessID and DivisionID = @DivisionID

IF @EndMethodID =0   --- Tinh toan so lieu
   BEGIN 
----- Buoc 2: Xac dinh CP DD cho NVL TT
    EXEC    MP8621 @DivisionID, @PeriodID, @TranMonth, @TranYear, @InProcessID, @VoucherID, @CMonth, @CYear

----- Buoc 3: Xac dinh CP DD cho NC TT
    EXEC    MP8622 @DivisionID, @PeriodID, @TranMonth, @TranYear, @InProcessID, @VoucherID, @CMonth, @CYear
	
----- Buoc 4: Xac dinh CP DD cho CP SXC
    EXEC    MP8627 @DivisionID, @PeriodID, @TranMonth, @TranYear, @InProcessID, @VoucherID, @CMonth, @CYear
   END
ELSE
    EXEC     MP8011  @DivisionID, @PeriodID, @TranMonth, @TranYear

SET NOCOUNT OFF
GO


