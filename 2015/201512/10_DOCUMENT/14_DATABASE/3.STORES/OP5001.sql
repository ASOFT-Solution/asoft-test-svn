---Created by: Vo Thanh Huong, date: 13/04/2005  
---purpose: Cap nhat lai tinh trang don hang   
---Last Edit : Thuy Tuyen, date 11/09/2008  
---Edit by: Dang Le Bao Quynh; Date: 30/10/2008  
---Purpose: Cai thien toc do  
/********************************************  
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]  
'********************************************/  
--- Edited by Bao Anh	Date: 27/11/2012	
--- Purpose:	1/ Sua loi DHSX khong ke thua qua Asoft-M nhung van cap nhat tinh trang la hoan tat
---				2/ Cap nhat tinh trang la Dang san xuat doi voi cac DHSX chưa duoc ke thua het

ALTER PROCEDURE [dbo].[OP5001] @DivisionID nvarchar(50),  
    @TranMonth int,  
    @TranYear int  
AS  
Declare @sSQL nvarchar(4000),  
@sSQL1 nvarchar(4000)  
  
Set @sSQL ='--Giu cho SO  
Select   
 ''SO'' as TypeID,   
 T01.DivisionID,   
 T00.SOrderID as OrderID,   
 T00.InventoryID, T00.TransactionID,  
 (  
  case when T00.Finish = 1   
  then 0  
  else   
   (  
    Case When AT1302.IsStocked = 0   
    then sum(isnull(OrderQuantity, 0)) - sum(isnull(AdjustQuantity,0)) - avg(isnull(ActualQuantityHD,0))   
    else sum(isnull(OrderQuantity, 0)) - sum(isnull(AdjustQuantity,0)) - avg(isnull(ActualQuantity,0))   
    end  
   )   
  end   
 ) as RemainQuantity ,  
 sum(isnull(ActualQuantity,0)) as ActualQuantity  
