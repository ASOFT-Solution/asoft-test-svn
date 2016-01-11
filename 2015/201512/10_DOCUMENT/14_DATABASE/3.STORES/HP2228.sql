IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2228]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2228]
GO
/****** Object:  StoredProcedure [dbo].[HP2228]    Script Date: 10/20/2011 09:34:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


----Created by: Dang Le Bao Quynh
----Created date: 22/08/2006
----purpose: Tính Báo cáo tình hình s? d?ng lao d?ng 

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2228]  @DivisionID  nvarchar(50),
				@TranQuater int,
				@TranYear int,
				@CreateUserID nvarchar(50)
 AS
DECLARE 	
		@BeginDate Datetime, -- Ngay bat dau cua Quy
		@EndDate Datetime, -- Ngay ket thuc cua Quy
		@CalculateInt int,-- Bien luu tru chi tieu thong ke theo kieu so nguyen
		@CalculateMoney decimal(28,8) -- Bien luu tru chi tieu thong ke theo kieu money
	-- tính tổng
	declare @cursor as cursor
	declare @sign as int
	declare @amount1 as int
	declare @amount2 as int
 
SET NOCOUNT ON
	Set @EndDate= 
	Case @TranQuater
		when 1 then '03/31/' + ltrim(@TranYear)
		when 2 then '06/30/' + ltrim(@TranYear)
		when 3 then '09/30/' + ltrim(@TranYear)
		when 4 then '12/31/' + ltrim(@TranYear)
	End
	Set @BeginDate=
	Case @TranQuater
		when 1 then '01/01/' + ltrim(@TranYear)
		when 2 then '04/01/' + ltrim(@TranYear)
		when 3 then '07/01/' + ltrim(@TranYear)
		when 4 then '10/01/' + ltrim(@TranYear)
	End
--Cap nhat chi tieu 1/Tong so lao dong **Cap nhat so lao dong nu
	-- Thong ke nhan su dang lam viec va co ngay vao lam <= ngay cuoi cua Quy can bao cao	
	Set @CalculateInt=(Select count(EmployeeID) from HT1400 Where DivisionID = @DivisionID and EmployeeStatus=1 
				and EmployeeID In (Select EmployeeID From HT1403 Where DivisionID = @DivisionID and WorkDate<=@EndDate))

	Update HT2228 Set Amount1=@CalculateInt,LastModifyUserID=@CreateUserID,LastModifyDate=getdate() 
	Where DivisionID = @DivisionID and [Code]='10' 
	AND TranQuater = @TranQuater AND TranYear = @TranYear
	Set @CalculateInt=(Select count(EmployeeID) from HT1400 Where DivisionID = @DivisionID and EmployeeStatus=1 and IsMale=0
				and EmployeeID In (Select EmployeeID From HT1403 Where DivisionID = @DivisionID and WorkDate<=@EndDate))
	Update HT2228 Set Amount1=@CalculateInt,LastModifyUserID=@CreateUserID,LastModifyDate=getdate() 
	Where DivisionID = @DivisionID and [Code]='101'
	AND TranQuater = @TranQuater AND TranYear = @TranYear
--Cap nhat chi tieu 2/Trinh do van hoa **Lay tu [Danh muc trinh do hoc van (HT1005)] theo nguyen tac cua truong [He so hoc van (RaceEducation)] 
		        --    1: Cap I;	2: Cap II;	3: Cap III;	 4: Trung cap, Cao dang;	 	5: Dai hoc
	-- Thong ke nhan su dang lam viec va co ngay vao lam <= ngay cuoi cua Quy can bao cao
	Set @CalculateInt=(Select count(EmployeeID) from HT1400 Where DivisionID = @DivisionID and EmployeeStatus=1 
				and EmployeeID In (Select EmployeeID From HT1403 Where DivisionID = @DivisionID and WorkDate<=@EndDate)
				and EmployeeID In (Select EmployeeID From HT1401 Where DivisionID = @DivisionID and EducationLevelID 
							In (Select EducationLevelID From HT1005 Where DivisionID = @DivisionID and RaceEducation=1)))
	Update HT2228 Set Amount1=@CalculateInt,LastModifyUserID=@CreateUserID,LastModifyDate=getdate() 
	Where DivisionID = @DivisionID and [Code]='201'
	AND TranQuater = @TranQuater AND TranYear = @TranYear
	select * from HT1005
	Set @CalculateInt=(Select count(EmployeeID) from HT1400 Where DivisionID = @DivisionID and EmployeeStatus=1 
				and EmployeeID In (Select EmployeeID From HT1403 Where DivisionID = @DivisionID and WorkDate<=@EndDate)
				and EmployeeID In (Select EmployeeID From HT1401 Where DivisionID = @DivisionID and EducationLevelID 
							In (Select EducationLevelID From HT1005 Where DivisionID = @DivisionID and RaceEducation=2)))
	Update HT2228 Set Amount1=@CalculateInt,LastModifyUserID=@CreateUserID,LastModifyDate=getdate() 
	Where DivisionID = @DivisionID and [Code]='202'
	AND TranQuater = @TranQuater AND TranYear = @TranYear

	Set @CalculateInt=(Select count(EmployeeID) from HT1400 Where DivisionID = @DivisionID and EmployeeStatus=1 
				and EmployeeID In (Select EmployeeID From HT1403 Where DivisionID = @DivisionID and WorkDate<=@EndDate)
				and EmployeeID In (Select EmployeeID From HT1401 Where DivisionID = @DivisionID and EducationLevelID 
							In (Select EducationLevelID From HT1005 Where DivisionID = @DivisionID and RaceEducation=3)))
	Update HT2228 Set Amount1=@CalculateInt,LastModifyUserID=@CreateUserID,LastModifyDate=getdate() 
	Where DivisionID = @DivisionID and [Code]='203'
	AND TranQuater = @TranQuater AND TranYear = @TranYear

	Set @CalculateInt=(Select count(EmployeeID) from HT1400 Where DivisionID = @DivisionID and EmployeeStatus=1 
				and EmployeeID In (Select EmployeeID From HT1403 Where DivisionID = @DivisionID and WorkDate<=@EndDate)
				and EmployeeID In (Select EmployeeID From HT1401 Where DivisionID = @DivisionID and EducationLevelID 
							In (Select EducationLevelID From HT1005 Where DivisionID = @DivisionID and RaceEducation=4)))
	Update HT2228 Set Amount1=@CalculateInt,LastModifyUserID=@CreateUserID,LastModifyDate=getdate() 
	Where DivisionID = @DivisionID and [Code]='204'
	AND TranQuater = @TranQuater AND TranYear = @TranYear

	Set @CalculateInt=(Select count(EmployeeID) from HT1400 Where DivisionID = @DivisionID and EmployeeStatus=1 
				and EmployeeID In (Select EmployeeID From HT1403 Where DivisionID = @DivisionID and WorkDate<=@EndDate)
				and EmployeeID In (Select EmployeeID From HT1401 Where DivisionID = @DivisionID and EducationLevelID 
							In (Select EducationLevelID From HT1005 Where DivisionID = @DivisionID and RaceEducation=5))) 
	Update HT2228 Set Amount1=@CalculateInt,LastModifyUserID=@CreateUserID,LastModifyDate=getdate() 
	Where DivisionID = @DivisionID and [Code]='205'
	AND TranQuater = @TranQuater AND TranYear = @TranYear
	-- tinh tổng các Code[từ 201-> 205]
	set @CalculateInt = 0;
	set @cursor = Cursor scroll keyset for 
	Select sign, amount1, amount2 From HT2228 where [Code0]='20'
	open @cursor 
	fetch next from @cursor into @sign, @amount1, @amount2
	WHILE @@FETCH_STATUS = 0
	begin
	if(@sign = 1)
	set @CalculateInt = @CalculateInt +  @amount1;
	else
	set @CalculateInt = @CalculateInt -  @amount1;

	fetch next  from @cursor into @sign, @amount1, @amount2
	end
	close @cursor
	deallocate @cursor

	Update HT2228 Set Amount1=@CalculateInt,LastModifyUserID=@CreateUserID,LastModifyDate=getdate() 
	Where DivisionID = @DivisionID and [Code]='20'
	AND TranQuater = @TranQuater AND TranYear = @TranYear
	
--Cap nhat chi tieu 3/Bien dong lao dong. Bao gom: **So lao dong tang; **So lao dong giam.
	-- Thong ke nhan su co ngay vao lam trong khoan ngay bat dau cua Quy va ngay cuoi cua Quy can bao cao	
	Set @CalculateInt=(Select count(EmployeeID) from HT1403 Where DivisionID = @DivisionID and WorkDate Between @BeginDate And @EndDate)
	Update HT2228 Set Amount1=@CalculateInt,LastModifyUserID=@CreateUserID,LastModifyDate=getdate() 
	Where DivisionID = @DivisionID and [Code]='301'
	AND TranQuater = @TranQuater AND TranYear = @TranYear
	-- Thong ke nhan su co ngay nghi viec trong khoan ngay bat dau cua Quy va ngay cuoi cua Quy can bao cao
	Set @CalculateInt=(Select count(EmployeeID) from HT1403 Where DivisionID = @DivisionID and LeaveDate Between @BeginDate And @EndDate)
	Update HT2228 Set Amount1=@CalculateInt,LastModifyUserID=@CreateUserID,LastModifyDate=getdate() 
	Where DivisionID = @DivisionID and [Code]='302'
	AND TranQuater = @TranQuater AND TranYear = @TranYear

	-- tinh tổng các Code[301,302]
	set @CalculateInt = 0;
	set @cursor = Cursor scroll keyset for 
	Select sign, amount1, amount2 From HT2228 where [Code0]='30'
	open @cursor 
	fetch next from @cursor into @sign, @amount1, @amount2
	WHILE @@FETCH_STATUS = 0
	begin
	if(@sign = 1)
	set @CalculateInt = @CalculateInt +  @amount1;
	else
	set @CalculateInt = @CalculateInt -  @amount1;

	fetch next  from @cursor into @sign, @amount1, @amount2
	end
	close @cursor
	deallocate @cursor

	Update HT2228 Set Amount1=@CalculateInt,LastModifyUserID=@CreateUserID,LastModifyDate=getdate() 
	Where DivisionID = @DivisionID and [Code]='30'
	AND TranQuater = @TranQuater AND TranYear = @TranYear
	
--Cap nhat chi tieu 4/Ky hop dong, so lao dong ** So lao dong ky hop dong lao dong
	-- Thong ke nhan su dang lam viec va co ngay vao lam <= ngay cuoi cua Quy can bao cao va co ho so Hop dong lao dong
	Set @CalculateInt=(Select count(EmployeeID) from HT1400 Where DivisionID = @DivisionID and EmployeeStatus=1 
				and EmployeeID In (Select EmployeeID From HT1403 Where DivisionID = @DivisionID and WorkDate<=@EndDate)
				and EmployeeID In (Select Distinct EmployeeID From HT1360 Where DivisionID = @DivisionID)) 
	Update HT2228 Set Amount1=@CalculateInt,LastModifyUserID=@CreateUserID,LastModifyDate=getdate() 
	Where DivisionID = @DivisionID and [Code]='401'
	AND TranQuater = @TranQuater AND TranYear = @TranYear
--Cap nhat chi tieu 5/Luong va thu nhap **Muc cao nhat va thap nhat, lay tu truong luong CB
--Cap nhat chi tieu 7/BHXH,BHYT **So nguoi tham gia BHXH,BHYT
SET NOCOUNT OFF
GO


