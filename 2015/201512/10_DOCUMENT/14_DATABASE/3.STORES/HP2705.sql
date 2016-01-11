/****** Object:  StoredProcedure [dbo].[HP2705]    Script Date: 08/02/2010 14:38:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


--------Quyet toan thue thu nhap ca nhan
--------Created by Le Hoai Minh
--------Date : 03/11/2005

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2705]  @TranYear int,
				@FromMonth int,
				@ToMonth int,
				@DivisionID NVARCHAR(50),
				@DepartmentID NVARCHAR(50),
				@TeamID NVARCHAR(50),
				@EmployeeID NVARCHAR(50),
				@IsYear tinyint		------1 : Quyet toan cuoi nam ,  0 : Quy?t toán theo k?

AS
DECLARE  @FMonth as int,
		@TMonth as int,
		@sSQL as nvarchar(4000),
		@Employ as NVARCHAR(50),
		@NoMonth  as int,--------------So thang quyet toan thue
		@IsPercentSurtax as tinyint,
		@IsProgressive as tinyint,
		@Cur_Tax as cursor,
		@PaidTax as decimal (28, 8),
		@NetAmount as decimal (18,8),
		@SumTax as decimal (28, 8),
		@UnpaidTax as decimal (28, 8),
		@DeductTax as decimal (28, 8),
		@TaxObjectID as NVARCHAR(50),
		@Cur_TaxObjectID as cursor

If @IsYear = 1
begin
	set @FMonth = 1
	set @TMonth = 12
end
else
begin
	set @FMonth = @FromMonth
	set @TMonth = @ToMonth
end
set @NoMonth = (@TMonth - @FMonth) + 1
if  exists (select top 1 1 from HT3400 where DivisionID = @DivisionID and DepartmentID like @DepartmentID and Isnull(TeamID,0) like @TeamID
		and EmployeeID like @EmployeeID and TranMonth in (@FMonth, @TMonth) )
Begin

-----------------Tinh tat ca cac khoan thu nhap, giam tru cua tat ca nhan vien tu FMonth den TMonth

set @sSQL = 'select H01.DivisionID, H01.DepartmentID, H01.TeamID, H01.EmployeeID, H04.TaxObjectID,
		isnull(case when Right(H02.IncomeID,2) = 01 then Income01
				when Right(H02.IncomeID,2) = 02 then Income02
				when Right(H02.IncomeID,2) = 03 then Income03
				when Right(H02.IncomeID,2) = 04 then Income04
				when Right(H02.IncomeID,2) = 05 then Income05
				when Right(H02.IncomeID,2) = 06 then Income06
				when Right(H02.IncomeID,2) = 07 then Income07
				when Right(H02.IncomeID,2) = 08 then Income08
				when Right(H02.IncomeID,2) = 09 then Income09
				when Right(H02.IncomeID,2) = 10 then Income10
				when Right(H02.IncomeID,2) = 11 then Income11
				when Right(H02.IncomeID,2) = 12 then Income12
				when Right(H02.IncomeID,2) = 13 then Income13
				when Right(H02.IncomeID,2) = 14 then Income14
				when Right(H02.IncomeID,2) = 15 then Income15
				when Right(H02.IncomeID,2) = 16 then Income16
				when Right(H02.IncomeID,2) = 17 then Income17
				when Right(H02.IncomeID,2) = 18 then Income18
				when Right(H02.IncomeID,2) = 19 then Income19
				when Right(H02.IncomeID,2) = 20 then Income20
			else 0  end, 0) as IncomeAmount , 0 as SubAmount
		from HT3400 H01 inner join HT5005 H02 on H01.PayrollMethodID = H02.PayrollMethodID And H01.DivisionID = H02.DivisionID
				inner join HT0002 H03 on H02.IncomeID = H03.IncomeID And H02.DivisionID = H03.DivisionID
				inner join HT2400 H04 on H01.DivisionID = H04.DivisionID and H01.DepartmentID = H04.DepartmentID and
				H01.EmployeeID = H04.EmployeeID and H01.TranMonth = H04.TranMonth and H01.TranYear = H04.TranYear
		where H01.DivisionID = '''+@DivisionID+''' and H01.TranMonth in ( ' + cast(@FMonth as nvarchar(10)) + ',' + cast(@TMonth as nvarchar(10)) + ') and
				H01.TranYear = ' +cast(@TranYear as nvarchar(10)) + ' and H03.IsTax = 1 and H01.EmployeeID like '''+@EmployeeID+'''
				and H01.DepartmentID like '''+@DepartmentID+''' and Isnull(H01.TeamID,'''') like '''+@TeamID+'''
union ' +

---------Cac khoan giam tru co tinh vao thue thu nhap

 'select H01.DivisionID, H01.DepartmentID, H01.TeamID,H01.EmployeeID, H04.TaxObjectID,0 as IncomeAmount,
		isnull(case when Right(H02.SubID,2) = 01 then SubAmount01
				when Right(H02.SubID,2) = 02 then SubAmount02
				when Right(H02.SubID,2) = 03 then SubAmount03
				when Right(H02.SubID,2) = 04 then SubAmount04
				when Right(H02.SubID,2) = 05 then SubAmount05
				when Right(H02.SubID,2) = 06 then SubAmount06
				when Right(H02.SubID,2) = 07 then SubAmount07
				when Right(H02.SubID,2) = 08 then SubAmount08
				when Right(H02.SubID,2) = 09 then SubAmount09
				when Right(H02.SubID,2) = 10 then SubAmount10
				when Right(H02.SubID,2) = 11 then SubAmount11
				when Right(H02.SubID,2) = 12 then SubAmount12
				when Right(H02.SubID,2) = 13 then SubAmount13
				when Right(H02.SubID,2) = 14 then SubAmount14
				when Right(H02.SubID,2) = 15 then SubAmount15
				when Right(H02.SubID,2) = 16 then SubAmount16
				when Right(H02.SubID,2) = 17 then SubAmount17
				when Right(H02.SubID,2) = 18 then SubAmount18
				when Right(H02.SubID,2) = 19 then SubAmount19
				when Right(H02.SubID,2) = 20 then SubAmount20
			else 0  end, 0) as SubAmount 
		from HT3400 H01 inner join HT5006 H02 on H01.PayrollMethodID = H02.PayrollMethodID And H01.DivisionID = H02.DivisionID
				inner join HT0005 H03 on H02.SubID = H03.SubID And H02.DivisionID = H03.DivisionID
				inner join HT2400 H04 on H01.DivisionID = H04.DivisionID and H01.DepartmentID = H04.DepartmentID and
				H01.EmployeeID = H04.EmployeeID and H01.TranMonth = H04.TranMonth and H01.TranYear = H04.TranYear
		where H01.DivisionID = '''+@DivisionID+''' and H01.TranMonth in ( ' + cast(@FMonth as nvarchar(10)) + ',' + cast(@TMonth as nvarchar(10)) + ') and 
				H01.TranYear = ' +cast(@TranYear as nvarchar(10)) + ' and H03.IsTax = 1 and H01.EmployeeID like '''+@EmployeeID+'''
				and H01.DepartmentID like '''+@DepartmentID+''' and Isnull(H01.TeamID,'''') like '''+@TeamID+''''

--------print @sSQL
If exists(Select Top 1 1 From sysObjects Where Name = 'HV2707' and Type = 'V')
	Drop view HV2707
EXEC('Create view HV2707 ---tao boi HP2705
		as ' + @sSQL)
set @sSQL = 'select  DivisionID, DepartmentID, TeamID,EmployeeID, TaxObjectID, sum(Isnull(InComeAmount,0) - Isnull(SubAmount,0)) as NetAmount, sum(Isnull(InComeAmount,0) - Isnull(SubAmount,0))/ '+cast(@NoMonth as NVARCHAR(50))+' as PerMonth
	from HV2707 where DivisionID = ''' + @DivisionID + ''' group by DivisionID, DepartmentID, TeamID,EmployeeID,TaxObjectID'
---------- --------(sum(InComeAmount - SubAmount)/ @NoMonth)

If exists(Select Top 1 1 From sysObjects Where Name = 'HV2708' and Type = 'V')
	Drop view HV2708
EXEC('Create view HV2708 ---tao boi HP2705
		as ' + @sSQL)
set @Cur_TaxObjectID = Cursor Scroll Keyset for
		select Distinct TaxObjectID from HV2708 
Open @Cur_TaxObjectID
Fetch next from @Cur_TaxObjectID into @TaxObjectID
While @@FETCH_STATUS = 0 
BEGIN
--Tinh thue 
Select @IsProgressive = IsProgressive, @IsPercentSurtax = IsPercentSurtax From HT1011 Where TaxObjectID = @TaxObjectID 

IF @IsProgressive = 1  ---luy tien
Set @sSQL='Select DivisionID, DepartmentID, TeamID, EmployeeID,H00.TaxObjectID, NetAmount, PerMonth,
		isnull(sum(case when ( PerMonth > MinSalary and ( PerMonth <= MaxSalary or MaxSalary = -1))
		then  PerMonth - MinSalary
		else case when  PerMonth <= MinSalary then 0 else
		MaxSalary - MinSalary end end* isnull(RateOrAmount,0)/100), 0) as TaxAmount
		
	From HV2708 H00 inner join HT1012 H01 on H01.TaxObjectID = ''' + @TaxObjectID + ''' and H00.DivisionID = H01.DivisionID 
	Group by DivisionID, DepartmentID, TeamID, EmployeeID, H00.TaxObjectID, NetAmount,PerMonth'

Else  ---nac thang
Set @sSQL ='	Select DivisionID, DepartmentID, TeamID, EmployeeID, H00.TaxObjectID, NetAmount, PerMonth,
		isnull(sum(case when ( PerMonth > MinSalary and ( PerMonth <= MaxSalary or MaxSalary = -1))
		then  PerMonth else 0 end* isnull(RateOrAmount,0)/100), 0) as TaxAmount
		
	From HV2708 H00 inner join HT1012 H01 on H01.TaxObjectID = ''' + @TaxObjectID + ''' and H00.DivisionID = H01.DivisionID 
	Group by DivisionID, DepartmentID, TeamID,  EmployeeID,  PerMonth ,H00.TaxObjectID, NetAmount'
-----print @sSQL
Fetch next from @Cur_TaxObjectID into @TaxObjectID
END

if exists(Select Top 1 1 from sysObjects where Name = 'HV2709' and Type = 'V' )
	Drop view HV2709
EXEC('Create view HV2709----------Tao boi HP2705
		as ' + @sSQL)

if exists (select top 1 1 from HT2705)
	delete HT2705
set @Cur_Tax = Cursor Scroll KeySet for
	select EmployeeID, TaxObjectID,NetAmount, (TaxAmount*@NoMonth) as SumTax
	from  HV2709
Open @Cur_Tax
FETCH NEXT from @Cur_Tax into @Employ, @TaxObjectID, @NetAmount,@SumTax
WHILE @@FETCH_STATUS = 0 
BEGIN
-------So thue da nop
SELECT @PaidTax = Sum(Isnull(TaxAmount, 0))
FROM   HT3400
WHERE  DivisionID = @DivisionID
       AND DepartmentID LIKE @DepartmentID
       AND Isnull(TeamID, '') LIKE @TeamID
       AND EmployeeID = @Employ
       AND TranMonth IN ( @FMonth, @TMonth )

SET @UnpaidTax = @SumTax - @PaidTax 



INSERT INTO HT2705
            (DivisionID,
            EmployeeID,
             PaidTax,
             NetAmount,
             SumTax,
             UnPaidTax,
             TaxObjectID)
VALUES      ( @DivisionID,
			  @Employ,
              @PaidTax,
              @NetAmount,
              @SumTax,
              @UnPaidTax,
              @TaxObjectID) 

Fetch next from @Cur_Tax into @Employ, @TaxObjectID, @NetAmount, @SumTax
END
END 
----else
----print 'a'

