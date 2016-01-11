IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP2019]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP2019]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----- Customize index = 43 (SECOIN)
----- Created by: Phan thanh Hoàng Vũ, date: 03/08/2015
----- Purpose: Update trạng thái hoàn tất/ chưa hoàn tất khi kế thứa hết số lượng hoặc chưa hết số lượng màn hết hình kết quả sản xuất với phiếu giao việc
----- Exec MP2019 'AS','5c6516f1-07d2-4d4b-99c7-a1b606a648ac'

CREATE PROCEDURE [dbo].[MP2019] 	
				@DivisionID nvarchar(50),
				@VoucherID nvarchar(50) --VoucherID: của phiếu giao việc vừa kế thừa
				

AS

IF EXISTS (SELECT TOP 1 1 FROM sysobjects WHERE NAME='MT2007' AND xtype='U')
	BEGIN
		IF NOT EXISTS (Select TOP 1 1 From MT2007 M Inner join MT2008 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID
									  left join (Select Sum(Isnull(D.Quantity,0)) as InheritQuantity
														, Sum(Isnull(D.ConvertedQuantity,0)) as InheritConvertedQuantity
													   , D.InheritVoucherID, D.InheritTransactionID, M.DivisionID
												 From MT0810 M Inner join MT1001 D on M.DivisionID = D.DivisionID and M.VoucherID = D.VoucherID
												 Where (IsPhase = 1 and IsJob = 1) or (IsPhase = 2 and IsJob = 1)
												 Group by D.InheritVoucherID, D.InheritTransactionID, M.DivisionID
												) C on D.VoucherID = C.InheritVoucherID and D.TransactionID = C.InheritTransactionID
														and D.DivisionID = C.DivisionID
						Where  (
								Isnull(D.Quantity,0) - Isnull(C.InheritQuantity,0)>0  
								or Isnull(D.ConvertedQuantity,0) - Isnull(C.InheritConvertedQuantity,0)>0
								)
								and M.DivisionID = @DivisionID and M.VoucherID = @VoucherID
					   )

		UPDATE MT2007 SET OrderStatus = 1 Where DivisionID = @DivisionID and VoucherID = @VoucherID
		Else
		UPDATE MT2007 SET OrderStatus = 0 Where DivisionID = @DivisionID and VoucherID = @VoucherID
	END