
/****** Object:  StoredProcedure [dbo].[MP4002]    Script Date: 08/02/2010 10:57:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created By NguyÔn Ngäc Mü
--Date 06/1/2004
--Purpose:B¸o c¸o chiÕt tÝnh gi¸ thµnh

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER procedure [dbo].[MP4002] @DivisionID as nvarchar(50),
				@PeriodID as nvarchar(50)
as
declare @sSQL nvarchar(4000)
set @sSQL='Select  VoucherTypeID,VoucherNo,VoucherDate,
	T00.PeriodID,T00.Description,ProductID, 
	T01.Description as PeriodName,       
	T02.InventoryName As ProductName,T02.UnitID As ProductUnitID,        
	T00.MaterialTypeID, 
	T00.DivisionID, 
	UserName,
	Case when T99.ExpenseID = ''COST001'' then MaterialID else T00.MaterialTypeID End as MaterialID,
	Case when T99.ExpenseID = ''COST001'' then T03.InventoryName else UserName End As MaterialName,        
	T03.UnitID As MaterialUnitID,
	ConvertedUnit,
	QuantityUnit,
	DetailCostID,
	VoucherID,    
	T99.ExpenseID
From         MT4000 T00  
	Left Join AT1302 T02 On T02.DivisionID=T00.DivisionID AND T00.ProductID=T02.InventoryID                 
	Left Join MT0699 T99 On T99.DivisionID=T00.DivisionID AND T00.MaterialTypeID=T99.MaterialTypeID                 
	Left Join AT1302 T03 On T03.DivisionID=T00.DivisionID AND T00.MaterialID=T03.InventoryID     
	Left Join MT1601 T01 On T01.DivisionID=T00.DivisionID AND T00.PeriodID=T01.PeriodID
	Where         T00.PeriodID='''+ @PeriodID + '''And T00.DivisionID='''+ @DivisionID +''''
--print @sSQL
If not exists (Select top 1 1 From SysObjects Where name = 'MV4002' and Xtype ='V')
	Exec ('Create view MV4002 as '+@sSQL)
Else
	Exec ('Alter view MV4002 as '+@sSQL)