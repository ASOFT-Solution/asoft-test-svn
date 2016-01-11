
/****** Object:  StoredProcedure [dbo].[OP2301]    Script Date: 08/02/2010 10:29:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


--VAN HUNG
---- Created by Vo Thanh Huong
---- Date 12/12/2005
---- Purpose: Loc ra cac PHIEU DIEU DO SAN XUAT BAO BI IN CHO MAN HINH TRUY VAN 
/********************************************
'* Edited by: [GS] [Tố Oanh] [02/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP2301] @DivisionID nvarchar(50),
                                                     @FromMonth int,
			             @FromYear int,
				@ToMonth int,
				@ToYear int  
				
AS
Declare @sSQL1 as nvarchar(4000),
	@sSQL2 as nvarchar(4000)

----- Buoc  1 : Tra ra thong tin Master View OV2301


	Set @sSQL1 = ' 
		Select  OT2001.*,
		InventoryTypeName, CurrencyName, 	
		AT1102.DepartmentName, 
		AT1103.FullName,  
	             OV1001.Description as OrderStatusName, 
 		OV1002.Description as OrderTypeName		
	From OT2001 left join AT1202 on AT1202.ObjectID = OT2001.ObjectID
		left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID 
		left join AT1004 on AT1004.CurrencyID = OT2001.CurrencyID
		left join AT1103 on AT1103.EmployeeID = OT2001.EmployeeID and AT1103.DivisionID = OT2001.DivisionID 
		left join AT1103 AT1103_2 on AT1103_2.EmployeeID = OT2001.EmployeeID and AT1103_2.DivisionID = OT2001.DivisionID 
		left join AT1102 on AT1102.DepartmentID = OT2001.DepartmentID  and AT1102.DivisionID = OT2001.DivisionID
		left join OV1001 on OV1001.OrderStatus = OT2001.OrderStatus and OV1001.TypeID = case when OT2001.OrderType = 1 then ''MO'' else '''' end									
		left join OV1002 on OV1002.OrderType = OT2001.OrderType and OV1002.TypeID =''SO'' 
             Where OT2001.DivisionID = ''' + @DivisionID + ''' and 
		OT2001.TranYear*100 + TranMonth between ' + 
		cast(@FromMonth + @FromYear*100 as nvarchar(20)) + ' and ' +  cast(@ToMonth + @ToYear*100 as nvarchar(20))  + ' and 
		OT2001.OrderType = 1 and OT2001.FileType = 1 '


---- Buoc  2 : Tra ra thong tin Detail View OV2311

Set @sSQL2= '
Select OT2002.* , 
		OT2002_Ref.OrderQuantity as SOrderQuantity,
		OT2001_Ref.ObjectID,
		AT1302.InventoryName, 	UnitName,		
		OT1305.FileNo,
		OT1305.UnitPrice, 
		OT1305.Var01, 
		OT1305.Var02, 
		OT1305.Var03,
		OT1305.Var04, 
		OT1305.Var05, 
		OT1305.Var06, 
		OT1305.Var07, 
		OT1305.Var08, 
		OT1305.Var09, 
		OT1305.Var10, 
		OT1305.Date01, 
		OT1305.Num01, 
		OT1305.Num02, 
		OT1305.Num03, 
		OT1305.Num04, 
		OT1305.Num05, 
		OT1305.Num06, 
		OT1305.Num07, 
		OT1305.Num08, 
		OT1305.Num09, 
		OT1305.Num10, 
		OT1305.Num11, 
		OT1305.Num12, 
		OT1305.Num13, 
		OT1305.Num14, 
		OT1305.Num15

From OT2002 left join AT1302 on AT1302.InventoryID= OT2002.InventoryID		
		inner join OT2001 on OT2001.SOrderID = OT2002.SOrderID
		left join OT2001 OT2001_Ref on OT2001_Ref.SOrderID = OT2002.RefOrderID
		left join OT2002 OT2002_Ref on OT2002.RefOrderID = OT2002_Ref.SOrderID and OT2002_Ref.InventoryID = OT2002.InventoryID
		left join AT1301 on AT1301.InventoryTypeID = OT2001.InventoryTypeID 	
		left join AT1304 on AT1304.UnitID = OT2002.UnitID
		left join OT1305 on OT1305.FileID = OT2002.FileID  and OT1305.ProductID = OT2002.InventoryID
          Where OT2001.DivisionID = ''' + @DivisionID + ''' and 
		OT2001.TranYear*100 + OT2001.TranMonth between ' + 
		cast(@FromMonth + @FromYear*100 as nvarchar(20)) + ' and ' +  cast(@ToMonth + @ToYear*100 as nvarchar(20))  + ' and 
		OT2001.OrderType = 1  and OT2001.FileType = 1'


If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV2301')
	Exec('Create View OV2301 ---tao boi OP2301
		 as '+@sSQL1)
Else
	Exec('Alter View OV2301 ---tao boi OP2301
		 as '+@sSQL1)


If not Exists (Select 1 From SysObjects Where Xtype ='V' and Name = 'OV2311')
	Exec('Create View OV2311  --tao boi OP2301
		as '+@sSQL2)
Else
	Exec('Alter View OV2311  --- tao boi OP2301
		as '+@sSQL2)