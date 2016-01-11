IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[AP0600]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[AP0600]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---Created by  Nguyen Van Nhan
--- Created Date 02/09/2004
--- Purpose cap nhat so du cho cac kho
--- Edit by: Dang Le Bao Quynh; Date 16/04/2008
--- Purpose: Thay doi cach tinh gia tri ton cuoi
--- Edit by: Dang Le Bao Quynh; Date 31/07/2008
--- Purpose: Thay doi cach tinh gia tri ton cuoi
--Edit by: Dang Le Bao Quynh; Date: 16/01/2009
--Purpose: Bo sung truong hop xuat hang mua tra lai
--Edit by: Nguyen Quoc Huy, Date: 06.08.2009
/********************************************
'* Edited by: [GS] [Thanh Nguyen] [29/07/2010]
'********************************************/
--- Edited by Bao Anh	Date: 05/08/2012
--- Purpose: Them quy cach va so luong mark (yeu cau cua 2T)
--- Edited by Mai Duyen,Date 14/01/2014
--- Purpose:Sua loi khong tinh duoc gia cac phieu VCNB->Xuat ra ngoai(KH Phuc Long),Rem phan cap nhat DebitAmount,InDebitAmount doi voi kho nhap cua phieu VCNB(@KindVoucherID =3 )
----- Modified on 25/02/2014 by Le Thi Thu Hien : Cap nhat DebitAmount,InDebitAmount doi voi kho nhap cua phieu VCNB

CREATE PROCEDURE [dbo].[AP0600] 	
				@KindVoucherID as tinyint, @DivisionID varchar(50), @TranMonth int, @TranYear int,
				@WareHouseID nvarchar(50), @WareHouseID2 nvarchar(50), @InventoryID as nvarchar(50),
				@DebitAccountID_Old nvarchar(50),  @CreditAccountID_Old nvarchar(50),  @DebitAccountID_New nvarchar(50), @CreditAccountID_New nvarchar(50), 
				@OldQuantity decimal(28, 8), @NewQuantity decimal(28, 8), @OldConvertedAmount decimal(28, 8), @NewConvertedAmount decimal(28, 8),
				@Parameter01 AS DECIMAL(28,8), @Parameter02 AS DECIMAL(28,8), @Parameter03 AS DECIMAL(28,8), @Parameter04 AS DECIMAL(28,8), @Parameter05 AS DECIMAL(28,8),
				@OldMarkQuantity AS DECIMAL(28,8), @NewMarkQuantity AS DECIMAL(28,8)
AS

