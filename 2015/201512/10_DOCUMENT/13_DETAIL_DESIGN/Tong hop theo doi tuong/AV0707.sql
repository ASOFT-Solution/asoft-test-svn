IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AV0707]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[AV0707]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--- Create on by
--- Modified on 22/01/2016 by Thị Phượng Thêm trường O05ID và IsBottle customize Hoàng Trần
SET QUOTED_IDENTIFIER ON
GO

 CREATE view [dbo].[AV0707] as 
SELECT DISTINCT
AV7000.ObjectID as ObjectID, 
AV7000.ObjectName as ObjectName, 	
AV7000.Address as Address, 
AV7000.InventoryID,
AV7000.InventoryName,
AV7000.UnitID,
AV7000.S1, AV7000.S2, AV7000.S3, AV7000.I01ID, AV7000.I02ID, AV7000.I03ID, AV7000.I04ID, AV7000.I05ID, 
ISNULL(AV7000.Parameter01,0) Parameter01, ISNULL(AV7000.Parameter02,0) Parameter02, ISNULL(AV7000.Parameter03,0) Parameter03, ISNULL(AV7000.Parameter04,0) Parameter04, ISNULL(AV7000.Parameter05,0) Parameter05, 
AV7000.InventoryTypeID, AV7000.Specification ,
AV7000.D02Notes01 , AV7000.D02Notes02 , AV7000.D02Notes03,
max(AV7000.Notes01) as Notes01, max(AV7000.Notes02) as Notes02, max(AV7000.Notes03) as Notes03, max(AV7000.Notes04) as Notes04, max(AV7000.Notes05) as Notes05,
max(AV7000.Notes06) as Notes06, max(AV7000.Notes07) as Notes07, max(AV7000.Notes08) as Notes08,	max(AV7000.Notes09) as Notes09, max(AV7000.Notes10) as Notes10,
max(AV7000.Notes11) as Notes11, max(AV7000.Notes12) as Notes12, max(AV7000.Notes13) as Notes13, max(AV7000.Notes14) as Notes14, max(AV7000.Notes15) as Notes15,
ISNULL(AV7000.SourceNo,'') SourceNo , AV7000.UnitName,	
0 as BeginQuantity,
0 as BeginConvertedQuantity,
0 as BeginAmount,
0 as BeginMarkQuantity,
Sum(Case when D_C = 'D' then isnull(AV7000.MarkQuantity,0) else 0 end) as DebitMarkQuantity,
Sum(Case when D_C = 'C' then isnull(AV7000.MarkQuantity,0) else 0 end) as CreditMarkQuantity,
Sum(Case when D_C = 'D' then isnull(AV7000.ActualQuantity,0) else 0 end) as DebitQuantity,
Sum(Case when D_C = 'C' then isnull(AV7000.ActualQuantity,0) else 0 end) as CreditQuantity,
Sum(Case when D_C = 'D' then isnull(AV7000.ConvertedQuantity,0) else 0 end) as DebitConvertedQuantity,
Sum(Case when D_C = 'C' then isnull(AV7000.ConvertedQuantity,0) else 0 end) as CreditConvertedQuantity,
Sum(Case when D_C = 'D' then isnull(AV7000.ConvertedAmount,0) else 0 end) as DebitAmount,
Sum(Case when D_C = 'C' then isnull(AV7000.ConvertedAmount,0) else 0 end) as CreditAmount,
AV7000.DivisionID, AV7000.O05ID, ISNULL(AV7000.IsBottle, 0) as IsBottle
From AV7000 Full join AV0709 on 	( AV0709.InventoryID = AV7000.InventoryID) and
				(AV0709.ObjectID = AV7000.ObjectID) AND AV0709.DivisionID = AV7000.DivisionID 		
Where 	ISNULL(AV7000.DivisionID, AV0709.DivisionID) ='AS' and
(AV7000.InventoryID between '0000000001' and 'VT007') and
(AV7000.WareHouseID like   'KHOBTTEMP' ) and
(AV7000.ObjectID between  'KH001' and  'KH006') and 
AV7000.D_C in ('D', 'C')  and (TranMonth+ 100*TranYear Between     201602 and      201602  )   
Group by  AV7000.ObjectID, AV7000.ObjectName, AV7000.Address,
AV7000.InventoryID, AV7000.InventoryName, AV7000.UnitID, AV7000.UnitName, 
AV7000.S1, AV7000.S2, AV7000.S3, AV7000.I01ID, AV7000.I02ID, AV7000.I03ID, AV7000.I04ID, AV7000.I05ID,
 ISNULL(AV7000.Parameter01,0), ISNULL(AV7000.Parameter02,0), ISNULL(AV7000.Parameter03,0), ISNULL(AV7000.Parameter04,0), ISNULL(AV7000.Parameter05,0), 
 AV7000.InventoryTypeID, AV7000.Specification,
AV7000.D02Notes01 , AV7000.D02Notes02 , AV7000.D02Notes03,
---AV7000.Notes01, AV7000.Notes02, AV7000.Notes03, AV7000.Notes04, AV7000.Notes05, AV7000.Notes06, AV7000.Notes07, AV7000.Notes08,
---	AV7000.Notes09, AV7000.Notes10, AV7000.Notes11, AV7000.Notes12, AV7000.Notes13, AV7000.Notes14, AV7000.Notes15,
ISNULL(AV7000.SourceNo,''), AV7000.DivisionID, AV7000.O05ID, ISNULL(AV7000.IsBottle, 0)
GO


