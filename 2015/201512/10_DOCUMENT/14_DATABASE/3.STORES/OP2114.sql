
/****** Object:  StoredProcedure [dbo].[OP2114]    Script Date: 08/02/2010 09:18:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



--Created by: Thuy Tuyen ,  date : 21/09/2009
--purpose : Ke thua bo dinh muc hang ban theo bo cho man hinh don hang ban,
/********************************************
'* Edited by: [GS] [Tố Oanh] [02/08/2010]
'********************************************/
---- Modified by Tiểu Mai on 18/11/2015: Bổ sung trường hợp có thiết lập quản lý mặt hàng theo quy cách


ALTER PROCEDURE   [dbo].[OP2114]  @DivisionID nvarchar(50),
			     	@VoucherID nvarchar(50),
				@ObjectID nvarchar(50),
				@VoucherDate datetime
				
AS
DECLARE @sSQL nvarchar(4000)


EXEC  OP1302 	 @DivisionID,@ObjectID,@VoucherDate 

Set  @VoucherID = 	Replace(@VoucherID, ',', ''',''')

IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
	Set @sSQL = '
		Select 
			OT3019.SOKitTransactionID, OT3019.SOKitID, OT3019.SOKitName, OT3019.CurrencyID,
			OT3019.ExchangeRate, OT3019.Description,
			OT3019.DivisionID, OT3019.CreateDate, OT3019.CreateUserID,
			OT3019.LastModifyUserID, OT3019.LastModifyDate, OT3019.Orders,
			OT3019.InventoryID, AT1302.InventoryName,
			OT3019.UnitID, OT3019.Quantity, 
	
			Isnull(OV1302.UnitPrice,OT3019.UnitPrice) as UnitPrice ,
 
			OT3019.OriginalAmount, OT3019.ConvertedAmount, OT3019.VATGroupID, 
			OT3019.VATPercent, OT3019.VATOriginalAmount, OT3019.Notes, OT3019.Notes01, OT3019.Notes02 ,
			DiscountPercent,DiscountAMount,
			SaleOffPercent01,SaleOffAmount01,
			SaleOffPercent02,SaleOffAmount02,
			SaleOffPercent03,SaleOffAmount03,
			SaleOffPercent04,SaleOffAmount04,
			SaleOffPercent05,SaleOffAmount05,
			'''' as S01ID, '''' as S02ID, '''' as S03ID, '''' as S04ID, 
			'''' as S05ID, '''' as S06ID, '''' as S07ID, '''' as S08ID, 
			'''' as S09ID, '''' as S10ID, '''' as S11ID, '''' as S12ID, 
			'''' as S13ID, '''' as S14ID, '''' as S15ID, '''' as S16ID, 
			'''' as S17ID, '''' as S18ID, '''' as S19ID, '''' as S20ID
		From OT3019
		Left Join AT1302 on AT1302.InventoryID = OT3019.InventoryID
		left Join OV1302 on OV1302.InventoryID = OT3019.InventoryID

		Where OT3019.DivisionID = ''' + @DivisionID + ''' and 
			OT3019.SOKitID in  (''' + @VoucherID + ''') '
ELSE
	Set @sSQL = '
Select 
	OT3019.SOKitTransactionID, OT3019.SOKitID, OT3019.SOKitName, OT3019.CurrencyID,
	OT3019.ExchangeRate, OT3019.Description,
	OT3019.DivisionID, OT3019.CreateDate, OT3019.CreateUserID,
	OT3019.LastModifyUserID, OT3019.LastModifyDate, OT3019.Orders,
	OT3019.InventoryID, AT1302.InventoryName,
	OT3019.UnitID, OT3019.Quantity, 
	
	Isnull(OV1302.UnitPrice,OT3019.UnitPrice) as UnitPrice ,
 
	OT3019.OriginalAmount, OT3019.ConvertedAmount, OT3019.VATGroupID, 
	OT3019.VATPercent, OT3019.VATOriginalAmount, OT3019.Notes, OT3019.Notes01, OT3019.Notes02 ,
	DiscountPercent,DiscountAMount,
	SaleOffPercent01,SaleOffAmount01,
	SaleOffPercent02,SaleOffAmount02,
	SaleOffPercent03,SaleOffAmount03,
	SaleOffPercent04,SaleOffAmount04,
	SaleOffPercent05,SaleOffAmount05
From OT3019
Left Join AT1302 on AT1302.InventoryID = OT3019.InventoryID
left Join OV1302 on OV1302.InventoryID = OT3019.InventoryID

Where OT3019.DivisionID = ''' + @DivisionID + ''' and 
	OT3019.SOKitID in  (''' + @VoucherID + ''') '

--print @sSQL
If  exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2114')
	DROP VIEW OV2114

EXEC('Create view OV2114 ---tao boi OP2114
		as ' + @sSQL)