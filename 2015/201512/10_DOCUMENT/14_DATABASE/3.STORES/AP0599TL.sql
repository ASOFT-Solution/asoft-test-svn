IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0599TL]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0599TL]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


  
  
---- Created by Nguyen Van Nhan,   
---- Date 19/03/2003  
---- Edit by Nguyen Quoc Huy, Date 13/02/2007  
--- Edit by: Dang Le Bao Quynh; Date 31/07/2008  
--- Purpose: Thay doi cach tinh gia tri ton cuoi  
--Edit by: Dang Le Bao Quynh; Date: 16/01/2009  
--Purpose: Bo sung truong hop xuat hang mua tra lai  
--Edit by: Dang Le Bao Quynh; Date: 21/04/2009  
--Purpose: Bo sung ma phan tich 4 5  
--Edit by: Dang Le Bao Quynh; Date: 23/02/2010  
--Purpose: Bo sung kindvoucherID cho cac truong hop nhap kho mua hang, xuat kho ban hang  
/********************************************  
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]  
'********************************************/  
--- Edited by Bao Anh Date: 21/08/2012  
--- Purpose: Cap nhat AT0114 doi voi kho nhap khi xuat VCNB  
--- Edited by Bao Anh Date: 21/08/2012  
--- Purpose: Them quy cach va so luong mark (yeu cau cua 2T)  
--- Edited by Bao Anh Date: 30/10/2012  
--- Purpose: Them so luong mark vao AT0114 (yeu cau cua 2T)  
--- Edited by Bao Anh Date: 08/11/2012  
--- Purpose: Bo sung DVT quy doi, sl quy doi va dg quy doi vao AT9000 (2T)  
--- Edited by Bao Anh Date: 20/11/2012   
--- Purpose: Dung @ActualQuantity cap nhat vao AT2008 va AT0114 (truoc day dung @ConvertedQuantity)  
--- Edited by Bao Quynh Date: 23/04/2013   
--- Purpose: Neu la but toan xuat kho hang mua tra lai thi khong ban qua so cai'.  
---- Modified on 29/07/2013 by Lê Thị Thu Hiền : Bổ sung RefNo01, RefNo02 
---- Modified on 10/04/2015 by Thanh Sơn: Bổ sung nếu loại chứng từ và số chứng từ <> '%NM%' thì không chuyển qua AT9000
  
CREATE PROCEDURE [dbo].[AP0599TL]  
    @TransactionID NVARCHAR(50),   
    @DivisionID NVARCHAR(50),   
    @RDVoucherID NVARCHAR(50),   
    @TranYear INT,   
    @TranMonth INT,   
    @RDVoucherDate DATETIME,   
    @RDVoucherNo NVARCHAR(50),   
    @EmployeeID NVARCHAR(50),  
    @ObjectID NVARCHAR(50), -- @VoucherTypeID NVARCHAR(50),  
    @CreateUserID NVARCHAR(50),   
    @CreateDate DATETIME,   
    @Description NVARCHAR(225),   
    @WareHouseID NVARCHAR(50),   
    @WareHouseID2 NVARCHAR(50),   
    @Status INT,   
    @KindVoucherID INT,   
    @CurrencyID NVARCHAR(50),   
    @ExchangeRate DECIMAL(28, 8),   
    @InventoryID NVARCHAR(50),   
    @UnitID NVARCHAR(50),   
    @MethodID TINYINT,   
    @ActualQuantity DECIMAL(28, 8),   
    @UnitPrice DECIMAL(28, 8),   
    @ConvertedQuantity DECIMAL(28, 8),   
    @ConvertedUnitPrice DECIMAL(28, 8),   
    @OriginalAmount DECIMAL(28, 8),   
    @ConvertedAmount DECIMAL(28, 8),   
    @DebitAccountID NVARCHAR(50),   
    @CreditAccountID NVARCHAR(50),   
    @SourceNo NVARCHAR(50),   
    @IsLimitDate TINYINT,   
    @IsSource TINYINT,   
    @LimitDate AS DATETIME,   
    @TableID AS NVARCHAR(50),   
    @BatchID AS NVARCHAR(50),   
    @Ana01ID AS NVARCHAR(50),   
    @Ana02ID AS NVARCHAR(50),   
    @Ana03ID AS NVARCHAR(50),   
    @Ana04ID AS NVARCHAR(50),   
    @Ana05ID AS NVARCHAR(50),   
    @Ana06ID AS NVARCHAR(50),   
    @Ana07ID AS NVARCHAR(50),   
    @Ana08ID AS NVARCHAR(50),   
    @Ana09ID AS NVARCHAR(50),   
    @Ana10ID AS NVARCHAR(50),   
    @Notes AS NVARCHAR(250),   
    @VoucherTypeID NVARCHAR(50),   
    @PeriodID NVARCHAR(50),   
    @ProductID NVARCHAR(50),   
    @IsTemp TINYINT,   
    @OrderID NVARCHAR(50),   
    @OTransactionID AS NVARCHAR(50),   
    @MOrderID AS NVARCHAR(50),   
    @SOrderID AS NVARCHAR(50),  
    @IsGoodsFirstVoucher AS TINYINT,  
    @ReVoucherID AS NVARCHAR(50),  
    @ReTransactionID NVARCHAR(50),  
    @Parameter01 AS DECIMAL(28,8),  
    @Parameter02 AS DECIMAL(28,8),  
    @Parameter03 AS DECIMAL(28,8),  
    @Parameter04 AS DECIMAL(28,8),  
    @Parameter05 AS DECIMAL(28,8),  
    @MarkQuantity AS DECIMAL(28,8),  
    @ConvertedUnitID NVARCHAR(50),  
    @RefNo01 NVARCHAR(100),  
 @RefNo02 NVARCHAR(100)  
