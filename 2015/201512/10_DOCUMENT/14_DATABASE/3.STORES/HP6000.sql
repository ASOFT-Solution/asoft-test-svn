
/****** Object:  StoredProcedure [dbo].[HP6000]    Script Date: 08/05/2010 10:05:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Vo Thanh Huong 
---- Created Date 02/06/2004.
---- Purpose: Tinh luong san pham

/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP6000]
       @DivisionID AS nvarchar(50) ,
       @PayrollMethodID AS nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int ,
       @UserID AS nvarchar(50) ,
       @VoucherDate AS datetime
AS
DECLARE
        @TransactionID AS nvarchar(50) ,
        @HT3401_cur AS cursor ,
        @CYear AS nvarchar(50) ,
        @CMonth AS nvarchar(50) ,
        @DepartmentID AS nvarchar(50) ,
        @TeamID AS nvarchar(50) ,
        @EmployeeID AS nvarchar(50)

--- Buoc 1: 	Xoa Luong cua cac nhan  nhan da tinh truong ky, sau do tinh lai. Delete HT3401
----		ghi chu: Trigger	HX3401 se tu dong xoa du lieu chi tiet luong san pham HT3402

DELETE
        HT3401
WHERE
        PayrollMethodID = @PayrollMethodID AND TranMonth = @TranMonth AND TranYear = @TranYear 

---- Buoc 2: 	Insert nhan vien tinh luong vao bang HT3401

SET NOCOUNT ON
SET @CYear = LTRIM(RTRIM(str(@TranYear)))
SET @CMonth = LTRIM(RTRIM(str(@TranMonth)))
SET @HT3401_cur = CURSOR SCROLL KEYSET FOR SELECT
                                               EmployeeID ,
                                               DepartmentID ,
                                               TeamID
                                           FROM
                                               HT2400
                                           WHERE
                                               DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear AND DepartmentID IN ( SELECT
                                                                                                                                                      DepartmentID
                                                                                                                                                  FROM
                                                                                                                                                      HT5011
                                                                                                                                                  WHERE
                                                                                                                                                      PayrollMethodID = @PayrollMethodID AND DivisionID = @DivisionID )

OPEN @HT3401_cur
FETCH NEXT FROM @HT3401_cur INTO @EmployeeID,@DepartmentID,@TeamID
WHILE @@FETCH_STATUS = 0
      BEGIN
            EXEC AP0000 @DivisionID, @TransactionID OUTPUT , 'HT3401' , 'EP' , @CYear , @CMonth , 15 , 3 , 0 , '-'
            IF NOT EXISTS ( SELECT TOP 1
                                1
                            FROM
                                HT3401
                            WHERE
                                DivisionID = @DivisionID AND DepartmentID = @DepartmentID AND EmployeeID = @EmployeeID AND TranMonth = @TranMonth AND TranYear = @TranYear AND PayrollmethodID = @PayrollmethodID )
               BEGIN
                     INSERT
                         HT3401
                         (
                           TransactionID ,
                           EmployeeID ,
                           DivisionID ,
                           TranMonth ,
                           TranYear ,
                           DepartmentID ,
                           TeamID ,
                           PayrollMethodID ,
                           CreateUserID ,
                           CreateDate ,
                           LastModifyUserID ,
                           LastModifyDate )
                     VALUES
                         (
                           @TransactionID ,
                           @EmployeeID ,
                           @DivisionID ,
                           @TranMonth ,
                           @TranYear ,
                           @DepartmentID ,
                           @TeamID ,
                           @PayrollMethodID ,
                           @UserID ,
                           getdate() ,
                           @UserID ,
                           getdate() )
               END

            FETCH NEXT FROM @HT3401_cur INTO @EmployeeID,@DepartmentID,@TeamID
      END
CLOSE @HT3401_cur


---- Buoc 3: Duyet cac nhan vien o buoc 2 va tinh luong sp

SET @HT3401_cur = CURSOR SCROLL KEYSET FOR SELECT DISTINCT
                                               EmployeeID ,
                                               TransactionID ,
                                               DepartmentID ,
                                               TeamID
                                           FROM
                                               HT3401
                                           WHERE
                                               DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear AND PayrollMethodID = @PayrollMethodID

OPEN @HT3401_cur
FETCH NEXT FROM @HT3401_cur INTO @EmployeeID,@TransactionID,@DepartmentID,@TeamID
WHILE @@FETCH_STATUS = 0
      BEGIN
            EXEC HP6001 @DivisionID , @TranMonth , @TranYear , @TransactionID , @DepartmentID , @TeamID , @EmployeeID , @PayrollMethodID

            UPDATE
                HT3401
            SET
                ProductSalary = ( SELECT
                                      sum(ProductSalary)
                                  FROM
                                      HT3402
                                  WHERE
                                      TransactionID = HT3401.TransactionID )
            WHERE
                DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear AND PayRollMethodID = @PayrollMethodID


            FETCH NEXT FROM @HT3401_cur INTO @EmployeeID,@TransactionID,@DepartmentID,@TeamID
      END
CLOSE @HT3401_cur


SET NOCOUNT OFF
































