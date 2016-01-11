IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP1303]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP1303]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Created by Nguyen Van Nhan
----- Created Date 18/10/2005
----- Purpose Tinh gia xuat kho theo PP FIFO
----- Edit by Nguyen Quoc Huy  26/05/2006
----- Modified on 29/03/2012 by Lê Thị Thu Hiền : Sửa LEFT JOIN thành INNER JOIN
----- Modified on 19/11/2012 by Bao Anh		Sua loi cap nhat sai AT0114 khi tinh gia xuat kho lan 1 
											---(do AT0115 rong -> sua lai AT0114 Left join AT0115)
----- Edit by Khanh Van on 16/09/2013 :Ket them dieu kien DivisionID
----- Edit by Mai Duyen on 28/03/2014 :ket them AV3004.InventoryID (Fix lỗi KH EIS)
----- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/

CREATE PROCEDURE  [dbo].[AP1303] 
		@DivisionID  as nvarchar(50), 
		@TranMonth as int , 
		@TranYear as int

AS


Declare @InventoryID as  nvarchar(50),
	@FIFO_cur as cursor ,
	@ConvertedAmount as decimal(28,8),
	@ConvertedAmount115 as decimal(28,8),
	@VoucherID as nvarchar(50),
	@TransactionID as nvarchar(50),
	@VoucherDate as Datetime,
	@ActualQuantity as decimal(28,8),
	@WareHouseID nvarchar(50),
	@ReFIFO_cur as cursor,
	@ReDelete_cur as cursor,
	@ReVoucherID nvarchar(50),
	@ReTransactionID nvarchar(50),
	@EndQuantity as decimal(28,8),
	@UnitPrice as decimal(28,8),
	@CurrentMonth as int,
	@CurrentYear as int,
	@VoucherNo as nvarchar(50),
	@ReVoucherNo as nvarchar(50),
	@ReVoucherDate datetime,
	@Quantity as decimal(28,8),
	@Quantity115 as decimal(28,8),		

--PHAN LAM TRON SO
	@QuantityDecimals  as tinyint,
	@UnitCostDecimals  as tinyint, 
	@ConvertedDecimals as tinyint

Select @QuantityDecimals = QuantityDecimals, @UnitCostDecimals = UnitCostDecimals, @ConvertedDecimals = ConvertedDecimals
FROM AT1101 where divisionID = @DivisionID
Set @QuantityDecimals =isnull( @QuantityDecimals,2)
Set @UnitCostDecimals = isnull( @UnitCostDecimals,2)
Set @ConvertedDecimals = isnull( @ConvertedDecimals,2)
	


Set @ConvertedAmount  =0 
-------- B1: huy bo viec tinh gia cua cac phieu xuat tu ky do tro ve sau
---------- Xu ly cac phieu xuat da Xoa va gia xuat kho da tinh tu ky nay ve sau ---------------------------------------------------------------------------------

---------- Xoa du lieu rac: Bao Quynh; 13/02/2009
---------- Sua loi tu viec xoa du lieu rac do thieu sot cac phieu so du dau: Bao Quynh; 13/02/2009
Delete AT0115 Where DivisionID = @DivisionID and ReTransactionID + '_' + InventoryID not in (Select TransactionID + '_' + InventoryID From AT2007 Union Select TransactionID + '_' + InventoryID From AT2017)

Update AT0114 set DeQuantity = isnull(Quantity,0), EndQuantity = ReQuantity -  isnull(Quantity,0)
From AT0114 
LEFT join ( Select InventoryID, ReTransactionID, Sum(PriceQuantity) as Quantity, DivisionID 
             From AT0115 
             Group by ReTransactionID,InventoryID, DivisionID
			) A
	on	A.ReTransactionID = AT0114.ReTransactionID 
		And A.InventoryID = AT0114.InventoryID And A.DivisionID = AT0114.DivisionID
Where isnull(Quantity,0)<>isnull(DeQuantity,0) and AT0114.DivisionID = @DivisionID 

SET @ReDelete_cur = Cursor Scroll KeySet FOR 
Select  WareHouseID, ReTransactionID , ReVoucherID, InventoryID,   sum(isnull(PriceQuantity,0))
From AT0115
Where DivisionID = @DivisionID and TransactionID not in (Select TransactionID from AT2007 Where DivisionID = @DivisionID)   --- Nhung phieu da xoa roi	
Group by   WareHouseID, ReTransactionID , ReVoucherID, InventoryID
union All
Select  WareHouseID, ReTransactionID , ReVoucherID, InventoryID,  sum(isnull(PriceQuantity,0))
From AT0115
Where DivisionID = @DivisionID and TransactionID  in (Select TransactionID from AT2007 Where DivisionID = @DivisionID and
											TranMonth+TranYear*100 >=@TranMonth +100*@TranYear)   --- phieu xuat ky nay ve  sau	
