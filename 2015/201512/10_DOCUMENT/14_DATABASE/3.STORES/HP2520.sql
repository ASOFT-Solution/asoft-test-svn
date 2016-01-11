/****** Object:  StoredProcedure [dbo].[HP2520]    Script Date: 01/11/2012 14:06:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2520]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2520]
GO

/****** Object:  StoredProcedure [dbo].[HP2520]    Script Date: 01/11/2012 14:06:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

----Created by : Vo Thanh Huong , date : 06/04/2005
---purpose: Ke thua tam ung

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

CREATE PROCEDURE [dbo].[HP2520]  @DivisionID as NVARCHAR(50),
				@DepartmentID as NVARCHAR(50),
				@TranMonth as int,
				@TranYear as int,
				@FromMonth as int,
				@FromYear as int,
				@AdvanceDate datetime,
				@CreateUserID NVARCHAR(50)	
AS

Declare 
	@HT2500Cursor  as Cursor,
	@AdvanceID as NVARCHAR(50),
	@EmployeeID as NVARCHAR(50),
	@AdvanceAmount as decimal (28, 8),
	@Description as nvarchar(100),
	@TeamID NVARCHAR(50),
	@TempYear NVARCHAR(50),
	@TempMonth  NVARCHAR(50)

Select @TempYear = left(cast(@TranYear as nvarchar(10)), 2),  @TempMonth = cast(@TranMonth as nvarchar(10))

SET @HT2500Cursor = CURSOR SCROLL KEYSET FOR
	SELECT  H4.DepartmentID, H4.TeamID, H5.EmployeeID,  AdvanceAmount,  Description                                                                                                                                                                                                                                                
	FROM HT2500 H5 inner join HT2400 H4 on H4.DivisionID = H5.DivisionID and H4.EmployeeID = H5.EmployeeID and H4.TranMonth = @TranMonth and H4.TranYear = @TranYear
	WHERE 	H5.DivisionID =@DivisionID and
			H4.DepartmentID LIKE @DepartmentID and 				
			H5.TranMonth  = @FromMonth and 
			H5.TranYear = @FromYear

OPEN @HT2500Cursor
FETCH NEXT FROM @HT2500Cursor INTO @DepartmentID, @TeamID,   @EmployeeID, @AdvanceAmount, @Description

WHILE @@FETCH_STATUS = 0
	  BEGIN
		IF not Exists(SELECT EmployeeID FROM HT2500 WHERE EmployeeID = @EmployeeID AND DivisionID = @DivisionID
							AND DepartmentID = @DepartmentID AND TranMonth = @TranMonth	
							AND TranYear = @TranYear and AdvanceDate = @AdvanceDate) 
		  BEGIN
			Exec AP0000  @DivisionID, @AdvanceID  OUTPUT, 'HT2500', 'AD', @TempYear, @TempMonth, 15, 3, 0, ''

			Insert HT2500(AdvanceID, DivisionID, DepartmentID, TeamID, EmployeeID, TranMonth, TranYear, AdvanceDate, 
				 AdvanceAmount, Description, CreateUserID, CreateDate,  LastModifyUserID,  LastModifyDate ) 
			Values (@AdvanceID, @DivisionID, @DepartmentID, @TeamID, @EmployeeID, @TranMonth, @TranYear, @AdvanceDate,  
			@AdvanceAmount, @Description, @CreateUserID, GetDate(),  @CreateUserID,GetDate())						
		  END
		FETCH NEXT FROM @HT2500Cursor INTO @DepartmentID, @TeamID,   @EmployeeID, @AdvanceAmount, @Description
 	 END
		
CLOSE @HT2500Cursor
DEALLOCATE @HT2500Cursor
GO


