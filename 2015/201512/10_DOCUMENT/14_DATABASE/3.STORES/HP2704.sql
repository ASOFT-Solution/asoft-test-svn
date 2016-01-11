/****** Object:  StoredProcedure [dbo].[HP2704]    Script Date: 08/02/2010 14:38:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



---------In to khai thue thu nhap ca nhan
-------Created by Le Hoai Minh
-------Create day 28-10-2005

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2704]  @ReportCode nvarchar(50),
				@DivisionID NVARCHAR(50),
				@TranMonth int,
				@TranYear int

 AS
declare @LA0 as decimal (28, 8),
	@LA1 as decimal (28, 8),
	@LA as decimal (18,8),
	@LT as decimal (28, 8),
	@LT0 as decimal (28, 8),
	@LT1 as decimal (28, 8),
	@ST as decimal (28, 8),
	@ST0 as decimal (28, 8),
	@ST1 as decimal (28, 8),
	@TA as decimal (28, 8),
	@TA0 as decimal (28, 8),
	@TA1 as decimal (28, 8),
	@sSQL as nvarchar(4000),
	@OT as decimal (28, 8),
	@OT9 as decimal (28, 8),
	@OT0 as decimal (28, 8),
	@OT1 as decimal (28, 8),
	@DataType as NVARCHAR(50),
	@EmployeeType as int,
	@LineID as NVARCHAR(50),
	@LineDescription as nvarchar(120),
	@Code as NVARCHAR(50),
	@Code0 as NVARCHAR(50),
	@Rate as decimal (28, 8),
	@Step as int,
	@IsBold as int,
	@IsItalic as int,
	@IsGray as int,
	@IsNotPrint as int,
	@Amount as decimal (28, 8),
	@Method int,
	@Cur_HT2704 as cursor

----------Tinh tong so lao dong trong thang
select @LA =  count(EmployeeID) from HT2400 
	where DivisionID =  @DivisionID  and TranMonth = @TranMonth and
	TranYear = @TranYear and EmployeeStatus = 1 

select @LA0 = count(HT2400.EmployeeID) from HT2400 left join HT1400 on HT1400.DivisionID = HT2400.DivisionID and HT1400.DepartmentID = HT2400.DepartmentID
					and HT1400.EmployeeID = HT2400.EmployeeID
	where HT2400.DivisionID = @DivisionID  and HT2400.TranMonth = @TranMonth
		and HT2400.EmployeeStatus = 1 and isnull(HT1400.IsForeigner,'') = 0


select @LA1 = count(HT2400.EmployeeID) from HT2400 left join HT1400 on HT1400.DivisionID = HT2400.DivisionID and HT1400.DepartmentID = HT2400.DepartmentID
					and HT1400.EmployeeID = HT2400.EmployeeID
	where HT2400.DivisionID = @DivisionID  and HT2400.TranMonth = @TranMonth
		and HT2400.EmployeeStatus = 1 and isnull(HT1400.IsForeigner,'') = 1



-------------Tinh so nguoi thuoc dien nop thue thang nay ( La nhung nguoi co TaxAmount >0)
select @LT = count(HT3.EmployeeID) from HT3400  HT3 inner join HT2400 HT2 on HT3.DivisionID = HT2.DivisionID and HT3.DepartmentID = HT2.DepartmentID
					and HT3.EmployeeID = HT2.EmployeeID and HT3.TranMonth = HT2.TranMonth and HT3.TranYear = HT2.TranYear
	where HT2.DivisionID = @DivisionID and HT2.TranMonth = @TranMonth and HT2.TranYear = @TranYear
		and TaxAmount >0



select @LT0 = count(HT3.EmployeeID) from HT3400  HT3 inner join HT2400 HT2 on HT3.DivisionID = HT2.DivisionID and HT3.DepartmentID = HT2.DepartmentID
					and HT3.EmployeeID = HT2.EmployeeID and HT3.TranMonth = HT2.TranMonth and HT3.TranYear = HT2.TranYear
	where HT2.DivisionID = @DivisionID  and HT2.TranMonth = @TranMonth and HT2.TranYear = @TranYear
		and TaxAmount >0 and TaxObjectID like '%VN%'


 select @LT1 = count(HT3.EmployeeID) from HT3400  HT3 inner join HT2400 HT2 on HT3.DivisionID = HT2.DivisionID and HT3.DepartmentID = HT2.DepartmentID
					and HT3.EmployeeID = HT2.EmployeeID and HT3.TranMonth = HT2.TranMonth and HT3.TranYear = HT2.TranYear
	where HT2.DivisionID = @DivisionID  and HT2.TranMonth = @TranMonth and HT2.TranYear = @TranYear
		and TaxAmount >0 and TaxObjectID like '%FOR%'



---------------Tinh tong so thue da khau tru ( Lay tu truong TaxAmount cua bang HT3400)
select @TA  = sum(TaxAmount)  from HT3400 
	where TaxAmount >0 and HT3400.DivisionID = @DivisionID
		and HT3400.TranMonth = @TranMonth and HT3400.TranYear = @TranYear


select @TA0 = sum(TaxAmount) from HT3400 HT3 inner join HT2400 HT2 on HT3.DivisionID = HT2.DivisionID and HT3.DepartmentID = HT2.DepartmentID
			and HT3.EmployeeID = HT2.EmployeeID and HT3.TranMonth = HT2.TranMonth and HT3.TranYear = HT2.TranYear
	where HT3.DivisionID = @DivisionID and HT3.TranMonth = @TranMonth and HT3.TranYear = @TranYear
	and TaxAmount >0 and TaxObjectID like '%VN%'


select @TA1 = sum(TaxAmount) from HT3400 HT3 inner join HT2400 HT2 on HT3.DivisionID = HT2.DivisionID and HT3.DepartmentID = HT2.DepartmentID
			and HT3.EmployeeID = HT2.EmployeeID and HT3.TranMonth = HT2.TranMonth and HT3.TranYear = HT2.TranYear
	where HT3.DivisionID = @DivisionID  and HT3.TranMonth = @TranMonth and HT3.TranYear = @TranYear
	and TaxAmount >0 and TaxObjectID like '%FOR%'


		

----------Tong so tien chi tra cho ca nhan nop thue

---B1: Liet ke cac khoan thu nhap va giam tru chiu the cua nhan vien
----------Cac khoan thu nhap chiu thue
set @sSQL = 'select H01.DivisionID, H01.EmployeeID, H04.TaxObjectID,
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
		from HT3400 H01 inner join HT5005 H02 on H01.PayrollMethodID = H02.PayrollMethodID
				inner join HT0002 H03 on H02.IncomeID = H03.IncomeID
				inner join HT2400 H04 on H01.DivisionID = H04.DivisionID and H01.DepartmentID = H04.DepartmentID and
				H01.EmployeeID = H04.EmployeeID and H01.TranMonth = H04.TranMonth and H01.TranYear = H04.TranYear
		where H01.DivisionID = '''+@DivisionID+''' and H01.TranMonth = ' + cast(@TranMonth as nvarchar(10)) + ' and 
				H01.TranYear = ' +cast(@TranYear as nvarchar(10)) + ' and H03.IsTax = 1
union ' +

---------Cac khoan giam tru co tinh vao thue thu nhap

 'select H01.DivisionID, H01.EmployeeID, H04.TaxObjectID,0 as IncomeAmount,
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
		from HT3400 H01 inner join HT5006 H02 on H01.PayrollMethodID = H02.PayrollMethodID
				inner join HT0005 H03 on H02.SubID = H03.SubID
				inner join HT2400 H04 on H01.DivisionID = H04.DivisionID and H01.DepartmentID = H04.DepartmentID and
				H01.EmployeeID = H04.EmployeeID and H01.TranMonth = H04.TranMonth and H01.TranYear = H04.TranYear
		where H01.DivisionID = '''+@DivisionID+''' and H01.TranMonth = ' + cast(@TranMonth as nvarchar(10)) + ' and 
				H01.TranYear = ' +cast(@TranYear as nvarchar(10)) + ' and H03.IsTax = 1'

if exists (select top 1 1 from sysObjects where Name = 'HV2700' and Type ='V')
	drop view HV2700
 Exec('Create View HV2700 as ' + @sSQL)

-----------Tinh tong thu nhap de in bao cao
select @ST = sum(InComeAmount - SubAmount) from HV2700
select @ST0 =  sum(InComeAmount - SubAmount) from HV2700 where TaxObjectID like '%VN%'
select @ST1 = sum(IncomeAmount - SubAmount) from HV2700 where TaxObjectID like '%FOR%'


if exists (select top 1 1 from HT2704  where HT2704.DivisionID = @DivisionID and HT2704.ReportCode = @ReportCode )
	delete HT2704
set @Cur_HT2704 = cursor scroll keyset for
	select H02.LineID, H02.LineDescription, H02.Code,H02.Code0, H02.Rate, H02.Step,
		H02.IsBold,H02.IsItalic,H02.IsGray, H02.IsNotPrint,H02.Method,  H02.DataType, H02.EmployeeType, H03.Amount as Amount1
	from HT2702 H02 left join HT2703 H03 on H02.ReportCode = H03.ReportCode and H02.LineID = H03.LineID and H03.DivisionID = @DivisionID and H02.Method = 2
	where H02.ReportCode = @ReportCode
Open @Cur_HT2704

FETCH NEXT from @Cur_HT2704 into @LineID, @LineDescription, @Code, @Code0, @Rate, @Step, @IsBold, @IsItalic, @IsGray, @IsNotPrint, @Method, @DataType, @EmployeeType, @Amount
While @@FETCH_STATUS = 0
begin


---------Gan du lieu cho @Amount
if @Method <> 2 
begin
	
	if @DataType = 'LA'
	begin
		if @EmployeeType = 9 set @Amount = @LA
		if @EmployeeType = 0 set @Amount = @LA0
		if @EmployeeType = 1 set @Amount = @LA1
	
	end
	if @DataType = 'LT'
	begin
		if @EmployeeType = 9 set @Amount = @LT
		if @EmployeeType = 0 set @Amount = @LT0
		if @EmployeeType = 1 set @Amount = @LT1

	end
	if @DataType = 'ST'
	begin
		if @EmployeeType = 9 set @Amount = @ST
		if @EmployeeType = 0 set @Amount = @ST0
		if @EmployeeType = 1 set @Amount = @ST1

	end
	if @DataType = 'TA'
	begin
		if @EmployeeType = 9 set @Amount = @TA
		if @EmployeeType = 0 set @Amount = @TA0
		if @EmployeeType = 1 set @Amount = @TA1
	end
	if @DataType = 'OT'
	begin
		
		if @EmployeeType = 9 set @Amount = @TA * @OT		if @EmployeeType = 0 set @Amount = @TA0* @OT
		if @EmployeeType = 1 set @Amount = @TA1*@OT
		if isnull(@EmployeeType,2) = 2  
		begin
			set @Amount = @TA* isnull(@Rate,1)/100
			set @OT = 1-isnull(@Rate,1)/100
			
		end
	
	end
	
end
	
else
	set @Amount = @Amount
	

insert HT2704(DivisionID, TranMonth, TranYear, ReportCode, LineID, LineDescription, Code, Code0, Rate, Step, IsBold, IsItalic, IsGray, IsNotPrint, DataType, EmployeeType, Amount)
	VALUES (@DivisionID,@TranMonth, @TranYear, @ReportCode, @LineID, @LineDescription, @Code, @Code0, @Rate, @Step, @IsBold, @IsItalic,
			@IsGray, @IsNotPrint, @DataType, @EmployeeType, @Amount)


FETCH NEXT from @Cur_HT2704 into @LineID, @LineDescription, @Code, @Code0, @Rate, @Step, @IsBold, @IsItalic, @IsGray, @IsNotPrint, @Method, @DataType, @EmployeeType, @Amount
end




