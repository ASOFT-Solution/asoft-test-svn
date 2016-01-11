
/****** Object:  StoredProcedure [dbo].[HP5007]    Script Date: 08/05/2010 10:00:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by:Pham Thi Phuong Loan, date: 01/09/2005
---purpose: Tinh thue thu nhap cho giao vien, ap dung cho SITC ( Tinh tong thu nhap cua GV o tat ca cac chi nhanh,
-- tinh thue thu nhap dua tren muc tong thu nhap do sau do phan bo thue ra cac chi nhanh theo ty le thu nhap cua chi nhanh)
--Cach tinh chua dong bo , se xem xet lai sau
/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP5007]
       @DivisionID AS nvarchar(50) ,
       @TranMonth AS int ,
       @TranYear AS int ,
       @PayrollMethodID AS nvarchar(50) ,
       @DepartmentID1 AS nvarchar(50) ,
       @TeamID1 AS nvarchar(50)
AS
DECLARE
        @sSQL nvarchar(4000) ,
        @sSQL1 AS nvarchar(4000) ,
        @sSQL2 AS nvarchar(4000) ,
        @IsProgressive tinyint ,
        @IsPercentSurtax AS tinyint ,
        @TaxObjectID nvarchar(50) ,
        @cur AS cursor ,
        @RateExchange AS decimal(28,8) ,
        @Currency AS nvarchar(50)
----BUOC 1 Tinh tong thu nhap chiu thue cua GV + thu nhap cua GV theo tung to nhom

--Select @Currency=CurrencyID From HT5000 Where PayrollMethodID=@PayrollMethodID
--If @Currency='VND'
SET @RateExchange = 1
--else
	--Select @RateExchange=RateExchange From HT0000 Where DivisionID=@DivisionID

SET @cur = CURSOR SCROLL KEYSET FOR SELECT DISTINCT
                                        TaxObjectID
                                    FROM
                                        HT2400
                                    WHERE
                                        TranMonth = @TranMonth AND TranYear = @TranYear AND DivisionID = @DivisionID AND DepartmentID LIKE @DepartmentID1 AND isnull(TeamID , '') <> isnull(@TeamID1 , '') AND isnull(TaxObjectID , '') <> ''
                                    AND DivisionID = @DivisionID
OPEN @cur
FETCH next FROM @cur INTO @TaxObjectID
WHILE @@Fetch_Status = 0
      BEGIN
---Tinh tong thu nhap chiu thue roi insert vao bang tam HT5889 va HV5504

            SET @sSQL = 'Select H00.DivisionID,  H00.DepartmentID, H00.EmployeeID, H00.PayrollMethodID, H02.IsTax,
		sum(isnull(case when right(H01.IncomeID,2) = 01 then Income01
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
		else 0 end, 0)) * ' + str(@RateExchange) + '  as IncomeAmount, 0 as SubAmount   	
	From HT3400  H00 inner join HT5005 H01 on H00.PayrollMethodID = H01.PayrollMethodID AND H00.DivisionID = H01.DivisionID
			inner join HT0002 H02 on H02.IncomeID = H01.IncomeID  AND H02.DivisionID = H01.DivisionID 
			inner join HT2400 H03 on H03.TranMonth = H00.TranMonth and
				H03.TranYear = H00.TranYear and
				H03.DivisionID = H00.DivisionID and
				H03.DepartmentID=H00.DepartmentID and
				IsNull(H03.TeamID,'''') like ISNull(H00.TeamID,'''') and
				H03.EmployeeID = H00.EmployeeID and
				H03.TaxObjectID = ''' + @TaxObjectID + '''
	Where H00.DivisionID = ''' + @DivisionID + ''' and 
		H00.DepartmentID like  ''' + @DepartmentID1 + ''' and 
		H00.PayrollMethodID like ''' + @PayrollMethodID + ''' and 
		H02.IsTax = 1 and
		H00.TranMonth = ' + CAST(@TranMonth AS varchar(10)) + ' and
		H00.TranYear = ' + CAST(@TranYear AS varchar(10)) + ' 
		Group by H00.DivisionID,  H00.DepartmentID, H00.EmployeeID, H00.PayrollMethodID, H02.IsTax
	Union ' 
	

--Cac khoan giam tru
            SET @sSQL1 = ' Select H00.DivisionID,  H00.DepartmentID,  H00.EmployeeID, H00.PayrollMethodID, H02.IsTax,  0 as IncomeAmount,
		sum(isnull(case when right(H01.SubID,2) = 01 then SubAmount01
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
		when right(H01.SubID,2) = 20 then SubAmount20 else 0 end, 0))  * ' + str(@RateExchange) + '  as SubAmount   	
	From HT3400  H00 	inner join HT5006 H01 on H00.PayrollMethodID = H01.PayrollMethodID AND H00.DivisionID = H01.DivisionID
			inner join HT0005 H02 on H01.SubID = H02.SubID  AND H01.DivisionID = H02.DivisionID 
			inner join HT2400 H03 on H03.TranMonth = H00.TranMonth and
				H03.TranYear = H00.TranYear and
				H03.DivisionID = H00.DivisionID and
				H03.DepartmentID=H00.DepartmentID and
				IsNull(H03.TeamID,'''') like ISNull(H00.TeamID,'''') and
				H03.EmployeeID = H00.EmployeeID and
				H03.TaxObjectID = ''' + @TaxObjectID + ''' 
	Where H00.DivisionID = ''' + @DivisionID + ''' and 
		H00.DepartmentID like  ''' + @DepartmentID1 + ''' and 
		H00.PayrollMethodID like ''' + @PayrollMethodID + ''' and 
		H02.IsTax = 1 and
		H00.TranMonth = ' + CAST(@TranMonth AS varchar(10)) + ' and
		H00.TranYear = ' + CAST(@TranYear AS varchar(10)) + '
	Group by H00.DivisionID,  H00.DepartmentID, H00.EmployeeID, H00.PayrollMethodID, H02.IsTax'

--Tinh thu nhap theo tung chi nhanh roi insert vao bang tam HT5890

            SET @sSQL2 = 'Select H00.DivisionID,  H00.DepartmentID, IsNull(H00.TeamID,'''') as TeamID,H00.EmployeeID, H00.PayrollMethodID, 
		(sum(isnull(Income01,0))+ sum(isnull(Income02,0))+sum(isnull(Income03,0))+ sum(isnull(Income04,0))+sum(isnull(Income05,0))+ sum(isnull(Income06,0))+
		sum(isnull(Income07,0))+ sum(isnull(Income08,0))+sum(isnull(Income09,0))+ sum(isnull(Income10,0))+sum(isnull(Income11,0))+ sum(isnull(Income12,0))+
		sum(isnull(Income13,0))+ sum(isnull(Income14,0))+sum(isnull(Income15,0))+ sum(isnull(Income16,0))+sum(isnull(Income17,0))+ sum(isnull(Income18,0))+
		sum(isnull(Income19,0))+ sum(isnull(Income20,0)) -
		(sum(isnull(SubAmount01, 0)) +sum(isnull(SubAmount02, 0)) +sum(isnull(SubAmount03, 0)) +sum(isnull(SubAmount04, 0)) +
		sum(isnull(SubAmount05, 0)) +sum(isnull(SubAmount06, 0)) +sum(isnull(SubAmount07, 0)) +sum(isnull(SubAmount08, 0)) +sum(isnull(SubAmount09, 0)) +sum(isnull(SubAmount10, 0)) +
		sum(isnull(SubAmount11, 0)) +sum(isnull(SubAmount12, 0)) +sum(isnull(SubAmount13, 0)) +sum(isnull(SubAmount14, 0)) +sum(isnull(SubAmount15, 0)) +sum(isnull(SubAmount16, 0)) +
		sum(isnull(SubAmount17, 0)) +sum(isnull(SubAmount18, 0)) +sum(isnull(SubAmount19, 0)) +sum(isnull(SubAmount20, 0)) ) )  as TeamSalary	
	From HT3400  H00 inner join HT2400 H03 on H03.TranMonth = H00.TranMonth and
				H03.TranYear = H00.TranYear and
				H03.DivisionID = H00.DivisionID and
				H03.DepartmentID=H00.DepartmentID and
				IsNull(H03.TeamID,'''')=IsNull(H00.TeamID,'''') and
				H03.EmployeeID = H00.EmployeeID and
				H03.TaxObjectID = ''' + @TaxObjectID + '''
	Where H00.DivisionID = ''' + @DivisionID + ''' and 
		H00.DepartmentID like  ''' + @DepartmentID1 + ''' and 
		H00.TeamID like   ''' + @TeamID1 + ''' and 
		H00.PayrollMethodID like ''' + @PayrollMethodID + ''' and 
		H00.TranMonth = ' + CAST(@TranMonth AS varchar(10)) + ' and
		H00.TranYear = ' + CAST(@TranYear AS varchar(10)) + ' 
	Group by H00.DivisionID,  H00.DepartmentID, IsNull(H00.TeamID,'''') ,H00.EmployeeID, H00.PayrollMethodID ' 


/*If exists(Select Top 1 1 From sysObjects Where Name = 'HV5510' and XType = 'V')
	Drop view HV5510
EXEC('Create view HV5510 ---tao boi HP5007
		as ' + @sSQL2)*/


            IF NOT EXISTS ( SELECT TOP 1
                                1
                            FROM
                                SysObjects
                            WHERE
                                Name = 'HT5890' AND Xtype = 'U' )
               BEGIN
                     CREATE TABLE [dbo].[HT5890]
                     (
                       [DivisionID] [nvarchar](50) NULL ,
                       [DepartmentID] [nvarchar](50) NULL ,
                       [TeamID] [nvarchar](50) NULL ,
                       [EmployeeID] [nvarchar](50) NOT NULL ,
                       [PayrollMethodID] [nvarchar](50) NULL ,
                       [TeamSalary] [decimal](28,8) NULL )
                     ON     [PRIMARY]
               END
            ELSE
               BEGIN
                     DELETE
                             HT5890
               END
            EXEC ( 'Insert into HT5890( DivisionID,  DepartmentID,TeamID,EmployeeID,  PayrollMethodID, TeamSalary)'+@sSQL2 )

