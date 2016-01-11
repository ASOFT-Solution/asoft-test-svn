
/****** Object:  StoredProcedure [dbo].[AP1528]    Script Date: 07/29/2010 13:10:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


-------- Created by Nguyen Quoc Huy, Date 11/04/2007
------- Purpose Kiem tra sau khi danh gia lai TSCD nay da duoc tinh khau hao chua?

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1528] 	
				@AssetID as nvarchar(50),
				@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int
 AS

Declare @Status as tinyint

If Exists (Select 1 
			From AT1504 
			Where AssetID = @AssetID and DivisionID = @DivisionID 
				and TranMonth= @TranMonth and TranYear = @TranYear)
	Set @Status= 1
Else
	Set @Status = 0

Select 	@Status  as Status