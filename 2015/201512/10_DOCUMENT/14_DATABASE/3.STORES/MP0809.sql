IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MP0809]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MP0809]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by:Hoµng ThÞ Lan
--Date 03/02/2004
--Purpose: Bao cao so sanh gia thanh va dinh muc
--Edit by: Dang Le Bao Quynh; Date: 10/08/2007
--Purpose: Bo sung va sua cach in bao cao so sanh gia thanh va dinh muc, cho phep chon mot dinh muc bat ky de so sanh
--Edit by: Thien Huynh; Date: 27/09/2011
--Purpose: Sua loi
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/
-- Last Edit 01/03/2013 by Thiên Huỳnh: Đa chi nhánh
-- Edit by Khanh Van: Loi ket DivisionID chua dung

CREATE PROCEDURE  [dbo].[MP0809]	@PeriodID as nvarchar(50),
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
					@DivisionID as nvarchar (50)
					
AS
Declare @sSQL as nvarchar(max),
	@FromPeriod as int,
	@ToPeriod as int,
	@DistributionID nvarchar(50),
	@lst_MaterialTypeID varchar(2000)
	

	Set @lst_MaterialTypeID  = '('

	Set @lst_MaterialTypeID  = @lst_MaterialTypeID + case when @Is621 = 1 then '''COST001'','  else ''''',' end + 
		 case when @Is622 = 1 then '''COST002'',' else ''''',' end  +  case when @Is627 = 1 then '''COST003'',' else ''''',' end 
	Set @lst_MaterialTypeID = left(@lst_MaterialTypeID, len(@lst_MaterialTypeID) - 1) + ')'


Set  @DistributionID =isnull((Select  DistributionID From MT1601 Where PeriodID = @PeriodID And DivisionID = @DivisionID), '')

Select   @FromPeriod =@FromMonth+@FromYear*100, @ToPeriod =@ToMonth+@ToYear*100

----Lay san  pham cua DTTHCP  chiet tinh gia thanh
Set @sSQL = '
Select Distinct  MT4000.DivisionID,PeriodID, ExpenseID, ProductID , AT1302.InventoryName as ProductName, MT4000.MaterialTypeID, ISNULL(MaterialID, MT4000.MaterialTypeID) AS MaterialID ,
ConvertedUnit, QuantityUnit
From 	MT4000 
	inner join At1302 on MT4000.ProductID = AT1302.InventoryID and MT4000.DivisionID = AT1302.DivisionID
Where MT4000.DivisionID = ''' + @DivisionID + ''' And	MT4000.PeriodID = '''+@PeriodID+''' and ProductID Between ''' + @FromProduct + ''' and '''+@ToProduct + ''' and 
	MT4000.MaterialTypeID in (Select MaterialTypeID From MT5001 Where DistributionID = ''' + @DistributionID + ''' And IsDistributed = 1 And ExpenseID In ' + @lst_MaterialTypeID + ')' + ' And
	MT4000.ExpenseID In ' +  @lst_MaterialTypeID

--Print @sSQL
 
If not exists (Select top 1 1 From SysObjects Where name = 'MV0809' and Xtype ='V')
	Exec ('Create view MV0809 --- Tao boi MP0809 
	as '+@sSQL)
Else
	Exec ('Alter view MV0809 --- Tao boi MP0809 
	as '+@sSQL)



---Lay bo dinh muc
Set @ListofApportionID = replace(@ListofApportionID,',',''',''')

if @CompareType = 0
	Set @sSQL = '
	Select Distinct MT1603.DivisionID, ''' + @PeriodID + ''' As PeriodID, MT1603.ApportionID, MT1603.ExpenseID, MT1603.ProductID, AT1302.InventoryName as ProductName,
		MT1603.MaterialTypeID, MaterialID, ConvertedUnit as ConvertedA , QuantityUnit as QuantityA
	From 	MT1603 
		inner join AT1302 on MT1603.ProductID = AT1302.InventoryID and MT1603.DivisionID = AT1302.DivisionID
	Where MT1603.DivisionID = ''' + @DivisionID + ''' And 	MT1603.ProductID Between  '''+@FromProduct+'''  And '''+@ToProduct + ''' And  
		MT1603.ExpenseID In ' + @lst_MaterialTypeID + ' And
		(MT1603.MaterialTypeID in (Select MaterialTypeID From MT5001 Where DivisionID = ''' + @DivisionID + ''' And DistributionID = ''' + @DistributionID + ''' And IsDistributed = 1 And ExpenseID In ' + @lst_MaterialTypeID + ') Or MT1603.MaterialTypeID Is Null)' + ' And
		MT1603.ApportionID In (Select ApportionID From MT5001 Where DivisionID = ''' + @DivisionID + ''' And DistributionID = ''' + @DistributionID + ''' And IsDistributed = 1 And ExpenseID In ' + @lst_MaterialTypeID + ') And ApportionID Is Not Null' 
else
	Set @sSQL = '
	Select  MT1603.DivisionID, ''' + @PeriodID + ''' As PeriodID, MT1603.ApportionID, MT1603.ExpenseID, MT1603.ProductID, AT1302.InventoryName as ProductName,
		MT1603.MaterialTypeID, MaterialID, ConvertedUnit as ConvertedA , QuantityUnit as QuantityA
	From 	MT1603 
		inner join AT1302 on MT1603.ProductID = AT1302.InventoryID and MT1603.DivisionID = AT1302.DivisionID
	Where  MT1603.DivisionID = ''' + @DivisionID + '''	And MT1603.ProductID Between  '''+@FromProduct+'''  And '''+@ToProduct + ''' And  
		MT1603.ExpenseID In ' + @lst_MaterialTypeID + ' And
		(MT1603.MaterialTypeID in (Select MaterialTypeID From MT5001 Where DivisionID = ''' + @DivisionID + ''' And DistributionID = ''' + @DistributionID + ''' And IsDistributed = 1 And ExpenseID In ' + @lst_MaterialTypeID + ') Or MT1603.MaterialTypeID Is Null)' + ' And
		MT1603.ApportionID In (''' + @ListofApportionID+ ''')' 

--print @sSQL	
If not exists (Select top 1 1 From SysObjects Where name = 'MV0813' and Xtype ='V')
	Exec ('Create view MV0813 --- Tao boi MP0809 
	as '+@sSQL)
Else
	Exec ('Alter view MV0813 --- Tao boi MP0809 
	as '+@sSQL)

Set @sSQL = '
Select Distinct
	MV0813.DivisionID,
	MV0813.PeriodID,
	Case When MV0809.ExpenseID Is Null Then MV0813.ExpenseID Else MV0809.ExpenseID End As ExpenseID, 
	Case When MV0809.ProductID Is Null Then MV0813.ProductID Else MV0809.ProductID End As ProductID,
	Case When MV0809.ProductName Is Null Then MV0813.ProductName Else MV0809.ProductName End As ProductName,
	Case When MV0809.MaterialTypeID Is Null Then MV0813.MaterialTypeID Else MV0809.MaterialTypeID End As MaterialTypeID,
	Case When MV0809.MaterialID Is Null Then MV0813.MaterialID Else MV0809.MaterialID End As MaterialID,
	isnull(MV0809.ConvertedUnit,0) as ConvertedUnit, Isnull(MV0809.QuantityUnit,0) as QuantityUnit, 	 
	isnull(ConvertedA,0) as ConvertedA, 
	isnull(QuantityA,0) as QuantityA, 
	MT0699.UserName , --MT0699.DivisionID,   
	isnull(MV0813.ApportionID, '''') as ApportionID,
	AT1302.InventoryName as MaterialName--, AT1302.DivisionID

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
 
	Left join MT0699 on Case When MV0809.MaterialTypeID Is Null Then MV0813.MaterialTypeID Else MV0809.MaterialTypeID End = MT0699.MaterialTypeID  AND MT0699.DivisionID = (Case When MV0809.DivisionID Is Null Then MV0813.DivisionID Else MV0809.DivisionID End)
	Left join AT1302 on AT1302.InventoryID = Case When MV0809.MaterialID Is Null Then MV0813.MaterialID Else MV0809.MaterialID End 
	and AT1302.DivisionID = Case When MV0809.DivisionID Is Null Then MV0813.DivisionID Else MV0809.DivisionID End 
Where MV0813.DivisionID = ''' + @DivisionID + ''''
	
--Print @sSQL

If not exists (Select top 1 1 From SysObjects Where name = 'MV0814' and Xtype ='V')
	Exec ('Create view MV0814 --- Tao boi MP0809 
	as '+@sSQL)
Else
	Exec ('Alter view MV0814 --- Tao boi MP0809 
	as '+@sSQL)