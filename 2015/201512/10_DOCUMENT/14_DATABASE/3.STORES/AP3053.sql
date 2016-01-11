/****** Object:  StoredProcedure [dbo].[AP3053]    Script Date: 07/29/2010 10:27:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




--Created by Nguyen Quoc Huy
--Date 05/10/2005
--Prupose:Hang ban tra lai
----Last Edit ThuyTuyen Them truong AT9000.DiscountRate,27/03/2007
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/
ALTER PROCEDURE [dbo].[AP3053] 	@DivisionID as nvarchar(50) ,
				@sSQLWhere as nvarchar(4000) ,
				@TranMonth as int,
				@TranYear as int	 
as
declare @sSQL as nvarchar(4000) 
set @sSQL='
	Select  
		AT9000.InventoryID,
		AT1302.InventoryName,
		AT1302.UnitID,	       	
		AT1304.UnitName,
		Sum(AT9000.Quantity) as Quantity,
		AT9000.CurrencyID,
		AT1302.SalePrice01,
		AT1302.S1, AT1302.S2, AT1302.S3,	
		AT1302.S2 as GroupID,
		AT1310.SName as GroupName,
		sum(AT9000.OriginalAmount) as OriginalAmount,
		Sum(AT9000.ConvertedAmount) as ConvertedAmount   ,
		AT9000.DiscountRate , AT9000.DivisionID
	From AT9000 	left join AT1302 on AT9000.InventoryID=AT1302.InventoryID  and AT9000.DivisionID=AT1302.DivisionID 
		   	left join AT1304 on AT1304.UnitID=AT1302.UnitID   and AT9000.DivisionID=AT1304.DivisionID
			Left join AT1310 on AT1310.S = AT1302.S2   and AT9000.DivisionID=AT1310.DivisionID and
					    AT1310.StypeID =''I02''  
	where AT9000.DivisionID='''+@DivisionID+'''
	and AT9000.TransactionTypeID=''T24''
	and '+@sSQLWhere+''
Set @sSQL = @sSQL+ '  

Group by 	AT9000.InventoryID, AT1302.InventoryName, AT1302.UnitID, AT1304.UnitName,	AT9000.Quantity,
		AT9000.CurrencyID,
		AT1302.SalePrice01,AT1310.SName, AT9000.DiscountRate,   	
		AT1302.S1, AT1302.S2, AT1302.S3	, AT9000.DivisionID  '

--print @sSQL
If not exists (Select top 1 1 From SysObjects Where name = 'AV3053' and Xtype ='V')
	Exec ('Create view AV3053 as '+@sSQL)
Else
	Exec ('Alter view AV3053 as '+@sSQL)