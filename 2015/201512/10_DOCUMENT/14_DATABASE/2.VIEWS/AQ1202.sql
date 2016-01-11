/****** Object:  View [dbo].[AQ1202]    Script Date: 01/12/2011 11:37:35 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AQ1202]'))
DROP VIEW [dbo].[AQ1202]
GO

/****** Object:  View [dbo].[AQ1202]    Script Date: 01/12/2011 11:37:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Create by: Dang Le Bao Quynh; Date: 10/05/2010
-- Purpose: View chet load danh muc Doi tuong

CREATE VIEW [dbo].[AQ1202]
AS
SELECT  AT1202.ObjectID, AT1202.ObjectName, AT1202.VATNo, 
		AT1202.Address, AT1202.DeAddress, AT1202.ReAddress, 
		AT1202.IsUpdateName, AT1202.IsSupplier, AT1202.IsCustomer, 
		AT1208.DueType, AT1202.PaDueDays, AT1202.ReDueDays,  
                      	AT1202.PaPaymentTermID, AT1202.RePaymentTermID, 
		AT1202.Contactor, AT1202.Disabled, AT1202.DivisionID

FROM AT1202 LEFT OUTER JOIN AT1208 
ON AT1202.RePaymentTermID = AT1208.PaymentTermID
GO


