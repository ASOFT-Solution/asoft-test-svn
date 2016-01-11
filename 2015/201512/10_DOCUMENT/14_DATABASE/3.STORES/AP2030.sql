/****** Object:  StoredProcedure [dbo].[AP2030]    Script Date: 09/13/2010 17:03:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/********************************************
'* Edited by: [GS] [Minh Lâm] [28/07/2010]
'********************************************/

------ Created by Nguyen Van Nhan, Date 17/11/2005
----- Kiem tra hieu chinh khi luu 
ALTER PROCEDURE [dbo].[AP2030]
       @DivisionID nvarchar(50) ,
       @TranMonth int ,
       @TranYear AS int ,
       @VoucherID nvarchar(50) ,
       @TransactionID nvarchar(50) ,
       @WareHouseID nvarchar(50) ,
       @InventoryID nvarchar(50) ,
       @NewQuantity AS decimal(28,8) ,
       @OldQuantity AS decimal(28,8) 
       
AS
DECLARE
        @Status AS tinyint ,
        @Mess AS nvarchar(4000) ,
        @DeQuantity AS decimal(28,8) ,
        @MethodID AS tinyint ,
        @IsSource tinyint ,
        @IsLimitDate tinyint

SET @Status = 0
SET @Mess = ''

SELECT
    @MethodID = MethodID ,
    @IsSource = IsSource ,
    @IsLimitDate = IsLimitDate
FROM
    AT1302
WHERE
    InventoryID = @InventoryID
AND DivisionID = @DivisionID

IF @MethodID IN ( 1 , 2 , 3 ) OR @IsSource <> 0 OR @IsLimitDate <> 0
   BEGIN
         SET @DeQuantity = NULL
         SET @DeQuantity = ( SELECT
                                 isnull(DeQuantity , 0)
                             FROM
                                 AT0114
                             WHERE
                                 DivisionID = @DivisionID AND ReVoucherID = @VoucherID AND ReTransactionID = @TransactionID AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID AND DeQuantity <> 0 )
         IF @DeQuantity IS NOT NULL
            BEGIN
                  IF @NewQuantity - @DeQuantity < 0
                     BEGIN
                           SET @Status = 1
                           SET @Mess = "WFML000088"
                                    --SET @Mess = 'Sè l­îng b¹n ®· thay ®æi ®· nhá qu¸ møc cho phÐp! B¹n chØ ®­îc phÐp nhËp sè l­îng lín h¬n hoÆc b¼ng ' + str(@DeQuantity) + ' . B¹n kiÓm tra l¹i mÆt hµng : ' + @InventoryID + '.'
                     END
            END
   END

SELECT
    @Status AS Status ,
    @Mess AS Mess,
    @DeQuantity As DeQuantity
