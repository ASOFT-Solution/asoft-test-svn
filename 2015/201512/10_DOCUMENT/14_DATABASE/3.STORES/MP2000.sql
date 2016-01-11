/****** Object:  StoredProcedure [dbo].[MP2000]    Script Date: 07/30/2010 17:49:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--Created by Hoµng Thi Lan
--Date 5/12/2003
--Purpose :KiÓm tra khi xoa, sua Menu >Truy van
--Edit by Nguyen Quoc Huy, Date 1/3/2004
--Edit by Vo Thanh Huong, Date 25/06/2005
--Edit by Hoàng Vũ, Date 07/07/2015, Bổ sung thêm kiểm tra phiếu kết quả sản xuất tồn tại trong kết quả sản xuất
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [30/07/2010]
'********************************************/
 
ALTER PROCEDURE [dbo].[MP2000]  @VoucherID as nvarchar(50) ,
				 @TableID as nvarchar(50)

 AS
Declare @Status as tinyint,
		@Message as nvarchar(500)

--1. Chi phí dở dang đầu kỳ
Select @Status =0, @Message = ''
Set Nocount on

If @TableID = 'MT1612' 
	If Exists (Select Top 1 1 From  MT1612  Where VoucherID = @VoucherID )
	Begin 
	If Exists (Select Top 1 1 From MT1601  inner join  MT1612 on  MT1601.PeriodID = MT1612.PeriodID and  MT1612.VoucherID = @VoucherID
				Where  IsCost = 1 or IsInprocess =1 )
		Begin
			Set @Status = 2
			Set @Message = 'MFML000031'
		End
	Else
	
	If Not Exists (Select Top 1 1 From MT1601  inner join  MT1612 on  MT1601.PeriodID = MT1612.PeriodID and  MT1612.VoucherID = @VoucherID
				Where  IsCost = 1 or IsInprocess =1 )
		Begin
			Set @Status = 0
			Set @Message = 'MFML000032'
		End
	End

-- Đã làm ở Store MP1620

--2.Chi phí NVL TT
If @TableID = 'MV9000' 
	If Exists (Select Top 1 1 From MV9000 Where VoucherID = @VoucherID)
	Begin
	If Exists (Select Top 1 1 From MV9000	inner join MT1601 on MV9000.PeriodID = MT1601.PeriodID 
		and IsCost =1 --Da  tinh gia thanh SP
		 Where 	 MV9000.ExpenseID = 'COST001' And  MV9000.VoucherID = @VoucherID )
		Begin
			Set @Status = 2
			Set @Message = 'MFML000033'
		End
	Else
		
		If Exists (Select Top 1 1 From MT1601 inner join MV9000  on MV9000.PeriodID = MT1601.PeriodID  
						and MV9000.VoucherID = @VoucherID and 	 MV9000.ExpenseID = 'COST001' 
				Where MT1601.IsForPeriodID =1  )  --Da  tap hop chi phi
		Begin
			Set @Status = 1
			Set @Message = 'MFML000034'
		End
	Else 
		If Not Exists (Select Top 1 1 From MT1601 inner join MV9000  on MV9000.PeriodID = MT1601.PeriodID  
						and MV9000.VoucherID = @VoucherID and 	 MV9000.ExpenseID = 'COST001' 
				Where MT1601.IsForPeriodID =1  )  -- Da THCP
		Begin
			Set @Status = 0
			Set @Message = 'MFML000032'
		End
	End
	
	
--3.Chi phí NC TT
If @TableID = 'MV9000' 
	If Exists (Select Top 1 1 From MV9000 Where VoucherID = @VoucherID)
	Begin
	If Exists (Select Top 1 1 From MV9000	inner join MT1601 on MV9000.PeriodID = MT1601.PeriodID 
		and IsCost =1 --Da  tinh gia thanh SP
		 Where 	 MV9000.ExpenseID = 'COST002'  and VoucherID = @VoucherID)
		Begin
			Set @Status = 2
			Set @Message = 'MFML000035'
		End
	Else
		
		If Exists (Select Top 1 1 From MT1601 inner join MV9000  on MV9000.PeriodID = MT1601.PeriodID  
						and MV9000.VoucherID = @VoucherID and 	 MV9000.ExpenseID = 'COST002' 
				Where MT1601.IsForPeriodID =1  )  --§·  tËp hîp chi phÝ
		Begin
			Set @Status = 1
			Set @Message = 'MFML000034'
		End
	Else 
		If Not Exists (Select Top 1 1 From MT1601 inner join MV9000  on MV9000.PeriodID = MT1601.PeriodID  
						and MV9000.VoucherID = @VoucherID and 	 MV9000.ExpenseID = 'COST002' 
				Where MT1601.IsForPeriodID =1  )  --§·  tËp hîp chi phÝ
		Begin
			Set @Status = 0
			Set @Message = 'MFML000032'
		End
	End
	
