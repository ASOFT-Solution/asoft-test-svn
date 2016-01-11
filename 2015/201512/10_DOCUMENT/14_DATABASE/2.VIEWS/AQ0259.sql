IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AQ0259]') AND OBJECTPROPERTY(ID, N'IsView') = 1)
DROP VIEW [DBO].[AQ0259]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--- Created by:  Bao Anh, date: 13/06/2012
--- Purpose: Lay ra so luong nhap kho ke thua chưa het
--- Edited by: Bao Anh	Date: 22/08/2012
--- Purpose: Bo sung loai phieu (KindVoucherID)

CREATE VIEW [dbo].[AQ0259] as 
Select Top 100 percent  DivisionID, TranMonth, TranYear, VoucherID, KindVoucherID,
	sum(isnull(EndQuantity,0)) as EndQuantity 
From AQ0258
Where EndQuantity > 0
Group by DivisionID, TranMonth, TranYear, VoucherID, KindVoucherID
Order by VoucherID

