/****** Object:  View [dbo].[AV1602]    Script Date: 12/16/2010 14:47:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--Create by Nguyen Quoc Huy : 24-01-2005
--View chet: Dung de in phieu bao hong ccdc
--- Edited by Bao Anh	Date: 08/07/2012
--- Purpose: Where them dieu kien VoucherID

ALTER VIEW [dbo].[AV1602] as 
Select 	AT1602.VoucherID,
	AT1602.VoucherNo,
	AT1602.VoucherDate,
	AT1602.DivisionID,
	AT1602.TranMonth,
	AT1602.TranYear,
	AT1602.EmployeeID,
	AT1602.Description,
	AT1602.ToolID,
	AT1602.VoucherTypeID,
	AT1603.ToolName,
	AT1603.ConvertedAmount

	
From AT1602 Inner Join AT1603 On AT1603.ToolID = AT1602.ToolID
				AND AT1603.VoucherID = AT1602.ReVoucherID
				and AT1603.DivisionID = AT1602.DivisionID
				
GO


