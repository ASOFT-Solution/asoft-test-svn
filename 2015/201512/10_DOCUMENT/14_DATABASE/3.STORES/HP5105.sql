IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5105]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5105]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- 	Created by Dang Le Bao Quynh, Date 09/06/2004
----  	Purpose: Tinh luong theo PP luong SP phan bo 
----	Cong thuc: L = HeSo*NgayCong*?Luong mot nhom/?HeSo*NgayCong
/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/

----- 	Edited by Dang Le Bao Quynh, Date 12/11/2012
-----  	Purpose: Tinh luong theo PP luong SP phan bo theo 2 ky
----- Modified on 06/09/2013 by Le Thi Thu Hien : Cham cong theo ca (Neu co du lieu cham cong ca thi cham cong ca nguoc lai cham cong ngay VietRoll

CREATE PROCEDURE [dbo].[HP5105]
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
        @ProductSalary AS decimal(28,8),
        @TimesID as nvarchar(50)

--Xac dinh ky tinh luong thong qua thong so ky tinh luong trong ngay cong tong hop cua pp tinh luong.
Select @TimesID=PeriodID From ht5002 Where GeneralAbsentID In
(Select GeneralAbsentID from HT5005 Where PayrollMethodID = @PayrollMethodID And IncomeID = @IncomeID)
If Isnull(@TimesID,'')=''
Begin
	Set @TimesID = '%'
End

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
                                                                                                                                                                                                                                                                                                                     PayrollMethodID = @PayrollMethodID And DivisionID = @DivisionID )


