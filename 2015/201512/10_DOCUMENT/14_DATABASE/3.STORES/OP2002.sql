/****** Object:  StoredProcedure [dbo].[OP2002]    Script Date: 12/16/2010 16:06:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 05/11/2004
---purpose: Bao cao Tinh hinh thuc hien don hang mua
/********************************************
'* Edited by: [GS] [Tố Oanh] [30/07/2010]
'********************************************/

ALTER PROCEDURE 	[dbo].[OP2002] @DivisionID nvarchar(50),
				@OrderID nvarchar(50)		
AS
Declare @Date01 as datetime, @Date02 as datetime, @Date03 as datetime, @Date04 as datetime, @Date05 as datetime, 
	@Date06 as datetime, @Date07 as datetime, @Date08 as datetime, @Date09 as datetime, @Date10 as datetime, 
	@Date11 as datetime, @Date12 as datetime, @Date13 as datetime, @Date14 as datetime, @Date15 as datetime, 
	@Date16 as datetime, @Date17 as datetime, @Date18 as datetime, @Date19 as datetime, @Date20 as datetime, 
	@Date21 as datetime, @Date22 as datetime, @Date23 as datetime, @Date24 as datetime, @Date25 as datetime, 
	@Date26 as datetime, @Date27 as datetime, @Date28 as datetime, @Date29 as datetime, @Date30 as datetime,	
	@sSQL nvarchar(4000),  @cur cursor, @Times int, @Orders int, @Dates datetime, @sSQL1 nvarchar(4000), @sSQL2 nvarchar(4000),
	@sSQL3 nvarchar(4000), @sSQL4 nvarchar(4000), @sSQL5 nvarchar(4000)

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

