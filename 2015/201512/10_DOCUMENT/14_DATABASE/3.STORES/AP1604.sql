/****** Object:  StoredProcedure [dbo].[AP1604]    Script Date: 08/04/2010 11:05:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/**********************************************
** Edited by: [GS] [Cẩm Loan] [30/07/2010]
***********************************************/

ALTER procedure [dbo].[AP1604] @CoefficientID as nvarchar(50)
as
 Declare @sSQL as nvarchar(4000)
set @sSQL='
--declare @CoefficientID as nvarchar(50)
--set @CoefficientID =1
select  MT1604.CoefficientID,
	MT1604.CreateDate,
	MT1604.Disabled,
	MT1604.CoefficientName,      
	MT1604.CreateUserID,
	AT1103.FullName,	
	MT1604.Description,
	MT1604.InventoryTypeID,
	MT1604.RefNo,
	MT1604.CoType,
	MT1605.InventoryID,
	AT1302.InventoryName,
	MT1605.CoValue,
	MT1605.Notes,
	MT1604.DivisionID
from MT1604 inner join AT1103 on MT1604.CreateUserID=AT1103.EmployeeID and MT1604.DivisionID = AT1103.DivisionID
	    left join MT1605 on MT1604.CoefficientID=MT1605.CoefficientID and MT1604.DivisionID = AT1103.DivisionID
 	   inner join AT1302 on MT1605.InventoryID=AT1302.InventoryID and MT1604.DivisionID = AT1103.DivisionID
where MT1604.disabled =0 and MT1604.CoefficientID='''+@CoefficientID+'''
'

--print @sSQL

If not exists (Select top 1 1 From SysObjects Where name = 'AV1605' and Xtype ='V')
	Exec ('Create view AV1605 as '+@sSQL)
Else
	Exec ('Alter view AV1605 as '+@sSQL)



