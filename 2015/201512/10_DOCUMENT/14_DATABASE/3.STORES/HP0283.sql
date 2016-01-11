IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0283]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0283]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Insert dữ liệu phát sinh chấm công theo ca vào bảng HF0284
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
----Created by: Nguyễn Thanh Sơn, date: 19/08/2013
-- <Example>
---- EXEC HP0283 'CTY','PKZ','','VR.0002',3,2013,'2013-03-01 00:00:00','2013-03-31 00:00:00','CA1','',10,''

CREATE PROCEDURE [dbo].[HP0283] 	 
                @DivisionID AS NVARCHAR(50),
				@DepartmentID AS NVARCHAR(50),
				@TeamID AS NVARCHAR(50),
				@EmployeeID AS NVARCHAR(50),
				@TranMonth AS INT,
				@TranYear AS INT,
				@FromDate AS DATETIME,				
				@ToDate AS DATETIME,
				@ShiftID AS NVARCHAR (50),
				@AbsentTypeID AS NVARCHAR(50),
				@AbsentAmount AS DECIMAL(28,8),
				@CreateUserID AS NVARCHAR(50)


AS
DECLARE 	@sSQL AS NVARCHAR(MAX),
			@cur AS CURSOR,
			@i AS INT,
			@j AS INT,
			@AbsentDate AS DATETIME,
			@TeamID1 NVARCHAR(50),
			@BeginDate AS DATETIME,
			@EndDate AS DATETIME,
			@IsCondition AS TINYINT,
			@ConditionCode AS NVARCHAR(4000),
			@ConditionAmount AS DECIMAL(28,8)

SET @ConditionAmount = 0

Select @BeginDate = BeginDate,  @EndDate = EndDate 
From HT9999 
Where DivisionID = @DivisionID and
	TranMonth = @TranMonth and
	TranYear = @TranYear

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

If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='HV0283')
	Exec(' Create view HV0283 as '+@sSQL)
Else
	Exec(' Alter view HV0283 as '+@sSQL)

Set @j = DATEDIFF(day, @FromDate, @ToDate) + 1

SET @cur = CURSOR SCROLL KEYSET FOR
		SELECT *
		FROM HV0283 where DivisionID = @DivisionID
	OPEN @cur
	FETCH NEXT FROM @cur INTO @DivisionID, @DepartmentID, @TeamID1, @EmployeeID

	WHILE @@FETCH_STATUS = 0
	  BEGIN
		Set @i = 1	
		Set @AbsentDate = @FromDate
	WHILE @i <= @j
			BEGIN	
				IF not Exists(SELECT EmployeeID FROM HT0284
							  WHERE  EmployeeID = @EmployeeID and 
									 DivisionID = @DivisionID and 
									 TranMonth=@TranMonth And 
									 TranYear=@TranYear and
									 AbsentDate = @AbsentDate and 
									 ShiftID=@ShiftID AND
									 AbsentTypeID = @AbsentTypeID)
				IF EXISTS    (SELECT EmployeeID From HT2400
				              WHERE  EmployeeID = @EmployeeID and 
									 DivisionID = @DivisionID and 
									 TranMonth=@TranMonth And TranYear=@TranYear and
									 @AbsentDate between isnull(FromDateTranFer, @BeginDate) and 
											isnull(ToDateTranfer, @EndDate))			  									
					Insert into HT0284(AbsentDate,ShiftID, EmployeeID, DivisionID, TranMonth, TranYear, DepartmentID,
						TeamID, AbsentTypeID, AbsentAmount, CreateDate, LastModifyDate, CreateUserID, LastModifyUserID)
					Values (@AbsentDate,@ShiftID, @EmployeeID, @DivisionID, @TranMonth, @TranYear,
						@DepartmentID, @TeamID1, @AbsentTypeID, @AbsentAmount, getdate(),getdate(),
						@CreateUserID, @CreateUserID)

				SET @AbsentDate = DATEADD(day, 1, @AbsentDate)
				SET @i = @i + 1
			END

		FETCH NEXT FROM @cur INTO @DivisionID, @DepartmentID, @TeamID1, @EmployeeID
  	  END
	CLOSE @cur
	DEALLOCATE @cur


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

