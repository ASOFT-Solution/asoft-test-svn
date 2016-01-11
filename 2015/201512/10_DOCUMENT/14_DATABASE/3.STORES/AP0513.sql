/****** Object:  StoredProcedure [dbo].[AP0513]    Script Date: 07/29/2010 08:33:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
----- Created by Nguyen Van Nhan, Date 19/03/2003
----- Cap nhat so du trong truong hop Xoa
/********************************************
'* Edited by: [GS] [Mỹ Tuyền] [29/07/2010]
'********************************************/
--- Edited by Bao Anh	Date: 05/08/2012
--- Purpose: Them quy cach va so luong mark (yeu cau cua 2T)

ALTER PROCEDURE [dbo].[AP0513]
	 @DivisionID nvarchar(50), 
	 @WareHouseID  nvarchar(50),
	 @TranMonth  int, 
	 @TranYear int, 
	 @InventoryID  nvarchar(50), 
	 @ConvertedAmount as Decimal(28,8), 
	 @ConvertedQuantity as Decimal(28,8), 
	 @DebitAccountID  nvarchar(50), 
	 @CreditAccountID  nvarchar(50), 
	 @Type as TINYINT,
	 @Parameter01 AS DECIMAL(28,8),
    	 @Parameter02 AS DECIMAL(28,8),
    	 @Parameter03 AS DECIMAL(28,8),
    	 @Parameter04 AS DECIMAL(28,8),
    	 @Parameter05 AS DECIMAL(28,8),
    	 @MarkQuantity AS DECIMAL(28,8)
 AS

DECLARE @CustomerName INT
--Tao bang tam de kiem tra day co phai la khach hang 2T khong (CustomerName = 15)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

If @Type =1	 ---- Xoa mot phieu nhap kho
	Begin
		If not exists (Select 1 From AT2008 Where 	InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID =@DebitAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear)
			Insert AT2008 (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
					  InventoryAccountID,   BeginQuantity,  BeginAmount,
					 DebitQuantity ,  DebitAmount , CreditQuantity,
					CreditAmount,  EndQuantity ,  EndAmount)
			Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
				@DebitAccountID, 0,0, -@ConvertedQuantity, -@ConvertedAmount , 0,0, 
				-@ConvertedQuantity, -@ConvertedAmount)
		else
			Begin
				Update AT2008
					set 	DebitQuantity 	=	isnull(DebitQuantity,0)	- isnull(@ConvertedQuantity,0),
						DebitAmount 	=	isnull(DebitAmount,0)	- Isnull(@ConvertedAmount,0)
						--EndQuantity		=	isnull(EndQuantity,0)		- isnull(@ConvertedQuantity,0),
						--EndAmount		=	isnull(EndAmount,0)		- isnull(@ConvertedAmount,0)	
				Where 		InventoryID =@InventoryID and
									DivisionID =@DivisionID and
									WareHouseID =@WareHouseID and
									InventoryAccountID =@DebitAccountID and
									TranMonth =@TranMonth and
									TranYear =@TranYear	

				Update AT2008
					set 	EndQuantity		=	isnull(BeginQuantity,0)	+ isnull( DebitQuantity,0) - isnull( CreditQuantity,0),
						EndAmount		=	isnull(BeginAmount,0)	+ isnull( DebitAmount,0) - isnull( CreditAmount,0)
				Where 		InventoryID =@InventoryID and
									DivisionID =@DivisionID and
									WareHouseID =@WareHouseID and
									InventoryAccountID =@DebitAccountID and
									TranMonth =@TranMonth and
									TranYear =@TranYear	
			End
		
		IF @CustomerName = 15
			BEGIN
				--- Insert AT2888: so du theo quy cach
				If not exists (Select 1 From AT2888 Where 	InventoryID =@InventoryID and
										DivisionID =@DivisionID and
										WareHouseID =@WareHouseID and
										InventoryAccountID =@DebitAccountID and
										TranMonth =@TranMonth and
										TranYear =@TranYear and
										Isnull(Parameter01,0) = @Parameter01 AND
										Isnull(Parameter02,0) = @Parameter02 AND
										Isnull(Parameter03,0) = @Parameter03 AND
										Isnull(Parameter04,0) = @Parameter04 AND
										Isnull(Parameter05,0) = @Parameter05)
					Insert AT2888 (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
							  InventoryAccountID,   BeginQuantity,  BeginAmount,
							 DebitQuantity ,  DebitAmount , CreditQuantity,
							CreditAmount,  EndQuantity ,  EndAmount, Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
							BeginMarkQuantity, DebitMarkQuantity, CreditMarkQuantity, EndMarkQuantity)
					Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
						@DebitAccountID, 0,0, -@ConvertedQuantity, -@ConvertedAmount , 0,0, 
						-@ConvertedQuantity, -@ConvertedAmount, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05,
						0,-@MarkQuantity,0,-@MarkQuantity)
				else
					Begin
						Update AT2888
							set 	DebitQuantity 	=	isnull(DebitQuantity,0)	- isnull(@ConvertedQuantity,0),
								DebitAmount 	=	isnull(DebitAmount,0)	- Isnull(@ConvertedAmount,0)
								--EndQuantity		=	isnull(EndQuantity,0)		- isnull(@ConvertedQuantity,0),
								--EndAmount		=	isnull(EndAmount,0)		- isnull(@ConvertedAmount,0)	
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
		
						Update AT2888
							set 	EndQuantity		=	isnull(BeginQuantity,0)	+ isnull( DebitQuantity,0) - isnull( CreditQuantity,0),
								EndAmount		=	isnull(BeginAmount,0)	+ isnull( DebitAmount,0) - isnull( CreditAmount,0)
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
			END
	End
  		
