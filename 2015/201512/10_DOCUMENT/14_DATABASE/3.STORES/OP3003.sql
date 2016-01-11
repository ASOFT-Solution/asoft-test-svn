/****** Object:  StoredProcedure [dbo].[OP3003]    Script Date: 12/16/2010 16:35:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong, date: 16/09/2004
----purpose: In  lich nhan hang
---- Modified on 08/09/2015 by Tiểu Mai: Bổ sung lấy tên, mã 10 MPT; 10 tham số từ đơn hàng mua.

ALTER PROCEDURE [dbo].[OP3003] 	@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@POrderID as nvarchar(50)
				
AS
Declare @sSQL as nvarchar(max), @sSQL1 AS NVARCHAR(MAX), @Times as int,	@Dates as datetime, @cur as cursor,
	@Date01 as datetime, @Date02 as datetime, @Date03 as datetime, @Date04 as datetime, @Date05 as datetime, 
	@Date06 as datetime, @Date07 as datetime, @Date08 as datetime, @Date09 as datetime, @Date10 as datetime, 
	@Date11 as datetime, @Date12 as datetime, @Date13 as datetime, @Date14 as datetime, @Date15 as datetime, 
	@Date16 as datetime, @Date17 as datetime, @Date18 as datetime, @Date19 as datetime, @Date20 as datetime, 
	@Date21 as datetime, @Date22 as datetime, @Date23 as datetime, @Date24 as datetime, @Date25 as datetime, 
	@Date26 as datetime, @Date27 as datetime, @Date28 as datetime, @Date29 as datetime, @Date30 as datetime

Select @sSQL = ''
Select    @Date01 = Date01,  @Date02 = Date02, @Date03 = Date03, @Date04 = Date04, @Date05 = Date05,
	 @Date06 = Date06,  @Date07 = Date07, @Date08 = Date08, @Date09 = Date09, @Date10 = Date10,
	 @Date11 = Date11,  @Date12 = Date12, @Date13 = Date13, @Date14 = Date14, @Date15 = Date15,
	 @Date16 = Date16,  @Date17 = Date17, @Date18 = Date18, @Date19 = Date19, @Date20 = Date20,
	 @Date21 = Date21,  @Date22 = Date22, @Date23 = Date23, @Date24 = Date24, @Date25 = Date25,
	 @Date26 = Date26,  @Date27 = Date27, @Date28 = Date28, @Date29 = Date29, @Date30 = Date30	
From OT3003 Where POrderID = @POrderID

Set @sSQL =  case when isnull(@Date01, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date01, 120) + ''' as datetime) as Dates, 1 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date02, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date02, 120) + ''' as datetime) as Dates, 2 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date03, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date03, 120) + ''' as datetime) as Dates, 3 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date04, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date04, 120) + ''' as datetime) as Dates, 4 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date05, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date05, 120) + ''' as datetime) as Dates, 5 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date06, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date06, 120) + ''' as datetime) as Dates, 6 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date07, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date07, 120) + ''' as datetime) as Dates, 7 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date08, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date08, 120) + ''' as datetime) as Dates, 8 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date09, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date09, 120) + ''' as datetime) as Dates, 9 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date10, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date10, 120) + ''' as datetime) as Dates, 10 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date11, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date11, 120) + ''' as datetime) as Dates, 11 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date12, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date12, 120) + ''' as datetime) as Dates, 12 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date13, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date13, 120) + ''' as datetime) as Dates, 13 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date14, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date14, 120) + ''' as datetime) as Dates, 14 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date15, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date15, 120) + ''' as datetime) as Dates, 15 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date16, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date16, 120) + ''' as datetime) as Dates, 16 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date17, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date17, 120) + ''' as datetime) as Dates, 17 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date18, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date18, 120) + ''' as datetime) as Dates, 18 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date19, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date19, 120) + ''' as datetime) as Dates, 19 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date20, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date20, 120) + ''' as datetime) as Dates, 20 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date21, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date21, 120) + ''' as datetime) as Dates, 21 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date22, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date22, 120) + ''' as datetime) as Dates, 22 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date23, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date23, 120) + ''' as datetime) as Dates, 23 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date24, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date24, 120) + ''' as datetime) as Dates, 24 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date25, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date25, 120) + ''' as datetime) as Dates, 25 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date26, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date26, 120) + ''' as datetime) as Dates, 26 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date27, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date27, 120) + ''' as datetime) as Dates, 27 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date28, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date28, 120) + ''' as datetime) as Dates, 28 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date29, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date29, 120) + ''' as datetime) as Dates, 29 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
	case when isnull(@Date30, '') = '' then '' else ' Select cast(''' + convert(varchar(20), @Date30, 120) + ''' as datetime) as Dates, 30 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end 

Set @sSQL = left(@sSQL, len(@sSQL) - 5)


If  Exists (Select 1 From sysObjects Where Name ='OV3006' and XType = 'V')
	Drop view OV3006
Exec ('Create view OV3006  ---tao boi OP3003
			as '+@sSQL)
	
Set @sSQL = 'Select  OT3002.DivisionID, TransactionID, VoucherTypeID, VoucherNo, OrderDate, OT3001.POrderID,	OT3001.ObjectID, 
			case when isnull(OT3001.ObjectName, '''') = '''' then AT1202.ObjectName else OT3001.ObjectName end as ObjectName,
			case when isnull(OT3001.Address, '''') = '''' then AT1202.Address else OT3001.Address end as ObjectAddress, 
			OT3001.ReceivedAddress, Transport,
			OT3001.EmployeeID, AT1103.FullName, AT1103.Address as EmployeeAddress,
			OT3002.InventoryID, InventoryName, AT1302.UnitID, UnitName, OrderQuantity, PurchasePrice, 
			IsPicking, OT3002.WareHouseID, WareHouseName,
			AT1302.I01ID,   
			AT1302.I02ID, 
			AT1302.I03ID, 
			AT1302.I04ID, 
			AT1302.I05ID, 
			
			I01.AnaName as I01AnaName,
			I02.AnaName as I02AnaName,
			I03.AnaName as I03AnaName,
			I04.AnaName as I04AnaName,
			I05.AnaName as I05AnaName,
			
			AT1302.Notes01 as InNotes01, AT1302.Notes02 as InNotes02, AT1302.notes03 as InNotes03, AT1302.Specification,
			Quantity01, Quantity02, Quantity03, Quantity04, Quantity05, 	
			Quantity06, Quantity07, Quantity08, Quantity09, Quantity10, 	
			Quantity11, Quantity12, Quantity13, Quantity14, Quantity15, 	
			Quantity16, Quantity17, Quantity18, Quantity19, Quantity20, 	
			Quantity21, Quantity22, Quantity23, Quantity24, Quantity25, 	
			Quantity26, Quantity27, Quantity28, Quantity29, Quantity30,
			OT3002.Ana01ID as TAna01ID,
			OT3002.Ana02ID as TAna02ID,
			OT3002.Ana03ID as TAna03ID,
			OT3002.Ana04ID as TAna04ID,
			OT3002.Ana05ID as TAna05ID,
	
			A01.AnaName as A01AnaName,
			A02.AnaName as A02AnaName,
			A03.AnaName as A03AnaName,
			A04.AnaName as A04AnaName,
			A05.AnaName as A05AnaName,
	
			OT3002.Ana06ID as TAna06ID,
			OT3002.Ana07ID as TAna07ID,
			OT3002.Ana08ID as TAna08ID,
			OT3002.Ana09ID as TAna09ID,
			OT3002.Ana10ID as TAna10ID,
	
			A06.AnaName as A06AnaName,
			A07.AnaName as A07AnaName,
			A08.AnaName as A08AnaName,
			A09.AnaName as A09AnaName,
			A10.AnaName as A10AnaName,
			OT3002.StrParameter01, OT3002.StrParameter02, OT3002.StrParameter03, OT3002.StrParameter04, OT3002.StrParameter05,
			OT3002.StrParameter06, OT3002.StrParameter07, OT3002.StrParameter08, OT3002.StrParameter09, OT3002.StrParameter10
		'	

 SET @sSQL1 = 'From OT3002 left join AT1302 on AT1302.InventoryID= OT3002.InventoryID and AT1302.DivisionID = OT3002.DivisionID	
			inner join OT3001 on OT3001.POrderID = OT3002.POrderID and OT3001.DivisionID = OT3002.DivisionID
			left join AT1303 on AT1303.WareHouseID = OT3002.WareHouseID and AT1303.DivisionID = OT3002.DivisionID 
			left join AT1301 on AT1301.InventoryTypeID = OT3001.InventoryTypeID and AT1301.DivisionID = OT3002.DivisionID
			left join AT1304 on AT1304.UnitID = AT1302.UnitID and AT1304.DivisionID= OT3002.DivisionID
			left join AT1103 on AT1103.EmployeeID = OT3001.EmployeeID and AT1103.DivisionID = OT3002.DivisionID
			left join AT1202 on AT1202.ObjectID = OT3001.ObjectID  and AT1202.DivisionID= OT3002.DivisionID
			Left Join AT1015 I01 on I01.AnaID = AT1302.I01ID and I01.AnaTypeID =''I01'' AND I01.DivisionID = AT1302.DivisionID
			Left Join AT1015 I02 on I02.AnaID = AT1302.I02ID and I02.AnaTypeID =''I02'' AND I02.DivisionID = AT1302.DivisionID
			Left Join AT1015 I03 on I03.AnaID = AT1302.I03ID and I03.AnaTypeID =''I03'' AND I03.DivisionID = AT1302.DivisionID
			Left Join AT1015 I04 on I04.AnaID = AT1302.I04ID and I04.AnaTypeID =''I04'' AND I04.DivisionID = AT1302.DivisionID
			Left Join AT1015 I05 on I05.AnaID = AT1302.I05ID and I05.AnaTypeID =''I05'' AND I05.DivisionID = AT1302.DivisionID
			left join AT1011 A01 on A01.AnaTypeID = ''A01'' and A01.AnaID = OT3002.Ana01ID  and A01.DivisionID= OT3002.DivisionID
			left join AT1011 A02 on A02.AnaTypeID = ''A02'' and A02.AnaID = OT3002.Ana02ID  and A02.DivisionID= OT3002.DivisionID
			left join AT1011 A03 on A03.AnaTypeID = ''A03'' and A03.AnaID = OT3002.Ana03ID  and A03.DivisionID= OT3002.DivisionID
			left join AT1011 A04 on A04.AnaTypeID = ''A04'' and A04.AnaID = OT3002.Ana04ID  and A04.DivisionID= OT3002.DivisionID
			left join AT1011 A05 on A05.AnaTypeID = ''A05'' and A05.AnaID = OT3002.Ana05ID  and A05.DivisionID= OT3002.DivisionID
			left join AT1011 A06 on A06.AnaTypeID = ''A06'' and A06.AnaID = OT3002.Ana06ID  and A06.DivisionID= OT3002.DivisionID
			left join AT1011 A07 on A07.AnaTypeID = ''A07'' and A07.AnaID = OT3002.Ana07ID  and A07.DivisionID= OT3002.DivisionID
			left join AT1011 A08 on A08.AnaTypeID = ''A08'' and A08.AnaID = OT3002.Ana08ID  and A08.DivisionID= OT3002.DivisionID
			left join AT1011 A09 on A09.AnaTypeID = ''A09'' and A09.AnaID = OT3002.Ana09ID  and A09.DivisionID= OT3002.DivisionID
			left join AT1011 A10 on A10.AnaTypeID = ''A10'' and A10.AnaID = OT3002.Ana10ID  and A10.DivisionID= OT3002.DivisionID
		Where OT3001.DivisionID = ''' + @DivisionID + ''' and 
			 OT3001.POrderID = ''' + @POrderID + ''''
If  Exists (Select 1 From sysObjects Where Name ='OV3007' and XType = 'V')
	Drop view OV3007
Exec ('Create view OV3007  ---tao boi OP3003
		as '+@sSQL+@sSQL1)
--PRINT @sSQL	
Set @sSQL = ''
Set @cur = cursor scroll keyset for 
		Select Distinct Dates, Times From OV3006
		Order by Times
	
Open @cur
Fetch next from @cur into @Dates, @Times

While @@Fetch_Status = 0
Begin				
	Set @sSQL= @sSQL + ' Select DivisionID, TransactionID, ''' + convert(varchar(20), @Dates, 120) + ''' as Dates, Quantity' + 
					case when @Times < 10 then '0' else '' end + cast(@Times as varchar(2)) +
					 ' as Quantity  From OV3007 Union '
	Fetch next from @cur into @Dates, @Times
End 
Close @cur

Set @sSQL = left(@sSQL, len(@sSQL) - 5)

If  Exists (Select 1 From sysObjects Where Name ='OV3008' and XType = 'V')
	Drop view OV3008
Exec ('Create view OV3008  ---tao boi OP3003
		as '+ @sSQL)

Set @sSQL = 'Select V00.DivisionID, VoucherNo, OrderDate, ObjectID, ObjectName, ObjectAddress, ReceivedAddress, 
			InventoryID, InventoryName, UnitName, OrderQuantity, Quantity, Dates, V00.TransactionID,
			I01ID,   
			I02ID, 
			I03ID, 
			I04ID, 
			I05ID, 
			I01AnaName,
			I02AnaName,
			I03AnaName,
			I04AnaName,
			I05AnaName,
			InNotes01, InNotes02, InNotes03, Specification,
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
			StrParameter06,StrParameter07,StrParameter08,StrParameter09, StrParameter10
		From OV3008 V00 left join OV3007 V01 on V00.TransactionID = V01.TransactionID and V00.DivisionID = V01.DivisionID'
			

If  Exists (Select 1 From sysObjects Where Name ='OV3020' and XType = 'V')
	Drop view OV3020
Exec ('Create view OV3020  ---tao boi OP3003
		as '+ @sSQL)




