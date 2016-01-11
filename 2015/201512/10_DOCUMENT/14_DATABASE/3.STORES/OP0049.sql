IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP0049]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[OP0049]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---- Created by Tiểu Mai on 22/12/2015
---- Purpose: Kế thừa đơn hàng sản xuất có định mức NVL


CREATE PROCEDURE [dbo].[OP0049] 
    @DivisionID NVARCHAR(50), 
    @ListSOrderID NVARCHAR (500),
    @ListTransactionID NVARCHAR(500)
AS
DECLARE 
    @sSQL NVARCHAR(4000),
    @sSQL1 NVARCHAR(4000),
    @sSQL2 NVARCHAR(MAX)

SET @sSQL = '    
SELECT CONVERT(TINYINT,0) IsSelected,OT2002.Description, OT2002.SOrderID, OT2002.RefInfor, OT2002.UnitID, EndQuantity as OrderQuantity,
      LinkNo, EndDate, OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID, OT2002.RefSOrderID,
      nvarchar01,nvarchar02,nvarchar03,nvarchar04,nvarchar05,nvarchar06,nvarchar07,nvarchar08,nvarchar09,nvarchar10,
      M37.DS01ID as S01ID, M37.DS02ID as S02ID, M37.DS03ID as S03ID, M37.DS04ID as S04ID, M37.DS05ID as S05ID, M37.DS06ID as S06ID, M37.DS07ID as S07ID, M37.DS08ID as S08ID, M37.DS09ID as S09ID, M37.DS10ID as S10ID,
      M37.DS11ID as S11ID, M37.DS12ID as S12ID, M37.DS13ID as S13ID, M37.DS14ID as S14ID, M37.DS15ID as S15ID, M37.DS16ID as S16ID, M37.DS17ID as S17ID, M37.DS18ID as S18ID, M37.DS19ID as S19ID, M37.DS20ID as S20ID, M36.ProductQuantity,
      M37.MaterialID, A02.InventoryName AS MaterialName, M37.MaterialUnitID, SUM(ISNULL(M37.MaterialQuantity,0)) as MaterialQuantity, M37.ExpenseID, M37.Orders
      '
SET @sSQL1 = '      
FROM OT2002 inner join OT2001 on OT2002.SOrderID = OT2001.SOrderID AND OT2002.DivisionID = OT2001.DivisionID
      Inner Join AT1302 on AT1302.InventoryID = OT2002.InventoryID AND AT1302.DivisionID = OT2002.DivisionID
      Left Join OV2906 on OV2906.TransactionID = OT2002.TransactionID AND OV2906.DivisionID = OT2002.DivisionID
      LEFT JOIN OT8899 O99 ON O99.DivisionID = OT2002.DivisionID AND O99.VoucherID = OT2002.SOrderID AND O99.TransactionID = OT2002.TransactionID
      LEFT JOIN MT0136 M36 ON M36.DivisionID = OT2001.DivisionID AND M36.ApportionID = OT2001.InheritApportionID AND M36.ProductID = OT2002.InventoryID  AND 
					ISNULL (M36.S01ID,'''') = ISNULL (O99.S01ID,'''') AND 
					ISNULL (M36.S02ID,'''') = ISNULL (O99.S02ID,'''') AND 
					ISNULL (M36.S03ID,'''') = ISNULL (O99.S03ID,'''') AND 
					ISNULL (M36.S04ID,'''') = ISNULL (O99.S04ID,'''') AND 
					ISNULL (M36.S05ID,'''') = ISNULL (O99.S05ID,'''') AND 
					ISNULL (M36.S06ID,'''') = ISNULL (O99.S06ID,'''') AND 
					ISNULL (M36.S07ID,'''') = ISNULL (O99.S07ID,'''') AND 
					ISNULL (M36.S08ID,'''') = ISNULL (O99.S08ID,'''') AND 
					ISNULL (M36.S09ID,'''') = ISNULL (O99.S09ID,'''') AND 
					ISNULL (M36.S10ID,'''') = ISNULL (O99.S10ID,'''') AND 
					ISNULL (M36.S11ID,'''') = ISNULL (O99.S11ID,'''') AND 
					ISNULL (M36.S12ID,'''') = ISNULL (O99.S12ID,'''') AND 
					ISNULL (M36.S13ID,'''') = ISNULL (O99.S13ID,'''') AND 
					ISNULL (M36.S14ID,'''') = ISNULL (O99.S14ID,'''') AND 
					ISNULL (M36.S15ID,'''') = ISNULL (O99.S15ID,'''') AND 
					ISNULL (M36.S16ID,'''') = ISNULL (O99.S16ID,'''') AND 
					ISNULL (M36.S17ID,'''') = ISNULL (O99.S17ID,'''') AND 
					ISNULL (M36.S18ID,'''') = ISNULL (O99.S18ID,'''') AND 
					ISNULL (M36.S19ID,'''') = ISNULL (O99.S19ID,'''') AND 
					ISNULL (M36.S20ID,'''') = ISNULL (O99.S20ID,'''')
		LEFT JOIN MT0137 M37 ON M37.DivisionID = M36.DivisionID AND M37.ProductID = M36.ProductID AND M37.ReTransactionID = M36.TransactionID AND M37.ExpenseID =''COST001''
	    INNER JOIN AT1302 A02 ON A02.DivisionID = M37.DivisionID AND A02.InventoryID = M37.MaterialID
WHERE OrderType = 1 and OT2002.SOrderID in ('+@ListSOrderID+')
      AND OT2002.DivisionID = '''+@DivisionID+'''
      AND OT2002.TransactionID in ('+@ListTransactionID+')
      '
      
SET @sSQL2 = '
GROUP BY OT2002.Description, OT2002.SOrderID, OT2002.RefInfor, OT2002.UnitID, EndQuantity,
      LinkNo, EndDate, OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID, OT2002.RefSOrderID,
      nvarchar01,nvarchar02,nvarchar03,nvarchar04,nvarchar05,nvarchar06,nvarchar07,nvarchar08,nvarchar09,nvarchar10,
      M37.DS01ID, M37.DS02ID, M37.DS03ID, M37.DS04ID, M37.DS05ID, M37.DS06ID, M37.DS07ID, M37.DS08ID, M37.DS09ID, M37.DS10ID,
      M37.DS11ID, M37.DS12ID, M37.DS13ID, M37.DS14ID, M37.DS15ID, M37.DS16ID, M37.DS17ID, M37.DS18ID, M37.DS19ID, M37.DS20ID, M36.ProductQuantity,
      M37.MaterialID, A02.InventoryName, M37.MaterialUnitID, M37.MaterialQuantity, M37.ExpenseID, M37.Orders
ORDER BY OT2002.SOrderID, M37.Orders      '      
PRINT @sSQL
PRINT @sSQL1
PRINT @sSQL2     		
EXEC (@sSQL + @sSQL1+@sSQL2)

SET NOCOUNT OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON	  
