
/****** Object:  StoredProcedure [dbo].[OP2208]    Script Date: 12/16/2010 13:14:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


---Created by:Nguyen Thi Thuy Tuyen, date:07/11/2006
---purpose: Ke thua tu yeu cau mua hang  cho don hang mua.
---Last EDit ThuyTuyen 01/06/2006
/********************************************
'* Edited by: [GS] [Tố Oanh] [02/08/2010]
'********************************************/
---Last Edit Mai Duyen 04/03/2014 : Sua lai khai bao chieu dai cua @lstROrderID 
--- Modified by Tiểu Mai on 19/11/2015: Bổ sung thông tin quy cách khi có thiết lập quản lý mặt hàng theo quy cách.

ALTER PROCEDURE [dbo].[OP2208]  @DivisionID nvarchar(50),
				@lstROrderID nvarchar(2000)
AS
Declare @sSQL  nvarchar(max),
		@sSQL1  nvarchar(max)

Set  @lstROrderID = 	Replace(@lstROrderID, ',', ''',''')
--- Print @lstROrderID

IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	SET @sSQL = '
	Select OT3101.DivisionID, TranMonth, TranYear,
	OT3102.ROrderID, OT3101.OrderStatus, OT3102.TransactionID,
	OT3102.InventoryID, OrderQuantity,  ----OT3001.OrderQuantity as ActualQuantity, 
	case when OT3102.Finish = 1 then NULL else isnull(OT3102.OrderQuantity,0) - isnull(ActualQuantity, 0) end as EndQuantity,
	case when OT3102.Finish = 1 then NULL else isnull(OT3102.ConvertedQuantity,0) - isnull(ActualCQuantity, 0) end as EndCQuantity,
	O89.S01ID, O89.S02ID, O89.S03ID, O89.S04ID, O89.S05ID, O89.S06ID, O89.S07ID, O89.S08ID, O89.S09ID, O89.S10ID,
	O89.S11ID, O89.S12ID, O89.S13ID, O89.S14ID, O89.S15ID, O89.S16ID, O89.S17ID, O89.S18ID, O89.S19ID, O89.S20ID

