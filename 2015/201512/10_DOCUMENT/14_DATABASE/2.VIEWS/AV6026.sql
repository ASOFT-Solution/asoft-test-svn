/****** Object:  View [dbo].[AV6026]    Script Date: 12/31/2010 13:53:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Creater: Thuy Tuyen
-- Purpore: Load edit man hinh ban hang theo bo
--Date: 03/07/2009



ALTER VIEW [dbo].[AV6026]
as

Select AT1302.InventoryName, AT1302.IsSource,AT1302.IsLimitDate,AT1302.IsLocation,AT1302.MethodID,AT1302.DeliveryPrice,
 AT1302.IsStocked, AT1302.AccountID as IsDebitAccountID , 2 as IsApportionID, AT9000.*
From AT9000 
Left Join AT1302 On AT9000.InventoryID = AT1302.InventoryID And AT9000.DivisionID = AT1302.DivisionID 
Where 
( exists (select top 1 1 From AT1326 Where DivisionID = AT9000.DivisionID and InventoryID = AT9000.InventoryID)
or exists (Select top 1 1 From MT1603 Where ProductID = AT9000.InventoryID And DivisionID = AT9000.DivisionID)
 )

union all
Select AT1302.InventoryName, AT1302.IsSource,AT1302.IsLimitDate,AT1302.IsLocation,AT1302.MethodID,AT1302.DeliveryPrice,
 AT1302.IsStocked, AT1302.AccountID as IsDebitAccountID ,  case when IsStocked =0 then 0 else 1 end  as IsApportionID,AT9000.*
From AT9000 
Left Join AT1302 On AT9000.InventoryID = AT1302.InventoryID And AT9000.DivisionID = AT1302.DivisionID
Where 
not exists (select top 1 1  from AT1326 Where InventoryID = AT9000.InventoryID and DivisionID = AT9000.DivisionID)
and not exists(select top 1 1 from MT1603 Where ProductID = AT9000.InventoryID and DivisionID = AT9000.DivisionID)

GO


