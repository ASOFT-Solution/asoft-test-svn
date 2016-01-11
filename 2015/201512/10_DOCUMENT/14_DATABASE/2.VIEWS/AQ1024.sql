
/****** Object:  View [dbo].[AQ1024]    Script Date: 02/16/2011 12:02:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Created by:  Bao Anh, date: 24/12/2009
--purpose: Lay ra so luong hang ke thua chua het  (Don hang mua)

ALTER VIEW [dbo].[AQ1024] as 
Select    Top 100 percent  DivisionID, TranMonth, TranYear, POrderID as OrderID, OrderStatus, sum(isnull(EndQuantity,0)) as EndQuantity 
From AQ2904
Where EndQuantity > 0
Group by DivisionID, TranMonth, TranYear, POrderID, OrderStatus
Order by POrderID
GO


