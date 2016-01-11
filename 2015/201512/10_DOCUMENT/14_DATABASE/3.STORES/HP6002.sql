
/****** Object:  StoredProcedure [dbo].[HP6002]    Script Date: 08/05/2010 10:06:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


----- Created by Vo Thanh Huong
---- Created Date 02/06/2004
---- Purpose: Tinh luong cho mot san pham

/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP6002]
       @DivisionID nvarchar(50) ,
       @TranMonth int ,
       @TranYear int ,
       @TransactionID nvarchar(50) ,
       @DepartmentID nvarchar(50) ,
       @TeamID nvarchar(50) ,
       @EmployeeID nvarchar(50) ,
       @ProductID nvarchar(50) ,
       @Quantity decimal(28,8)
AS
DECLARE
        @MethodID tinyint ,
        @SalaryAmount AS decimal(28,8) ,
        @UnitPrice AS decimal(28,8)

SET @SalaryAmount = 0


SET @MethodID = ( SELECT
                      MethodID
                  FROM
                      HT1015
                  WHERE
                      ProductID = @ProductID AND DivisionID = @DivisionID )

IF @MethodID = 0 ---luy tien
   BEGIN
         SET @SalaryAmount = isnull(
         ( SELECT
               Sum(Amount * ( CASE
                                   WHEN ( @Quantity > FromValues AND @Quantity <= Tovalues ) THEN @Quantity - FromValues
                                   ELSE CASE
                                             WHEN ( @Quantity <= FromValues ) THEN 0
                                             ELSE Tovalues - FromValues
                                        END
                              END ))
           FROM
               HT1016
           WHERE
               ProductID = @ProductID AND DivisionID = @DivisionID AND ToValues <> -1 ) , 0)


         SET @SalaryAmount = @SalaryAmount + isnull(
         ( SELECT
               Sum(Amount * ( @Quantity - FromValues ))
           FROM
               HT1016
           WHERE
               ProductID = @ProductID AND DivisionID = @DivisionID AND ToValues = -1 AND FromValues < @Quantity ) , 0)

   END
ELSE
   BEGIN

         IF @MethodID = 1
            BEGIN
                  SET @UnitPrice = isnull(
                  ( SELECT
                        Amount
                    FROM
                        HT1016
                    WHERE
                        ProductID = @ProductID AND DivisionID = @DivisionID AND FromValues <= @Quantity AND ( ToValues > @Quantity OR ToValues = -1 ) ) , 0)
                  SET @SalaryAmount = @UnitPrice * @Quantity

            END
   END

IF @MethodID = 2
   BEGIN
         SET @SalaryAmount = @Quantity * isnull(
         ( SELECT
               isnull(UnitPrice , 0)
           FROM
               HT1015
           WHERE
               ProductID = @ProductID AND DivisionID = @DivisionID ) , 0)
   END


IF NOT EXISTS ( SELECT
                    1
                FROM
                    HT3402
                WHERE
                    TransactionID = @TransactionID AND ProductID = @ProductID AND DivisionID = @DivisionID )
   BEGIN
         INSERT
             HT3402
             (
               TransactionID ,
               ProductID ,
               EmployeeID ,
               ProductQuantity ,
               ProductSalary )
         VALUES
             (
               @TransactionID ,
               @ProductID ,
               @EmployeeID ,
               @Quantity ,
               @SalaryAmount )
   END