AS  
DECLARE @CustomerName INT  
--Tao bang tam de kiem tra day co phai la khach hang 2T khong (CustomerName = 15)  
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)  
INSERT #CustomerName EXEC AP4444  
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)  
  
  
  
IF (@IsSource <> 0 OR @IsLimitDate <> 0 OR @MethodID IN (1, 2, 3, 5, 7) ) AND @KindVoucherID IN (1, 3, 5, 7, 9, 15, 17)  
BEGIN  
    --print 'INSERT vao bang tinh gia xuat kho: AT0114'   
    IF @CustomerName = 15 --- Customize 2T  
    Begin  
    INSERT AT0114 (InventoryID, DivisionID, WareHouseID, ReVoucherID, ReTransactionID, ReVoucherNo,   
    ReVoucherDate, ReTranMonth, ReTranYear, ReSourceNo, ReQuantity, DeQuantity,   
    EndQuantity, UnitPrice, Status, LimitDate, ReMarkQuantity, DeMarkQuantity, EndMarkQuantity)  
    VALUES (@InventoryID, @DivisionID, @WareHouseID, @RDVoucherID, @TransactionID, @RDVoucherNo,   
    @RDVoucherDate, @TranMonth, @TranYear, @SourceNo, @ActualQuantity, 0,   
    @ActualQuantity,   
    CASE WHEN @MarkQuantity <> 0 THEN @ConvertedAmount/@MarkQuantity ELSE @ConvertedUnitPrice END, 0, @LimitDate,  
    @MarkQuantity, 0, @MarkQuantity)  
    End  
    Else  
    Begin  
    INSERT AT0114 (InventoryID, DivisionID, WareHouseID, ReVoucherID, ReTransactionID, ReVoucherNo,   
    ReVoucherDate, ReTranMonth, ReTranYear, ReSourceNo, ReQuantity, DeQuantity,   
    EndQuantity, UnitPrice, Status, LimitDate, ReMarkQuantity, DeMarkQuantity, EndMarkQuantity)  
    VALUES (@InventoryID, @DivisionID, @WareHouseID, @RDVoucherID, @TransactionID, @RDVoucherNo,   
    @RDVoucherDate, @TranMonth, @TranYear, @SourceNo, @ActualQuantity, 0,   
    @ActualQuantity,   
    CASE WHEN @ActualQuantity <> 0 THEN @ConvertedAmount/@ActualQuantity ELSE @ConvertedUnitPrice END, 0, @LimitDate,  
    @MarkQuantity, 0, @MarkQuantity)  
    End  
END  
IF(NOT EXISTS ( SELECT 1 FROM AT0000 WHERE IsSpecificate = 1))
BEGIN 
IF @KindVoucherID = 3 --- la xuat van chuyen noi bo  
BEGIN  
    EXEC AP0512 @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @ConvertedAmount, @ActualQuantity, @DebitAccountID, @CreditAccountID, 11, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05, @MarkQuantity -- (1) la cap nhat tang, (0 ) la cap nhat giam  
    EXEC AP0512 @DivisionID, @WareHouseID2, @TranMonth, @TranYear, @InventoryID, @ConvertedAmount, @ActualQuantity, @DebitAccountID, @CreditAccountID, 10, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05, @MarkQuantity -- (1) la cap nhat tang, (0 ) la cap nhat giam   
    IF (@IsSource <> 0 OR @IsLimitDate <> 0 OR @MethodID IN (1, 2, 3, 5, 7) ) AND @KindVoucherID IN (1, 3, 5, 7, 9, 15, 17)  
     BEGIN  
      UPDATE AT0114 SET DeQuantity = DeQuantity + @ActualQuantity, EndQuantity = EndQuantity - @ActualQuantity,  
          DeMarkQuantity = DeMarkQuantity + @MarkQuantity, EndMarkQuantity = EndMarkQuantity - @MarkQuantity  
      WHERE InventoryID = @InventoryID AND DivisionID = @DivisionID AND WareHouseID = @WareHouseID2  
      AND ReVoucherID = @ReVoucherID AND ReTransactionID = @ReTransactionID        
     END  
END
ELSE IF @KindVoucherID IN (1, 5, 7, 9, 15, 17) --- Nhap kho, dieu chinh tang : 1: nhap kho - 5: mua hang nhap kho - 7: hang ban tra lai nhap kho - 9: dieu chinh kiem ke kho tang - 15: nhap kho mua hang - 17: nhap kho xuat kho hang ban tra lai  
    EXEC AP0512 @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @ConvertedAmount, @ActualQuantity, @DebitAccountID, @CreditAccountID, 1, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05, @MarkQuantity -- (1) la cap nhat tang, (0 ) la cap nhat giam  
