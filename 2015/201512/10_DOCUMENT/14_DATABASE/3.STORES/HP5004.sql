IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP5004]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP5004]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Nguyen Van Nhan, Date 29/04/2004
----- Tap hop cham cong, he so
----- edited by: Vo Thanh Huong, date: 20/08/2004
----- Edit By: Dang Le Bao Quynh; Date: 09/06/2006
----- Description: Bo sugn them tham so @IncomeID de tinh thu nhap tong hop	
----- Modify on 14/08/2013 by Bao Anh: Bo sung cast cho HV5003.ProkectID khi join HV5002 (mantis 0021196)
----- Modified on 24/03/2014 by Le Thi Thu Hien : Bo sung them bien truyen vao
----- Modified on 10/04/2014 by Bảo Anh : Bỏ điều kiện TeamID khi join HV5002 và HV5003 nếu là phương pháp P06
----- Modified on 20/10/2014 by Trí Thiện : Bỏ sum giá trị chi phí khác khi tính lương theo phương pháp P01 và P06 cho KH Vân Khánh
/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/
CREATE PROCEDURE [dbo].[HP5004] @DivisionID      AS NVARCHAR(50),
                               @TranMonth       AS INT,
                               @TranYear        AS INT,
                               @PayrollMethodID NVARCHAR(50),
                               @MethodID        AS NVARCHAR(50),
                               @BaseSalaryField AS NVARCHAR(50),
                               @BaseSalary      AS DECIMAL (28, 8),
                               @SalaryTotal     AS DECIMAL (28, 8),
                               @AbsentAmount    AS DECIMAL (28, 8),
                               @Orders          AS TINYINT,
                               @IsIncome        AS TINYINT,
                               @DepartmentID1   AS NVARCHAR(50),
                               @TeamID1         AS NVARCHAR(50),
                               @ExchangeRate    DECIMAL (28, 8),
                               @IncomeID        AS NVARCHAR(50),
                               @GeneralAbsentID AS nvarchar(50)
