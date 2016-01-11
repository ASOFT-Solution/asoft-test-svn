
/****** Object:  StoredProcedure [dbo].[MP2006]    Script Date: 08/02/2010 09:39:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 11/11/2004
---purpose: In Bao cao Bang tong hop tinh hinh san xuat
 
 /********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[MP2006] @DivisionID nvarchar(50),						
				@InventoryID nvarchar(50),
				@LinkNo nvarchar(50),
				@FromMonth int,
				@FromYear int,
				@ToMonth int,
				@ToYear int
		
AS
Declare @sSQL1 nvarchar(4000),
		@sSQL2 nvarchar(4000),
		@cur as cursor,
		@OrderNo nvarchar(50),
		@OrderDate datetime

--Lay ngay  trien khai san xuat  (la ngay san xuat dau tien va ngay yeu cau hoan thanh ( ngay san xuat cuoi cung) trong ke hoach san xuat
Set @sSQL1 =  'Select  T00.PlanID, InventoryID ,  LinkNo, T00.DivisionID,
	case when  isnull(Quantity40, 0) <> 0 then Date40 
	else 	 case when  isnull(Quantity39, 0) <> 0 then Date39 
	else 	 case when  isnull(Quantity38, 0) <> 0 then Date38 
	else 	 case when  isnull(Quantity37, 0) <> 0 then Date37 
	else 	 case when  isnull(Quantity36, 0) <> 0 then Date36 
	else 	 case when  isnull(Quantity35, 0) <> 0 then Date35 
	else 	 case when  isnull(Quantity34, 0) <> 0 then Date34 
	else 	 case when  isnull(Quantity33, 0) <> 0 then Date33 
	else 	 case when  isnull(Quantity32, 0) <> 0 then Date32 
	else 	 case when  isnull(Quantity31, 0) <> 0 then Date31 
	end end end end  end end  end end  end end 
	as EndDate,
	case when 	 isnull(Quantity01, 0) <> 0 then Date01 
	else 	 case when  isnull(Quantity02, 0) <> 0 then Date02 
	else 	 case when  isnull(Quantity03, 0) <> 0 then Date03 
	else 	 case when  isnull(Quantity04, 0) <> 0 then Date04 
	else 	 case when  isnull(Quantity05, 0) <> 0 then Date05 
	else 	 case when  isnull(Quantity06, 0) <> 0 then Date06 
	else 	 case when  isnull(Quantity07, 0) <> 0 then Date07 
	else 	 case when  isnull(Quantity08, 0) <> 0 then Date08 
	else 	 case when  isnull(Quantity09, 0) <> 0 then Date09 
	else 	 case when  isnull(Quantity10, 0) <> 0 then Date10
	end end end end  end end  end end  end end 
	as BeginDate
From MT2002 T00 inner join MT2003 T01 on T00.PlanID =  T01.PlanID 
	inner join MT2001 T02 on T02.PlanID = T00.PlanID 
Where  	T00.LinkNo = ''' + @LinkNo + '''  and T02.DivisionID = ''' + @DivisionID + '''
Union
Select  T00.PlanID, T00.DivisionID, InventoryID ,     LinkNo, 
	case when  isnull(Quantity30, 0) <> 0 then Date30 
	else 	 case when  isnull(Quantity29, 0) <> 0 then Date29 
	else 	 case when  isnull(Quantity28, 0) <> 0 then Date28 
	else 	 case when  isnull(Quantity27, 0) <> 0 then Date27 
	else 	 case when  isnull(Quantity26, 0) <> 0 then Date26 
	else 	 case when  isnull(Quantity25, 0) <> 0 then Date25 
	else 	 case when  isnull(Quantity24, 0) <> 0 then Date24 
	else 	 case when  isnull(Quantity23, 0) <> 0 then Date23 
	else 	 case when  isnull(Quantity22, 0) <> 0 then Date22 
	else 	 case when  isnull(Quantity21, 0) <> 0 then Date21 
	end end end end  end end  end end  end end 
	as EndDate,
	case when  isnull(Quantity11, 0) <> 0 then Date11 
	else 	 case when  isnull(Quantity12, 0) <> 0 then Date12 	
	else 	 case when  isnull(Quantity13, 0) <> 0 then Date13 
	else 	 case when  isnull(Quantity14, 0) <> 0 then Date14 
	else 	 case when  isnull(Quantity15, 0) <> 0 then Date15 
	else 	 case when  isnull(Quantity16, 0) <> 0 then Date16 
	else 	 case when  isnull(Quantity17, 0) <> 0 then Date17 
	else 	 case when  isnull(Quantity18, 0) <> 0 then Date18 
	else 	 case when  isnull(Quantity19, 0) <> 0 then Date19 
	else 	 case when  isnull(Quantity20, 0) <> 0 then Date20 
	end end	 end end  end end  end end  end end 
	as BeginDate
From MT2002 T00 inner join MT2003 T01 on T00.PlanID =  T01.PlanID 
		inner join MT2001 T02 on T02.PlanID = T00.PlanID 
Where  	T00.LinkNo = ''' + @LinkNo + '''  and T02.DivisionID = ''' + @DivisionID + '''
Union'
Set @sSQL1 = 'Select  T00.PlanID,T00.DivisionID, InventoryID,   LinkNo, 
	case when  isnull(Quantity20, 0) <> 0 then Date20
	else 	case when  isnull(Quantity19, 0) <> 0 then Date19
	else 	 case when  isnull(Quantity18, 0) <> 0 then Date18
	else 	 case when  isnull(Quantity17, 0) <> 0 then Date17 
	else 	 case when  isnull(Quantity16, 0) <> 0 then Date16 
	else 	 case when  isnull(Quantity15, 0) <> 0 then Date15 
	else 	 case when  isnull(Quantity14, 0) <> 0 then Date14 
	else 	 case when  isnull(Quantity13, 0) <> 0 then Date13
	else 	 case when  isnull(Quantity12, 0) <> 0 then Date12
	else 	 case when  isnull(Quantity11, 0) <> 0 then Date11  
	end end end end  end end  end end  end end 
	as EndDate,
	case when  isnull(Quantity21, 0) <> 0 then Date21
	else 	 case when  isnull(Quantity22, 0) <> 0 then Date22
	else 	 case when  isnull(Quantity23, 0) <> 0 then Date23 
	else 	 case when  isnull(Quantity24, 0) <> 0 then Date24 
	else 	 case when  isnull(Quantity25, 0) <> 0 then Date25 
	else 	 case when  isnull(Quantity26, 0) <> 0 then Date26 
	else 	 case when  isnull(Quantity27, 0) <> 0 then Date27 
	else 	 case when  isnull(Quantity28, 0) <> 0 then Date28 
	else 	 case when  isnull(Quantity29, 0) <> 0 then Date29 
	else 	 case when  isnull(Quantity30, 0) <> 0 then Date30 
	end end end end  end end  end end  end end 
	as BeginDate
From MT2002 T00 inner join MT2003 T01 on T00.PlanID =  T01.PlanID 
		inner join MT2001 T02 on T02.PlanID = T00.PlanID 
Where  	T00.LinkNo = ''' + @LinkNo + '''  and T02.DivisionID = ''' + @DivisionID + '''
Union
Select  T00.PlanID, InventoryID,T00.DivisionID,   LinkNo, 
	case when  isnull(Quantity10, 0) <> 0 then Date10 
	else 	 case when  isnull(Quantity09, 0) <> 0 then Date09 
	else 	 case when  isnull(Quantity08, 0) <> 0 then Date08 
	else 	 case when  isnull(Quantity07, 0) <> 0 then Date07 
	else 	 case when  isnull(Quantity06, 0) <> 0 then Date06 
	else 	 case when  isnull(Quantity05, 0) <> 0 then Date05 
	else 	 case when  isnull(Quantity04, 0) <> 0 then Date04 
	else 	 case when  isnull(Quantity03, 0) <> 0 then Date03 
	else 	 case when  isnull(Quantity02, 0) <> 0 then Date02 
	else 	 case when  isnull(Quantity01, 0) <> 0 then Date01 
	end end end end  end end  end end  end end 
	as EndDate,
	case when  isnull(Quantity31, 0) <> 0 then Date31 
	else 	 case when  isnull(Quantity32, 0) <> 0 then Date32
	else 	 case when  isnull(Quantity33, 0) <> 0 then Date33 
	else 	 case when  isnull(Quantity34, 0) <> 0 then Date34 
	else 	 case when  isnull(Quantity35, 0) <> 0 then Date35 
	else 	 case when  isnull(Quantity36, 0) <> 0 then Date36 
	else 	 case when  isnull(Quantity37, 0) <> 0 then Date37 
	else 	 case when  isnull(Quantity38, 0) <> 0 then Date38 
	else 	 case when  isnull(Quantity39, 0) <> 0 then Date39 
	else 	 case when  isnull(Quantity40, 0) <> 0 then Date40 
	end end end end  end end  end end  end end 
	as BeginDate
From MT2002 T00 inner join MT2003 T01 on T00.PlanID =  T01.PlanID 
		inner join MT2001 T02 on T02.PlanID = T00.PlanID 
Where  	T00.LinkNo = ''' + @LinkNo + '''  and  T02.DivisionID = ''' + @DivisionID + ''''

If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV2105') 
	Drop view MV2105
EXEC('Create view MV2105 ---tao boi MP2006
		as ' + @sSQL1 + @sSQL2)

---Tinh hinh thuc hien
Set @sSQL1 = 'Select M00.PlanID, M01.VoucherNo , M01.VoucherDate , M00.DivisionID, M00.InventoryID , DepartmentName,	
			sum(isnull(ActualQuantity, 0)) as ActualQuantity, max(isnull(M00.Description, '''')) as Description
		From MT2005 M00 inner join MT2004 M01 on M00.VoucherID = M01.VoucherID
			left join MT2001 M02 on M02.PlanID = M00.PlanID			
			left join AT1102 A02 on A02.DepartmentID = M01.DepartmentID And 	A02.DivisionID = M01.DivisionID
		Where LinkNo = ''' + @LinkNo + ''' and M01.DivisionID = ''' + @DivisionID + '''
		Group by M00.PlanID, M01.VoucherNo, M01.VoucherDate, M00.InventoryID,   DepartmentName, M00.DivisionID'

If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV2101') 
	Drop view MV2101
EXEC('Create view MV2101 ---tao boi MP2006
		as ' + @sSQL1)

Set @sSQL1 =  'Select M00.PlanID, M01.VoucherNo , M01.VoucherDate, M00.DivisionID,		M00.Notes as Description, 
		O00.VoucherNo  as OrderNo, O00.OrderDate,
		O00.ObjectID, case when isnull(O00.ObjectName, '''') = '''' then A03.ObjectName else O00.ObjectName end as ObjectName,	
		M01.DepartmentID, DepartmentName, M03.BeginDate, M03.EndDate, 
		case when M00.InventoryID = ''' + @InventoryID + ''' then 2 else 1 end as Orders, 
		M00.InventoryID, A00.InventoryName, UnitName, sum(M00.PlanQuantity) as PlanQuantity, sum(ActualQuantity) as  ActualQuantity,
		Max(ActualDate) as MaxActualDate
	From MT2002 M00 inner join MT2001 M01 on M00.PlanID = M01.PlanID		
		left join AT1102 A02 on A02.DepartmentID = M01.DepartmentID	
		left join OT2001 O00 on O00.SOrderID = M01.SOderID 
		left join AT1202 A03 on A03.ObjectID = O00.ObjectID	  
		left join		 (Select PlanID, InventoryID, Max(VoucherDate) as ActualDate, sum(ActualQuantity) as ActualQuantity	
		From MV2101
	Group by PlanID, InventoryID, M00.DivisionID)	 V00 on	 V00.PlanID = M01.PlanID and V00.InventoryID = M00.InventoryID	
		inner join AT1302 A00 on M00.InventoryID = A00.InventoryID
		left join AT1304 A01 on A01.UnitID = A00.UnitID 
		left join (Select  PlanID, InventoryID,   LinkNo, Min(BeginDate)  as BeginDate, Max(EndDate) as EndDate From MV2105 
			Group by PlanID, InventoryID,   LinkNo) 
			M03 on M03.LinkNo  = M00.LinkNo and M03.InventoryID = M00.InventoryID and M03.PlanID = M00.PlanID
	Where M00.LinkNo = ''' + @LinkNo + '''  and M00.DivisionID = ''' + @DivisionID + '''
	Group by 	M00.PlanID, M01.VoucherNo , M01.VoucherDate, M00.DivisionID,		
		O00.VoucherNo, M00.Notes,  O00.OrderDate,	O00.ObjectID, A03.ObjectName, O00.ObjectName ,
		M01.DepartmentID, DepartmentName, M03.BeginDate, M03.EndDate, 		
		M00.InventoryID, A00.InventoryName, UnitName '

If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV2102') 
	Drop view MV2102
EXEC('Create view MV2102 ---tao boi MP2006
		as ' + @sSQL1)

Set @sSQL1 = 'Select PlanID, A00.DivisionID, VoucherNo, VoucherDate, V00.InventoryID,  A00.InventoryName,  A01.UnitName, 
		case when V00.inventoryID = ''' + @InventoryID + ''' then 2 else 1 end as Orders,
		V00.ActualQuantity, V00.Description, DepartmentName
	From MV2101 V00 inner join AT1302  A00  on V00.InventoryID =  A00.InventoryID
			left join AT1304 A01 on A01.UnitID = A00.UnitID' 


If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV2103') 
	Drop view MV2103
EXEC('Create view MV2103 ---tao boi MP2006
		as ' + @sSQL1)

Set @sSQL1 = 'Select ''' + @LinkNo + ''' as LinkNo, '''' as VoucherNo, '''' as VoucherDate,  '''' as ABeginDate, '''' as AEndDate,  DepartmentName, 
			InventoryID, InventoryName, UnitName, PlanQuantity, 0  as ActualQuantity, MV2102.DivisionID,
			1 as Parts, 0 as Orders, '''' as Description, OrderNo, OrderDate, ObjectID,  ObjectName, BeginDate, NULL as EndDate,
			MaxActualDate
		From MV2102
		Where InventoryID = ''' + @InventoryID + '''
		Union
		Select Top 1   ''' + @LinkNo + ''' as LinkNo, '''' as VoucherNo, '''' as VoucherDate,  '''' as ABeginDate,
			 '''' as AEndDate, '''' as DepartmentName, 	'''' as InventoryID, '''' as InventoryName, '''' as UnitName, 
			0 as PlanQuantity, 0  as ActualQuantity, 2 as Parts, 0 as Orders, '''' as Description, V00.VoucherNo as OrderNo, 
			M00.DivisionID,
			V00.OrderDate, O02.ObjectID,  case when isnull(O02.ObjectName, '''') = '''' then A03.ObjectName else O02.ObjectName end as ObjectName, 
			M00.BeginDate, NULL as EndDate, '''' as MaxActualDate
		From MT2001 M00 left join OV1003 V00 on V00.OrderID = M00.SOderID and V00.Type = ''SO''
			inner join MT2002 M01 on M00.PlanID = M01.PlanID
			left join OT2001 O02 on O02.SOrderID = M00.SOderID 
			left join AT1202 A03 on A03.ObjectID = O02.ObjectID	
		Where M01.LinkNo = ''' + @LinkNo + '''  
		Union 
		Select  ''' + @LinkNo + ''' as LinkNo, VoucherNo, VoucherDate, NULL as ABeginDate, EndDate as AEndDate, DepartmentName, 
			InventoryID, Inventoryname, UnitName, PlanQuantity, ActualQuantity, 3 as Parts, Orders, '''' as Description,
			MV2102.DivisionID,
			OrderNo, OrderDate, ObjectID,  ObjectName,   BeginDate, EndDate, MaxActualDate
		From MV2102 
		Union
		Select  '''' as LinkNo, '''' as VoucherNo, '''' as VoucherDate,  '''' as ABeginDate, '''' as AEndDate, '''' as DepartmentName, '''' as InventoryID, 
			''''  as InventoryName, 	'''' as UnitName, 0 as PlanQuantity, 0 as ActualQuantity, 4 as Parts, 0 as Orders, '''' as Description,
			'''' as OrderNo, '''' as OrderDate, '''' as ObjectID, '''' as  ObjectName, NULL as BeginDate, NULL as EndDate,  '''' as MaxActualDate
		Union
		Select  ''' + @LinkNo + ''' as LinkNo, VoucherNo, VoucherDate,  '''' as ABeginDate, '''' as AEndDate,  DepartmentName, 
			 InventoryID, Inventoryname, UnitName, 0 as PlanQuantity, ActualQuantity, 5 as Parts, Orders, Description,
			 MV2103.DivisionID,
			 '''' as OrderNo, '''' as OrderDate, '''' as ObjectID, '''' as ObjectName, NULL as BeginDate, NULL as EndDate,  '''' as MaxActualDate
		From MV2103'

If exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV2104') 
	Drop view MV2104
EXEC('Create view MV2104 ---tao boi MP2006
		as ' + @sSQL1)