ELSE IF @KindVoucherID IN (2, 4, 6, 8, 10, 14, 20) --- Xuat kho, dieu chinh giam: 2: Xuat kho - 4: ban hang xuat kho - 8: dieu chinh kiem ke kho giam -10: hang mua tra lai xuat kho -14: xuat kho ban hang -20: xuat kho nhap kho mua hang tra lai  
  EXEC AP0512 @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @ConvertedAmount, @ActualQuantity, @DebitAccountID, @CreditAccountID, 0, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05, @MarkQuantity -- (1) la cap nhat tang, (0 ) la cap nhat giam  
END 
ELSE
	BEGIN
		IF @KindVoucherID = 3 --- la xuat van chuyen noi bo  
		BEGIN
			IF (@IsSource <> 0 OR @IsLimitDate <> 0 OR @MethodID IN (1, 2, 3, 5, 7) ) AND @KindVoucherID IN (1, 3, 5, 7, 9, 15, 17)  
			 BEGIN  
				UPDATE AT0114 SET DeQuantity = DeQuantity + @ActualQuantity, EndQuantity = EndQuantity - @ActualQuantity,  
				DeMarkQuantity = DeMarkQuantity + @MarkQuantity, EndMarkQuantity = EndMarkQuantity - @MarkQuantity  
				WHERE InventoryID = @InventoryID AND DivisionID = @DivisionID AND WareHouseID = @WareHouseID2  
				AND ReVoucherID = @ReVoucherID AND ReTransactionID = @ReTransactionID        
			 END  
		END
	END
 
IF @TableID IN ('AT2006', 'MT0810') AND @IsTemp = 0 AND ISNULL(@IsGoodsFirstVoucher, 0) = 0 AND @KindVoucherID <> 10 AND (@KindVoucherID <> 3 OR ( @KindVoucherID = 3 AND @DebitAccountID <> @CreditAccountID) )  
    If (@RDVoucherNo NOT LIKE '%NM%' AND @VoucherTypeID NOT LIKE '%NM%')--Customize cho Thuan Loi, LTV neu nhap kho truoc mua hang sau thi không chuyen qua AT9000
    INSERT AT9000  
    (VoucherID, BatchID, TransactionID, TableID,   
    DivisionID, TranMonth, TranYear, TransactionTypeID,   
    CurrencyID, CurrencyIDCN, ObjectID, DebitAccountID, CreditAccountID,   
    ExchangeRate, OriginalAmount, ConvertedAmount,   
    ExchangeRateCN, OriginalAmountCN,   
    VoucherDate, VoucherTypeID, VoucherNo,   
    Orders, EmployeeID,   
    Ana01ID, Ana02ID, Ana03ID, Ana04ID, Ana05ID,   
    Ana06ID, Ana07ID, Ana08ID, Ana09ID, Ana10ID,   
    VDescription, BDescription, TDescription, Quantity, UnitPrice,   
    InventoryID, UnitID, Status,   
    ProductID, PeriodID, OrderID,   
    CreateDate, CreateUserID, LastModifyDate, LastModifyUserID, OTransactionID,  
    MOrderID, SOrderID, UParameter01, UParameter02, UParameter03, UParameter04, UParameter05, MarkQuantity,  
    ConvertedUnitID, ConvertedQuantity, ConvertedPrice, RefNo01, RefNo02)   
    VALUES  
    (@RDVoucherID, ISNULL(@BatchID, ''), @TransactionID, @TableID,   
    @DivisionID, @TranMonth, @TranYear,   
    CASE WHEN @KindVoucherID IN (1, 3, 5, 7, 9, 15, 17) THEN 'T05' ELSE  
    CASE WHEN @KindVoucherID IN ( 2, 4, 6, 8, 10, 14, 20) THEN 'T06' ELSE 'T99' END END,   
    @CurrencyID, @CurrencyID, @ObjectID, @DebitAccountID, @CreditAccountID,   
    @ExchangeRate, @OriginalAmount, @ConvertedAmount,   
    @ExchangeRate, @OriginalAmount,   
    @RDVoucherDate, @VoucherTypeID, @RDVoucherNo,   
    1, @EmployeeID,   
    @Ana01ID, @Ana02ID, @Ana03ID, @Ana04ID, @Ana05ID,   
    @Ana06ID, @Ana07ID, @Ana08ID, @Ana09ID, @Ana10ID,   
    @Description, @Description, @Notes, @ActualQuantity, @UnitPrice,   
    @InventoryID, @UnitID, 0,   
    @ProductID, @PeriodID, @OrderID,   
    @CreateDate, @CreateUserID, @CreateDate, @CreateUserID, @OTransactionID,  
    @MOrderID, @SOrderID, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05, @MarkQuantity,  
    @ConvertedUnitID, @ConvertedQuantity, @ConvertedUnitPrice,@RefNo01, @RefNo02)  

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
