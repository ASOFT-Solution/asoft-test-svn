
/****** Object:  View [dbo].[OV1017]    Script Date: 12/16/2010 14:47:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---Created by: Thuy Tuyen, date: 22/05/2007
---purpose: Lay ra so luong hang giao chua het  (Yeu Cau Mua Hang)

ALTER VIEW [dbo].[OV1017] as 
Select   DivisionID, TranMonth, TranYear, ROrderID as OrderID,  OrderStatus, sum(EndQuantity) as EndQuantity
From OV2905
Where EndQuantity > 0
Group by DivisionID, TranMonth, TranYear, ROrderID,  OrderStatus

GO


