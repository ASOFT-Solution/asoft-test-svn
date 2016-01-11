/****** Object:  StoredProcedure [dbo].[OP0304]    Script Date: 12/16/2010 10:53:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



--Creater : Nguyen Thi Thuy Tuyen
---Creadate:26/06/2006
-- Puppose :Lay du lieu don hang  do ra combo cho man hinh nhap kho   !
-- Edit Thuy Tuyen , date 27/08/2006
--- Modify on 09/06/2014 by Bảo Anh: Lấy DivisionID từ OV0303 nếu OV0304 NULL
--- Modify on 14/05/2015 by Bảo Anh: Bổ sung số đơn hàng
/********************************************
'* Edited by: [GS] [Hoàng Phước] [30/07/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP0304]  @DivisionID nvarchar(50),
				@IsDate tinyint,
				@FromMonth int,				
				@ToMonth int,
				@FromYear int,
				@ToYear int,
				@FromDate datetime,
				@ToDate datetime		
				--@FromInventoryID nvarchar(20),
				--@ToInventoryID nvarchar(20),
				--@IsGroup as tinyint,
				--@GroupID nvarchar(20) -- GroupID: OB, CI1, CI2, CI3, I01, I02, I03, I04, I05	
AS
DECLARE 	@sSQL nvarchar(max)
		
If  @IsDate =1-- theo ngay

Set @sSQL = 
N'Select A00.DivisionID ,
	A00.OrderID , 
	A00.InventoryID,  
	sum(ActualQuantity) as ActualQuantity, 
	Max(A01.VoucherDate) as ActualDate,
         	A01.WareHouseID,
	T02.TransactionID,
	T01.VoucherNo
	
	
From AT2007 A00 inner join AT2006 A01 on A00.VoucherID = A01.VoucherID And A00.DivisionID = A01.DivisionID
	inner join OT2001 T01 on T01.SOrderID  = A00.OrderID And T01.DivisionID  = A00.DivisionID
	Inner Join OT2002 T02 on T02.TransactionID = A00.OTransactionID And T02.DivisionID = A00.DivisionID
	

Where  A00.DivisionID = ''' + @DivisionID +  '''  and	
	( Convert(nvarchar(10),T01.OrderDate,101) Between '''+Convert(nvarchar(10),@FromDate,101)+'''  and  '''+Convert(nvarchar(10),@ToDate,101)+''')
	
	Group by A00.DivisionID, A00.OrderID, A00.InventoryID, A01.WareHouseID, T02.TransactionID, T01.VoucherNo'
Else ---Theo Ky
Set @sSQL = 
N'Select A00.DivisionID ,
	A00.OrderID , 
	A00.InventoryID,  
	sum(ActualQuantity) as ActualQuantity, 
	Max(A01.VoucherDate) as ActualDate,
    A01.WareHouseID,T02.TransactionID,
	T01.VoucherNo
	
	
	
From AT2007 A00 inner join AT2006 A01 on A00.VoucherID = A01.VoucherID And A00.DivisionID = A01.DivisionID
	inner join OT2001 T01 on T01.SOrderID  = A00.OrderID And T01.DivisionID  = A00.DivisionID
	Inner Join OT2002 T02 on T02.TransactionID = A00.OTransactionID And T02.DivisionID = A00.DivisionID
	Where  A00.DivisionID = ''' + @DivisionID +  '''  and	
	(A00.TranMonth + A00.TranYear*100 Between   '+str(@FromMonth)+' + '+str(@FromYear)+'*100 and '+str(@ToMonth)+' + 100*'+str(@ToYear)+') 
	Group by A00.DivisionID , A00.OrderID, A00.InventoryID, A01.WareHouseID,T02.TransactionID, T01.VoucherNo'

---print @sSQL
If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV0304')
	Drop view OV0304
EXEC('Create view OV0304 ---tao boi OP0304
		as ' + @sSQL)

Set @sSQL = N'select   distinct  OrderID,Isnull(OV0304.DivisionID,OV0303.DivisionID) as DivisionID, OV0303.InventoryID,AT1302.InventoryName, OT2002.RefInfor,
AT1302.Specification,Quantity,DeliDate,ActualQuantity,ActualDate, OV0304. WareHouseID, OT2002.Ana01ID, 	OT2002.Ana02ID, 	
	OT2002.Ana03ID,OT2002.Ana04ID ,OT2002.Ana05ID, Isnull(OV0304.VoucherNo,OV0303.VoucherNo) as VoucherNo
	
From OV0304  right Join OV0303 on OV0303.InventoryID = OV0304.InventoryID and OV0303.TransactionID = OV0304.TRansactionID and OV0303.DivisionID = OV0304.DivisionID
	     left Join AT1302 on AT1302.InventoryID = OV0303.InventoryID and 	AT1302.DivisionID = OV0303.DivisionID
	   left  Join OT2002 on OT2002.SOrderID = OV0304.OrderID And OT2002.DivisionID = OV0304.DivisionID
Where Quantity >0'
---PRINT @sSQL
If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV0305')
	Drop view OV0305
EXEC('Create view OV0305 ---tao boi OP0304
		as ' + @sSQL)