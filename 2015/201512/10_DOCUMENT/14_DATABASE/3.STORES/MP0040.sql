
/****** Object:  StoredProcedure [dbo].[MP0040]    Script Date: 08/02/2010 14:19:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


---- Created by Van Nhan. Date: 05/05/2009
--- Purpose: Kiem tra truoc khi phan bo

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [02/08/2010]
'* Edited by: [GS] [Thành Nguyên] [13/01/2011]
'********************************************/

ALTER PROCEDURE [dbo].[MP0040] 	@ProcedureID as nvarchar(50),
					@DivisionID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int
				
 AS

Declare 	@cur as cursor,
		@PeriodID as  nvarchar(50),
		@Status as tinyint,
		@Message as nvarchar(250)
		set @Status = 0;
	
		If Exists (Select top 1 1 
		From MT1631 inner join MT1601 on MT1601.PeriodID=MT1631.PeriodID AND MT1631.DivisionID = @DivisionID
		Where ProcedureID=@ProcedureID and (IsDistribute<>0 or IsCost<>0 or IsDetailCost<>0) AND MT1631.DivisionID = @DivisionID )
		Begin
			Set @Status=1
			Set @Message = 'MFML000214';			
		End

--theo cấu trúc bảng AT7777
Select @DivisionID as DivisionID
		,'' as UserID
		, @Status as [Status]
		, @Message  as [Message]
		, '' as Value1
		, '' as Value2
		, '' as Value3
		, '' as Value4
		, '' as Value5
