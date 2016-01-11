IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0107]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0107]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--- Creater by Bảo Anh	Date: 20/01/2014
--- Purpose: Hiển thị dữ liệu chi tiết cho màn hình chọn đơn hàng bán CF0106 (Sinolife)
--- Modify on 31/12/2015 by Bảo Anh: Bổ sung cho Angel
--- AP0107 'AS','SO/03/2012/0001'

CREATE PROCEDURE [dbo].[AP0107]  
				@DivisionID nvarchar(50),
				@SOrderID nvarchar (50)
AS

Declare @sSQL AS nvarchar(4000),
		@CustomerIndex as tinyint
		
SELECT @CustomerIndex = CustomerName FROM CustomerIndex

Set @sSQL= N'
Select
		OT2002.TransactionID,
		OT2002.InventoryID, 
		(case when isnull(OT2002.InventoryCommonName, '''') = '''' then AT1302.InventoryName else OT2002.InventoryCommonName end) AS 
		InventoryName, 		
		AT1302.UnitID,
		AT1304.UnitName,
		OT2002.OrderQuantity, 
		SalePrice, 
		ConvertedAmount, 
		OriginalAmount,
		VATGroupID,
		VATPercent,
		VATOriginalAmount,
		VATConvertedAmount,
		DiscountPercent,
		DiscountOriginalAmount,
		DiscountConvertedAmount,
		OT2002.Ana08ID,
		T08.AnaName as Ana08Name,
		OT2002.Ana09ID,
		T09.AnaName as Ana09Name,
		OT2002.Notes,'

IF @CustomerIndex = 20 --- Sinolife
	Set @sSQL= @sSQL + N'
		(Isnull((Select top 1 1 From AT1020 Where DivisionID = OT2002.DivisionID And STransactionID = OT2002.TransactionID),0)) as IsSelected'
ELSE --- Angel
	Set @sSQL= N'
	(Isnull((Select top 1 1 From AT1031 Where DivisionID = OT2002.DivisionID And InheritVoucherID = OT2002.SOrderID and InheritTransactionID = OT2002.TransactionID),0)) as IsSelected'

Set @sSQL= @sSQL + N'
From OT2002
LEFT JOIN AT1302 on AT1302.InventoryID= OT2002.InventoryID And AT1302.DivisionID = OT2002.DivisionID
LEFT JOIN AT1304 on AT1302.UnitID= AT1304.UnitID And AT1302.DivisionID = AT1304.DivisionID
LEFT JOIN AT1011 T08 on T08.DivisionID = OT2002.DivisionID And T08.AnaID= OT2002.Ana08ID And T08.AnaTypeID = ''A08''
LEFT JOIN AT1011 T09 on T09.DivisionID = OT2002.DivisionID And T09.AnaID= OT2002.Ana08ID And T09.AnaTypeID = ''A09''
Where  OT2002.DivisionID = ''' + @DivisionID + ''' AND OT2002.SOrderID = ''' + @SOrderID + ''' ORDER BY Orders'

EXEC(@sSQL)