AS
    --Print ' Tinh Thu nhap '
    DECLARE @sSQL       AS NVARCHAR(4000),
            @IsDivision AS TINYINT

	--- >>> CustomerIndex

	DECLARE @AP4444 Table(CustomerIndex Int, Export Int)
	DECLARE @CustomerIndex AS Int
	INSERT INTO @AP4444(CustomerIndex,Export) EXEC('AP4444')
	SELECT @CustomerIndex=CustomerIndex From @AP4444

	--- <<< CustomerIndex

    DELETE HT3444
	DELETE HT344401
	
	--Luong theo cong trinh
    If @MethodID = 'P06'
    BEGIN
		IF @CustomerIndex = 39 -- Customize cho Khách hàng Vân Khánh, không sum các giá trị khác theo P06
			BEGIN
				SET @sSQL =' Insert  HT3444 (TranMonth,TranYear,EmployeeID,DivisionID,DepartmentID,TeamID,GeneralCo, AbsentAmount , BaseSalary )
				Select V2.TranMonth, V2.TranYear, V2.EmployeeID,
				V2.DivisionID, V2.DepartmentID , V2.TeamID,
				isnull(V2.GeneralCo,0), --Sum(isnull(V2.GeneralCo,0)), 	
				Sum(isnull(V3.AbsentAmount,0)) ,
				Min(V2.BaseSalary)
				From #HV5002 V2 Left join #HV5003 V3 on 	V2.EmployeeID = V3.EmployeeID and 
								V2.DepartmentID = V3.DepartmentID and 
						---		isnull(V2.TeamID,'''') = isnull(V3.TeamID,'''') and
								V2.DivisionID = V3.DivisionID and
								V2.TranMonth = V3.TranMonth and
								V2.TranYear = V3.TranYear and
								isnull(V2.ProjectID,'''') = isnull(cast(V3.ProjectID as nvarchar(50)),'''')
				Where V2.DivisionID = ''' + @DivisionID + ''' and
				V2.TranMonth = ' + Str(@TranMonth) + '  and
				V2.TranYear =' + Str(@TranYear) + '  
				Group By V2.DivisionID, V2.TranMonth, V2.TranYear, V2.DepartmentID, V2.TeamID, V2.EmployeeID, V2.GeneralCo	
				'
			END
		ELSE
			BEGIN
				SET @sSQL =' Insert  HT3444 (TranMonth,TranYear,EmployeeID,DivisionID,DepartmentID,TeamID,GeneralCo, AbsentAmount , BaseSalary )
				Select V2.TranMonth, V2.TranYear, V2.EmployeeID,
				V2.DivisionID, V2.DepartmentID , V2.TeamID,
				Sum(isnull(V2.GeneralCo,0)), 	
				Sum(isnull(V3.AbsentAmount,0)) ,
				Min(V2.BaseSalary)
				From #HV5002 V2 Left join #HV5003 V3 on 	V2.EmployeeID = V3.EmployeeID and 
								V2.DepartmentID = V3.DepartmentID and 
						---		isnull(V2.TeamID,'''') = isnull(V3.TeamID,'''') and
								V2.DivisionID = V3.DivisionID and
								V2.TranMonth = V3.TranMonth and
								V2.TranYear = V3.TranYear and
								isnull(V2.ProjectID,'''') = isnull(cast(V3.ProjectID as nvarchar(50)),'''')
				Where V2.DivisionID = ''' + @DivisionID + ''' and
				V2.TranMonth = ' + Str(@TranMonth) + '  and
				V2.TranYear =' + Str(@TranYear) + '  
				Group By V2.DivisionID, V2.TranMonth, V2.TranYear, V2.DepartmentID, V2.TeamID, V2.EmployeeID, V2.GeneralCo	
				'
			END
		
		-- Execute SQL INSERT INTO HT3444
		EXEC (@sSQL)
		
		IF @CustomerIndex = 39
			SET @sSQL =' Insert  HT344401 (ProjectID,TranMonth,TranYear,EmployeeID,DivisionID,DepartmentID,TeamID,GeneralCo, AbsentAmount , BaseSalary )
			Select V2.ProjectID, V2.TranMonth, V2.TranYear, V2.EmployeeID,
			V2.DivisionID, V2.DepartmentID , V2.TeamID,
			isnull(V2.GeneralCo,0), --Sum(isnull(V2.GeneralCo,0)), 	
			Sum(isnull(V3.AbsentAmount,0)) ,
			Min(V2.BaseSalary)
			From #HV5002 V2 Left join #HV5003 V3 on 	V2.EmployeeID = V3.EmployeeID and 
							V2.DepartmentID = V3.DepartmentID and 
					---		isnull(V2.TeamID,'''') = isnull(V3.TeamID,'''') and
							V2.DivisionID = V3.DivisionID and
							V2.TranMonth = V3.TranMonth and
							V2.TranYear = V3.TranYear and
							isnull(V2.ProjectID,'''') = isnull(cast(V3.ProjectID as nvarchar(50)),'''')
			Where V2.DivisionID = ''' + @DivisionID + ''' and
			V2.TranMonth = ' + Str(@TranMonth) + '  and
			V2.TranYear =' + Str(@TranYear) + '  
			Group By V2.DivisionID, V2.TranMonth, V2.TranYear, V2.DepartmentID, V2.TeamID, V2.EmployeeID,V2.ProjectID, V2.GeneralCo	
			'
		ELSE
			SET @sSQL =' Insert  HT344401 (ProjectID,TranMonth,TranYear,EmployeeID,DivisionID,DepartmentID,TeamID,GeneralCo, AbsentAmount , BaseSalary )
			Select V2.ProjectID, V2.TranMonth, V2.TranYear, V2.EmployeeID,
			V2.DivisionID, V2.DepartmentID , V2.TeamID,
			Sum(isnull(V2.GeneralCo,0)), 	
			Sum(isnull(V3.AbsentAmount,0)) ,
			Min(V2.BaseSalary)
			From #HV5002 V2 Left join #HV5003 V3 on 	V2.EmployeeID = V3.EmployeeID and 
							V2.DepartmentID = V3.DepartmentID and 
					---		isnull(V2.TeamID,'''') = isnull(V3.TeamID,'''') and
							V2.DivisionID = V3.DivisionID and
							V2.TranMonth = V3.TranMonth and
							V2.TranYear = V3.TranYear and
							isnull(V2.ProjectID,'''') = isnull(cast(V3.ProjectID as nvarchar(50)),'''')
			Where V2.DivisionID = ''' + @DivisionID + ''' and
			V2.TranMonth = ' + Str(@TranMonth) + '  and
			V2.TranYear =' + Str(@TranYear) + '  
			Group By V2.DivisionID, V2.TranMonth, V2.TranYear, V2.DepartmentID, V2.TeamID, V2.EmployeeID,V2.ProjectID, V2.GeneralCo	
			'

		-- Execute SQL INSERT INTO HT344401
		EXEC (@sSQL)
    END
    ELSE -- Không theo lương công trình : khác P06
    BEGIN
		IF @CustomerIndex = 39
			SET @sSQL =' Insert  HT3444 (TranMonth,TranYear,EmployeeID,DivisionID,DepartmentID,TeamID,GeneralCo, AbsentAmount , BaseSalary )
			Select V2.TranMonth, V2.TranYear, V2.EmployeeID,
			V2.DivisionID, V2.DepartmentID , V2.TeamID,
			isnull(V2.GeneralCo,0), --Sum(isnull(V2.GeneralCo,0)), 	
			Sum(isnull(V3.AbsentAmount,0)) ,
			Min(V2.BaseSalary)
			From #HV5002 V2 Left join #HV5003 V3 on 	V2.EmployeeID = V3.EmployeeID and 
							V2.DepartmentID = V3.DepartmentID and 
							isnull(V2.TeamID,'''') = isnull(V3.TeamID,'''') and
							V2.DivisionID = V3.DivisionID and
							V2.TranMonth = V3.TranMonth and
							V2.TranYear = V3.TranYear 
			Where V2.DivisionID = ''' + @DivisionID + ''' and
			V2.TranMonth = ' + Str(@TranMonth) + '  and
			V2.TranYear =' + Str(@TranYear) + '  
			Group By V2.DivisionID, V2.TranMonth, V2.TranYear, V2.DepartmentID, V2.TeamID, V2.EmployeeID, V2.GeneralCo
			'
		ELSE
			SET @sSQL =' Insert  HT3444 (TranMonth,TranYear,EmployeeID,DivisionID,DepartmentID,TeamID,GeneralCo, AbsentAmount , BaseSalary )
			Select V2.TranMonth, V2.TranYear, V2.EmployeeID,
			V2.DivisionID, V2.DepartmentID , V2.TeamID,
			Sum(isnull(V2.GeneralCo,0)), 	
			Sum(isnull(V3.AbsentAmount,0)) ,
			Min(V2.BaseSalary)
			From #HV5002 V2 Left join #HV5003 V3 on 	V2.EmployeeID = V3.EmployeeID and 
							V2.DepartmentID = V3.DepartmentID and 
							isnull(V2.TeamID,'''') = isnull(V3.TeamID,'''') and
							V2.DivisionID = V3.DivisionID and
							V2.TranMonth = V3.TranMonth and
							V2.TranYear = V3.TranYear 
			Where V2.DivisionID = ''' + @DivisionID + ''' and
			V2.TranMonth = ' + Str(@TranMonth) + '  and
			V2.TranYear =' + Str(@TranYear) + '  
			Group By V2.DivisionID, V2.TranMonth, V2.TranYear, V2.DepartmentID, V2.TeamID, V2.EmployeeID, V2.GeneralCo
			'

		-- Execute SQL INSERT INTO HT3444
		EXEC (@sSQL)
    END
    
    
    
    
    SET @IsDivision = (SELECT IsDivision
                       FROM   HT1000
                       WHERE  MethodID = @MethodID  and DivisionID =@DivisionID)


    IF @IsDivision = 0 --- luong Nhan
      EXEC Hp5101
        @DivisionID,
        @TranMonth,
        @TranYear,
        @PayrollMethodID,
        @MethodID,
        @AbsentAmount,
        @Orders,
        @IsIncome,
        @DepartmentID1,
        @TeamID1,
        @ExchangeRate,
        @IncomeID,
        @GeneralAbsentID 
    ELSE IF @IsDivision = 1 --- Luong Chia
      EXEC Hp5102
        @DivisionID,
        @TranMonth,
        @TranYear,
        @PayrollMethodID,
        @MethodID,
        @SalaryTotal,
        @AbsentAmount,
        @Orders,
        @IsIncome,
        @DepartmentID1,
        @TeamID1
    ELSE IF @IsDivision = 2
      EXEC Hp5103
        @DivisionID,
        @TranMonth,
        @TranYear,
        @PayrollMethodID,
        @MethodID,
        @AbsentAmount,
        @Orders,
        @IsIncome,
        @DepartmentID1,
        @TeamID1,
        @ExchangeRate,
        @IncomeID
    ELSE IF @IsDivision = 3
      EXEC Hp5105
        @DivisionID,
        @TranMonth,
        @TranYear,
        @PayrollMethodID,
        @MethodID,
        @AbsentAmount,
        @Orders,
        @IsIncome,
        @DepartmentID1,
        @TeamID1,
        @ExchangeRate,
        @IncomeID 


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON