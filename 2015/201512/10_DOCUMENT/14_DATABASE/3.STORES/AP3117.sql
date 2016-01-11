/****** Object:  StoredProcedure [dbo].[AP3117]    Script Date: 07/29/2010 11:57:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



---- Created by  Thuy Tuyen
---- Created date 23/08/2007
---- Purpose: Kiem tra gia ban va gia von cho man hinh ban hang
---- Edit by: Dang Le Bao Quynh; Date: 16/01/2009
---- Purpose: Bo sung truong hop xuat hang mua tra lai
/********************************************
'* Edited by: [GS] [Tố Oanh] [29/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[AP3117] @DivisionID as nvarchar(50),
				@Month as int,
				@Year as int,
				@InventoryID as nvarchar(50),
				@SalePrice as decimal (28,8)
				

 AS
Set NoCount on
Declare @sSQL as nvarchar(4000),
	@MethodID as tinyint,
	@Price  as decimal (28,8),
	@EngMessage as nvarchar(250),
	@VieMessage as nvarchar(250),
	@Status  as tinyint
	

Set @MethodID = (Select MethodID From AT1302 Where InventoryID = @InventoryID)
Set @Status =0
Set @EngMessage =''
Set @VieMessage=''

Set @sSQL = ' Select  
 ExQuantity = (Select isnull(Sum(ActualQuantity),0)as ActualQuantity From AT2007 
		Inner join  AT2006 on AT2006.VoucherID =  AT2007.VoucherID and AT2006.DivisionID =  AT2007.DivisionID
		Where KindVoucherID in(2,4,6,10) and InventoryID = ''' + @InventoryID + ''' ),

 InQuantity = (Select isnull(Sum(ActualQuantity),0)as ActualQuantity From AT2007 
		Inner join  AT2006 on AT2006.VoucherID =  AT2007.VoucherID and AT2006.DivisionID =  AT2007.DivisionID
		Where KindVoucherID in(3,5,7) and InventoryID = ''' + @InventoryID + ''' ),

 EndQuantity = (Select isnull(Sum(ActualQuantity),0)as ActualQuantity From AT2007 
		Inner join  AT2006 on AT2006.VoucherID =  AT2007.VoucherID and AT2006.DivisionID =  AT2007.DivisionID
		Where KindVoucherID in(3,5,7) and InventoryID = ''' + @InventoryID + ''' ) -
    (Select isnull(Sum(ActualQuantity),0)as ActualQuantity From AT2007 
		Inner join  AT2006 on AT2006.VoucherID =  AT2007.VoucherID and AT2006.DivisionID =  AT2007.DivisionID
		Where KindVoucherID in(2,4,6,10) and InventoryID = ''' + @InventoryID + ''' ),
UnitPrice = isnull(Sum(ConvertedAmount),0)/((Select isnull(Sum(ActualQuantity),0)as ActualQuantity From AT2007 
		Inner join  AT2006 on AT2006.VoucherID =  AT2007.VoucherID and AT2006.DivisionID =  AT2007.DivisionID
		Where KindVoucherID in(3,5,7) and InventoryID = ''' + @InventoryID + ''' ) -
    (Select isnull(Sum(ActualQuantity),0)as ActualQuantity From AT2007 
		Inner join  AT2006 on AT2006.VoucherID =  AT2007.VoucherID and AT2006.DivisionID =  AT2007.DivisionID
		Where KindVoucherID in(2,4,6,10) and InventoryID = ''' + @InventoryID + ''' )), AT2007.DivisionID
From AT2007
	Inner Join AT2006 on AT2006.VoucherID = AT2007.VoucherID and AT2006.DivisionID =  AT2007.DivisionID
Where
AT2007.DivisionID ='''+@DivisionID+''' and
AT2007.InventoryID like ''' + @InventoryID + ''' and 
(AT2007.TranMonth  +100*AT2007.TranYear  between '+str(@Month)+ ' -1 + 100*'+str(@Year)+' and '+str(@Month)+' -1+  100*'+str(@Year)+ ') 
Group by InventoryID, AT2007.TranMonth, AT2007.TranYear, AT2007.DivisionID
			'


/*Else
Set @sSQL = 
	' Select  AT2008.WareHouseID, AT2008.UnitPrice, 
		sum(	Case when AT2008.TranMonth + AT2008.TranYear*100 = ' + ltrim(rtrim(str(@Month + @Year*100))) + '
			then isnull(EndQuantity, 0) else 0 end) as EndQuantity
		
	From AT2008  
	Where 	AT2008.DivisionID ='''+@DivisionID+''' and
		AT2008.InventoryID like ''' + @InventoryID + ''' and 
		( AT2008.TranMonth  +100*AT2008.TranYear  between '+str(@Month)+ ' + 100*'+str(@Year)+' and '+str(@Month)+' +  100*'+str(@Year)+ ') 
	Group by  AT2008.WareHouseID, AT2008.UnitPrice
 	'
*/
--print @sSQL


If not Exists (Select 1 From  sysObjects Where Xtype ='V' and Name ='AV3117')
	Exec(' Create view AV3117 as '+@sSQL)
Else
	Exec(' Alter view AV3117 as '+@sSQL)

Set @Price =  ( Select UnitPrice From AV3117   )

--print cast (@Price as varchar(20))

If Isnull( @Price,0) > Isnull( @SalePrice,0)   
   Begin
	Set @Status =1
	Set @VieMessage =' Gi¸n b¸n thÊp h¬n gi¸ vèn.!'
	Set @EngMessage = 'Sale price is less than .!'
	Goto EndMess
  End	
EndMess:
Select @Status as Status ,@EngMessage as EngMessage, @VieMessage as VieMessage