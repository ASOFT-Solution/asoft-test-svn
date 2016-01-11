  
-----  Created by Dang Le Bao Quynh, Date 09/06/2004  
----   Purpose: Tinh luong theo PP luong SP phan bo   
---- Cong thuc: L = HeSo*NgayCong*(?Luong mot nhom/?HeSo*NgayCong)  
/********************************************  
'* Edited by: [GS] [Minh Lâm] [02/08/2010]  
'********************************************/  
  
ALTER PROCEDURE [dbo].[HP5106]  
       @PayrollMethodID nvarchar(50) ,  
       @TranMonth int ,  
       @TranYear int ,  
       @DivisionID nvarchar(50) ,  
       @DepartmentID nvarchar(50) ,  
       @TeamID nvarchar(50)  
AS  
DECLARE  
        @PayrollMethodID1 nvarchar(50) ,  
        @TranMonth1 int ,  
        @TranYear1 int ,  
        @DivisionID1 nvarchar(50) ,  
        @DepartmentID1 nvarchar(50) ,  
        @TeamID1 nvarchar(50) ,  
        @IncomeID1 nvarchar(50) ,  
        @EmployeeID1 nvarchar(50) ,  
        @GeneralCo1 decimal(28,8) ,  
        @GeneralAbsent1 decimal(28,8) ,  
        @ProductSalaryTeam1 decimal(28,8) ,  
        @cur cursor ,  
        @TeamCoAbsent decimal(28,8) ,  
        @sSQL nvarchar(4000)  
  
SET @cur = CURSOR FOR SELECT  
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
                          ProductSalary  
                      FROM  
                          HT3404  
                      WHERE  
                          PayrollMethodID = @PayrollMethodID AND TranMonth = @TranMonth AND TranYear = @TranYear AND DivisionID = @DivisionID AND DepartmentID LIKE @DepartmentID AND IsNull(TeamID , '') LIKE IsNull(@TeamID , '')  
OPEN @cur  
FETCH NEXT FROM @cur INTO @PayrollMethodID1,@TranMonth1,@TranYear1,@DivisionID1,@DepartmentID1,@TeamID1,@IncomeID1,@EmployeeID1,@GeneralCo1,@GeneralAbsent1,@ProductSalaryTeam1  
WHILE @@FETCH_STATUS = 0  
      BEGIN  
            SET @TeamCoAbsent = ( SELECT  
                                      sum(GeneralCo * GeneralAbsentAmount)  
                                  FROM  
                                      HT3404  
                                  WHERE  
                                      PayrollMethodID = @PayrollMethodID1 AND IncomeID = @IncomeID1 AND TranMonth = @TranMonth1 AND TranYear = @TranYear1 
                                      AND DivisionID = @DivisionID1 AND DepartmentID = @DepartmentID1 AND TeamID = @TeamID1 )  
  -- Xu ly loi chia cho 0  
    
            IF @TeamCoAbsent = 0  
               BEGIN  
                     SET @TeamCoAbsent = 1  
               END  
                     
  
            SET @sSQL = 'UPDATE HT3400 SET Income' + RIGHT(@IncomeID1 , 2) + '=' + ltrim(CAST(( @ProductSalaryTeam1 / @TeamCoAbsent ) * @GeneralCo1 * @GeneralAbsent1 AS float)) + ' WHERE PayrollMethodID=''' + @PayrollMethodID1 + '''' + ' AND TranMonth=' +
 ltrim(@TranMonth1) + ' AND TranYear=' + ltrim(@TranYear1) + ' AND EmployeeID=''' + @EmployeeID1 + ''' AND DivisionID = ''' +  @DivisionID + ''''  
              
     
            EXEC ( @sSQL )  
            FETCH NEXT FROM @cur INTO @PayrollMethodID1,@TranMonth1,@TranYear1,@DivisionID1,@DepartmentID1,@TeamID1,@IncomeID1,@EmployeeID1,@GeneralCo1,@GeneralAbsent1,@ProductSalaryTeam1  
      END  