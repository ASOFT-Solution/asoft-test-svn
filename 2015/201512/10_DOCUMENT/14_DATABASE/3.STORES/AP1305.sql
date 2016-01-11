/****** Object:  StoredProcedure [dbo].[AP1305]    Script Date: 07/29/2010 17:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------  	Created by Nguyen Van Nhan
------- 	Created Date  21/12/2004.
-------	Purpose Tinh gia thuc te dich danh 
-------	Edited by Nguyen Quoc Huy, Date: 29/12/2006 (them @SourceNo vao viec lam tron)
-------	Edit by: Dang Le Bao Quynh , Date 01/07/2009
-------	Pupose: bo lam tron do vong lap vo tan
-------	Edit by: Dang Le Bao Quynh , Date 09/09/2009
-------	Pupose: Bo sung chuc nang lam tron, xu ly loai bo vong lap vo tan
-------	Edit by: Dang Le Bao Quynh , Date 14/09/2009
-------	Pupose: Chinh sua chuc nang lam tron, chi chon phieu xuat tuong ung voi phieu nhap co chenh lech de dieu chinh thay vi dieu chinh phieu xuat lon nhat. 
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/
--- Edited by Bao Anh	Date: 05/08/2012
--- Purpose: Bo sung quy cach (yeu cau cua 2T)
--- Edited by Khanh Van Date: 16/09/2013
--- Purpose: Bo sung dieu kien divisionID
--- Modified on 08/10/2015 by Tieu Mai: Sửa phần làm tròn số lẻ theo thiết lập đơn vị-chi nhánh




ALTER PROCEDURE  [dbo].[AP1305] @DivisionID  as nvarchar(50), @TranMonth as int , @TranYear as int

AS


Declare @InventoryID as  nvarchar(50),
	@SourceNo as nvarchar(50),
	@BQGQ_cur as cursor ,
	@round_cur as cursor ,
	@ReTransactionID as nvarchar(50),
	@ReVoucherID as nvarchar(50),
	@WareHouseID as nvarchar(50),
	@DeltaAmount as decimal(28,8),
	@TransactionID nvarchar(50),
	@ConvertedDecimals as INT,
	@Parameter01 DECIMAL(28,8),
	@Parameter02 DECIMAL(28,8),
	@Parameter03 DECIMAL(28,8),
	@Parameter04 DECIMAL(28,8),
	@Parameter05 DECIMAL(28,8)

Select @ConvertedDecimals = ConvertedDecimals From AT1101 WHERE DivisionID = @DivisionID

SET @BQGQ_Cur = Cursor Scroll KeySet FOR 
	/*
	Select 	InventoryID From AT1302
	Where MethodID = 3
	*/
	
	Select 	DISTINCT AT2007.InventoryID, Isnull(Parameter01,0), Isnull(Parameter02,0), Isnull(Parameter03,0), Isnull(Parameter04,0), Isnull(Parameter05,0)
	From AT2007 INNER JOIN AT1302 ON AT2007.InventoryID = AT1302.InventoryID and AT2007.DivisionID = AT1302.DivisionID
	Where AT1302.MethodID = 3 and AT2007.DivisionID = @DivisionID
		
OPEN	@BQGQ_cur
FETCH NEXT FROM @BQGQ_cur INTO   @InventoryID, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05
WHILE @@Fetch_Status = 0
	Begin	
		Update A1 set 	UnitPrice = A2.UnitPrice,
				OriginalAmount = round(A1.ActualQuantity*isnull(A2.UnitPrice,0),@ConvertedDecimals),
				ConvertedAmount =round(A1.ActualQuantity*isnull(A2.UnitPrice,0),@ConvertedDecimals)
		From AT2007 A1 inner join AT0114 A2 on A1.ReTransactionID = A2.ReTransactionID and A1.DivisionID = A2.DivisionID
		Where  A1.InventoryID =@InventoryID and
			A1.TranMonth = @TranMonth and
			A1.TranYear = @TranYear and
			A1.DivisionID = @DivisionID AND
			Isnull(A1.Parameter01,0) = @Parameter01 AND
			Isnull(A1.Parameter02,0) = @Parameter02 AND
			Isnull(A1.Parameter03,0) = @Parameter03 AND
			Isnull(A1.Parameter04,0) = @Parameter04 AND
			Isnull(A1.Parameter05,0) = @Parameter05

		FETCH NEXT FROM @BQGQ_cur INTO   @InventoryID, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05
	End
