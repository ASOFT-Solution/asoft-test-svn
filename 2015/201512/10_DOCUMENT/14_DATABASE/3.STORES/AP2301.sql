/****** Object:  StoredProcedure [dbo].[AP2301]    Script Date: 08/05/2010 09:42:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Quoc Huy, Date 28/03/2007
----- Kiem tra han muc cua ma phan tich
----- Edit by: Dang Le Bao Quynh; Date: 14/03/2008
----- Purpose: Tinh han muc theo ma vat tu theo tong luy ke'
---- Edit by: Dang Le Bao Quynh; Date: 16/01/2009
---- Purpose: Bo sung truong hop xuat hang mua tra lai
---- Edit by B.Anh, date 11/01/2010	Sua bien @Language thanh kieu int

ALTER PROCEDURE [dbo].[AP2301]
       @DivisionID AS varchar(20) ,
       @AnaTypeID AS varchar(20) ,
       @AnaID AS varchar(20) ,
       @InventoryID AS varchar(20) ,
       @DebitAccountID AS varchar(20) ,
       @CreditAccountID AS varchar(20) ,
       @Quantity AS money ,
       @Amount AS money ,
       @MethodID AS tinyint , 			--(0: InventoryID, 1: DebitAccountID, 2: CreditAccount)
       @Language AS int ,
       @VoucherID AS varchar(20) = ''
AS
DECLARE
        @Status AS tinyint ,
        @Message AS varchar(5000) ,
        @SumofQuantity AS money ,
        @SumofAmount AS money

SET @Message = ''
SET @Status = 0



IF @MethodID = 0---InventoryID
   BEGIN
         IF EXISTS ( SELECT TOP 1
                         1
                     FROM
                         AT2301
                     WHERE
                         AnaTypeID = @AnaTypeID AND AnaID = @AnaID AND InventoryID = @InventoryID AND DivisionID = @DivisionID )
            BEGIN
                  SET @SumofQuantity = CASE @AnaTypeID
                                         WHEN 'A01' THEN
                                         ( SELECT
                                               Isnull(Sum(isnull(ActualQuantity , 0)) , 0)
                                           FROM
                                               AT2006 INNER JOIN AT2007
                                           ON  AT2006.VoucherID = AT2007.VoucherID
                                               AND AT2006.DivisionID = AT2007.DivisionID
                                           WHERE
                                               InventoryID = @InventoryID AND Ana01ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                               AND AT2006.DivisionID = @DivisionID)
                                         WHEN 'A02' THEN
                                         ( SELECT
                                               Isnull(Sum(isnull(ActualQuantity , 0)) , 0)
                                           FROM
                                               AT2006 INNER JOIN AT2007
                                           ON  AT2006.VoucherID = AT2007.VoucherID
                                               AND AT2006.DivisionID = AT2007.DivisionID
                                           WHERE
                                               InventoryID = @InventoryID AND Ana02ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                               AND AT2006.DivisionID = @DivisionID)
                                         WHEN 'A03' THEN
                                         ( SELECT
                                               Isnull(Sum(isnull(ActualQuantity , 0)) , 0)
                                           FROM
                                               AT2006 INNER JOIN AT2007
                                           ON  AT2006.VoucherID = AT2007.VoucherID
                                               AND AT2006.DivisionID = AT2007.DivisionID
                                           WHERE
                                               InventoryID = @InventoryID AND Ana03ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                               AND AT2006.DivisionID = @DivisionID)
                                         WHEN 'A04' THEN
                                         ( SELECT
                                               Isnull(Sum(isnull(ActualQuantity , 0)) , 0)
                                           FROM
                                               AT2006 INNER JOIN AT2007
                                           ON  AT2006.VoucherID = AT2007.VoucherID
                                               AND AT2006.DivisionID = AT2007.DivisionID
                                           WHERE
                                               InventoryID = @InventoryID AND Ana04ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                               AND AT2006.DivisionID = @DivisionID)
                                         WHEN 'A05' THEN
                                         ( SELECT
                                               Isnull(Sum(isnull(ActualQuantity , 0)) , 0)
                                           FROM
                                               AT2006 INNER JOIN AT2007
                                           ON  AT2006.VoucherID = AT2007.VoucherID
                                               AND AT2006.DivisionID = AT2007.DivisionID
                                           WHERE
                                               InventoryID = @InventoryID AND Ana05ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                               AND AT2006.DivisionID = @DivisionID)
                                         ELSE 0
                                       END

                  IF
                  ( SELECT TOP 1
                        Quantity
                    FROM
                        AT2301
                    WHERE
                        AnaTypeID = @AnaTypeID AND AnaID = @AnaID AND InventoryID = @InventoryID AND DivisionID = @DivisionID) < @SumofQuantity + @Quantity
                     BEGIN
                           SET @Status = 1
                           SET @Message = ' Sè l­îng xuÊt cña mÆt hµng nµy theo m· ph©n tÝch ' + @AnaID + ' v­ît qu¸ h¹n møc'
                     END
            END
   END

IF @MethodID = 1---DebitAccountID
   BEGIN

         IF EXISTS ( SELECT TOP 1
                         1
                     FROM
                         AT2301
                     WHERE
                         AnaTypeID = @AnaTypeID AND AnaID = @AnaID AND DebitAccountID = @DebitAccountID AND DivisionID = @DivisionID)
            BEGIN
                  SET @SumofAmount = CASE @AnaTypeID
                                       WHEN 'A01' THEN
                                       ( SELECT
                                             Isnull(Sum(isnull(ConvertedAmount , 0)) , 0)
                                         FROM
                                             AT2006 INNER JOIN AT2007
                                         ON  AT2006.VoucherID = AT2007.VoucherID
                                             AND AT2006.DivisionID = AT2007.DivisionID
                                         WHERE
                                             DebitAccountID = @DebitAccountID AND Ana01ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                             AND AT2006.DivisionID = @DivisionID)
                                       WHEN 'A02' THEN
                                       ( SELECT
                                             Isnull(Sum(isnull(ConvertedAmount , 0)) , 0)
                                         FROM
                                             AT2006 INNER JOIN AT2007
                                         ON  AT2006.VoucherID = AT2007.VoucherID
                                             AND AT2006.DivisionID = AT2007.DivisionID
                                         WHERE
                                             DebitAccountID = @DebitAccountID AND Ana02ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                             AND AT2006.DivisionID = @DivisionID)
                                       WHEN 'A03' THEN
                                       ( SELECT
                                             Isnull(Sum(isnull(ConvertedAmount , 0)) , 0)
                                         FROM
                                             AT2006 INNER JOIN AT2007
                                         ON  AT2006.VoucherID = AT2007.VoucherID
                                             AND AT2006.DivisionID = AT2007.DivisionID
                                         WHERE
                                             DebitAccountID = @DebitAccountID AND Ana03ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                             AND AT2006.DivisionID = @DivisionID)
                                       WHEN 'A04' THEN
                                       ( SELECT
                                             Isnull(Sum(isnull(ConvertedAmount , 0)) , 0)
                                         FROM
                                             AT2006 INNER JOIN AT2007
                                         ON  AT2006.VoucherID = AT2007.VoucherID
                                             AND AT2006.DivisionID = AT2007.DivisionID
                                         WHERE
                                             DebitAccountID = @DebitAccountID AND Ana04ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                             AND AT2006.DivisionID = @DivisionID)
                                       WHEN 'A05' THEN
                                       ( SELECT
                                             Isnull(Sum(isnull(ConvertedAmount , 0)) , 0)
                                         FROM
                                             AT2006 INNER JOIN AT2007
                                         ON  AT2006.VoucherID = AT2007.VoucherID
                                             AND AT2006.DivisionID = AT2007.DivisionID
                                         WHERE
                                             DebitAccountID = @DebitAccountID AND Ana05ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                             AND AT2006.DivisionID = @DivisionID)
                                       ELSE 0
                                     END
                  IF
                  ( SELECT TOP 1
                        Amount
                    FROM
                        AT2301
                    WHERE
                        AnaTypeID = @AnaTypeID AND AnaID = @AnaID AND DebitAccountID = @DebitAccountID AND DivisionID = @DivisionID) < @SumofAmount + @Amount
                     BEGIN
                           SET @Status = 1
                           SET @Message = 'Thµn tiÒn ®· v­ît qu¸ h·n møc theo m· ph©n tÝch ' + @AnaID
                           GOTO ENDMESS
                     END
            END

   END

IF @MethodID = 2---CreditAccountID
   BEGIN

         IF EXISTS ( SELECT TOP 1
                         1
                     FROM
                         AT2301
                     WHERE
                         AnaTypeID = @AnaTypeID AND AnaID = @AnaID AND CreditAccountID = @CreditAccountID AND DivisionID = @DivisionID)
            BEGIN
                  SET @SumofAmount = CASE @AnaTypeID
                                       WHEN 'A01' THEN
                                       ( SELECT
                                             Isnull(Sum(isnull(ConvertedAmount , 0)) , 0)
                                         FROM
                                             AT2006 INNER JOIN AT2007
                                         ON  AT2006.VoucherID = AT2007.VoucherID
                                             AND AT2006.DivisionID = AT2007.DivisionID
                                         WHERE
                                             CreditAccountID = @CreditAccountID AND Ana01ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                             AND AT2006.DivisionID = @DivisionID)
                                       WHEN 'A02' THEN
                                       ( SELECT
                                             Isnull(Sum(isnull(ConvertedAmount , 0)) , 0)
                                         FROM
                                             AT2006 INNER JOIN AT2007
                                         ON  AT2006.VoucherID = AT2007.VoucherID
                                             AND AT2006.DivisionID = AT2007.DivisionID
                                         WHERE
                                             CreditAccountID = @CreditAccountID AND Ana02ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                             AND AT2006.DivisionID = @DivisionID)
                                       WHEN 'A03' THEN
                                       ( SELECT
                                             Isnull(Sum(isnull(ConvertedAmount , 0)) , 0)
                                         FROM
                                             AT2006 INNER JOIN AT2007
                                         ON  AT2006.VoucherID = AT2007.VoucherID
                                             AND AT2006.DivisionID = AT2007.DivisionID
                                         WHERE
                                             CreditAccountID = @CreditAccountID AND Ana03ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                             AND AT2006.DivisionID = @DivisionID)
                                       WHEN 'A04' THEN
                                       ( SELECT
                                             Isnull(Sum(isnull(ConvertedAmount , 0)) , 0)
                                         FROM
                                             AT2006 INNER JOIN AT2007
                                         ON  AT2006.VoucherID = AT2007.VoucherID
                                             AND AT2006.DivisionID = AT2007.DivisionID
                                         WHERE
                                             CreditAccountID = @CreditAccountID AND Ana04ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                             AND AT2006.DivisionID = @DivisionID)
                                       WHEN 'A05' THEN
                                       ( SELECT
                                             Isnull(Sum(isnull(ConvertedAmount , 0)) , 0)
                                         FROM
                                             AT2006 INNER JOIN AT2007
                                         ON  AT2006.VoucherID = AT2007.VoucherID
                                             AND AT2006.DivisionID = AT2007.DivisionID
                                         WHERE
                                             CreditAccountID = @CreditAccountID AND Ana05ID = @AnaID AND KindVoucherID IN ( 2 , 4 , 6 , 8 , 10 ) AND AT2007.VoucherID <> @VoucherID 
                                             AND AT2006.DivisionID = @DivisionID)
                                       ELSE 0
                                     END
                  IF
                  ( SELECT TOP 1
                        Amount
                    FROM
                        AT2301
                    WHERE
                        AnaTypeID = @AnaTypeID AND AnaID = @AnaID AND CreditAccountID = @CreditAccountID AND DivisionID = @DivisionID) < @SumofAmount + @Amount
                     BEGIN
                           SET @Status = 1
                           SET @Message = 'Thaønh tieàn ñaõ vöôït quaù haïn möùc theo maõ phaân tích ' + @AnaID
                           GOTO ENDMESS
                     END
            END

   END

ENDMESS:
SELECT
    @Status AS Status ,
    @Message AS Message