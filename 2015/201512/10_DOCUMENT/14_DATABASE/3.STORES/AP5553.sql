/****** Object:  StoredProcedure [dbo].[AP5553]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP5553]  @DataName nvarchar(255) = '' Output, @ReturnType int = 0 --  0 tra ve recordset, 1 tra ve tham so
AS
Set @DataName = N'VSOFT'

IF @ReturnType = 0
Begin
	Select 0 as Status, 0 as GetExcel
End
GO
