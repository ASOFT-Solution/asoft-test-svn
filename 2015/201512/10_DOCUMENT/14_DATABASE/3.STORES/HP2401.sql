/****** Object:  StoredProcedure [dbo].[HP2401]    Script Date: 04/19/2012 11:37:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2401]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2401]
GO
/****** Object:  StoredProcedure [dbo].[HP2401]    Script Date: 04/19/2012 11:37:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong, date: 06/09/2004
----purpose: Luu ch?m công ngày khi thêm m?i
--- Modify on 04/08/2013 by Bao Anh: Bo sung tinh so cong theo dieu kien (Hung Vuong)
--- Modify on 20/05/2014 by Tri Thien: Cho phép ghi đè dữ liệu chấm công khi import
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2401] 	@DivisionID as nvarchar(50),
				@DepartmentID as nvarchar(50),
				@TeamID as nvarchar(50),
				@EmployeeID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@FromDate as datetime,
				@ToDate as datetime,
				@AbsentTypeID as nvarchar(50),
				@AbsentAmount as decimal(28,8),
				@CreateUserID as nvarchar(50)

AS
DECLARE 	@sSQL as nvarchar(4000),
			@cur as cursor,
			@i as int,
			@j as int,
			@AbsentDate as datetime,
			@TeamID1 nvarchar(50),
			@BeginDate datetime,
			@EndDate datetime,
			@IsCondition tinyint,
			@ConditionCode nvarchar(4000),
			@ConditionAmount decimal(28,8)

Set @ConditionAmount = 0

Select @BeginDate = BeginDate,  @EndDate = EndDate
From HT9999 
Where DivisionID = @DivisionID and
	TranMonth = @TranMonth and
	TranYear = @TranYear

--- Bo sung tinh so cong theo dieu kien duoc thiet lap trong danh muc loai cong ngay (yeu cau cua Hung Vuong)
SELECT
     @IsCondition = IsCondition ,
     @ConditionCode = ConditionCode
FROM
     HT1013
WHERE
     DivisionID = @DivisionID AND AbsentTypeID = @AbsentTypeID

IF @IsCondition = 1 and ISNULL(@ConditionCode,'') <> ''
	BEGIN
		EXEC HP5556 @AbsentAmount , @ConditionCode , @ConditionAmount OUTPUT
		SET @AbsentAmount = @ConditionAmount
	END
					 
Set @sSQL = '
Select DivisionID, DepartmentID, TeamID, EmployeeID
From HT2400
Where DivisionID = ''' + @DivisionID + ''' and
	DepartmentID like ''' + @DepartmentID + ''' and
	isnull(TeamID,'''') like ''' + @TeamID + ''' and
	EmployeeID like ''' + @EmployeeID + ''' and 
	TranYear = ' + cast(@TranYear as nvarchar(4)) + ' and TranMonth = ' + cast(@TranMonth as nvarchar(2))

If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='HV2401')
	Exec(' Create view HV2401 as '+@sSQL)
Else
	Exec(' Alter view HV2401 as '+@sSQL)

Set @j = DATEDIFF(day, @FromDate, @ToDate) + 1

SET @cur = CURSOR SCROLL KEYSET FOR
		SELECT *
		FROM HV2401 where DivisionID = @DivisionID
	OPEN @cur
	FETCH NEXT FROM @cur INTO @DivisionID, @DepartmentID, @TeamID1, @EmployeeID

	WHILE @@FETCH_STATUS = 0
	  BEGIN
		Set @i = 1	
		Set @AbsentDate = @FromDate
		WHILE @i <= @j
			BEGIN	
				--IF not Exists(SELECT EmployeeID FROM HT2401 
				--			WHERE EmployeeID = @EmployeeID and 
				--					DivisionID = @DivisionID and 
				--					DepartmentID = @DepartmentID  and
				--					isnull(TeamID, '') = isnull(@TeamID1,'')	 and
				--					TranMonth=@TranMonth And TranYear=@TranYear and
				--					 AbsentDate = @AbsentDate and 
				--					AbsentTypeID = @AbsentTypeID)
				--IF exists (Select EmployeeID From HT2400
				--		WHERE EmployeeID = @EmployeeID and 
				--					DivisionID = @DivisionID and 
				--					DepartmentID = @DepartmentID and 
				--					isnull(TeamID, '')=  isnull(@TeamID1,'') and 
				--					TranMonth=@TranMonth And TranYear=@TranYear and
				--					@AbsentDate between isnull(FromDateTranFer, @BeginDate) and 
				--							isnull(ToDateTranfer, @EndDate))			  									
				--	Insert into HT2401 (AbsentDate, EmployeeID, DivisionID, TranMonth, TranYear, DepartmentID,
				--		TeamID, AbsentTypeID, AbsentAmount, CreateDate, LastModifyDate, CreateUserID, LastModifyUserID)
				--	Values (@AbsentDate, @EmployeeID, @DivisionID, @TranMonth, @TranYear,
				--		@DepartmentID, @TeamID1, @AbsentTypeID, @AbsentAmount, getdate(),getdate(),
				--		@CreateUserID, @CreateUserID)

				-- Kiem tra ho so luong co ton tai hay khong
				IF EXISTS (SELECT EmployeeID From HT2400
						WHERE EmployeeID = @EmployeeID AND DivisionID = @DivisionID AND DepartmentID = @DepartmentID 
						AND ISNULL(TeamID, '')=  ISNULL(@TeamID1,'') AND TranMonth=@TranMonth AND TranYear=@TranYear
						AND @AbsentDate BETWEEN ISNULL(FromDateTranFer, @BeginDate)AND ISNULL(ToDateTranfer, @EndDate))	
						BEGIN
							-- Kiem tra da ton tai thong tin cham cong nay chua
							IF NOT EXISTS(	SELECT EmployeeID
							                FROM HT2401 
											WHERE EmployeeID = @EmployeeID AND DivisionID = @DivisionID AND DepartmentID = @DepartmentID
												AND ISNULL(TeamID, '') = ISNULL(@TeamID1,'') AND TranMonth=@TranMonth AND TranYear=@TranYear 
												AND AbsentDate = @AbsentDate AND AbsentTypeID = @AbsentTypeID)
									-- Them moi du lieu cham cong neu chua ton tai
									Insert into HT2401 (AbsentDate, EmployeeID, DivisionID, TranMonth, TranYear, DepartmentID,
														TeamID, AbsentTypeID, AbsentAmount, CreateDate, LastModifyDate, CreateUserID, LastModifyUserID)
									Values (@AbsentDate, @EmployeeID, @DivisionID, @TranMonth, @TranYear, @DepartmentID, 
														@TeamID1, @AbsentTypeID, @AbsentAmount, getdate(),getdate(), @CreateUserID, @CreateUserID)
							ELSE
								-- Cap nhat thong tin cham cong neu da ton tai
								UPDATE HT2401 
								SET AbsentAmount = @AbsentAmount, LastModifyDate = getdate(), LastModifyUserID = @CreateUserID
								WHERE EmployeeID = @EmployeeID AND DivisionID = @DivisionID AND DepartmentID = @DepartmentID
									AND ISNULL(TeamID, '') = ISNULL(@TeamID1,'') AND TranMonth=@TranMonth AND TranYear=@TranYear 
									AND AbsentDate = @AbsentDate AND AbsentTypeID = @AbsentTypeID 
						END
						
				SET @AbsentDate = DATEADD(day, 1, @AbsentDate)
				SET @i = @i + 1
			END

		FETCH NEXT FROM @cur INTO @DivisionID, @DepartmentID, @TeamID1, @EmployeeID
  	  END
	CLOSE @cur
	DEALLOCATE @cur
GO


