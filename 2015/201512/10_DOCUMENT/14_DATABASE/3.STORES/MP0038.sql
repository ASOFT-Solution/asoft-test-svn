
/****** Object:  StoredProcedure [dbo].[MP0038]    Script Date: 08/02/2010 14:18:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



---- Created by Van Nhan, Date 10/05/2009.
---- Purpose:  So sánh chi?t tính giá thành theo quy trinh v?i d?nh m?c
---- Edit by: Dang Le Bao Quynh; Date: 22/09/2009
---- Purpose: Bao cao ko chinh xac

/********************************************
'* Edited by: [GS] [Thanh Trẫm] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP0038] 	@DivisionID as nvarchar(50),
					@ProcedureID as nvarchar(50),
					@FromProductID as nvarchar(50),
					@ToProductID  as nvarchar(50),
					@ApportionID as nvarchar(50),
					@Is621 as tinyint,
					@Is622 as tinyint,
					@Is627 as tinyint

					
 AS
Declare @sSQL as nvarchar(4000)
---- Lay so lieu chiet tinh
Set @sSQL='
Select MT1632.DivisionID, ExpenseID, 
--MaterialTypeID, 
Case when ExpenseID=''COST001'' then  ''M''+ltrim(ltrim(right(isnull(I01ID,''zz''),2)))  Else MaterialTypeID End as MaterialTypeID, 
ProductID ,
--Case when ExpenseID=''COST001'' then  ''M''+ltrim(ltrim(right(I01ID,2)))  Else null End as MaterialID, 
sum(QuantityUnit) as QuantityUnit, sum(ConvertedUnit) as ConvertedUnit
From MT1632 left join AT1302 on AT1302.InventoryID = MT1632.MaterialID and AT1302.DivisionID = MT1632.DivisionID 
Where 	ProcedureID='''+@ProcedureID+''' and
	MT1632.DivisionID ='''+@DivisionID+''' and
	ProductID between N'''+@FromProductID+''' and N'''+@ToProductID+'''
Group by MT1632.DivisionID, ExpenseID,
	--MaterialTypeID, 
	Case when ExpenseID=''COST001'' then  ''M''+ltrim(ltrim(right(isnull(I01ID,''zz''),2)))  Else MaterialTypeID End,
	ProductID --, I01ID  '

If not exists (Select top 1 1 From SysObjects Where name = 'MV0036' and Xtype ='V')
	Exec ('Create view MV0036 as '+@sSQL)
Else
	Exec ('Alter view MV0036 as '+@sSQL)

---- Lay bo dinh muc
Set @sSQL='
Select 	MT1603.DivisionID, ExpenseID, 
	--MaterialTypeID, 
	--Case when ExpenseID=''COST001'' then  ''M''+ltrim(ltrim(right(I01ID,2)))  Else null End as MaterialID, 
	Case when ExpenseID=''COST001'' then  ''M''+ltrim(ltrim(right(isnull(I01ID,''zz''),2)))  Else MaterialTypeID End as MaterialTypeID, 
	ProductID, 
	sum(QuantityUnit) as QuantityUnit, sum(ConvertedUnit) as ConvertedUnit
From MT1603 left join AT1302 on AT1302.InventoryID = MT1603.MaterialID and AT1302.DivisionID = MT1603.DivisionID 
Where ApportionID= N'''+@ApportionID+'''  and MT1603.DivisionID = N'''+@DivisionID+''' and
ProductID between N'''+@FromProductID+''' and N'''+@ToProductID+'''
Group by 
	MT1603.DivisionID, ExpenseID,
	--MaterialTypeID, 
	Case when ExpenseID=''COST001'' then  ''M''+ltrim(ltrim(right(isnull(I01ID,''zz''),2)))  Else MaterialTypeID End, 
	ProductID--,I01ID  
'

If not exists (Select top 1 1 From SysObjects Where name = 'MV0037' and Xtype ='V')
	Exec ('Create view MV0037 as '+@sSQL)
Else
	Exec ('Alter view MV0037 as '+@sSQL)

Set @sSQL='
Select  	MV0036.DivisionID, MV0036.ExpenseID, MV0036.MaterialTypeID,MV0036.ProductID,
	--Case when MV0036.ExpenseID=''COST001'' then MV0036.MaterialID else MV0036.MaterialTypeID End as MaterialID ,
	AT1302.InventoryName as ProductName,
	--(Case when MV0036.ExpenseID=''COST001'' then M.UserName else MT0699.UserName End) as MaterialName,
	MT0699.UserName as MaterialTypeName,
	MV0036.QuantityUnit as QuantityUnit,
	--V1.QuantityUnit as ApporQuantityUnit,
	MV0037.QuantityUnit as ApporQuantityUnit,
	MV0036.ConvertedUnit as ConvertedUnit,
	--Case when  MV0036.ExpenseID=''COST001'' then V1.ConvertedUnit else V2.ConvertedUnit end as ApporConvertedUnit
	MV0037.ConvertedUnit as ApporConvertedUnit,
	Null as MaterialID		
/*
From MV0036 left join MV0037 	V2	on 	MV0036.ProductID = V2.ProductID  and
						MV0036.MaterialTypeID=V2.MaterialTypeID and
						MV0036.ExpenseID<>''COST001''
		left join MV0037 	V1	on 	MV0036.ProductID = V1.ProductID  and
						MV0036.MaterialID=V1.MaterialID and
						MV0036.ExpenseID=''COST001''
*/

From MV0036 left join MV0037 		on 	MV0036.ProductID = MV0037.ProductID  and
						MV0036.MaterialTypeID=MV0037.MaterialTypeID and MV0036.DivisionID=MV0037.DivisionID
						
		Left join AT1302   	on 	AT1302.InventoryID = MV0036.ProductID and AT1302.DivisionID = MV0036.DivisionID
		Left join MT0699  	on 	MT0699.MaterialTypeID = MV0036.MaterialTypeID and MT0699.DivisionID = MV0036.DivisionID	
Where 0=0 '

If @Is621=0 -- Uncheck
Set @sSQL=@sSQL+' and MV0036.ExpenseID<>''COST001'' '
If @Is622=0 -- Uncheck
Set @sSQL=@sSQL+' and MV0036.ExpenseID<>''COST002'' '
If @Is627=0 -- Uncheck
Set @sSQL=@sSQL+' and MV0036.ExpenseID<>''COST003'' '

If not exists (Select top 1 1 From SysObjects Where name = 'MV0038' and Xtype ='V')
	Exec ('Create view MV0038 as '+@sSQL)
Else
	Exec ('Alter view MV0038 as '+@sSQL)