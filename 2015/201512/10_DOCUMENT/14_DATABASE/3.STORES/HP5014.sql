IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5014]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5014]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
---- Giống HP5102 Nhưng tính vào cuối cùng sau khi tính các khoản lương khác của khách hàng cảng sài gòn
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 13/11/2013 by Lê Thị Thu Hiền
---- 
---- Modified on 13/11/2013 by 
-- <Example>
---- 

CREATE PROCEDURE [dbo].[HP5014]
       @DivisionID AS nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int ,
       @PayrollMethodID nvarchar(50) ,
       @SalaryTotal AS decimal(28,8) 
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
		@SumCoAbsentAmount AS decimal(28,8) ,
		@UnitPrice AS decimal(28,8) ,
		@SumSalaryAmount AS decimal(28,8) ,
		@Diff AS decimal(28,8),
		@Income01 AS decimal(28,8),
		@Income02 AS decimal(28,8),
		@Income03 AS decimal(28,8),
		@Income04 AS decimal(28,8)

DECLARE @CONGDOAN AS DECIMAL(28,8)

	SET @SumCoAbsentAmount = (	SELECT  Sum(isnull(HV54.GeneralCo , 0) * Isnull(HV54.AbsentAmount , 0))
	                          	FROM	HT3445 HV54
	                          	WHERE	DivisionID = @DivisionID 
	                          			AND TranMonth = @TranMonth 
	                          			AND TranYear = @TranYear 
										AND EmployeeID In (SELECT	EmployeeID 
										                   FROM		HT2400 
										                   Where	HT2400.DivisionID = @DivisionID 
																   AND HT2400.TranMonth = @TranMonth 
																   AND HT2400.TranYear = @TranYear 
																   AND IsJobWage=1))

--PRINT(@SumCoAbsentAmount)
--PRINT(@SalaryTotal)
SET @Income01 = (SELECT SUM(ISNULL(Income01,0)) FROM HT3400 WHERE EmployeeID IN (SELECT EmployeeID FROM HT2400 WHERE HT2400.IsJobWage = 1))
SET @Income02 = (SELECT SUM(ISNULL(Income02,0)) FROM HT3400 WHERE EmployeeID IN (SELECT EmployeeID FROM HT2400 WHERE HT2400.IsJobWage = 1))
SET @Income03 = (SELECT SUM(ISNULL(Income03,0)) FROM HT3400 WHERE EmployeeID IN (SELECT EmployeeID FROM HT2400 WHERE HT2400.IsJobWage = 1))
--PRINT(@SalaryTotal - @Income01 - @Income02 - @Income03 )

IF @SumCoAbsentAmount <> 0
   BEGIN
         SET @UnitPrice = (@SalaryTotal - @Income01 - @Income02 - @Income03 )/ @SumCoAbsentAmount
         PRINT(@UnitPrice)
   END
ELSE
   BEGIN
         SET @UnitPrice = 0
   END

	SET @Emp_cur = CURSOR SCROLL KEYSET FOR 
					SELECT	HT34.TransactionID ,
							HT34.EmployeeID ,
							HT34.DepartmentID ,
							HT34.TeamID ,
							HV54.GeneralCo ,
							HV54.AbsentAmount ,
							HV54.BaseSalary
					FROM	HT3400 HT34 
					LEFT JOIN HT3445 HV54
						ON  HT34.EmployeeID = HV54.EmployeeID 
							AND HT34.DivisionID = HV54.DivisionID 
							AND HT34.DepartmentID = HV54.DepartmentID 
							AND isnull(HT34.TeamID , '') = isnull(HV54.TeamID , '') 
							AND HT34.TranMonth = HV54.TranMonth 
							AND HT34.TranYear = HV54.TranYear
					WHERE
						HT34.PayrollMethodID = @PayrollMethodID 
						AND HT34.TranMonth = @TranMonth 
						AND HT34.TranYear = @TranYear 
						AND HT34.DivisionID = @DivisionID 
						AND HT34.DepartmentID IN (	SELECT	DepartmentID
						                          	FROM	HT5004
						                          	WHERE	PayrollMethodID = @PayrollMethodID 
						                          	And DivisionID = @DivisionID )
						AND HT34.EmployeeID In (SELECT	EmployeeID 
						                        FROM	HT2400 
						                        Where	HT2400.DivisionID = @DivisionID 
														AND HT2400.TranMonth = @TranMonth 
														AND HT2400.TranYear = @TranYear 
														AND IsJobWage=1)							 