DECLARE @CustomerName INT
--Tao bang tam de kiem tra day co phai la khach hang 2T khong (CustomerName = 15)
CREATE Table #CustomerName (CustomerName INT, ImportExcel int)
INSERT #CustomerName EXEC AP4444
SET @CustomerName = (SELECT TOP 1 CustomerName FROM #CustomerName)

----------------------============================================----------------------------------------------------
--Print ' Kind: '+str(@KindVoucherID)+' New :' +@CreditAccountID_Old+'  ' +@CreditAccountID_New
If @KindVoucherID in (1,5,7,9,15,17) --- truong hop nhap kho
	 Begin
		If @DebitAccountID_Old = @DebitAccountID_New
		  	Begin	
		   		Update AT2008		
				Set 	DebitQuantity 	=	isnull(DebitQuantity,0)	- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
					DebitAmount 	=	isnull(DebitAmount,0)	- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) 
					--EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0),  --EndQuantity		=	isnull(EndQuantity,0)		- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
					--EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) --EndAmount		=	isnull(EndAmount,0)		- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) 
		 		Where 	InventoryID =@InventoryID and
					DivisionID =@DivisionID and
					WareHouseID =@WareHouseID and
					InventoryAccountID = @DebitAccountID_New  and
					TranMonth =@TranMonth and
					TranYear =@TranYear					

				Update AT2008		
				Set 	EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0),
					EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) 
		 		Where 	InventoryID =@InventoryID and
					DivisionID =@DivisionID and
					WareHouseID =@WareHouseID and
					InventoryAccountID = @DebitAccountID_New  and
					TranMonth =@TranMonth and
					TranYear =@TranYear
				
				IF @CustomerName = 15
					BEGIN
						--- Insert AT2888: so du theo quy cach
						Update AT2888		
						Set 	DebitQuantity 	=	isnull(DebitQuantity,0)	- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
							DebitAmount 	=	isnull(DebitAmount,0)	- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) ,
							DebitMarkQuantity 	=	isnull(DebitMarkQuantity,0)	- isnull(@OldMarkQuantity,0) +  isnull(@NewMarkQuantity,0)
							--EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0),  --EndQuantity		=	isnull(EndQuantity,0)		- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
							--EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) --EndAmount		=	isnull(EndAmount,0)		- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) 
				 		Where 	InventoryID =@InventoryID and
							DivisionID =@DivisionID and
							WareHouseID =@WareHouseID and
							InventoryAccountID = @DebitAccountID_New  and
							TranMonth =@TranMonth and
							TranYear =@TranYear AND
							Isnull(Parameter01,0) = @Parameter01 AND
							Isnull(Parameter02,0) = @Parameter02 AND
							Isnull(Parameter03,0) = @Parameter03 AND
							Isnull(Parameter04,0) = @Parameter04 AND
							Isnull(Parameter05,0) = @Parameter05				
		
						Update AT2888		
						Set 	EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0),
							EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0),
							EndMarkQuantity		=	isnull(BeginMarkQuantity,0) + isnull(DebitMarkQuantity,0) - isnull(CreditMarkQuantity,0)
				 		Where 	InventoryID =@InventoryID and
							DivisionID =@DivisionID and
							WareHouseID =@WareHouseID and
							InventoryAccountID = @DebitAccountID_New  and
							TranMonth =@TranMonth and
							TranYear =@TranYear AND
							Isnull(Parameter01,0) = @Parameter01 AND
							Isnull(Parameter02,0) = @Parameter02 AND
							Isnull(Parameter03,0) = @Parameter03 AND
							Isnull(Parameter04,0) = @Parameter04 AND
							Isnull(Parameter05,0) = @Parameter05
					END
                        End
		Else
		   Begin
			
			Exec AP0513 @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @OldConvertedAmount, @OldQuantity, @DebitAccountID_Old , @CreditAccountID_Old, 1, @Parameter01,@Parameter02,@Parameter03,@Parameter04,@Parameter05, @OldMarkQuantity -- (1) la cap nhat tang,(0 ) la cap nhat giam
			Exec AP0512 @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @NewConvertedAmount, @NewQuantity, @DebitAccountID_New , @CreditAccountID_New, 1, @Parameter01,@Parameter02,@Parameter03,@Parameter04,@Parameter05, @NewMarkQuantity -- (1) la cap nhat tang,(0 ) la cap nhat giam
		   End
 	End --- Of Nhap kho
