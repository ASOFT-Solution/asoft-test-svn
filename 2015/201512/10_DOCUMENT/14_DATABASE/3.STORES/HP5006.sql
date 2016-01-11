/****** Object:  StoredProcedure [dbo].[HP5006]    Script Date: 11/30/2011 08:41:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP5006]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP5006]
GO
/****** Object:  StoredProcedure [dbo].[HP5006]    Script Date: 11/30/2011 08:41:29 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO





---Created by: Vo Thanh Huong, date: 17/02/2005
---purpose: Tinh thue thu nhap
---Edit By: Dang Le Bao Quynh; Date 27/08/2008
---Purpose: Sua Union thanh Union All
--- Modify on 01/08/2013 by Bao Anh: Bo sung them 10 khoan thu nhap 21 -> 30 (Hung Vuong)
/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/
CREATE PROCEDURE [dbo].[HP5006]
       @DivisionID AS nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int ,
       @PayrollMethodID AS nvarchar(50) ,
       @DepartmentID1 AS nvarchar(50) ,
       @TeamID1 AS nvarchar(50)
AS
DECLARE
        @sSQLSelect nvarchar(4000) ,
        @sSQLFrom nvarchar(4000) ,
        @sSQLWhere nvarchar(4000) ,
        @sSQLUnion nvarchar(4000) ,
        @IsProgressive tinyint ,
        @IsPercentSurtax AS tinyint ,
        @TaxObjectID nvarchar(50) ,
        @cur AS cursor ,
        @RateExchange AS nvarchar(50) ,
        @Currency AS nvarchar(50)

SET @RateExchange = 1

IF EXISTS ( SELECT TOP 1
                1
            FROM
                HT3400
            WHERE
                DivisionID = @DivisionID AND DepartmentID LIKE @DepartmentID1 AND Isnull(TeamID , '') LIKE isnull(@TeamID1 , '') AND TranMonth = @TranMonth AND TranYear = @TranYear )
   BEGIN
         SET @cur = CURSOR SCROLL KEYSET FOR SELECT DISTINCT
                                                 TaxObjectID
                                             FROM
                                                 HT2400
                                             WHERE DivisionID = @DivisionID AND
                                                 TranMonth = @TranMonth AND TranYear = @TranYear AND isnull(TaxObjectID , '''') <> '''' AND DivisionID = @DivisionID AND DepartmentID LIKE @DepartmentID1 AND Isnull(TeamID , '') LIKE isnull(@TeamID1 , '')
         OPEN @cur
         FETCH next FROM @cur INTO @TaxObjectID
         WHILE @@Fetch_Status = 0
               BEGIN
---Tinh thu nhap chiu thue
                     SET @sSQLSelect = 'Select H00.DivisionID,  H00.DepartmentID, ISnull(H00.TeamID,'''') as TeamID,H00.EmployeeID, H00.PayrollMethodID, H02.IsTax,
		isnull(case when right(H01.IncomeID,2) = 01 then Income01
		 when right(H01.IncomeID,2) = 02 then Income02 
		 when right(H01.IncomeID,2) = 03 then Income03 
		 when right(H01.IncomeID,2) = 04 then Income04 
		 when right(H01.IncomeID,2) = 05 then Income05 
		 when right(H01.IncomeID,2) = 06 then Income06 
		when right(H01.IncomeID,2) = 07 then Income07
		when right(H01.IncomeID,2) = 08 then Income08
		when right(H01.IncomeID,2) = 09 then Income09
		when right(H01.IncomeID,2) = 10 then Income10 
		when right(H01.IncomeID,2) = 11 then Income11
		 when right(H01.IncomeID,2) = 12 then Income12 
		 when right(H01.IncomeID,2) = 13 then Income13 
		 when right(H01.IncomeID,2) = 14 then Income14 
		 when right(H01.IncomeID,2) = 15 then Income15 
		 when right(H01.IncomeID,2) = 16 then Income16 
		when right(H01.IncomeID,2) = 17 then Income17
		when right(H01.IncomeID,2) = 18 then Income18
		when right(H01.IncomeID,2) = 19 then Income19
		when right(H01.IncomeID,2) = 20 then Income20
		when right(H01.IncomeID,2) = 21 then Income21
		when right(H01.IncomeID,2) = 22 then Income22
		when right(H01.IncomeID,2) = 23 then Income23
		when right(H01.IncomeID,2) = 24 then Income24
		when right(H01.IncomeID,2) = 25 then Income25
		when right(H01.IncomeID,2) = 26 then Income26
		when right(H01.IncomeID,2) = 27 then Income27
		when right(H01.IncomeID,2) = 28 then Income28
		when right(H01.IncomeID,2) = 29 then Income29
		when right(H01.IncomeID,2) = 30 then Income30
		else 0 end, 0) * ' + str(@RateExchange) + '  as IncomeAmount, 0 as SubAmount '
                     SET @sSQLFrom = ' From HT3400  H00 inner join HT5005 H01 on H00.PayrollMethodID = H01.PayrollMethodID AND H00.DivisionID = H01.DivisionID
			inner join HT0002 H02 on H02.IncomeID = H01.IncomeID AND  H02.DivisionID = H01.DivisionID 
			inner join HT2400 H03 on H03.TranMonth = H00.TranMonth and H03.DivisionID = H00.DivisionID
				and H03.TranYear = H00.TranYear and
				H03.DivisionID = H00.DivisionID and
				H03.DepartmentID=H00.DepartmentID and
				IsNull(H03.TeamID,'''') like ISNull(H00.TeamID,'''') and
				H03.EmployeeID = H00.EmployeeID and
				H03.TaxObjectID = ''' + @TaxObjectID + ''''
                     SET @sSQLWhere = ' Where H00.DivisionID = ''' + @DivisionID + ''' and 
		H00.DepartmentID like ''' + @DepartmentID1 + ''' and 
		IsNull(H00.TeamID,'''') like  ''' + @TeamID1 + ''' and
		H00.PayrollMethodID like ''' + @PayrollMethodID + ''' and 
		H02.IsTax = 1 and
		H00.TranMonth = ' + CAST(@TranMonth AS varchar(10)) + ' and
		H00.TranYear = ' + CAST(@TranYear AS varchar(10)) + ' '
                     SET @sSQLUnion = ' Union All ' + --Cac khoan giam tru
                     ' Select H00.DivisionID,  H00.DepartmentID, ISnull(H00.TeamID,'''') as TeamID, H00.EmployeeID, H00.PayrollMethodID, H02.IsTax,  0 as IncomeAmount,
		isnull(case when right(H01.SubID,2) = 01 then SubAmount01
		 when right(H01.SubID,2) = 02 then SubAmount02 
		 when right(H01.SubID,2) = 03 then SubAmount03 
		 when right(H01.SubID,2) = 04 then SubAmount04 
		 when right(H01.SubID,2) = 05 then SubAmount05 
		 when right(H01.SubID,2) = 06 then SubAmount06 
		when right(H01.SubID,2) = 07 then  SubAmount07
		when right(H01.SubID,2) = 08 then SubAmount08
		when right(H01.SubID,2) = 09 then SubAmount09
		when right(H01.SubID,2) = 10 then SubAmount10
		when right(H01.SubID,2) = 11 then SubAmount11
		 when right(H01.SubID,2) = 12 then SubAmount12 
		 when right(H01.SubID,2) = 13 then SubAmount13 
		 when right(H01.SubID,2) = 14 then SubAmount14 
		 when right(H01.SubID,2) = 15 then SubAmount15 
		 when right(H01.SubID,2) = 16 then SubAmount16 
		when right(H01.SubID,2) = 17 then  SubAmount17
		when right(H01.SubID,2) = 18 then SubAmount18
		when right(H01.SubID,2) = 19 then SubAmount19
		when right(H01.SubID,2) = 20 then SubAmount20 else 0 end, 0) * ' + str(@RateExchange) + '  as SubAmount   	
	From HT3400  H00 inner join HT5006 H01 on H00.PayrollMethodID = H01.PayrollMethodID and H00.DivisionID = H01.DivisionID 
			inner join HT0005 H02 on H01.SubID = H02.SubID and H01.DivisionID = H02.DivisionID 
			inner join HT2400 H03 on H03.TranMonth = H00.TranMonth and H03.DivisionID = H00.DivisionID and
				H03.TranYear = H00.TranYear and
				H03.DivisionID = H00.DivisionID and
				H03.DepartmentID=H00.DepartmentID and
				IsNull(H03.TeamID,'''') like ISNull(H00.TeamID,'''') and
				H03.EmployeeID = H00.EmployeeID and
				H03.TaxObjectID = ''' + @TaxObjectID + ''' 
	Where H00.DivisionID = ''' + @DivisionID + ''' and 
		H00.DepartmentID like ''' + @DepartmentID1 + ''' and 
		IsNull(H00.TeamID,'''') like  ''' + @TeamID1 + ''' and
		H00.PayrollMethodID like ''' + @PayrollMethodID + ''' and 
		H02.IsTax = 1 and
		H00.TranMonth = ' + CAST(@TranMonth AS varchar(10)) + ' and
		H00.TranYear = ' + CAST(@TranYear AS varchar(10))


                     IF EXISTS ( SELECT TOP 1
                                     1
                                 FROM
                                     sysObjects
                                 WHERE
                                     Name = 'HV5501' AND Type = 'V' )
                        BEGIN
                              DROP VIEW HV5501
                        END
                     EXEC ( 'Create view HV5501 ---tao boi HP5006
		as '+@sSQLSelect+@sSQLFrom+@sSQLWhere+@sSQLUnion )

---Tính thu nh?p tr??c thu? (t?ng thu nh?p tr??c thu? - t?ng gi?m tr? tr??c thu?)
                     SET @sSQLSelect = 'Select DivisionID, DepartmentID, TeamID, EmployeeID, PayrollMethodID, 
		sum(IncomeAmount - SubAmount) as SalaryAmount 
	From HV5501
	Group by DivisionID, DepartmentID,TeamID, EmployeeID, PayrollMethodID'
	
	

                     IF EXISTS ( SELECT TOP 1
                                     1
                                 FROM
                                     sysObjects
                                 WHERE
                                     Name = 'HV5502' AND Type = 'V' )
                        BEGIN
                              DROP VIEW HV5502
                        END
                     EXEC ( 'Create view HV5502 ---tao boi HP5006
		as '+@sSQLSelect )


--Tinh thue 
                     SELECT
                         @IsProgressive = IsProgressive ,
                         @IsPercentSurtax = IsPercentSurtax
                     FROM
                         HT1011
                     WHERE
                         TaxObjectID = @TaxObjectID

                     IF @IsProgressive = 1
                        BEGIN  ---luy tien
                              SET @sSQLSelect = '	Select H00.DivisionID, DepartmentID, TeamID, EmployeeID, PayrollMethodID, SalaryAmount,
		isnull(sum(case when (SalaryAmount > MinSalary and (SalaryAmount <= MaxSalary or MaxSalary = -1))
		then SalaryAmount - MinSalary
		else case when SalaryAmount <= MinSalary then 0 else
		MaxSalary - MinSalary end end* isnull(RateOrAmount,0)/100), 0) as TaxAmount,
		isnull(max(case when (SalaryAmount > MinSalary and (SalaryAmount <= MaxSalary or MaxSalary = -1))
		then RateOrAmount else 0 end), 0) as TaxRate
	INTO HT5888
	From HV5502 H00 inner join HT1012 H01 on H01.TaxObjectID = ''' + @TaxObjectID + ''' AND H01.DivisionID = ''' + @DivisionID + '''
	Group by H00.DivisionID, DepartmentID, TeamID, EmployeeID, PayrollMethodID, SalaryAmount'
                        END
                     ELSE
                        BEGIN  ---nac thang
                              SET @sSQLSelect = '	Select H00.DivisionID, DepartmentID, TeamID, EmployeeID, PayrollMethodID,  SalaryAmount,
		isnull(sum(case when (SalaryAmount > MinSalary and (SalaryAmount <= MaxSalary or MaxSalary = -1))
		then SalaryAmount else 0 end		* isnull(RateOrAmount,0)/100), 0) as TaxAmount,
		isnull(max(case when (SalaryAmount > MinSalary and (SalaryAmount <= MaxSalary or MaxSalary = -1))
		then RateOrAmount else 0 end), 0) as TaxRate
	INTO HT5888
	From HV5502 H00 inner join HT1012 H01 on H01.TaxObjectID = ''' + @TaxObjectID + ''' AND H01.DivisionID = ''' + @DivisionID + '''
	Group by H00.DivisionID, DepartmentID, TeamID,  EmployeeID, PayrollMethodID,  SalaryAmount '
                        END

                     IF EXISTS ( SELECT TOP 1
                                     1
                                 FROM
                                     sysObjects
                                 WHERE
                                     XType = 'U' AND Name = 'HT5888' )
                        BEGIN
                              DROP TABLE HT5888
                        END
                     EXEC ( @sSQLSelect )

                     IF @IsPercentSurtax = 1 ---Tinh thue thu nhap bo sung
                        BEGIN
                              SET @sSQLSelect = 'Select H00.DivisionID, DepartmentID, TeamID, EmployeeID, PayrollMethodID, TaxRate,TaxAmount + 
			case when (SalaryAmount - TaxAmount) > IncomeAfterTax then (SalaryAmount - TaxAmount)*RateOrAmount/100 else 0 end as TaxAmount
		From HT5888  H00 inner join HT1011 H01  on H01.TaxObjectID = ''' + @TaxObjectID + ''' AND H01.DivisionID = H00.DivisionID '

                              IF EXISTS ( SELECT TOP 1
                                              1
                                          FROM
                                              sysObjects
                                          WHERE
                                              Name = 'HV5006' AND Type = 'V' )
                                 BEGIN
                                       DROP VIEW HV5006
                                 END
                              EXEC ( 'Create view HV5006 ---tao boi HP5006
	as '+@sSQLSelect )


                              UPDATE
                                  HT3400
                              SET
                                  TaxAmount = H01.TaxAmount ,
                                  TaxRate = H01.TaxRate
                              FROM
                                  HT3400 H00 INNER JOIN HV5006 H01
                                  ON H00.DivisionID = H01.DivisionID AND H00.DepartmentID = H01.DepartmentID AND IsNull(H00.TeamID , '') LIKE ISNull(H01.TeamID , '') AND H00.EmployeeID = H01.EmployeeID AND H00.PayrollMethodID = H01.PayrollMethodID AND H00.TranMonth = @TranMonth AND H00.TranYear = @TranYear
                              WHERE 
                                  H00.DivisionID = @DivisionID
                        END
                     ELSE
                        BEGIN
                              UPDATE
                                  HT3400
                              SET
                                  TaxAmount = H01.TaxAmount ,
                                  TaxRate = H01.TaxRate
                              FROM
                                  HT3400 H00 INNER JOIN HT5888 H01
                                  ON H00.DivisionID = H01.DivisionID AND H00.DepartmentID = H01.DepartmentID AND IsNull(H00.TeamID , '') = ISNull(H01.TeamID , '') AND H00.EmployeeID = H01.EmployeeID AND H00.PayrollMethodID = H01.PayrollMethodID AND H00.TranMonth = @TranMonth AND H00.TranYear = @TranYear
							  WHERE H00.DivisionID = @DivisionID                                  
                        END

                     FETCH next FROM @cur INTO @TaxObjectID
               END
   END
GO