OPEN @Emp_cur
FETCH NEXT FROM @Emp_cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID,@CoValues,@AbsentValues,@BaseSalary
WHILE @@FETCH_STATUS = 0
      BEGIN
            SET @SalaryAmount = 0
            SET @SalaryAmount = @UnitPrice * isnull(@CoValues , 0) * isnull(@AbsentValues , 0)  
		--Print ' @BaseSalary '+str(@BaseSalary)+ ' 	@SalaryAmount: '+str(@SalaryAmount)+' Orders: '+str(@Orders)--+' @AbsentAmount: '+str(@AbsentAmount)

            UPDATE    HT3400
            SET      Income04 = @SalaryAmount
            WHERE
                DivisionID = @DivisionID 
                AND PayrollMethodID = @PayrollMethodID 
                AND TranMonth = @TranMonth 
                AND TranYear = @TranYear 
                AND TransactionID = @TransactionID 
            ----------- Tính kinh phí công đoàn
            SET @CONGDOAN = (SELECT SUM((ISNULL(Income01,0)+ ISNULL(Income02,0)+ ISNULL(Income03,0)+ ISNULL(Income04,0)+ ISNULL(Income05,0)+
						ISNULL(Income06,0)+ ISNULL(Income07,0)+ ISNULL(Income08,0)+ 
						ISNULL(Income11,0)+ ISNULL(Income12,0)+ ISNULL(Income13,0)+ ISNULL(Income14,0)+ ISNULL(Income15,0)+
						ISNULL(Income16,0)+ ISNULL(Income17,0)+ ISNULL(Income18,0)+ ISNULL(Income19,0)+ ISNULL(Income20,0)+
						ISNULL(Income21,0)+ ISNULL(Income22,0)+ ISNULL(Income23,0)+ ISNULL(Income24,0)+ ISNULL(Income25,0)+
						ISNULL(Income26,0)+ ISNULL(Income27,0)+ ISNULL(Income28,0)+ ISNULL(Income29,0)+ ISNULL(Income30,0))
						- 
						(ISNULL(Income09,0)+ ISNULL(Income10,0)))*0.01
						
                 FROM HT3400
                 WHERE	HT3400.DivisionID = @DivisionID
						AND HT3400.TranMonth = @TranMonth
						AND HT3400.TranYear = @TranYear
						AND HT3400.EmployeeID = @EmployeeID
						AND PayrollMethodID = @PayrollMethodID  
						
						 )
IF @CONGDOAN <115000
BEGIN
	UPDATE HT3400
	SET [SubAmount04]= @CONGDOAN
	 WHERE	HT3400.DivisionID = @DivisionID
			AND HT3400.TranMonth = @TranMonth
			AND HT3400.TranYear = @TranYear
			AND HT3400.EmployeeID = @EmployeeID
			AND PayrollMethodID = @PayrollMethodID  
END
ELSE
	UPDATE HT3400
	SET [SubAmount04]= 115000
	 WHERE	HT3400.DivisionID = @DivisionID
			AND HT3400.TranMonth = @TranMonth
			AND HT3400.TranYear = @TranYear
			AND HT3400.EmployeeID = @EmployeeID
			AND PayrollMethodID = @PayrollMethodID  

           
            FETCH NEXT FROM @Emp_cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID,@CoValues,@AbsentValues,@BaseSalary
      END

CLOSE @Emp_cur



GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

