IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[OP3119]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[OP3119]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---------Created by Nguyen Thuy Tuyen.
--------  Ke thua don hang san xuat cho man hinh yêu c?u mua hàng.
------ Date 17/05/2005

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/
---- Modified on 24/07/2013 by Lê Thị Thu Hiền : Bổ sung DivisionID 
---- Modified on 29/07/2013 by Lê Thị Thu Hiền : Bổ sung NotesMater Diễn giải master
---- Modified on 19/11/2015 by Tiểu Mai: Sửa không tạo view, bổ sung thông tin quy cách hàng hóa khi có thiết lập quản lý mặt hàng theo quy cách.
---- EXEC OP3119 '', 'AS'
---- SELECT * FROM OV3119
CREATE PROCEDURE [dbo].[OP3119]  
			@SOrderID  nvarchar(50),
			@DivisionID AS NVARCHAR(50) = ''
				
	
 AS
 Declare  @sSQL as nvarchar(4000)

IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
	Set  @sSQL ='
		SELECT DISTINCT
			OT2001.DivisionID,
			OT2001.ObjectID,
			AT1202.ObjectName,
			AT1202.VatNo,
			AT1202.Address,
			OT2002.TransactionID, OT2002.SOrderID, 
			AT1302.Barcode,
			OT2002.InventoryID,
			AT1302.InventoryName,
			OT2002.MethodID, 
			OT2002.OrderQuantity, OT2002.SalePrice, 
			OT2002.ConvertedAmount, OT2002.OriginalAmount, 
			OT2002.VATOriginalAmount, OT2002.VATConvertedAmount, OT2002.VATPercent, 
			OT2002.DiscountConvertedAmount, OT2002.DiscountPercent, 
			OT2002.IsPicking, OT2002.WareHouseID,
			OT2002.LinkNo, OT2002.EndDate, OT2002.Orders, OT2002.Description, 
			OT2002.RefInfor, 
			OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID,
			OT2002.Ana06ID, OT2002.Ana07ID, OT2002.Ana08ID, OT2002.Ana09ID, OT2002.Ana10ID,
			OT2002.InventoryCommonName, OT2002.UnitID, OT2002.Finish, 
			OT2002.AdjustQuantity, OT2002.FileID, OT2002.RefOrderID, OT2002.SourceNo,
			OT2002.Cal01, OT2002.Cal02, OT2002.Cal03, OT2002.Cal04, OT2002.Cal05, OT2002.Cal06,
			OT2002.Cal07, OT2002.Cal08, OT2002.Cal09, OT2002.Cal10,
			OT2002.Notes, OT2002.Notes01, OT2002.Notes02,
			OT2001.Notes AS NotesMaster,
			O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID
		FROM	OT2002
		INNER JOIN OT2001 on OT2001.SOrderID = OT2002.SOrderID AND OT2001.DivisionID = OT2002.DivisionID
		LEFT JOIN AT1202 on AT1202.ObjectID = OT2001.ObjectID AND AT1202.DivisionID = OT2002.DivisionID
		LEFT JOIN AT1302 on AT1302.InventoryID = OT2002.InventoryID AND AT1302.DivisionID = OT2002.DivisionID
		LEFT JOIN OT8899 O99 ON O99.DivisionID = OT2002.DivisionID AND O99.VoucherID = OT2002.SOrderID AND O99.TransactionID = OT2002.TransactionID AND O99.TableID = ''OT2002''
		WHERE	OrderType = 1 and OT2001.Disabled =0
				AND OT2002. SOrderID ='''+@SOrderID+'''
				AND OT2002.DivisionID = '''+@DivisionID+'''
		' 
ELSE
	Set  @sSQL ='
		SELECT DISTINCT
			OT2001.DivisionID,
			OT2001.ObjectID,
			AT1202.ObjectName,
			AT1202.VatNo,
			AT1202.Address,
			OT2002.TransactionID, OT2002.SOrderID, 
			AT1302.Barcode,
			OT2002.InventoryID,
			AT1302.InventoryName,
			OT2002.MethodID, 
			OT2002.OrderQuantity, OT2002.SalePrice, 
			OT2002.ConvertedAmount, OT2002.OriginalAmount, 
			OT2002.VATOriginalAmount, OT2002.VATConvertedAmount, OT2002.VATPercent, 
			OT2002.DiscountConvertedAmount, OT2002.DiscountPercent, 
			OT2002.IsPicking, OT2002.WareHouseID,
			OT2002.LinkNo, OT2002.EndDate, OT2002.Orders, OT2002.Description, 
			OT2002.RefInfor, 
			OT2002.Ana01ID, OT2002.Ana02ID, OT2002.Ana03ID, OT2002.Ana04ID, OT2002.Ana05ID,
			OT2002.Ana06ID, OT2002.Ana07ID, OT2002.Ana08ID, OT2002.Ana09ID, OT2002.Ana10ID,
			OT2002.InventoryCommonName, OT2002.UnitID, OT2002.Finish, 
			OT2002.AdjustQuantity, OT2002.FileID, OT2002.RefOrderID, OT2002.SourceNo,
			OT2002.Cal01, OT2002.Cal02, OT2002.Cal03, OT2002.Cal04, OT2002.Cal05, OT2002.Cal06,
			OT2002.Cal07, OT2002.Cal08, OT2002.Cal09, OT2002.Cal10,
			OT2002.Notes, OT2002.Notes01, OT2002.Notes02,
			OT2001.Notes AS NotesMaster
		FROM	OT2002
		INNER JOIN OT2001 on OT2001.SOrderID = OT2002.SOrderID AND OT2001.DivisionID = OT2002.DivisionID
		LEFT JOIN AT1202 on AT1202.ObjectID = OT2001.ObjectID AND AT1202.DivisionID = OT2002.DivisionID
		LEFT JOIN AT1302 on AT1302.InventoryID = OT2002.InventoryID AND AT1302.DivisionID = OT2002.DivisionID
		WHERE	OrderType = 1 and OT2001.Disabled =0
				AND OT2002. SOrderID ='''+@SOrderID+'''
				AND OT2002.DivisionID = '''+@DivisionID+'''
		' 
                         
EXEC(@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

