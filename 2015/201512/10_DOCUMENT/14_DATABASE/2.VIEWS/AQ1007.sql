/****** Object:  View [dbo].[AQ1007]    Script Date: 01/12/2011 11:36:45 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AQ1007]'))
DROP VIEW [dbo].[AQ1007]
GO

/****** Object:  View [dbo].[AQ1007]    Script Date: 01/12/2011 11:36:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Create by: Dang Le Bao Quynh; Date: 10/05/2010
-- Purpose: View chet load danh muc Loai Chung Tu

CREATE VIEW [dbo].[AQ1007]
AS
SELECT  VoucherTypeID, VoucherTypeName, VDescription, TDescription, BDescription, IsVAT, VATTypeID, IsBDescription, IsTDescription, 
		DebitAccountID, CreditAccountID, WareHouseID, ObjectID, IsDefault, VoucherGroupID, Disabled, DivisionID

FROM AT1007
GO


