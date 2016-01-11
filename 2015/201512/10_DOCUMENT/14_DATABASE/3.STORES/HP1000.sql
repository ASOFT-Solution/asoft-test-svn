/****** Object:  StoredProcedure [dbo].[HP1000]    Script Date: 11/11/2011 18:02:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HP1000]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[HP1000]
GO

/****** Object:  StoredProcedure [dbo].[HP1000]    Script Date: 11/11/2011 18:02:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---- Created by Nguyen Thi Ngoc Minh, Created Date 31/03/2004
---- Purpose: Kiem tra rang buoc Foreign Key 
----Add by : Vo Thanh Huong, date: 03/09/2004
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
CREATE PROCEDURE [dbo].[HP1000] @DivisionID nvarchar(50), @TableID nvarchar(50), @KeyValues as nvarchar(50)
 AS
Declare @Status as tinyint
	

Set @Status =0

If @TableID = 'HT1013'  --Loai cham cong (AbsentType)
  If exists (Select top 1 1  From HT1013 Where ParentID = @KeyValues and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		--GOTO RETURN_VALUES
	End

If @TableID = 'HT1014'  --Chi tieu quan ly (Target)
  Begin
	Declare @ID as nvarchar(50),
		@sSQL as nvarchar(800),
		@TargetTypeID nvarchar(50)
	
	Set @TargetTypeID = (Select TOP 1 TargetTypeID From HT1014 Where TargetID = @KeyValues and DivisionID = @DivisionID )		

	Set @ID = right(@TargetTypeID,2) 

	Set @sSQL = ' Select top 1 1  as Status  From HT1403  Where Target'+@ID+'ID = '''+ @KeyValues +'''  and DivisionID = '''+@DivisionID+''''
	
	If not Exists (Select  1 From SysObjects Where Name = 'HV1000'  and Xtype ='V' )
		  Exec (' Create View HV1000 as '+@sSQL)
	Else
		 Exec ('  Alter  View HV1000 as '+@sSQL)


	If Exists	(Select 1 From HV1000)
		Set @Status =1
  End

If @TableID = 'HT1022'  
	If exists (Select top 1 1  From HT1021 Where RestrictID = @KeyValues and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		--GOTO RETURN_VALUES
	End

If @TableID = 'HT1020'  
	If exists (Select top 1 1  From HT2407 Where ShiftID = @KeyValues and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		--GOTO RETURN_VALUES
	End

If @TableID = 'HT1900'
If exists (Select top 1 1  From HT1901 Where ProducingProcessID = @KeyValues and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		--GOTO RETURN_VALUES
	End

If @TableID = 'HT1901'
If exists (Select top 1 1  From HT1903 Where ProducingProcessID + StepID = @KeyValues and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		--GOTO RETURN_VALUES
	End

If @TableID = 'HT1902'
If exists (Select top 1 1  From HT1903 Where PriceSheetID = @KeyValues and DivisionID = @DivisionID)
	Begin
		 Set @Status =1
		--GOTO RETURN_VALUES
	End

---- Tra ra gia tri
RETURN_VALUES:
Select @Status as Status
GO


