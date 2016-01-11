/***** Object:  StoredProcedure [dbo].[HP0271]    Script Date: 25/07/2013 *****/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP0271]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP0271]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--- Created by: Bảo Anh, date: 25/07/2013
--- Purpose: Lưu bảng phân ca
--- EXEC HP0271 'AS','%','%','%',1,2012,'01/01/2012','01/31/2012','C01',N'21 -> 31','admin'

CREATE PROCEDURE [dbo].[HP0271]
				@DivisionID as nvarchar(50),
				@DepartmentID as nvarchar(50),
				@TeamID as nvarchar(50),
				@EmployeeID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@FromDate as datetime,
				@ToDate as datetime,
				@ShiftID as nvarchar(50),
				@Notes as nvarchar(250),
				@CreateUserID as nvarchar(50)

AS
DECLARE 	@sSQL as nvarchar(4000),
			@cur as cursor,
			@i as int,
			@j as int,			
			@TeamID1 nvarchar(50),
			@TransactionID nvarchar(50)
			
Declare @HT2400 table
(
	DivisionID nvarchar(50),
	DepartmentID nvarchar(50),
	TeamID nvarchar(50),
	EmployeeID nvarchar(50)
)
	 
INSERT INTO @HT2400 (DivisionID, DepartmentID, TeamID, EmployeeID)
Select DivisionID, DepartmentID, TeamID, EmployeeID
From HT2400
Where DivisionID = @DivisionID and
	DepartmentID like @DepartmentID and
	isnull(TeamID,'') like @TeamID and
	EmployeeID like @EmployeeID and 
	TranYear = @TranYear and TranMonth = @TranMonth

Set @j = day(@ToDate)

SET @cur = CURSOR SCROLL KEYSET FOR
		SELECT *
		FROM @HT2400 where DivisionID = @DivisionID
		
	OPEN @cur
	FETCH NEXT FROM @cur INTO @DivisionID, @DepartmentID, @TeamID1, @EmployeeID

	WHILE @@FETCH_STATUS = 0
	  BEGIN	
			IF not Exists(SELECT EmployeeID FROM HT1025 
						WHERE EmployeeID = @EmployeeID and 
								DivisionID = @DivisionID and							
								TranMonth=@TranMonth And TranYear=@TranYear)
				BEGIN				
					IF exists (Select EmployeeID From HT2400
							WHERE EmployeeID = @EmployeeID and 
										DivisionID = @DivisionID and 
										DepartmentID = @DepartmentID and 
										isnull(TeamID, '')=  isnull(@TeamID1,'') and 
										TranMonth=@TranMonth And TranYear=@TranYear)
						BEGIN								
							Exec AP0000  @DivisionID, @TransactionID  OUTPUT, 'HT1025', 'SD', @TranYear, '', 15, 3, 0, ''
							 									
							Insert into HT1025 (DivisionID, TransactionID, EmployeeID, TranMonth, TranYear, Notes, CreateDate, LastModifyDate, CreateUserID, LastModifyUserID)
							Values (@DivisionID, @TransactionID, @EmployeeID, @TranMonth, @TranYear, @Notes,
								getdate(),getdate(), @CreateUserID, @CreateUserID)
								
							Set @i = DAY(@FromDate)
							WHILE @i <= @j
								BEGIN
									Set @sSQL = N'UPDATE HT1025 SET D' + (case when @i<10 then '0' else '' end) + convert(nvarchar(2),@i) + ' = ''' + @ShiftID + '''
												WHERE DivisionID = ''' + @DivisionID + ''' And EmployeeID = ''' +  @EmployeeID + ''''
									EXEC(@sSQL)
									SET @i = @i + 1
								END
						END
				END
			ELSE				
				BEGIN					
					Set @i = DAY(@FromDate)
							WHILE @i <= @j
								BEGIN
									Set @sSQL = N'UPDATE HT1025 SET D' + (case when @i<10 then '0' else '' end) + convert(nvarchar(2),@i) + ' = ''' + @ShiftID + '''
												WHERE DivisionID = ''' + @DivisionID + ''' And EmployeeID = ''' +  @EmployeeID + ''''
									
									EXEC(@sSQL)
									SET @i = @i + 1			
								END	
				END
				
			FETCH NEXT FROM @cur INTO @DivisionID, @DepartmentID, @TeamID1, @EmployeeID	
		END		
  	  
	CLOSE @cur
	DEALLOCATE @cur