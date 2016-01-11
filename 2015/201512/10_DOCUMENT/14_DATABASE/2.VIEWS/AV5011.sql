
/****** Object:  View [dbo].[AV5011]    Script Date: 12/16/2010 14:34:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

--View chet???

ALTER VIEW [dbo].[AV5011] as
SELECT     DivisionID, VoucherID, VoucherNo, VoucherTypeID, VoucherDate, SOrderID
FROM         dbo.OT5001

GO