If @Type =0	---- Type =0, Xoa mot phieu Xuat kho
	Begin
		If not exists (Select 1 From AT2008 Where 	InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID =@CreditAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear)
			Insert AT2008 (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
					  InventoryAccountID,   BeginQuantity,  BeginAmount,
					 DebitQuantity,  DebitAmount, CreditQuantity,
					CreditAmount,  EndQuantity ,  EndAmount)
			Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
				@CreditAccountID, 0,0, 0,0,-@ConvertedQuantity, -@ConvertedAmount , 
				@ConvertedQuantity, @ConvertedAmount)

			
		else
			Begin
				Update AT2008
					set 	CreditQuantity	 	=	isnull(CreditQuantity,0)		- isnull(@ConvertedQuantity,0),
						CreditAmount 	=		isnull(CreditAmount,0)	- 	isnull(@ConvertedAmount,0)
						--EndQuantity		=	isnull(EndQuantity,0)		+ isnull(@ConvertedQuantity,0),
						--EndAmount		=	isnull(EndAmount,0)		+ isnull(@ConvertedAmount,0)	
				Where 		InventoryID =@InventoryID and
									DivisionID =@DivisionID and
									WareHouseID =@WareHouseID and
									InventoryAccountID =@CreditAccountID and
									TranMonth =@TranMonth and
									TranYear =@TranYear	

				Update AT2008
					set 	EndQuantity		=	isnull(BeginQuantity,0)	+ isnull( DebitQuantity,0) - isnull( CreditQuantity,0),
						EndAmount		=	isnull(BeginAmount,0)	+ isnull( DebitAmount,0) - isnull( CreditAmount,0)
				Where 		InventoryID =@InventoryID and
									DivisionID =@DivisionID and
									WareHouseID =@WareHouseID and
									InventoryAccountID =@CreditAccountID and
									TranMonth =@TranMonth and
									TranYear =@TranYear	
			End
	
		IF @CustomerName = 15
			BEGIN
				--- Insert AT2888: so du theo quy cach
				If not exists (Select 1 From AT2888 Where 	InventoryID =@InventoryID and
										DivisionID =@DivisionID and
										WareHouseID =@WareHouseID and
										InventoryAccountID =@CreditAccountID and
										TranMonth =@TranMonth and
										TranYear =@TranYear AND
										Isnull(Parameter01,0) = @Parameter01 AND
										Isnull(Parameter02,0) = @Parameter02 AND
										Isnull(Parameter03,0) = @Parameter03 AND
										Isnull(Parameter04,0) = @Parameter04 AND
										Isnull(Parameter05,0) = @Parameter05)
					Insert AT2888 (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
							  InventoryAccountID,   BeginQuantity,  BeginAmount,
							 DebitQuantity,  DebitAmount, CreditQuantity,
							CreditAmount,  EndQuantity ,  EndAmount,
							Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
							BeginMarkQuantity, DebitMarkQuantity, CreditMarkQuantity, EndMarkQuantity)
					Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
						@CreditAccountID, 0,0, 0,0,-@ConvertedQuantity, -@ConvertedAmount , 
						@ConvertedQuantity, @ConvertedAmount, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05,
						0,0,-@MarkQuantity,@MarkQuantity)
		
					
				else
					Begin
						Update AT2888
							set 	CreditQuantity	 	=	isnull(CreditQuantity,0)		- isnull(@ConvertedQuantity,0),
								CreditAmount 	=		isnull(CreditAmount,0)	- 	isnull(@ConvertedAmount,0),
								CreditMarkQuantity	 	=	isnull(CreditMarkQuantity,0)		- isnull(@MarkQuantity,0)
								--EndQuantity		=	isnull(EndQuantity,0)		+ isnull(@ConvertedQuantity,0),
								--EndAmount		=	isnull(EndAmount,0)		+ isnull(@ConvertedAmount,0)	
						Where 		InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID =@CreditAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear AND
								Isnull(Parameter01,0) = @Parameter01 AND
								Isnull(Parameter02,0) = @Parameter02 AND
								Isnull(Parameter03,0) = @Parameter03 AND
								Isnull(Parameter04,0) = @Parameter04 AND
								Isnull(Parameter05,0) = @Parameter05	
		
						Update AT2888
							set 	EndQuantity		=	isnull(BeginQuantity,0)	+ isnull(DebitQuantity,0) - isnull(CreditQuantity,0),
								EndAmount		=	isnull(BeginAmount,0)	+ isnull(DebitAmount,0) - isnull(CreditAmount,0),
								EndMarkQuantity		=	isnull(BeginMarkQuantity,0)	+ isnull(DebitMarkQuantity,0) - isnull(CreditMarkQuantity,0)
						Where 		InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID =@CreditAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear AND
								Isnull(Parameter01,0) = @Parameter01 AND
								Isnull(Parameter02,0) = @Parameter02 AND
								Isnull(Parameter03,0) = @Parameter03 AND
								Isnull(Parameter04,0) = @Parameter04 AND
								Isnull(Parameter05,0) = @Parameter05
					END
			END
	End

