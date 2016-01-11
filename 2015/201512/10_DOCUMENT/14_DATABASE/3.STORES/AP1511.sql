
/****** Object:  StoredProcedure [dbo].[AP1511]    Script Date: 07/29/2010 11:17:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------ Created by Nguyen Van Nhan, Date 14/10/2003
----- Purpose: Xu ly so le

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1511] 
				@DivisionID nvarchar(50), 
				@TranMonth as int, 
				@TranYear as int,
				@AssetID as nvarchar(50), 
				@TotalDepAmount as decimal(28, 8)
AS

Declare @DepAmount as decimal(28, 8),
	@DepreciationID as nvarchar(50)	

--Print 'TEST'

Set @DepAmount = isnull((Select Sum(DepAmount) 
						From AT1504
						Where DivisionID = @DivisionID and AssetID = @AssetID 
							and TranMonth = @TranMonth and TranYear =@TranYear 
							and DepType =0) ,0)
							
IF @TotalDepAmount <> @DepAmount
	Begin		--- Phai lam tron
		Set @DepreciationID = (Select top 1  DepreciationID 
								From AT1504
								Where DivisionID =@DivisionID and AssetID =@AssetID 
									and TranMonth = @TranMonth and TranYear =@TranYear 
									and DepType =0 
								Order by DepAmount DESC)
									
		Update AT1504 
		Set DepAmount = DepAmount + (@TotalDepAmount - @DepAmount)
		Where  DepreciationID = @DepreciationID and DivisionID = @DivisionID  and AssetID =@AssetID 
			and TranMonth = @TranMonth and TranYear = @TranYear and  DepType = 0
	End