Group by   WareHouseID, ReTransactionID , ReVoucherID, InventoryID

OPEN @ReDelete_cur
FETCH NEXT FROM @ReDelete_cur INTO  @WareHouseID, @ReTransactionID , @ReVoucherID, @InventoryID, @ActualQuantity
WHILE @@Fetch_Status = 0
 Begin
		--Print ' @ReTransactionID ='+@ReTransactionID+' so tien : '+str(@ActualQuantity)
		
	Update AT0114 set 	DeQuantity = DeQuantity - @ActualQuantity,
				EndQuantity = EndQuantity + @ActualQuantity
	Where 	DivisionID = @DivisionID and 
		WareHouseID = @WareHouseID and
		InventoryID = @InventoryID and
		ReVoucherID = @ReVoucherID and
		ReTransactionID =@ReTransactionID 
             FETCH NEXT FROM @ReDelete_cur INTO  @WareHouseID, @ReTransactionID , @ReVoucherID, @InventoryID, @ActualQuantity
 End 
CLOSE @ReDelete_cur

Delete AT0115 Where DivisionID = @DivisionID and TransactionID not in (Select TransactionID from AT2007 Where DivisionID = @DivisionID) 

Delete AT0115 Where DivisionID = @DivisionID and TransactionID  in (Select TransactionID from AT2007 Where DivisionID = @DivisionID and
											TranMonth+TranYear*100 >=@TranMonth +100*@TranYear)   --- phieu xuat ky nay ve  sau	
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------- Lay ra cac phan tu cua phieu xuat thep PP FIFO-----------------------------------------------------------
SET @FIFO_cur = Cursor Scroll KeySet FOR 
	Select WareHouseID , At2007.VoucherID, TransactionID, At2007.InventoryID , ActualQuantity, VoucherNo, VoucherDate , At2007.TranMonth, At2007.TranYear
	From AT2007 	inner join AT2006 on AT2006.VoucherID = AT2007.VoucherID and AT2006.DivisionID = AT2007.DivisionID 
			inner join AT1302 on AT1302.InventoryID = AT2007.InventoryID and AT1302.DivisionID = AT2007.DivisionID and  MethodID =1 
	Where 	AT2007.DivisionID = @DivisionID and
		KindVoucherID in (2,3,4,6,8) and
		At2007.TranMonth + AT2007.TranYear*100 >= @TranMonth +100*@TranYear
	Order by VoucherDate, AT2007.VoucherID, Orders ---- Cac phieu xuat kho theo thu tu ngay tang dan 
