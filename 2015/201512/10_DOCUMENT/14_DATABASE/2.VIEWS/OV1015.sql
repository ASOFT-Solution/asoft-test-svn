

/****** Object:  View [dbo].[OV1015]    Script Date: 12/16/2010 14:46:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 10/05/2005
---purpose: Lay ra so luong hang hang giao chua het  (Du tru)

ALTER VIEW [dbo].[OV1015] as 
Select  DivisionID, TranMonth, TranYear, EstimateID as OrderID, OrderStatus, sum(isnull(EndQuantity, 0)) as EndQuantity 
From OV2903
Where EndQuantity > 0
Group by DivisionID, TranMonth, TranYear, EstimateID, OrderStatus

GO


