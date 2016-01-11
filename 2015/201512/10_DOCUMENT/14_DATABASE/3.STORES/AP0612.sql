/****** Object:  StoredProcedure [dbo].[AP0612]    Script Date: 07/29/2010 17:23:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----- Created by Nguyen Van Nhan, Date 19/03/2003
----- Cap nhat so du AT2008 tu phieu nhap so du
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/
--- Edited by Bao Anh	Date: 05/08/2012
--- Purpose: Cap nhat du lieu cho AT2888 (so du ton kho co quy cach va sl mark - yeu cau 2T)

ALTER PROCEDURE [dbo].[AP0612]
	 @DivisionID nvarchar(50), 
	@WareHouseID  nvarchar(50),
	 @TranMonth  int, 
	@TranYear int, 
	@InventoryID  nvarchar(50), 
	@ConvertedAmount as Decimal(28,8), 
	@ConvertedQuantity as Decimal(28,8), 
	@DebitAccountID  nvarchar(50), 
	@CreditAccountID  nvarchar(50), 
	@Type as TINYINT, -- (1) la cap nhat tang,(0 ) la cap nhat giam
	@Parameter01 DECIMAL(28,8),
	@Parameter02 DECIMAL(28,8),
	@Parameter03 DECIMAL(28,8),
	@Parameter04 DECIMAL(28,8),
	@Parameter05 DECIMAL(28,8),
	@MarkQuantity DECIMAL(28,8)

 AS

DECLARE @CustomerName INT
--Tao bang tam de kiem tra day co phai la khach hang 2T khong (CustomerName = 15)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

If @Type =1	 --- Cap nhat tang (Inserted)
	Begin
		
		If not exists (Select 1 From AT2008 	Where 	InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID =@DebitAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear)
			Insert AT2008 (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
					  InventoryAccountID,   BeginQuantity,  BeginAmount,
					 DebitQuantity ,  DebitAmount , CreditQuantity ,
					CreditAmount,  EndQuantity ,  EndAmount)
			Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
				@DebitAccountID, @ConvertedQuantity, @ConvertedAmount , 0,0, 0,0, 
				@ConvertedQuantity, @ConvertedAmount)
		else
			Update AT2008
				Set	BeginQuantity 	=	Isnull(BeginQuantity,0)	+ isnull(@ConvertedQuantity,0),
					BeginAmount 	=	Isnull(BeginAmount,0)	+ isnull(@ConvertedAmount,0),
					EndQuantity		=	Isnull(EndQuantity,0)		+ Isnull(@ConvertedQuantity,0),
					EndAmount		=	Isnull(EndAmount,0)		+Isnull(@ConvertedAmount,0)	
			Where 		InventoryID =@InventoryID and
					DivisionID =@DivisionID and
					WareHouseID =@WareHouseID and
					InventoryAccountID =@DebitAccountID and
					TranMonth =@TranMonth and
					TranYear =@TranYear	
		
		IF @CustomerName = 15
			BEGIN
				--- Cap nhat AT2888: so du ton kho theo quy cach (yeu cau cua 2T)
				If not exists (Select 1 From AT2888 	Where 	InventoryID =@InventoryID and
										DivisionID =@DivisionID and
										WareHouseID =@WareHouseID and
										InventoryAccountID =@DebitAccountID and
										TranMonth =@TranMonth and
										TranYear =@TranYear AND
										Isnull(Parameter01,0) = @Parameter01 AND
										Isnull(Parameter02,0) = @Parameter02 AND
										Isnull(Parameter03,0) = @Parameter03 AND
										Isnull(Parameter04,0) = @Parameter04 AND
										Isnull(Parameter05,0) = @Parameter05)
					Insert AT2888 (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
							  InventoryAccountID,   BeginQuantity,  BeginAmount,
							 DebitQuantity ,  DebitAmount , CreditQuantity ,
							CreditAmount,  EndQuantity ,  EndAmount,
							Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
							BeginMarkQuantity, DebitMarkQuantity, CreditMarkQuantity, EndMarkQuantity)
					Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
						@DebitAccountID, @ConvertedQuantity, @ConvertedAmount , 0,0, 0,0, 
						@ConvertedQuantity, @ConvertedAmount,
						@Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05,
						@MarkQuantity,0,0,@MarkQuantity)
				else
					Update AT2888
						Set	BeginQuantity 	=	Isnull(BeginQuantity,0)	+ isnull(@ConvertedQuantity,0),
							BeginAmount 	=	Isnull(BeginAmount,0)	+ isnull(@ConvertedAmount,0),
							EndQuantity		=	Isnull(EndQuantity,0)		+ Isnull(@ConvertedQuantity,0),
							EndAmount		=	Isnull(EndAmount,0)		+Isnull(@ConvertedAmount,0),
							BeginMarkQuantity 	=	Isnull(BeginMarkQuantity,0)	+ isnull(@MarkQuantity,0),
							EndMarkQuantity		=	Isnull(EndMarkQuantity,0)		+ Isnull(@MarkQuantity,0)
					Where 		InventoryID =@InventoryID and
							DivisionID =@DivisionID and
							WareHouseID =@WareHouseID and
							InventoryAccountID =@DebitAccountID and
							TranMonth =@TranMonth and
							TranYear =@TranYear AND
							Isnull(Parameter01,0) = @Parameter01 AND
							Isnull(Parameter02,0) = @Parameter02 AND
							Isnull(Parameter03,0) = @Parameter03 AND
							Isnull(Parameter04,0) = @Parameter04 AND
							Isnull(Parameter05,0) = @Parameter05
			END
	End

Else  		--- Cap nhat giam (Deleted)
	Begin
		If not exists (Select 1 From AT2008 Where 	InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID =@DebitAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear)
			Insert AT2008 (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
					  InventoryAccountID,   BeginQuantity,  BeginAmount,
					 DebitQuantity,  DebitAmount,  CreditQuantity,
					CreditAmount,   EndQuantity , EndAmount)
			Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
				@DebitAccountID, -@ConvertedQuantity, -@ConvertedAmount, 0,0, 0,0,  
				-@ConvertedQuantity, -@ConvertedAmount)
		else
			Update AT2008
				set 	BeginQuantity	 	=	Isnull(BeginQuantity,0)		- Isnull(@ConvertedQuantity,0),
					BeginAmount 		=	Isnull(BeginAmount,0)		- Isnull(@ConvertedAmount,0),
					EndQuantity		=	Isnull(EndQuantity,0)		- Isnull(@ConvertedQuantity,0),
					EndAmount		= 	Isnull(EndAmount,0)	- 	Isnull(@ConvertedAmount,0)	
			Where 		InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID  =@DebitAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear
		
		IF @CustomerName = 15
			BEGIN
				--- Cap nhat AT2888: so du ton kho theo quy cach (yeu cau cua 2T)
				If not exists (Select 1 From AT2888 Where 	InventoryID =@InventoryID and
										DivisionID =@DivisionID and
										WareHouseID =@WareHouseID and
										InventoryAccountID =@DebitAccountID and
										TranMonth =@TranMonth and
										TranYear =@TranYear AND
										Isnull(Parameter01,0) = @Parameter01 AND
										Isnull(Parameter02,0) = @Parameter02 AND
										Isnull(Parameter03,0) = @Parameter03 AND
										Isnull(Parameter04,0) = @Parameter04 AND
										Isnull(Parameter05,0) = @Parameter05)
					Insert AT2888 (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
							  InventoryAccountID,   BeginQuantity,  BeginAmount,
							 DebitQuantity,  DebitAmount,  CreditQuantity,
							CreditAmount,   EndQuantity , EndAmount,
							Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
							BeginMarkQuantity, DebitMarkQuantity, CreditMarkQuantity, EndMarkQuantity)
					Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
						@DebitAccountID, -@ConvertedQuantity, -@ConvertedAmount, 0,0, 0,0,  
						-@ConvertedQuantity, -@ConvertedAmount,
						@Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05,
						-@MarkQuantity,0,0,-@MarkQuantity)
				else
					Update AT2888
						set 	BeginQuantity	 	=	Isnull(BeginQuantity,0)		- Isnull(@ConvertedQuantity,0),
							BeginAmount 		=	Isnull(BeginAmount,0)		- Isnull(@ConvertedAmount,0),
							EndQuantity		=	Isnull(EndQuantity,0)		- Isnull(@ConvertedQuantity,0),
							EndAmount		= 	Isnull(EndAmount,0)	- 	Isnull(@ConvertedAmount,0),
							BeginMarkQuantity	=	Isnull(BeginMarkQuantity,0)		- Isnull(@MarkQuantity,0),
							EndMarkQuantity		=	Isnull(EndMarkQuantity,0)		- Isnull(@MarkQuantity,0)
					Where 		InventoryID =@InventoryID and
										DivisionID =@DivisionID and
										WareHouseID =@WareHouseID and
										InventoryAccountID  =@DebitAccountID and
										TranMonth =@TranMonth and
										TranYear =@TranYear AND
										Isnull(Parameter01,0) = @Parameter01 AND
										Isnull(Parameter02,0) = @Parameter02 AND
										Isnull(Parameter03,0) = @Parameter03 AND
										Isnull(Parameter04,0) = @Parameter04 AND
										Isnull(Parameter05,0) = @Parameter05
			END
	End
GO