-------------------------------------------------
If @Type =11	 ---- Xoa mot phieu nhap kho Van chuyen NB
	Begin
		If not exists (Select 1 From AT2008 Where 	InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID =@DebitAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear)
			Insert AT2008 (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
					  InventoryAccountID,   BeginQuantity,  BeginAmount,
					 DebitQuantity ,  DebitAmount , CreditQuantity,
					CreditAmount,  InDebitQuantity, InDebitAmount, EndQuantity ,  EndAmount)
			Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
				@DebitAccountID, 0,0, -@ConvertedQuantity, -@ConvertedAmount , 0,0, -@ConvertedQuantity, -@ConvertedAmount,
				-@ConvertedQuantity, -@ConvertedAmount)
		else
			Begin
				Update AT2008
	
					set 	DebitQuantity 	=	isnull(DebitQuantity,0)	- isnull(@ConvertedQuantity,0),
						DebitAmount 	=	isnull(DebitAmount,0)	- Isnull(@ConvertedAmount,0),
						InDebitQuantity 	=	isnull(InDebitQuantity,0)	- isnull(@ConvertedQuantity,0),
						InDebitAmount 	=	isnull(InDebitAmount,0)	- Isnull(@ConvertedAmount,0)
						--EndQuantity		=	isnull(EndQuantity,0)		- isnull(@ConvertedQuantity,0),
						--EndAmount		=	isnull(EndAmount,0)		- isnull(@ConvertedAmount,0)
							
				Where 		InventoryID =@InventoryID and
									DivisionID =@DivisionID and
									WareHouseID =@WareHouseID and
									InventoryAccountID =@DebitAccountID and
									TranMonth =@TranMonth and
									TranYear =@TranYear	
				Update AT2008
	
					set 	EndQuantity		=	isnull(BeginQuantity,0)	+ isnull( DebitQuantity,0) - isnull( CreditQuantity,0),
						EndAmount		=	isnull(BeginAmount,0)	+ isnull( DebitAmount,0) - isnull( CreditAmount,0)
							
				Where 		InventoryID =@InventoryID and
									DivisionID =@DivisionID and
									WareHouseID =@WareHouseID and
									InventoryAccountID =@DebitAccountID and
									TranMonth =@TranMonth and
									TranYear =@TranYear	

			End
	
		IF @CustomerName = 15
			BEgin
				--- Insert AT2888: so du theo quy cach
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
							 DebitQuantity ,  DebitAmount , CreditQuantity,
							CreditAmount,  InDebitQuantity, InDebitAmount, EndQuantity ,  EndAmount,
							Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
							BeginMarkQuantity, DebitMarkQuantity, CreditMarkQuantity, InDebitMarkQuantity,InCreditMarkQuantity, EndMarkQuantity)
					Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
						@DebitAccountID, 0,0, -@ConvertedQuantity, -@ConvertedAmount , 0,0, -@ConvertedQuantity, -@ConvertedAmount,
						-@ConvertedQuantity, -@ConvertedAmount, @Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05,
						0,-@MarkQuantity,0,-@MarkQuantity,0,-@MarkQuantity)
				else
					Begin
						Update AT2888
			
							set 	DebitQuantity 	=	isnull(DebitQuantity,0)	- isnull(@ConvertedQuantity,0),
								DebitAmount 	=	isnull(DebitAmount,0)	- Isnull(@ConvertedAmount,0),
								InDebitQuantity 	=	isnull(InDebitQuantity,0)	- isnull(@ConvertedQuantity,0),
								InDebitAmount 	=	isnull(InDebitAmount,0)	- Isnull(@ConvertedAmount,0),
								DebitMarkQuantity 	=	isnull(DebitMarkQuantity,0)	- isnull(@MarkQuantity,0),
								InDebitMarkQuantity 	=	isnull(InDebitMarkQuantity,0)	- isnull(@MarkQuantity,0)
								--EndQuantity		=	isnull(EndQuantity,0)		- isnull(@ConvertedQuantity,0),
								--EndAmount		=	isnull(EndAmount,0)		- isnull(@ConvertedAmount,0)
									
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
						Update AT2888
			
							set 	EndQuantity		=	isnull(BeginQuantity,0)	+ isnull(DebitQuantity,0) - isnull(CreditQuantity,0),
								EndAmount		=	isnull(BeginAmount,0)	+ isnull(DebitAmount,0) - isnull(CreditAmount,0),
								EndMarkQuantity		=	isnull(BeginMarkQuantity,0)	+ isnull(DebitMarkQuantity,0) - isnull(CreditMarkQuantity,0)
									
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
			END
	End

	---- Type =0, Xoa mot phieu Xuat kho
