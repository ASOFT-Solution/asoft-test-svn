
/****** Object:  StoredProcedure [dbo].[MP0026]    Script Date: 07/29/2010 17:29:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---- Created by Bao Anh, date 05.06.2008
---- Purpose: In chi tiet quy trinh san xuat

/********************************************
'* Edited by: [GS] [Hoàng Phước] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0026] @ProcedureID as nvarchar(50)
 AS

Declare @sSQL as nvarchar(4000)

Set @sSQL='
Select MT1630.DivisionID, MT1630.ProcedureID, MT1630.Description,
	StepID, MT1631.PeriodID, MT1601.Description as PeriodName, MT1631.Notes
	
From MT1630 	inner join MT1631 on MT1631.ProcedureID=MT1630.ProcedureID and MT1631.DivisionID=MT1630.DivisionID
		inner join MT1601 on MT1601.PeriodID =MT1631.PeriodID and MT1601.DivisionID =MT1631.DivisionID

Where 	MT1630.ProcedureID ='''+@ProcedureID+'''
'

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name ='MV0026')
	Exec (' Create view MV0026 as '+@sSQL)
Else
	Exec (' Alter view MV0026 as '+@sSQL)