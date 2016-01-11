/****** Object:  StoredProcedure [dbo].[AP3204]    Script Date: 07/29/2010 11:25:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






---Created by:Nguyen Thi Thuy Tuyen,
--- Date: 01/10/2009
---purpose:  load detail cho man hinh  ke thua  nhieu  don hang mua(AF3203)
---Last Edit: Tuyen, tam gan VATGoupID den khi nao Op them VATGoupID thi sua lai, date 9/11/2009
---Last Edit: Thien Huynh: Chinh sua lai tinh OriginalAmount, ConvertedAmount, VATOriginalAmount, VATConvertedAmount
---Last Edit: Thien Huynh: Lay them cac truong ĐVT quy doi
---Last Edit: Thien Huynh: Chinh sua lai tinh VATOriginalAmount, VATConvertedAmount
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [29/07/2010]
'**************************************************************/
---- Modified by Tieu Mai on 15/12/2015: Bo sung quy cach khi co thiet lap quan ly mat hang theo quy cach

ALTER PROCEDURE [dbo].[AP3204] @DivisionID nvarchar(50),
				@VATGroupID nvarchar(50),
				@lstROrderID nvarchar(4000),
				@VoucherID nvarchar(50), --- Addnew   truyen ''; Load Edit :  so chung tu vua duoc chon sua
				@ConnID nvarchar(100) =''
				
AS
Declare @sSQL  nvarchar(4000),
	@sSQL1  nvarchar(4000),
	@VATRate decimal(28,8)

SET @sSQL1 = ''
Set  @lstROrderID = 	Replace(@lstROrderID, ',', ''',''')
Select @VATRate  = isnull(VATRate,0)   From AT1010 Where VATGroupID = @VATGroupID 
--- Print @lstROrderID



If isnull (@VoucherID,'') <> '' 
BEGIN

