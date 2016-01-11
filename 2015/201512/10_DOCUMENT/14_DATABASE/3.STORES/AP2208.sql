/****** Object:  StoredProcedure [dbo].[AP2208]    Script Date: 08/27/2010 15:28:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/

------ Created by Nguyen Van Nhan, Date 09/05/2005
----- Kiem tra man hinh hieu Mua hang cho  phep luu hay khong
ALTER PROCEDURE [dbo].[AP2208]
       @DivisionID AS nvarchar(50) ,
       @VoucherID AS nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int ,
       @TransactionID AS nvarchar(50) ,
       @WareHouseID AS nvarchar(50) ,
       @IsNegativeStock AS tinyint ,
       @InventoryID AS nvarchar(50) ,
       @AccountID AS nvarchar(50) ,
       @MethodID AS tinyint ,
       @IsSource AS tinyint ,
       @IsLimitDate AS tinyint ,
       @OldQuantity AS decimal(28,8) ,
       @NewQuantity AS decimal(28,8) ,
       @Language AS tinyint
AS
DECLARE
        @Message AS nvarchar(4000)

SET @Message = ''

IF @MethodID = 3 OR @IsSource = 1 OR @IsLimitDate = 1  --- Quan ly dich danh
   BEGIN
         IF EXISTS ( SELECT TOP 1
                         1
                     FROM
                         AT0114
                     WHERE
                         DivisionID = @DivisionID AND ReQuantity + @NewQuantity - @OldQuantity - DeQuantity < 0 AND ReTransactionID = @TransactionID AND InventoryID = @InventoryID )
            BEGIN
                  SET @Message = 'WFML000086'
            END

   END
ELSE
   BEGIN

         IF @IsNegativeStock = 0
            BEGIN
                  IF EXISTS ( SELECT TOP 1
                                  1
                              FROM
                                  AT2008
                              WHERE
                                  TranMonth = @TranMonth AND TranYear = @TranYear AND DivisionID = @DivisionID AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID AND InventoryAccountID = @AccountID AND EndQuantity + @NewQuantity - @OldQuantity < 0 )
                     BEGIN
                           SET @Message = 'WFML000087'
                           GOTO ENDMESS
                     END
            END


   END

ENDMESS:
SELECT
    @Message AS Message

