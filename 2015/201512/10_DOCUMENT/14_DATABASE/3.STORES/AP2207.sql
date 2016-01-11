/****** Object:  StoredProcedure [dbo].[AP2207]    Script Date: 10/20/2010 15:24:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



----- 	Created by Nguyen Van Nhan and Nguyen Minh Thuy
----- 	Edit by Nguyen Quoc Huy
-----	Created Date 07/05/2005
----	Purpose: Cap nhat lai so luong , don gia nhap kho khi hieu chinh man hinh mua hang
----	Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh

ALTER PROCEDURE [dbo].[AP2207]
       @DivisionID AS nvarchar(50) ,
       @VoucherID nvarchar(50) ,
       @TranMonth int ,
       @TranYear AS int
AS
DECLARE
        @AT9000_cur AS cursor ,
        @TransactionID AS nvarchar(50) ,
        @InventoryID AS nvarchar(50) ,
        @NewQuantity AS decimal(28,8) ,
        @UnitPrice AS decimal(28,8) , ---- Gia nhap kho
        @ConvertedAmount AS decimal(28,8) , --- Thanh tien nhap kho
        @Ana01ID AS nvarchar(50) ,
        @Ana02ID AS nvarchar(50) ,
        @Ana03ID AS nvarchar(50) ,
        @ExchangeRate AS decimal(28,8) ,
        @ObjectID AS nvarchar(50) ,
        @LastModifyUserID AS nvarchar(50) ,
        @UnitCostDecimals AS int

SELECT
    @UnitCostDecimals = isnull(UnitCostDecimals , 0)
FROM
    AT1101 
WHERE DivisionID = @DivisionID



IF EXISTS ( SELECT TOP 1
                1
            FROM
                AT2006
            WHERE
                VoucherID = @VoucherID AND TableID = 'AT9000' AND DivisionID = @DivisionID)
   BEGIN
---- B1 Lay cac gia moi duoc hieu chinh o man hinh mua hang
         SET @AT9000_cur = CURSOR SCROLL KEYSET FOR SELECT
                                                        TransactionID ,
                                                        InventoryID ,
                                                        Quantity ,
                                                        Ana01ID ,
                                                        Ana02ID ,
                                                        Ana03ID ,
                                                        ( ConvertedAmount + isnull(ImTaxConvertedAmount , 0) + isnull(ExpenseOriginalAmount , 0) ) AS ConvertedAmount ,
                                                        ExchangeRate ,
                                                        ObjectID ,
                                                        LastModifyUserID
                                                    FROM
                                                        AT9000
                                                    WHERE
                                                        VoucherID = @VoucherID AND TransactionTypeID = 'T03' AND DivisionID = @DivisionID
         OPEN @AT9000_cur
         FETCH NEXT FROM @AT9000_cur INTO @TransactionID,@InventoryID,@NewQuantity,@Ana01ID,@Ana02ID,@Ana03ID,@ConvertedAmount,@ExchangeRate,@ObjectID,@LastModifyUserID


/*
Update AT2006 set ObjectID = @ObjectID 
Where 	VoucherID =@VoucherID and
	TableID = 'AT9000'
*/
         WHILE @@Fetch_Status = 0
               BEGIN	--- Cap nhat gia xuat kho thuong


                     UPDATE
                         AT2007
                     SET
                         ActualQuantity = @NewQuantity ,
                         ConvertedAmount = @ConvertedAmount ,
                         OriginalAmount = @ConvertedAmount ,
                         UnitPrice = ( CASE
                                            WHEN @NewQuantity <> 0 THEN round(( @ConvertedAmount / @NewQuantity ) , @UnitCostDecimals)
                                            ELSE 0
                                       END )
                     FROM
                         AT2007 INNER JOIN AT2006
                         ON AT2007.VoucherID = AT2006.VoucherID
                         AND AT2007.DivisionID = AT2006.DivisionID
                     WHERE
                         AT2007.DivisionID = @DivisionID AND AT2007.VoucherID = @VoucherID AND AT2007.TransactionID = @TransactionID AND AT2007.InventoryID = @InventoryID AND AT2006.TableID = 'AT9000'

                     FETCH NEXT FROM @AT9000_cur INTO @TransactionID,@InventoryID,@NewQuantity,@Ana01ID,@Ana02ID,@Ana03ID,@ConvertedAmount,@ExchangeRate,@ObjectID,@LastModifyUserID

               END

         UPDATE
             AT2006
         SET
             ObjectID = @ObjectID
         WHERE
             VoucherID = @VoucherID AND TableID = 'AT9000' AND DivisionID = @DivisionID

         CLOSE @AT9000_cur

   END