---Print ' TEST'
OPEN	@FIFO_cur
FETCH NEXT FROM @FIFO_cur INTO   @WareHouseID, @VoucherID, @TransactionID, @InventoryID, @ActualQuantity, @VoucherNo, @VoucherDate , @CurrentMonth, @CurrentYear 
WHILE @@Fetch_Status = 0

	Begin	
		Set @ConvertedAmount = 0
		Set @Quantity = 0
		
		Set @ReFIFO_cur = Cursor Scroll KeySet FOR  ---- Lay cac phieu nhap tuong ung co the xuat kho dc.

		Select AT0114.ReVoucherID, AT0114.ReTransactionID, AT0114.EndQuantity , isnull(AV3004.UnitPrice,0),  AT0114.ReVoucherNo, AT0114.ReVoucherDate  
		From AT0114 	INNER JOIN AV3004 ON AV3004.TransactionID = AT0114.ReTransactionID and AV3004.DivisionID = AT0114.DivisionID
						and AV3004.InventoryID = AT0114.InventoryID
			--INNER JOIN AT2006 ON AT2006.VoucherID = AT0114.ReVoucherID
			--INNER JOIN AT2007 ON AT2007.TransactionID = AT0114.ReTransactionID

		Where AT0114.DivisionID = @DivisionID and 
			AT0114.ReVoucherDate<=@VoucherDate and
			--(CASE WHEN AT2006.KINDVOUCHERID = 3 THEN AT2006.WareHouseID2 ELSE AT2006.WareHouseID END) = @WareHouseID and
			AV3004.WareHouseID= @WareHouseID and
			AT0114.InventoryID =@InventoryID and
			AT0114.EndQuantity >0	
		Order by AT0114.ReVoucherDate, AT0114.ReTransactionID
		Open @ReFIFO_cur
		FETCH NEXT FROM @ReFIFO_cur  INTO  @ReVoucherID, @ReTransactionID,  @EndQuantity, @UnitPrice, @ReVoucherNo, @ReVoucherDate
			WHILE @@Fetch_Status = 0 and @ActualQuantity>0 
				Begin
					Set @Quantity115 =0
					If @EndQuantity>@ActualQuantity
						Begin
							
							Set @ConvertedAmount = ROUND(ROUND(@ConvertedAmount,@ConvertedDecimals)+ ROUND(@UnitPrice,@UnitCostDecimals)*ROUND(@ActualQuantity,@QuantityDecimals) ,@ConvertedDecimals)
							Set @ConvertedAmount115 = ROUND(ROUND(@UnitPrice,@UnitCostDecimals)*ROUND(@ActualQuantity,@QuantityDecimals) ,@ConvertedDecimals)
							Set @Quantity = ROUND(@Quantity+ @ActualQuantity,@QuantityDecimals)	
							set @Quantity115 =ROUND(@ActualQuantity,@QuantityDecimals)	
							Set @ActualQuantity = 0 	

								
						 End
						Else
						 Begin
							Set @ConvertedAmount = ROUND(ROUND(@ConvertedAmount,@ConvertedDecimals)+ ROUND(@UnitPrice,@UnitCostDecimals)*ROUND(@EndQuantity,@QuantityDecimals) ,@ConvertedDecimals)
							Set @ConvertedAmount115 = ROUND(ROUND(@UnitPrice,@UnitCostDecimals)*ROUND(@EndQuantity,@QuantityDecimals) ,@ConvertedDecimals)
							Set @Quantity = ROUND(@Quantity+ @EndQuantity  ,@QuantityDecimals)
							Set @Quantity115 = ROUND(@EndQuantity ,@QuantityDecimals) 	
							Set @ActualQuantity  =ROUND( ROUND(@ActualQuantity,@QuantityDecimals) - ROUND(@EndQuantity,@QuantityDecimals)	,@QuantityDecimals)

												
						 End
						Update AT0114 set 	EndQuantity =  EndQuantity - @Quantity115 ,
									DeQuantity = DeQuantity + @Quantity115
							Where ReVoucherID = @ReVoucherID and
								DivisionID= @DivisionID and
								WareHouseID = @WareHouseID and
								InventoryID = @InventoryID and
								ReTransactionID =@ReTransactionID
					
					
						Insert AT0115 (DivisionID, TranMonth, TranYear, WareHouseID, VoucherDate, VoucherNo,  VoucherID, TransactionID, InventoryID,
									 UnitPrice, PriceQuantity, ConvertedAmount, ReVoucherID, ReTransactionID, ReVoucherDate, ReVoucherNo)
							Values (@DivisionID, @CurrentMonth, @CurrentYear, @WareHouseID, @VoucherDate, @VoucherNo, @VoucherID, @TransactionID, @InventoryID,
									@UnitPrice,  @Quantity115 , @ConvertedAmount115, @ReVoucherID, @ReTransactionID, @ReVoucherDate, @ReVoucherNo)

					


					 FETCH NEXT FROM @ReFIFO_cur  INTO  @ReVoucherID, @ReTransactionID,  @EndQuantity, @UnitPrice, @ReVoucherNo, @ReVoucherDate
				End 

		             Update AT2007   set 	ConvertedAmount = Round(@ConvertedAmount,@ConvertedDecimals),
						OriginalAmount  = Round(@ConvertedAmount,@ConvertedDecimals),
						UnitPrice =Round( ( Case when ActualQuantity <>0 then  round(@ConvertedAmount, @ConvertedDecimals) / ActualQuantity else 0 end ),@UnitCostDecimals)
			Where DivisionID = @DivisionID and TransactionID = @TransactionID 

FETCH NEXT FROM @FIFO_cur INTO   @WareHouseID, @VoucherID, @TransactionID, @InventoryID, @ActualQuantity, @VoucherNo, @VoucherDate , @CurrentMonth, @CurrentYear 
	End
CLOSE @FIFO_cur

 ---Goi  Store de lam tron phan tinh gia FIFO
  Exec AP1301 @DivisionID, @TranMonth, @TranYear

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

