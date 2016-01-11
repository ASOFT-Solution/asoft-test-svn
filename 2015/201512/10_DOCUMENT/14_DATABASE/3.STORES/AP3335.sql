/****** Object:  StoredProcedure [dbo].[AP3335]    Script Date: 07/29/2010 11:47:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
--Ke thua xuat kho
ALTER PROCEDURE [dbo].[AP3335] @DivisionID nvarchar(50), @Where nvarchar(4000), @Method tinyint = 0, @VoucherID nvarchar(50) = '' -- 0, do du lieu ke thua, 1 cap nhat tinh trang da ke thua, 2 Xoa

AS
If @Method = 0
	Begin
		Select Null As ObjectID ,
		
		InventoryID,T2.InventoryName,UnitID, IsStocked, MethodID, IsSource, IsLocation, IsLimitDate,
		V7.Quantity, Null As UnitPrice,  AccountID,  Null As PrimeCostAccountID, Null As OriginalAmount
		
		From AV3337 V7 Left Join AT1302 T2 On V7.HH_MaSo = T2.InventoryID

		ORDER BY T2.InventoryID
	End
Else
	If @Method = 1
		Begin
			Insert Into AT3332(DivisionID, VoucherID, Ma) Select @DivisionID, @VoucherID, ltrim(PNX_NgayNhanHang) + '_' + ltrim(Kho_MaSo) + '_' + ltrim(HH_MaSo) From AV3337 Where ltrim(PNX_NgayNhanHang) + '_' + ltrim(Kho_MaSo) + '_' + ltrim(HH_MaSo) Not In (Select Ma From AT3332)
		End
	Else
		Begin
			Delete From AT3332 Where VoucherID = @VoucherID
		End