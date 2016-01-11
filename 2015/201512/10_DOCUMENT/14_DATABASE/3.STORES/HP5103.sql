/****** Object:  StoredProcedure [dbo].[HP5103]    Script Date: 08/05/2010 10:02:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


----- 	Created by Dang Le Bao Quynh, Date 09/06/2004
----  	Purpose: Tinh luong theo PP luong Tong hop (Luong cong nhat
----	Cong thuc: L = LuongTH * HeSo*NgayCong/SoNgayQuyDinh

----	Edit by: Dang Le Bao Quynh; Date: 25/01/2007
----	Purpose: Tu thiet lap theo cong thuc tinh cua nguoi dung
----	Modify on 01/08/2013 by Bao Anh: Bo sung them 10 khoan thu nhap 21 -> 30 (Hung Vuong)
/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP5103]
       @DivisionID AS nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int ,
       @PayrollMethodID nvarchar(50) ,
       @MethodID AS nvarchar(50) ,
       @AbsentAmount AS decimal(28,8) ,
       @Orders AS tinyint ,
       @IsIncome AS tinyint ,
       @DepartmentID1 AS nvarchar(50) ,
       @TeamID1 AS nvarchar(50) ,
       @ExchangeRate decimal(28,8) ,
       @IncomeID AS nvarchar(50)
AS
DECLARE
        @Emp_cur AS cursor ,
        @DepartmentID AS nvarchar(50) ,
        @TeamID AS nvarchar(50) ,
        @EmployeeID AS nvarchar(50) ,
        @CoValues AS decimal(28,8) ,
        @AbsentValues AS decimal(28,8) ,
        @SalaryAmount AS decimal(28,8) ,
        @BaseSalary AS decimal(28,8) ,
        @TransactionID AS nvarchar(50) ,
        @IsOtherDayPerMonth AS tinyint ,
        @OtherDayPerMonth AS decimal(28,8) ,
        @IsCondition bit ,
        @ConditionCode nvarchar(4000)



SELECT
    @OtherDayPerMonth = IsNull(OtherDayPerMonth , 0)
FROM
    HT0000
WHERE
    DivisionID = @DivisionID

SET @Emp_cur = CURSOR SCROLL KEYSET FOR SELECT
                                            HT34.TransactionID ,
                                            HT34.EmployeeID ,
                                            HT34.DepartmentID ,
                                            HT34.TeamID ,
                                            HV54.GeneralCo ,
                                            HV54.AbsentAmount ,
                                            HV54.BaseSalary ,
                                            HT34.IsOtherDayPerMonth
                                        FROM
                                            HT3400 HT34 LEFT JOIN HT3444 HV54
                                        ON  HT34.EmployeeID = HV54.EmployeeID AND HT34.DivisionID = HV54.DivisionID AND HT34.DepartmentID = HV54.DepartmentID AND isnull(HT34.TeamID , '') = isnull(HV54.TeamID , '') AND HT34.TranMonth = HV54.TranMonth AND HT34.TranYear = HV54.TranYear
                                        WHERE
                                            HT34.PayrollMethodID = @PayrollMethodID AND HT34.TranMonth = @TranMonth AND HT34.TranYear = @TranYear AND HT34.DivisionID = @DivisionID AND HT34.DepartmentID LIKE @DepartmentID1 AND ISNull(HT34.TeamID , '') LIKE ISNULL(@TeamID1 , '') AND HT34.DepartmentID IN ( SELECT
                                                                                                                                                                                                                                                                                                                     DepartmentID
                                                                                                                                                                                                                                                                                                                 FROM
                                                                                                                                                                                                                                                                                                                     HT5004
                                                                                                                                                                                                                                                                                                                 WHERE
                                                                                                                                                                                                                                                                                                                     PayrollMethodID = @PayrollMethodID AND DivisionID = @DivisionID )


OPEN @Emp_cur
FETCH NEXT FROM @Emp_cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID,@CoValues,@AbsentValues,@BaseSalary,@IsOtherDayPerMonth
WHILE @@FETCH_STATUS = 0
      BEGIN
            SET @SalaryAmount = 0
		---Thiet lap lai bien @BaseSalary tai day 
		
	--	PRINT @PayrollMethodID 
 --PRINT @TranMonth 
 --PRINT @TranYear 
 --PRINT @EmployeeID 
 --PRINT @IncomeID 
 --PRINT @IsIncome 
 --PRINT @DivisionID 
 --PRINT @DepartmentID 
 --PRINT @TeamID 
 --PRINT @TransactionID 
 --PRINT @BaseSalary

	
            EXEC HP5104 @PayrollMethodID , @TranMonth , @TranYear , @EmployeeID , @IncomeID , @IsIncome , @DivisionID , @DepartmentID , @TeamID , @TransactionID , @BaseSalary OUTPUT

            IF @IsIncome = 1
               BEGIN
                     SELECT
                         @IsCondition = IsCondition ,
                         @ConditionCode = ConditionCode
                     FROM
                         HT5005
                     WHERE
                         PayrollMethodID = @PayrollMethodID AND CAST(RIGHT(IncomeID , 2) AS int) = @Orders
                     IF @IsCondition = 0
                        BEGIN
                              SET @SalaryAmount = CASE
                                                       WHEN isnull(@AbsentAmount , 0) = 0 THEN 0
                                                       ELSE isnull(@BaseSalary , 0) * isnull(@CoValues , 1) * isnull(@AbsentValues , 0) * isnull(@ExchangeRate , 1) / @AbsentAmount
                                                  END
                        END
                     ELSE
                        BEGIN
                              IF @ConditionCode IS NULL OR @ConditionCode = ''
                                 BEGIN
                                       SET @SalaryAmount = 0
                                 END
                              ELSE
                                 BEGIN
                                       EXEC HP5555 @AbsentValues , @CoValues , @BaseSalary , @ConditionCode , @SalaryAmount OUTPUT
                                 END
                        END
               END
            ELSE
               BEGIN
                     SELECT
                         @IsCondition = IsCondition ,
                         @ConditionCode = ConditionCode
                     FROM
                         HT5006
                     WHERE
                         PayrollMethodID = @PayrollMethodID AND CAST(RIGHT(SubID , 2) AS int) = @Orders
                     IF @IsCondition = 0
                        BEGIN
                              SET @SalaryAmount = CASE
                                                       WHEN isnull(@AbsentAmount , 0) = 0 THEN 0
                                                       ELSE isnull(@BaseSalary , 0) * isnull(@CoValues , 1) * isnull(@AbsentValues , 0) * isnull(@ExchangeRate , 1) / @AbsentAmount
                                                  END
                        END
                     ELSE
                        BEGIN
                              IF @ConditionCode IS NULL OR @ConditionCode = ''
                                 BEGIN
                                       SET @SalaryAmount = 0
                                 END
                              ELSE
                                 BEGIN
                                       EXEC HP5555 @AbsentValues , @CoValues , @BaseSalary , @ConditionCode , @SalaryAmount OUTPUT
                                 END
                        END
               END

			--Rem by Dang Le Bao Quynh
			--Purpose: Khong hieu muc dich cua viec kiem tra so ngay quy dinh @AbsentAmount > 20 and @AbsentAmount <32 ???????????
			--Set @SalaryAmount = case when isnull(@AbsentAmount, 0) = 0 then 0 else isnull(@BaseSalary,0)*isnull( @CoValues,1)*isnull(@AbsentValues,0)* isnull(@ExchangeRate,1)/ case  When  @AbsentAmount > 20 and @AbsentAmount <32 Then   Case When IsNull(@IsOtherDayPerMonth,0) =0 Then  @AbsentAmount    Else  @OtherDayPerMonth  End    Else  @AbsentAmount  End     End


            UPDATE
                HT3400
            SET
                Income01 = ( CASE
                                  WHEN @Orders = 01 THEN @SalaryAmount
                                  ELSE Income01
                             END ) ,
                Income02 = ( CASE
                                  WHEN @Orders = 02 THEN @SalaryAmount
                                  ELSE Income02
                             END ) ,
                Income03 = ( CASE
                                  WHEN @Orders = 03 THEN @SalaryAmount
                                  ELSE Income03
                             END ) ,
                Income04 = ( CASE
                                  WHEN @Orders = 04 THEN @SalaryAmount
                                  ELSE Income04
                             END ) ,
                Income05 = ( CASE
                                  WHEN @Orders = 05 THEN @SalaryAmount
                                  ELSE Income05
                             END ) ,
                Income06 = ( CASE
                                  WHEN @Orders = 06 THEN @SalaryAmount
                                  ELSE Income06
                             END ) ,
                Income07 = ( CASE
                                  WHEN @Orders = 07 THEN @SalaryAmount
                                  ELSE Income07
                             END ) ,
                Income08 = ( CASE
                                  WHEN @Orders = 08 THEN @SalaryAmount
                                  ELSE Income08
                             END ) ,
                Income09 = ( CASE
                                  WHEN @Orders = 09 THEN @SalaryAmount
                                  ELSE Income09
                             END ) ,
                Income10 = ( CASE
                                  WHEN @Orders = 10 THEN @SalaryAmount
                                  ELSE Income10
                             END ) ,
                Income11 = ( CASE
                                  WHEN @Orders = 11 THEN @SalaryAmount
                                  ELSE Income11
                             END ) ,
                Income12 = ( CASE
                                  WHEN @Orders = 12 THEN @SalaryAmount
                                  ELSE Income12
                             END ) ,
                Income13 = ( CASE
                                  WHEN @Orders = 13 THEN @SalaryAmount
                                  ELSE Income13
                             END ) ,
                Income14 = ( CASE
                                  WHEN @Orders = 14 THEN @SalaryAmount
                                  ELSE Income14
                             END ) ,
                Income15 = ( CASE
                                  WHEN @Orders = 15 THEN @SalaryAmount
                                  ELSE Income15
                             END ) ,
                Income16 = ( CASE
                                  WHEN @Orders = 16 THEN @SalaryAmount
                                  ELSE Income16
                             END ) ,
                Income17 = ( CASE
                                  WHEN @Orders = 17 THEN @SalaryAmount
                                  ELSE Income17
                             END ) ,
                Income18 = ( CASE
                                  WHEN @Orders = 18 THEN @SalaryAmount
                                  ELSE Income18
                             END ) ,
                Income19 = ( CASE
                                  WHEN @Orders = 19 THEN @SalaryAmount
                                  ELSE Income19
                             END ) ,
                Income20 = ( CASE
                                  WHEN @Orders = 20 THEN @SalaryAmount
                                  ELSE Income20
                             END ) ,
                Income21 = ( CASE
                                  WHEN @Orders = 21 THEN @SalaryAmount
                                  ELSE Income21
                             END ) ,
                Income22 = ( CASE
                                  WHEN @Orders = 22 THEN @SalaryAmount
                                  ELSE Income22
                             END ) ,             
                Income23 = ( CASE
                                  WHEN @Orders = 23 THEN @SalaryAmount
                                  ELSE Income23
                             END ) ,
                Income24 = ( CASE
                                  WHEN @Orders = 24 THEN @SalaryAmount
                                  ELSE Income24
                             END ) ,
                Income25 = ( CASE
                                  WHEN @Orders = 25 THEN @SalaryAmount
                                  ELSE Income25
                             END ) ,
                Income26 = ( CASE
                                  WHEN @Orders = 26 THEN @SalaryAmount
                                  ELSE Income26
                             END ) ,
                Income27 = ( CASE
                                  WHEN @Orders = 27 THEN @SalaryAmount
                                  ELSE Income27
                             END ) ,
                Income28 = ( CASE
                                  WHEN @Orders = 28 THEN @SalaryAmount
                                  ELSE Income28
                             END ) ,
                Income29 = ( CASE
                                  WHEN @Orders = 29 THEN @SalaryAmount
                                  ELSE Income29
                             END ) ,
                Income30 = ( CASE
                                  WHEN @Orders = 30 THEN @SalaryAmount
                                  ELSE Income30
                             END ) ,
                IGAbsentAmount01 = ( CASE
                                          WHEN @Orders = 01 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount01
                                     END ) ,
                IGAbsentAmount02 = ( CASE
                                          WHEN @Orders = 02 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount02
                                     END ) ,
                IGAbsentAmount03 = ( CASE
                                          WHEN @Orders = 03 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount03
                                     END ) ,
                IGAbsentAmount04 = ( CASE
                                          WHEN @Orders = 04 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount04
                                     END ) ,
                IGAbsentAmount05 = ( CASE
                                          WHEN @Orders = 05 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount05
                                     END ) ,
                IGAbsentAmount06 = ( CASE
                                          WHEN @Orders = 06 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount06
                                     END ) ,
                IGAbsentAmount07 = ( CASE
                                          WHEN @Orders = 07 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount07
                                     END ) ,
                IGAbsentAmount08 = ( CASE
                                          WHEN @Orders = 08 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount08
                                     END ) ,
                IGAbsentAmount09 = ( CASE
                                          WHEN @Orders = 09 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount09
                                     END ) ,
                IGAbsentAmount10 = ( CASE
                                          WHEN @Orders = 10 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount10
                                     END ) ,
                IGAbsentAmount11 = ( CASE
                                          WHEN @Orders = 11 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount11
                                     END ) ,
                IGAbsentAmount12 = ( CASE
                                          WHEN @Orders = 12 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount12
                                     END ) ,
                IGAbsentAmount13 = ( CASE
                                          WHEN @Orders = 13 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount13
                                     END ) ,
                IGAbsentAmount14 = ( CASE
                                          WHEN @Orders = 14 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount14
                                     END ) ,
                IGAbsentAmount15 = ( CASE
                                          WHEN @Orders = 15 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount15
                                     END ) ,
                IGAbsentAmount16 = ( CASE
                                          WHEN @Orders = 16 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount16
                                     END ) ,
                IGAbsentAmount17 = ( CASE
                                          WHEN @Orders = 17 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount17
                                     END ) ,
                IGAbsentAmount18 = ( CASE
                                          WHEN @Orders = 18 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount18
                                     END ) ,
                IGAbsentAmount19 = ( CASE
                                          WHEN @Orders = 19 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount19
                                     END ) ,
                IGAbsentAmount20 = ( CASE
                                          WHEN @Orders = 20 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount20
                                     END )
            WHERE
                DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID AND @IsIncome = 1

            UPDATE
                HT3400
            SET
                SubAmount01 = ( CASE
                                     WHEN @Orders = 01 THEN @SalaryAmount
                                     ELSE SubAmount01
                                END ) ,
                SubAmount02 = ( CASE
                                     WHEN @Orders = 02 THEN @SalaryAmount
                                     ELSE SubAmount02
                                END ) ,
                SubAmount03 = ( CASE
                                     WHEN @Orders = 03 THEN @SalaryAmount
                                     ELSE SubAmount03
                                END ) ,
                SubAmount04 = ( CASE
                                     WHEN @Orders = 04 THEN @SalaryAmount
                                     ELSE SubAmount04
                                END ) ,
                SubAmount05 = ( CASE
                                     WHEN @Orders = 05 THEN @SalaryAmount
                                     ELSE SubAmount05
                                END ) ,
                SubAmount06 = ( CASE
                                     WHEN @Orders = 06 THEN @SalaryAmount
                                     ELSE SubAmount06
                                END ) ,
                SubAmount07 = ( CASE
                                     WHEN @Orders = 07 THEN @SalaryAmount
                                     ELSE SubAmount07
                                END ) ,
                SubAmount08 = ( CASE
                                     WHEN @Orders = 08 THEN @SalaryAmount
                                     ELSE SubAmount08
                                END ) ,
                SubAmount09 = ( CASE
                                     WHEN @Orders = 09 THEN @SalaryAmount
                                     ELSE SubAmount09
                                END ) ,
                SubAmount10 = ( CASE
                                     WHEN @Orders = 10 THEN @SalaryAmount
                                     ELSE SubAmount10
                                END ) ,
                SubAmount11 = ( CASE
                                     WHEN @Orders = 11 THEN @SalaryAmount
                                     ELSE SubAmount11
                                END ) ,
                SubAmount12 = ( CASE
                                     WHEN @Orders = 12 THEN @SalaryAmount
                                     ELSE SubAmount12
                                END ) ,
                SubAmount13 = ( CASE
                                     WHEN @Orders = 13 THEN @SalaryAmount
                                     ELSE SubAmount13
                                END ) ,
                SubAmount14 = ( CASE
                                     WHEN @Orders = 14 THEN @SalaryAmount
                                     ELSE SubAmount14
                                END ) ,
                SubAmount15 = ( CASE
                                     WHEN @Orders = 15 THEN @SalaryAmount
                                     ELSE SubAmount15
                                END ) ,
                SubAmount16 = ( CASE
                                     WHEN @Orders = 16 THEN @SalaryAmount
                                     ELSE SubAmount16
                                END ) ,
                SubAmount17 = ( CASE
                                     WHEN @Orders = 17 THEN @SalaryAmount
                                     ELSE SubAmount17
                                END ) ,
                SubAmount18 = ( CASE
                                     WHEN @Orders = 18 THEN @SalaryAmount
                                     ELSE SubAmount18
                                END ) ,
                SubAmount19 = ( CASE
                                     WHEN @Orders = 19 THEN @SalaryAmount
                                     ELSE SubAmount19
                                END ) ,
                SubAmount20 = ( CASE
                                     WHEN @Orders = 20 THEN @SalaryAmount
                                     ELSE SubAmount20
                                END ) ,
                IGAbsentAmount21 = ( CASE
                                          WHEN @Orders = 21 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount21
                                     END ) ,
                IGAbsentAmount22 = ( CASE
                                          WHEN @Orders = 22 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount22
                                     END ) ,
                IGAbsentAmount23 = ( CASE
                                          WHEN @Orders = 23 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount23
                                     END ) ,
                IGAbsentAmount24 = ( CASE
                                          WHEN @Orders = 24 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount24
                                     END ) ,
                IGAbsentAmount25 = ( CASE
                                          WHEN @Orders = 25 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount25
                                     END ) ,
                IGAbsentAmount26 = ( CASE
                                          WHEN @Orders = 26 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount26
                                     END ) ,
                IGAbsentAmount27 = ( CASE
                                          WHEN @Orders = 27 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount27
                                     END ) ,
                IGAbsentAmount28 = ( CASE
                                          WHEN @Orders = 28 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount28
                                     END ) ,
                IGAbsentAmount29 = ( CASE
                                          WHEN @Orders = 02 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount29
                                     END ) ,
                IGAbsentAmount30 = ( CASE
                                          WHEN @Orders = 30 THEN isnull(@AbsentValues , 0)
                                          ELSE IGAbsentAmount30
                                     END )
            WHERE
                DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID AND @IsIncome = 0
            FETCH NEXT FROM @Emp_cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID,@CoValues,@AbsentValues,@BaseSalary,@IsOtherDayPerMonth
      END

CLOSE @Emp_cur