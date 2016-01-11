/****** Object:  StoredProcedure [dbo].[OP2109]    Script Date: 12/16/2010 11:34:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




---------Created by Nguyen Thuy Tuyen.
--------  Ke thua dinh muc tu Asoft  M cho man hinh chao gia.
------ Date 14/05/2005
/********************************************
'* Edited by: [GS] [Tố Oanh] [02/08/2010]
'********************************************/
---- Modified by Tieu Mai on 18/11/2015: Bổ sung quy cách khi có thiết lập quản lý theo quy cách hàng hóa.

ALTER PROCEDURE [dbo].[OP2109]  
(
	@DivisionID NVARCHAR (50),
	@ApportionID  nvarchar(50)
	
)
 AS
 Declare  @sSQL as nvarchar(4000)
 IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
	Set  @sSQL ='
				Select  MT1603.DivisionID,
					ApportionProductID, 
					MT1603.ApportionID,
					AT1302.Barcode,
					MT1603.MaterialID ,
					AT1302.InventoryName,
					MT1603.MaterialTypeID,
					MT1603.MaterialUnitID, 
					MT1603.MaterialQuantity, 
					MT1603.MaterialPrice,
					MT1603.MaterialAmount,
					MT1603.DiminishPercent,  
					MT1603.ProductID,
					MT1603.ProductQuantity, 
					MT1603.DetailUse,
					MT1603.QuantityUnit, 
					MT1603.ConvertedUnit,   
					MT1603.Description,
					'''' as S01ID, '''' as S02ID, '''' as S03ID, '''' as S04ID, 
					'''' as S05ID, '''' as S06ID, '''' as S07ID, '''' as S08ID, 
					'''' as S09ID, '''' as S10ID, '''' as S11ID, '''' as S12ID, 
					'''' as S13ID, '''' as S14ID, '''' as S15ID, '''' as S16ID, 
					'''' as S17ID, '''' as S18ID, '''' as S19ID, '''' as S20ID
				From MT1603
				 Inner join AT1302 on AT1302.InventoryID = MT1603.MaterialID and AT1302.DivisionID = MT1603.DivisionID
				Where MT1603.ApportionID ='''+@ApportionID+''' AND MT1603.DivisionID = '''+@DivisionID+'''
				' 
ELSE
	SET @sSQL = '
	Select  MT1603.DivisionID,
	ApportionProductID, 
	MT1603.ApportionID,
	AT1302.Barcode,
	MT1603.MaterialID ,
	AT1302.InventoryName,
	MT1603.MaterialTypeID,
	MT1603.MaterialUnitID, 
	MT1603.MaterialQuantity, 
	MT1603.MaterialPrice,
	MT1603.MaterialAmount,
	MT1603.DiminishPercent,  
	MT1603.ProductID,
	MT1603.ProductQuantity, 
	MT1603.DetailUse,
	MT1603.QuantityUnit, 
	MT1603.ConvertedUnit,   
	MT1603.Description	
From MT1603
 Inner join AT1302 on AT1302.InventoryID = MT1603.MaterialID and AT1302.DivisionID = MT1603.DivisionID
Where MT1603.ApportionID ='''+@ApportionID+''' AND MT1603.DivisionID = '''+@DivisionID+''' ' 
                         
If  Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV2109')
	Drop view OV2109
Exec('Create View OV2109 ---tao boi OV2109
		as '+@sSQL)