From OT3102 inner join OT3101 on OT3102.ROrderID = OT3101.ROrderID
	LEFT JOIN OT8899 O89 ON O89.DivisionID = OT3102.DivisionID AND O89.VoucherID = OT3102.ROrderID AND O89.TransactionID = OT3102.TransactionID AND O89.TableID = ''OT3102''
	left join 	(Select OT3001.DivisionID, OT3002.ROrderID, isnull (OT3002.RefTransactionID,'''' ) as RefTransactionID,
			InventoryID, sum(OT3002.OrderQuantity) As ActualQuantity, Sum(Isnull(ConvertedQuantity,0)) As ActualCQuantity,
			O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		From OT3002 inner join OT3001 on OT3001.POrderID = OT3002.POrderID
		LEFT JOIN OT8899 O99 ON O99.DivisionID = OT3002.DivisionID AND O99.VoucherID = OT3002.POrderID AND O99.TransactionID = OT3002.TransactionID AND O99.TableID = ''OT3002''
		Where isnull (OT3002.RefTransactionID,'''' ) <> '' ''
		Group by OT3001.DivisionID, OT3002.ROrderID, InventoryID,OT3002.RefTransactionID,
				O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
				O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID) as G  --- (co nghia la Nhan hang)
		on 	OT3101.DivisionID = G.DivisionID and
			----OT3102.ROrderID = G.ROrderID and
			OT3102.InventoryID = G.InventoryID and
			OT3102.TransactionID = isnull(G.RefTransactionID,'''') AND
			ISNULL(O89.S01ID,'''') = Isnull(G.S01ID,'''') AND 
			ISNULL(O89.S02ID,'''') = Isnull(G.S02ID,'''') AND
			ISNULL(O89.S03ID,'''') = Isnull(G.S03ID,'''') AND
			ISNULL(O89.S04ID,'''') = Isnull(G.S04ID,'''') AND
			ISNULL(O89.S05ID,'''') = Isnull(G.S05ID,'''') AND 
			ISNULL(O89.S06ID,'''') = Isnull(G.S06ID,'''') AND
			ISNULL(O89.S07ID,'''') = Isnull(G.S07ID,'''') AND
			ISNULL(O89.S08ID,'''') = Isnull(G.S08ID,'''') AND
			ISNULL(O89.S09ID,'''') = Isnull(G.S09ID,'''') AND
			ISNULL(O89.S10ID,'''') = Isnull(G.S10ID,'''') AND
			ISNULL(O89.S11ID,'''') = Isnull(G.S11ID,'''') AND 
			ISNULL(O89.S12ID,'''') = Isnull(G.S12ID,'''') AND
			ISNULL(O89.S13ID,'''') = Isnull(G.S13ID,'''') AND
			ISNULL(O89.S14ID,'''') = Isnull(G.S14ID,'''') AND
			ISNULL(O89.S15ID,'''') = Isnull(G.S15ID,'''') AND
			ISNULL(O89.S16ID,'''') = Isnull(G.S16ID,'''') AND
			ISNULL(O89.S17ID,'''') = Isnull(G.S17ID,'''') AND
			ISNULL(O89.S18ID,'''') = Isnull(G.S18ID,'''') AND
			ISNULL(O89.S19ID,'''') = Isnull(G.S19ID,'''') AND
			ISNULL(O89.S20ID,'''') = Isnull(G.S20ID,'''')
			'
	If not exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV29051')
	EXEC('Create view OV29051 ----tao boi OP2208
			as ' + @sSQL)
	Else	
	EXEC('Alter view OV29051 ----tao boi OP2208
			as ' + @sSQL)
					
	Set @sSQL1 ='
	Select Distinct OT3102.DivisionID, 
		OT3102.ROrderID, 
		OT3102.TransactionID, 
		OT3102.InventoryID, 
		case when isnull(OT3102.InventoryCommonName,'''') = ''''  then AT1302.InventoryName else OT3102.InventoryCommonName end as 
		InventoryName, 			
		Isnull(OT3102.UnitID,AT1302.UnitID) as  UnitID,
		OV29051.EndQuantity as OrderQuantity, 
		RequestPrice, 
		ConvertedAmount, 
		OriginalAmount, 
		VATConvertedAmount, 
		VATOriginalAmount, 
		OT3102.VATPercent, 
		DiscountConvertedAmount,  
		DiscountOriginalAmount,
		OT3102.Ana01ID,
		OT3102.Ana02ID,
		OT3102.Ana03ID,
		OT3102.Ana04ID,
		OT3102.Ana05ID,
		OT3102.Ana06ID,
		OT3102.Ana07ID,
		OT3102.Ana08ID,
		OT3102.Ana09ID,
		OT3102.Ana10ID,
		OT3102.DiscountPercent,
		OT3102.Orders, 				
		OT3102.Notes,
		OT3102.Notes01,
		OT3102.Notes02,
		OT3101.ConTractNo,OV29051.EndCQuantity as ConvertedQuantity, OT3102.ConvertedSalePrice,
		OT3102.Parameter01, OT3102.Parameter02, OT3102.Parameter03, OT3102.Parameter04, OT3102.Parameter05,
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		
From OT3102 left join AT1302 on AT1302.InventoryID= OT3102.InventoryID AND AT1302.DivisionID= OT3102.DivisionID
	        Left Join OT3101 on OT3101.ROrderID  =  OT3102.ROrderID	AND OT3101.DivisionID  =  OT3102.DivisionID
	        Left join OT8899 O99 ON O99.DivisionID = OT3102.DivisionID AND O99.VoucherID = OT3102.ROrderID AND O99.TransactionID = OT3102.TransactionID AND O99.TableID = ''OT3102''
			Inner Join OV29051 on	OV29051.ROrderID  =  OT3102.ROrderID  AND OV29051.DivisionID  =  OT3102.DivisionID
									and OT3102.TransactionID = OV29051.TransactionID AND OT3102.DivisionID = OV29051.DivisionID AND
									ISNULL(O99.S01ID,'''') = ISNULL(OV29051.S01ID,'''') AND 
									ISNULL(O99.S02ID,'''') = ISNULL(OV29051.S02ID,'''') AND
									ISNULL(O99.S03ID,'''') = ISNULL(OV29051.S03ID,'''') AND
									ISNULL(O99.S04ID,'''') = ISNULL(OV29051.S04ID,'''') AND
									ISNULL(O99.S05ID,'''') = ISNULL(OV29051.S05ID,'''') AND 
									ISNULL(O99.S06ID,'''') = ISNULL(OV29051.S06ID,'''') AND
									ISNULL(O99.S07ID,'''') = ISNULL(OV29051.S07ID,'''') AND
									ISNULL(O99.S08ID,'''') = ISNULL(OV29051.S08ID,'''') AND
									ISNULL(O99.S09ID,'''') = ISNULL(OV29051.S09ID,'''') AND
									ISNULL(O99.S10ID,'''') = ISNULL(OV29051.S10ID,'''') AND
									ISNULL(O99.S11ID,'''') = ISNULL(OV29051.S11ID,'''') AND 
									ISNULL(O99.S12ID,'''') = ISNULL(OV29051.S12ID,'''') AND
									ISNULL(O99.S13ID,'''') = ISNULL(OV29051.S13ID,'''') AND
									ISNULL(O99.S14ID,'''') = ISNULL(OV29051.S14ID,'''') AND
									ISNULL(O99.S15ID,'''') = ISNULL(OV29051.S15ID,'''') AND
									ISNULL(O99.S16ID,'''') = ISNULL(OV29051.S16ID,'''') AND
									ISNULL(O99.S17ID,'''') = ISNULL(OV29051.S17ID,'''') AND
									ISNULL(O99.S18ID,'''') = ISNULL(OV29051.S18ID,'''') AND
									ISNULL(O99.S19ID,'''') = ISNULL(OV29051.S19ID,'''') AND
									ISNULL(O99.S20ID,'''') = ISNULL(OV29051.S20ID,'''')
Where OT3101.DivisionID = ''' + @DivisionID + ''' and OT3102.ROrderID in (''' + @lstROrderID + ''')
 and OV29051.EndQuantity > 0
'
END
ELSE
	Set @sSQL1 ='Select Distinct OT3102.DivisionID, 
		OT3102.ROrderID, 
		OT3102.TransactionID, 
		OT3102.InventoryID, 
		case when isnull(OT3102.InventoryCommonName,'''') = ''''  then AT1302.InventoryName else OT3102.InventoryCommonName end as 
		InventoryName, 			
		Isnull(OT3102.UnitID,AT1302.UnitID) as  UnitID,
		OV2905.EndQuantity as OrderQuantity, 
		RequestPrice, 
		ConvertedAmount, 
		OriginalAmount, 
		VATConvertedAmount, 
		VATOriginalAmount, 
		OT3102.VATPercent, 
		DiscountConvertedAmount,  
		DiscountOriginalAmount,
		OT3102.Ana01ID,
		OT3102.Ana02ID,
		OT3102.Ana03ID,
		OT3102.Ana04ID,
		OT3102.Ana05ID,
		OT3102.Ana06ID,
		OT3102.Ana07ID,
		OT3102.Ana08ID,
		OT3102.Ana09ID,
		OT3102.Ana10ID,
		OT3102.DiscountPercent,
		OT3102.Orders, 				
		OT3102.Notes,
		OT3102.Notes01,
		OT3102.Notes02,
		OT3101.ConTractNo,OV2905.EndCQuantity as ConvertedQuantity, OT3102.ConvertedSalePrice,
		OT3102.Parameter01, OT3102.Parameter02, OT3102.Parameter03, OT3102.Parameter04, OT3102.Parameter05,
		'''' as S01ID, '''' as S02ID, '''' as S03ID, '''' as S04ID, '''' as S05ID, '''' as S06ID, '''' as S07ID, '''' as S08ID, '''' as S09ID, '''' as S10ID,
		'''' as S11ID, '''' as S12ID, '''' as S13ID, '''' as S14ID, '''' as S15ID, '''' as S16ID, '''' as S17ID, '''' as S18ID, '''' as S19ID, '''' as S20ID
		
From OT3102 left join AT1302 on AT1302.InventoryID= OT3102.InventoryID AND AT1302.DivisionID= OT3102.DivisionID
	           Left Join OT3101 on OT3101.ROrderID  =  OT3102.ROrderID	AND OT3101.DivisionID  =  OT3102.DivisionID
	 Inner Join OV2905 on OV2905.ROrderID  =  OT3102.ROrderID  AND OV2905.DivisionID  =  OT3102.DivisionID
				and OT3102.TransactionID =OV2905.TransactionID AND OT3102.DivisionID =OV2905.DivisionID
Where OT3101.DivisionID = ''' + @DivisionID + ''' and OT3102.ROrderID in (''' + @lstROrderID + ''')
 and OV2905.EndQuantity > 0
'

	If not exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2208')
	EXEC('Create view OV2208 ----tao boi OP2208
			as ' + @sSQL1)
	Else	
	EXEC('Alter view OV2208 ----tao boi OP2208
			as ' + @sSQL1)