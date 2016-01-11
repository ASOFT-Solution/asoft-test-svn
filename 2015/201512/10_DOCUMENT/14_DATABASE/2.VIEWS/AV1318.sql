
/****** Object:  View [dbo].[AV1318]    Script Date: 12/16/2010 15:44:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--- Created by: Thuy Tuyen
--- Created Date: 12/08/2009
--- Purpose: Loc ra danh muc ma phan tich doi  tuong cho man hinh cap nhat hang khuyen mai AF1328
-- Last Edit Thuy Tuyen , date 12/08/2009

ALTER VIEW [dbo].[AV1318] as 
Select  DivisionID, '%' as AnaID, 'Taát caû' as AnaName
From AT1101
Union all
select DivisionID, AnaID,AnaName from AT1015 
where AnaTypeID =  (  select TypeID from  AT0005 Where TypeID like 'O%'  and Status =1 ) and Disabled = 0   
/*
and  


(AnaID  not in (  Select top 1 OID from AT1328 where 
( case when  InventoryTypeID = '%' then @InventoryTypeID else InventoryTypeID  end)  =  ( case when  @InventoryTypeID = '%' then InventoryTypeID else @InventoryTypeID  end) and
(Case When OID = '%' then 'HCM' else OID end ) = (Case When 'HCM' = '%' then OID else 'HCM' end ) and
 ('01/20/2009'  between fromdate and ( case when Todate = '1900/01/01' then '9999/01/01' else Todate  end)or ( case when '1900/01/01'  = '1900/01/01' then '9999/01/01' else '1900/01/01'  end)  between fromdate and ( case when Todate = '1900/01/01' then '9999/01/01' else Todate  end) ))
)
*/



GO