----------------------============================================----------------------------------------------------
	If @KindVoucherID in (2,4,6,8,10,14,20) --- truong hop Xuat kho
		Begin
		   	 If @CreditAccountID_Old = @CreditAccountID_New
				Begin
					Update AT2008			 
						Set 	CreditQuantity 	=		isnull(CreditQuantity,0)	- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
							CreditAmount 	=		isnull(CreditAmount,0)	- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) 
							--EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0),  --isnull(EndQuantity,0)	+ isnull(@OldQuantity,0) -  isnull(@NewQuantity,0),
							--EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) --isnull(EndAmount,0)		+ Isnull(@OldConvertedAmount,0) - Isnull(@NewConvertedAmount,0) 
					 Where 		InventoryID =@InventoryID and
							DivisionID =@DivisionID and
							WareHouseID =@WareHouseID and
							InventoryAccountID = @CreditAccountID_New and
							TranMonth =@TranMonth and
							TranYear =@TranYear
					Update AT2008		
						Set 	EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0),
							EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) 
				 		Where 	InventoryID =@InventoryID and
							DivisionID =@DivisionID and
							WareHouseID =@WareHouseID and
							InventoryAccountID = @CreditAccountID_New  and
							TranMonth =@TranMonth and
							TranYear =@TranYear
					
					IF @CustomerName = 15
						BEGIN
							--- Insert AT2888: so du theo quy cach
							Update AT2888			 
								Set 	CreditQuantity 	=		isnull(CreditQuantity,0)	- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
									CreditAmount 	=		isnull(CreditAmount,0)	- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0),
									CreditMarkQuantity 	=		isnull(CreditMarkQuantity,0)	- isnull(@OldMarkQuantity,0) +  isnull(@NewMarkQuantity,0)
									--EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0),  --isnull(EndQuantity,0)	+ isnull(@OldQuantity,0) -  isnull(@NewQuantity,0),
									--EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) --isnull(EndAmount,0)		+ Isnull(@OldConvertedAmount,0) - Isnull(@NewConvertedAmount,0) 
							 Where 		InventoryID =@InventoryID and
									DivisionID =@DivisionID and
									WareHouseID =@WareHouseID and
									InventoryAccountID = @CreditAccountID_New and
									TranMonth =@TranMonth and
									TranYear =@TranYear AND
									Isnull(Parameter01,0) = @Parameter01 AND
									Isnull(Parameter02,0) = @Parameter02 AND
									Isnull(Parameter03,0) = @Parameter03 AND
									Isnull(Parameter04,0) = @Parameter04 AND
									Isnull(Parameter05,0) = @Parameter05
							Update AT2888		
								Set 	EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0),
									EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0),
									EndMarkQuantity		=	isnull(BeginMarkQuantity,0) + isnull(DebitMarkQuantity,0) - isnull(CreditMarkQuantity,0)
						 		Where 	InventoryID =@InventoryID and
									DivisionID =@DivisionID and
									WareHouseID =@WareHouseID and
									InventoryAccountID = @CreditAccountID_New  and
									TranMonth =@TranMonth and
									TranYear =@TranYear AND
									Isnull(Parameter01,0) = @Parameter01 AND
									Isnull(Parameter02,0) = @Parameter02 AND
									Isnull(Parameter03,0) = @Parameter03 AND
									Isnull(Parameter04,0) = @Parameter04 AND
									Isnull(Parameter05,0) = @Parameter05
						END
				End
			Else
				Begin
					Exec AP0513 @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @OldConvertedAmount, @OldQuantity, @DebitAccountID_Old , @CreditAccountID_Old, 0, @Parameter01,@Parameter02,@Parameter03,@Parameter04,@Parameter05, @OldMarkQuantity -- (1) la cap nhat tang,(0 ) la cap nhat giam
					Exec AP0512 @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @NewConvertedAmount, @NewQuantity, @DebitAccountID_New , @CreditAccountID_New, 0, @Parameter01,@Parameter02,@Parameter03,@Parameter04,@Parameter05, @NewMarkQuantity -- (1) la cap nhat tang,(0 ) la cap nhat giam
				End

		  End --- Of Xuat kho