CLOSE @BQGQ_cur

--------------------- Xu ly lam tron so le

--Set @round_cur = Cursor Scroll KeySet FOR

Declare @CountUpdate int



--Tinh lai 
Recal:

Set @round_cur = Cursor static FOR



Select  WareHouseID, AT0114.InventoryID,  AT0114.ReSourceNo,  isnull(At2007.ConvertedAmount,0)  - Sum(X.ConvertedAmount) ,  ---  --round(ReQuantity*At0114.UnitPrice, @ConvertedDecimals), 
	At0114.ReVoucherID, At0114.ReTransactionID 
From AT0114 	inner join AT1302 on AT1302.InventoryID = AT0114.InventoryID and MethodID = 3  -- thuc te dich danh
                     and AT1302.DivisionID = AT0114.DivisionID
		inner join AT2007 on 	AT2007.TransactionID = At0114.ReTransactionID and  -- phieu nhap
					AT2007.VoucherID = AT0114.ReVoucherID and AT2007.DivisionID = AT0114.DivisionID
		right join AT2007 X on 	X.ReTransactionID = AT0114.ReTransactionID    -- phieu xuat
		                and X.DivisionID = AT0114.DivisionID

Where At0114.DivisionID = @DivisionID and EndQuantity =0 and  
            At0114.ReTransactionID in (Select ReTransactionID From AT2007 Where TranMonth = @TranMonth and TranYear = @TranYear and DivisionID =@DivisionID) and  --phieu nhap trong ky
           At0114.ReTransactionID not in (Select ReTransactionID From AT2007 Where TranMonth + TranYear*100> @TranMonth +100*@TranYear and DivisionID =@DivisionID and isnull(ReTransactionID,'')<>'')
Group by  WareHouseID, AT0114.InventoryID, AT0114.ReSourceNo, AT2007.ConvertedAmount , At0114.ReVoucherID, At0114.ReTransactionID 
Having isnull(At2007.ConvertedAmount,0)  - Sum(X.ConvertedAmount)  <>0 

Union All
Select 		WareHouseID, AT0114.InventoryID, AT0114.ReSourceNo ,  isnull(At2017.ConvertedAmount,0) - Sum(X.ConvertedAmount) , 	---- round(ReQuantity*At0114.UnitPrice, @ConvertedDecimals), 
		At0114.ReVoucherID, At0114.ReTransactionID 
From AT0114 	inner join AT1302 on AT1302.InventoryID = AT0114.InventoryID and MethodID = 3  -- thuc te dich danh
                     and AT1302.DivisionID = AT0114.DivisionID
		inner join AT2017 AT2017 on 	AT2017.TransactionID = At0114.ReTransactionID and
						AT2017.VoucherID = AT0114.ReVoucherID and AT2017.DivisionID = AT0114.DivisionID
		right join AT2007 X on 	X.ReTransactionID = AT0114.ReTransactionID 
		                and X.DivisionID = AT0114.DivisionID

Where At0114.DivisionID = @DivisionID and EndQuantity =0 and   
            At0114.ReTransactionID in (Select ReTransactionID From AT2007 Where TranMonth = @TranMonth and TranYear = @TranYear and DivisionID =@DivisionID) and 
	At0114.ReTransactionID not in (Select ReTransactionID From AT2007 Where TranMonth + TranYear*100> @TranMonth +100*@TranYear and DivisionID =@DivisionID and isnull(ReTransactionID,'')<>'')