OPEN @Emp_cur
FETCH NEXT FROM @Emp_cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID,@CoValues,@AbsentValues,@BaseSalary,@IsOtherDayPerMonth
WHILE @@FETCH_STATUS = 0
      BEGIN
            SET @SalaryAmount = 0
		---Thiet lap lai bien @BaseSalary tai day 
		--EXEC HP5104 @PayrollMethodID,@TranMonth,@TranYear,@EmployeeID,@IncomeID,@IsIncome,@DivisionID,@DepartmentID,@TeamID,@TransactionID,@BaseSalary OUTPUT
            IF @DepartmentID IS NOT NULL AND @TeamID IS NOT NULL
               BEGIN
               	---------HT0289 Cham san pham phan bo theo ca
               	IF NOT EXISTS (SELECT TOP 1 1 FROM HT0289 WHERE DivisionID = @DivisionID 
               													AND TranMonth = @TranMonth 
               													AND TranYear = @TranYear)
				BEGIN 
                     SET @ProductSalary = ( SELECT	SUM(HT2413.quantity * HT1015.unitprice) AS ProductSalary
                                            FROM    HT2413 
                                            INNER JOIN HT1015
													ON  HT2413.ProductID = HT1015.ProductID 
														AND HT2413.DivisionID = HT1015.DivisionID
                                            WHERE	HT2413.DivisionID = @DivisionID 
													AND TranMonth = @TranMonth 
													AND TranYear = @TranYear 
													AND DepartmentID = @DepartmentID 
													AND TeamID = @TeamID 
													AND TimesID like @TimesID)
				END
				ELSE
				BEGIN
					SET @ProductSalary = (	SELECT	SUM(HT0289.quantity * HT1015.unitprice) AS ProductSalary
                                            FROM    HT0289 
                                            INNER JOIN HT1015
													ON  HT0289.ProductID = HT1015.ProductID 
														AND HT0289.DivisionID = HT1015.DivisionID
					                      	WHERE	HT0289.DivisionID = @DivisionID 
													AND TranMonth = @TranMonth 
													AND TranYear = @TranYear 
													AND DepartmentID = @DepartmentID 
													AND TeamID = @TeamID 
													AND TimesID like @TimesID)
				END
			   If @ProductSalary IS NOT NULL
                     INSERT INTO
                         HT3404
                         (
                           TransactionID ,
                           PayrollMethodID ,
                           TranMonth ,
                           TranYear ,
                           DivisionID ,
                           DepartmentID ,
                           TeamID ,
                           IncomeID ,
                           EmployeeID ,
                           GeneralCo ,
                           GeneralAbsentAmount ,
                           ProductSalary )
                     VALUES
                         (
                           @TransactionID ,
                           @PayrollMethodID ,
                           @TranMonth ,
                           @TranYear ,
                           @DivisionID ,
                           @DepartmentID ,
                           @TeamID ,
                           @IncomeID ,
                           @EmployeeID ,
                           @CoValues ,
                           @AbsentValues ,
                           @ProductSalary )
               END
		/*Set @SalaryAmount = case when isnull(@AbsentAmount, 0) = 0 then 0 else isnull(@BaseSalary,0)*isnull( @CoValues,1)*isnull(@AbsentValues,0)* isnull(@ExchangeRate,1)/ case  When  @AbsentAmount > 20 and @AbsentAmount <32 Then   Case When IsNull(@IsOtherDayPerMonth,0) =0 Then  @AbsentAmount    Else  @OtherDayPerMonth  End    Else  @AbsentAmount  End     end	
			Update  HT3400
				Set 	Income01 = (Case When @Orders =01 then @SalaryAmount Else Income01 end),
					Income02 = (Case When @Orders =02 then @SalaryAmount Else Income02 end),
					Income03 = (Case When @Orders =03 then @SalaryAmount Else Income03 end),
					Income04 = (Case When @Orders =04 then @SalaryAmount Else Income04 end),
					Income05 = (Case When @Orders =05 then @SalaryAmount Else Income05 end),
					Income06 = (Case When @Orders =06 then @SalaryAmount Else Income06 end),
					Income07 = (Case When @Orders =07 then @SalaryAmount Else Income07 end),
					Income08 = (Case When @Orders =08 then @SalaryAmount Else Income08 end),
					Income09= (Case When @Orders =09 then @SalaryAmount Else Income09 end),
					Income10 = (Case When @Orders =10 then @SalaryAmount Else Income10 end),
					Income11 = (Case When @Orders =11 then @SalaryAmount Else Income11 end),
					Income12 = (Case When @Orders =12 then @SalaryAmount Else Income12 end),
					Income13 = (Case When @Orders =13 then @SalaryAmount Else Income13 end),
					Income14 = (Case When @Orders =14 then @SalaryAmount Else Income14 end),
					Income15 = (Case When @Orders =15 then @SalaryAmount Else Income15 end),
					Income16 = (Case When @Orders =16 then @SalaryAmount Else Income16 end),
					Income17 = (Case When @Orders =17 then @SalaryAmount Else Income17 end), 					Income18 = (Case When @Orders =18 then @SalaryAmount Else Income18 end),
					Income19= (Case When @Orders =19 then @SalaryAmount Else Income19 end),
					Income20 = (Case When @Orders =20 then @SalaryAmount Else Income20 end),
					IGAbsentAmount01 = (Case When @Orders = 01 then isnull(@AbsentValues,0) Else IGAbsentAmount01 end),
					IGAbsentAmount02 = (Case When @Orders = 02 then isnull(@AbsentValues,0) Else IGAbsentAmount02 end),
					IGAbsentAmount03 = (Case When @Orders = 03 then isnull(@AbsentValues,0) Else IGAbsentAmount03 end),
					IGAbsentAmount04 = (Case When @Orders =04 then isnull(@AbsentValues,0) Else IGAbsentAmount04 end),
					IGAbsentAmount05 = (Case When @Orders = 05 then isnull(@AbsentValues,0) Else IGAbsentAmount05 end),
					IGAbsentAmount06 = (Case When @Orders = 06 then isnull(@AbsentValues,0) Else IGAbsentAmount06 end),
					IGAbsentAmount07 = (Case When @Orders = 07 then isnull(@AbsentValues,0) Else IGAbsentAmount07 end),
					IGAbsentAmount08 = (Case When @Orders = 08 then isnull(@AbsentValues,0) Else IGAbsentAmount08 end),
					IGAbsentAmount09 = (Case When @Orders = 09 then isnull(@AbsentValues,0) Else IGAbsentAmount09 end),
					IGAbsentAmount10 = (Case When @Orders = 10 then isnull(@AbsentValues,0) Else IGAbsentAmount10 end),
					IGAbsentAmount11 = (Case When @Orders = 11 then isnull(@AbsentValues,0) Else IGAbsentAmount11 end),
					IGAbsentAmount12 = (Case When @Orders = 12 then isnull(@AbsentValues,0) Else IGAbsentAmount12 end),
					IGAbsentAmount13 = (Case When @Orders = 13 then isnull(@AbsentValues,0) Else IGAbsentAmount13 end),
					IGAbsentAmount14 = (Case When @Orders =14 then isnull(@AbsentValues,0) Else IGAbsentAmount14 end),
					IGAbsentAmount15 = (Case When @Orders = 15 then isnull(@AbsentValues,0) Else IGAbsentAmount15 end),
					IGAbsentAmount16 = (Case When @Orders = 16 then isnull(@AbsentValues,0) Else IGAbsentAmount16 end),
					IGAbsentAmount17 = (Case When @Orders = 17 then isnull(@AbsentValues,0) Else IGAbsentAmount17 end),
					IGAbsentAmount18 = (Case When @Orders = 18 then isnull(@AbsentValues,0) Else IGAbsentAmount18 end),
					IGAbsentAmount19 = (Case When @Orders = 19 then isnull(@AbsentValues,0) Else IGAbsentAmount19 end),
					IGAbsentAmount20 = (Case When @Orders = 20 then isnull(@AbsentValues,0) Else IGAbsentAmount20 end)
			Where 	DivisionID =@DivisionID and
				PayrollMethodID = @PayrollMethodID and
				TransactionID =@TransactionID and
				@IsIncome = 1
			
		Update  HT3400
				Set 	SubAmount01 = (Case When @Orders = 01 then @SalaryAmount Else SubAmount01 end),
					SubAmount02 = (Case When @Orders = 02 then @SalaryAmount Else SubAmount02 end),
					SubAmount03 = (Case When @Orders = 03 then @SalaryAmount Else SubAmount03 end),
					SubAmount04= (Case When @Orders = 04 then @SalaryAmount Else SubAmount04 end),
					SubAmount05 = (Case When @Orders = 05 then @SalaryAmount Else SubAmount05 end),
					SubAmount06 = (Case When @Orders = 06 then @SalaryAmount Else SubAmount06 end),
					SubAmount07 = (Case When @Orders = 07 then @SalaryAmount Else SubAmount07 end),
					SubAmount08 = (Case When @Orders = 08 then @SalaryAmount Else SubAmount08 end),
					SubAmount09= (Case When @Orders = 09 then @SalaryAmount Else SubAmount09 end),
					SubAmount10 = (Case When @Orders = 10 then @SalaryAmount Else SubAmount10 end), 	
					SubAmount11 = (Case When @Orders = 11 then @SalaryAmount Else SubAmount11 end),
					SubAmount12 = (Case When @Orders = 12 then @SalaryAmount Else SubAmount12 end),
					SubAmount13 = (Case When @Orders = 13 then @SalaryAmount Else SubAmount13 end),
					SubAmount14= (Case When @Orders = 14 then @SalaryAmount Else SubAmount14 end),
					SubAmount15 = (Case When @Orders = 15 then @SalaryAmount Else SubAmount15 end),
					SubAmount16 = (Case When @Orders = 16 then @SalaryAmount Else SubAmount16 end),
					SubAmount17 = (Case When @Orders = 17 then @SalaryAmount Else SubAmount17 end),
					SubAmount18 = (Case When @Orders = 18 then @SalaryAmount Else SubAmount18 end),
					SubAmount19= (Case When @Orders = 19 then @SalaryAmount Else SubAmount19 end), 					SubAmount20 = (Case When @Orders = 20 then @SalaryAmount Else SubAmount20 end),
					IGAbsentAmount21 = (Case When @Orders = 21 then isnull(@AbsentValues,0) Else IGAbsentAmount21 end),
					IGAbsentAmount22 = (Case When @Orders = 22 then isnull(@AbsentValues,0) Else IGAbsentAmount22 end),
					IGAbsentAmount23 = (Case When @Orders = 23 then isnull(@AbsentValues,0) Else IGAbsentAmount23 end),
					IGAbsentAmount24 = (Case When @Orders =24 then isnull(@AbsentValues,0) Else IGAbsentAmount24 end),
					IGAbsentAmount25 = (Case When @Orders = 25 then isnull(@AbsentValues,0) Else IGAbsentAmount25 end),
					IGAbsentAmount26 = (Case When @Orders = 26 then isnull(@AbsentValues,0) Else IGAbsentAmount26 end),
					IGAbsentAmount27 = (Case When @Orders = 27 then isnull(@AbsentValues,0) Else IGAbsentAmount27 end),
					IGAbsentAmount28 = (Case When @Orders = 28 then isnull(@AbsentValues,0) Else IGAbsentAmount28 end),
					IGAbsentAmount29 = (Case When @Orders = 02 then isnull(@AbsentValues,0) Else IGAbsentAmount29 end),
					IGAbsentAmount30 = (Case When @Orders = 30 then isnull(@AbsentValues,0) Else IGAbsentAmount30 end)					
			Where 	DivisionID =@DivisionID and
				PayrollMethodID = @PayrollMethodID and
				TransactionID =@TransactionID and
				@IsIncome = 0*/
            FETCH NEXT FROM @Emp_cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID,@CoValues,@AbsentValues,@BaseSalary,@IsOtherDayPerMonth
      END

CLOSE @Emp_cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

