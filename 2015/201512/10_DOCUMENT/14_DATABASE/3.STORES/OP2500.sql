
/****** Object:  StoredProcedure [dbo].[OP2500]    Script Date: 07/30/2010 09:14:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong, date:  09/09/2004
----purpose: Xoa tien do giao hang
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [03/08/2010]
'**************************************************************/

ALTER  PROCEDURE [dbo].[OP2500]  @DivisionID nvarchar(50),
			@OrderID nvarchar(50)

AS

Delete OT2003 
From OT2003 T00 inner join OT2001 T01 on T00.SOrderID  = T01.SOrderID and T00.DivisionID  = T01.DivisionID
Where T00.SOrderID = @OrderID  and T01.DivisionID = @DivisionID

Update OT2002 Set Quantity01 = NULL, Quantity02 = NULL, Quantity03 = NULL, Quantity04 = NULL, Quantity05 = NULL,
			 Quantity06 = NULL, Quantity07 = NULL, Quantity08 = NULL, Quantity09 =NULL, Quantity10 = NULL,
			 Quantity11 = NULL, Quantity12 = NULL, Quantity13 = NULL, Quantity14 = NULL, Quantity15 = NULL,
			 Quantity16 = NULL, Quantity17 = NULL, Quantity18 = NULL, Quantity19 = NULL, Quantity20 = NULL,
			 Quantity21 = NULL, Quantity22 = NULL, Quantity23 = NULL, Quantity24 = NULL, Quantity25 = NULL,
			 Quantity26 =NULL, Quantity27 = NULL, Quantity28 = NULL, Quantity29 = NULL, Quantity30 = NULL
From OT2002 T00 inner join OT2001 T01 on T00.SOrderID = T01.SOrderID and T00.DivisionID = T01.DivisionID
Where  T00.SOrderID = @OrderID 



