/****** Object:  StoredProcedure [dbo].[MP2402]    Script Date: 08/02/2010 10:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Createdby: Vo Thanh Huong, date: 25/11/2004
---purpose: Tinh du toan nguyen vat lieu

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/
--- Modified by Tiểu Mai on 23/12/2015: Bổ sung load thông tin từ bộ định mức theo quy cách

ALTER PROCEDURE [dbo].[MP2402]  @DivisionID nvarchar(50),
				@ApportionType int, --0 - Dinh muc nguyen vat lieu Asoft-M, 1- Dinh muc xuat kho Asoft-T
				@EstimateID nvarchar(50)
AS
DECLARE @sSQL nvarchar(max)
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
	Set @sSQL = 'Select EDetailID, ProductID, Orders as POrders,  ApportionID,  ProductQuantity, MT2102.DivisionID,
						O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
						O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
				From MT2102
				left join MT8899 O99 on O99.DivisionID = MT2102.DivisionID and O99.voucherID = MT2102.EstimateID and O99.TransactionID = MT2102.EDetailID and O99.TableID = ''MT2102''
				Where MT2102.DivisionID = ''' + @DivisionID + ''' and EstimateID = ''' + @EstimateID + ''''
ELSE
	Set @sSQL = 'Select EDetailID, ProductID, Orders as POrders,  ApportionID,  ProductQuantity, DivisionID
				From MT2102
				Where DivisionID = ''' + @DivisionID + ''' and EstimateID = ''' + @EstimateID + ''''

If exists (Select Top 1 1 From sysObjects  Where XType = 'V' and Name = 'MV2403')
	Drop view MV2403
EXEC('Create view MV2403   ---tao boi MP2402
		as ' + @sSQL)


If  @ApportionType = 0
BEGIN
	IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
		Set @sSQL = 'Select ''' + @DivisionID + ''' as DivisionID, ''' + @EstimateID  + ''' as EstimateID, EDetailID, 
				T00.MaterialID, T03.TranMonth, T03.TranYear,  
				InventoryName as MaterialName,  
				T02.UnitID, '''' as MDescription, V00.ProductID, 
				sum(isnull(case when isnull(T01.ProductQuantity, 0) = 0 then 0 else 
				T00.MaterialQuantity * V00.ProductQuantity / T01.ProductQuantity end, 0)) as MaterialQuantity, 
				V00.POrders,
				T00.DS01ID, T00.DS02ID, T00.DS03ID, T00.DS04ID, T00.DS05ID, T00.DS06ID, T00.DS07ID, T00.DS08ID, T00.DS09ID, T00.DS10ID,
				T00.DS11ID, T00.DS12ID, T00.DS13ID, T00.DS14ID, T00.DS15ID, T00.DS16ID, T00.DS17ID, T00.DS18ID, T00.DS19ID, T00.DS20ID
			From MT0137 T00 
				inner join MT0136 T01 on T00.DivisionID = T01.DivisionID AND T01.ProductID = T00.ProductID AND T01.TransactionID = T00.ReTransactionID
				inner join MV2403 V00 ON T00.DivisionID = V00.DivisionID AND V00.ApportionID = T01.ApportionID and  V00.ProductID = T00.ProductID
										AND Isnull(T01.S01ID,'''') = Isnull(V00.S01ID,'''') AND Isnull(T01.S02ID,'''') = Isnull(V00.S02ID,'''')
										AND Isnull(T01.S03ID,'''') = Isnull(V00.S03ID,'''') AND Isnull(T01.S04ID,'''') = Isnull(V00.S04ID,'''')
										AND Isnull(T01.S05ID,'''') = Isnull(V00.S05ID,'''') AND Isnull(T01.S06ID,'''') = Isnull(V00.S06ID,'''')
										AND Isnull(T01.S07ID,'''') = Isnull(V00.S07ID,'''') AND Isnull(T01.S08ID,'''') = Isnull(V00.S08ID,'''')
										AND Isnull(T01.S09ID,'''') = Isnull(V00.S09ID,'''') AND Isnull(T01.S10ID,'''') = Isnull(V00.S10ID,'''')   
										AND Isnull(T01.S11ID,'''') = Isnull(V00.S11ID,'''') AND Isnull(T01.S12ID,'''') = Isnull(V00.S12ID,'''')
										AND Isnull(T01.S13ID,'''') = Isnull(V00.S13ID,'''') AND Isnull(T01.S14ID,'''') = Isnull(V00.S14ID,'''')
										AND Isnull(T01.S15ID,'''') = Isnull(V00.S15ID,'''') AND Isnull(T01.S16ID,'''') = Isnull(V00.S16ID,'''')
										AND Isnull(T01.S17ID,'''') = Isnull(V00.S17ID,'''') AND Isnull(T01.S18ID,'''') = Isnull(V00.S18ID,'''') 
										AND Isnull(T01.S19ID,'''') = Isnull(V00.S19ID,'''') AND Isnull(T01.S20ID,'''') = Isnull(V00.S20ID,'''')
				inner join AT1302 T02 on T02.InventoryID = T00.MaterialID and T00.DivisionID = T02.DivisionID
				inner join MT2101 T03 on T03.EstimateID = ''' + @EstimateID  + '''  and T00.DivisionID = T03.DivisionID and T03.DivisionID = ''' + @DivisionID + '''
			Where isnull(T00.MaterialID,'''') <> ''''
			Group by T00.DivisionID, EstimateID, EDetailID, T00.MaterialID,  InventoryName,  T02.UnitID, T03.TranMonth, T03.TranYear,  V00.ProductID, V00.POrders,
					T00.DS01ID, T00.DS02ID, T00.DS03ID, T00.DS04ID, T00.DS05ID, T00.DS06ID, T00.DS07ID, T00.DS08ID, T00.DS09ID, T00.DS10ID,
					T00.DS11ID, T00.DS12ID, T00.DS13ID, T00.DS14ID, T00.DS15ID, T00.DS16ID, T00.DS17ID, T00.DS18ID, T00.DS19ID, T00.DS20ID'
	ELSE
			Set @sSQL = 'Select ''' + @DivisionID + ''' as DivisionID, ''' + @EstimateID  + ''' as EstimateID, EDetailID, 
				T00.MaterialID, T03.TranMonth, T03.TranYear,  
				InventoryName as MaterialName,  
				T02.UnitID, '''' as MDescription, V00.ProductID, sum(isnull(case when isnull(T00.ProductQuantity, 0) = 0 then 0 else 
				MaterialQuantity * V00.ProductQuantity / T00.ProductQuantity end, 0)) as MaterialQuantity, V00.POrders
			From MT1603 T00 inner join MT1602 T01 on T00.ApportionID = T01.ApportionID and T00.DivisionID = T01.DivisionID
				inner join MV2403 V00 on V00.ApportionID = T00.ApportionID and  V00.ProductID = T00.ProductID  and T00.DivisionID = V00.DivisionID
				inner join AT1302 T02 on T02.InventoryID = T00.MaterialID and T00.DivisionID = T02.DivisionID
				inner join MT2101 T03 on T03.EstimateID = ''' + @EstimateID + '''  and T00.DivisionID = T03.DivisionID and T03.DivisionID = ''' + @DivisionID + '''
			Where isnull(T00.MaterialID,'''') <> '''' 
			Group by T00.DivisionID, EstimateID, EDetailID, T00.MaterialID,  InventoryName,  T02.UnitID, T03.TranMonth, T03.TranYear,  V00.ProductID, V00.POrders'
END
Else
Set @sSQL = 'Select ''' + @DivisionID + ''' as DivisionID, ''' + @EstimateID  + ''' as EstimateID, EDetailID, T00.ItemID as MaterialID, T03.TranMonth, T03.TranYear,  
	InventoryName as MaterialName, T02.UnitID, '''' as MDescripton,  V00.ProductID, sum(isnull(case when isnull(T00.InventoryQuantity, 0) = 0 then 0 else 
	ItemQuantity * V00.ProductQuantity / T00.InventoryQuantity end, 0)) as MaterialQuantity,  V00.POrders 
From AT1326 	T00 inner join MV2403 V00 on V00.ApportionID = T00.KITID and  V00.ProductID = T00.InventoryID And V00.DivisionID = T00.DivisionID
	inner join AT1302 T02 on T02.InventoryID = T00.ItemID And T02.DivisionID = T00.DivisionID
	inner join MT2101 T03 on T03.EstimateID = ''' + @EstimateID + ''' and T00.DivisionID = T03.DivisionID and T03.DivisionID = ''' + @DivisionID + '''
Where isnull(T00.ItemID,'''') <> '''' 
Group by T00.DivisionID, EstimateID, EDetailID, T00.ItemID ,	InventoryName, T02.UnitID, T03.TranMonth, T03.TranYear,  V00.ProductID, V00.POrders'

--PRINT @sSQL
If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV2402')
	Drop view MV2402
EXEC('Create view MV2402 ---tao boi MP2402
		as ' + @sSQL)
		
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON		