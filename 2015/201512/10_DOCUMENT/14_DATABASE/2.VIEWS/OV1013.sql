
/****** Object:  View [dbo].[OV1013]    Script Date: 12/16/2010 14:45:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Created by: Vo Thanh Huong, date: 10/05/2005
---purpose: Lay ra so luong hang hang giao chua het  (Don hang ban)
-- -- Last edit  :27/05/2008

ALTER VIEW [dbo].[OV1013] as 
Select    Top 100 percent  DivisionID, TranMonth, TranYear, SOrderID as OrderID, OrderStatus, sum(isnull(EndQuantity,0)) as EndQuantity 
From OV2901
Where EndQuantity > 0
Group by DivisionID, TranMonth, TranYear, SOrderID, OrderStatus
Order by SOrderID

GO


