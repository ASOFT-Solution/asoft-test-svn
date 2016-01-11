
/****** Object:  StoredProcedure [dbo].[HP2806]    Script Date: 07/30/2010 10:14:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP2806]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP2806]
GO

/****** Object:  StoredProcedure [dbo].[HP2806]    Script Date: 07/30/2010 10:14:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--- Create Date: 20/6/2005
---Purpose: Insert vao bang HT2810 ngay phep con lai trong nam

/**********************************************
** Edited by: [GS] [Cẩm Loan] [02/08/2010]
***********************************************/

CREATE PROCEDURE [dbo].[HP2806]  @DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@GeneralAbsentID1 as nvarchar(50)
				
				
as

Declare @cur as cursor,
	@GeneralAbsentID as nvarchar(50),
	@AbsentTypeID as nvarchar(50),	
	@EmpLoaRem as nvarchar(50)

If Exists (Select top 1 1 From HT2809 Where DivisionID = @DivisionID 
					 and TranYear = @TranYear and IsNull(IsAdded,0)=1)	
Begin

	Set @cur = Cursor scroll keyset for
		Select DISTINCT HT03.GeneralAbsentID 
		From HT5003 HT03 
		Where GeneralAbsentID = @GeneralAbsentID1
		And DivisionID = @DivisionID
		--Inner join HT1013 HT13 on HT03.AbsentTypeID=HT13.AbsentTypeID and HT13.TypeID='P'
		
	Open @cur
	Fetch next from @cur into @GeneralAbsentID

	While @@Fetch_Status = 0 
		BEGIN
            EXEC Hp2803
              @DivisionID,
              '%',
              '%',
              @TranMonth,
              @TranYear,
              @GeneralAbsentID
        
            IF EXISTS (SELECT TOP 1 1
                       FROM   HT2810
                       WHERE  DivisionID = @DivisionID
                              AND TranYear = @TranYear
                              AND GeneralAbsentID = @GeneralAbsentID)
              DELETE HT2810
              WHERE  DivisionID = @DivisionID
                     AND
                     ---DepartmentID like '%' and 
                     TranYear = @TranYear
                     AND GeneralAbsentID = @GeneralAbsentID
                     AND DivisionID = @DivisionID
        
            ---Exec AP0000  @EmpLoaRem  OUTPUT, 'HT2809', 'LOM', @TempMonth ,@TempYear,15, 3, 0, '-'
            INSERT INTO HT2810
                        (DivisionID,
                         DepartmentID,
                         TeamID,
                         TranYear,
                         EmployeeID,
                         GeneralAbsentID,
                         DaysRemained)
            SELECT HV.DivisionID,
                   HV.DepartmentID,
                   HV.TeamID,
                   HV.TranYear,
                   HV.EmployeeID,
                   HV.GeneralAbsentID,
                   HV.DaysRemained
            FROM   HV2805 HV
                   INNER JOIN HT2809 HT
                     ON HT.DivisionID = HV. DivisionID
                        AND HT.DepartmentID = HV.DepartmentID
                        AND Isnull(HV.TeamID, '') = Isnull(HT.TeamID, '')
                        AND HT. EmployeeID = HV.EmployeeID
            WHERE  Isnull(IsAdded, 0) = 1
                   AND HV.DivisionID = @DivisionID
        
            FETCH next FROM @cur INTO @GeneralAbsentID
        END 
        

	Close @cur
End




GO

