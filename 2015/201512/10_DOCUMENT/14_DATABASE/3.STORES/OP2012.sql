/****** Object:  StoredProcedure [dbo].[OP2012]    Script Date: 12/16/2010 16:09:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created dy: VO THANH HUONG, date: 07/01/2004
---purpose: Lay cac ngay giao hang de in lenh xuat kho
/********************************************
'* Edited by: [GS] [Tố Oanh] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP2012] @DivisionID nvarchar(50),
				@OrderID nvarchar(50)
 AS
Declare @Date01 as datetime, @Date02 as datetime, @Date03 as datetime, @Date04 as datetime, @Date05 as datetime, 
	@Date06 as datetime, @Date07 as datetime, @Date08 as datetime, @Date09 as datetime, @Date10 as datetime, 
	@Date11 as datetime, @Date12 as datetime, @Date13 as datetime, @Date14 as datetime, @Date15 as datetime, 
	@Date16 as datetime, @Date17 as datetime, @Date18 as datetime, @Date19 as datetime, @Date20 as datetime, 
	@Date21 as datetime, @Date22 as datetime, @Date23 as datetime, @Date24 as datetime, @Date25 as datetime, 
	@Date26 as datetime, @Date27 as datetime, @Date28 as datetime, @Date29 as datetime, @Date30 as datetime,	
	@sSQL nvarchar(4000), @ShipDate datetime

If not exists (Select Top 1 1 From OT2003 Where SOrderID = @OrderID)
BEGIN
	Select @ShipDate = ShipDate  From OT2001 Where SOrderID = @OrderID 

	Set @sSQL = case when isnull(@ShipDate,'') = '' then 'Select '''' as Dates, 1 as Times, ''' + @DivisionID + ''' as DivisionID '
			else  'Select DivisionID, isnull(ShipDate, '''') as Dates, 1 as Times, ''' + @DivisionID + ''' as DivisionID
		From OT2001 Where SOrderID = ''' + @OrderID+ '''' end 
END
else 	
Begin
Select    @Date01 = Date01,  @Date02 = Date02, @Date03 = Date03, @Date04 = Date04, @Date05 = Date05,
	 @Date06 = Date06,  @Date07 = Date07, @Date08 = Date08, @Date09 = Date09, @Date10 = Date10,
	 @Date11 = Date11,  @Date12 = Date12, @Date13 = Date13, @Date14 = Date14, @Date15 = Date15,
	 @Date16 = Date16,  @Date17 = Date17, @Date18 = Date18, @Date19 = Date19, @Date20 = Date20,
	 @Date21 = Date21,  @Date22 = Date22, @Date23 = Date23, @Date24 = Date24, @Date25 = Date25,
	 @Date26 = Date26,  @Date27 = Date27, @Date28 = Date28, @Date29 = Date29, @Date30 = Date30	
From OT2003 Where SOrderID = @OrderID 

Set @sSQL =  case when isnull(@Date01, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date01, 120) + ''' as Dates, 1 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date02, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date02, 120) + ''' as Dates, 2 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date03, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date03, 120) + ''' as Dates, 3 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date04, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date04, 120) + ''' as Dates, 4 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date05, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date05, 120) + ''' as Dates, 5 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date06, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date06, 120) + ''' as Dates, 6 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date07, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date07, 120) + ''' as Dates, 7 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date08, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date08, 120) + ''' as Dates, 8 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date09, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date09, 120) + ''' as Dates, 9 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date10, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date10, 120) + ''' as Dates, 10 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date11, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date11, 120) + ''' as Dates, 11 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date12, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date12, 120) + ''' as Dates, 12 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date13, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date13, 120) + ''' as Dates, 13 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date14, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date14, 120) + ''' as Dates, 14 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date15, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date15, 120) + ''' as Dates, 15 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date16, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date16, 120) + ''' as Dates, 16 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date17, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date17, 120) + ''' as Dates, 17 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date18, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date18, 120) + ''' as Dates, 18 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date19, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date19, 120) + ''' as Dates, 19 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date20, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date20, 120) + ''' as Dates, 20 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date21, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date21, 120) + ''' as Dates, 21 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date22, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date22, 120) + ''' as Dates, 22 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date23, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date23, 120) + ''' as Dates, 23 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date24, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date24, 120) + ''' as Dates, 24 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date25, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date25, 120) + ''' as Dates, 25 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date26, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date26, 120) + ''' as Dates, 26 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date27, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date27, 120) + ''' as Dates, 27 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date28, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date28, 120) + ''' as Dates, 28 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date29, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date29, 120) + ''' as Dates, 29 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end +
		case when isnull(@Date30, '') = '' then '' else ' Select ''' + convert(nvarchar(20), @Date30, 120) + ''' as Dates, 30 as Times, ''' + @DivisionID + ''' as DivisionID Union ' end 

Set @sSQL = left(@sSQL, len(@sSQL) - 5)
End
print @sSQL

If  exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV2012')
	Drop view OV2012
EXEC('Create view OV2012 ---tao boi OP2012
		 as ' + @sSQL)	




