/****** Object:  StoredProcedure [dbo].[HP2416]    Script Date: 08/02/2010 15:14:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Created by : Nguyen Quoc Huy
---Created date: 24/09/2008
---purpose: Chuyen nhung ngay di cong tac sang bang cham cong ngay
/********************************************
'* Edited by: [GS] [Thành Nguyên] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[HP2416] @DivisionID AS nvarchar(50),
				@DepartmentID AS nvarchar(50),
				@TeamID AS nvarchar(50),
				@TranMonth AS INT,
				@TranYear AS INT,
				@EmployeeID AS nvarchar(50),
				@StartDate AS DATETIME,
				@NumberOfDays AS decimal (28,8),
				@AbsentTypeID AS nvarchar(50),
				@UserID AS nvarchar(50),
				@isType as int,   --0: Cham cong, 1: Huy cham cong,
				@AbsentAmount decimal (28,8) = 1	
AS
 
DECLARE 	@i AS INT,
		@AbsentDate AS DATETIME
SET @i = 0


BEGIN
	WHILE @i < @NumberOfDays
	BEGIN
		SET @AbsentDate = @StartDate + @i
		IF @isType = 0  --Cham cong
			Begin	
				IF not exists ( select * from HT2401 where EmployeeID = @EmployeeID and TranMonth = @TranMonth and TranYear = @TranYear and DAY(AbsentDate) = DAY(@AbsentDate) AND MONTH(AbsentDate) = MONTH(@AbsentDate) and YEAR(AbsentDate) = YEAR(@AbsentDate) and DivisionID = @DivisionID And AbsentTypeID = @AbsentTypeID)
				Begin
					INSERT INTO HT2401 ( AbsentDate, EmployeeID, DivisionID, TranMonth, TranYear, DepartmentID, TeamID, 
							AbsentTypeID, AbsentAmount, CreateDate, LastModifyDate, CreateUserID, LastModifyUserID)
					VALUES ( @AbsentDate, @EmployeeID, @DivisionID, @TranMonth, @TranYear, @DepartmentID, @TeamID, 
							@AbsentTypeID, @AbsentAmount, Getdate(), Getdate(), @UserID, @UserID )
				End
			End
		ELSE   ---Huy cham cong
			Begin	
				
				Delete HT2401 where EmployeeID = @EmployeeID and TranMonth = @TranMonth and TranYear = @TranYear and AbsentTypeID = @AbsentTypeID
							and DAY(AbsentDate) = DAY(@AbsentDate) AND MONTH(AbsentDate) = MONTH(@AbsentDate) 
							and YEAR(AbsentDate) = YEAR(@AbsentDate) and DivisionID = @DivisionID 
			End

		SET @i = @i +1
	END
END
GO
