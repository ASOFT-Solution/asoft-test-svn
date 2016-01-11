
/****** Object:  StoredProcedure [dbo].[OP2013]    Script Date: 12/16/2010 11:32:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


---Created by: Vo Thanh Huong, date: 06/01/2005
---purpose: Xu ly so lieu in  Lenh xuat kho trong tien do giao hang
---Edit by B.Anh, date 15/03/2010	Mang FIX nay tu version 3.10.00 (do phat trien tu 3.0.0 len 3.10.00 khi sua store kg chay cho DB chuan)
/********************************************
'* Edited by: [GS] [Tố Oanh] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP2013]  @DivisionID nvarchar(50),
				@OrderID nvarchar(50),								
				@lstTimes nvarchar(100)
AS
DECLARE @sSQL nvarchar(4000), 
		@cur cursor,
		@Find int, 
		@Times int, 
		@sSQL1 nvarchar(4000),
		@sSQL2 nvarchar(4000),
		@sSQL3 nvarchar(4000)

Select @lstTimes = @lstTimes + ',',  @sSQL1 = ''
While   charindex(',', @lstTimes) <> 0
BEGIN
	Select @Times = left(@lstTimes,  charindex(',', @lstTimes) - 1), @lstTimes = right(@lstTimes, len(@lstTimes) - charindex(',', @lstTimes))	
	Set @sSQL1 = @sSQL1 + 'isnull(Quantity' + case when @Times < 10 then '0'  else '' end + cast(@Times as nvarchar(10)) + ', 0) + '
	CONTINUE
END

Set @sSQL1 = left(@sSQL1, len(@sSQL1) - 1)

Set @sSQL = 
 'Select distinct T00.DivisionID, 
	T00.SOrderID, 
	V00.VoucherNo, 
	V00.OrderDate, 
	V00.ObjectID, 
	V00.ObjectName,  
	T00.SalePrice,
	T00.VATPercent, 
	V00.Address as DeliveryAddress, 
	T03.Tel, T00.Description as DDescription, 
	V00.ContractNo,
	T04.PaymentName, V00.Notes,
	T00.Orders, T00.InventoryID, 
	isnull(T00.InventoryCommonName, T01.InventoryName) as InventoryName, 
	T02.UnitName, '

Set @sSQL2 = '	
From OT2002 T00 inner join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID
	inner join AT1304 T02 on T02.UnitID = T01.UnitID	and T02.DivisionID= T01.DivisionID
	inner join OV1003 V00 on V00.OrderID = T00.SOrderID and V00.Type = ''SO'' and V00.DivisionID= T00.DivisionID
	left join AT1202 T03 on T03.ObjectID  = V00.ObjectID and T03.DivisionID= V00.DivisionID
	left join AT1205 T04 on  T04.PaymentID =  V00.PaymentID and T04.DivisionID=  V00.DivisionID '


If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2013') 
	Drop view OV2013
EXEC('Create view OV2013 ---tao boi OP2013
		as ' + @sSQL + @sSQL1 + '  as Quantity,
		T00.SalePrice*('+ @sSQL1 + ')  as OriginalAmount,
		T00.SalePrice*('+ @sSQL1 + ') as  ConvertedAmount,
		T00.VATPercent*T00.SalePrice*('+ @sSQL1 + ')/100 as VATOriginalAmount,
		T00.VATPercent*T00.SalePrice*('+ @sSQL1 + ')/100  as VATConvertedAmount'
		+ @sSQL2 + ' Where T00.DivisionID = ''' + @DivisionID + ''' AND T00.SOrderID = ''' + @OrderID + ''' and ' + @sSQL1 + ' <> 0 ')
		
		