
/****** Object:  StoredProcedure [dbo].[OP3050]    Script Date: 08/02/2010 15:11:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

--Create by: Dang Le Bao Quynh; Date : 02/04/2008
--Purpose: Tao view in bao cao bang ke hai quan

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP3050]
AS
Declare @AppendixCount as int

	Select @AppendixCount = Count(*)-3 From OV3002
	If @AppendixCount<=0
		Set @AppendixCount = 0
	Else
		Set @AppendixCount = (@AppendixCount+3)/9 +  Case When (@AppendixCount+3) % 9 = 0 Then 0 Else 1 End
	Select @AppendixCount As AppendixCount