Group by  WareHouseID, AT0114.InventoryID, AT0114.ReSourceNo, AT2017.ConvertedAmount , At0114.ReVoucherID, At0114.ReTransactionID 
Having isnull(At2017.ConvertedAmount,0)  - Sum(X.ConvertedAmount)  <>0 


		
OPEN	@round_cur
FETCH NEXT FROM @round_cur INTO  @WareHouseID, @InventoryID, @SourceNo,  @DeltaAmount, @ReVoucherID, @ReTransactionID
WHILE @@Fetch_Status = 0
	Begin	
	
		If exists (Select Top 1 1 From AT2006 Inner join AT2007 On AT2006.VoucherID = AT2007.VoucherID and AT2006.DivisionID = AT2007.DivisionID 
			Where 	AT2007.InventoryID =@InventoryID and 								
				AT2006.TranMonth = @TranMonth and 
				AT2006.TranYear = @TranYear and 
				AT2006.DivisionID = @DivisionID and
				AT2006.WareHouseID = @WareHouseID and
				AT2006.KindVoucherID In (2,4,6) and 
				AT2007.ReTransactionID = @ReTransactionID)
			Begin
				
					Set  @TransactionID = ( Select  top 1 D11.TransactionID
							From AT2007  D11 inner join AT2006 D9 on D9.VoucherID  = D11.VoucherID and D9.DivisionID  = D11.DivisionID
							Where  D11.InventoryID =@InventoryID and 								
								D11.TranMonth = @TranMonth and 
								D11.TranYear = @TranYear and 
								D11.DivisionID = @DivisionID and
							           (	(D9.WareHouseID = @WareHouseID  and D9.KindVoucherID  in (2,4,6) ) 
								--or (D9.WareHouseID2 = @WareHouseID  and D9.KindVoucherID  =3 ) 
								) and D11.ReTransactionID = @ReTransactionID
								/*
								and
								ConvertedAmount = 	(Select  Max( AT2007.ConvertedAmount)
					 						From AT2007  inner join AT2006  on AT2007.VoucherID  =AT2006.VoucherID
											Where  AT2007.InventoryID =@InventoryID and 
												AT2007.TranMonth = @TranMonth and 
												AT2007.TranYear = @TranYear and 
												AT2007.DivisionID = @DivisionID and
												AT2007.ReVoucherID = @ReVoucherID and
												LTrim(RTrim(isnull(AT2007.SourceNo,''))) = Ltrim(RTrim(isnull(@SourceNo,''))) and
											    	( (AT2006.WareHouseID = @WareHouseID  and AT2006.KindVoucherID  in (2,4,6) )  
												--or (AT2006.WareHouseID2 = @WareHouseID  and AT2006.KindVoucherID  =3 ) 
												))
								*/
								)
			End
		Else
			Begin
				
					Set  @TransactionID = ( Select  top 1 D11.TransactionID
							From AT2007  D11 inner join AT2006 D9 on D9.VoucherID  = D11.VoucherID and D9.DivisionID  = D11.DivisionID
							Where  D11.InventoryID =@InventoryID and 								
								D11.TranMonth = @TranMonth and 
								D11.TranYear = @TranYear and 
								D11.DivisionID = @DivisionID and
							           	(D9.WareHouseID2 = @WareHouseID  and D9.KindVoucherID  =3 ) and
								D11.ReTransactionID = @ReTransactionID
								/*
								and 
								ConvertedAmount = 	(Select  Max( AT2007.ConvertedAmount)
					 						From AT2007  inner join AT2006  on AT2007.VoucherID  =AT2006.VoucherID
											Where  AT2007.InventoryID =@InventoryID and 
												AT2007.TranMonth = @TranMonth and 
												AT2007.TranYear = @TranYear and 
												AT2007.DivisionID = @DivisionID and
												AT2007.ReVoucherID = @ReVoucherID and
												LTrim(RTrim(isnull(AT2007.SourceNo,''))) = Ltrim(RTrim(isnull(@SourceNo,''))) and
											    	(AT2006.WareHouseID2 = @WareHouseID  and AT2006.KindVoucherID  =3 ) 
												)
								*/
								)
			End
		If @TransactionID is not null
		Begin
				
				Update AT2007 Set 	ConvertedAmount = round(round(isnull(ConvertedAmount,0),@ConvertedDecimals) + round(@DeltaAmount,@ConvertedDecimals),@ConvertedDecimals) ,
							OriginalAmount = round(round(isnull(OriginalAmount,0),@ConvertedDecimals) + round(@DeltaAmount,@ConvertedDecimals),@ConvertedDecimals)							
				From AT2007 inner join AT2006 on AT2007.VoucherID  = AT2006.VoucherID and AT2007.DivisionID  = AT2006.DivisionID
				Where  InventoryID =@InventoryID and 
					AT2007.TranMonth = @TranMonth and 
					AT2007.TranYear = @TranYear and 
					AT2007.DivisionID = @DivisionID and
					( (AT2006.WareHouseID = @WareHouseID  and AT2006.KindVoucherID  in (2,4,6) )  or 
					(AT2006.WareHouseID2 = @WareHouseID  and AT2006.KindVoucherID =3 ) 
					) and
				AT2007.TransactionID =@TransactionID
				Set @CountUpdate = @CountUpdate + 1 
		End

		FETCH NEXT FROM @round_cur INTO  @WareHouseID, @InventoryID, @SourceNo, @DeltaAmount, @ReVoucherID, @ReTransactionID
							 
	End
	Close 	@round_cur
