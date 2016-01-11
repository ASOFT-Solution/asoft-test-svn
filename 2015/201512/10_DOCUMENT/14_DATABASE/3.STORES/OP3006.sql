/****** Object:  StoredProcedure [dbo].[OP3006]    Script Date: 12/16/2010 14:27:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



---Created by: Vo Thanh Huong, date: 04/11/2004
---purpose: In Tinh hinh thuc hien don hang mua
/***************************************************************
'* Edited by : [GS] [Quoc Cuong] [03/08/2010]
--- Edited by Tieu Mai	Date: 01/09/2015 Bổ sung mã, tên của 10 MPT, Parameter01->10
'**************************************************************/

ALTER PROCEDURE [dbo].[OP3006] @DivisionID nvarchar(50),
				@OrderID nvarchar(50)		
AS
Declare @Date01 as datetime, @Date02 as datetime, @Date03 as datetime, @Date04 as datetime, @Date05 as datetime, 
	@Date06 as datetime, @Date07 as datetime, @Date08 as datetime, @Date09 as datetime, @Date10 as datetime, 
	@Date11 as datetime, @Date12 as datetime, @Date13 as datetime, @Date14 as datetime, @Date15 as datetime, 
	@Date16 as datetime, @Date17 as datetime, @Date18 as datetime, @Date19 as datetime, @Date20 as datetime, 
	@Date21 as datetime, @Date22 as datetime, @Date23 as datetime, @Date24 as datetime, @Date25 as datetime, 
	@Date26 as datetime, @Date27 as datetime, @Date28 as datetime, @Date29 as datetime, @Date30 as datetime,	
	@sSQL nvarchar(MAX), @sSQL1 AS NVARCHAR(MAX), @VoucherNo nvarchar(50), @VoucherDate datetime

Select @VoucherNo = VoucherNo, @VoucherDate = OrderDate 
	From OT3001 Where POrderID = @OrderID

If not exists (Select Top 1 1 From OT3003 Where POrderID = @OrderID)
	Set @sSQL = 'Select ''' + @DivisionID + ''' as DivisionID, '''' as Dates, 1 as Times'
