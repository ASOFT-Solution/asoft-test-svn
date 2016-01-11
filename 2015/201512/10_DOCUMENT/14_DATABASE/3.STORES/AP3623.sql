/****** Object:  StoredProcedure [dbo].[AP3623]    Script Date: 12/16/2010 17:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Creater by: Nguyen Quoc Huy, Date 06/08/2009
--- Ke thua hoa don ban hang tu phieu xuat kho.
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
ALTER PROCEDURE [dbo].[AP3623] 	@DivisionID as nvarchar(50) ,
					@isDate as tinyint, 
				 	@FromDate as datetime,
					@ToDate as datetime,
					@FromMonth as int,
					@FromYear as int,
					@ToMonth as int,
					@ToYear as int,
					@isDelivery as tinyint,    -- 1: ke thua tu phieu xuat kho.
					@OrderIDList as nvarchar(200),
					@VoucherID as nvarchar(50),
					@ObjectID as nvarchar(50),
					@ConnID nvarchar(100) =''
				
AS


Declare @sSQL as nvarchar(4000),
	@sTimeWhere as nvarchar(500),
	@sOrderIDList as nvarchar(500)

	----- Buoc  1 : Tra ra thong tin Master View AV3623
IF @isDelivery = 1   -- ke thua tu phieu xuat kho
     BEGIN
	IF @isDate = 0 --Theo thang
		Set @sTimeWhere = '(AT2006.TranMonth + AT2006.TranYear*100 Between ('+str(@FromMonth)+' + '+str(@FromYear)+'*100) and ('+str(@ToMonth)+' + '+str(@ToYear)+'*100))  '
	Else
		Set @sTimeWhere = '(AT2006.VoucherDate Between '''+Convert(nvarchar(10),@FromDate,21)+''' and '''+convert(nvarchar(10), @ToDate,21)+''' ) '
	
	IF isnull(@OrderIDList,'')  = ''
		Begin
			Set @sOrderIDList = ''
			Set @OrderIDList = ''''''
		End
	Else
		Set @sOrderIDList = '  and ReSPVoucherID not in ('+@OrderIDList+') '
	
	Set @sSQL='
	Select 	distinct  
		AT2006.VoucherID, 
		AT2006.VoucherNo, AT2007.Ana01ID,
		AT2006.VoucherDate ,
		AT2006.ObjectID, 
		AT1202.ObjectName,
		AT1202.Address,
		AT2006.Description, 
		AT2006.EmployeeID, 
		AT1103.FullName,
        AT2006.DivisionID,
		Case when AT2006.VoucherID in (' + @OrderIDList + ')  then
				1  
			else
				0
		End as IsCheck

		
	From AT2006 	Inner join AT2007 on AT2007.VoucherID = AT2006.VoucherID and AT2007.DivisionID = AT2006.DivisionID
			Left join AT1202 on AT1202.ObjectID = AT2006.ObjectID and AT1202.DivisionID = AT2006.DivisionID
			Left join AT1103 on AT1103.EmployeeID =AT2006.EmployeeID and AT1103.DivisionID = AT2006.DivisionID
	
	Where (	AT2006.DivisionID ='''+@DivisionID+''' and
		AT2006.ObjectID like '''+@ObjectID+''' and 
		AT2006.KindVoucherID = 14 and			
		AT2007.TransactionID not in (Select isnull(ReTransactionID,'''')  From AT9000 Where TransactionTypeID =''T40''  and DivisionID ='''+@DivisionID+'''    ' + @sOrderIDList +'  ) and ' + @sTimeWhere + ') ' 

     END		


--print @ssql

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name =  'AV3623' + @ConnID)
	Exec('Create View  AV3623' + @ConnID + ' as '+@ssql)
Else
	Exec('Alter View AV3623' + @ConnID + ' as '+@ssql)


----- Buoc  2 : Tra ra thong tin Detail View AV3624
IF @isDelivery = 1     -- ke thua tu phieu xuat kho
     BEGIN
		Set @ssQL='
		Select 	
			AT2006.VoucherNo,AT2007.ReSPVoucherID,AT2006.ObjectID, 
			AT2007.InventoryID, 
			Case when isnull(AT2007.InventoryName1,'''')='''' then AT1302.InventoryName  Else AT2007.InventoryName1 end as  InventoryName,       	
			Case when isnull(AT2007.InventoryName1,'''')='''' then 0  Else 1 end as  IsInventoryCommonName,       	
			AT1302.UnitID, 			
			AT2007.ActualQuantity,      
			isnull(AT1309.ConversionFactor,1) as ConversionFactor,
			AT2007.UnitPrice, AT2007.OriginalAmount , AT2007.ConvertedAmount,
			AT1302.IsSource, AT1302.IsLocation, AT1302.SalesAccountID, AT1302.IsLimitDate, 
			AT1302.AccountID, AT1302.PrimeCostAccountID, AT1302.MethodID, AT1302.IsStocked,  
			AT2007.Ana01ID, AT2007.Ana02ID, AT2007.Ana03ID, AT2007.Ana04ID, AT2007.Ana05ID, AT2007.Orders,
			AT2007.TransactionID as   ReTransactionID,     AT2007.VoucherID as ReVoucherID ,
            AT2007.DivisionID,
			Case when AT2007.TransactionID in (Select ReTransactionID From AT9000 Where TransactionTypeID =''T40''  and ReVoucherID in  (' + @OrderIDList + ') and VoucherID = ''' + @VoucherID + ''' )  then
		
					1  
				else
					0
			End as IsCheck
		
		From AT2007 	inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID and AT2006.DivisionID = AT2007.DivisionID
				inner join AT1302 on AT1302.InventoryID =AT2007.InventoryID and AT1302.DivisionID =AT2007.DivisionID
				Left join AT1304 on AT1304.UnitID = AT2007.UnitID and AT1304.DivisionID = AT2007.DivisionID
				Left join AT1309 on AT1309.InventoryID = AT2007.InventoryID and AT1309.UnitID = AT2007.UnitID and AT1309.DivisionID = AT2007.DivisionID
		
		Where (	AT2006.DivisionID ='''+@DivisionID+''' and
			AT2006.ObjectID like '''+@ObjectID+''' and 
			AT2007.TransactionID not in (Select isnull(ReTransactionID,'''') From AT9000 where TransactionTypeID =''T40'' and DivisionID ='''+@DivisionID+'''    ' + @sOrderIDList +'  ) and ' + @sTimeWhere + ') ' 
       END
	

--print @sSQL

If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name =  'AV3624' + @ConnID )
	Exec('Create View AV3624' +@ConnID + ' as '+@ssql)

Else
	Exec('Alter View AV3624'+ @ConnID +' as '+@ssql)
GO
