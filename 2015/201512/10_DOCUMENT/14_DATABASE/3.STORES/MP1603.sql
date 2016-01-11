IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP1603]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP1603]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- <Summary>
---- Ke thua chao gia cho Bo dinh muc <Customize cho An Phú Gia>
-- <Param>
---- 
-- <Return>
---- 
-- <Reference>
---- 
-- <History>
---- Create on 04/09/2015 by Tiểu Mai
-- <Example>
---- 

--EXEC MP1603 'AS','QO/08/2015/0010','BMD.003'

CREATE PROCEDURE  [dbo].[MP1603] 
		@DivisionID nvarchar(50),
		@VoucherID nvarchar(200),
		@ApportionID NVARCHAR(50)
AS
DECLARE @sSQL nvarchar(4000)
SET  @VoucherID = 	Replace(@VoucherID, ',', ''',''')

SET @sSQL = '

IF EXISTS (SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N''tempdb.dbo.#MT1603APG'')) 

DROP TABLE #MT1603APG

SELECT	OT2102.DivisionID, 
		OT2102.QuotationID,
		OT2102.TransactionID,
		OT2102.Orders, 
		OT2102.InventoryID, 
		OT2102.UnitID, 
		OT2102.QuoQuantity,
		OT2102.QuoQuantity01,  
		UnitPrice = CASE WHEN ISNULL(OT2102.UnitPrice,0)<>0 then OT2102.UnitPrice ELSE (SUM(O02.OriginalAmount)/OT2102.QuoQuantity01) end,
		OriginalAmount = CASE WHEN AT1302.InventoryTypeID = ''NVL'' then OT2102.UnitPrice * OT2102.QuoQuantity ELSE (SUM(O02.OriginalAmount)/OT2102.QuoQuantity01) * OT2102.QuoQuantity01 end , 
		ConvertedAmount = CASE WHEN AT1302.InventoryTypeID = ''NVL'' then OT2102.UnitPrice * OT2102.QuoQuantity ELSE (SUM(O02.ConvertedAmount)/OT2102.QuoQuantity01) * OT2102.QuoQuantity01 END,	 			
		OT2102.Notes,
		--OT2102.ConvertedQuantity,
		--OT2102.ConvertedSalePrice,
		AT1302.InventoryTypeID,
		OT2102.QD01, OT2102.QD02,OT2102.Ana02ID
INTO #MT1603APG		
FROM	OT2102 
LEFT JOIN AT1302 on AT1302.InventoryID = OT2102.InventoryID And AT1302.DivisionID = OT2102.DivisionID 
LEFT JOIN AT1010 ON AT1010.DivisionID = OT2102.DivisionID AND AT1010.VATGroupID = OT2102.VATGroupID
LEFT JOIN OT2102 O02 ON O02.DivisionID = OT2102.DivisionID AND O02.QuotationID = OT2102.QuotationID AND O02.Ana02ID = OT2102.Ana02ID
WHERE	OT2102.DivisionID = ''' + @DivisionID + ''' and 
		OT2102.QuotationID in  (''' + @VoucherID + ''') 
GROUP BY OT2102.OriginalAmount,OT2102.InventoryID, OT2102.Ana02ID,OT2102.QuoQuantity01,OT2102.QuoQuantity, OT2102.DivisionID,OT2102.TransactionID,OT2102.QuotationID,
		OT2102.Orders, OT2102.UnitID, OT2102.UnitPrice,  
		OT2102.ConvertedAmount,
		OT2102.Ana01ID, OT2102.Ana02ID, 
		OT2102.Notes,OT2102.Notes01,OT2102.Notes02,
		OT2102.QD01, OT2102.QD02,AT1302.InventoryTypeID

INSERT INTO MT1603(ApportionProductID,DivisionID, ApportionID, MaterialID,ProductID, ExpenseID, MaterialAmount, QuantityUnit, 
ConvertedUnit, MaterialQuantity, MaterialUnitID, MaterialPrice, IsExtraMaterial,InheritQuotationID,InheritTableID,InheritTransactionID,
DParameter01,DParameter02,DParameter03 )
SELECT NEWID(), t.DivisionID,'''+ @ApportionID +''',t.InventoryID,'''',''COST001'',t.OriginalAmount,t.QuoQuantity,t.ConvertedAmount,
t.QuoQuantity,t.UnitID,t.UnitPrice,0, t.QuotationID,''OT2102'',t.TransactionID,t.QD01,t.QD02,t.Notes FROM #MT1603APG t
WHERE t.InventoryTypeID = ''NVL''AND 	
	t.TransactionID NOT IN (SELECT M03.InheritTransactionID FROM MT1603 M03 WHERE M03.DivisionID = ''' + @DivisionID + ''' AND M03.InheritQuotationID = ''' + @VoucherID + ''' AND M03.ApportionID = '''+ @ApportionID +''')	

UPDATE MT1603
SET ProductID = t1.InventoryID,
				UnitID = t1.UnitID,
				ProductQuantity = 1,
				MParameter01 = t1.QD01,
				MParameter02 = t1.QD02,
				MParameter03 = t1.Notes
FROM MT1603
INNER JOIN #MT1603APG t ON MT1603.InheritQuotationID = t.QuotationID And MT1603.InheritTransactionID = t.TransactionID
INNER JOIN (SELECT Ana02ID, InventoryID, UnitID, QuoQuantity01, QD01, QD02, Notes
			FROM #MT1603APG Where InventoryTypeID = ''TP'') t1 ON t.Ana02ID = t1.Ana02ID AND QuotationID = MT1603.InheritQuotationID
WHERE MT1603.DivisionID = ''' + @DivisionID + ''' And MT1603.ApportionID = ''' + @ApportionID + '''

'
EXEC (@sSQL)
--PRINT(@sSQL)
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
