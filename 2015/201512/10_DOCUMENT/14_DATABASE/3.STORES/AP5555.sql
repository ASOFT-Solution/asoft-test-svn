/****** Object:  StoredProcedure [dbo].[AP5555]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Ke thua mua hang
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP5555] @Where nvarchar(4000), @Method tinyint = 0, @VoucherID nvarchar(50) = '' -- 0, do du lieu ke thua, 1 cap nhat tinh trang da ke thua, 2 Xoa

AS

If @Method = 0
	EXEC(N'Select  * From AV5557 Order by ImportID,Orders')
Else
	If @Method = 1
		Begin
			EXEC(N'Insert Into AT5552 Select distinct N''' + @VoucherID+ ''', ImportID From AV5557 Where ImportID Not In (Select ImportID From AT5552)')
		End
	Else
		Begin
			EXEC(N'Delete From AT5552 Where VoucherID = N''' + @VoucherID+ '''')
		End
GO
