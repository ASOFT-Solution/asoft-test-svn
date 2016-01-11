
/****** Object:  View [dbo].[AV1303]    Script Date: 12/16/2010 15:44:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


--View chet len bao cao danh muc dinh muc ton kho hang hoa
ALTER VIEW [dbo].[AV1303] AS 	
Select DivisionID, '%' as WareHouseID, 'Taát caû caùc kho' as WareHouseName
From AT1101
Union all
Select DivisionID, WareHouseID, WareHouseName
From AT1303


GO


