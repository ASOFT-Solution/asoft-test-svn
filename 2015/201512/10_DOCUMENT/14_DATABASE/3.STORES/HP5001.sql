IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5001]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP5001]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Nguyen Van Nhan, Date 26/04/2004
----- Xac dinh cac khoan thu nhap
----- Edited by: Vo Thanh Huong, date: 20/08/2004
----- Edit By: Dang Le Bao Quynh; Date: 09/06/2006
----- Description: Bo sugn them tham so @IncomeID de tinh thu nhap tong hop tai dong lenh
----- Exec HP5004

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/
-- Edited by: [GS] [Bao Quynh] [05/03/2013] -- If @MethodID = 'P05' : Thêm phần tính phương pháp tính lương sản phẩm theo ngay  Vietroll  
----- Modified on 06/09/2013 by Le Thi Thu Hien : Cham cong theo ca (Neu co du lieu cham cong ca thi cham cong ca nguoc lai cham cong ngay VietRoll
----- Modified on 24/03/2014 by Le Thi Thu Hien : Bo sung them bien truyen vao

CREATE PROCEDURE  [dbo].[HP5001] 
				@DivisionID AS nvarchar(50),
				@TranMonth AS int, 
				@TranYear AS int,  
				@PayrollMethodID AS nvarchar(50), 
				@IncomeID  AS nvarchar(50),  
				@MethodID  AS nvarchar(50),  
				@BaseSalaryField  AS nvarchar(50),  
				@BaseSalary AS decimal(28,8), 
				@GeneralCoID AS  nvarchar(50),  
				@GeneralAbsentID AS nvarchar(50),  
				@SalaryTotal AS decimal(28,8), 
				@AbsentAmount AS decimal(28,8), 
				@Orders AS tinyint,
				@IsIncome AS tinyint,
				@DepartmentID1 AS nvarchar(50),
				@TeamID1 AS nvarchar(50),
				@ExchangeRate decimal(28,8)
AS
Declare @sSQL AS nvarchar(4000)

IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#HV5002')) 
	DROP TABLE #HV5002

IF EXISTS (SELECT *	FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb.dbo.#HV5003')) 
	DROP TABLE #HV5003

CREATE TABLE #HV5002 (DivisionID nvarchar(50),
					ProjectID nvarchar(50),
					TranMonth int,
					TranYear int,
					EmployeeID nvarchar(50),
					DepartmentID nvarchar(50),
					BaseSalary decimal(28,8),
					TeamID nvarchar(50),
					GeneralCo decimal(28,8)
)

CREATE TABLE #HV5003 (DivisionID nvarchar(50),
					ProjectID nvarchar(50),
					TranMonth int,
					TranYear int,
					EmployeeID nvarchar(50),
					DepartmentID nvarchar(50),
					AbsentAmount decimal(28,8),
					TeamID nvarchar(50)
)

----- 	Xac dinh he so chung:		

	Exec HP5002	@DivisionID, @TranMonth, @TranYear, @PayrollMethodID, @GeneralCoID, @MethodID,
			@BaseSalaryField, @BaseSalary, @DepartmentID1, @TeamID1

---	Xac dinh ngay cong tong hop:
	Exec HP5003	@DivisionID, @TranMonth, @TranYear, @PayrollMethodID, @GeneralAbsentID, 
			@DepartmentID1, @TeamID1
			
--- Xac dinh cong san pham, gio cong, he so theo ngay, ap dung cho phuong phap P05
	IF NOT EXISTS (SELECT TOP 1 1 FROM HT0289 WHERE DivisionID = @DivisionID AND TranMonth = @TranMonth AND TranYear = @TranYear)
	BEGIN 
		IF @MethodID = 'P05'
		EXEC HP2454 @DivisionID, @TranMonth, @TranYear, @PayrollMethodID, @GeneralAbsentID
	END
	ELSE
	BEGIN
		IF @MethodID = 'P05'
		EXEC HP2455 @DivisionID, @TranMonth, @TranYear, @PayrollMethodID, @GeneralAbsentID
	END
		
	
--- 	Xac dinh thu nhap
	EXEC HP5004	@DivisionID, @TranMonth, @TranYear, @PayrollMethodID,  @MethodID, @BaseSalaryField, @BaseSalary, 
			@SalaryTotal, @AbsentAmount, @Orders, @IsIncome, @DepartmentID1, @TeamID1, @ExchangeRate,@IncomeID,@GeneralAbsentID

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

