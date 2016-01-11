
/****** Object:  StoredProcedure [dbo].[MP2401]    Script Date: 08/02/2010 10:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

---Created by: Vo Thanh Huong, date: 25/11/2004
---purpose: Ke thua cac thanh pham tu lenh san xuat
---Edit by: Nguyen Quoc Huy 31/12/2004

/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [02/08/2010]
'********************************************/
--- Modified by Tiểu Mai on 23/12/2015: Bổ sung thông tin quy cách khi có thiết lập

ALTER PROCEDURE [dbo].[MP2401]  @DivisionID nvarchar(50),
				@Type int,  --1- Ke thua tu lenh san xuat, 2- Ke thua tu don hang
				@lstInheritKeyID nvarchar(500)
AS
Declare @sSQL  nvarchar(4000)
IF EXISTS (SELECT 1 FROM AT0000 WHERE DefDivisionID = @DivisionID AND IsSpecificate = 1)
BEGIN
	IF @Type = 2
		Set @sSQL ='Select T00.InventoryID as ProductID, InventoryName as ProductName, T01.UnitID, OrderQuantity as ProductQuantity,
			'''' as LinkNo, Description, T00.Orders	, T00.DivisionID,
			O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID		 
		From OT2002 T00 inner join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID
			inner join OT2001 T02 on T02.SOrderID = T00.SOrderID  and T00.DivisionID = T02.DivisionID
			left join OT8899 O99 on O99.DivisionID = T00.DivisionID and O99.VoucherID = T00.SOrderID and O99.TransactionID = T00.TransactionID and O99.TableID = ''OT2002''
		Where T02.DivisionID = ''' + @DivisionID + ''' and T00.SOrderID = ''' + @lstInheritKeyID + ''''
	else
		If @Type = 1
		Set @sSQL ='Select T00.InventoryID as ProductID, InventoryName as ProductName, T01.UnitID, PlanQuantity as ProductQuantity,
			T05. LinkNo,  Notes as Description , T00.Orders, T00.DivisionID,
			O99.S01ID, O99.S02ID, O99.S03ID, O99.S04ID, O99.S05ID, O99.S06ID, O99.S07ID, O99.S08ID, O99.S09ID, O99.S10ID,
			O99.S11ID, O99.S12ID, O99.S13ID, O99.S14ID, O99.S15ID, O99.S16ID, O99.S17ID, O99.S18ID, O99.S19ID, O99.S20ID		 
		From MT2002 T00 inner join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID
					left join MT8899 O99 on O99.DivisionID = T00.DivisionID and O99.VoucherID = T00.PlanID and O99.TransactionID = T00.PlanDetailID and O99.TableID = ''MT2002''
					Left join MT2005 T05 on T00.InventoryID = T05.InventoryID and T00.DivisionID = T05.DivisionID and T00.PlanID = T05.PlanID
		Where T00.DivisionID = ''' + @DivisionID + ''' and T00.PlanID = ''' + @lstInheritKeyID + ''''
	
END
ELSE
BEGIN
	IF @Type = 2
		Set @sSQL ='Select T00.InventoryID as ProductID, InventoryName as ProductName, T01.UnitID, OrderQuantity as ProductQuantity,
			'''' as LinkNo, Description, T00.Orders	, T00.DivisionID		 
		From OT2002 T00 inner join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID
			inner join OT2001 T02 on T02.SOrderID = T00.SOrderID  and T00.DivisionID = T02.DivisionID
		Where T02.DivisionID = ''' + @DivisionID + ''' and T00.SOrderID = ''' + @lstInheritKeyID + ''''
	else
		If @Type = 1
		Set @sSQL ='Select T00.InventoryID as ProductID, InventoryName as ProductName, T01.UnitID, PlanQuantity as ProductQuantity,
			T05. LinkNo,  Notes as Description , T00.Orders, T00.DivisionID		 
		From MT2002 T00 inner join AT1302 T01 on T00.InventoryID = T01.InventoryID and T00.DivisionID = T01.DivisionID
					Left join MT2005 T05 on T00.InventoryID = T05.InventoryID and T00.DivisionID = T05.DivisionID
		Where T00.DivisionID = ''' + @DivisionID + ''' and T00.PlanID = ''' + @lstInheritKeyID + ''''

END	
--PRINT @sSQL
If not exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'MV2401')
	EXEC('Create view MV2401 ----tao boi MP2401
			as ' + @sSQL)
Else	
	EXEC('Alter view MV2401 ----tao boi MP2401
			as ' + @sSQL)
			
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON			