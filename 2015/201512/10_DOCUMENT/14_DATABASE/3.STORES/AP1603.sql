/****** Object:  StoredProcedure [dbo].[AP1603]    Script Date: 07/28/2010 14:09:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP1603]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AP1603]
GO

/****** Object:  StoredProcedure [dbo].[AP1603]    Script Date: 07/28/2010 14:09:44 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


---- Created by Thuy Tuyen , Date 28/01/2010
----  Load edit man hinh xuat dung trong ky
---- Edited by Bao Anh		Date: 08/07/2012
---- Purpose: Them bien VoucherID
---- Edit by Khanh Van on 10/01/2014: Them vào 20 parameter và ngày hình thành
/**********************************************
** Edited by: [GS] [Cáº©m Loan] [29/07/2010]
***********************************************/
 
CREATE PROCEDURE [dbo].[AP1603] @DivisionID as nvarchar(50), 
				 @TranMonth  as int, 
				 @TranYear as int,
				 @ToolID as nvarchar(50),
				 @VoucherID AS NVARCHAR (50)
 AS
Declare @sSQL as nvarchar(4000)
Declare @sSQL1 as nvarchar(4000)

Set @sSQL='
Select AT1603.DivisionID, AT1603.VoucherNo, AT1603.ToolID,AT1603.ToolName, AT1603.ObjectID, AT1603.Description,
AT1603.DebitAccountID , AT1603.CreditAccountID,  AT1603.ActualQuantity, 
 AT1603.Ana01ID, AT1603.Ana02ID, AT1603.Ana03ID, BeginMonth, BeginYear, 
AT1603.Ana04ID,AT1603.Ana05ID, AT1603.MethodID,AT1603.ReVoucherID, AT1603.ReTransactionID,
 AT1603.InventoryID,AT2007.Notes ,
(Case when exists (Select top 1 ToolID From AT1606 Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
					 and AT1606.TranMonth + 100*AT1606.TranYear <=  '+str(@TranMonth)+'  +  100* '+str(@TranYear)+')
					Then  (select top 1 AT1606.ConvertedNewAmount  From AT1606 
						Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
						and AT1606.TranMonth + 100*AT1606.TranYear <=  '+str(@TranMonth)+' +  100* '+str(@TranYear)+'  Order by AT1606.TranYear Desc,AT1606.TranMonth Desc )
				Else AT1603.ConvertedAmount end) as ConvertedAmount,

(Case when exists (Select top 1 ToolID From AT1606 Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
					 and AT1606.TranMonth + 100*AT1606.TranYear <=  '+str(@TranMonth)+'  +  100* '+str(@TranYear)+' )
					Then  
						(select top 1 AT1606.DepNewPercent  From AT1606 
						Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
						and AT1606.TranMonth + 100*AT1606.TranYear <=  '+str(@TranMonth)+'  +  100* '+str(@TranYear)+'  Order by AT1606.TranYear Desc,AT1606.TranMonth Desc )
					Else AT1603.ApportionRate end)	as ApportionRate, 
					
					(Case when exists (Select top 1 ToolID From AT1606 Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
					 and AT1606.TranMonth + 100*AT1606.TranYear <=  '+str(@TranMonth)+'  +  100* '+str(@TranYear)+' )
					Then  
						(select top 1 AT1606.DepNewAmount  From AT1606 
						Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
						and AT1606.TranMonth + 100*AT1606.TranYear <=  '+str(@TranMonth)+'  +  100* '+str(@TranYear)+'  Order by AT1606.TranYear Desc,AT1606.TranMonth Desc )
					Else AT1603.ApportionAmount end)	as ApportionAmount,
					
					'
Set @sSQL1='
(Case when exists (Select top 1 ToolID From AT1606 Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
					 and AT1606.TranMonth + 100*AT1606.TranYear <= '+str(@TranMonth)+'  +  100* '+str(@TranYear)+')
					Then  
						(select top 1 AT1606.DepNewPeriods  From AT1606 
						Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
						and AT1606.TranMonth + 100*AT1606.TranYear <=   '+str(@TranMonth)+'  +  100* '+str(@TranYear)+' Order by AT1606.TranYear Desc,AT1606.TranMonth Desc )
					Else AT1603.Periods end)	as Periods, 	

	DepAmount = Isnull((Select Sum(DepAmount) From AT1604
				Where 	ToolID = AT1603.ToolID and ReVoucherID = AT1603.VoucherID and
					TranMonth + TranYear*100 <= '+str(@TranMonth)+'+ '+str(@TranYear)+'*100),0), --- so tien phan bo
	
	DepPeriod = Isnull(Isnull(AT1603.DepPeriod,0) + Isnull((Select count(ToolID) From AT1604
				Where 	ToolID = AT1603.ToolID and ReVoucherID = AT1603.VoucherID),0),0), --- so ky phan bo

	(Case when exists (Select top 1 ToolID From AT1606 Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
					 and AT1606.TranMonth + 100*AT1606.TranYear <=  '+str(@TranMonth)+'  +  100* '+str(@TranYear)+')
					Then  (select top 1 AT1606.ConvertedNewAmount  From AT1606 
						Where AT1606.ToolID = AT1603.ToolID and AT1606.ReVoucherID = AT1603.VoucherID and AT1606.DivisionID = AT1603.DivisionID
						and AT1606.TranMonth + 100*AT1606.TranYear <=  '+str(@TranMonth)+' +  100* '+str(@TranYear)+'  Order by AT1606.TranYear Desc,AT1606.TranMonth Desc )
				Else AT1603.ConvertedAmount end)   - ( Isnull((Select Sum(DepAmount) From AT1604
				Where 	ToolID = AT1603.ToolID and ReVoucherID = AT1603.VoucherID),0) )  as RemainConvertedAmount,
				AT1603.Parameter01, AT1603.Parameter02, AT1603.Parameter03, AT1603.Parameter04, AT1603.Parameter05, AT1603.Parameter06, AT1603.Parameter07, AT1603.Parameter08, AT1603.Parameter09, AT1603.Parameter10	,  AT1603.Parameter11,AT1603.Parameter12,AT1603.Parameter13,AT1603.Parameter14,AT1603.Parameter15,AT1603.Parameter16,AT1603.Parameter17,AT1603.Parameter18,AT1603.Parameter19,AT1603.Parameter20, AT1603.EstablishDate, AT1603.ParentVoucherID
		
From AT1603 
Left Join AT2007 on AT2007.TransactionID = AT1603.ReTransactionID And AT2007.DivisionID = AT1603.DivisionID
Where AT1603.DivisionID = N'''+@DivisionID+'''  and ToolID =N''' +@ToolID+''' and AT1603.VoucherID = N''' + @VoucherID + '''
'

---Print @sSQL

If Not Exists (Select 1 From sysObjects Where Name ='AV1603')
	Exec ('Create view AV1603 as '+@sSQL +@sSQL1) ------ Tao boi store AP1603
Else
	Exec( 'Alter view AV1603 as '+@sSQL +@sSQL1) ----- Tao boi store AP1603
GO

