
/****** Object:  StoredProcedure [dbo].[MP1606]    Script Date: 07/29/2010 14:46:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------- Created by Nguyen Quoc Huy, Date 15/10/2003
------- Purpose: Edit Form "Cap nhat bo he so theo doi tuong"
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [30/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[MP1606] @DivisionID nvarchar(50), @CoefficientID as nvarchar(50)
 AS

Declare @sSQL as nvarchar(4000),
	@IsType as int
Declare	@TempTable table(CustomerName  int,IsExcel  int)

INSERT @TempTable
EXEC	[dbo].[AP4444]

select @IsType= case when CustomerName<>1 then 0 else 1 end  from @TempTable

set @sSQL='
Select   MT06.CoefficientID, 
	MT06.CoefficientName,
	MT06.Disabled,
	MT06.EmployeeID,
	MT06.CoType,
	MT07.CoValue, 
	MT07.Notes, 
	MT07.PeriodID, 
	MT07.DeCoefficientID,
	MT01.Description , 
	AT03.FullName,
	MT07.DivisionID,
	MT01.IsForPeriodID
From MT1607 MT07 Inner Join MT1606 MT06 On MT07.CoefficientID = MT06.CoefficientID and MT07.DivisionID = MT06.DivisionID
		Inner Join MT1601 MT01 On MT07.PeriodID = MT01.PeriodID and MT07.DivisionID = MT01.DivisionID
		Left Join AT1103 AT03 On MT06.EmployeeID = AT03.EmployeeID
					and MT06.DivisionID = AT03.DivisionID
Where MT01.DivisionID = '''+@DivisionID+'''
	And MT06.CoefficientID = '''+@CoefficientID+''''
	-- Customize Minh Phuong
if(@IsType = 0)
	set @sSQL=@sSQL + ' and MT01.IsForPeriodID = 0   '

--print @sSQL

If not exists (Select top 1 1 From SysObjects Where name = 'MV1606' and Xtype ='V')
	Exec ('Create view MV1606 as '+@sSQL)
Else
	Exec ('Alter view MV1606 as '+@sSQL)












