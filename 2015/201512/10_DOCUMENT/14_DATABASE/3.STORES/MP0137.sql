IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0137]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP0137]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- <Summary>
---- In bộ định mức theo quy cách - MF0136
-- <History>
---- Created by Tiểu Mai on 25/12/2015
---- Modified on ... by 
-- <Example>


CREATE PROCEDURE [dbo].[MP0137] 	
	@DivisionID NVARCHAR(50),
	@ApportionID NVARCHAR(50)
AS
DECLARE @sSQL NVARCHAR(MAX), @sSQL1 NVARCHAR(MAX), 
		@sSQL2 NVARCHAR(MAX), @sSQL3 NVARCHAR(MAX)

SET @sSQL = '
SELECT MT0135.DivisionID, MT0135.ApportionID, MT0135.[Description], MT0135.ObjectID, AT1202.ObjectName,MT0135.InventoryTypeID,AT1301.InventoryTypeName, MT0135.[Disabled], MT0135.ApportionTypeID,
MT0135.IsBOM, MT0136.TransactionID, MT0136.ProductID,AT1302.InventoryName, MT0136.UnitID, MT0136.ProductQuantity,MT0136.S01ID, MT0136.S02ID, MT0136.S03ID, MT0136.S04ID, MT0136.S05ID,
MT0136.S06ID, MT0136.S07ID, MT0136.S08ID, MT0136.S09ID, MT0136.S10ID, MT0136.S11ID, MT0136.S12ID, MT0136.S13ID, MT0136.S14ID, MT0136.S15ID,
MT0136.S16ID, MT0136.S17ID, MT0136.S18ID, MT0136.S19ID, MT0136.S20ID, MT0136.Parameter01, MT0136.Parameter02, MT0136.Parameter03, MT0136.Orders,
TotalAmount = ( Select Sum(Case When A.ExpenseID =''COST001''  Or  A.ExpenseID <>''COST001'' and MT0699.IsUsed = 1
 				then IsNull(MaterialAmount,0) Else 0 End )  	From  MT0137  A  Left join  MT0699 on MT0699.MaterialTypeID = A.MaterialTypeID  and MT0699.DivisionID = A.DivisionID
								Where  A.ProductID = MT0137.ProductID  and A.DivisionID = MT0137.DivisionID AND A.ReTransactionID = MT0136.TransactionID
								),
Sum(Case when MT0137.ExpenseID =''COST001''  then 	isnull(MaterialAmount,0) else 0 end) as TotalAmount621,
Sum(Case when MT0137.ExpenseID =''COST002'' And MT0699.IsUsed=1 then 	isnull(MaterialAmount,0) else 0 end) as TotalAmount622,
Sum(Case when MT0137.ExpenseID =''COST003'' And MT0699.IsUsed=1 then 	isnull(MaterialAmount,0) else 0 end) as TotalAmount627,
ProductCost = ( Select Sum(Case When A.ExpenseID =''COST001''  Or  A.ExpenseID <>''COST001'' and MT0699.IsUsed = 1
 				then IsNull(MaterialAmount,0) Else 0 End )  	From  MT0137  A  Left join  MT0699 on MT0699.MaterialTypeID = A.MaterialTypeID  and MT0699.DivisionID = A.DivisionID
								Where A.ProductID = MT0137.ProductID and A.DivisionID = MT0137.DivisionID and A.ReTransactionID = MT0137.ReTransactionID)/isnull(MT0136.ProductQuantity,1),
MT0137.MaterialID, A50.InventoryName as MaterialName, MT0137.MaterialUnitID, MT0137.MaterialQuantity, MT0137.MaterialPrice, MT0137.MaterialAmount,							
MT0137.Rate, MT0137.RateDecimalApp, MT0137.ExpenseID, MT0137.IsExtraMaterial, MT0137.WasteID, MT0137.MaterialGroupID,
MT0137.[Description] as DDescription , MT0137.DParameter01, MT0137.DParameter02, MT0137.DParameter03,
MT0137.DS01ID, MT0137.DS02ID, MT0137.DS03ID, MT0137.DS04ID, MT0137.DS05ID, MT0137.DS06ID, MT0137.DS07ID, MT0137.DS08ID, MT0137.DS09ID, MT0137.DS10ID,
MT0137.DS11ID, MT0137.DS12ID, MT0137.DS13ID, MT0137.DS14ID, MT0137.DS15ID, MT0137.DS16ID, MT0137.DS17ID, MT0137.DS18ID, MT0137.DS19ID, MT0137.DS20ID,

