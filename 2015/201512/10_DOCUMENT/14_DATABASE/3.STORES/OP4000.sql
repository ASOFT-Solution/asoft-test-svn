/****** Object:  StoredProcedure [dbo].[OP4000]    Script Date: 12/20/2010 14:42:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Created by: Vo Thanh Huong, date: 13/09/2004
---purpose: Tinh du toan don hang
/********************************************
'* Edited by: [GS] [Thành Nguyên] [04/08/2010]
'********************************************/

ALTER PROCEDURE [dbo].[OP4000] @SOrderID nvarchar(50),
				@DivisionID nvarchar(50)												
AS
Declare @sSQL as nvarchar(4000),
	@TranMonth int,
	@TranYear int,	
	@cur cursor,
	@PrimeCost decimal(28,8),
	@Sales decimal(28,8),
	@DiscountAmount decimal(28,8),
	@OthersCost decimal(28,8),
	@CostID nvarchar(50),
	@TransactionID nvarchar(50),
	@InventoryID nvarchar(50),
	@Description nvarchar(250)

Select  @TranMonth = TranMonth, @TranYear =  TranYear
From OV1003
Where DivisionID = @DivisionID and OrderID = @SOrderID 

---Xac dinh gia von
Set @sSQL = '
Select 
		DivisionID,
		InventoryID, 
		Case When (Sum(isnull(BeginQuantity, 0) + isnull(DebitQuantity, 0) )<>0) 
		Then	
			sum(isnull(BeginAmount, 0) + isnull(DebitAmount, 0)) /sum(isnull(BeginQuantity, 0) + isnull(DebitQuantity, 0)) 
		Else 
		0 
		End AS UnitPrice 
From AT2008 
Where DivisionID = N''' + @DivisionID  + ''' and
		TranMonth = ' + cast(isnull(@TranMonth,0) as varchar(2)) + ' and 
		TranYear = ' + cast(isnull(@TranYear,0) as varchar(4)) + ' and 
		InventoryID in (Select Distinct InventoryID From OT2002  Where SOrderID = N''' + @SOrderID + ''' )
Group by DivisionID, InventoryID'

If  exists(Select 1 From sysObjects Where XType = 'V' and Name =  'OV4000')
	exec('Alter view OV4000  ---tao boi OP4000 
			as ' + @sSQL)
else 
	exec('Create view OV4000  ---tao boi OP4000 
			as ' + @sSQL)

----Xac dinh chi tiet doanh thu, chi phi cho tung mat hang
Set @sSQL='
Select 
		O01.DivisionID,
		Orders, NULL as CostID, O01.InventoryID, '''' as Description, 
		A01.InventoryName as Description0, 
		case when isnull(ConvertedAmount,0)= 0 then NULL else ConvertedAmount end  as Sales, 
		case when isnull(O01.DiscountConvertedAmount, 0) = 0 then NULL else  O01.DiscountConvertedAmount end as DiscountAmount,
		case when isnull(O01.CommissionCAmount, 0) = 0 then NULL else O01.CommissionCAmount end as CommissionAmount,
		case when isnull(O01.OrderQuantity, 0) = 0 then NULL else  O01.OrderQuantity end  as OrderQuantity,
		case when isnull(V01.UnitPrice, 0) =0 then NULL else (O01.OrderQuantity * isnull(V01.UnitPrice, 0) ) end PrimeCost, NULL as OthersCost    
	From OT2002 O01 left  join OV4000 V01 on O01.InventoryID = V01.InventoryID and O01.DivisionID = V01.DivisionID
			inner join AT1302 A01 on A01.InventoryID = O01.InventoryID and A01.DivisionID = O01.DivisionID
	Where SOrderID =  N''' + @SOrderID + ''' 
	Union 
------ Xac dinh chi phi bo sung
Select 
		O01.DivisionID,
		O01.Orders, O01.CostID, NULL as InventoryID, '''' as Description, 
		CostName as Description0,		
		NULL as Sales, NULL as DiscountAmount,
		NULL as CommissionAmount,
		NULL as OrderQuantity, NULL as PrimeCost,  Amount as OthersCost
	From OT2004 O01	inner join OT1004 O02 on O02.CostID = O01.CostID and O02.DivisionID = O01.DivisionID
	Where SOrderID = N''' + @SOrderID  + ''''

If  exists (Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV4002')
	EXEC('Alter view OV4002 ---tao boi OP4000 
			as ' + @sSQL)
else 
	EXEC('Create view OV4002 ---tao boi OP4000 
			as ' + @sSQL)

Set @sSQL = 'Select DivisionID, N''' + @SOrderID + ''' as SOrderID, ' +  cast(isnull(@TranMonth,0) as varchar(2)) + ' as TranMonth, ' +
			 cast(isnull(@TranYear,0) as varchar(4)) + ' as TranYear,
			case when sum(isnull(Sales,0)) = 0 then NULL else  sum(isnull(Sales, 0)) end as Sales, 
			case when sum(isnull(DiscountAmount, 0)) = 0 then NULL else sum(isnull(DiscountAmount, 0)) end  as DiscountAmount,
			case when sum(isnull(CommissionAmount, 0)) = 0 then NULL else sum(isnull(CommissionAmount, 0)) end  as CommissionAmount,
			case when sum(isnull(PrimeCost, 0 )) = 0 then NULL else sum(isnull(PrimeCost, 0)) end  as PrimeCost, 
			case when sum(isnull(OthersCost, 0)) = 0 then NULL else sum(isnull(OthersCost, 0)) end  as OthersCost
		From OV4002
		GROUP BY DivisionID'

If exists(Select Top 1 1 From sysObjects Where XType = 'V' and Name = 'OV4001')
	EXEC('Alter view OV4001 ---tao boi OP4000
		as ' + @sSQL)
else
	EXEC('Create view OV4001 ---tao boi OP4000
		as ' + @sSQL)
