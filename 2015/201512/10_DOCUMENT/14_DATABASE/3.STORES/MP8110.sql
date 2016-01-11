IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP8110]') AND  OBJECTPROPERTY(ID, N'IsProcedure') = 1)			
DROP PROCEDURE [DBO].[MP8110]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Created by Hoang Thi Lan
--Date 28/11/2003
--Purpose:CËp nhËt vµo kÕt qu¶ s¶n xuÊt kÕt qu¶ tÝnh gi¸ thµnh
-- Modified on 27/06/2014 by Thanh Sơn : Cập nhật câu sql lấy số lẻ đơn giá

/********************************************
'* Edited by: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/

CREATE PROCEDURE [dbo].[MP8110] 	@DivisionID as nvarchar(50),
					@PeriodID as  nvarchar(50)

 AS
Declare @sSQL  as nvarchar(4000),
	@ListMaterial_cur as cursor,
	@ProductID as nvarchar(50),
	@CostUnit as decimal(28,8),
	@ConvertedDecimal as int,
	@ConvertedAmount as decimal(28,8),
	@Delta as decimal(28,8),
	@TransactionID as nvarchar(50),
	@AT2007_cur as cursor,
	@Price as decimal(28,8),
	@Cost as decimal(28,8),
	@Temp as decimal(28,8),
	@EndCost as decimal(28,8),
	@Quantity as decimal(28,8),
	@UnitPriceDecimal DECIMAL(28,8),
	@OriginalDecimal DECIMAL(28,8)


SELECT @ConvertedDecimal = ConvertDecimal, @UnitPriceDecimal = UnitPriceDecimal, @OriginalDecimal = OriginalDecimal  FROM MT0000 where DivisionID = @DivisionID
set @ConvertedDecimal = isnull(@ConvertedDecimal,2)
set @UnitPriceDecimal = isnull(@UnitPriceDecimal,2)
set @OriginalDecimal = isnull(@OriginalDecimal,2)

Set @ListMaterial_cur  = Cursor Scroll KeySet FOR 

Select ProductID, CostUnit, Cost,  
	isnull(EndInprocessCost,0) 
From MT1614
Where 	DivisionID = @DivisionID and periodID = @PeriodID

Open @ListMaterial_cur 
		FETCH NEXT FROM @ListMaterial_cur INTO  @ProductID , @CostUnit, @Cost, @EndCost
		WHILE @@Fetch_Status = 0
			Begin	
				
				Update MT1001
				Set  MT1001.Price = @CostUnit,
				      MT1001.OriginalAmount =  Round(MT1001.Quantity*round(@CostUnit, @UnitPriceDecimal), @OriginalDecimal),
		  		     MT1001.ConvertedAmount  = Round(MT1001.Quantity*round(@CostUnit,@UnitPriceDecimal), @ConvertedDecimal)
				
				From MT1001 inner join MT0810 on MT0810.VoucherID =MT1001.VoucherID
				Where MT0810.DivisionID= @DivisionID and MT0810.PeriodID =@PeriodID 
					and MT1001.ProductID = @ProductID and MT0810.ResultTypeID = 'R01' 
				
				
			Set @Quantity =0
			Set @Quantity = 	(Select sum(Quantity) From MT1001 M1 inner join MT0810 M10  on M10.VoucherID  = M1.VoucherID
						Where 	M1.DivisionID =@DivisionID and
							PeriodID =@PeriodID and
							M1.ProductID = @ProductID and
							ResultTypeID ='R03' )
				--Print ' Q: '+Str(@Quantity)+' P: '+@ProductID+' @EndCost: '+str(@EndCost)+' U ='+str(@EndCost/@Quantity)
				
				
				Update MT1001
				Set  MT1001.Price = Case when @Quantity <>0 then @EndCost/@Quantity else 0 end,
				      MT1001.OriginalAmount =  Case when @Quantity <>0 then (Quantity*@EndCost)/@Quantity else 0 end,
		  		      MT1001.ConvertedAmount  = Case when @Quantity <>0 then (Quantity*@EndCost)/@Quantity else 0 end
				
				From MT1001 inner join MT0810 on MT0810.VoucherID =MT1001.VoucherID
				Where MT0810.DivisionID= @DivisionID and MT0810.PeriodID =@PeriodID 
					and MT1001.ProductID = @ProductID and MT0810.ResultTypeID = 'R03' 


		FETCH NEXT FROM @ListMaterial_cur INTO   @ProductID ,@CostUnit, @Cost, @EndCost

		End
		Close @ListMaterial_cur

set @ConvertedAmount = isnull( (Select  sum(isnull(Cost,0)) From MT1614 Where  	DivisionID = @DivisionID and 	PeriodID = @PeriodID),0)

Set @Delta =0 

Set @Delta = @ConvertedAmount -   isnull((Select  sum(isnull(MT1001.ConvertedAmount,0))  From MT1001  inner join MT0810 on MT0810.VoucherID =MT1001.VoucherID
										Where MT0810.DivisionID= @DivisionID and MT0810.PeriodID =@PeriodID 
										 and MT0810.ResultTypeID = 'R01'  ),0) 


If @Delta <>0 
	Begin 
		---Print ' Chenh lech '+str(@Delta,20,4)
		---Print ' Tong gia thanh '+str(@ConvertedAmount,20,4)
		
		Set @TransactionID = (Select top 1 TransactionID From MT1001 inner join MT0810 on MT0810.VoucherID =MT1001.VoucherID
						Where MT0810.DivisionID= @DivisionID and MT0810.PeriodID =@PeriodID 
							 and MT0810.ResultTypeID = 'R01' 
						Order by MT1001.ConvertedAmount Desc)
		Print ' Tran ' +@TransactionID
		 if @TransactionID is not null
			Update MT1001
				
				set       MT1001.OriginalAmount =  MT1001.OriginalAmount + @Delta,
		  		     	 MT1001.ConvertedAmount  =MT1001.ConvertedAmount  + @Delta
				
				From MT1001 inner join MT0810 on MT0810.VoucherID =MT1001.VoucherID
				Where MT0810.DivisionID= @DivisionID and MT0810.PeriodID =@PeriodID and TransactionID = @TransactionID 
					and MT0810.ResultTypeID = 'R01' 



	End



------ Edit by VAN NHAN
Set @ListMaterial_cur  = Cursor Scroll KeySet FOR 
Select ProductID,  Cost
From MT1614
Where 	DivisionID = @DivisionID and
	PeriodID = @PeriodID

Open @ListMaterial_cur 
		FETCH NEXT FROM @ListMaterial_cur INTO  @ProductID,  @Cost
		WHILE @@Fetch_Status = 0
			Begin	

				Set @Temp =0
				Set @Delta =0
				Set @Temp = 	isnull((Select Sum(MT1001.ConvertedAmount) 
						From MT1001  inner join MT0810 on MT0810.VoucherID =MT1001.VoucherID
						Where MT0810.DivisionID= @DivisionID and MT0810.PeriodID =@PeriodID 
							and MT1001.ProductID = @ProductID and MT0810.ResultTypeID = 'R01' ),0)
				Set @Delta =  @Cost - @Temp
				If @Delta <>0 
					Begin 
					---Print ' Chenh lech '+str(@Delta,20,4)
					---Print ' Tong gia thanh '+str(@ConvertedAmount,20,4)		
				Set @TransactionID = (Select top 1 TransactionID From MT1001 inner join MT0810 on MT0810.VoucherID =MT1001.VoucherID
						Where MT0810.DivisionID= @DivisionID and MT0810.PeriodID =@PeriodID  and ProductID =@ProductID
							 and MT0810.ResultTypeID = 'R01' 
						Order by MT1001.ConvertedAmount Desc)
				Print ' Tran ' +@TransactionID+' Delta '+str(@Delta)
				 if @TransactionID is not null
				Update MT1001
				
				set       MT1001.OriginalAmount =  MT1001.OriginalAmount + @Delta,
		  		     	 MT1001.ConvertedAmount  =MT1001.ConvertedAmount  + @Delta
				
				From MT1001 inner join MT0810 on MT0810.VoucherID =MT1001.VoucherID
				Where MT0810.DivisionID= @DivisionID and MT0810.PeriodID =@PeriodID and TransactionID = @TransactionID 
					and MT0810.ResultTypeID = 'R01'     and ProductID =@ProductID



					End
				
			FETCH NEXT FROM @ListMaterial_cur INTO   @ProductID,  @Cost
		End
		Close @ListMaterial_cur



---- Day lai ASOFT - T
Set @AT2007_cur  = Cursor Scroll KeySet FOR 
Select  	TransactionID, 
	ProductID,
	price, 
	MT1001.ConvertedAmount 
From 	MT1001 inner join MT0810 on MT0810.VoucherID = MT1001.VoucherID
Where 	MT0810.PeriodID = @PeriodID and MT1001.DivisionID =@DivisionID and
	Mt0810.IsWareHouse =1 and ResultTypeID ='R01'

Open @AT2007_cur
FETCH NEXT FROM @AT2007_cur INTO  @TransactionID, @ProductID, @Price , @ConvertedAmount
		WHILE @@Fetch_Status = 0
			Begin	
				Update AT2007 Set	 UnitPrice = @Price,
							OriginalAmount = @ConvertedAmount,
							ConvertedAmount = @ConvertedAmount
				Where DivisionID =@DivisionID and
					TransactionID =@TransactionID and
					InventoryID =@ProductID
	
				FETCH NEXT FROM @AT2007_cur INTO  @TransactionID, @ProductID, @Price, @ConvertedAmount			
			End

ClOSE @AT2007_cur








GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
