/****** Object:  View [dbo].[OQ3333]    Script Date: 12/16/2010 15:44:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--PP: Tao view lay ngay du kien dat hang 
--Creater:Thuy Tuyen
---Date:21/07/2009
ALTER VIEW [dbo].[OQ3333]
as
select  POrderID, Date01, DivisionID    from OT3003
union all
select  POrderID, Date02, DivisionID from OT3003
union
select  POrderID, Date03, DivisionID from OT3003
union
select  POrderID, Date04, DivisionID from OT3003
union
select  POrderID, Date05, DivisionID from OT3003
union
select  POrderID, Date06, DivisionID from OT3003
union
select  POrderID, Date07, DivisionID from OT3003
union
select  POrderID, Date08, DivisionID from OT3003
union
select  POrderID, Date09, DivisionID from OT3003
union
select  POrderID, Date10, DivisionID from OT3003
union
select  POrderID, Date11, DivisionID from OT3003
union
select  POrderID, Date12, DivisionID from OT3003
union
select  POrderID, Date13, DivisionID from OT3003
union
select  POrderID, Date14, DivisionID from OT3003
union
select  POrderID, Date15, DivisionID from OT3003
union
select  POrderID, Date16, DivisionID from OT3003
union
select  POrderID, Date17, DivisionID from OT3003
union
select  POrderID, Date18, DivisionID from OT3003
union
select  POrderID, Date19, DivisionID from OT3003
union
select  POrderID, Date20, DivisionID from OT3003
Union
select  POrderID, Date21, DivisionID from OT3003
union
select  POrderID, Date22, DivisionID from OT3003
union
select  POrderID, Date23, DivisionID from OT3003
union
select  POrderID, Date24, DivisionID from OT3003
union
select  POrderID, Date25, DivisionID from OT3003
union
select  POrderID, Date26, DivisionID from OT3003
union
select  POrderID, Date27, DivisionID from OT3003
union
select  POrderID, Date28, DivisionID from OT3003
union
select  POrderID, Date29, DivisionID from OT3003
union
select  POrderID, Date30, DivisionID from OT3003

GO