From  OT2002 T00   
 inner join OT2001 T01 on T00.SOrderID = T01.SOrderID and T00.DivisionID = T01.DivisionID   
 Inner join AT1302 on AT1302.InventoryID = T00.InventoryID and AT1302.DivisionID = T00.DivisionID  
 left  join    
 (--Giao hang thuc te  
  Select T00.OrderID, InventoryID, sum(ActualQuantity) as ActualQuantity, OTransactionID  
  From AT2007 T00 inner join AT2006 T01 on T00.VoucherID = T01.VoucherID and T00.DivisionID = T01.DivisionID  
  Where KindVoucherID in (2, 4) and isnull(T00.OrderID, '''') <> ''''   
  and T00.DivisionID = '''+@DivisionID + '''  
  Group by T00.OrderID, InventoryID,OTransactionID  
 ) T02 on T02.InventoryID = T00.InventoryID and   
    T02.OrderID = T00.SOrderID and   
    T02.OTransactionID = T00.TransactionID   
'  
set @sSQL1 =  
N'left join   
 (-- Lap Hoa don doi voi nhung mat hang AT1302.IsStocked = 0)  
  Select AT9000.DivisionID, AT9000.OrderID, OTransactionID, InventoryID, sum(Quantity) As ActualQuantityHD  
  From AT9000    
  Where isnull(AT9000.OrderID,'''') <>''''   
  and  TransactionTypeID =''T04''  
  and DivisionID = '''+ @DivisionID +'''  
  Group by AT9000.DivisionID, AT9000.OrderID, InventoryID, OTransactionID  
 ) as G   
  on  T01.DivisionID = G.DivisionID and  
   T00.SOrderID = G.OrderID and  
   T00.InventoryID = G.InventoryID and  
   T00.TransactionID = G.OTransactionID  
Where OrderStatus not in (0,4, 5, 9) and   
  T01.Disabled = 0 and T01.DivisionID like isnull(N''' + @DivisionID + ''', '''')  and   
  T01.TranMonth + T01.TranYear*100 < = ' + cast(@TranMonth + @TranYear*100 as nvarchar(50)) + '      
Group by T01.DivisionID,  T00.SOrderID, T00.InventoryID,TransactionID, T00.Finish, AT1302.IsStocked'  
  
If exists (SELECT Top 1 1 From sysObjects Where XType = 'V'  and Name = 'OV5101')  
 EXEC('Alter view OV5101 ---tao boi OP5001   
 as ' + @sSQL + @sSQL1)  
else   
 EXEC('Create view OV5101 ---tao boi OP5001   
 as ' + @sSQL + @sSQL1)  
  
  
--Union all  
Set @sSQL ='--Hang dang ve PO  
Select   
 ''PO'' as TypeID, T01.DivisionID, T00.POrderID as OrderID, T00.InventoryID, TransactionID ,  
 -------sum(isnull(OrderQuantity, 0)) - sum(isnull(AdjustQuantity,0)) - avg(isnull(ActualQuantity,0))  as RemainQuantity ,  
 (   
  case when T00.Finish = 1   
  then 0     
  else   
  (    
   Case When AT1302.IsStocked = 0   
   then sum(isnull(OrderQuantity, 0)) - sum(isnull(AdjustQuantity,0)) - avg(isnull(ActualQuantityHD,0))   
   else sum(isnull(OrderQuantity, 0)) - sum(isnull(AdjustQuantity,0)) - avg(isnull(ActualQuantity,0))   
   end  
  )   
  end   
 )   as RemainQuantity ,  
 sum(isnull(ActualQuantity,0)) as ActualQuantity  
From  OT3002 T00 inner join OT3001 T01 on T00.POrderID = T01.POrderID and T00.DivisionID = T01.DivisionID  
  inner join AT1302 on AT1302.InventoryID = T00.InventoryID and AT1302.DivisionID = T00.DivisionID  
  left Join   
  (--Nhap hang PO  
   Select T00.DivisionID, T00.OrderID, InventoryID, sum(ActualQuantity) as ActualQuantity, OTransactionID  
   From AT2007 T00 inner join AT2006 T01 on T00.VoucherID = T01.VoucherID and T00.DivisionID = T01.DivisionID  
   Where KindVoucherID in (1, 5, 7) and isnull(T00.OrderID, '''') <> ''''  
   and T00.DivisionID = ''' + @DivisionID +'''  
   Group by T00.DivisionID, T00.OrderID, InventoryID,OTransactionID  
  ) T03 on T03.OrderID = T00.POrderID and   
     T03.InventoryID = T00.InventoryID and    
     T03.DivisionID = T00.DivisionID and    
     T03.OTRansactionID = T00.TRansactionID    
'  
set @sSQL1 =   
N'Left join   
 (-- Lap phi?u mua hàng  doi voi nhung mat hang AT1302.IsStocked = 0)  
  Select AT9000.DivisionID, AT9000.OrderID, OTransactionID, InventoryID, sum(Quantity) As ActualQuantityHD  
  From AT9000    
  Where isnull(AT9000.OrderID,'''') <>'''' and TransactionTypeID =''T05''  
  Group by AT9000.DivisionID, AT9000.OrderID, InventoryID, OTransactionID  
 ) as G on T01.DivisionID = G.DivisionID and   
    T00.POrderID = G.OrderID and   
    T00.InventoryID = G.InventoryID and  
    T00.TransactionID = G.OTransactionID  
Where OrderStatus not in (0, 3,4, 9) and   
  T01.Disabled = 0 and   
  T01.DivisionID like isnull(N''' + @DivisionID + ''', '''')  and   
  T01.TranMonth + T01.TranYear*100 < = ' + cast(@TranMonth + @TranYear*100 as nvarchar(50)) + '    
Group by T01.DivisionID, T00.POrderID, T00.InventoryID, TransactionID,T00.Finish, AT1302.IsStocked'  
  
--Union all  
If exists (SELECT Top 1 1 From sysObjects Where XType = 'V'  and Name = 'OV5102')  
  EXEC('Alter view OV5102 ---tao boi OP5001   
  
      as ' + @sSQL + @sSQL1)  
else   
  EXEC('Create view OV5102 ---tao boi OP5001   
  
      as ' + @sSQL + @sSQL1)  
  
Set @sSQL ='--Giu cho du tru ES  
Select ''ES'' as TypeID, T01.DivisionID,  T00.EstimateID as OrderID, MaterialID as InventoryID, '''' as TransactionID ,  
  sum(isnull(MaterialQuantity, 0)) - avg(isnull(ActualQuantity,0))  as RemainQuantity ,  
  sum(isnull(ActualQuantity,0))  as ActualQuantity  
From  OT2203 T00 inner join OT2201 T01 on T00.EstimateID = T01.EstimateID and T00.DivisionID = T01.DivisionID  
 left join (--Xuat hang ES  
 Select T00.DivisionID, T00.OrderID, InventoryID, sum(ActualQuantity) as ActualQuantity  
 From AT2007 T00 inner join AT2006 T01 on T00.VoucherID = T01.VoucherID and T00.DivisionID = T01.DivisionID  
 Where KindVoucherID in (2, 4) and isnull(T00.OrderID, '''') <> ''''  
 Group by T00.DivisionID, T00.OrderID, InventoryID  
 ) T03 on T03.OrderID = T00.EstimateID and T03.InventoryID = T00.MaterialID  and T03.DivisionID = T00.DivisionID   
'  
set @sSQL1 =  
N'Where OrderStatus not in (0, 3,4, 9) -- and T01.Disabled = 0   
  and T01.DivisionID like isnull(N''' + @DivisionID + ''', '''')  and   
 T01.TranMonth + T01.TranYear*100 < = ' + cast(@TranMonth + @TranYear*100 as nvarchar(50)) + '    
Group by T01.DivisionID, T00.EstimateID, MaterialID'  
print @sSQL + @sSQL1  
If exists (SELECT Top 1 1 From sysObjects Where XType = 'V'  and Name = 'OV5103')  
  EXEC('Alter view OV5103 ---tao boi OP5001   
      as ' + @sSQL + @sSQL1)  
else  
  EXEC('Create view OV5103 ---tao boi OP5001   
      as ' + @sSQL + @sSQL1)  
  
  
Set @sSQL = 'Select TypeID, DivisionID, OrderID, sum(isnull(ActualQuantity,0)) as ActualQuantity,  
 sum(case when RemainQuantity <0 then 0 else RemainQuantity end) as RemainQuantity  
From OV5101 where DivisionID  = ''' + @DivisionID +'''  
Group by TypeID, DivisionID, OrderID  
-------Having sum(case when RemainQuantity <0 then 0 else RemainQuantity end) = 0'  
  
If exists (SELECT Top 1 1 From sysObjects Where XType = 'V'  and Name = 'OV5001')  
  EXEC('Alter view OV5001 ---tao boi OP5001  
      as ' + @sSQL)  
else  
  EXEC('Create view OV5001 ---tao boi OP5001  
      as ' + @sSQL)  
  
Set @sSQL = 'Select TypeID, DivisionID, OrderID, sum(isnull(ActualQuantity,0)) as ActualQuantity,  
 sum(case when RemainQuantity <0 then 0 else RemainQuantity end) as RemainQuantity  
From OV5102 where DivisionID  = ''' + @DivisionID +'''  
Group by TypeID, DivisionID, OrderID'  
  
If exists (SELECT Top 1 1 From sysObjects Where XType = 'V'  and Name = 'OV5002')  
  EXEC('Alter view OV5002 ---tao boi OP5001  
      as ' + @sSQL)  
else   
  EXEC('Create view OV5002 ---tao boi OP5001  
      as ' + @sSQL)  
  
Set @sSQL = 'Select TypeID, DivisionID, OrderID, sum(isnull(ActualQuantity,0)) as ActualQuantity,  
 sum(case when RemainQuantity <0 then 0 else RemainQuantity end) as RemainQuantity  
From OV5103 where DivisionID  = ''' + @DivisionID +'''  
Group by TypeID, DivisionID, OrderID'  
  
If exists (SELECT Top 1 1 From sysObjects Where XType = 'V'  and Name = 'OV5003')  
  EXEC('Alter view OV5003 ---tao boi OP5001  
      as ' + @sSQL)  
else   
  EXEC('Create view OV5003 ---tao boi OP5001  
      as ' + @sSQL)  
  
  
 -- CAp nhat tinh trang don hang  
  
  
-- CAp nhat tinh trang don hang bán  
Update OT2001 Set OrderStatus =    
Case When (ISNULL( RemainQuantity,0) > 0  and   isnull (ActualQuantity,0)= 0) Then 1 -- Chap Nhan  
Else   
Case When (ISNULL( RemainQuantity,0) > 0 and   isnull (ActualQuantity,0) >0) Then 2 -- Dang Giao Hang  
Else  
Case When (ISNULL( RemainQuantity,0) = 0) Then 3 -- Da Hoan Tat  
Else OrderStatus  
End  
End  
End  
From OT2001 T00 inner join OV5001 V00 on T00.SOrderID = V00.OrderID and T00.DivisionID = V00.DivisionID  
where T00.DivisionID  = @DivisionID  
and T00.OrderType = 0  
  
-- CAp nhat tinh trang don hang sản xuất  
--Rem by Dang Le Bao Quynh; 22/11/2012
/*
Update OT2001 Set OrderStatus =    
--Case When (ISNULL( RemainQuantity,0) > 0  and   isnull (ActualQuantity,0)= 0) Then 0 -- Chưa sản xuất  
--Else   
Case When (ISNULL( RemainQuantity,0) > 0 and   isnull (ActualQuantity,0) >0) Then 1 -- Dang sản xuất  
Else  
Case When (ISNULL( RemainQuantity,0) = 0) Then 2 -- Da Hoan Tat  
Else OrderStatus  
--End  
End  
End  
From OT2001 T00 inner join OV5001 V00 on T00.SOrderID = V00.OrderID and T00.DivisionID = V00.DivisionID  
where T00.DivisionID  = @DivisionID  
and T00.OrderType = 1  
*/
-- Add new Dang Le Bao Quynh; 22/11/2012
Update OT2001 Set OrderStatus = 2 Where SOrderID not In 
(
	Select SOrderID From
	(
	Select OT2002.DivisionID, OT2002.SOrderID, OT2002.OrderQuantity, TransactionID From OT2002 Inner Join OT2001 
	On OT2002.SOrderID = OT2001.SOrderID
	Where OrderType=1 And TranMonth + 12*TranYear<=@TranMonth+12*@TranYear
	) O
	Left Join 
	(Select MT1001.DivisionID, OTransactionID, sum(isnull(Quantity,0)) As MQuantity From MT0810 Inner Join MT1001 On MT0810.DivisionID = MT1001.DivisionID And MT0810.VoucherID = MT1001.VoucherID
	Where ResultTypeID = 'R01'
	Group By MT1001.DivisionID, OTransactionID) M
	ON O.DivisionID = M.DivisionID And O.TransactionID = M.OTransactionID
	Where O.OrderQuantity - Isnull(M.MQuantity,0)>0
) And OrderType=1 And TranMonth + TranYear<=@TranMonth+12*@TranYear

Update OT2001 Set OrderStatus = 1 Where SOrderID In 
(
	Select SOrderID From
	(
	Select OT2002.DivisionID, OT2002.SOrderID, OT2002.OrderQuantity, TransactionID From OT2002 Inner Join OT2001 
	On OT2002.SOrderID = OT2001.SOrderID
	Where OrderType=1 And TranMonth + 12*TranYear<=@TranMonth+12*@TranYear
	) O
	Inner Join 
	(Select MT1001.DivisionID, OTransactionID, sum(isnull(Quantity,0)) As MQuantity From MT0810 Inner Join MT1001 On MT0810.DivisionID = MT1001.DivisionID And MT0810.VoucherID = MT1001.VoucherID
	Where ResultTypeID = 'R01'
	Group By MT1001.DivisionID, OTransactionID) M
	ON O.DivisionID = M.DivisionID And O.TransactionID = M.OTransactionID
	Where O.OrderQuantity - Isnull(M.MQuantity,0)>0
) And OrderType=1 And TranMonth + TranYear<=@TranMonth+12*@TranYear
--------------------------------------------------------------------

/*  
Update OT2001 Set OrderStatus =  3 -- Da Hoan Tat  
From OT2001 T00 inner join OV5001 V00 on T00.SOrderID = V00.OrderID  and V00.TypeID = 'SO'  WHERE ISNULL( RemainQuantity,0) = 0  
  
Update OT2001 Set OrderStatus =  2 -- Dang giao hang  
From OT2001 T00 inner join OV5001 V00 on T00.SOrderID = V00.OrderID  and V00.TypeID = 'SO'  WHERE ISNULL( RemainQuantity,0) > 0 and   isnull (ActualQuantity,0) >0    
  
  
Update OT2001 Set OrderStatus =  1 -- Chap nhan  
From OT2001 T00 inner join OV5001 V00 on T00.SOrderID = V00.OrderID  and V00.TypeID = 'SO' WHERE ISNULL( RemainQuantity,0) > 0  and   isnull (ActualQuantity,0)= 0   
*/  
  
-- CAp nhat tinh trang don hang mua, giống đơn hàng bán  
Update OT3001 Set OrderStatus =    
Case When (ISNULL( RemainQuantity,0) > 0  and   isnull (ActualQuantity,0)= 0) Then 1 -- Chap Nhan  
Else   
Case When (ISNULL( RemainQuantity,0) > 0 and   isnull (ActualQuantity,0) >0) Then 2 -- Dang Giao Hang  
Else  
Case When (ISNULL( RemainQuantity,0) = 0) Then 3 -- Da Hoan Tat  
Else OrderStatus  
End  
End  
End  
From OT3001 T00 inner join OV5002 V00 on T00.POrderID = V00.OrderID and T00.DivisionID = V00.DivisionID  
where T00.DivisionID  = @DivisionID  
  
  
/*  
Update OT3001 Set OrderStatus =  3  
From OT3001 T00 inner join OV5002 V00 on T00.POrderID = V00.OrderID where ISNULL( RemainQuantity,0) = 0  
*/  
Update OT2201 Set OrderStatus =  2  
From OT2201 T00 inner join OV5003 V00 on T00.EstimateID = V00.OrderID and T00.DivisionID = V00.DivisionID   
Where  ISNULL( RemainQuantity,0) = 0  
and T00.DivisionID  = @DivisionID  