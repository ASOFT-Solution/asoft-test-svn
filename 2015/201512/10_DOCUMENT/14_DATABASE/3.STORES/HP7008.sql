IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP7008]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[HP7008]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Created by: Pham Thi Phuong Loan, Date: 20/09/2005
---Purpose: In bao cao luong theo thiet lap cua nguoi dung
--Code written by : Luong Bao Anh
/********************************************
'* Edited by: [GS] [Minh Lâm] [02/08/2010]
'********************************************/
--- Edited by Bao Anh	Date: 24/07/2012
--- Purpose: Lay truong PersonalTaxID, Birthday
--- Edited by Bao Anh	Date: 27/11/2012
--- Purpose: Lay truong WorkDate, LeaveDate
--- Edited by Bao Anh	Date: 19/12/2012	Bo sung truong EducationLevelID, EducationLevelName, MajorID, MajorName
--- Edited by Bao Anh	Date: 24/02/2013	Bo @sWHERE trong cau @sSQL_HT3400GA (truong hop @TableName = 'HT3400' va @AmountType = 'GA')
--- Edited by Bao Anh	Date: 11/12/2013	Bo sung truong ShortName, Alias
----- Modified on 18/06/2014 by Le Thi Thu Hien : Bo sung them Thuế TNCN
----- Modified on 08/08/2014 by Bảo Anh : Bổ sung cột thực lãnh và thuế TNCN vào HT7110
--- HP7008 'ltv','BLCHITIET','A01','C08','%','A0101','A0101',6,2014,6,2014,'%'
----- Modified by Thanh Sơn on 21/01/2015: Bổ sug thêm 3 trường tài khoản kết chuyển cho SG Petro

CREATE PROCEDURE [dbo].[HP7008]
       @DivisionID nvarchar(50) ,
       @ReportCode nvarchar(50) ,
       @FromDepartmentID nvarchar(50) ,
       @ToDepartmentID nvarchar(50) ,
       @TeamID nvarchar(50) ,
       @FromEmployeeID nvarchar(50) ,
       @ToEmployeeID nvarchar(50) ,
       @FromMonth int ,
       @FromYear int ,
       @ToMonth int ,
       @ToYear int ,
       @lstPayrollMethodID AS nvarchar(4000)
AS
DECLARE
        @sSQL nvarchar(4000) ,
        @sSQL1 nvarchar(4000) ,
        @cur AS cursor ,
        @PayrollMethodID nvarchar(50) ,
        @Count AS int ,
        @sSQLGroup AS nvarchar(4000) ,
        @Caption AS nvarchar(250) ,
        @AmountType AS nvarchar(50) ,
        @AmountTypeFrom AS nvarchar(50) ,
        @AmountTypeTo AS nvarchar(50) ,
        @Signs AS nvarchar(50) ,
        @OtherAmount AS money ,
        @AmountTypeFromOut AS nvarchar(4000) ,
        @AmountTypeToOut AS nvarchar(4000) ,
        @ColumnID AS int ,
        @IsSerie AS tinyint ,
        @ColumnAmount AS nvarchar(4000) ,
        @FromColumn AS int ,
        @ToColumn AS int ,
        @sGroupBy AS nvarchar(4000) ,
        @sCaption AS nvarchar(4000) ,
        @sColumn AS nvarchar(2000) ,
        @Pos AS int ,
        @Currency AS nvarchar(50) ,
        @Currency1 AS nvarchar(50) ,
        @RateExchange AS money ,
        @IsChangeCurrency AS tinyint ,
        @IsTotal AS tinyint ,
        @sSQL2 AS nvarchar(4000) ,
        @FOrders AS int ,
        @sSQL_HT2400 nvarchar(4000) ,
        @sSQL_HT2460 nvarchar(4000) ,
        @sSQL_HT2401 nvarchar(4000) ,
        @sSQL_HT2402 nvarchar(4000) ,
        @sSQL_HT3400 nvarchar(4000) ,
        @sSQL_HT3400GA nvarchar(4000) ,
        @sSQL_HT0338 NVARCHAR(MAX),
        @TableName nvarchar(4000) ,
        @IsHT2400 tinyint ,
        @IsHT2401 tinyint ,
        @IsHT2402 tinyint ,
        @IsHT3400 tinyint ,
        @IsOT tinyint ,
        @sWHERE nvarchar(4000),
        @NetIncomeMethod int,
        @sSQL_Total nvarchar(4000),
        @sSQL_Tax nvarchar(4000)
		
-----BUOC 1: XAC DINH LOAI TIEN TE MA PHUONG PHAP TINH LUONG SU DUNG			