----------------------============================================----------------------------------------------------
		if @KindVoucherID =3  --- Nhap VCNB
			Begin
				---- Kho nhap
			      IF 	@DebitAccountID_Old = @DebitAccountID_New
				Begin
					Update AT2008		
					Set DebitQuantity 	=	isnull(DebitQuantity,0)	- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
						DebitAmount 	=	isnull(DebitAmount,0)	- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) ,--Date 14/01/2014
						InDebitQuantity  = 	isnull(InDebitQuantity,0)	- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
						InDebitAmount 	=	isnull(InDebitAmount,0)	- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) --Date 14/01/2014
						--EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0), -- EndQuantity		=	isnull(EndQuantity,0)		- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
						--EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) --EndAmount		=	isnull(EndAmount,0)		- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) 
					 Where 		InventoryID =@InventoryID and
							DivisionID =@DivisionID and
							WareHouseID =@WareHouseID and
							InventoryAccountID = @DebitAccountID_New and
							TranMonth =@TranMonth and
							TranYear =@TranYear
					Update AT2008		
					Set 	EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0),
						EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) 
			 		Where 	InventoryID =@InventoryID and
						DivisionID =@DivisionID and
						WareHouseID =@WareHouseID and
						InventoryAccountID = @DebitAccountID_New  and
						TranMonth =@TranMonth and
						TranYear =@TranYear
					
					IF @CustomerName = 15
						BEGIN
							--- Insert AT2888: so du theo quy cach
							Update AT2888		
							Set DebitQuantity 	=	isnull(DebitQuantity,0)	- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
								DebitAmount 	=	isnull(DebitAmount,0)	- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) ,
								InDebitQuantity  = 	isnull(InDebitQuantity,0)	- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
								InDebitAmount 	=	isnull(InDebitAmount,0)	- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0),
								DebitMarkQuantity 	=	isnull(DebitMarkQuantity,0)	- isnull(@OldMarkQuantity,0) +  isnull(@NewMarkQuantity,0),
								InDebitMarkQuantity  = 	isnull(InDebitMarkQuantity,0)	- isnull(@OldMarkQuantity,0) +  isnull(@NewMarkQuantity,0)
								--EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0), -- EndQuantity		=	isnull(EndQuantity,0)		- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
								--EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) --EndAmount		=	isnull(EndAmount,0)		- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) 
							 Where 		InventoryID =@InventoryID and
									DivisionID =@DivisionID and
									WareHouseID =@WareHouseID and
									InventoryAccountID = @DebitAccountID_New and
									TranMonth =@TranMonth and
									TranYear =@TranYear AND
									Isnull(Parameter01,0) = @Parameter01 AND
									Isnull(Parameter02,0) = @Parameter02 AND
									Isnull(Parameter03,0) = @Parameter03 AND
									Isnull(Parameter04,0) = @Parameter04 AND
									Isnull(Parameter05,0) = @Parameter05
									
							Update AT2888		
							Set EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0),
								EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0),
								EndMarkQuantity		=	isnull(BeginMarkQuantity,0) + isnull(DebitMarkQuantity,0) - isnull(CreditMarkQuantity,0)
					 		Where 	InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID and
								InventoryAccountID = @DebitAccountID_New  and
								TranMonth =@TranMonth and
								TranYear =@TranYear AND
								Isnull(Parameter01,0) = @Parameter01 AND
								Isnull(Parameter02,0) = @Parameter02 AND
								Isnull(Parameter03,0) = @Parameter03 AND
								Isnull(Parameter04,0) = @Parameter04 AND
								Isnull(Parameter05,0) = @Parameter05
						END
				End
			   ELSE	
				Begin
					Exec AP0513 @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @OldConvertedAmount, @OldQuantity, @DebitAccountID_Old , @CreditAccountID_Old, 11, @Parameter01,@Parameter02,@Parameter03,@Parameter04,@Parameter05, @OldMarkQuantity -- (1) la cap nhat tang,(0 ) la cap nhat giam; 11 la cho VCNB
					Exec AP0512 @DivisionID, @WareHouseID, @TranMonth, @TranYear, @InventoryID, @NewConvertedAmount, @NewQuantity, @DebitAccountID_New , @CreditAccountID_New, 11,@Parameter01,@Parameter02,@Parameter03,@Parameter04,@Parameter05, @NewMarkQuantity -- (1) la cap nhat tang,(0 ) la cap nhat giam
				End
			
				---- Kho Xuat
				If @CreditAccountID_New = @CreditAccountID_Old
					Begin
						Update AT2008		
						Set CreditQuantity 	=	isnull(CreditQuantity,0)	- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
							CreditAmount 	=	isnull(CreditAmount,0)	- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) ,
							InCreditQuantity  = 	isnull(InCreditQuantity,0)	- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
							InCreditAmount 	=	isnull(InCreditAmount,0)	- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) 
							--EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0), --EndQuantity		=	isnull(EndQuantity,0)		+ isnull(@OldQuantity,0) -  isnull(@NewQuantity,0),
							--EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) --EndAmount		=	isnull(EndAmount,0)		+ Isnull(@OldConvertedAmount,0) - Isnull(@NewConvertedAmount,0) 
						 Where 		InventoryID =@InventoryID and
								DivisionID =@DivisionID and
								WareHouseID =@WareHouseID2 and
								InventoryAccountID =@CreditAccountID_New and
								TranMonth =@TranMonth and
								TranYear =@TranYear
						Update AT2008		
						Set 	EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0),
							EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) 
				 		Where 	InventoryID =@InventoryID and
							DivisionID =@DivisionID and
							WareHouseID =@WareHouseID2 and
							InventoryAccountID = @CreditAccountID_New  and
							TranMonth =@TranMonth and
							TranYear =@TranYear
						
						IF @CustomerName = 15
							BEGIN
								--- Insert AT2888: so du theo quy cach
								Update AT2888		
								Set CreditQuantity 	=	isnull(CreditQuantity,0)	- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
									CreditAmount 	=	isnull(CreditAmount,0)	- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0) ,
									InCreditQuantity  = 	isnull(InCreditQuantity,0)	- isnull(@OldQuantity,0) +  isnull(@NewQuantity,0),
									InCreditAmount 	=	isnull(InCreditAmount,0)	- Isnull(@OldConvertedAmount,0) + Isnull(@NewConvertedAmount,0),
									CreditMarkQuantity 	=	isnull(CreditMarkQuantity,0)	- isnull(@OldMarkQuantity,0) +  isnull(@NewMarkQuantity,0),
									InCreditMarkQuantity  = 	isnull(InCreditMarkQuantity,0)	- isnull(@OldMarkQuantity,0) +  isnull(@NewMarkQuantity,0)
									--EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0), --EndQuantity		=	isnull(EndQuantity,0)		+ isnull(@OldQuantity,0) -  isnull(@NewQuantity,0),
									--EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0) --EndAmount		=	isnull(EndAmount,0)		+ Isnull(@OldConvertedAmount,0) - Isnull(@NewConvertedAmount,0) 
								 Where 		InventoryID =@InventoryID and
										DivisionID =@DivisionID and
										WareHouseID =@WareHouseID2 and
										InventoryAccountID =@CreditAccountID_New and
										TranMonth =@TranMonth and
										TranYear =@TranYear AND
										Isnull(Parameter01,0) = @Parameter01 AND
										Isnull(Parameter02,0) = @Parameter02 AND
										Isnull(Parameter03,0) = @Parameter03 AND
										Isnull(Parameter04,0) = @Parameter04 AND
										Isnull(Parameter05,0) = @Parameter05
										
								Update AT2888		
								Set 	EndQuantity		=	isnull(BeginQuantity,0) + isnull(DebitQuantity,0) - isnull(CreditQuantity,0),
									EndAmount		=	isnull(BeginAmount,0) + isnull(DebitAmount,0) - isnull(CreditAmount,0),
									EndMarkQuantity		=	isnull(BeginMarkQuantity,0) + isnull(DebitMarkQuantity,0) - isnull(CreditMarkQuantity,0)
						 		Where 	InventoryID =@InventoryID and
									DivisionID =@DivisionID and
									WareHouseID =@WareHouseID2 and
									InventoryAccountID = @CreditAccountID_New  and
									TranMonth =@TranMonth and
									TranYear =@TranYear AND
									Isnull(Parameter01,0) = @Parameter01 AND
									Isnull(Parameter02,0) = @Parameter02 AND
									Isnull(Parameter03,0) = @Parameter03 AND
									Isnull(Parameter04,0) = @Parameter04 AND
									Isnull(Parameter05,0) = @Parameter05
							END
					End
				Else

				Begin
					Exec AP0513 @DivisionID, @WareHouseID2, @TranMonth, @TranYear, @InventoryID, @OldConvertedAmount, @OldQuantity, @DebitAccountID_Old , @CreditAccountID_Old, 10, @Parameter01,@Parameter02,@Parameter03,@Parameter04,@Parameter05, @OldMarkQuantity -- (1) la cap nhat tang,(0 ) la cap nhat giam; 10 la cho VCNB
					Exec AP0512 @DivisionID, @WareHouseID2, @TranMonth, @TranYear, @InventoryID, @NewConvertedAmount, @NewQuantity, @DebitAccountID_New , @CreditAccountID_New, 10, @Parameter01,@Parameter02,@Parameter03,@Parameter04,@Parameter05, @NewMarkQuantity -- (1) la cap nhat tang,(0 ) la cap nhat giam

				End
			End

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