Set @sSQL ='
	Select 
		T00.ObjectID,  T00.VATObjectID , T00.CurrencyID,
		T00.OrderID,T00.OTransactionID AS TransactionID ,
		T00.InventoryID,T01.InventoryName, T01.UnitID,  0 as IsEditInventoryName,
		T00.Quantity, T00.UnitPrice, 
		T00.OriginalAmount, T00.ConvertedAmount, 
		null as DiscountPercent, 
		null as DiscountConvertedAmount,
		T01.IsSource, T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
		T01.AccountID, T01.MethodID, T01.IsStocked,
		T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID,  T00.Ana05ID,
		T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID,  T00.Ana10ID,
		T00.Orders, null  as DueDate,null as ShipDate, null as DueDays,'''' as VATNo,
		'''' as PaymentID, '''' as PaymenttermID,
		1 as IsCheck, AT1010.VATRate as VATPercent,
		T00.VatGroupID,
		(select Sum(OriginalAmount) from AT9000 where AT9000.VoucherID = T00.VoucherID  and TransactionTypeID = ''T03'' and  AT9000.InventoryID = T00.InventoryID)as VATOriginalAMount,
		(select Sum(ConvertedAmount)  from AT9000 where AT9000.VoucherID = T00.VoucherID  and TransactionTypeID = ''T03'' and AT9000.InventoryID = T00.InventoryID  )as VATConvertedAmount,
		BDescription, T00.DivisionID,
		T00.ConvertedUnitID, T00.ConvertedQuantity, T00.ConvertedPrice, 
		T00.UParameter01, T00.UParameter02, T00.UParameter03, T00.UParameter04, T00.UParameter05
	From AT9000  T00 
		Left join  AT1010 on AT1010.VATGroupID= T00.VATGroupID and T00.DivisionID =AT1010.DivisionID
		Inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID =T01.DivisionID  
	Where  T00.DivisionID = ''' + @DivisionID + '''  and 
		T00.VoucherID =  '''+@VoucherID+'''  
		and TransactionTypeID = ''T03''
		and  isnull(OTransactionID,'''')  <>''''
'
SET @sSQL1 = '
UNION

	Select T02.ObjectID, T02.ObjectID as VATObjectID, T02.CurrencyID, 
		T00.PorderID as OrderID,
		T00.TransactionID,
		T00.InventoryID,		
		isnull(T00.InventoryCommonName, T01.InventoryName)  as InventoryName, 
		T01.UnitID, 
		case when isnull(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  as  IsEditInventoryName, 
		V00.EndQuantity as Quantity,	
	        T00.PurchasePrice as UnitPrice, 
		case when IsNull(V00.EndQuantity,0) = IsNull(V00.OrderQuantity,0) then IsNull(T00.OriginalAmount,0) - IsNull(T00.DiscountOriginalAmount, 0)  else
		IsNull(V00.EndQuantity,0) * IsNull(T00.PurchasePrice,0) * (100 - IsNull(T00.DiscountPercent,0)) / 100	End As OriginalAmount , 	  
		case when  IsNull(V00.EndQuantity,0) = IsNull(V00.OrderQuantity,0) then  IsNull(T00.ConvertedAmount,0) - IsNull(T00.DiscountConvertedAmount, 0) else 
		IsNull(V00.EndQuantity,0) * IsNull(T00.PurchasePrice,0) * IsNull(ExchangeRate,0) * (100 - IsNull(T00.DiscountPercent,0)) / 100	End As ConvertedAmount,
		T00.DiscountPercent, 
		T00.DiscountConvertedAmount, T01.IsSource, 
		T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
		T01.AccountID, T01.MethodID, T01.IsStocked,
		T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
		T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
		T00.Orders ,null  as  DueDate,
		null as ShipDate,  null as DueDays, T02.VATNo,T02.PaymentID, T02.PaymenttermID,
		0 as IsCheck,  T00.VATPercent,  

---- AT1010.VatGroupID,
-----Last Edit: Tuyen, tam gan VATGoupID den khi nao Op them VATGoupID thi sua lai
		(case when T00.VATPercent = 10 then ''T10'' else
		Case when T00.VATPercent = 5 then ''T05'' else  ''T00'' end end ) as VATGroupID,

		--T00.VATOriginalAmount ,
		--T00.VATConvertedAmount ,
		case when IsNull(T00.VATPercent,0) = 0 Then T00.VATOriginalAmount  Else
			case when IsNull(V00.EndQuantity,0) = IsNull(V00.OrderQuantity,0) then IsNull(T00.OriginalAmount,0) - IsNull(T00.DiscountOriginalAmount, 0) * IsNull(T00.VATPercent,0)/100  else
			(IsNull(V00.EndQuantity,0) * IsNull(T00.PurchasePrice,0) * (100 - IsNull(T00.DiscountPercent,0)) / 100) * IsNull(T00.VATPercent,0)/100	End End As VATOriginalAmount , 	  
		case when IsNull(T00.VATPercent,0) = 0 Then T00.VATConvertedAmount  Else
			case when  IsNull(V00.EndQuantity,0) = IsNull(V00.OrderQuantity,0) then  IsNull(T00.ConvertedAmount,0) - IsNull(T00.DiscountConvertedAmount, 0) * IsNull(T00.VATPercent,0)/100 else 
			(IsNull(V00.EndQuantity,0) * IsNull(T00.PurchasePrice,0) * IsNull(ExchangeRate,0) * (100 - IsNull(T00.DiscountPercent,0)) / 100) * IsNull(T00.VATPercent,0)/100	End End As VATConvertedAmount,
		
		T02.notes as BDescription, T00.DivisionID,
		T00.UnitID As ConvertedUnitID, T00.ConvertedQuantity, T00.ConvertedSalePrice As ConvertedPrice, 
		T00.Parameter01 As UParameter01, T00.Parameter02 As UParameter02, T00.Parameter03 As UParameter03, 
		T00.Parameter04 As UParameter04, T00.Parameter05 As UParameter05
		
	From OT3002 T00  inner join OT3001 T02 on T00.POrderID =  T02.POrderID and T00.DivisionID =T02.DivisionID
		inner join AQ2902 V00 on V00.POrderID = T00.POrderID and V00.TransactionID = T00.TransactionID and T00.DivisionID =V00.DivisionID
		inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID  and T00.DivisionID =T01.DivisionID
		------Left Join At1010 on AT1010.VATRate  = T00.VATPercent
	Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.POrderID in (''' + @lstROrderID + ''') and 
		V00.EndQuantity > 0 
		 ' + 
		case when isnull(@VATGroupID , '') <> ''  and isnull(@VATGroupID , '') <> '%' then ' and T00.VATPercent = ' + cast(@VATRate as nvarchar(50))  else '' end 

END
ELSE
begin
	if exists (select 1, * from AT0000 where DefDivisionID = @DivisionID and IsSpecificate = 1)
	begin
		Set @sSQL ='Select T02.ObjectID, T02.ObjectID as VATObjectID, T02.CurrencyID, 
		T00.POrderID as OrderID,
		T00.TransactionID,
		T00.InventoryID,		
		isnull(T00.InventoryCommonName, T01.InventoryName)  as InventoryName, 
		T01.UnitID, 
		case when isnull(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  as  IsEditInventoryName, 
		V00.EndQuantity as Quantity,	
	    T00.PurchasePrice as UnitPrice, 
		case when IsNull(V00.EndQuantity,0) = IsNull(V00.OrderQuantity,0) Then IsNull(T00.OriginalAmount,0) - IsNull(T00.DiscountOriginalAmount, 0)  else
		IsNull(V00.EndQuantity,0) * IsNull(T00.PurchasePrice,0) * (100 - IsNull(T00.DiscountPercent,0)) / 100	End As OriginalAmount , 	  
		case when  IsNull(V00.EndQuantity,0) = IsNull(V00.OrderQuantity,0) then  IsNull(T00.ConvertedAmount,0) - IsNull(T00.DiscountConvertedAmount, 0) else 
		IsNull(V00.EndQuantity,0) * IsNull(T00.PurchasePrice,0) * IsNull(ExchangeRate,0) * (100 - IsNull(T00.DiscountPercent,0)) / 100 End As ConvertedAmount,
		T00.DiscountPercent, 
		T00.DiscountConvertedAmount, T01.IsSource, 
		T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
		T01.AccountID, T01.MethodID, T01.IsStocked,
		T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
		T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
		T00.Orders ,null as DueDate,
		null as ShipDate, null as DueDays, T02.VATNo,T02.PaymentID, T02.PaymenttermID,  0 as IsCheck, T00.VATPercent,
		
		 ---AT1010.VatGroupID,
-----Last Edit: Tuyen, tam gan VATGoupID den khi nao Op them VATGoupID thi sua lai
		(case when T00.VATPercent = 10 then ''T10'' else
		Case when T00.VATPercent = 5 then ''T05'' else  ''T00'' end end ) as VATGroupID,
		
		--T00.VATOriginalAmount ,
		--T00.VATConvertedAmount ,  
		case when IsNull(T00.VATPercent,0) = 0 Then T00.VATOriginalAmount  Else
			case when IsNull(V00.EndQuantity,0) = IsNull(V00.OrderQuantity,0) then IsNull(T00.OriginalAmount,0) - IsNull(T00.DiscountOriginalAmount, 0) * IsNull(T00.VATPercent,0)/100  else
			(IsNull(V00.EndQuantity,0) * IsNull(T00.PurchasePrice,0) * (100 - IsNull(T00.DiscountPercent,0)) / 100) * IsNull(T00.VATPercent,0)/100	End End As VATOriginalAmount , 	  
		case when IsNull(T00.VATPercent,0) = 0 Then T00.VATConvertedAmount  Else
			case when  IsNull(V00.EndQuantity,0) = IsNull(V00.OrderQuantity,0) then  IsNull(T00.ConvertedAmount,0) - IsNull(T00.DiscountConvertedAmount, 0) * IsNull(T00.VATPercent,0)/100 else 
			(IsNull(V00.EndQuantity,0) * IsNull(T00.PurchasePrice,0) * IsNull(ExchangeRate,0) * (100 - IsNull(T00.DiscountPercent,0)) / 100) * IsNull(T00.VATPercent,0)/100	End End As VATConvertedAmount,
		
		T02.notes as BDescription, T00.DivisionID,
		T00.UnitID As ConvertedUnitID, T00.ConvertedQuantity, T00.ConvertedSalePrice As ConvertedPrice, 
		T00.Parameter01 As UParameter01, T00.Parameter02 As UParameter02, T00.Parameter03 As UParameter03, 
		T00.Parameter04 As UParameter04, T00.Parameter05 As UParameter05,			
		O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
		O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
		AT01.StandardName S01Name, AT02.StandardName S02Name, AT03.StandardName S03Name, AT04.StandardName S04Name, AT05.StandardName S05Name,
		AT06.StandardName S06Name, AT07.StandardName S07Name, AT08.StandardName S08Name, AT09.StandardName S09Name, AT10.StandardName S10Name,
		AT11.StandardName S11Name, AT12.StandardName S12Name, AT13.StandardName S13Name, AT14.StandardName S14Name, AT15.StandardName S15Name,
		AT16.StandardName S16Name, AT17.StandardName S17Name, AT18.StandardName S18Name, AT19.StandardName S19Name, AT20.StandardName S20Name '
	
	set @sSQL1 = '	
	From OT3002 T00  inner join OT3001 T02 on T00.POrderID =  T02.POrderID and T00.DivisionID =T02.DivisionID
		inner join AQ2902 V00 on V00.POrderID = T00.POrderID and V00.TransactionID = T00.TransactionID  and T00.DivisionID =V00.DivisionID
		inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID  and T00.DivisionID =T01.DivisionID
		left join OT8899 O99 ON T00.DivisionID = O99.DivisionID and T00.POrderID = O99.VoucherID and O99.TransactionID = T00.TransactionID
		LEFT JOIN AT0128 AT01 ON AT01.StandardID = O99.S01ID AND AT01.StandardTypeID = ''S01''
		LEFT JOIN AT0128 AT02 ON AT02.StandardID = O99.S02ID AND AT02.StandardTypeID = ''S02''
		LEFT JOIN AT0128 AT03 ON AT03.StandardID = O99.S03ID AND AT03.StandardTypeID = ''S03''
		LEFT JOIN AT0128 AT04 ON AT04.StandardID = O99.S04ID AND AT04.StandardTypeID = ''S04''
		LEFT JOIN AT0128 AT05 ON AT05.StandardID = O99.S05ID AND AT05.StandardTypeID = ''S05''
		LEFT JOIN AT0128 AT06 ON AT06.StandardID = O99.S06ID AND AT06.StandardTypeID = ''S06''
		LEFT JOIN AT0128 AT07 ON AT07.StandardID = O99.S07ID AND AT07.StandardTypeID = ''S07''
		LEFT JOIN AT0128 AT08 ON AT08.StandardID = O99.S08ID AND AT08.StandardTypeID = ''S08''
		LEFT JOIN AT0128 AT09 ON AT09.StandardID = O99.S09ID AND AT09.StandardTypeID = ''S09''
		LEFT JOIN AT0128 AT10 ON AT10.StandardID = O99.S10ID AND AT10.StandardTypeID = ''S10''
		LEFT JOIN AT0128 AT11 ON AT11.StandardID = O99.S11ID AND AT11.StandardTypeID = ''S11''
		LEFT JOIN AT0128 AT12 ON AT12.StandardID = O99.S12ID AND AT12.StandardTypeID = ''S12''
		LEFT JOIN AT0128 AT13 ON AT13.StandardID = O99.S13ID AND AT13.StandardTypeID = ''S13''
		LEFT JOIN AT0128 AT14 ON AT14.StandardID = O99.S15ID AND AT14.StandardTypeID = ''S14''
		LEFT JOIN AT0128 AT15 ON AT15.StandardID = O99.S15ID AND AT15.StandardTypeID = ''S15''
		LEFT JOIN AT0128 AT16 ON AT16.StandardID = O99.S16ID AND AT16.StandardTypeID = ''S16''
		LEFT JOIN AT0128 AT17 ON AT17.StandardID = O99.S17ID AND AT17.StandardTypeID = ''S17''
		LEFT JOIN AT0128 AT18 ON AT18.StandardID = O99.S18ID AND AT18.StandardTypeID = ''S18''
		LEFT JOIN AT0128 AT19 ON AT19.StandardID = O99.S19ID AND AT19.StandardTypeID = ''S19''
		LEFT JOIN AT0128 AT20 ON AT20.StandardID = O99.S20ID AND AT20.StandardTypeID = ''S20''
	Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.POrderID in (''' + @lstROrderID + ''') and 
		V00.EndQuantity > 0 
		 ' + 
		case when isnull(@VATGroupID , '') <> ''  and isnull(@VATGroupID , '') <> '%' then ' and T00.VATPercent = ' + cast(@VATRate as nvarchar(50))  else '' end 
	end 
	else
	begin
		Set @sSQL ='Select T02.ObjectID, T02.ObjectID as VATObjectID, T02.CurrencyID, 
		T00.POrderID as OrderID,
		T00.TransactionID,
		T00.InventoryID,		
		isnull(T00.InventoryCommonName, T01.InventoryName)  as InventoryName, 
		T01.UnitID, 
		case when isnull(T00.InventoryCommonName, '''') = '''' then 0 else 1 end  as  IsEditInventoryName, 
		V00.EndQuantity as Quantity,	
	    T00.PurchasePrice as UnitPrice, 
		case when IsNull(V00.EndQuantity,0) = IsNull(V00.OrderQuantity,0) Then IsNull(T00.OriginalAmount,0) - IsNull(T00.DiscountOriginalAmount, 0)  else
		IsNull(V00.EndQuantity,0) * IsNull(T00.PurchasePrice,0) * (100 - IsNull(T00.DiscountPercent,0)) / 100	End As OriginalAmount , 	  
		case when  IsNull(V00.EndQuantity,0) = IsNull(V00.OrderQuantity,0) then  IsNull(T00.ConvertedAmount,0) - IsNull(T00.DiscountConvertedAmount, 0) else 
		IsNull(V00.EndQuantity,0) * IsNull(T00.PurchasePrice,0) * IsNull(ExchangeRate,0) * (100 - IsNull(T00.DiscountPercent,0)) / 100 End As ConvertedAmount,
		T00.DiscountPercent, 
		T00.DiscountConvertedAmount, T01.IsSource, 
		T01.IsLocation, T01.SalesAccountID, T01.IsLimitDate, 
		T01.AccountID, T01.MethodID, T01.IsStocked,
		T00.Ana01ID, T00.Ana02ID, T00.Ana03ID, T00.Ana04ID, T00.Ana05ID, 
		T00.Ana06ID, T00.Ana07ID, T00.Ana08ID, T00.Ana09ID, T00.Ana10ID, 
		T00.Orders ,null as DueDate,
		null as ShipDate, null as DueDays, T02.VATNo,T02.PaymentID, T02.PaymenttermID,  0 as IsCheck, T00.VATPercent,
		
		 ---AT1010.VatGroupID,
-----Last Edit: Tuyen, tam gan VATGoupID den khi nao Op them VATGoupID thi sua lai
		(case when T00.VATPercent = 10 then ''T10'' else
		Case when T00.VATPercent = 5 then ''T05'' else  ''T00'' end end ) as VATGroupID,
		
		--T00.VATOriginalAmount ,
		--T00.VATConvertedAmount ,  
		case when IsNull(T00.VATPercent,0) = 0 Then T00.VATOriginalAmount  Else
			case when IsNull(V00.EndQuantity,0) = IsNull(V00.OrderQuantity,0) then IsNull(T00.OriginalAmount,0) - IsNull(T00.DiscountOriginalAmount, 0) * IsNull(T00.VATPercent,0)/100  else
			(IsNull(V00.EndQuantity,0) * IsNull(T00.PurchasePrice,0) * (100 - IsNull(T00.DiscountPercent,0)) / 100) * IsNull(T00.VATPercent,0)/100	End End As VATOriginalAmount , 	  
		case when IsNull(T00.VATPercent,0) = 0 Then T00.VATConvertedAmount  Else
			case when  IsNull(V00.EndQuantity,0) = IsNull(V00.OrderQuantity,0) then  IsNull(T00.ConvertedAmount,0) - IsNull(T00.DiscountConvertedAmount, 0) * IsNull(T00.VATPercent,0)/100 else 
			(IsNull(V00.EndQuantity,0) * IsNull(T00.PurchasePrice,0) * IsNull(ExchangeRate,0) * (100 - IsNull(T00.DiscountPercent,0)) / 100) * IsNull(T00.VATPercent,0)/100	End End As VATConvertedAmount,
		
		T02.notes as BDescription, T00.DivisionID,
		T00.UnitID As ConvertedUnitID, T00.ConvertedQuantity, T00.ConvertedSalePrice As ConvertedPrice, 
		T00.Parameter01 As UParameter01, T00.Parameter02 As UParameter02, T00.Parameter03 As UParameter03, 
		T00.Parameter04 As UParameter04, T00.Parameter05 As UParameter05
		
	From OT3002 T00  inner join OT3001 T02 on T00.POrderID =  T02.POrderID and T00.DivisionID =T02.DivisionID
		inner join AQ2902 V00 on V00.POrderID = T00.POrderID and V00.TransactionID = T00.TransactionID  and T00.DivisionID =V00.DivisionID
		inner  join AT1302 T01 on T00.InventoryID = T01.InventoryID  and T00.DivisionID =T01.DivisionID
		----Left Join At1010 on AT1010.VATRate  = T00.VATPercent
	Where  T02.DivisionID = ''' + @DivisionID + ''' and 
		T00.POrderID in (''' + @lstROrderID + ''') and 
		V00.EndQuantity > 0 
		 ' + 
		case when isnull(@VATGroupID , '') <> ''  and isnull(@VATGroupID , '') <> '%' then ' and T00.VATPercent = ' + cast(@VATRate as nvarchar(50))  else '' end 
	end

end 
--Print  @sSQL
--print @sSQL1
If not exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'AV3204' + @ConnID)
	EXEC('Create view AV3204' + @ConnID + ' ----tao boi AP3204
			as ' + @sSQL + @sSQL1)
Else	
	EXEC('Alter view AV3204' + @ConnID + ' ----tao boi AP3204
			as ' + @sSQL + @sSQL1)