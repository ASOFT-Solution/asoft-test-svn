/****** Object:  StoredProcedure [dbo].[AP1610]    Script Date: 07/28/2010 15:10:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1610]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1610]
GO

/****** Object:  StoredProcedure [dbo].[AP1610]    Script Date: 07/28/2010 15:10:05 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

----- Created by Nguyen Quoc Huy, Date 19/12/2008.
----- Purpose: Loc ra cac CCDC xuat dung trong ky
----Last Edit :Thuy Tuyen, date: 19/08/2009
----LastEdit Thuy Tuyen, date: 29/12/2009. Them Dieu kien where (AV1611.ConvertedAmount - sum(isnull(AT1603.ConvertedAmount,0)))  > = 0

/**********************************************
** Edited by: [GS] [Cẩm Loan] [29/07/2010]
***********************************************/
--- Edited by: Bao Anh	Date: 22/07/2012	
--- Purpose: Loai ra cac phieu duoc phan bo va ket chuyen ben Asoft-T

CREATE PROCEDURE  [dbo].[AP1610]  	@DivisionID as nvarchar(50),
					@TranMonth as int,
					@TranYear as int
					
					
 AS
Declare @sSQL as nvarchar(4000)



Set @sSQL='

Select AT9000.DivisionID, VoucherID, TransactionID, VoucherNo, VoucherDate, AT9000.InventoryID, ConvertedAmount, TDescription,DebitAccountID,  InventoryName, Quantity  
From AT9000  
	left join AT1302 on AT1302.InventoryID = AT9000.InventoryID and AT1302.DivisionID = AT9000.DivisionID 
 Where  TranMonth + TranYear *100  < = '+str(@TranMonth)+' +   100 *  '+str(@TranYear)+' and  AT9000.DivisionID = '''+@DivisionID+'''
		and DebitAccountID in (Select PreCostAccountID From AT0000 
		 where  DefDivisionID = '''+@DivisionID+''')
		and VoucherID not in 
		(Select VoucherID from AT1703 Inner join AT1704 on AT1703.JobID = AT1704.JobID 
		Where AT1704.Status = 1 and  AT1703.DivisionID = '''+@DivisionID+''') 
'



If  Exists (Select 1 From sysObjects Where Name ='AV1611')
	DROP VIEW AV1611
Exec ('Create view AV1611  --Tao boi AP1610
	as '+@sSQL)


Set @sSQL='
	Select AV1611.DivisionID,
		AV1611.VoucherID, 
		AV1611.TransactionID, 
		AV1611.VoucherNo, 
		AV1611.VoucherDate, 
		AV1611.InventoryID,  
		AV1611.TDescription, 
		AV1611.DebitAccountID,  
		AV1611.InventoryName, 
		AV1611.Quantity  ,
		(AV1611.ConvertedAmount - sum(isnull(AT1603.ConvertedAmount,0))) as ConvertedAmount
	From AV1611  left join AT1603 on AT1603.ReVoucherID = AV1611.VoucherID and AT1603.ReTransactionID = AV1611.TransactionID 
	                        and AT1603.DivisionID = AV1611.DivisionID
	Group by
		AV1611.DivisionID, AV1611.VoucherID, AV1611.TransactionID, AV1611.VoucherNo, AV1611.VoucherDate, AV1611.InventoryID,  
		AV1611.TDescription, AV1611.DebitAccountID,  AV1611.InventoryName, AV1611.Quantity ,AV1611.ConvertedAmount
	Having  (AV1611.ConvertedAmount - sum(isnull(AT1603.ConvertedAmount,0)))  > 0

'		

--Print @sSQL

If  Exists (Select 1 From sysObjects Where Name ='AV1610')
	DROP VIEW AV1610
Exec ('Create view AV1610  --Tao boi AP1610
	as '+@sSQL)
GO

