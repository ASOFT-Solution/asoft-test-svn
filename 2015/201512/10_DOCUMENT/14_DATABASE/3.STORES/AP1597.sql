
/****** Object:  StoredProcedure [dbo].[AP1597]    Script Date: 07/29/2010 13:58:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-------- Created by Nguyen Quoc Huy
-------- Date 16/05/2007.
-------- Purpose: Cap that vao bang In "Tinh hinh tang giam tai san co dinh"

/********************************************
'* Edited by: [GS] [Ngọc Nhựt] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP1597]	
				@LineID AS NVARCHAR(50), 
				@NumGroupID AS NVARCHAR(50), 
				@Amount AS DECIMAL(28, 8)
			
AS

DECLARE @strSQL as nvarchar(4000)
		
	--------- Cap nhat vao chinh chi tieu cua no.
IF @NumGroupID = 1
	UPDATE AT1597  SET Amount01 = ISNULL(Amount01, 0) + @Amount WHERE LineID = @LineID
ELSE IF @NumGroupID = 2
	UPDATE AT1597  SET Amount02 = ISNULL(Amount02, 0) + @Amount WHERE LineID = @LineID
ELSE IF @NumGroupID = 3
	UPDATE AT1597  SET Amount03 = ISNULL(Amount03, 0) + @Amount WHERE LineID = @LineID
ELSE IF @NumGroupID = 4
	UPDATE AT1597  SET Amount04 = ISNULL(Amount04, 0) + @Amount WHERE LineID = @LineID
ELSE IF @NumGroupID = 5
	UPDATE AT1597  SET Amount05 = ISNULL(Amount05, 0) + @Amount WHERE LineID = @LineID
ELSE IF @NumGroupID = 6
	UPDATE AT1597  SET Amount06 = ISNULL(Amount06, 0) + @Amount WHERE LineID = @LineID
ELSE IF @NumGroupID = 7
	UPDATE AT1597  SET Amount07 = ISNULL(Amount07, 0) + @Amount WHERE LineID = @LineID
ELSE IF @NumGroupID = 8
	UPDATE AT1597  SET Amount08 = ISNULL(Amount08, 0) + @Amount WHERE LineID = @LineID
ELSE IF @NumGroupID = 9
	UPDATE AT1597  SET Amount09 = ISNULL(Amount09, 0) + @Amount WHERE LineID = @LineID
ELSE IF @NumGroupID = 10
	UPDATE AT1597  SET Amount10 = ISNULL(Amount10, 0) + @Amount WHERE LineID = @LineID