SET @PayrollMethodID = CASE
                            WHEN @lstPayrollMethodID = '%' THEN ' like ''' + @lstPayrollMethodID + ''''
                            ELSE ' in (''' + replace(@lstPayrollMethodID , ',' , ''',''') + ''')'
                       END
SET @Pos = PATINDEX('%,%' , @PayrollMethodID)

IF @Pos <> 0 OR @lstPayrollMethodID = '%'
   BEGIN-----neu in theo nhieu PP tinh luong 
         SELECT
             @RateExchange = 1 ,
             @Currency = 'VND' ,
             @Currency1 = 'USD'
   END
ELSE
   BEGIN
         SELECT
             @RateExchange = IsNull(RateExchange , 1)
         FROM
             HT0000
         WHERE
             DivisionID = @DivisionID
         SELECT
             @Currency = CurrencyID
         FROM
             HT5000
         WHERE
             PayrollMethodID = @lstPayrollMethodID And DivisionID = @DivisionID
         IF @Currency = 'VND'
            BEGIN
                  SET @Currency1 = 'USD'
            END
         ELSE
            BEGIN
                  SET @Currency1 = 'VND'
            END

   END
SELECT
    @sSQL = '' ,
    @sColumn = ''
SELECT
    @Count = Max(ColumnID)
FROM
    HT4712
WHERE
    ReportCode = @ReportCode
    And DivisionID = @DivisionID

----------BUOC 2: XAC DINH CO NHOM THEO PHONG BAN, TO NHOM HAY KHONG

SET @sSQL1 = ' Select T00.DivisionID, T00.DepartmentID,  T01.DepartmentName, IsNull(T00.TeamID,'''') as TeamID, 
				 IsNull(T11.TeamName,'''') as TeamName,
				T00.EmployeeID, T00.FullName, HV1400.IdentifyCardNo, HV1400.BankID, HT1008.BankName, HV1400.BankAccountNo,	
				IsNull(T00.DutyID,'''') as DutyID,
				 IsNull(DutyName,'''')   AS DutyName, T00.Orders, 0 as Groups, sum(Isnull(SA01,0)) as BaseSalary,
				 HV1400.Birthday, HV1400.PersonalTaxID, HV1400.WorkDate, HV1400.LeaveDate,
				 HV1400.EducationLevelID, HV1400.EducationLevelName, HV1400.MajorID, HT1004.MajorName, HV1400.ShortName, HV1400.Alias,
				 HV1400.ExpenseAccountID, HV1400.PayableAccountID, HV1400.PerInTaxID, T00.TranMonth, T00.TranYear'

SET @sGroupBy = ' Group by T00.DivisionID, T00.DepartmentID,  T01.DepartmentName,  IsNull(T11.TeamName,''''), T00.EmployeeID, T00.Fullname,
			HV1400.IdentifyCardNo, HV1400.BankID, HT1008.BankName, HV1400.BankAccountNo,	
			 IsNull(T00.TeamID,''''), IsNull(T00.DutyID,'''') , IsNull(DutyName,''''), T00.Orders, HV1400.Birthday, HV1400.PersonalTaxID,
			 HV1400.WorkDate, HV1400.LeaveDate, HV1400.EducationLevelID, HV1400.EducationLevelName, HV1400.MajorID, HT1004.MajorName, HV1400.ShortName, HV1400.Alias,
			  HV1400.ExpenseAccountID, HV1400.PayableAccountID, HV1400.PerInTaxID, T00.TranMonth, T00.TranYear'


SET @sSQL2 = ' From HV3400 T00 left join AT1102 T01 on T01.DivisionID = T00.DivisionID and T01.DepartmentID = T00.DepartmentID 
	left join HT1101 T11 on T11.DivisionID = T00.DivisionID and T11.DepartmentID = T00.DepartmentID and IsNull(T00.TeamID,'''')=IsNull(T11.TeamID,'''')
	left join HV1400 on HV1400.EmployeeID = T00.EmployeeID And HV1400.DivisionID = T00.DivisionID
	left join HT1008 on HV1400.BankID = HT1008.BankID AND HV1400.DivisionID = HT1008.DivisionID
	left join HT1004 on HV1400.DivisionID = HT1004.DivisionID And HV1400.MajorID = HT1004.MajorID
	Where T00.DivisionID = ''' + @DivisionID + ''' and
	T00.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
	isnull(T00.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
	T00.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
	T00.TranMonth + T00.TranYear*100 between ' + CAST(@FromMonth + @FromYear * 100 AS nvarchar(10)) + ' and ' + CAST(@ToMonth + @ToYear * 100 AS nvarchar(10)) + ' and
	PayrollMethodID ' + @PayrollMethodID


IF EXISTS ( SELECT
                *
            FROM
                sysobjects
            WHERE
                name = 'HT7110' AND xtype = 'U' )
   BEGIN
         IF NOT EXISTS ( SELECT
                             *
                         FROM
                             syscolumns col INNER JOIN sysobjects tab
                         ON  col.id = tab.id
                         WHERE
                             tab.name = 'HT7110' AND col.name = 'ColumnAmount50' )
            BEGIN
                  DROP TABLE HT7110
            END
   END

IF NOT EXISTS ( SELECT TOP 1
                    1
                FROM
                    SysObjects
                WHERE
                    Name = 'HT7110' AND Xtype = 'U' )
   BEGIN
         CREATE TABLE [dbo].[HT7110]
         (
           [ID] [int] IDENTITY(1,1)
                      PRIMARY KEY ,
           [STT] [int] NULL ,
           [DivisionID] [nvarchar](50) NULL ,
           [DepartmentID] [nvarchar](50) NULL ,
           [DepartmentName] [nvarchar](250) NULL ,
           [TeamID] [nvarchar](50) NULL ,
           [TeamName] [nvarchar](250) NULL ,
           [EmployeeID] [nvarchar](50) NOT NULL ,
           [FullName] [nvarchar](250) NULL ,
           [IdentifyCardNo] [nvarchar](50) NULL ,
           [BankID] [nvarchar](50) NULL ,
           [BankName] [nvarchar](250) NULL ,
           [BankAccountNo] [nvarchar](50) NULL ,
           [DutyID] [nvarchar](50) NULL ,
           [DutyName] [nvarchar](250) NULL ,
           [Orders] [int] NULL ,
           [Groups] [tinyint] NULL ,
           [BaseSalary] decimal(28,8) NULL ,
           [ColumnAmount01] decimal(28,8) NULL ,
           [ColumnAmount02] decimal(28,8) NULL ,
           [ColumnAmount03] decimal(28,8) NULL ,
           [ColumnAmount04] decimal(28,8) NULL ,
           [ColumnAmount05] decimal(28,8) NULL ,
           [ColumnAmount06] decimal(28,8) NULL ,
           [ColumnAmount07] decimal(28,8) NULL ,
           [ColumnAmount08] decimal(28,8) NULL ,
           [ColumnAmount09] decimal(28,8) NULL ,
           [ColumnAmount10] decimal(28,8) NULL ,
           [ColumnAmount11] decimal(28,8) NULL ,
           [ColumnAmount12] decimal(28,8) NULL ,
           [ColumnAmount13] decimal(28,8) NULL ,
           [ColumnAmount14] decimal(28,8) NULL ,
           [ColumnAmount15] decimal(28,8) NULL ,
           [ColumnAmount16] decimal(28,8) NULL ,
           [ColumnAmount17] decimal(28,8) NULL ,
           [ColumnAmount18] decimal(28,8) NULL ,
           [ColumnAmount19] decimal(28,8) NULL ,
           [ColumnAmount20] decimal(28,8) NULL ,
           [ColumnAmount21] decimal(28,8) NULL ,
           [ColumnAmount22] decimal(28,8) NULL ,
           [ColumnAmount23] decimal(28,8) NULL ,
           [ColumnAmount24] decimal(28,8) NULL ,
           [ColumnAmount25] decimal(28,8) NULL ,
           [ColumnAmount26] decimal(28,8) NULL ,
           [ColumnAmount27] decimal(28,8) NULL ,
           [ColumnAmount28] decimal(28,8) NULL ,
           [ColumnAmount29] decimal(28,8) NULL ,
           [ColumnAmount30] decimal(28,8) NULL ,
           [ColumnAmount31] decimal(28,8) NULL ,
           [ColumnAmount32] decimal(28,8) NULL ,
           [ColumnAmount33] decimal(28,8) NULL ,
           [ColumnAmount34] decimal(28,8) NULL ,
           [ColumnAmount35] decimal(28,8) NULL ,
           [ColumnAmount36] decimal(28,8) NULL ,
           [ColumnAmount37] decimal(28,8) NULL ,
           [ColumnAmount38] decimal(28,8) NULL ,
           [ColumnAmount39] decimal(28,8) NULL ,
           [ColumnAmount40] decimal(28,8) NULL ,
           [ColumnAmount41] decimal(28,8) NULL ,
           [ColumnAmount42] decimal(28,8) NULL ,
           [ColumnAmount43] decimal(28,8) NULL ,
           [ColumnAmount44] decimal(28,8) NULL ,
           [ColumnAmount45] decimal(28,8) NULL ,
           [ColumnAmount46] decimal(28,8) NULL ,
           [ColumnAmount47] decimal(28,8) NULL ,
           [ColumnAmount48] decimal(28,8) NULL ,
           [ColumnAmount49] decimal(28,8) NULL ,
           [ColumnAmount50] decimal(28,8) NULL ,
           [Birthday] DATETIME NULL,	
           [PersonalTaxID] NVARCHAR(50) NULL,
           [WorkDate] datetime NULL,
           [LeaveDate] datetime NULL,
           [EducationLevelID] nvarchar(50) NULL,
		   [EducationLevelName] nvarchar(250) NULL,
		   [MajorID] NVARCHAR(50) NULL,
		   [MajorName] NVARCHAR(250) NULL,
		   [ShortName] NVARCHAR(50) NULL,
		   [Alias] NVARCHAR(50) NULL,
		   [Total] decimal(28,8),
		   [TaxAmount] decimal(28,8),
		   [ExpenseAccountID] VARCHAR(50),
		   [PayableAccountID] VARCHAR(50),
		   [PerInTaxID] VARCHAR(50)
         )
         ON     [PRIMARY]
   END
ELSE
   BEGIN
         DELETE
                 HT7110
         DBCC CHECKIDENT ( HT7110,RESEED,0 )
   END
EXEC ( 'Insert into HT7110  ( DivisionID,DepartmentID, DepartmentName, TeamID, TeamName, EmployeeID, FullName, IdentifyCardNo, BankID, BankName, BankAccountNo, 
				DutyID, DutyName, Orders, Groups, BaseSalary, Birthday, PersonalTaxID, WorkDate, LeaveDate, EducationLevelID, EducationLevelName, MajorID, MajorName,
				ShortName, Alias, ExpenseAccountID, PayableAccountID, PerInTaxID, TranMonth, TranYear)
				'+@sSQL1+@sSQL2+@sGroupBy)

IF NOT EXISTS ( SELECT TOP 1
                    1
                FROM
                    HT7110 Where DivisionID = @DivisionID)
   BEGIN
         INSERT INTO
             HT7110
             (
               DivisionID ,
               DepartmentID ,
               DepartmentName ,
               TeamID ,
               TeamName ,
               EmployeeID ,
               FullName ,
               IdentifyCardNo ,
               BankID ,
               BankName ,
               BankAccountNo ,
               DutyID ,
 DutyName ,
               Orders ,
               Groups ,
               BaseSalary,
               Birthday,
               PersonalTaxID,
               WorkDate,
               LeaveDate,
               EducationLevelID,
               EducationLevelName,
               MajorID,
               MajorName,
               ShortName,
               Alias)
             SELECT
                 HT2400.DivisionID ,
                 HT2400.DepartmentID ,
                 AT1102.DepartmentName ,
                 HT2400.TeamID ,
                 HT1101.TeamName ,
                 HT2400.EmployeeID ,
                 HV1400.FullName ,
                 HV1400.IdentifyCardNo ,
                 HV1400.BankID ,
                 HT1008.BankName ,
                 HV1400.BankAccountNo ,
                 HV1400.DutyID ,
                 HV1400.DutyName ,
                 HV1400.Orders ,
                 0 AS Groups ,
                 HT2400.BaseSalary,
                 HV1400.Birthday,
                 HV1400.PersonalTaxID,
                 HV1400.WorkDate,
                 HV1400.LeaveDate,
                 HV1400.EducationLevelID,
                 HV1400.EducationLevelName,
                 HV1400.MajorID,
                 HT1004.MajorName,
                 HV1400.ShortName,
                 HV1400.Alias
             FROM
                 HT2400 INNER JOIN HV1400
             ON  HV1400.EmployeeID = HT2400.EmployeeID AND HV1400.DivisionID = HT2400.DivisionID INNER JOIN AT1102
             ON  AT1102.DivisionID = HT2400.DivisionID AND AT1102.DepartmentID = HT2400.DepartmentID INNER JOIN HT1101
             ON  HT1101.DivisionID = HT2400.DivisionID AND HT1101.DepartmentID = HT2400.DepartmentID AND HT2400.TeamID = HT1101.TeamID LEFT JOIN HT1008
             ON  HV1400.BankID = HT1008.BankID AND HV1400.DivisionID = HT1008.DivisionID left join HT1004
             ON HV1400.DivisionID = HT1004.DivisionID And HV1400.MajorID = HT1004.MajorID
             WHERE
                 HT2400.DivisionID = @DivisionID AND HT2400.DepartmentID BETWEEN @FromDepartmentID AND @ToDepartmentID AND isnull(HT2400.TeamID , '') LIKE isnull(@TeamID , '') AND HT2400.EmployeeID BETWEEN @FromEmployeeID AND @ToEmployeeID AND HT2400.TranMonth + HT2400.TranYear * 100 BETWEEN CAST(@FromMonth + @FromYear * 100 AS nvarchar(10)) AND CAST(@ToMonth + @ToYear * 100 AS nvarchar(10))
   END 
	
----------------------BUOC 3: FETCH TUNG COT TRONG HT4712 DE TINH TOAN

SELECT
    @sCaption = '' ,
    @IsHT2400 = 0 ,
    @IsHT2401 = 0 ,
    @IsHT2402 = 0 ,
    @IsHT3400 = 0 ,
    @IsOT = 0 ,
    @sSQL_HT3400 = '' ,
    @sSQL_HT3400GA = ''


SET @cur = CURSOR SCROLL KEYSET FOR SELECT
                                        ColumnID ,
                                        FOrders ,
                                        Caption ,
                                        isnull(AmountType , '') AS AmountType ,
                                        isnull(AmountTypeFrom , '') AS AmountTypeFrom ,
                                        isnull(AmountTypeTo , '') AS AmountTypeTo ,
                                        Signs ,
                                        IsNull(IsSerie , 0) AS IsSerie ,
                                        isnull(OtherAmount , 0) ,
                                        IsNull(IsChangeCurrency , 0) AS IsChangeCurrency,
                                        Isnull(NetIncomeMethod, 0) as NetIncomeMethod
                                    FROM
                                        HT4712
                                    WHERE
                                        ReportCode = @ReportCode AND DivisionID = @DivisionID AND IsNull(IsTotal , 0) = 0
ORDER BY
                                        ColumnID


OPEN @cur
FETCH NEXT FROM @cur INTO @ColumnID,@FOrders,@Caption,@AmountType,@AmountTypeFrom,@AmountTypeTo,@Signs,@IsSerie,@OtherAmount,@IsChangeCurrency, @NetIncomeMethod
WHILE @@Fetch_Status = 0
      BEGIN

            IF @AmountType <> 'OT'  ----so lieu khong phai la Khac							

               BEGIN               
                     EXEC HP4700 @DivisionID ,@AmountTypeFrom , @AmountType , @lstPayrollMethodID , @AmountTypeFromOut  OUTPUT, @TableName OUTPUT , @sWHERE OUTPUT
                     EXEC HP4700 @DivisionID ,@AmountTypeTo , @AmountType , @lstPayrollMethodID , @AmountTypeToOut OUTPUT , @TableName OUTPUT , @sWHERE OUTPUT                 
                     EXEC HP4701 @DivisionID ,@AmountTypeFromOut , @AmountTypeToOut , @Signs , @IsSerie , @IsChangeCurrency , @Currency , @Currency1 , @RateExchange , @ColumnAmount OUTPUT


                     IF @TableName = 'HT2400'
                        BEGIN
                              SET @sSQL_HT2400 = '
                              Update HT7110 
                              Set ColumnAmount' + ( CASE WHEN @FOrders < 10 THEN '0' ELSE ''END ) + ltrim(rtrim(str(@FOrders))) + '=  A
			 From HT7110 
			 left  join (Select DivisionID, DepartmentID, isnull(TeamID, '''') as TeamID,  EmployeeID,
						sum(' + @ColumnAmount + ') as A 
			From HT2400  HV3400
			Where HV3400.DivisionID = ''' + @DivisionID + ''' and
				HV3400.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
				isnull(HV3400.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
				HV3400.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
				HV3400.TranMonth + HV3400.TranYear*100 between ' + CAST(@FromMonth + @FromYear * 100 AS nvarchar(10)) + ' and ' + CAST(@ToMonth + @ToYear * 100 AS nvarchar(10)) + ' 
				Group by DivisionID, DepartmentID, isnull(TeamID, ''''), EmployeeID)	HV3400 on HT7110.DivisionID=HV3400.DivisionID and 
				HT7110.DepartmentID=HV3400.DepartmentID and 
				isnull(HT7110.TeamID,'''')=isnull(HV3400.TeamID,'''') and 
				HT7110.EmployeeID = HV3400.EmployeeID'
                              EXEC ( @sSQL_HT2400 )

                        END
                     ELSE
                        BEGIN
                              IF @TableName = 'HT2460'
                                 BEGIN
                                       SET @sSQL_HT2460 = 'Update HT7110 Set 
			ColumnAmount' + ( CASE
                                                                                                         WHEN @FOrders < 10 THEN '0'
                                                                                                         ELSE ''
                                                                                                    END ) + ltrim(rtrim(str(@FOrders))) + '=  A
			 From HT7110 left  join (Select DivisionID, DepartmentID, isnull(TeamID, '''') as TeamID,  EmployeeID,
			sum(' + @ColumnAmount + ') as A 
			From HT2460  HV3400
			Where HV3400.DivisionID = ''' + @DivisionID + ''' and
				HV3400.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
				isnull(HV3400.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
				HV3400.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
				HV3400.TranMonth + HV3400.TranYear*100 between ' + CAST(@FromMonth + @FromYear * 100 AS nvarchar(10)) + ' and ' + CAST(@ToMonth + @ToYear * 100 AS nvarchar(10)) + ' 
				Group by DivisionID, DepartmentID, isnull(TeamID, ''''), EmployeeID)	HV3400 on HT7110.DivisionID=HV3400.DivisionID and 
				HT7110.DepartmentID=HV3400.DepartmentID and 
				isnull(HT7110.TeamID,'''')=isnull(HV3400.TeamID,'''') and 
				HT7110.EmployeeID = HV3400.EmployeeID'
                                       EXEC ( @sSQL_HT2460 )

                                 END
                              ELSE
                                 BEGIN
                                       IF @TableName = 'HT2401'
                                          BEGIN
                                                SET @sSQL_HT2401 = 'Update HT7110 Set ColumnAmount' + ( CASE
                                                                                                             WHEN @FOrders < 10 THEN '0'
                                                                                                             ELSE ''
                                                                                                        END ) + ltrim(rtrim(str(@FOrders))) + '=' + @ColumnAmount + ' 
					 From HT7110 left  join (Select EmployeeID, DivisionID, DepartmentID, isnull(TeamID,'''') as TeamID,
						sum(isnull(AbsentAmount, 0)) as AbsentAmount
					From HT2401 HV3400
					Where AbsentTypeID between ''' + @AmountTypeFrom + ''' and ''' + @AmountTypeTo + ''' and 
						HV3400.DivisionID = ''' + @DivisionID + ''' and
						HV3400.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
						isnull(HV3400.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
						HV3400.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
						HV3400.TranMonth + HV3400.TranYear*100 between ' + CAST(@FromMonth + @FromYear * 100 AS nvarchar(10)) + ' and ' + CAST(@ToMonth + @ToYear * 100 AS nvarchar(10)) + '
					Group by HV3400.DivisionID, HV3400.DepartmentID, isnull(HV3400.TeamID, ''''), HV3400.EmployeeID) HV3400 on 
						HT7110.DivisionID=HV3400.DivisionID and 
						HT7110.DepartmentID=HV3400.DepartmentID
						and IsNull(HT7110.TeamID,'''')=IsNull(HV3400.TeamID,'''') and 
						IsNull(HT7110.EmployeeID,'''')=IsNull(HV3400.EmployeeID,'''')'
                                                EXEC ( @sSQL_HT2401 )
                                          END
                                       ELSE
                                          BEGIN
                                                IF @TableName = 'HT2402'
                                                   BEGIN
                                                         SET @sSQL_HT2402 = 'Update HT7110 Set ColumnAmount' + ( CASE
                                                                                                                      WHEN @FOrders < 10 THEN '0'
                                                                                                                      ELSE ''
                                                                                                                 END ) + ltrim(rtrim(str(@FOrders))) + '=' + @ColumnAmount + ' 
					 From HT7110 left  join (Select EmployeeID, DivisionID, DepartmentID, isnull(TeamID,'''') as TeamID,
						sum(isnull(AbsentAmount, 0)) as AbsentAmount
					From HT2402 HV3400
					Where AbsentTypeID between ''' + @AmountTypeFrom + ''' and ''' + @AmountTypeTo + ''' and 
						HV3400.DivisionID = ''' + @DivisionID + ''' and
						HV3400.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
						isnull(HV3400.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
						HV3400.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
						HV3400.TranMonth + HV3400.TranYear*100 between ' + CAST(@FromMonth + @FromYear * 100 AS nvarchar(10)) + ' and ' + CAST(@ToMonth + @ToYear * 100 AS nvarchar(10)) + '
					Group by HV3400.DivisionID, HV3400.DepartmentID, isnull(HV3400.TeamID, ''''), HV3400.EmployeeID) HV3400 on 
						HT7110.DivisionID=HV3400.DivisionID and 
						HT7110.DepartmentID=HV3400.DepartmentID
						and IsNull(HT7110.TeamID,'''')=IsNull(HV3400.TeamID,'''') and 
						IsNull(HT7110.EmployeeID,'''')=IsNull(HV3400.EmployeeID,'''')'
                                                         EXEC ( @sSQL_HT2402 )

                                                   END
                                                ELSE
													BEGIN
                                                         IF @TableName = 'HT3400' AND @AmountType = 'GA'
                                                            BEGIN
                                                                  SET @sSQL_HT3400GA = 'Update HT7110 Set 
							ColumnAmount' + ( CASE
                                                                                                                                          WHEN @FOrders < 10 THEN '0'
                                                                                                                                          ELSE ''
                                                                                                                                     END ) + ltrim(rtrim(str(@FOrders))) + '=' + @ColumnAmount + '
					 	From HT7110 left  join HT3400 HV3400 on HT7110.DivisionID=HV3400.DivisionID and 
						HT7110.DepartmentID=HV3400.DepartmentID
						and IsNull(HT7110.TeamID,'''')=IsNull(HV3400.TeamID,'''') and 
						IsNull(HT7110.EmployeeID,'''')=IsNull(HV3400.EmployeeID,'''')
						Where HV3400.DivisionID = ''' + @DivisionID + ''' and
						HV3400.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
						isnull(HV3400.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
						HV3400.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
						HV3400.TranMonth + HV3400.TranYear*100 between ' + CAST(@FromMonth + @FromYear * 100 AS nvarchar(10)) + ' and ' + CAST(@ToMonth + @ToYear * 100 AS nvarchar(10)) + '  and
						PayrollMethodID ' + @PayrollMethodID ---+ @sWHERE						
                                                                  EXEC ( @sSQL_HT3400GA )
                                                            END
                                                         ELSE
                                                            BEGIN
                                                                  IF @TableName = 'HT3400'
                                                                     BEGIN
                                                                           SET @sSQL_HT3400 = 'Update HT7110 Set 
							ColumnAmount' + ( CASE
                                                                                                                                                 WHEN @FOrders < 10 THEN '0'
                                                                                                                                                 ELSE ''
                                                                                                                                            END ) + ltrim(rtrim(str(@FOrders))) + '=  A
					 	From HT7110 left  join (Select DivisionID, DepartmentID, isnull(TeamID, '''') as TeamID,  EmployeeID,
						sum(' + @ColumnAmount + ') as A 
						From HT3400  HV3400
						Where HV3400.DivisionID = ''' + @DivisionID + ''' and
						HV3400.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
						isnull(HV3400.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and
						HV3400.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
						HV3400.TranMonth + HV3400.TranYear*100 between ' + CAST(@FromMonth + @FromYear * 100 AS nvarchar(10)) + ' and ' + CAST(@ToMonth + @ToYear * 100 AS nvarchar(10)) + '  and
						PayrollMethodID ' + @PayrollMethodID + @sWHERE + '
						Group by DivisionID, DepartmentID, isnull(TeamID, ''''), EmployeeID)	HV3400 on HT7110.DivisionID=HV3400.DivisionID and 
						HT7110.DepartmentID=HV3400.DepartmentID and 
						isnull(HT7110.TeamID,'''')=isnull(HV3400.TeamID,'''') and 
						HT7110.EmployeeID = HV3400.EmployeeID'
                                                                           EXEC ( @sSQL_HT3400 )
                                                                     END
                                                            END
                                                   END
                                          END
                                 END
                                 IF @TableName = 'HT0338' --- Thuế TNCN                            
                                 BEGIN
                                 	SET @sSQL_HT0338 = '
                                 	UPDATE HT7110 
                                 	SET ColumnAmount' + ( CASE WHEN @FOrders < 10 THEN '0' ELSE '' END ) + ltrim(rtrim(str(@FOrders))) + '=  VAT
					 				FROM HT7110 
					 				LEFT  JOIN (SELECT	DivisionID, EmployeeID,
														SUM(' + @ColumnAmount + ') AS VAT
												FROM	HT0338  HT0338
												WHERE	HT0338.DivisionID = ''' + @DivisionID + ''' and
														HT0338.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
														HT0338.TranMonth + HT0338.TranYear*100 between ' + CAST(@FromMonth + @FromYear * 100 AS nvarchar(10)) + ' and ' + CAST(@ToMonth + @ToYear * 100 AS nvarchar(10)) + ' 
														' + @sWHERE + '
												GROUP BY DivisionID, EmployeeID
					 							) HT0338 
					 					ON		HT7110.DivisionID = HT0338.DivisionID AND 
												HT7110.EmployeeID = HT0338.EmployeeID '
                                                                           EXEC ( @sSQL_HT0338 )
                                 END
                        END


               END
            ELSE	----- @AmountType = 'OT'  , so lieu la khac thi lay hang so la so lieu cua mot cot
               BEGIN
                     IF @IsOT = 0
                        BEGIN
                              SELECT
                                  @IsOT = 1 ,
                                  @sSQL = 'Update HT7110 Set '
                        END
                     SET @sSQL = @sSQL + 'ColumnAmount' + ( CASE
                                                                 WHEN @FOrders < 10 THEN '0'
                                                                 ELSE ''
                                                            END ) + ltrim(rtrim(str(@FOrders))) + '=' + ' IsNull(' + str(@OtherAmount) + ',0) ' + ','

               END
			
			--- Update thực lãnh
			IF Isnull(@NetIncomeMethod,0) = 1
				SET @sSQL_Total = 'UPDATE HT7110 Set Total = Isnull(Total,0) + ColumnAmount' + ( CASE
                                                                 WHEN @FOrders < 10 THEN '0'
                                                                 ELSE ''
                                                            END ) + ltrim(rtrim(str(@FOrders)))
			ELSE IF Isnull(@NetIncomeMethod,0) = 2
				SET @sSQL_Total = 'UPDATE HT7110 Set Total = Isnull(Total,0) - ColumnAmount' + ( CASE
                                                                 WHEN @FOrders < 10 THEN '0'
                                                                 ELSE ''
                                                            END ) + ltrim(rtrim(str(@FOrders)))
            ELSE
				SET @sSQL_Total = ''
            
            EXEC(@sSQL_Total)
           
            --- Update thuế TNCN
            IF @AmountType = 'TA'
            BEGIN
				SET @sSQL_Tax = 'UPDATE HT7110 Set TaxAmount = ColumnAmount' + ( CASE
                                                                 WHEN @FOrders < 10 THEN '0'
                                                                 ELSE ''
                                                            END ) + ltrim(rtrim(str(@FOrders)))
				EXEC(@sSQL_Tax)                                        
			END
           
            FETCH NEXT FROM @cur INTO @ColumnID,@FOrders,@Caption,@AmountType,@AmountTypeFrom,@AmountTypeTo,@Signs,@IsSerie,@OtherAmount,@IsChangeCurrency, @NetIncomeMethod

      END
CLOSE @cur
IF @IsOT = 1
   BEGIN

         SET @sSQL = LEFT(@sSQL , len(@sSQL) - 1)
         SET @sSQL = @sSQL + ' From HT7110 left  join HV3400 on HT7110.DivisionID=HV3400.DivisionID and HT7110.DepartmentID=HV3400.DepartmentID
	and IsNull(HT7110.TeamID,'''')=IsNull(HV3400.TeamID,'''') and IsNull(HT7110.EmployeeID,'''')=IsNull(HV3400.EmployeeID,'''')
	Where HV3400.DivisionID = ''' + @DivisionID + ''' and
			HV3400.DepartmentID between ''' + @FromDepartmentID + ''' and ''' + @ToDepartmentID + ''' and
			isnull(HV3400.TeamID,'''') like isnull(''' + @TeamID + ''', '''') and

			HV3400.EmployeeID between ''' + @FromEmployeeID + ''' and ''' + @ToEmployeeID + ''' and
			HV3400.TranMonth + HV3400.TranYear*100 between ' + CAST(@FromMonth + @FromYear * 100 AS nvarchar(10)) + ' and ' + CAST(@ToMonth + @ToYear * 100 AS nvarchar(10)) + ' and
			PayrollMethodID ' + @PayrollMethodID
         EXEC ( @sSQL )
   END


---------Neu co tinh tong 



IF EXISTS ( SELECT TOP 1
                1
            FROM
                HT4712
            WHERE
                IsNull(IsTotal , 0) = 1 AND ReportCode = @ReportCode And DivisionID = @DivisionID )
   BEGIN

         SET @sSQL = 'Update HT7110 Set '

         SET @cur = CURSOR SCROLL KEYSET FOR SELECT
                                                 ColumnID ,
                                                 FOrders ,
                                                 Caption ,
                                                 Signs ,
                                                 IsNull(IsSerie , 0) AS IsSerie ,
                                                 FromColumn ,
                                                 ToColumn
                                             FROM
                                                 HT4712
                                             WHERE
                                                 DivisionID = @DivisionID and ReportCode = @ReportCode AND IsNull(IsTotal , 0) = 1
         ORDER BY
                                                 ColumnID
         OPEN @cur
         FETCH NEXT FROM @cur INTO @ColumnID,@FOrders,@Caption,@Signs,@IsSerie,@FromColumn,@ToColumn
         WHILE @@Fetch_Status = 0
               BEGIN               
                     EXEC HP4702 @Signs , @IsSerie , @FromColumn , @ToColumn , @ColumnAmount OUTPUT , @ColumnID              
                     SET @sSQL = @sSQL + 'ColumnAmount' + ( CASE
                                                                 WHEN @FOrders < 10 THEN '0'
                                                                 ELSE ''
                                                            END ) + ltrim(rtrim(str(@FOrders))) + '=' + @ColumnAmount -- + ','
           
                    EXEC ( @sSQL )
                     SET @sSQL = 'Update HT7110 Set '
                     FETCH NEXT FROM @cur INTO @ColumnID,@FOrders,@Caption,@Signs,@IsSerie,@FromColumn,@ToColumn
                    
               END
         CLOSE @cur
   END
DELETE
        HT7110
WHERE
        isnull(ColumnAmount01 , 0) = 0 AND isnull(ColumnAmount02 , 0) = 0 AND isnull(ColumnAmount03 , 0) = 0 AND isnull(ColumnAmount04 , 0) = 0 AND isnull(ColumnAmount05 , 0) = 0 AND isnull(ColumnAmount06 , 0) = 0 AND isnull(ColumnAmount07 , 0) = 0 AND isnull(ColumnAmount08 , 0) = 0 AND isnull(ColumnAmount09 , 0) = 0 AND isnull(ColumnAmount10 , 0) = 0 AND isnull(ColumnAmount11 , 0) = 0 AND isnull(ColumnAmount12 , 0) = 0 AND isnull(ColumnAmount13 , 0) = 0 AND isnull(ColumnAmount14 , 0) = 0 AND isnull(ColumnAmount15 , 0) = 0 AND isnull(ColumnAmount16 , 0) = 0 AND isnull(ColumnAmount17 , 0) = 0 AND isnull(ColumnAmount18 , 0) = 0 AND isnull(ColumnAmount19 , 0) = 0 AND isnull(ColumnAmount20 , 0) = 0 AND isnull(ColumnAmount21 , 0) = 0 AND isnull(ColumnAmount22 , 0) = 0 AND isnull(ColumnAmount23 , 0) = 0 AND isnull(ColumnAmount24 , 0) = 0 AND isnull(ColumnAmount25 , 0) = 0 AND isnull(ColumnAmount26 , 0) = 0 AND isnull(ColumnAmount27 , 0) = 0 AND isnull(ColumnAmount28 , 0) = 0 AND isnull(ColumnAmount29 , 0) = 0 AND isnull(ColumnAmount30 , 0) = 0 AND isnull(ColumnAmount31 , 0) = 0 AND isnull(ColumnAmount32 , 0) = 0 AND isnull(ColumnAmount33 , 0) = 0 AND isnull(ColumnAmount34 , 0) = 0 AND isnull(ColumnAmount35 , 0) = 0 AND isnull(ColumnAmount36 , 0) = 0 AND isnull(ColumnAmount37 , 0) = 0 AND isnull(ColumnAmount38 , 0) = 0 AND isnull(ColumnAmount39 , 0) = 0 AND isnull(ColumnAmount40 , 0) = 0 AND isnull(ColumnAmount41 , 0) = 0 AND isnull(ColumnAmount42 , 0) = 0 AND isnull(ColumnAmount43 , 0) = 0 AND isnull(ColumnAmount44 , 0) = 0 AND isnull(ColumnAmount45 , 0) = 0 AND isnull(ColumnAmount46 , 0) = 0 AND isnull(ColumnAmount47 , 0) = 0 AND isnull(ColumnAmount48 , 0) = 0 AND isnull(ColumnAmount49 , 0) = 0 AND isnull(ColumnAmount50 , 0) = 0

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