--Neu van con ton tai chenh lech quay lai xu ly tiep :)
If exists (
Select  WareHouseID, AT0114.InventoryID,  AT0114.ReSourceNo,  isnull(At2007.ConvertedAmount,0)  - Sum(X.ConvertedAmount) ,  ---  --round(ReQuantity*At0114.UnitPrice, @ConvertedDecimals), 
	At0114.ReVoucherID, At0114.ReTransactionID 
From AT0114 	inner join AT1302 on AT1302.InventoryID = AT0114.InventoryID and MethodID = 3  -- thuc te dich danh
                        and AT1302.DivisionID = AT0114.DivisionID
		inner join AT2007 on 	AT2007.TransactionID = At0114.ReTransactionID and  -- phieu nhap
					AT2007.VoucherID = AT0114.ReVoucherID and AT2007.DivisionID = At0114.DivisionID
		right join AT2007 X on 	X.ReTransactionID = AT0114.ReTransactionID    -- phieu xuat
                        and X.DivisionID = AT0114.DivisionID

Where At0114.DivisionID = @DivisionID and EndQuantity =0 and  
            At0114.ReTransactionID in (Select ReTransactionID From AT2007 Where TranMonth = @TranMonth and TranYear = @TranYear and DivisionID =@DivisionID) and  --phieu nhap trong ky
           At0114.ReTransactionID not in (Select ReTransactionID From AT2007 Where TranMonth + TranYear*100> @TranMonth +100*@TranYear and DivisionID =@DivisionID and isnull(ReTransactionID,'')<>'')
Group by  WareHouseID, AT0114.InventoryID, AT0114.ReSourceNo, AT2007.ConvertedAmount , At0114.ReVoucherID, At0114.ReTransactionID 
Having isnull(At2007.ConvertedAmount,0)  - Sum(X.ConvertedAmount)  <>0 

Union All
Select 		WareHouseID, AT0114.InventoryID, AT0114.ReSourceNo ,  isnull(At2017.ConvertedAmount,0) - Sum(X.ConvertedAmount) , 	---- round(ReQuantity*At0114.UnitPrice, @ConvertedDecimals), 
		At0114.ReVoucherID, At0114.ReTransactionID 
From AT0114 	inner join AT1302 on AT1302.InventoryID = AT0114.InventoryID and MethodID = 3  -- thuc te dich danh
                        and AT1302.DivisionID = AT0114.DivisionID
		inner join AT2017 AT2017 on 	AT2017.TransactionID = At0114.ReTransactionID and
						AT2017.VoucherID = AT0114.ReVoucherID and AT2017.DivisionID = At0114.DivisionID
		right join AT2007 X on 	X.ReTransactionID = AT0114.ReTransactionID 
                        and X.DivisionID = AT0114.DivisionID

Where At0114.DivisionID = @DivisionID and EndQuantity =0 and   
            At0114.ReTransactionID in (Select ReTransactionID From AT2007 Where TranMonth = @TranMonth and TranYear = @TranYear and DivisionID =@DivisionID) and 
	At0114.ReTransactionID not in (Select ReTransactionID From AT2007 Where TranMonth + TranYear*100> @TranMonth +100*@TranYear and DivisionID =@DivisionID and isnull(ReTransactionID,'')<>'')
Group by  WareHouseID, AT0114.InventoryID, AT0114.ReSourceNo, AT2017.ConvertedAmount , At0114.ReVoucherID, At0114.ReTransactionID 
Having isnull(At2017.ConvertedAmount,0)  - Sum(X.ConvertedAmount)  <>0 
) And @CountUpdate>0

GOTO ReCal
GO
