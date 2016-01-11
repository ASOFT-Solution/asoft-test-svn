
/****** Object:  StoredProcedure [dbo].[HP6001]    Script Date: 08/05/2010 10:05:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----- Created by Vo Thanh Huong
---- Created Date 02/06/2004
---- Purpose: Tinh luong cho tung nhan vien mot (Luong san pham)
/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP6001]
       @DivisionID AS nvarchar(50) ,
       @TranMonth int ,
       @TranYear int ,
       @TransactionID AS nvarchar(50) ,
       @DepartmentID AS nvarchar(50) ,
       @TeamID AS nvarchar(50) ,
       @EmployeeID AS nvarchar(50) ,
       @PayrollMethodID AS nvarchar(50)
AS
DECLARE
        @ProductID AS nvarchar(50) ,
        @Quantity AS decimal(28,8) ,
        @cur cursor

SET @cur = CURSOR SCROLL KEYSET FOR SELECT
                                        ProductID ,
                                        Quantity
                                    FROM
                                        HT2403
                                    WHERE
                                        DivisionID = @DivisionID AND DepartmentID = @DepartmentID AND Isnull(TeamID , '') = Isnull(TeamID , '') AND TranMonth = @TranMonth AND TranYear = @TranYear AND EmployeeID = @EmployeeID AND TimesID IN ( SELECT
                                                                                                                                                                                                                                                      TimesID
                                                                                                                                                                                                                                                  FROM
                                                                                                                                                                                                                                                      HT5012
                                                                                                                                                                                                                                                  WHERE
                                                                                                                                                                                                                                                      PayrollMethodID = @PayrollMethodID AND DivisionID = @DivisionID )
OPEN @cur
FETCH next FROM @cur INTO @ProductID,@Quantity
WHILE @@Fetch_Status = 0
      BEGIN
            EXEC HP6002 @DivisionID , @TranMonth , @TranYear , @TransactionID , @DepartmentID , @TeamID , @EmployeeID , @ProductID , @Quantity

            FETCH next FROM @cur INTO @ProductID,@Quantity
      END
CLOSE @cur
DEALLOCATE @cur



