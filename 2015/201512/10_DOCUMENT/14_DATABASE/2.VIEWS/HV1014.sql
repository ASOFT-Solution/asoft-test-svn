/****** Object:  View [dbo].[HV1014]    Script Date: 12/16/2010 14:49:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 19/01/2004
---purpose: du lieu ngam cho combo Dieu kien tam ung

ALTER VIEW [dbo].[HV1014] as
Select 0 as TypeID, 'Ngaøy coâng toång hôïp' as TypeName
Union
Select 1  as TypeID, 'Heä soá chung' as TypeName
Union
Select 2  as TypeID, 'Möùc löông' as TypeName

GO