else 	
Begin
	Select    @Date01 = Date01,  @Date02 = Date02, @Date03 = Date03, @Date04 = Date04, @Date05 = Date05,
		 @Date06 = Date06,  @Date07 = Date07, @Date08 = Date08, @Date09 = Date09, @Date10 = Date10,
		 @Date11 = Date11,  @Date12 = Date12, @Date13 = Date13, @Date14 = Date14, @Date15 = Date15,
		 @Date16 = Date16,  @Date17 = Date17, @Date18 = Date18, @Date19 = Date19, @Date20 = Date20,
		 @Date21 = Date21,  @Date22 = Date22, @Date23 = Date23, @Date24 = Date24, @Date25 = Date25,
		 @Date26 = Date26,  @Date27 = Date27, @Date28 = Date28, @Date29 = Date29, @Date30 = Date30	
	From OT3003 Where POrderID = @OrderID

	Set @sSQL =  
	    case when isnull(@Date01, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date01, 120) + ''' as Dates, 1 as Times Union ' end +
		case when isnull(@Date02, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date02, 120) + ''' as Dates, 2 as Times Union ' end +
		case when isnull(@Date03, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date03, 120) + ''' as Dates, 3 as Times Union ' end +
		case when isnull(@Date04, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date04, 120) + ''' as Dates, 4 as Times Union ' end +
		case when isnull(@Date05, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date05, 120) + ''' as Dates, 5 as Times Union ' end +
		case when isnull(@Date06, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date06, 120) + ''' as Dates, 6 as Times Union ' end +
		case when isnull(@Date07, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date07, 120) + ''' as Dates, 7 as Times Union ' end +
		case when isnull(@Date08, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date08, 120) + ''' as Dates, 8 as Times Union ' end +
		case when isnull(@Date09, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date09, 120) + ''' as Dates, 9 as Times Union ' end +
		case when isnull(@Date10, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date10, 120) + ''' as Dates, 10 as Times Union ' end +
		case when isnull(@Date11, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date11, 120) + ''' as Dates, 11 as Times Union ' end +
		case when isnull(@Date12, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date12, 120) + ''' as Dates, 12 as Times Union ' end +
		case when isnull(@Date13, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date13, 120) + ''' as Dates, 13 as Times Union ' end +
		case when isnull(@Date14, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date14, 120) + ''' as Dates, 14 as Times Union ' end +
		case when isnull(@Date15, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date15, 120) + ''' as Dates, 15 as Times Union ' end +
		case when isnull(@Date16, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date16, 120) + ''' as Dates, 16 as Times Union ' end +
		case when isnull(@Date17, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date17, 120) + ''' as Dates, 17 as Times Union ' end +
		case when isnull(@Date18, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date18, 120) + ''' as Dates, 18 as Times Union ' end +
		case when isnull(@Date19, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date19, 120) + ''' as Dates, 19 as Times Union ' end +
		case when isnull(@Date20, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date20, 120) + ''' as Dates, 20 as Times Union ' end +
		case when isnull(@Date21, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date21, 120) + ''' as Dates, 21 as Times Union ' end +
		case when isnull(@Date22, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date22, 120) + ''' as Dates, 22 as Times Union ' end +
		case when isnull(@Date23, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date23, 120) + ''' as Dates, 23 as Times Union ' end +
		case when isnull(@Date24, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date24, 120) + ''' as Dates, 24 as Times Union ' end +
		case when isnull(@Date25, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date25, 120) + ''' as Dates, 25 as Times Union ' end +
		case when isnull(@Date26, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date26, 120) + ''' as Dates, 26 as Times Union ' end +
		case when isnull(@Date27, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date27, 120) + ''' as Dates, 27 as Times Union ' end +
		case when isnull(@Date28, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date28, 120) + ''' as Dates, 28 as Times Union ' end +
		case when isnull(@Date29, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date29, 120) + ''' as Dates, 29 as Times Union ' end +
		case when isnull(@Date30, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID,''' + convert(nvarchar(50), @Date30, 120) + ''' as Dates, 30 as Times Union ' end 

	Set @sSQL = left(@sSQL, len(@sSQL) - 5)
End
If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV3102')
	Drop view OV3102
EXEC('Create view OV3102 ---tao boi OP3006
		 as ' + @sSQL)	


Set @sSQL = 'Select  T00.DivisionID,
			V00.Dates, V00.Times, T00. InventoryID, A00.InventoryName, A01.UnitName, A00.Specification,
			A00.InventoryTypeID,
			 sum(OrderQuantity) as OrderQuantity, 
			sum(case when Times = 1 then Quantity01 
			when Times = 2 then Quantity02 
			when Times = 3 then Quantity03 
			when Times = 4 then Quantity04 
			when Times = 5 then Quantity05 
			when Times = 6 then Quantity06 
			when Times = 7 then Quantity07 
			when Times = 8 then Quantity08 
			when Times = 9 then Quantity09 
			when Times = 10 then Quantity10 
			when Times = 11 then Quantity11 
			when Times = 12 then Quantity12 
			when Times = 13 then Quantity13 
			when Times = 14 then Quantity14 
			when Times = 15 then Quantity15 
			when Times = 16 then Quantity16 
			when Times = 17 then Quantity17 
			when Times = 18 then Quantity18 
			when Times = 19 then Quantity19 
			when Times = 20 then Quantity20 
			when Times = 21 then Quantity21 
			when Times = 22 then Quantity22 
			when Times = 23 then Quantity23 
			when Times = 24 then Quantity24 
			when Times = 25 then Quantity25 
			when Times = 26 then Quantity26 
			when Times = 27 then Quantity27 
			when Times = 28 then Quantity28 
			when Times = 29 then Quantity29 
			when Times = 30 then Quantity30  end) as Quantity,
			T00.Ana01ID as TAna01ID,
			T00.Ana02ID as TAna02ID,
			T00.Ana03ID as TAna03ID,
			T00.Ana04ID as TAna04ID,
			T00.Ana05ID as TAna05ID,
	
			A11.AnaName as A01AnaName,
			A02.AnaName as A02AnaName,
			A03.AnaName as A03AnaName,
			A04.AnaName as A04AnaName,
			A05.AnaName as A05AnaName,
	
			T00.Ana06ID as TAna06ID,
			T00.Ana07ID as TAna07ID,
			T00.Ana08ID as TAna08ID,
			T00.Ana09ID as TAna09ID,
			T00.Ana10ID as TAna10ID,
	
			A06.AnaName as A06AnaName,
			A07.AnaName as A07AnaName,
			A08.AnaName as A08AnaName,
			A09.AnaName as A09AnaName,
			A10.AnaName as A10AnaName,
			T00.StrParameter01, T00.StrParameter02, T00.StrParameter03, T00.StrParameter04, T00.StrParameter05,
			T00.StrParameter06, T00.StrParameter07, T00.StrParameter08, T00.StrParameter09, T00.StrParameter10
		'
SET @sSQL1 = 'From OT3002 T00 cross join OV3102 V00
			inner join AT1302 A00 ON A00.DivisionID = T00.DivisionID AND A00.InventoryID = T00.InventoryID
			inner join AT1304 A01 ON A01.DivisionID = T00.DivisionID AND A00.UnitID = A01.UnitID
			left join AT1011 A11 on A11.AnaTypeID = ''A01'' and A11.AnaID = T00.Ana01ID  and A11.DivisionID= T00.DivisionID
			left join AT1011 A02 on A02.AnaTypeID = ''A02'' and A02.AnaID = T00.Ana02ID  and A02.DivisionID= T00.DivisionID
			left join AT1011 A03 on A03.AnaTypeID = ''A03'' and A03.AnaID = T00.Ana03ID  and A03.DivisionID= T00.DivisionID
			left join AT1011 A04 on A04.AnaTypeID = ''A04'' and A04.AnaID = T00.Ana04ID  and A04.DivisionID= T00.DivisionID
			left join AT1011 A05 on A05.AnaTypeID = ''A05'' and A05.AnaID = T00.Ana05ID  and A05.DivisionID= T00.DivisionID
			left join AT1011 A06 on A06.AnaTypeID = ''A06'' and A06.AnaID = T00.Ana01ID  and A06.DivisionID= T00.DivisionID
			left join AT1011 A07 on A07.AnaTypeID = ''A07'' and A07.AnaID = T00.Ana02ID  and A07.DivisionID= T00.DivisionID
			left join AT1011 A08 on A08.AnaTypeID = ''A08'' and A08.AnaID = T00.Ana03ID  and A08.DivisionID= T00.DivisionID
			left join AT1011 A09 on A09.AnaTypeID = ''A09'' and A09.AnaID = T00.Ana04ID  and A09.DivisionID= T00.DivisionID
			left join AT1011 A10 on A10.AnaTypeID = ''A10'' and A10.AnaID = T00.Ana05ID  and A10.DivisionID= T00.DivisionID			
		Where T00.POrderID =''' + @OrderID + '''
		    AND T00.DivisionID = ''' + @DivisionID + '''
		Group by T00.DivisionID, V00.Dates, V00.Times, T00. InventoryID, A00.InventoryName, A01.UnitName , A00.Specification, A00.InventoryTypeID,
			T00.Ana01ID,T00.Ana02ID,T00.Ana03ID,T00.Ana04ID,T00.Ana05ID,T00.Ana06ID,T00.Ana07ID,T00.Ana08ID ,T00.Ana09ID,T00.Ana10ID,
			A11.AnaName,A02.AnaName,A03.AnaName,A04.AnaName,A05.AnaName,A06.AnaName,A07.AnaName,A08.AnaName,A09.AnaName,A10.AnaName,
			T00.StrParameter01, T00.StrParameter02, T00.StrParameter03, T00.StrParameter04, T00.StrParameter05,
			T00.StrParameter06, T00.StrParameter07, T00.StrParameter08, T00.StrParameter09, T00.StrParameter10'
If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV3103')
	Drop view OV3103
EXEC('Create view OV3103 ---tao boi OP3006
		as ' + @sSQL +@sSQL1)
--PRINT (@sSQL + @sSQL1)
Set @sSQL = 'Select A00.DivisionID, InventoryID,  sum(ActualQuantity) as ActualQuantity
		From AT2007 A00 
		    inner join AT2006 A01 on A01.DivisionID = A00.DivisionID and A00.VoucherID = A01.VoucherID and A01.KindVoucherID in(1, 5, 7)
		Where A00.OrderID = ''' + @OrderID + '''
		    AND A00.DivisionID = ''' + @DivisionID + '''
		Group by A00.DivisionID, InventoryID'

If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV3104')
	Drop view OV3104
EXEC('Create view OV3104 ---tao boi OP3006
		as ' + @sSQL)

Set @sSQL = 'Select T00.DivisionID, T00.InventoryID, InventoryName, A01.UnitName, A00.Specification,
		A00.InventoryTypeID, VoucherDate as Dates, V00.ActualQuantity, sum(T00.ActualQuantity) as Quantity
		From AT2007  T00   
		    inner join AT2006 T01 on T01.DivisionID = T00.DivisionID and T00.VoucherID = T01.VoucherID and T01.KindVoucherID in(1, 5, 7)
			inner join OV3104 V00 on V00.DivisionID = T00.DivisionID and T00.InventoryID = V00.InventoryID
			inner join AT1302 A00 on A00.DivisionID = T00.DivisionID and T00.InventoryID = A00.InventoryID
			inner join AT1304 A01 on A01.DivisionID = T00.DivisionID and A00.UnitID = A01.UnitID
		Where T00.OrderID = ''' + @OrderID + '''
		    AND T00.DivisionID = ''' + @DivisionID + '''
		Group by T00.DivisionID, T00.InventoryID, InventoryName,  A01.UnitName, Voucherdate , V00.ActualQuantity , A00.Specification,
		A00.InventoryTypeID '

If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name ='OV3105')
	Drop view OV3105
EXEC('Create view OV3105 ---tao boi OP3006
		as ' + @sSQL) 

---Tat ca ngay  trong ke hoach san xuat va thuc te thuc hien
Set @sSQL = 'Select Dates, DivisionID From OV3102 Union
		Select Distinct Dates, DivisionID From OV3105'

If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name ='OV3106')
	Drop view OV3106
EXEC('Create view OV3106  ---tao boi OP3006
		as ' + @sSQL) 
--//

Set @sSQL = 'Select V00.DivisionID, ''' + @VoucherNo + ''' as VoucherNo, ''' + convert(nvarchar(10), @VoucherDate, 103) + ''' as VoucherDate, 
		V00.InventoryID,  V00.InventoryName, V00.UnitName, V00.Specification,
		V00.InventoryTypeID, Dates, 
		1 as Types, ''OFML000183'' as TypeName, OrderQuantity, V01.ActualQuantity, Quantity,
		V00.TAna01ID,
		V00.TAna02ID,
		V00.TAna03ID,
		V00.TAna04ID,
		V00.TAna05ID,
	
		V00.A01AnaName,
		V00.A02AnaName,
		V00.A03AnaName,
		V00.A04AnaName,
		V00.A05AnaName,
	
		V00.TAna06ID,
		V00.TAna07ID,
		V00.TAna08ID,
		V00.TAna09ID,
		V00.TAna10ID,
	
		V00.A06AnaName,
		V00.A07AnaName,
		V00.A08AnaName,
		V00.A09AnaName,
		V00.A10AnaName,
		V00.StrParameter01,V00.StrParameter02,V00.StrParameter03, V00.StrParameter04, V00.StrParameter05,
		V00.StrParameter06,V00.StrParameter07,V00.StrParameter08,V00.StrParameter09,V00.StrParameter10  
	From OV3103 V00 left join OV3104 V01 on V00.InventoryID = V01.InventoryID 				
Union 
Select Distinct V00.DivisionID, ''' + @VoucherNo + ''' as VoucherNo, ''' + convert(nvarchar(10), @VoucherDate, 103) + ''' as VoucherDate, 
		V00.InventoryID, V00.InventoryName, V00.UnitName, V00.Specification,
		V00.InventoryTypeID, V00.Dates, 
		1 as Types,''OFML000183'' as TypeName, V01.OrderQuantity as OrderQuantity, ActualQuantity,  0 as Quantity,
		V01.TAna01ID,
		V01.TAna02ID,
		V01.TAna03ID,
		V01.TAna04ID,
		V01.TAna05ID,
	
		V01.A01AnaName,
		V01.A02AnaName,
		V01.A03AnaName,
		V01.A04AnaName,
		V01.A05AnaName,
	
		V01.TAna06ID,
		V01.TAna07ID,
		V01.TAna08ID,
		V01.TAna09ID,
		V01.TAna10ID,
	
		V01.A06AnaName,
		V01.A07AnaName,
		V01.A08AnaName,
		V01.A09AnaName,
		V01.A10AnaName,
		V01.StrParameter01, V01.StrParameter02, V01.StrParameter03, V01.StrParameter04, V01.StrParameter05,
		V01.StrParameter06, V01.StrParameter07, V01.StrParameter08, V01.StrParameter09, V01.StrParameter10
	From OV3105  V00 left join (Select Distinct InventoryID, OrderQuantity,TAna01ID,
		TAna02ID,
		TAna03ID,
		TAna04ID,
		TAna05ID,
	
		A01AnaName,
		A02AnaName,
		A03AnaName,
		A04AnaName,
		A05AnaName,
	
		TAna06ID,
		TAna07ID,
		TAna08ID,
		TAna09ID,
		TAna10ID,
	
		A06AnaName,
		A07AnaName,
		A08AnaName,
		A09AnaName,
		A10AnaName,
		StrParameter01, StrParameter02, StrParameter03,StrParameter04,StrParameter05,
		StrParameter06, StrParameter07, StrParameter08,StrParameter09,StrParameter10 From OV3103) V01 
		on V00.InventoryID = V01.InventoryID
	Where V00.Dates not in (Select Distinct Dates From OV3102) '

SET @sSQL1 =
'Union
Select V00.DivisionID, ''' + @VoucherNo + ''' as VoucherNo, ''' + convert(nvarchar(10), @VoucherDate, 103) + ''' as VoucherDate, 
		 V00.InventoryID,  V00.InventoryName, V00.UnitName, V00.Specification,
		V00.InventoryTypeID, Dates, 
		2 as Types, ''OFML000184'' as TypeName, V01.OrderQuantity, ActualQuantity, Quantity,
		V01.TAna01ID,
		V01.TAna02ID,
		V01.TAna03ID,
		V01.TAna04ID,
		V01.TAna05ID,
	
		V01.A01AnaName,
		V01.A02AnaName,
		V01.A03AnaName,
		V01.A04AnaName,
		V01.A05AnaName,
	
		V01.TAna06ID,
		V01.TAna07ID,
		V01.TAna08ID,
		V01.TAna09ID,
		V01.TAna10ID,
	
		V01.A06AnaName,
		V01.A07AnaName,
		V01.A08AnaName,
		V01.A09AnaName,
		V01.A10AnaName,
		V01.StrParameter01, V01.StrParameter02, V01.StrParameter03, V01.StrParameter04, V01.StrParameter05,
		V01.StrParameter06, V01.StrParameter07, V01.StrParameter08, V01.StrParameter09, V01.StrParameter10 
	From OV3105 V00 inner join
	(Select Distinct InventoryID, OrderQuantity,
	TAna01ID,
	TAna02ID,
	TAna03ID,
	TAna04ID,
	TAna05ID,
	
	A01AnaName,
	A02AnaName,
	A03AnaName,
	A04AnaName,
	A05AnaName,
	
	TAna06ID,
	TAna07ID,
	TAna08ID,
	TAna09ID,
	TAna10ID,
	
	A06AnaName,
	A07AnaName,
	A08AnaName,
	A09AnaName,
	A10AnaName,
	StrParameter01, StrParameter02,StrParameter03, StrParameter04, StrParameter05,
	StrParameter06, StrParameter07, StrParameter08, StrParameter09,StrParameter10 From OV3103)V01 
		on V00.InventoryID = V01.InventoryID		
Union 
Select Distinct V00.DivisionID, ''' + @VoucherNo + ''' as VoucherNo, ''' + convert(nvarchar(10), @VoucherDate, 103) + ''' as VoucherDate,
		V00.InventoryID,  V00.InventoryName, V00.UnitName, V00.Specification,
		V00.InventoryTypeID, V00.Dates,  
		2 as Types, ''OFML000184'' as TypeName, OrderQuantity, V01.ActualQuantity, 0 as Quantity,
		V00.TAna01ID,
		V00.TAna02ID,
		V00.TAna03ID,
		V00.TAna04ID,
		V00.TAna05ID,
	
		V00.A01AnaName,
		V00.A02AnaName,
		V00.A03AnaName,
		V00.A04AnaName,
		V00.A05AnaName,
	
		V00.TAna06ID,
		V00.TAna07ID,
		V00.TAna08ID,
		V00.TAna09ID,
		V00.TAna10ID,
	
		V00.A06AnaName,
		V00.A07AnaName,
		V00.A08AnaName,
		V00.A09AnaName,
		V00.A10AnaName,
		V00.StrParameter01, V00.StrParameter02, V00.StrParameter03, V00.StrParameter04,V00.StrParameter05,
		V00.StrParameter06, V00.StrParameter07, V00.StrParameter08, V00.StrParameter09,V00.StrParameter10
	From OV3103 V00 left join OV3104 V01 on V00.InventoryID = V01.InventoryID
	Where Dates not in (Select Distinct Dates From OV3105) '

--PRINT (@sSQL+@sSQL1)
If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name ='OV3107')
	Drop view OV3107
EXEC('Create view OV3107 ---tao boi OP3006
		as ' + @sSQL+@sSQL1)