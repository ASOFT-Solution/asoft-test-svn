/****** Object:  View [dbo].[OV1014]    Script Date: 12/16/2010 14:46:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 10/05/2005
---purpose: Lay ra so luong hang giao chua het  (Don hang mua)
-- Last edit  :27/05/2008

ALTER VIEW [dbo].[OV1014] as 
Select   TOP 100 PERCENT DivisionID, TranMonth, TranYear, POrderID as OrderID,  OrderStatus, sum(EndQuantity) as EndQuantity
From OV2902
Where EndQuantity > 0
Group by DivisionID, TranMonth, TranYear, POrderID,  OrderStatus
Order by  POrderID

GO