--4.Chi phí SXC
If @TableID = 'MV9000' 
	If Exists (Select Top 1 1 From MV9000 Where VoucherID = @VoucherID)
	Begin
		If Exists (Select Top 1 1 From MV9000	inner join MT1601 on MV9000.PeriodID = MT1601.PeriodID 
			and IsCost =1 --Da tinh gia thanh SP
		 Where 	 MV9000.ExpenseID = 'COST003'  and VoucherID = @VoucherID)
		Begin
			Set @Status = 2
			Set @Message = 'MFML000035'
		End
	Else
		
		If Exists (Select Top 1 1 From MT1601 inner join MV9000  on MV9000.PeriodID = MT1601.PeriodID  
						and MV9000.VoucherID = @VoucherID and 	 MV9000.ExpenseID = 'COST003' 
				Where MT1601.IsForPeriodID =1  )  --Da tap hop chi phi
		Begin
			Set @Status = 1
			Set @Message = 'MFML000034'
		End
	Else 
		If Not Exists (Select Top 1 1 From MT1601 inner join MV9000  on MV9000.PeriodID = MT1601.PeriodID  
						and MV9000.VoucherID = @VoucherID and 	 MV9000.ExpenseID = 'COST003' 
				Where MT1601.IsForPeriodID =1  )  --Da tap hop chi phi
		Begin
			Set @Status = 0
			Set @Message = 'MFML000032'
		End
	End
	
--5.Kết quả sản xuất
	If @TableID = 'MT0810'
	If Exists (Select Top 1 1 From MT0810 Where VoucherID = @VoucherID)
	Begin
	If Exists (Select Top 1 1 From MT1601 inner join MT0810 on MT1601.PeriodID = MT0810.PeriodID and MT0810.VoucherID = @VoucherID
			Where MT1601.Iscost =1 )
	 
		Begin
			Set @Status = 2
			Set @Message = 'MFML000031'
		End
	Else 
	--Kiem tra AsoftT xem da xuat kho chua?
	If Exists(Select Top 1 1 From AT0114 inner join AT1302 on AT1302.InventoryID = AT0114.InventoryID 
		Where ReVoucherID = @VoucherID and DeQuantity <>0  and (MethodID = 3 Or IsSource = 1 or IsLimitDate =1)) 
		Begin
 			Set @Status = 2
			Set @Message = 'MFML000031'
		End 	
	Else  
	--Truong hợp là thành phẩm 'R01'
	If Exists (Select Top 1 1 From MT1601 inner join MT0810 on MT1601.PeriodID = MT0810.PeriodID and MT0810.VoucherID = @VoucherID
			Where MT1601.IsDistribute =1  and MT0810.ResultTypeID ='R01')
		Begin
			Set @Status = 1
			Set @Message = 'MFML000036'
		End

	Else
	If Exists (Select Top 1 1 From MT1001 inner join MT0810 on MT1001.VoucherID = MT0810.VoucherID 
						   Where MT1001.InheritVoucherID =@VoucherID )
				Begin
					Set @Status = 2
					Set @Message = 'MFML000031'
				End
	Else
	If Not Exists (Select Top 1 1 From MT1601 inner join MT0810 on MT1601.PeriodID = MT0810.PeriodID and MT0810.VoucherID = @VoucherID
			Where MT1601.IsDistribute =1 )
		Begin
			Set @Status = 0
			Set @Message = 'MFML000032'
		End
	End

Set Nocount Off	
Select @Status AS Status, @Message as Message