IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[HP0259]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[HP0259]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- Create by Bao Anh		Date: 15/01/2013
---- Purpose: Kiem tra khi xoa danh muc loi san pham

CREATE PROCEDURE HP0259
( 
	@DivisionID as nvarchar(50),
	@ErrorID AS NVARCHAR(max)
) 
AS 

CREATE TABLE #TAM
(
	ItemID NVARCHAR(50)
)

Declare	@iSpaces INT,
		@part varchar(50),
		@List varchar(max),
		@cur cursor,
		@Status as tinyint,
		@Mess as nvarchar(250)

Set @Status =0
Set @Mess =''
	
Set @cur = Cursor scroll keyset for
Select Distinct ErrorList From HT0260 Where DivisionID = @DivisionID

Open @cur  
Fetch next from @cur into @List  
  
While @@Fetch_Status = 0
Begin
	--initialize spaces
	Select @iSpaces = charindex(',',@List,0)
	While @iSpaces > 0
	
	BEGIN
		Select @part = substring(@List,0,charindex(',',@List,0))
			Insert Into #TAM(ItemID)
			Select @part
			Select @List = substring(@List,charindex(',',@List,0)+ len(','),len(@List) - charindex(' ',@List,0))
			Select @iSpaces = charindex(',',@List,0)
	END
	
    If len(@List) > 0
    Insert Into #TAM
    Select @List
	Fetch next from @cur into @List
End

IF Exists (Select top 1 1 From HT0259 Where DivisionID = @DivisionID And ErrorID in (Select ItemID from #TAM))
Begin
			Set @Status =1
			Set @Mess =N'HFML000009'
			Goto EndMess
End
Close @cur

EndMess:
	Select @Status as Status, @Mess as Mess