If @Type = 10 
	Begin
		If not exists (Select 1 From AT2008 Where 	InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID =@CreditAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear)
			Insert AT2008 (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
					  InventoryAccountID,   BeginQuantity,  BeginAmount,
					 DebitQuantity,  DebitAmount, CreditQuantity,
					CreditAmount, InCreditQuantity, InCreditAmount,  EndQuantity ,  EndAmount)
			Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
				@CreditAccountID, 0,0, 0,0,-@ConvertedQuantity, -@ConvertedAmount , 
				-@ConvertedQuantity, -@ConvertedQuantity,  @ConvertedQuantity, @ConvertedAmount)

			
		else
			Begin
				Update AT2008
					set 	CreditQuantity	 	=		isnull( CreditQuantity,0)		- isnull(@ConvertedQuantity,0),
						CreditAmount 		=		isnull( CreditAmount,0)	- 	isnull(@ConvertedAmount,0),
						InCreditQuantity	 	=		isnull( InCreditQuantity,0)		- isnull(@ConvertedQuantity,0),
						InCreditAmount 		=		isnull( InCreditAmount,0)	- 	isnull(@ConvertedAmount,0)
						--EndQuantity		=		isnull( EndQuantity,0)		+ isnull(@ConvertedQuantity,0),
						--EndAmount		=		isnull( EndAmount,0)		+ isnull(@ConvertedAmount,0)	
				Where 		InventoryID =@InventoryID and
									DivisionID =@DivisionID and
									WareHouseID =@WareHouseID and
									InventoryAccountID =@CreditAccountID and
									TranMonth =@TranMonth and
									TranYear =@TranYear	

				Update AT2008
					set 	EndQuantity		=	isnull(BeginQuantity,0)	+ isnull( DebitQuantity,0) - isnull( CreditQuantity,0),
						EndAmount		=	isnull(BeginAmount,0)	+ isnull( DebitAmount,0) - isnull( CreditAmount,0)
				Where 		InventoryID =@InventoryID and
									DivisionID =@DivisionID and
									WareHouseID =@WareHouseID and
									InventoryAccountID =@CreditAccountID and
									TranMonth =@TranMonth and
									TranYear =@TranYear	
			End
	
		IF @CustomerName = 15
			BEGIN
				--- Insert AT2888: so du theo quy cach
				If not exists (Select 1 From AT2888 Where 	InventoryID =@InventoryID and
										DivisionID =@DivisionID and
										WareHouseID =@WareHouseID and
										InventoryAccountID =@CreditAccountID and
										TranMonth =@TranMonth and
										TranYear =@TranYear AND
										Isnull(Parameter01,0) = @Parameter01 AND
										Isnull(Parameter02,0) = @Parameter02 AND
										Isnull(Parameter03,0) = @Parameter03 AND
										Isnull(Parameter04,0) = @Parameter04 AND
										Isnull(Parameter05,0) = @Parameter05)
					Insert AT2888 (InventoryID, WareHouseID,TranMonth,TranYear, DivisionID,
							  InventoryAccountID,   BeginQuantity,  BeginAmount,
							 DebitQuantity,  DebitAmount, CreditQuantity,
							CreditAmount, InCreditQuantity, InCreditAmount,  EndQuantity ,  EndAmount,
							Parameter01, Parameter02, Parameter03, Parameter04, Parameter05,
							BeginMarkQuantity, DebitMarkQuantity, CreditMarkQuantity, InDebitMarkQuantity,InCreditMarkQuantity, EndMarkQuantity)
					Values	(@InventoryID, @WareHouseID, @TranMonth, @TranYear, @DivisionID,
						@CreditAccountID, 0,0, 0,0,-@ConvertedQuantity, -@ConvertedAmount , 
						-@ConvertedQuantity, -@ConvertedQuantity,  @ConvertedQuantity, @ConvertedAmount,
						@Parameter01, @Parameter02, @Parameter03, @Parameter04, @Parameter05,
						0,0,-@MarkQuantity,0,-@MarkQuantity,@MarkQuantity)
		
					
				else
					Begin
						Update AT2888
							set 	CreditQuantity	 	=		isnull(CreditQuantity,0)		- isnull(@ConvertedQuantity,0),
								CreditAmount 		=		isnull(CreditAmount,0)	- 	isnull(@ConvertedAmount,0),
								InCreditQuantity	 	=		isnull( InCreditQuantity,0)		- isnull(@ConvertedQuantity,0),
								InCreditAmount 		=		isnull(InCreditAmount,0)	- 	isnull(@ConvertedAmount,0),
								CreditMarkQuantity	=		isnull(CreditMarkQuantity,0)		- isnull(@MarkQuantity,0),
								InCreditMarkQuantity	=		isnull(InCreditMarkQuantity,0)		- isnull(@MarkQuantity,0)
								--EndQuantity		=		isnull(EndQuantity,0)		+ isnull(@ConvertedQuantity,0),
								--EndAmount		=		isnull(EndAmount,0)		+ isnull(@ConvertedAmount,0)	
						Where 		InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID =@CreditAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear AND
								Isnull(Parameter01,0) = @Parameter01 AND
								Isnull(Parameter02,0) = @Parameter02 AND
								Isnull(Parameter03,0) = @Parameter03 AND
								Isnull(Parameter04,0) = @Parameter04 AND
								Isnull(Parameter05,0) = @Parameter05
		
						Update AT2888
							set 	EndQuantity		=	isnull(BeginQuantity,0)	+ isnull(DebitQuantity,0) - isnull(CreditQuantity,0),
								EndAmount		=	isnull(BeginAmount,0)	+ isnull(DebitAmount,0) - isnull(CreditAmount,0),
								EndMarkQuantity		=	isnull(BeginMarkQuantity,0)	+ isnull(DebitMarkQuantity,0) - isnull(CreditMarkQuantity,0)
						Where 		InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID =@CreditAccountID and
								TranMonth =@TranMonth and
								TranYear =@TranYear AND
								Isnull(Parameter01,0) = @Parameter01 AND
								Isnull(Parameter02,0) = @Parameter02 AND
								Isnull(Parameter03,0) = @Parameter03 AND
								Isnull(Parameter04,0) = @Parameter04 AND
								Isnull(Parameter05,0) = @Parameter05
											
					END
			END	
	End