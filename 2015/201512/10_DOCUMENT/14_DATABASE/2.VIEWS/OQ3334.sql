/****** Object:  View [dbo].[OQ3334]    Script Date: 12/16/2010 15:46:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--PP: Tao view lay ngay du kien dat hang 
--Creater:Thuy Tuyen
---isnull(Quantity:21/07/2009
ALTER VIEW [dbo].[OQ3334]
as
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity01,0)as Quantity , InventoryID, TransactionID, Date01 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all  
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity02,0)as  Quantity02, InventoryID, TransactionID , Date02 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select  OT3002.POrderID, OT3002.DivisionID, isnull(Quantity03,0)as Quantity03 , InventoryID, TransactionID , Date03 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity04,0)  as  Quantity04, InventoryID, TransactionID , Date04  From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select  OT3002.POrderID, OT3002.DivisionID, isnull(Quantity05,0)  as Quantity05 , InventoryID, TransactionID , Date05  From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity06,0) as Quantity06 , InventoryID, TransactionID , Date06 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity07,0) as Quantity07 , InventoryID, TransactionID , Date07 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID

union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity08,0) as Quantity08 , InventoryID, TransactionID , Date08 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity09,0) as Quantity09, InventoryID, TransactionID , Date09 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select  OT3002.POrderID,  OT3002.DivisionID, isnull(Quantity10,0)  as Quantity10, InventoryID, TransactionID , Date10 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID

union  all

 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity11,0)  as Quantity11 , InventoryID, TransactionID , Date11 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity12,0)  as Quantity12 , InventoryID, TransactionID , Date12 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity13,0)  as Quantity13 , InventoryID, TransactionID , Date13 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity14,0)  as Quantity14, InventoryID, TransactionID , Date14 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity15,0) as Quantity15 , InventoryID, TransactionID , Date15 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity16,0)  as Quantity16, InventoryID, TransactionID , Date16 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity17,0) as Quantity17 , InventoryID, TransactionID , Date17 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity18,0)  as Quantity18 , InventoryID, TransactionID , Date18 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity19,0)  as  Quantity19, InventoryID, TransactionID , Date19 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity20,0) as Quantity20 , InventoryID, TransactionID , Date20 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity21,0) as Quantity21 , InventoryID, TransactionID , Date21 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity22,0) as Quantity22 , InventoryID, TransactionID , Date22 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity23,0) as Quantity23 , InventoryID, TransactionID , Date23 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity24,0)  as Quantity24 , InventoryID, TransactionID , Date24 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity25,0)  as Quantity25 , InventoryID, TransactionID , Date25 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity26,0) as Quantity26  , InventoryID, TransactionID , Date26 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity27,0)  as Quantity27 , InventoryID, TransactionID , Date27 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity28,0)  as Quantity28 , InventoryID, TransactionID , Date28 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity29,0) as Quantity29  , InventoryID, TransactionID , Date29 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID
union  all
 Select   OT3002.POrderID, OT3002.DivisionID, isnull(Quantity30,0)  as Quantity30, InventoryID, TransactionID , Date30 From OT3002 left  join OT3003 on OT3003.POrderID = OT3002.POrderID

GO


