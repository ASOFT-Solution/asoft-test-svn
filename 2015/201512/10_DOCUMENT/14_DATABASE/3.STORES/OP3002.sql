/****** Object:  StoredProcedure [dbo].[OP3002]    Script Date: 12/16/2010 16:26:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

----Created by: Vo Thanh Huong, date: 09/09/2004
----purpose: In  lich giao hang 
---- Modified by Tieu Mai on 25/12/2015: Bo sung thong tin quy cach khi co thiet lap quan ly mat hang theo quy cach

ALTER PROCEDURE [dbo].[OP3002] 	@DivisionID as nvarchar(50),
				@TranMonth as int,
				@TranYear as int,
				@SOrderID as nvarchar(50)
				
AS

Declare @sSQL as nvarchar(MAX), @Times as int,	@Dates as datetime, @cur as cursor,
	@Date01 as datetime, @Date02 as datetime, @Date03 as datetime, @Date04 as datetime, @Date05 as datetime, 
	@Date06 as datetime, @Date07 as datetime, @Date08 as datetime, @Date09 as datetime, @Date10 as datetime, 
	@Date11 as datetime, @Date12 as datetime, @Date13 as datetime, @Date14 as datetime, @Date15 as datetime, 
	@Date16 as datetime, @Date17 as datetime, @Date18 as datetime, @Date19 as datetime, @Date20 as datetime, 
	@Date21 as datetime, @Date22 as datetime, @Date23 as datetime, @Date24 as datetime, @Date25 as datetime, 
	@Date26 as datetime, @Date27 as datetime, @Date28 as datetime, @Date29 as datetime, @Date30 as DATETIME,
	@sSQL1 as nvarchar(MAX),
	@sSQL2 as nvarchar(MAX)

Select @sSQL = ''
Select    @Date01 = Date01,  @Date02 = Date02, @Date03 = Date03, @Date04 = Date04, @Date05 = Date05,
	 @Date06 = Date06,  @Date07 = Date07, @Date08 = Date08, @Date09 = Date09, @Date10 = Date10,
	 @Date11 = Date11,  @Date12 = Date12, @Date13 = Date13, @Date14 = Date14, @Date15 = Date15,
	 @Date16 = Date16,  @Date17 = Date17, @Date18 = Date18, @Date19 = Date19, @Date20 = Date20,
	 @Date21 = Date21,  @Date22 = Date22, @Date23 = Date23, @Date24 = Date24, @Date25 = Date25,
	 @Date26 = Date26,  @Date27 = Date27, @Date28 = Date28, @Date29 = Date29, @Date30 = Date30	
From OT2003 Where SOrderID = @SOrderID and DivisionID = @DivisionID

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
---print @sSQL


If  Exists (Select 1 From sysObjects Where Name ='OV3003' and XType = 'V')
	Drop view OV3003
Exec ('Create view OV3003  ---tao boi OP3002
			as '+@sSQL)

IF EXISTS (SELECT top 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN

Set @sSQL = 'Select  OT2002.DivisionID, OT2002.TransactionID, VoucherTypeID, VoucherNo, OrderDate, ContractNo, ContractDate,OT2001.SOrderID,	OT2001.ObjectID, 
			case when isnull(OT2001.ObjectName, '''') = '''' then AT1202.ObjectName else OT2001.ObjectName end as ObjectName,
			case when isnull(OT2001.Address, '''') = '''' then AT1202.Address else OT2001.Address end as ObjectAddress, 
			OT2001.DeliveryAddress, Transport,
			OT2001.EmployeeID, AT1103.FullName, AT1103.Address as EmployeeAddress,
			OT2002.InventoryID, InventoryName, AT1302.UnitID, UnitName, 
			AT1302.I01ID,   
			AT1302.I02ID, 
			AT1302.I03ID, 
			AT1302.I04ID, 
			AT1302.I05ID, 
			T15.AnaName as I01AnaName,
			T16.AnaName as I02AnaName,
			T17.AnaName as I03AnaName,
			T18.AnaName as I04AnaName,
			T19.AnaName as I05AnaName,			
			AT1302.Notes01 as InNotes01, AT1302.Notes02 as InNotes02, AT1302.notes03 as InNotes03, AT1302.Specification,
			OrderQuantity, SalePrice, 
			IsPicking, OT2002.WareHouseID, WareHouseName,
			Quantity01, Quantity02, Quantity03, Quantity04, Quantity05, 	
			Quantity06, Quantity07, Quantity08, Quantity09, Quantity10, 	
			Quantity11, Quantity12, Quantity13, Quantity14, Quantity15, 	
			Quantity16, Quantity17, Quantity18, Quantity19, Quantity20, 	
			Quantity21, Quantity22, Quantity23, Quantity24, Quantity25, 	
			Quantity26, Quantity27, Quantity28, Quantity29, Quantity30,
			O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID, 
			O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID,
			A01.StandardName AS S01Name, A02.StandardName AS S02Name, A03.StandardName AS S03Name, A04.StandardName AS S04Name, A05.StandardName AS S05Name,
			A06.StandardName AS S06Name, A07.StandardName AS S07Name, A08.StandardName AS S08Name, A09.StandardName AS S09Name, A10.StandardName AS S10Name,
			A11.StandardName AS S11Name, A12.StandardName AS S12Name, A13.StandardName AS S13Name, A14.StandardName AS S14Name, A15.StandardName AS S15Name,
			A16.StandardName AS S16Name, A17.StandardName AS S17Name, A18.StandardName AS SName18, A19.StandardName AS S19Name, A20.StandardName AS S20Name '
		SET @sSQL1 = '		
		From OT2002 left join AT1302 on AT1302.InventoryID= OT2002.InventoryID	and  AT1302.DivisionID = OT2002.DivisionID	
			inner join OT2001 on OT2001.SOrderID = OT2002.SOrderID	and  OT2001.DivisionID = OT2002.DivisionID	
			left join AT1303 on AT1303.WareHouseID = OT2002.WareHouseID and AT1303.DivisionID = OT2001.DivisionID 
			left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID 	and  AT1301.DivisionID = OT2002.DivisionID		
			left join AT1304 on AT1304.UnitID = AT1302.UnitID	and  AT1304.DivisionID = OT2002.DivisionID	
			left join AT1103 on AT1103.EmployeeID = OT2001.EmployeeID and AT1103.DivisionID = OT2001.DivisionID 
			left join AT1202 on AT1202.ObjectID = OT2001.ObjectID	and  AT1202.DivisionID = OT2002.DivisionID	
			Left Join AT1015  T15 on  T15.AnaID = AT1302.I01ID and T15. AnaTypeID =''I01'' AND T15.DivisionID = AT1302.DivisionID
			Left Join AT1015   T16 on T16.AnaID = AT1302.I02ID and T16.AnaTypeID =''I02'' AND T16.DivisionID = AT1302.DivisionID
			Left Join AT1015  T17  on  T17.AnaID = AT1302.I03ID and  T17.AnaTypeID =''I03'' AND T17.DivisionID = AT1302.DivisionID
			Left Join AT1015   T18 on T18.AnaID = AT1302.I04ID and T18.AnaTypeID =''I04'' AND T18.DivisionID = AT1302.DivisionID
			Left Join AT1015  T19  on  T19.AnaID = AT1302.I05ID and  T19.AnaTypeID =''I05'' AND T19.DivisionID = AT1302.DivisionID
			'
		SET @sSQL2 = '
			LEFT JOIN OT8899 O99 ON O99.DivisionID = OT2002.DivisionID AND O99.VoucherID = OT2002.SOrderID AND O99.TransactionID  = OT2002.TransactionID and O99.TableID  = ''OT2002''
			LEFT JOIN AT0128 A01 ON A01.DivisionID = O99.DivisionID AND A01.StandardID = O99.S01ID AND A01.StandardTypeID = ''S01''
			LEFT JOIN AT0128 A02 ON A02.DivisionID = O99.DivisionID AND A02.StandardID = O99.S02ID AND A02.StandardTypeID = ''S02''
			LEFT JOIN AT0128 A03 ON A03.DivisionID = O99.DivisionID AND A03.StandardID = O99.S03ID AND A03.StandardTypeID = ''S03''
			LEFT JOIN AT0128 A04 ON A04.DivisionID = O99.DivisionID AND A04.StandardID = O99.S04ID AND A04.StandardTypeID = ''S04''
			LEFT JOIN AT0128 A05 ON A05.DivisionID = O99.DivisionID AND A05.StandardID = O99.S05ID AND A05.StandardTypeID = ''S05''
			LEFT JOIN AT0128 A06 ON A06.DivisionID = O99.DivisionID AND A06.StandardID = O99.S06ID AND A06.StandardTypeID = ''S06''
			LEFT JOIN AT0128 A07 ON A07.DivisionID = O99.DivisionID AND A07.StandardID = O99.S07ID AND A07.StandardTypeID = ''S07''
			LEFT JOIN AT0128 A08 ON A08.DivisionID = O99.DivisionID AND A08.StandardID = O99.S08ID AND A08.StandardTypeID = ''S08''
			LEFT JOIN AT0128 A09 ON A09.DivisionID = O99.DivisionID AND A09.StandardID = O99.S09ID AND A09.StandardTypeID = ''S09''
			LEFT JOIN AT0128 A10 ON A10.DivisionID = O99.DivisionID AND A10.StandardID = O99.S10ID AND A10.StandardTypeID = ''S10''
			LEFT JOIN AT0128 A11 ON A11.DivisionID = O99.DivisionID AND A11.StandardID = O99.S11ID AND A11.StandardTypeID = ''S11''
			LEFT JOIN AT0128 A12 ON A12.DivisionID = O99.DivisionID AND A12.StandardID = O99.S12ID AND A12.StandardTypeID = ''S12''
			LEFT JOIN AT0128 A13 ON A13.DivisionID = O99.DivisionID AND A13.StandardID = O99.S13ID AND A13.StandardTypeID = ''S13''
			LEFT JOIN AT0128 A14 ON A14.DivisionID = O99.DivisionID AND A14.StandardID = O99.S14ID AND A14.StandardTypeID = ''S14''
			LEFT JOIN AT0128 A15 ON A15.DivisionID = O99.DivisionID AND A15.StandardID = O99.S15ID AND A15.StandardTypeID = ''S15''
			LEFT JOIN AT0128 A16 ON A16.DivisionID = O99.DivisionID AND A16.StandardID = O99.S16ID AND A16.StandardTypeID = ''S16''
			LEFT JOIN AT0128 A17 ON A17.DivisionID = O99.DivisionID AND A17.StandardID = O99.S17ID AND A17.StandardTypeID = ''S17''
			LEFT JOIN AT0128 A18 ON A18.DivisionID = O99.DivisionID AND A18.StandardID = O99.S18ID AND A18.StandardTypeID = ''S18''
			LEFT JOIN AT0128 A19 ON A19.DivisionID = O99.DivisionID AND A19.StandardID = O99.S19ID AND A19.StandardTypeID = ''S19''
			LEFT JOIN AT0128 A20 ON A20.DivisionID = O99.DivisionID AND A20.StandardID = O99.S20ID AND A20.StandardTypeID = ''S20''
		Where OT2001.DivisionID = N''' + isnull(@DivisionID,'') + ''' and 
			 OT2001.SOrderID = N''' + isnull(@SOrderID,'') + ''''	
	
END
ELSE
	Set @sSQL = 'Select  OT2002.DivisionID, TransactionID, VoucherTypeID, VoucherNo, OrderDate, ContractNo, ContractDate,OT2001.SOrderID,	OT2001.ObjectID, 
			case when isnull(OT2001.ObjectName, '''') = '''' then AT1202.ObjectName else OT2001.ObjectName end as ObjectName,
			case when isnull(OT2001.Address, '''') = '''' then AT1202.Address else OT2001.Address end as ObjectAddress, 
			OT2001.DeliveryAddress, Transport,
			OT2001.EmployeeID, AT1103.FullName, AT1103.Address as EmployeeAddress,
			OT2002.InventoryID, InventoryName, AT1302.UnitID, UnitName, 
			AT1302.I01ID,   
			AT1302.I02ID, 
			AT1302.I03ID, 
			AT1302.I04ID, 
			AT1302.I05ID, 
			T15.AnaName as I01AnaName,
			T16.AnaName as I02AnaName,
			T17.AnaName as I03AnaName,
			T18.AnaName as I04AnaName,
			T19.AnaName as I05AnaName,			
			AT1302.Notes01 as InNotes01, AT1302.Notes02 as InNotes02, AT1302.notes03 as InNotes03, AT1302.Specification,
			OrderQuantity, SalePrice, 
			IsPicking, OT2002.WareHouseID, WareHouseName,
			Quantity01, Quantity02, Quantity03, Quantity04, Quantity05, 	
			Quantity06, Quantity07, Quantity08, Quantity09, Quantity10, 	
			Quantity11, Quantity12, Quantity13, Quantity14, Quantity15, 	
			Quantity16, Quantity17, Quantity18, Quantity19, Quantity20, 	
			Quantity21, Quantity22, Quantity23, Quantity24, Quantity25, 	
			Quantity26, Quantity27, Quantity28, Quantity29, Quantity30 	
		From OT2002 left join AT1302 on AT1302.InventoryID= OT2002.InventoryID	and  AT1302.DivisionID = OT2002.DivisionID	
			inner join OT2001 on OT2001.SOrderID = OT2002.SOrderID	and  OT2001.DivisionID = OT2002.DivisionID	
			left join AT1303 on AT1303.WareHouseID = OT2002.WareHouseID and AT1303.DivisionID = OT2001.DivisionID 
			left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID 	and  AT1301.DivisionID = OT2002.DivisionID		
			left join AT1304 on AT1304.UnitID = AT1302.UnitID	and  AT1304.DivisionID = OT2002.DivisionID	
			left join AT1103 on AT1103.EmployeeID = OT2001.EmployeeID and AT1103.DivisionID = OT2001.DivisionID 
			left join AT1202 on AT1202.ObjectID = OT2001.ObjectID	and  AT1202.DivisionID = OT2002.DivisionID	
			Left Join AT1015  T15 on  T15.AnaID = AT1302.I01ID and T15. AnaTypeID =''I01'' AND T15.DivisionID = AT1302.DivisionID
			Left Join AT1015   T16 on T16.AnaID = AT1302.I02ID and T16.AnaTypeID =''I02'' AND T16.DivisionID = AT1302.DivisionID
			Left Join AT1015  T17  on  T17.AnaID = AT1302.I03ID and  T17.AnaTypeID =''I03'' AND T17.DivisionID = AT1302.DivisionID
			Left Join AT1015   T18 on T18.AnaID = AT1302.I04ID and T18.AnaTypeID =''I04'' AND T18.DivisionID = AT1302.DivisionID
			Left Join AT1015  T19  on  T19.AnaID = AT1302.I05ID and  T19.AnaTypeID =''I05'' AND T19.DivisionID = AT1302.DivisionID
		Where OT2001.DivisionID = N''' + isnull(@DivisionID,'') + ''' and 
			 OT2001.SOrderID = N''' + isnull(@SOrderID,'') + ''''
--PRINT @sSQL
--PRINT @sSQL1
--PRINT @sSQL2
If  Exists (Select 1 From sysObjects Where Name ='OV3004' and XType = 'V')
	Drop view OV3004
Exec ('Create view OV3004  ---tao boi OP3002
		as '+@sSQL + @sSQL1 + @sSQL2)
	
Set @sSQL = ''
Set @cur = cursor scroll keyset for 
		Select Distinct Dates, Times From OV3003 
		Order by Times
	
Open @cur
Fetch next from @cur into @Dates, @Times

While @@Fetch_Status = 0
Begin				
	Set @sSQL= @sSQL + ' Select DivisionID, TransactionID, cast(''' + convert(varchar(20), @Dates, 120) + '''  as datetime) as Dates, Quantity' + 
					case when @Times < 10 then '0' else '' end + cast(@Times as varchar(2)) +
					 ' as Quantity  From OV3004 Union '
	Fetch next from @cur into @Dates, @Times
End 
Close @cur
Set @sSQL = left(@sSQL, len(@sSQL) - 5)

--PRINT @sSQL
If  Exists (Select 1 From sysObjects Where Name ='OV3005' and XType = 'V')
Drop view OV3005
Exec ('Create view OV3005  ---tao boi OP3002
		as '+ @sSQL)
IF EXISTS (SELECT TOP 1 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
Set @sSQL = 'Select V00.DivisionID, VoucherNo, OrderDate, ObjectID, ObjectName, ObjectAddress, ContractNo, ContractDate, DeliveryAddress, 
			V01.InventoryID, V01.InventoryName, UnitName, OrderQuantity, Quantity, Dates, V00.TransactionID,
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
			V01.S01ID, V01.S02ID, V01.S03ID, V01.S04ID, V01.S05ID, V01.S06ID, V01.S07ID, V01.S08ID, V01.S09ID, V01.S10ID, 
			V01.S11ID, V01.S12ID, V01.S13ID, V01.S14ID, V01.S15ID, V01.S16ID, V01.S17ID, V01.S18ID, V01.S19ID, V01.S20ID,
			V01.S01Name, V01.S02Name, V01.S03Name, V01.S04Name, V01.S05Name,
			V01.S06Name, V01.S07Name, V01.S08Name, V01.S09Name, V01.S10Name,
			V01.S11Name, V01.S12Name, V01.S13Name, V01.S14Name, V01.S15Name,
			V01.S16Name, V01.S17Name, V01.SName18, V01.S19Name, V01.S20Name
		From OV3005 V00 left join OV3004 V01 on V00.TransactionID = V01.TransactionID and V00.DivisionID = V01.DivisionID'
ELSE 
	Set @sSQL = 'Select V00.DivisionID, VoucherNo, OrderDate, ObjectID, ObjectName, ObjectAddress, ContractNo, ContractDate, DeliveryAddress, 
			V01.InventoryID, V01.InventoryName, UnitName, OrderQuantity, Quantity, Dates, V00.TransactionID,
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
			InNotes01, InNotes02, InNotes03, Specification
		From OV3005 V00 left join OV3004 V01 on V00.TransactionID = V01.TransactionID and V00.DivisionID = V01.DivisionID'		
			
If  Exists (Select 1 From sysObjects Where Name ='OV3010' and XType = 'V')
	Drop view OV3010
Exec ('Create view OV3010  ---tao boi OP3002
		as '+ @sSQL)