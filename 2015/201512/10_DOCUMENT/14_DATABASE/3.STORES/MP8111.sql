IF EXISTS (SELECT TOP 1 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[DBO].[MP8111]') AND OBJECTPROPERTY(ID, N'IsProcedure') = 1)
DROP PROCEDURE [DBO].[MP8111]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Created by Hoang Thi Lan
--Date 28/11/2003
--Purpose:	Cap nhat ket qua san xuat do dang va gia thanh
--Edit by: Dang Le Bao Quynh; Date 01/06/2007
--Purpose: Sua lai cach cap nhat don gia thanh tien
---- Modify on 11/06/2014 by Bảo Anh: Group by thêm PerfectRate vì có trường hợp 1 mặt hàng nhiều TLHT
---- Modified on 13/08/2014 by Le Thi Thu Hien : Bo sung them ProductQuantity sua lai cho truong hop la PerfectRate của 2 dòng giống nhau
/********************************************
'* Edited by: [GS] [Hoàng Phước] [02/08/2010]
'********************************************/
--EXEC MP8111 'TBI' , 'gd2072014'
CREATE PROCEDURE [dbo].[MP8111] 	
(
				@DivisionID AS nvarchar(50),
				@PeriodID AS  nvarchar(50)
)

 AS
DECLARE @sSQL  AS nvarchar(4000),
		@ListMaterial_cur AS cursor,
		@ProductID AS nvarchar(50),
		@CostUnit AS decimal(28,8),
		@Summ AS decimal(28,8),
		@PerfectRate AS decimal(28,8),
		@ProductQuantity AS DECIMAL(28,8)
	
Set @ListMaterial_cur  = Cursor Scroll KeySet FOR 

SELECT	ProductID,PerfectRate,Sum(ConvertedAmount) As Summ, ProductQuantity
FROM	MT1613
WHERE 	DivisionID = @DivisionID 
		AND	PeriodID = @PeriodID
		AND Type = 'E'
GROUP BY ProductID,PerfectRate, ProductQuantity


Open @ListMaterial_cur 
		FETCH NEXT FROM @ListMaterial_cur INTO  @ProductID ,@PerfectRate, @Summ, @ProductQuantity
		WHILE @@Fetch_Status = 0
			Begin	
				--Rem by: Dang Le Bao Quynh; Date 01/06/2007
				--Note: Lam store het suc cau tha, khong quan tam va cung khong chiu test
				/*
				Update MT1001
				Set  MT1001.Price = @Summ,
				      MT1001.OriginalAmount = MT1001.Quantity*@Summ, 
		  		     MT1001.ConvertedAmount  = @Summ
				*/

			UPDATE	MT1001
			SET		MT1001.OriginalAmount = @Summ/@ProductQuantity*Quantity , 
					MT1001.ConvertedAmount  = @Summ/@ProductQuantity*Quantity,
					MT1001.Price = case when isnull(MT1001.Quantity,0) = 0 then 0 else @Summ/@ProductQuantity End
				
			FROM	MT1001 
			INNER JOIN MT0810 on MT0810.VoucherID =MT1001.VoucherID
			Where	MT0810.DivisionID= @DivisionID 
					and MT0810.PeriodID =@PeriodID 
					and MT1001.ProductID = @ProductID 
					and MT0810.ResultTypeID = 'R03' 
					and MT1001.PerfectRate = @PerfectRate

		FETCH NEXT FROM @ListMaterial_cur INTO   @ProductID ,@PerfectRate, @Summ, @ProductQuantity
		End
		Close @ListMaterial_cur

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

