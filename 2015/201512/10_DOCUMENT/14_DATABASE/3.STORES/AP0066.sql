IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0066]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AP0066]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- <Summary>
--- Load edit phiếu bán hàng
-- <Param>
----
-- <Return>
----
-- <Reference>
----
-- <History>
---- Created by: Bảo Anh on: 30/09/2013
---- Modified on 15/09/2014 by Le Thi Thu Hien : Lấy thêm AT1010.VATRate
---- Modified on 28/10/2013 by Bảo Anh: Sửa cách lấy F11
---- Modified on 23/06/2015 by Thanh Sơn: bổ sung 20 mã phân tích quy cách hàng
---- Modified by Tiểu Mai on 16/12/2015: Bổ sung điều kiện left join AT8899
-- <Example>
/*
	EXEC AP0066 'TL','BL1/07/2013/0237'
*/

CREATE PROCEDURE AP0066
(
	@DivisionID nvarchar(50),
	@VoucherID nvarchar(50)
)
	
AS
SELECT AT9000.*, ISNULL(AT9000.InventoryName1, AT1302.InventoryName) InventoryName, 
	AT1302.MethodID, AT1302.DeliveryPrice, AT1302.IsSource,AT1302.IsLimitDate,AT1302.IsLocation, 
	AT1302.IsStocked, AT1302.AccountID as IsDebitAccountID, AT1302.Barcode, AT1302.IsDiscount,
	'' LocationID, '' SourceNo, CONVERT(DATETIME, NULL) LimitDate,
	(CASE WHEN ISNULL(AT1302.IsStocked, 0) = 0 THEN 1 ELSE 0 END) F11, 
	WQ1309.Operator, WQ1309.DataType, AT1319.FormulaDes, AT1010.VATRate,
	O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
	O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
	AT01.StandardName S01Name, AT02.StandardName S02Name, AT03.StandardName S03Name, AT04.StandardName S04Name, AT05.StandardName S05Name,
	AT06.StandardName S06Name, AT07.StandardName S07Name, AT08.StandardName S08Name, AT09.StandardName S09Name, AT10.StandardName S10Name,
	AT11.StandardName S11Name, AT12.StandardName S12Name, AT13.StandardName S13Name, AT14.StandardName S14Name, AT15.StandardName S15Name,
	AT16.StandardName S16Name, AT17.StandardName S17Name, AT18.StandardName S18Name, AT19.StandardName S19Name, AT20.StandardName S20Name
		
FROM AT9000 
	LEFT JOIN AT1302 On AT9000.DivisionID = AT1302.DivisionID AND AT9000.InventoryID = AT1302.InventoryID
	LEFT JOIN AT1309 WQ1309 On WQ1309.DivisionID = AT9000.DivisionID AND WQ1309.InventoryID = AT9000.InventoryID AND WQ1309.UnitID = AT9000.ConvertedUnitID
	LEFT JOIN AT1319 On WQ1309.DivisionID = AT1319.DivisionID and WQ1309.FormulaID = AT1319.FormulaID
	LEFT JOIN AT1010 On AT1010.DivisionID = AT9000.DivisionID and AT1010.VATGroupID = AT9000.VATGroupID
	LEFT JOIN AT8899 O99 ON O99.DivisionID = AT9000.DivisionID AND O99.VoucherID = AT9000.VoucherID AND  O99.TransactionID = AT9000.TransactionID
	LEFT JOIN AT0128 AT01 ON AT01.StandardID = O99.S01ID AND AT01.StandardTypeID = 'S01'
	LEFT JOIN AT0128 AT02 ON AT02.StandardID = O99.S02ID AND AT02.StandardTypeID = 'S02'
	LEFT JOIN AT0128 AT03 ON AT03.StandardID = O99.S03ID AND AT03.StandardTypeID = 'S03'
	LEFT JOIN AT0128 AT04 ON AT04.StandardID = O99.S04ID AND AT04.StandardTypeID = 'S04'
	LEFT JOIN AT0128 AT05 ON AT05.StandardID = O99.S05ID AND AT05.StandardTypeID = 'S05'
	LEFT JOIN AT0128 AT06 ON AT06.StandardID = O99.S06ID AND AT06.StandardTypeID = 'S06'
	LEFT JOIN AT0128 AT07 ON AT07.StandardID = O99.S07ID AND AT07.StandardTypeID = 'S07'
	LEFT JOIN AT0128 AT08 ON AT08.StandardID = O99.S08ID AND AT08.StandardTypeID = 'S08'
	LEFT JOIN AT0128 AT09 ON AT09.StandardID = O99.S09ID AND AT09.StandardTypeID = 'S09'
	LEFT JOIN AT0128 AT10 ON AT10.StandardID = O99.S10ID AND AT10.StandardTypeID = 'S10'
	LEFT JOIN AT0128 AT11 ON AT11.StandardID = O99.S11ID AND AT11.StandardTypeID = 'S11'
	LEFT JOIN AT0128 AT12 ON AT12.StandardID = O99.S12ID AND AT12.StandardTypeID = 'S12'
	LEFT JOIN AT0128 AT13 ON AT13.StandardID = O99.S13ID AND AT13.StandardTypeID = 'S13'
	LEFT JOIN AT0128 AT14 ON AT14.StandardID = O99.S15ID AND AT14.StandardTypeID = 'S14'
	LEFT JOIN AT0128 AT15 ON AT15.StandardID = O99.S15ID AND AT15.StandardTypeID = 'S15'
	LEFT JOIN AT0128 AT16 ON AT16.StandardID = O99.S16ID AND AT16.StandardTypeID = 'S16'
	LEFT JOIN AT0128 AT17 ON AT17.StandardID = O99.S17ID AND AT17.StandardTypeID = 'S17'
	LEFT JOIN AT0128 AT18 ON AT18.StandardID = O99.S18ID AND AT18.StandardTypeID = 'S18'
	LEFT JOIN AT0128 AT19 ON AT19.StandardID = O99.S19ID AND AT19.StandardTypeID = 'S19'
	LEFT JOIN AT0128 AT20 ON AT20.StandardID = O99.S20ID AND AT20.StandardTypeID = 'S20'
WHERE AT9000.DivisionID = @DivisionID
AND AT9000.VoucherID = @VoucherID
AND AT9000.TransactionTypeID IN ('T04','T64') 
ORDER BY AT9000.Orders

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