A01.StandardName AS S01Name, A02.StandardName AS S02Name, A03.StandardName AS S03Name, A04.StandardName AS S04Name, A05.StandardName AS S05Name,
A06.StandardName AS S06Name, A07.StandardName AS S07Name, A08.StandardName AS S08Name, A09.StandardName AS S09Name, A10.StandardName AS S10Name,
A11.StandardName AS S11Name, A12.StandardName AS S12Name, A13.StandardName AS S13Name, A14.StandardName AS S14Name, A15.StandardName AS S15Name,
A16.StandardName AS S16Name, A17.StandardName AS S17Name, A18.StandardName AS SName18, A19.StandardName AS S19Name, A20.StandardName AS S20Name,
 
A21.StandardName AS DS01Name, A22.StandardName AS DS02Name, A23.StandardName AS DS03Name, A24.StandardName AS DS04Name, A25.StandardName AS DS05Name,
A26.StandardName AS DS06Name, A27.StandardName AS DS07Name, A28.StandardName AS DS08Name, A29.StandardName AS DS09Name, A20.StandardName AS DS10Name,
A31.StandardName AS DS11Name, A32.StandardName AS DS12Name, A33.StandardName AS DS13Name, A34.StandardName AS DS14Name, A35.StandardName AS DS15Name,
A36.StandardName AS DS16Name, A37.StandardName AS DS17Name, A38.StandardName AS DSName18, A39.StandardName AS DS19Name, A40.StandardName AS DS20Name
'
SET @sSQL1 = '	
From MT0135
LEFT JOIN MT0136 ON MT0135.DivisionID = MT0136.DivisionID AND MT0135.ApportionID = MT0136.ApportionID
LEFT JOIN MT0137 ON MT0136.DivisionID = MT0137.DivisionID AND MT0136.ProductID = MT0137.ProductID AND MT0137.ReTransactionID = MT0136.TransactionID
Left  join MT0699 on  MT0699.MaterialTypeID = MT0137.MaterialTypeID and MT0699.DivisionID = MT0137.DivisionID
LEFT JOIN AT1202 ON AT1202.ObjectID = MT0135.ObjectID AND AT1202.DivisionID = MT0135.DivisionID
LEFT JOIN AT1301 ON AT1301.DivisionID = AT1202.DivisionID AND AT1301.InventoryTypeID = MT0135.InventoryTypeID
LEFT JOIN AT1302 ON AT1302.DivisionID = MT0136.DivisionID AND At1302.InventoryID = Mt0136.ProductID
LEFT JOIN AT1302 A50 ON A50.DivisionID = MT0137.DivisionID AND A50.InventoryID = MT0137.MaterialID
LEFT JOIN AT0128 A01 ON A01.DivisionID = MT0136.DivisionID AND A01.StandardID = MT0136.S01ID AND A01.StandardTypeID = ''S01''
LEFT JOIN AT0128 A02 ON A02.DivisionID = MT0136.DivisionID AND A02.StandardID = MT0136.S02ID AND A02.StandardTypeID = ''S02''
LEFT JOIN AT0128 A03 ON A03.DivisionID = MT0136.DivisionID AND A03.StandardID = MT0136.S03ID AND A03.StandardTypeID = ''S03''
LEFT JOIN AT0128 A04 ON A04.DivisionID = MT0136.DivisionID AND A04.StandardID = MT0136.S04ID AND A04.StandardTypeID = ''S04''
LEFT JOIN AT0128 A05 ON A05.DivisionID = MT0136.DivisionID AND A05.StandardID = MT0136.S05ID AND A05.StandardTypeID = ''S05''
LEFT JOIN AT0128 A06 ON A06.DivisionID = MT0136.DivisionID AND A06.StandardID = MT0136.S06ID AND A06.StandardTypeID = ''S06''
LEFT JOIN AT0128 A07 ON A07.DivisionID = MT0136.DivisionID AND A07.StandardID = MT0136.S07ID AND A07.StandardTypeID = ''S07''
LEFT JOIN AT0128 A08 ON A08.DivisionID = MT0136.DivisionID AND A08.StandardID = MT0136.S08ID AND A08.StandardTypeID = ''S08''
LEFT JOIN AT0128 A09 ON A09.DivisionID = MT0136.DivisionID AND A09.StandardID = MT0136.S09ID AND A09.StandardTypeID = ''S09''
LEFT JOIN AT0128 A10 ON A10.DivisionID = MT0136.DivisionID AND A10.StandardID = MT0136.S10ID AND A10.StandardTypeID = ''S10''
LEFT JOIN AT0128 A11 ON A11.DivisionID = MT0136.DivisionID AND A11.StandardID = MT0136.S11ID AND A11.StandardTypeID = ''S11''
LEFT JOIN AT0128 A12 ON A12.DivisionID = MT0136.DivisionID AND A12.StandardID = MT0136.S12ID AND A12.StandardTypeID = ''S12''
LEFT JOIN AT0128 A13 ON A13.DivisionID = MT0136.DivisionID AND A13.StandardID = MT0136.S13ID AND A13.StandardTypeID = ''S13''
LEFT JOIN AT0128 A14 ON A14.DivisionID = MT0136.DivisionID AND A14.StandardID = MT0136.S14ID AND A14.StandardTypeID = ''S14''
LEFT JOIN AT0128 A15 ON A15.DivisionID = MT0136.DivisionID AND A15.StandardID = MT0136.S15ID AND A15.StandardTypeID = ''S15''
LEFT JOIN AT0128 A16 ON A16.DivisionID = MT0136.DivisionID AND A16.StandardID = MT0136.S16ID AND A16.StandardTypeID = ''S16''
LEFT JOIN AT0128 A17 ON A17.DivisionID = MT0136.DivisionID AND A17.StandardID = MT0136.S17ID AND A17.StandardTypeID = ''S17''
LEFT JOIN AT0128 A18 ON A18.DivisionID = MT0136.DivisionID AND A18.StandardID = MT0136.S18ID AND A18.StandardTypeID = ''S18''
LEFT JOIN AT0128 A19 ON A19.DivisionID = MT0136.DivisionID AND A19.StandardID = MT0136.S19ID AND A19.StandardTypeID = ''S19''
LEFT JOIN AT0128 A20 ON A20.DivisionID = MT0136.DivisionID AND A20.StandardID = MT0136.S20ID AND A20.StandardTypeID = ''S20''
'
SET @sSQL2 = '
LEFT JOIN AT0128 A21 ON A21.DivisionID = MT0137.DivisionID AND A21.StandardID = MT0137.DS01ID AND A21.StandardTypeID = ''S01''
LEFT JOIN AT0128 A22 ON A22.DivisionID = MT0137.DivisionID AND A22.StandardID = MT0137.DS02ID AND A22.StandardTypeID = ''S02''
LEFT JOIN AT0128 A23 ON A23.DivisionID = MT0137.DivisionID AND A23.StandardID = MT0137.DS03ID AND A23.StandardTypeID = ''S03''
LEFT JOIN AT0128 A24 ON A24.DivisionID = MT0137.DivisionID AND A24.StandardID = MT0137.DS04ID AND A24.StandardTypeID = ''S04''
LEFT JOIN AT0128 A25 ON A25.DivisionID = MT0137.DivisionID AND A25.StandardID = MT0137.DS05ID AND A25.StandardTypeID = ''S05''
LEFT JOIN AT0128 A26 ON A26.DivisionID = MT0137.DivisionID AND A26.StandardID = MT0137.DS06ID AND A26.StandardTypeID = ''S06''
LEFT JOIN AT0128 A27 ON A27.DivisionID = MT0137.DivisionID AND A27.StandardID = MT0137.DS07ID AND A27.StandardTypeID = ''S07''
LEFT JOIN AT0128 A28 ON A28.DivisionID = MT0137.DivisionID AND A28.StandardID = MT0137.DS08ID AND A28.StandardTypeID = ''S08''
LEFT JOIN AT0128 A29 ON A29.DivisionID = MT0137.DivisionID AND A29.StandardID = MT0137.DS09ID AND A29.StandardTypeID = ''S09''
LEFT JOIN AT0128 A30 ON A30.DivisionID = MT0137.DivisionID AND A30.StandardID = MT0137.DS10ID AND A30.StandardTypeID = ''S10''
LEFT JOIN AT0128 A31 ON A31.DivisionID = MT0137.DivisionID AND A31.StandardID = MT0137.DS11ID AND A31.StandardTypeID = ''S11''
LEFT JOIN AT0128 A32 ON A32.DivisionID = MT0137.DivisionID AND A32.StandardID = MT0137.DS12ID AND A32.StandardTypeID = ''S12''
LEFT JOIN AT0128 A33 ON A33.DivisionID = MT0137.DivisionID AND A33.StandardID = MT0137.DS13ID AND A33.StandardTypeID = ''S13''
LEFT JOIN AT0128 A34 ON A34.DivisionID = MT0137.DivisionID AND A34.StandardID = MT0137.DS14ID AND A34.StandardTypeID = ''S14''
LEFT JOIN AT0128 A35 ON A35.DivisionID = MT0137.DivisionID AND A35.StandardID = MT0137.DS15ID AND A35.StandardTypeID = ''S15''
LEFT JOIN AT0128 A36 ON A36.DivisionID = MT0137.DivisionID AND A36.StandardID = MT0137.DS16ID AND A36.StandardTypeID = ''S16''
LEFT JOIN AT0128 A37 ON A37.DivisionID = MT0137.DivisionID AND A37.StandardID = MT0137.DS17ID AND A37.StandardTypeID = ''S17''
LEFT JOIN AT0128 A38 ON A38.DivisionID = MT0137.DivisionID AND A38.StandardID = MT0137.DS18ID AND A38.StandardTypeID = ''S18''
LEFT JOIN AT0128 A39 ON A39.DivisionID = MT0137.DivisionID AND A39.StandardID = MT0137.DS19ID AND A39.StandardTypeID = ''S19''
LEFT JOIN AT0128 A40 ON A40.DivisionID = MT0137.DivisionID AND A40.StandardID = MT0137.DS20ID AND A40.StandardTypeID = ''S20'''

SET @sSQL3 = '
WHERE MT0135.ApportionID = '''+@ApportionID+'''
		AND MT0135.DivisionID = '''+@DivisionID+'''
Group by MT0137.DivisionID, MT0135.DivisionID, MT0135.ApportionID, MT0135.[Description], MT0135.ObjectID, AT1202.ObjectName,MT0135.InventoryTypeID,AT1301.InventoryTypeName, MT0135.[Disabled], MT0135.ApportionTypeID,
MT0135.IsBOM, MT0136.TransactionID, MT0136.ProductID,AT1302.InventoryName, MT0136.UnitID, MT0136.ProductQuantity,MT0136.S01ID, MT0136.S02ID, MT0136.S03ID, MT0136.S04ID, MT0136.S05ID,
MT0136.S06ID, MT0136.S07ID, MT0136.S08ID, MT0136.S09ID, MT0136.S10ID, MT0136.S11ID, MT0136.S12ID, MT0136.S13ID, MT0136.S14ID, MT0136.S15ID,
MT0136.S16ID, MT0136.S17ID, MT0136.S18ID, MT0136.S19ID, MT0136.S20ID,
MT0137.ProductID,	ProductQuantity, MT0136.TransactionID, MT0136.Parameter01, MT0136.Parameter02, MT0136.Parameter03, MT0137.ReTransactionID, MT0136.Orders,
MT0137.MaterialID, A50.InventoryName, MT0137.MaterialUnitID, MT0137.MaterialQuantity, MT0137.MaterialPrice, MT0137.MaterialAmount,							
MT0137.Rate, MT0137.RateDecimalApp, MT0137.ExpenseID, MT0137.IsExtraMaterial, MT0137.WasteID, MT0137.MaterialGroupID,
MT0137.[Description], MT0137.DParameter01, MT0137.DParameter02, MT0137.DParameter03,
MT0137.DS01ID, MT0137.DS02ID, MT0137.DS03ID, MT0137.DS04ID, MT0137.DS05ID, MT0137.DS06ID, MT0137.DS07ID, MT0137.DS08ID, MT0137.DS09ID, MT0137.DS10ID,
MT0137.DS11ID, MT0137.DS12ID, MT0137.DS13ID, MT0137.DS14ID, MT0137.DS15ID, MT0137.DS16ID, MT0137.DS17ID, MT0137.DS18ID, MT0137.DS19ID, MT0137.DS20ID,

A01.StandardName, A02.StandardName, A03.StandardName, A04.StandardName, A05.StandardName,
A06.StandardName, A07.StandardName, A08.StandardName, A09.StandardName, A10.StandardName,
A11.StandardName, A12.StandardName, A13.StandardName, A14.StandardName, A15.StandardName,
A16.StandardName, A17.StandardName, A18.StandardName, A19.StandardName, A20.StandardName,
 
A21.StandardName, A22.StandardName, A23.StandardName, A24.StandardName, A25.StandardName,
A26.StandardName, A27.StandardName, A28.StandardName, A29.StandardName, A20.StandardName,
A31.StandardName, A32.StandardName, A33.StandardName, A34.StandardName, A35.StandardName,
A36.StandardName, A37.StandardName, A38.StandardName, A39.StandardName, A40.StandardName
Order by MT0136.Orders
' 
EXEC (@sSQL + @sSQL1 + @sSQL2 + @sSQL3)
--PRINT @sSQL
--PRINT @sSQL1
--PRINT @sSQL2
--PRINT @sSQL3


GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
