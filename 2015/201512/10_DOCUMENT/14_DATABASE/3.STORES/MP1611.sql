/****** Object:  StoredProcedure [dbo].[MP1611]    Script Date: 07/29/2010 14:49:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

------- Created by Nguyen Van Nhan, Date 15/10/2003
------- Purpose: Eidit Form "Doi tuong tap hop chi phi"
------- Edit by Nguyen Quoc Huy
----- Modify on 30/01/2013 by Bao Anh: Bo sung WasteID, WasteName
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [02/08/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[MP1611] @DivisionID nvarchar(50), @PeriodID as nvarchar(50)
 AS

Declare @sSQL as nvarchar(4000),
	@IsType as int
Declare	@TempTable table(CustomerName  int,IsExcel  int)

INSERT @TempTable
EXEC	[dbo].[AP4444]
select @IsType= case when CustomerName<>1 then 0 else 1 end  from @TempTable

Set @sSQL ='

Select 
	MT01.PeriodID,
	MT01.Description,
	MT01.Notes,
	MT01.Disabled,
	(Case When MT01.FromMonth < 10 Then  +''0''+  rtrim(ltrim(str(MT01.FromMonth))) +''/''+ltrim(Rtrim(str(MT01.FromYear))) 
		Else rtrim(ltrim(str(MT01.FromMonth)))+''/''+ltrim(Rtrim(str(MT01.FromYear))) END) As FromMonthYear,
	
	(Case When MT01.ToMonth < 10 Then  +''0''+  rtrim(ltrim(str(MT01.ToMonth))) +''/''+ltrim(Rtrim(str(MT01.ToYear))) 
		Else rtrim(ltrim(str(MT01.ToMonth)))+''/''+ltrim(Rtrim(str(MT01.ToYear))) END) As ToMonthYear,

	MT01.DistributionID,
	MT01.CoefficientID,
	MT01.InProcessID,
	MT01.FromPeriodID,
	MT01.IsFromCost,
	MT01.IsForPeriodID,
	MT10.ExpenseID,
	MT10.MaterialTypeID,
	MT10.IsUse,
	MT01.DivisionID,
	MT99.UserName,
	MT01.WasteID, T02.InventoryName as WasteName
'

if @IsType = 1
	SET @sSQL = @sSQL + ' ,MT01.OrderID  AS OrderID'
ELSE 
	SET @sSQL = @sSQL + ' ,'''' AS OrderID '
	
SET @sSQL = @sSQL + ' From  MT1601 MT01 Left Join MT1610 MT10 On MT01.PeriodID = MT10.PeriodID and MT01.DivisionID = MT10.DivisionID
			Left Join MT0699 MT99 On MT10.MaterialTypeID = MT99.MaterialTypeID and MT01.DivisionID = MT99.DivisionID
			Left join AT1302 T02 on MT01.WasteID = T02.InventoryID And MT01.DivisionID = T02.DivisionID
Where MT01.PeriodID ='''+@PeriodID+''''

--print @sSQL

If not exists (Select top 1 1 From SysObjects Where name = 'MV1611' and Xtype ='V')
	Exec ('Create view MV1611 --[MP1611]
	as '+@sSQL)
Else
	Exec ('Alter view MV1611 --[MP1611]
	as '+@sSQL)






