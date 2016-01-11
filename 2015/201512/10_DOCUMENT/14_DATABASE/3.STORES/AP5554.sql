/****** Object:  StoredProcedure [dbo].[AP5554]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Ke thua ban hang
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP5554] @Where nvarchar(4000), @Method tinyint = 0, @VoucherID nvarchar(50) = '' -- 0, do du lieu ke thua, 1 cap nhat tinh trang da ke thua, 2 Xoa
AS

If @Method = 0
	EXEC (N'Select  * From AV5556 Order by OrderID')
Else
	If @Method = 1
		Begin
			EXEC(N'Insert Into AT5553 Select distinct N''' + @VoucherID + N''', OrderID From AV5556 Where OrderID Not In (Select OrderID From AT5553)')
		End
	Else
		Begin
			EXEC(N'Delete From AT5553 Where VoucherID = N''' + @VoucherID + N'''')
		End
GO
