
/****** Object:  StoredProcedure [dbo].[AP1508]    Script Date: 07/29/2010 10:00:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-------- Created by Nguyen Van Nhan, Date 01/10/2003
------- Purpose Kiem tra tinh trang cua TSCD

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1508] 	@AssetID as nvarchar(50),
				@DivisionID as nvarchar(50)
 AS

Declare @Status as tinyint

If Exists (Select 1 From AT1504 Where 	AssetID =@AssetID and
					DivisionID = @DivisionID)
	Set @Status= 1
Else
	Set @Status = 0

Select 	@Status  as Status