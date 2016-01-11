
/****** Object:  StoredProcedure [dbo].[HP2809]    Script Date: 07/30/2010 10:28:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2809]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2809]
GO

/****** Object:  StoredProcedure [dbo].[HP2809]    Script Date: 07/30/2010 10:28:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------ Created by Nguyen Lam Hoa
------ Created Date 30/06/2005
----- Purpose: Xoa du lieu tinh phep

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE  [dbo].[HP2809] 	@DivisionID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int,
					@DepartmentID as nvarchar(50),
					@TeamID1 as nvarchar(50),
					@GeneralAbsentID as nvarchar(50)

AS

	Declare @Status as tinyint,
		@Mess as nvarchar(500),
		@IsMonth as tinyint,
		@cur as cursor,
		@DivisionID1 as nvarchar(50),
		@DepartmentID1 as nvarchar(50),
		@TeamID as nvarchar(50),
		@DaysSpent as decimal(28,8),
		@DaysRemained as decimal(28,8),
		@EmployeeID as nvarchar(50),
		@DaysAllowed as decimal(28,8)


Set @Status =0 
Set @Mess =''

---DELETE  HT2809  Where GeneralAbsentID =@GeneralAbsentID   and DivisionID = @DivisionID  and TranMonth = @TranMonth and TranYear =@TranYear 
set @cur =   CURSOR SCROLL  keyset for
	SELECT EmployeeID,
           DivisionID,
           DepartmentID,
           Isnull(TeamID, 0) AS TeamID,
           DaysSpent,
           DaysRemained,
           DaysAllowed
    FROM   HT2809
    WHERE  GeneralAbsentID = @GeneralAbsentID
           AND DivisionID = @DivisionID
           AND TranMonth = @TranMonth
           AND TranYear = @TranYear
           AND DepartmentID LIKE @DepartmentID
           AND Isnull(TeamID, 0) LIKE @TeamID1 
    
open @cur

FETCH NEXT FROM @cur into @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID, @DaysSpent, @DaysRemained,@DaysAllowed
WHILE @@FETCH_STATUS = 0 
	BEGIN
		if isnull(@DaysSpent,0) > @DaysAllowed 
			set @DaysRemained = @DaysRemained + @DaysAllowed
		else 
			set @DaysRemained = @DaysRemained + isnull(@DaysSpent,0)
		set @DaysSpent = 0
		update HT2809 set DaysSpent = @DaysSpent, DaysRemained = @DaysRemained where DivisionID = @DivisionID1 and DepartmentID = @DepartmentID1 and
			isnull(TeamID, 0) = @TeamID and  EmployeeID = @EmployeeID and TranMonth = @TranMonth and TranYear = @TranYear and GeneralAbsentID = @GeneralAbsentID
	
	FETCH NEXT FROM @cur into @EmployeeID, @DivisionID1, @DepartmentID1, @TeamID, @DaysSpent, @DaysRemained,@DaysAllowed
	END

	IF Exists (select  top 1  1 From HT2809 where DivisionID= @DivisionID  and TranMonth=  @TranMonth and TranYear= @TranYear and IsNull(IsCal,0)=1 
		and DepartmentID like @DepartmentID and isnull(TeamID,0) like @TeamID1)
		
				Begin 
				If exists ( SELECT TOP 1 1
                            FROM   HT2812
                                   INNER JOIN (SELECT HT03.AbsentTypeID, HT03.DivisionID
                                               FROM   HT5003 HT03
                                                      INNER JOIN HT1013 HT13
                                                        ON HT03.AbsentTypeID = HT13.AbsentTypeID
                                                           AND HT03.DivisionID = @DivisionID
                                               WHERE  HT03.GeneralAbsentID = @GeneralAbsentID) HT
                                     ON HT2812.AbsentTypeID = HT.AbsentTypeID AND HT2812.DivisionID = HT.DivisionID
                            WHERE  HT2812.TranMonth = @TranMonth
                                   AND HT2812.TranYear = @TranYear
                                   AND HT2812.GeneralAbsentID = @GeneralAbsentID
                                   AND HT2812.DivisionID = @DivisionID  
                            )  
					
					Set @IsMonth= (select distinct IsMonth from HT2812 Where DivisionID= @DivisionID 
								and TranMonth=@TranMonth and TranYear=@TranYear)
					
					If @IsMonth=1

						Begin
		
							UPDATE HT2402
                            SET    AbsentAmount = HT2812.AbsentAmount
                            FROM   HT2402
                                   INNER JOIN (SELECT HT03.AbsentTypeID,HT03.DivisionID 
                                               FROM   HT5003 HT03
                                                      INNER JOIN HT1013 HT13
                                                        ON HT03.AbsentTypeID = HT13.AbsentTypeID
                                               WHERE  HT03.GeneralAbsentID = @GeneralAbsentID
                                                      AND HT03.DivisionID = @DivisionID) HT
                                     ON HT2402.AbsentTypeID = HT.AbsentTypeID and HT2402.DivisionID = HT.DivisionID
                                   INNER JOIN HT2812
                                     ON HT2402.DivisionID = HT2812.DivisionID
                                        AND HT2402.DepartmentID = HT2812.DepartmentID
                                        AND HT2402.EmployeeID = HT2812.EmployeeID
                                        AND Isnull(HT2402.TeamID, '') = Isnull(HT2812.TeamID, '')
                                        AND HT2402.AbsentTypeID = HT2812.AbsentTypeID
                                        AND HT2402.TranMonth = HT2812.TranMonth
                                        AND HT2402.TranYear = HT2812.TranYear
                                        AND IsMonth = 1
                            WHERE  HT2402.TranMonth = @TranMonth
                                   AND HT2402.TranYear = @TranYear
                                   AND HT2402.DivisionID = @DivisionID 
                            

							DELETE FROM HT2812
							WHERE  DivisionID = @DivisionID
								   AND TranMonth = @TranMonth
								   AND DepartmentID LIKE @DepartmentID
								   AND Isnull(TeamID, 0) LIKE @TeamID1
								   AND TranYear = @TranYear
								   AND GeneralAbsentID = @GeneralAbsentID
								   AND IsMonth = 1 
				
					End


				Else 
					Begin
							
							UPDATE HT2401
                            SET    AbsentAmount = HT2812.AbsentAmount
                            FROM   HT2401
                                   INNER JOIN (SELECT HT03.AbsentTypeID, HT03.DivisionID
                                               FROM   HT5003 HT03
                                                      INNER JOIN HT1013 HT13
                                                        ON HT03.AbsentTypeID = HT13.AbsentTypeID
                                                           AND HT03.DivisionID = HT13.DivisionID
                                               WHERE  HT03.GeneralAbsentID = @GeneralAbsentID
                                                      AND HT03.DivisionID = @DivisionID) HT
                                     ON HT2401.AbsentTypeID = HT.AbsentTypeID and HT2401.DivisionID = HT.DivisionID
                                   INNER JOIN HT2812
                                     ON HT2401.DivisionID = HT2812.DivisionID
                                        AND HT2401.DepartmentID = HT2812.DepartmentID
                                        AND HT2401.EmployeeID = HT2812.EmployeeID
                                        AND Isnull(HT2401.TeamID, '') = Isnull(HT2812.TeamID, '')
                                        AND HT2401.AbsentTypeID = HT2812.AbsentTypeID
                                        AND HT2401.TranMonth = HT2812.TranMonth
                                        AND HT2401.TranYear = HT2812.TranYear
                                        AND IsMonth = 0
                            WHERE  HT2401.TranMonth = @TranMonth
                                   AND HT2401.TranYear = @TranYear 
                            


							DELETE FROM HT2812
                            WHERE  DivisionID = @DivisionID
                                   AND TranMonth = @TranMonth
                                   AND DepartmentID LIKE @DepartmentID
                                   AND Isnull(TeamID, 0) LIKE @TeamID1
                                   AND TranYear = @TranYear
                                   AND GeneralAbsentID = @GeneralAbsentID
                                   AND IsMonth = 0 
                            
					End



	End
close @cur
deallocate @cur
						

---distinct  HT2812.AbsentTypeID			







GO

