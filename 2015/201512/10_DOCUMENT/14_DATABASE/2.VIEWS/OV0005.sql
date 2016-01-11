
/****** Object:  View [dbo].[OV0005]    Script Date: 12/16/2010 15:49:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----Created by: Vo Thanh Huong, date: 10/10/2005
---purpose: Tinh trang phieu dieu chinh

ALTER VIEW  [dbo].[OV0005] as

Select 1 as DataType, 'OFML000181' as Description , DivisionID
FROM AT1101
UNION
Select 2 as DataType, 'OFML000182' as Description, DivisionID
FROM AT1101


GO