/*		H00.TranMonth + 100*H00.TranYear between ' + 
	cast(@FromMonth + @FromYear*100 as varchar(10)) + ' and ' + cast(@ToMonth + @ToYear*100 as varchar(10))   		

*/		

/*

If exists(Select Top 1 1 From sysObjects Where Name = 'HV5509' and XType = 'V')
	Drop view HV5509
EXEC('Create view HV5509 ---tao boi HP5006
		as ' + @sSQL+@sSQL1)*/
		

            IF NOT EXISTS ( SELECT TOP 1
                                1
                            FROM
                                SysObjects
                            WHERE
                                Name = 'HT5889' AND Xtype = 'U' )
               BEGIN

										CREATE TABLE [dbo].[HT5889](
						[APK] [uniqueidentifier] NOT NULL,
						[DivisionID] [nvarchar](3) NULL,
						[DepartmentID] [nvarchar](50) NULL,
						[EmployeeID] [nvarchar](50) NOT NULL,
						[PayrollMethodID] [nvarchar](50) NULL,
						[IsTax] [int] NULL,
						[IncomeAmount] [decimal](28, 8) NULL,
						[SubAmount] [decimal](28, 8) NULL,
						 CONSTRAINT [PK_HT5889] PRIMARY KEY NONCLUSTERED 
						(
							[APK] ASC
						)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
					) ON [PRIMARY]
					
					ALTER TABLE [dbo].[HT5889] ADD  DEFAULT (newid()) FOR [APK]

               END
            ELSE
               BEGIN
                     DELETE
                             HT5889
               END
            EXEC ( 'Insert into HT5889  ( DivisionID,  DepartmentID, EmployeeID,  PayrollMethodID, IsTax, IncomeAmount,  SubAmount)'+@sSQL+@sSQL1 )


