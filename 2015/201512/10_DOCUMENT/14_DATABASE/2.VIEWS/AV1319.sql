IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV1319]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AV1319]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Created by  Nguyen Quoc Huy
--Date: 14/05/2007
--View chet dung cho viec lay ten don vi tinh chuyen doi.
-- Last edit: Thuy Tuyen, them truong 
-- Edit by : Quốc Tuấn by 01/10/2015 bổ sung thêm bảng AT1302
CREATE VIEW [dbo].[AV1319] AS 	
SELECT AT1309.DivisionID,AT1309.InventoryID, AT1309.UnitID, AT1309.ConversionFactor, AT1309.Disabled ,AT1304.UnitName ,
AT1309.Operator

FROM  AT1309 	Left Join AT1304 ON  (AT1309.UnitID = AT1304.UnitID and AT1309.DivisionID = AT1304.DivisionID)
UNION ALL
SELECT  AT1302.DivisionID,AT1302.InventoryID, AT1302.UnitID, 1 ConversionFactor, AT1302.Disabled ,AT1304.UnitName ,
0 Operator

From AT1302  	Left Join AT1304 ON  (AT1302.UnitID = AT1304.UnitID and AT1302.DivisionID = AT1304.DivisionID)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
