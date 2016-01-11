IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP0808]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP0808]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


----- 	Created by Van Nhan, Date 10/07/2008.
------	Purpose: So sanh gia thanh thuc te va dinh muc (Ap dung theo quy trinh)
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

CREATE PROCEDURE  [dbo].[MP0808]	@ProcedureID as nvarchar(50),
					@FromProduct as nvarchar(50),
					@ToProduct as nvarchar(50),					
					@FromMonth as int,
					@FromYear as int,
					@ToMonth as int,
					@ToYear as int,
					@Is621 tinyint,
					@Is622 tinyint,
					@Is627 tinyint,
					@CompareType int = 0, -- 0: So sanh theo cac bo dinh muc co trong phuong phap phan bo; 1: So sanh theo cac bo dinh muc tu chon 
					@ListofApportionID nvarchar(2000) = Null,
					@DivisionID nvarchar (50)
					
AS
Declare @sSQL as nvarchar(max),
	@FromPeriod as int,
	@ToPeriod as int,
	@DistributionID nvarchar(50),
	@lst_MaterialTypeID nvarchar(2000)
	

	Set @lst_MaterialTypeID  = '('

	Set @lst_MaterialTypeID  = @lst_MaterialTypeID + case when @Is621 = 1 then '''COST001'','  else ''''',' end + 
		 case when @Is622 = 1 then '''COST002'',' else ''''',' end  +  case when @Is627 = 1 then '''COST003'',' else ''''',' end 
	Set @lst_MaterialTypeID = left(@lst_MaterialTypeID, len(@lst_MaterialTypeID) - 1) + ')'


--Set  @DistributionID =isnull((Select  DistributionID From MT1601 Where PeriodID = @PeriodID), '')

--Select   @FromPeriod =@FromMonth+@FromYear*100, @ToPeriod =@ToMonth+@ToYear*100

----Lay san  pham cua DTTHCP  chiet tinh gia thanh
Set @sSQL = '
Select Distinct MT1632.DivisionID, ProcedureID, ExpenseID, ProductID , AT1302.InventoryName as ProductName, MT1632.MaterialTypeID, MaterialID,
	ConvertedUnit,QuantityUnit
From 	MT1632 inner join At1302 on MT1632.ProductID = AT1302.InventoryID and MT1632.DivisionID = AT1302.DivisionID
Where MT1632.DivisionID = ''' + @DivisionID + ''' And	MT1632.ProcedureID = '''+@ProcedureID+''' and ProductID Between ''' + @FromProduct + ''' and '''+@ToProduct + ''' and 	
	MT1632.ExpenseID In ' +  @lst_MaterialTypeID

If not exists (Select top 1 1 From SysObjects Where name = 'MV0809' and Xtype ='V')
	Exec ('Create view MV0809 as '+@sSQL)
Else
	Exec ('Alter view MV0809 as '+@sSQL)


---Lay bo dinh muc
Set @ListofApportionID = replace(@ListofApportionID,',',''',''')
Set @sSQL = '
	Select  Distinct MT1603.DivisionID,	''' + @ProcedureID + ''' As PeriodID, MT1603.ApportionID, MT1603.ExpenseID, MT1603.ProductID, AT1302.InventoryName as ProductName,
		MT1603.MaterialTypeID, MaterialID, ConvertedUnit as ConvertedA , QuantityUnit as QuantityA
	From 	MT1603 inner join AT1302 on MT1603.ProductID = AT1302.InventoryID and MT1603.DivisionID = AT1302.DivisionID
	Where MT1603.DivisionID = ''' + @DivisionID + '''And MT1603.ProductID Between  '''+@FromProduct+'''  And '''+@ToProduct + ''' And  
		MT1603.ExpenseID In ' + @lst_MaterialTypeID + ' And		
		MT1603.ApportionID In (''' + @ListofApportionID+ ''')' 

	
If not exists (Select top 1 1 From SysObjects Where name = 'MV0813' and Xtype ='V')
	Exec ('Create view MV0813 as '+@sSQL)
Else
	Exec ('Alter view MV0813 as '+@sSQL)

Set @sSQL = '
Select Distinct MV0809.DivisionID, 
	MV0813.PeriodID,
	Case When MV0809.ExpenseID Is Null Then MV0813.ExpenseID Else MV0809.ExpenseID End As ExpenseID, 
	Case When MV0809.ProductID Is Null Then MV0813.ProductID Else MV0809.ProductID End As ProductID,
	Case When MV0809.ProductName Is Null Then MV0813.ProductName Else MV0809.ProductName End As ProductName,
	Case When MV0809.MaterialTypeID Is Null Then MV0813.MaterialTypeID Else MV0809.MaterialTypeID End As MaterialTypeID,
	Case When MV0809.MaterialID Is Null Then MV0813.MaterialID Else MV0809.MaterialID End As MaterialID,
	isnull(MV0809.ConvertedUnit,0) as ConvertedUnit, Isnull(MV0809.QuantityUnit,0) as QuantityUnit, 	 
	isnull(ConvertedA,0) as ConvertedA, 
	isnull(QuantityA,0) as QuantityA, 
	MT0699.UserName ,  --MT0699.DivisionID,
	isnull(MV0813.ApportionID, '''') as ApportionID,
	AT1302.InventoryName as MaterialName

From MV0809 full join MV0813 on 

	MV0809.ProductID + ''_'' + 
	MV0809.ExpenseID + ''_'' + 
	case when left(MV0809.MaterialTypeID,1) = ''M'' then '' '' else MV0809.MaterialTypeID end 
	+ ''_'' +  isnull(MV0809.MaterialID,'' '')
	
	=
	
	MV0813.ProductID + ''_'' + 
	MV0813.ExpenseID + ''_'' + 
	case when left(MV0809.MaterialTypeID,1) = ''M'' then '' '' else MV0813.MaterialTypeID end 
	+ ''_'' +  isnull(MV0813.MaterialID,'' '')
	and MV0809.DivisionID = MV0813.DivisionID
 
	Left join MT0699 on Case When MV0809.MaterialTypeID Is Null Then MV0813.MaterialTypeID Else MV0809.MaterialTypeID End = MT0699.MaterialTypeID and MV0809.DivisionID = MT0699.DivisionID 
	Left join AT1302 on AT1302.InventoryID = Case When MV0809.MaterialID Is Null Then MV0813.MaterialID Else MV0809.MaterialID End and MV0809.DivisionID = AT1302.DivisionID 
Where MV0809.DivisionID = ''' + @DivisionID + ''''


If not exists (Select top 1 1 From SysObjects Where name = 'MV0814' and Xtype ='V')
	Exec ('Create view MV0814 as '+@sSQL)
Else
	Exec ('Alter view MV0814 as '+@sSQL)

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