---Tinh luong tinh thue thu nhap
            SET @sSQL = 'Select DivisionID, DepartmentID,  EmployeeID, PayrollMethodID, 
		sum(IncomeAmount - SubAmount) as SalaryAmount, sum(IncomeAmount - SubAmount)  as SalaryAmount1
	From HT5889
	WHERE DivisionID = ''' +  @DivisionID + '''
	Group by DivisionID, DepartmentID, EmployeeID, PayrollMethodID'

            IF EXISTS ( SELECT TOP 1
                            1
                        FROM
                            sysObjects
                        WHERE
                            Name = 'HV5504' AND XType = 'V' )
               BEGIN
                     DROP VIEW HV5504
               END
            EXEC ( 'Create view HV5504 ---tao boi HP5007
		as '+@sSQL )

--Tinh thue tren tong luong tung nguoi
            SELECT
                @IsProgressive = IsProgressive ,
                @IsPercentSurtax = IsPercentSurtax
            FROM
                HT1011
            WHERE
                TaxObjectID = @TaxObjectID
            IF @IsProgressive = 1
               BEGIN  ---luy tien	
                     SET @sSQL = 'Select H00.DivisionID, DepartmentID, EmployeeID, PayrollMethodID, SalaryAmount,
			isnull(sum(case when (SalaryAmount > MinSalary and (SalaryAmount <= MaxSalary or MaxSalary = -1))
			then SalaryAmount - MinSalary
			else case when SalaryAmount <= MinSalary then 0 else
			MaxSalary - MinSalary end end* isnull(RateOrAmount,0)/100), 0)   as TaxAmount,
			isnull(max(case when (SalaryAmount > MinSalary and (SalaryAmount <= MaxSalary or MaxSalary = -1))
			then RateOrAmount else 0 end), 0) as TaxRate
			From HV5504 H00 inner join HT1012 H01 on H01.TaxObjectID = ''' + @TaxObjectID + '''	AND H00.DivisionID = H01.DivisionID 
			Group by H00.DivisionID, DepartmentID,  EmployeeID, PayrollMethodID, SalaryAmount'
               END
            ELSE
               BEGIN  ---nac thang
                     SET @sSQL = '	Select H00.DivisionID, DepartmentID, EmployeeID, PayrollMethodID,  SalaryAmount,
			isnull(sum(case when (SalaryAmount > MinSalary and (SalaryAmount <= MaxSalary or MaxSalary = -1))
			then SalaryAmount else 0 end		* isnull(RateOrAmount,0)/100), 0)  as TaxAmount,
			isnull(max(case when (SalaryAmount > MinSalary and (SalaryAmount <= MaxSalary or MaxSalary = -1))
		then RateOrAmount else 0 end), 0) as TaxRate
		From HV5504 H00 inner join HT1012 H01 on H01.TaxObjectID = ''' + @TaxObjectID + ''' AND H00.DivisionID = H01.DivisionID
		Group by H00.DivisionID, DepartmentID,  EmployeeID, PayrollMethodID,  SalaryAmount '
               END


            IF EXISTS ( SELECT TOP 1
                            1
                        FROM
                            sysObjects
                        WHERE
                            Name = 'HV5508' AND Type = 'V' )
               BEGIN
                     DROP VIEW HV5508
               END
            EXEC ( 'Create view HV5508 ---tao boi HP5007
		as '+@sSQL )

            IF @IsPercentSurtax = 1 ---Tinh thue thu nhap bo sung
               BEGIN
                     SET @sSQL = '
		Select DivisionID, DepartmentID, EmployeeID, PayrollMethodID, TaxRate,TaxAmount +
			case when (SalaryAmount - TaxAmount) > IncomeAfterTax then (SalaryAmount - TaxAmount)*RateOrAmount/100 else 0 end  as TaxAmount
		From HV5508 H00 inner join HT1011 H01  on H01.TaxObjectID = ''' + @TaxObjectID + ''' AND H00.DivisionID = H01.DivisionID ' 

                     IF EXISTS ( SELECT TOP 1
                                     1
                                 FROM
                                     sysObjects
                                 WHERE
                                     Name = 'HV5007' AND Type = 'V' )
                        BEGIN
                              DROP VIEW HV5007
                        END
                     EXEC ( 'Create view HV5007 ---tao boi HP5007
		as '+@sSQL )
               END


----BUOC 2 Phan bo thue thu nhap ra tung chi nhanh theo ty le thu nhap 
            IF @IsPercentSurtax = 1
               BEGIN ---Tinh thue thu nhap bo sung
                     SET @sSQL = 'Select H00.DivisionID,  H00.DepartmentID, IsNull(H00.TeamID,'''') as TeamID,H00.EmployeeID, H00.PayrollMethodID, 
	Case H03.SalaryAmount1 When 0 Then HV.TaxAmount*H00.TeamSalary/1 Else HV.TaxAmount*H00.TeamSalary/H03.SalaryAmount1 End 
	 as TaxAmount, TaxRate
	From HT5890 H00 inner join HV5504 H03
		on H00.DivisionID = H03.DivisionID and
			H00.DepartmentID=H03.DepartmentID  and
			H03.EmployeeID = H00.EmployeeID
	Left Join HV5007 HV on H00.DivisionID = HV.DivisionID and
			H00.DepartmentID=HV.DepartmentID  and
			H03.EmployeeID = HV.EmployeeID'
               END
            ELSE
               BEGIN
                     SET @sSQL = 'Select H00.DivisionID,  H00.DepartmentID, IsNull(H00.TeamID,'''') as TeamID,H00.EmployeeID, H00.PayrollMethodID, HV.TaxAmount as a, H00.TeamSalary, H03.SalaryAmount, H03.SalaryAmount1,
	Case H03.SalaryAmount1 When 0 Then HV.TaxAmount*H00.TeamSalary/1 Else HV.TaxAmount*H00.TeamSalary/H03.SalaryAmount1 End 
	 as TaxAmount, TaxRate
	From HT5890 H00 left join HV5504 H03
		on H00.DivisionID = H03.DivisionID and
			H00.DepartmentID=H03.DepartmentID  and
			H03.EmployeeID = H00.EmployeeID
	Left Join HV5508 HV on H00.DivisionID = HV.DivisionID and
			H00.DepartmentID=HV.DepartmentID  and
			H03.EmployeeID = HV.EmployeeID'
               END


            IF EXISTS ( SELECT TOP 1
                            1
                        FROM
                            sysObjects
                        WHERE
                            Name = 'HV5008' AND Type = 'V' )
               BEGIN
                     DROP VIEW HV5008
               END
            EXEC ( 'Create view HV5008 ---tao boi HP5007
		as '+@sSQL )


            UPDATE
                HT3400
            SET
                TaxAmount = H01.TaxAmount ,
                TaxRate = H01.TaxRate
            FROM
                HT3400 H00 INNER JOIN HV5008 H01
                ON H00.DivisionID = H01.DivisionID AND H00.EmployeeID = H01.EmployeeID AND H00.DepartmentID = H01.DepartmentID AND IsNull(H00.TeamID , '') = IsNull(H01.TeamID , '') AND H00.PayrollMethodID = H01.PayrollMethodID AND H00.TranMonth = @TranMonth AND H00.TranYear = @TranYear


            FETCH next FROM @cur INTO @TaxObjectID
      END

CLOSE @cur