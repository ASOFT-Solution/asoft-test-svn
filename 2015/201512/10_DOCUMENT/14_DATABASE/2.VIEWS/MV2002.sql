/****** Object:  View [dbo].[MV2002]    Script Date: 12/16/2010 15:40:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--VIEW CHET ???

ALTER VIEW [dbo].[MV2002] as 
Select MT2002.DivisionID, 	MT2002.InventoryID , MT2002.UnitID, InventoryName, PlanQuantity , 
	Date01, Date02, Date03,Date04 ,Date05, Date06, Date07, Date08,Date09 ,Date10,
	Date11, Date12, Date13,Date14 ,Date15, Date16, Date17, Date18,Date19 ,Date20,
	Date21, Date22, Date23,Date24 ,Date25, Date26, Date27, Date28,Date29 ,Date30,
	Date31, Date32, Date33,Date34 ,Date35, Date36, Date37, Date38,Date39 ,Date40,
	Quantity01, Quantity02 , Quantity03, Quantity04,Quantity05, Quantity06 , Quantity07, Quantity08, Quantity09, Quantity10,  
	Quantity11, Quantity12 , Quantity13, Quantity14,Quantity15, Quantity16 , Quantity17, Quantity18, Quantity19, Quantity20, 
	Quantity21, Quantity22 , Quantity23, Quantity24,Quantity25, Quantity26 , Quantity27, Quantity28, Quantity29, Quantity30, 
	Quantity31, Quantity32 , Quantity33, Quantity34,Quantity35, Quantity36 , Quantity37, Quantity38, Quantity39, Quantity40,
	RQuantity01, RQuantity02 , RQuantity03, RQuantity04, RQuantity05, RQuantity06 , RQuantity07, RQuantity08, RQuantity09, RQuantity10,  
	RQuantity11, RQuantity12 , RQuantity13, RQuantity14,RQuantity15, RQuantity16 , RQuantity17, RQuantity18, RQuantity19, RQuantity20, 
	RQuantity21, RQuantity22 , RQuantity23, RQuantity24,RQuantity25, RQuantity26 , RQuantity27, RQuantity28, RQuantity29, RQuantity30, 
	RQuantity31, RQuantity32 , RQuantity33, RQuantity34,RQuantity35, RQuantity36 , RQuantity37, RQuantity38, RQuantity39, RQuantity40
 
From 	MT2002 inner join AT1302 on AT1302.InventoryID = MT2002.InventoryID
		 Left join MT2003 on MT2002.PlanID = MT2003.PlanID
		Left join MV2001 on MV2001.ProductID = MT2002.InventoryID
WHere MT2002.PlanID = 'MP20040000000021' and
	MT2002.DivisionID ='ABC'

GO