Set @sSQL =  case when isnull(@Date01, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date01, 120) + ''' as Dates, 1 as Times Union ' end +
		case when isnull(@Date02, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date02, 120) + ''' as Dates, 2 as Times Union ' end +
		case when isnull(@Date03, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date03, 120) + ''' as Dates, 3 as Times Union ' end +
		case when isnull(@Date04, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date04, 120) + ''' as Dates, 4 as Times Union ' end +
		case when isnull(@Date05, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date05, 120) + ''' as Dates, 5 as Times Union ' end +
		case when isnull(@Date06, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date06, 120) + ''' as Dates, 6 as Times Union ' end +
		case when isnull(@Date07, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date07, 120) + ''' as Dates, 7 as Times Union ' end +
		case when isnull(@Date08, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date08, 120) + ''' as Dates, 8 as Times Union ' end +
		case when isnull(@Date09, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date09, 120) + ''' as Dates, 9 as Times Union ' end +
		case when isnull(@Date10, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date10, 120) + ''' as Dates, 10 as Times Union ' end +
		case when isnull(@Date11, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date11, 120) + ''' as Dates, 11 as Times Union ' end +
		case when isnull(@Date12, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date12, 120) + ''' as Dates, 12 as Times Union ' end +
		case when isnull(@Date13, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date13, 120) + ''' as Dates, 13 as Times Union ' end +
		case when isnull(@Date14, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date14, 120) + ''' as Dates, 14 as Times Union ' end +
		case when isnull(@Date15, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date15, 120) + ''' as Dates, 15 as Times Union ' end +
		case when isnull(@Date16, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date16, 120) + ''' as Dates, 16 as Times Union ' end +
		case when isnull(@Date17, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date17, 120) + ''' as Dates, 17 as Times Union ' end +
		case when isnull(@Date18, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date18, 120) + ''' as Dates, 18 as Times Union ' end +
		case when isnull(@Date19, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date19, 120) + ''' as Dates, 19 as Times Union ' end +
		case when isnull(@Date20, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date20, 120) + ''' as Dates, 20 as Times Union ' end +
		case when isnull(@Date21, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date21, 120) + ''' as Dates, 21 as Times Union ' end +
		case when isnull(@Date22, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date22, 120) + ''' as Dates, 22 as Times Union ' end +
		case when isnull(@Date23, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date23, 120) + ''' as Dates, 23 as Times Union ' end +
		case when isnull(@Date24, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date24, 120) + ''' as Dates, 24 as Times Union ' end +
		case when isnull(@Date25, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date25, 120) + ''' as Dates, 25 as Times Union ' end +
		case when isnull(@Date26, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date26, 120) + ''' as Dates, 26 as Times Union ' end +
		case when isnull(@Date27, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date27, 120) + ''' as Dates, 27 as Times Union ' end +
		case when isnull(@Date28, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date28, 120) + ''' as Dates, 28 as Times Union ' end +
		case when isnull(@Date29, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date29, 120) + ''' as Dates, 29 as Times Union ' end +
		case when isnull(@Date30, '') = '' then '' else ' Select ''' + @DivisionID + ''' as DivisionID, ''' + convert(nvarchar(20), @Date30, 120) + ''' as Dates, 30 as Times Union ' end 

Set @sSQL = left(@sSQL, len(@sSQL) - 5)
End

If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2701')
	Drop view OV2701
EXEC('Create view OV2701 ---tao boi OP2002
		 as ' + @sSQL)	

Set @sSQL = 'Select A00.DivisionID, InventoryID,  sum(ActualQuantity) as ActualQuantity
		From AT2007 A00 inner join AT2006 A01 on A00.VoucherID = A01.VoucherID and A01.KindVoucherID in(1, 5, 7)
		Where A00.OrderID = ''' + @OrderID + '''
		Group by A00.DivisionID, InventoryID'

If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2702')
	Drop view OV2702
EXEC('Create view OV2702 ---tao boi OP2002
		as ' + @sSQL) 

Set @sSQL = 'Select T00.DivisionID, T00.InventoryID, VoucherDate as Dates , V00.ActualQuantity, sum(T00.ActualQuantity) as Quantity
		From AT2007  T00   inner join AT2006 T01 on T00.VoucherID = T01.VoucherID and T01.KindVoucherID in(1, 5, 7)	
			inner join OV2702 V00 on V00.InventoryID = T00.InventoryID				
		Where T00.OrderID = ''' + @OrderID + '''
		Group by T00.DivisionID, T00.InventoryID, VoucherDate, V00.ActualQuantity'

If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name ='OV2703')
	Drop view OV2703
EXEC('Create view OV2703 ---tao boi OP2002
		as ' + @sSQL) 

---Tat ca ngay  trong ke hoach san xuat va thuc te thuc hien
Set @sSQL = 'Select DivisionID, Dates, Times From OV2701 Union
		Select Distinct DivisionID, Dates, 31 as Times From OV2703 Where Dates not in (Select Dates From OV2701)'

If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name ='OV2704')
	Drop view OV2704
Exec('Create view OV2704  ---tao boi OP2002
		as ' + @sSQL) 
--//

Select @Orders = 1, @sSQL1 = 'Select DivisionID, InventoryID, sum(OrderQuantity) as OrderQuantity,  ', 
		@sSQL2 = 'Select DivisionID, InventoryID, ',  
		@sSQL = 'Select V00.DivisionID, case when isnull(V00.InventoryID, '''') = '''' then V01.InventoryID else V00.InventoryID end as InventoryID, 
				InventoryName, UnitName, V00.OrderQuantity, V02.ActualQuantity, ',
	    @sSQL3 = '',
	    @sSQL4 = '',
	    @sSQL5 = ''
Set @cur = Cursor scroll keyset for
		Select Dates, Times 	From OV2704  		Order by Dates
Open @cur
Fetch next from @cur into @Dates, @Times

While @@Fetch_Status = 0
Begin
	Set @sSQL1 = @sSQL1 + 'sum(' + case when  @Times < 10 	then 'isnull(Quantity0' + cast(@Times as nvarchar(2)) +', 0)'
				  when @Times < 31  	then 'isnull(Quantity' + cast(@Times as nvarchar(2)) +', 0)'			
				   else '0' end + ') as Quantity' + case when @Orders <  10 then  '0' else '' end + cast(@Orders as nvarchar(10)) + ', '	
	
	Set @sSQL2 = @sSQL2 + ' sum(case when Dates = ''' + convert(nvarchar(20), @Dates, 120) + 
			''' then isnull(Quantity,0)  else 0 end) as AQuantity' +  case when @Orders <  10 then  '0' else '' end + cast(@Orders as nvarchar(10)) + ', '	
	
    if(@Orders < 10)
	    Set @sSQL3 = @sSQL3 + '
Quantity0' + cast(@Orders as nvarchar(10)) + ' = case when Quantity0' + cast(@Orders as nvarchar(10)) + ' = 0 then NULL else Quantity0' + cast(@Orders as nvarchar(10)) + ' end,
AQuantity0' + cast(@Orders as nvarchar(10)) + ' = case when AQuantity0' + cast(@Orders as nvarchar(10)) + ' = 0 then NULL else AQuantity0' + cast(@Orders as nvarchar(10)) + ' end,'
	else
	    Set @sSQL4 = @sSQL4 + '
Quantity' + cast(@Orders as nvarchar(10)) + ' = case when Quantity' + cast(@Orders as nvarchar(10)) + ' = 0 then NULL else Quantity' + cast(@Orders as nvarchar(10)) + ' end,
AQuantity' + cast(@Orders as nvarchar(10)) + ' = case when AQuantity' + cast(@Orders as nvarchar(10)) + ' = 0 then NULL else AQuantity' + cast(@Orders as nvarchar(10)) + ' end,'

	Set @Orders = @Orders + 1
	Fetch next from @cur into @Dates, @Times
End

Set @sSQL1 = left(@sSQL1, len(@sSQL1) - 1) + ' From OT3002 Where POrderID = ''' + @OrderID + ''' Group by InventoryID, DivisionID '

Set @sSQL2 = left(@sSQL2, len(@sSQL2) - 1) + ' From OV2703 Group by InventoryID, DivisionID '

if(len(@sSQL4)=0)
    Set @sSQL3 = left(@sSQL3, len(@sSQL3) - 1)
else
    Set @sSQL4 = left(@sSQL4, len(@sSQL4) - 1)

Set @sSQL5 = ' From OV2705 V00 
         full join OV2706 V01 ON V01.DivisionID = V00.DivisionID AND V00.InventoryID = V01.InventoryID
		 full join OV2702 V02 ON V02.DivisionID = V00.DivisionID AND case when isnull( V00.InventoryID, '''') = '''' then V01.InventoryID else V00.InventoryID end = V02.InventoryID       	
		inner join AT1302 A00 ON A00.DivisionID = V00.DivisionID AND case when isnull(V00.InventoryID, '''') = '''' then V01.InventoryID else V00.InventoryID end = A00.InventoryID
		 left join AT1304 A01 ON A01.DivisionID = V00.DivisionID AND A01.UnitID = A00.UnitID'

If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name ='OV2705')
	Drop view OV2705
Exec('Create view OV2705  ---tao boi OP2002
		as ' + @sSQL1) 

If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name ='OV2706')
	Drop view OV2706
Exec('Create view OV2706  ---tao boi OP2002
		as ' + @sSQL2) 

If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name ='OV2707')
	Drop view OV2707
Exec('Create view OV2707  ---tao boi OP2002
		as ' + @sSQL + @sSQL3 + @sSQL4 + @sSQL5)










