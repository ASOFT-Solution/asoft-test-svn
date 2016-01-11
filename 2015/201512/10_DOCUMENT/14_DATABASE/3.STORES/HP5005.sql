/****** Object:  StoredProcedure [dbo].[HP5005]    Script Date: 08/05/2010 09:59:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong
----Created date: 20/08/2004
----purpose: Tinh cac khoan giam tru duoc ket chuyen -----duoc goi tu HP5000, chua xu ly cac khoan giam tru tinh bang loai tien te khac VND
--- Modify on 08/01/2014 by Bảo Anh: Cải thiện tốc độ (câu tạo cursor không join HT2461, dùng biến kiểu table thay cho HV5555)
/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/
ALTER PROCEDURE [dbo].[HP5005]
       @PayrollMethodID nvarchar(50) ,
       @DivisionID nvarchar(50) ,
       @TranMonth int ,
       @TranYear int ,
       @SubID nvarchar(50) ,
       @Orders int ,
       @SourceFieldName nvarchar(250) ,
       @SourceTableName nvarchar(250) ,
       @DepartmentID1 AS nvarchar(50) ,
       @TeamID1 AS nvarchar(50)
AS
DECLARE
        @sSQL nvarchar(4000) ,
        @SalaryAmount decimal(28,8) ,
        @cur cursor ,
        @TransactionID nvarchar(50) ,
        @EmployeeID nvarchar(50) ,
        @DepartmentID nvarchar(50) ,
        @TeamID nvarchar(50)
        
Declare @ST Table(SalaryAmount decimal(28,8))
		
IF @DepartmentID1 = '%'
   BEGIN

         SET @cur = CURSOR SCROLL KEYSET FOR SELECT
                                                 HT34.TransactionID ,
                                                 HT34.EmployeeID ,
                                                 HT34.DepartmentID ,
                                                 HT34.TeamID
                                             FROM
                                                 HT3400 HT34 ---LEFT JOIN HT2461 HT24
                                             ---ON  HT34.EmployeeID = HT24.EmployeeID AND HT34.DivisionID = HT24.DivisionID AND HT34.DepartmentID = HT24.DepartmentID AND ISNull(HT34.TeamID , '') LIKE ISNull(HT24.TeamID , '') AND HT34.TranMonth = HT24.TranMonth AND HT34.TranYear = HT24.TranYear
                                             WHERE
                                                 HT34.PayrollMethodID = @PayrollMethodID AND HT34.TranMonth = @TranMonth AND HT34.TranYear = @TranYear AND HT34.DivisionID = @DivisionID AND HT34.DepartmentID IN ( SELECT
                                                                                                                                                                                                                        DepartmentID
                                                                                                                                                                                                                    FROM
                                                                                                                                                                                                                        HT5004
                                                                                                                                                                                                                    WHERE
                                                                                                                                                                                                                        PayrollMethodID = @PayrollMethodID
                                                                                                                                                                                                                        AND DivisionID = @DivisionID )

         OPEN @cur
         FETCH next FROM @cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID
         WHILE @@FETCH_STATUS = 0
               BEGIN
                     SET @SalaryAmount = 0
                     IF ( Isnull(@SourceFieldName , '') NOT LIKE '' ) AND ( Isnull(@SourceTableName , '') NOT LIKE '' )
                        BEGIN							
                            SET @sSQL = ' Select  Sum(Isnull(' + @SourceFieldName + ', 0)) as SalaryAmount		 
											From ' + @SourceTableName + '
											Where DivisionID = ''' + @DivisionID + ''' and 
												EmployeeID  = ''' + @EmployeeID + ''' and 
												DepartmentID = ''' + @DepartmentID + ''' and
												isnull(TeamID, '''') = ''' + isnull(@TeamID , '') + ''' and 
												TranMonth = ' + str(@TranMonth) + ' and
												TranYear = ' + str(@TranYear)

                            Insert into @ST(SalaryAmount) EXEC(@sSQL)
							SELECT @SalaryAmount = SalaryAmount from @ST

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
                                                  END )
                            WHERE
                                  DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID

                            FETCH next FROM @cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID
                        END
               END
         CLOSE @cur

   END
ELSE -------------------------------------------------@DepartmentID1<>'%'----------------------------------------

   BEGIN

         SET @cur = CURSOR SCROLL KEYSET FOR SELECT
                                                 HT34.TransactionID ,
                                                 HT34.EmployeeID ,
                                                 HT34.DepartmentID ,
                                                 HT34.TeamID
                                             FROM
                                                 HT3400 HT34 ---LEFT JOIN HT2461 HT24
                                             ---ON  HT34.EmployeeID = HT24.EmployeeID AND HT34.DivisionID = HT24.DivisionID AND HT34.DepartmentID = HT24.DepartmentID AND ISNull(HT34.TeamID , '') LIKE ISNull(HT24.TeamID , '') AND HT34.TranMonth = HT24.TranMonth AND HT34.TranYear = HT24.TranYear
                                             WHERE
                                                 HT34.PayrollMethodID = @PayrollMethodID AND HT34.TranMonth = @TranMonth AND HT34.TranYear = @TranYear AND HT34.DivisionID = @DivisionID AND HT34.DepartmentID LIKE @DepartmentID1 AND IsNull(HT34.TeamID , '') LIKE IsNull(@TeamID1 , '') AND HT34.DepartmentID IN ( SELECT
                                                                                                                                                                                                                                                                                                                          DepartmentID
                                                                                                                                                                                                                                                                                                                      FROM
                                                                                                                                                                                                                                                                                                                          HT5004
                                                                                                                                                                                                                                                                                                                      WHERE
                                                                                                                                                                                                                                                                                                                          PayrollMethodID = @PayrollMethodID )

         OPEN @cur
         FETCH next FROM @cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID
         WHILE @@FETCH_STATUS = 0
               BEGIN
                     SET @SalaryAmount = 0
                     IF ( Isnull(@SourceFieldName , '') NOT LIKE '' ) AND ( Isnull(@SourceTableName , '') NOT LIKE '' )
                        BEGIN							
							SET @sSQL = 'Select round(Sum(Isnull(' + @SourceFieldName + ', 0)),0) as SalaryAmount		 
											From ' + @SourceTableName + '
											Where DivisionID = ''' + @DivisionID + ''' and 
												DepartmentID = ''' + @DepartmentID1 + ''' and 
												IsNull(TeamID,'''') like  ''' + @TeamID1 + ''' and 
												EmployeeID  = ''' + @EmployeeID + ''' and
												TranMonth = ' + str(@TranMonth) + ' and
												TranYear = ' + str(@TranYear)
							Insert into @ST(SalaryAmount) EXEC(@sSQL)
							SELECT @SalaryAmount = SalaryAmount from @ST
								
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
												  END )
							WHERE
								  DivisionID = @DivisionID AND PayrollMethodID = @PayrollMethodID AND TransactionID = @TransactionID

							FETCH next FROM @cur INTO @TransactionID,@EmployeeID,@DepartmentID,@TeamID
                        END
               END
         CLOSE @cur

   END