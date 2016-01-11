/****** Object:  StoredProcedure [dbo].[AP2031]    Script Date: 08/05/2010 09:37:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/********************************************
'* Edited by: [GS] [Minh Lâm] [29/07/2010]
'********************************************/

------ Created by Nguyen Van Nhan, Date 17/11/2005
----- Cap nhat lai  cac bang lien quan khi hieu chinh phieu nhap kho

ALTER PROCEDURE [dbo].[AP2031]
       @DivisionID nvarchar(50) ,
       @TranMonth int ,
       @TranYear AS int ,
       @VoucherID nvarchar(50) ,
       @TransactionID nvarchar(50) ,
       @InventoryID nvarchar(50) ,
       @OldQuantity AS decimal(28,8) ,
       @NewQuantity AS decimal(28,8) ,
       @OldConvertedAmount decimal(28,8) ,
       @NewConvertedAmount AS decimal(28,8)
AS
DECLARE
        @VoucherNo AS nvarchar(50) ,
        @VoucherDate AS datetime ,
        @VoucherTypeID AS nvarchar(50) ,
        @ObjectID AS nvarchar(50) ,
        @WareHouseID AS nvarchar(50) ,
        @EmployeeID AS nvarchar(50) ,
        @Description AS varchar(250) ,
        @LastModifyUserID AS nvarchar(50) ,
        @LastModifyDate datetime ,
        @RefNo01 AS nvarchar(50) ,
        @RefNo02 AS nvarchar(50) ,
----------Detail
        @Ana01ID AS nvarchar(50) ,
        @Ana02ID AS nvarchar(50) ,
        @Ana03ID AS nvarchar(50) ,
        @Notes AS varchar(250) ,
        @DebitAccountID nvarchar(50) ,
        @CreditAccountID nvarchar(50) ,
        @UnitPrice AS decimal(28,8) ,
        @SourceNo nvarchar(50) ,
        @LimitDate AS datetime ,
        @MethodID AS tinyint ,
        @IsSource AS tinyint ,
        @IsLimitDate AS tinyint

SELECT
    @MethodID = MethodID ,
    @IsSource = IsSource ,
    @IsLimitDate = IsLimitDate
FROM
    AT1302
WHERE
    InventoryID = @InventoryID AND DivisionID = @DivisionID
    
SELECT
    @VoucherNo = VoucherNo ,
    @VoucherDate = VoucherDate ,
    @VoucherTypeID = VoucherTypeID ,
    @ObjectID = ObjectID ,
    @WareHouseID = WareHouseID ,
    @EmployeeID = EmployeeID ,
    @Description = Description ,
    @LastModifyUserID = AT2006.LastModifyUserID ,
    @LastModifyDate = At2006.LastModifyDate ,
    @RefNo01 = RefNo01 ,
    @RefNo02 = RefNo02 ,
    @Ana01ID = Ana01ID ,
    @Ana02ID = Ana02ID ,
    @Ana03ID = Ana03ID ,
    @Notes = Notes ,
    @DebitAccountID = DebitAccountID ,
    @CreditAccountID = CreditAccountID ,
    @UnitPrice = UnitPrice ,
    @SourceNo = SourceNo ,
    @LimitDate = LimitDate
FROM
    AT2007 INNER JOIN AT2006
ON  AT2006.VoucherID = AT2007.VoucherID
AND AT2006.DivisionID = AT2007.DivisionID
WHERE
    AT2007.DivisionID = @DivisionID AND AT2007.VoucherID = @VoucherID AND AT2007.TransactionID = @TransactionID AND AT2007.InventoryID = @InventoryID 
	
--- Buoc 1: Cap nhat lai bang so du  AT2008-------------------------------------------------------------------------------------------------
UPDATE
    AT2008
SET
    DebitQuantity = DebitQuantity - @OldQuantity + @NewQuantity ,
    CreditAmount = DebitQuantity - @OldConvertedAmount + @NewConvertedAmount ,
    EndQuantity = EndQuantity - @OldQuantity + @NewQuantity ,
    EndAmount = EndAmount - @OldConvertedAmount + @NewConvertedAmount
WHERE
    DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear AND WareHouseID = @WareHouseID AND InventoryID = @InventoryID AND InventoryAccountID = @DebitAccountID

--- Buoc 2: Cap nhat lai bang theo doi dich danh AT0114------------------------------------------------------------------------------------------------
UPDATE
    AT0114
SET
    ReQuantity = @NewQuantity ,
    UnitPrice = @UnitPrice ,
    EndQuantity = @NewQuantity - DeQuantity ,
    ReVoucherNo = @VoucherNo ,
    ReVoucherDate = @VoucherDate ,
    ReSourceNo = @SourceNo ,
    LimitDate = @LimitDate
WHERE
    DivisionID = @DivisionID AND ReVoucherID = @VoucherID AND ReTransactionID = @TransactionID AND InventoryID = @InventoryID AND WareHouseID = @WareHouseID 

--- Buoc 3: Cap nhat lai bang but toan AT9000 ------------------------------------------------------------------------------------------------
UPDATE
    AT9000
SET
    ObjectID = @ObjectID ,
    DebitAccountID = @DebitAccountID ,
    CreditAccountID = @CreditAccountID ,
    UnitPrice = @UnitPrice ,
    OriginalAmount = @NewConvertedAmount ,
    ConvertedAmount = @NewConvertedAmount ,
    VoucherDate = @VoucherDate ,
    VoucherTypeID = @VoucherTypeID ,
    VoucherNo = @VoucherNo ,
    RefNo01 = @RefNo01 ,
    RefNo02 = @RefNo02 ,
    VDescription = @Description ,
    TDescription = @Notes ,
    Quantity = @NewQuantity ,
    Ana01ID = Ana01ID ,
    Ana02ID = @Ana02ID ,
    Ana03ID = @Ana03ID ,
    LastModifyDate = @LastModifyDate ,
    LastModifyUserID = @LastModifyUserID ,
    OriginalAmountCN = @NewConvertedAmount
WHERE
    DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear AND VoucherID = @VoucherID AND TransactionID = @TransactionID AND TableID = 'AT2006'