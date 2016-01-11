/****** Object:  StoredProcedure [dbo].[AP7011]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- Created by Nguyen Van Nhan, Date 13/06/2003
---- Purpose:  Kiem tra co duoc phep xuat kho hay khong.
---- Duoc goi khi AddNew va Edit phieu xuat kho
--- Last edit : Thuy Tuyen, date  06/07/2009

/********************************************
'* Edited by: [GS] [Việt Khánh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP7011]     
    @UserID NVARCHAR(50), 
    @DivisionID NVARCHAR(50), 
    @TranMonth INT, 
    @TranYear INT, 
    @WareHouseID NVARCHAR(50), 
    @InventoryID NVARCHAR(50), 
    @UnitID NVARCHAR(50), 
    @ConversionFactor DECIMAL(28, 8), 
    @IsSource TINYINT, 
    @IsLimitDate TINYINT, 
    @CreditAccountID NVARCHAR(50), 
    @ReOldVoucherID NVARCHAR(50), 
    @ReOldTransactionID NVARCHAR(50), 
    @ReNewVoucherID NVARCHAR(50), 
    @ReNewTransactionID NVARCHAR(50), 
    @VoucherDate DATETIME, 
    @OldQuantity DECIMAL(28, 8), 
    @NewQuantity DECIMAL(28, 8), 
    @AllowOverShip TINYINT, 
    @MethodID TINYINT, 
    @OK TINYINT OUTPUT 
AS

DECLARE 
    @EndQuantity AS DECIMAL(28, 8), 
    @Message AS NVARCHAR(250), 
    @Status AS TINYINT, 
    @IsNegativeStock AS TINYINT

SET @OK = 0

SELECT @IsNegativeStock = IsNegativeStock FROM WT0000  --- Cho phep xuat kho am hay khong

SET @IsNegativeStock = ISNULL(@IsNegativeStock, 0)

SET NOCOUNT ON
DELETE AT7777 WHERE UserID = @UserID

IF  @IsSource<>0 or @IsLimitDate<>0 or @MethodID = 3
    --- Xuat dich danh, theo Lo - ngay het han

        EXEC AP8003 @UserID, @DivisionID, @TranMonth, @TranYear, @WareHouseID, @InventoryID, 
                    @UnitID, @ConversionFactor,     @CreditAccountID, 
                    @ReOldVoucherID, @ReOldTransactionID, 
                    @ReNewVoucherID, @ReNewTransactionID, 
                    @OldQuantity, @NewQuantity

ELSE

    BEGIN
    
        SET @EndQuantity = @OldQuantity*ISNULL(@ConversionFactor, 1)+ ISNULL( (SELECT EndQuantity FROM AT2008 WHERE DivisionID = @DivisionID AND
                                        TranMOnth = @TranMonth AND
                                        TranYear = @TranYear AND
                                        InventoryID = @InventoryID AND 
                                        InventoryAccountID = @CreditAccountID AND
                                        WareHouseID = @WareHouseID), 0)

    
    IF @NewQuantity*ISNULL(@ConversionFactor, 1) > @EndQuantity AND  @IsNegativeStock = 0 
        BEGIN
            SET @OK  = 1
            SET @Status = 1
            SET @Message = 'WFML000123'
        END    
    ELSE
        BEGIN
            SET @OK  = 0
            SET @Status = 0 
            SET @Message = ''
        END
    

        Insert AT7777 (DivisionID, UserID, Status, Message)
        Values (@DivisionID, @UserID, @Status, @Message)
    
        

    END
                

SET Nocount off
---- SELECT * FROM AT7777 WHERE UserID = @UserID
GO
