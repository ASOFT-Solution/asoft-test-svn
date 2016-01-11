/****** Object:  StoredProcedure [dbo].[AP5559]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP5559] @Date datetime
AS

Declare @DataName nvarchar(255)
Declare @sql nvarchar(4000)

EXEC AP5553 @DataName OUTPUT, 1
--Import Master
	Set @sql = 
	N'Insert Into AT5558 Select * From ' + @DataName + N'..Orders Where OrderID Not In (Select OrderID From AT5558) And OrderDate = ''' + ltrim(@Date) + ''''
	EXEC (@sql)
--Xoa Detail truoc khi import
	Set @sql = 
	N'Delete AT5559 Where OrderID In (Select OrderID From AT5558 Where OrderDate = ''' + ltrim(@Date) + N''')'
	EXEC (@sql)
--Import Detail
	Set @sql = 
	N'Insert Into AT5559 Select * From ' + @DataName + N'..OrderDetails Where OrderID In (Select OrderID From AT5558 Where OrderDate = ''' + ltrim(@Date) + ''')'
	EXEC (@sql)
GO
