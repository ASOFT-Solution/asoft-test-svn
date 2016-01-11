
/****** Object:  StoredProcedure [dbo].[HP5104]    Script Date: 08/05/2010 10:03:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/
----Create by: Dang Le Bao Quynh; Date: 15/06/2006
----Puspose: Tinh khoan thu nhap tong hop

ALTER PROCEDURE [dbo].[HP5104]
       @PayrollMethodID nvarchar(50) ,
       @TranMonth int ,
       @TranYear int ,
       @EmployeeID nvarchar(50) ,
       @IncomeID nvarchar(50) ,
       @IsIncome AS tinyint ,
       @DivisionID nvarchar(50) ,
       @DepartmentID nvarchar(50) ,
       @TeamID nvarchar(50) ,
       @TransactionID nvarchar(50) ,
       @BaseSalary decimal(28,8) OUTPUT
AS
DECLARE
        @ProcessIdentifier int ,
        @cur cursor ,
        @Amount decimal(28,8) ,
        @BaseSalaryCalculate decimal(28,8) ,
        @DetailIncomeID nvarchar(50) ,
        @DivisionK nvarchar(50) ,
        @Orders int ,
        @Type char(1) ,
        @SQL nvarchar(4000)

SET NOCOUNT ON
SET @ProcessIdentifier = @@SPID
SET @Orders = 0
SET @BaseSalaryCalculate = 0


IF @IsIncome = 1
   BEGIN
         SET @cur = CURSOR FOR SELECT
                                   HT5008.IncomeID ,                             
                                   HV1116.Type
                               FROM
                                   HT5008 INNER JOIN HV1116
                               ON  HT5008.IncomeID = HV1116.BaseSalaryFieldID
                               WHERE
                                   HT5008.GeneralIncomeID IN ( SELECT
                                                                   BaseSalaryField
                                                               FROM
                                                                   HT5005
                                                               WHERE
                                                                   IncomeID = @IncomeID AND PayrollMethodID = @PayrollMethodID AND DivisionID = @DivisionID )
  
   END
   
ELSE
   BEGIN 
         SET @cur = CURSOR FOR SELECT
                                   HT5008.IncomeID ,
                                   HV1116.Type
                               FROM
                                   HT5008 INNER JOIN HV1116 
                               ON  HT5008.IncomeID = HV1116.BaseSalaryFieldID 
                               WHERE
                                   HT5008.GeneralIncomeID IN ( SELECT
                                                                   BaseSalaryField
                                                               FROM
                                                                   HT5006
                                                               WHERE
                                                                   SubID = @IncomeID AND PayrollMethodID = @PayrollMethodID AND DivisionID = @DivisionID )
 
   END

--Tao bang tam -- Edit by Trong Khanh
 CREATE TABLE #HTTemp
 (  
	ColumnName decimal(28,8)
 )  
     
OPEN @cur
FETCH NEXT FROM @cur INTO @DetailIncomeID,@Type

WHILE @@FETCH_STATUS = 0
      BEGIN  
            IF @Type = 'B'
               BEGIN    
                     SET @SQL = 'INSERT INTO #HTTemp SELECT isnull(' + @DetailIncomeID + ',0)  AS ColumnName  FROM HT2400 WHERE DivisionID = '''+@DivisionID+''' AND EmployeeID=''' + @EmployeeID + ''' AND TranMonth=' + STR(@TranMonth) + ' AND TranYear=' + STR(@TranYear) + ' AND DepartmentID=''' + @DepartmentID + ''' AND isnull(TeamID,''' + '%' + ''') like ''' + isnull(@TeamID , '%') + ''''
                     EXEC ( @SQL )

					--SET @Amount=(SELECT ColumnName FROM HD5104)
					--SET @BaseSalaryCalculate=@BaseSalaryCalculate + Isnull(@Amount,0)
               END
            IF @Type = 'I'
               BEGIN                         
                     SET @SQL = 'INSERT INTO #HTTemp SELECT isnull(Income' + RIGHT(@DetailIncomeID , 2) + ',0)  AS ColumnName FROM HT3400 WHERE  DivisionID = '''+@DivisionID+''' AND EmployeeID=''' + @EmployeeID + ''' AND TranMonth=' + STR(@TranMonth) + ' AND TranYear=' + STR(@TranYear) + ' AND DepartmentID=''' + @DepartmentID + ''' AND isnull(TeamID,''' + '%' + ''') like ''' + isnull(@TeamID , '%') + ''' AND TransactionID=''' + @TransactionID + ''''
                     EXEC ( @SQL )                   
					--SET  @Amount= (SELECT ColumnName FROM HD5104)
					--SET @BaseSalaryCalculate=@BaseSalaryCalculate + Isnull(@Amount,0)
               END
            FETCH NEXT FROM @cur INTO @DetailIncomeID,@Type    
    
      END

CLOSE @cur
DEALLOCATE @cur

SET @Amount = ( SELECT
                    sum(ColumnName)
                FROM
                    #HTTemp )
SET @BaseSalary = Isnull(@Amount , 0)

--Xoa Bang tam
DROP TABLE #HTTemp

SET NOCOUNT OFF