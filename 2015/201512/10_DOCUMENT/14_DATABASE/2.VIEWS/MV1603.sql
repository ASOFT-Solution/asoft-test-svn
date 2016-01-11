
/****** Object:  View [dbo].[MV1603]    Script Date: 12/16/2010 15:26:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---created by Hoang Thi Lan 
--Date 08/10/2003
--purpose lay thong tin hang hoa
ALTER VIEW [dbo].[MV1603]
as
select InventoryTypeID,InventoryTypeName, DivisionID
from AT1301
where disabled =0
union 
select '%' as InventoryTypeID,
	'Tatca' as InventoryTypeName, DivisionID
FROM AT1301
GO


